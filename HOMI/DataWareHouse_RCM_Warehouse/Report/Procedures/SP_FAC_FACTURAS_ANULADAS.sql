-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_FAC_FACTURAS_ANULADAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.SP_FAC_FACTURAS_ANULADAS
    @FechaInicial date,
    @FechaFinal   date
AS
BEGIN
    SET NOCOUNT ON;

    /*  Rango de fechas: half-open
        >= @FechaInicial  AND  < DATEADD(day, 1, @FechaFinal)
        Así no se “pierden” registros del último día por tema de horas en datetime.
    */

    ;WITH CTE_INGRESOS_ANULADOS AS (
        SELECT DISTINCT FAC.AdmissionNumber
        FROM [INDIGO036].[Billing].[Invoice] AS FAC
        WHERE FAC.Status = 2
          AND FAC.AnnulmentDate >= @FechaInicial
          AND FAC.AnnulmentDate <  DATEADD(day, 1, @FechaFinal)
    ),
    CTE_FACTURAS_ANULADAS AS (
        SELECT DISTINCT
            FAC.Id,
            FAC.AdmissionNumber,
            FAC.PatientCode,
            FAC.InvoiceNumber,
            FAC.TotalInvoice,
            FAC.InvoiceDate,
            FAC.ReversalReasonId,
            FAC.AnnulmentDate,
            FAC.DescriptionReversal,
            PAC.IPNOMCOMP,
            HA.Name,
            USU.NOMUSUARI AS [USUARIO FACTURO],
            USUA.NOMUSUARI AS [USUARIO ANULO],
            FAC.InvoiceCategoryId
        FROM [INDIGO036].[Billing].[Invoice] FAC
        INNER JOIN CTE_INGRESOS_ANULADOS AS ANU 
                ON FAC.AdmissionNumber = ANU.AdmissionNumber
        INNER JOIN [INDIGO036].[dbo].[INPACIENT] AS PAC 
                ON PAC.IPCODPACI = FAC.PatientCode
        INNER JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
                ON HA.Id = FAC.HealthAdministratorId
        INNER JOIN [INDIGO036].[dbo].[SEGusuaru] AS USU 
                ON USU.CODUSUARI = FAC.InvoicedUser
        INNER JOIN [INDIGO036].[dbo].[SEGusuaru] AS USUA 
                ON USUA.CODUSUARI = FAC.AnnulmentUser
        WHERE FAC.Status = 2
          AND FAC.AnnulmentDate >= @FechaInicial
          AND FAC.AnnulmentDate <  DATEADD(day, 1, @FechaFinal)
    ),
    CTE_FACTURAS_SIN_ANULAR AS (
        SELECT FAC.*
        FROM [INDIGO036].[Billing].[Invoice] AS FAC
        INNER JOIN CTE_INGRESOS_ANULADOS AS ANU 
                ON FAC.AdmissionNumber = ANU.AdmissionNumber
        WHERE FAC.Status = 1
    ),
    CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO AS (
        SELECT
            FAC.AdmissionNumber,
            FAC.PatientCode,
            FAC.InvoiceNumber,
            FAC.TotalInvoice,
            FAC.InvoiceDate
        FROM [INDIGO036].[Billing].[Invoice] AS FAC
        INNER JOIN CTE_INGRESOS_ANULADOS AS ANU 
                ON FAC.AdmissionNumber = ANU.AdmissionNumber
        WHERE FAC.Status = 1
    ),
    CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_MAX AS (
        SELECT
            FAC.AdmissionNumber,
            FAC.PatientCode,
            FAC.InvoiceNumber,
            FAC.TotalInvoice,
            FAC.InvoiceDate
        FROM [INDIGO036].[Billing].[Invoice] FAC
        INNER JOIN CTE_FACTURAS_ANULADAS ANU 
                ON FAC.AdmissionNumber = ANU.AdmissionNumber
               AND FAC.InvoiceCategoryId = ANU.InvoiceCategoryId
        WHERE FAC.Status = 1
    ),
    CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_FOLIO AS (
        SELECT
            FAC.AdmissionNumber,
            FAC.PatientCode,
            FAC.InvoiceNumber,
            FAC.TotalInvoice,
            FAC.InvoiceDate
        FROM [INDIGO036].[Billing].[Invoice] FAC
        INNER JOIN CTE_FACTURAS_ANULADAS ANU 
                ON FAC.AdmissionNumber = ANU.AdmissionNumber
               AND 1 = (
                    SELECT COUNT(*)
                    FROM [INDIGO036].[Billing].[Invoice] F
                    WHERE F.AdmissionNumber = FAC.AdmissionNumber
                      AND F.Status = 1
               )
        WHERE FAC.Status = 1
    ),
    CTE_FACTURAS_ANULADAS_DETALLE AS (
        SELECT
            FAC.AdmissionNumber,
            Id.InvoiceId,
            MIN(Id.ServiceOrderDetailId) AS SOD
        FROM [INDIGO036].[Billing].[InvoiceDetail] Id
        INNER JOIN [INDIGO036].[Billing].[Invoice] AS FAC 
                ON FAC.Id = Id.InvoiceId
        INNER JOIN CTE_FACTURAS_ANULADAS AS ANU 
                ON ANU.AdmissionNumber = FAC.AdmissionNumber 
               AND FAC.Id = ANU.Id
        WHERE Id.Balance = 0
        GROUP BY FAC.AdmissionNumber, Id.InvoiceId
    ),
    CTE_FACTURAS_SIN_ANULAR_DETALLE AS (
        SELECT
            FAC.AdmissionNumber,
            Id.InvoiceId,
            MIN(Id.ServiceOrderDetailId) AS SOD,
            FAC.InvoiceNumber,
            FAC.TotalInvoice,
            FAC.InvoiceDate
        FROM [INDIGO036].[Billing].[InvoiceDetail] Id
        INNER JOIN [INDIGO036].[Billing].[Invoice] AS FAC 
                ON FAC.Id = Id.InvoiceId
        INNER JOIN CTE_FACTURAS_SIN_ANULAR AS ANU 
                ON ANU.AdmissionNumber = FAC.AdmissionNumber 
               AND FAC.Id = ANU.Id
        WHERE Id.Balance > 0
        GROUP BY FAC.AdmissionNumber, Id.InvoiceId, 
                 FAC.InvoiceNumber, FAC.TotalInvoice, FAC.InvoiceDate
    ),
    CTE_FINAL_FACTURA_ANULADAS AS (
        SELECT
            ANU.AdmissionNumber AS INGRESO,
            ING.IESTADOIN AS ESTADO,
            ANU.PatientCode AS IDENTIFICACION,
            ANU.IPNOMCOMP AS PACIENTE,
            ANU.Name AS ENTIDAD,
            ANU.InvoiceNumber AS [FACTURA ANULADA],
            CAST(ANU.InvoiceDate AS DATE) AS [FECHA DE FACTURA],
            ANU.TotalInvoice AS [VALOR ANULADO],
            ANU.[USUARIO FACTURO],
            ANU.[USUARIO ANULO],
            ANU.AnnulmentDate AS [FECHA ANULACION],
            ANU.DescriptionReversal AS [OBSERVACIONES ANULACION],
            ISNULL(DETSIN.InvoiceNumber, ISNULL(CON.InvoiceNumber, ISNULL(MAXI.InvoiceNumber, FOL.InvoiceNumber))) AS [FACTURA REMPLAZO],
            ISNULL(DETSIN.TotalInvoice, ISNULL(CON.TotalInvoice, ISNULL(MAXI.TotalInvoice, FOL.TotalInvoice))) AS [VALOR REMPLAZO],
            ISNULL(DETSIN.InvoiceDate, ISNULL(CON.InvoiceDate, ISNULL(MAXI.InvoiceDate, FOL.InvoiceDate))) AS [FECHA FACTURA REMPLAZO],
            ANU.ReversalReasonId
        FROM CTE_FACTURAS_ANULADAS ANU
        INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
                ON ING.NUMINGRES = ANU.AdmissionNumber
        LEFT JOIN CTE_FACTURAS_ANULADAS_DETALLE AS DET 
               ON DET.InvoiceId = ANU.Id
        LEFT JOIN CTE_FACTURAS_SIN_ANULAR_DETALLE AS DETSIN 
               ON DETSIN.AdmissionNumber = DET.AdmissionNumber 
              AND DETSIN.SOD = DET.SOD
        LEFT JOIN CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO AS CON 
               ON CON.AdmissionNumber = ANU.AdmissionNumber 
              AND ANU.TotalInvoice = CON.TotalInvoice
        LEFT JOIN CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_MAX AS MAXI 
               ON ANU.AdmissionNumber = MAXI.AdmissionNumber
        LEFT JOIN CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_FOLIO FOL 
               ON ANU.AdmissionNumber = FOL.AdmissionNumber
    )
    SELECT DISTINCT
        ANU.INGRESO,
        ANU.ESTADO,
        ANU.IDENTIFICACION,
        RTRIM(ANU.PACIENTE) AS PACIENTE,
        RTRIM(ANU.ENTIDAD) AS ENTIDAD,
        ANU.[FACTURA ANULADA],
        ANU.[FECHA ANULACION],
        ANU.[FECHA DE FACTURA],
        ANU.[VALOR ANULADO],
        ANU.[USUARIO FACTURO],
        ANU.[USUARIO ANULO],
        BRR.Description AS [RAZONES ANULACION],
        ANU.[OBSERVACIONES ANULACION],
        ANU.[FACTURA REMPLAZO],
        ANU.[VALOR REMPLAZO],
        ANU.[FECHA FACTURA REMPLAZO]
    FROM CTE_FINAL_FACTURA_ANULADAS ANU
    LEFT JOIN [INDIGO036].[Billing].[BillingReversalReason] AS BRR 
           ON BRR.Id = ANU.ReversalReasonId;
END
