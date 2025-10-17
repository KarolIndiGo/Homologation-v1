-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_FACTURACION_TOTAL_CITAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE PROCEDURE [Report].[SP_FACTURACION_TOTAL_CITAS]
 @FECINI AS DATE,
 @FECFIN AS DATE
AS

---******FACTURACION TOTAL CON RANGO DE FECHA******-------

 
WITH CTE_FACTURACION_TOTAL AS (
    SELECT DISTINCT I.id, I.InvoiceNumber, I.AdmissionNumber 
    FROM Billing.Invoice AS I
    WHERE CAST(I.InvoiceDate AS DATE) BETWEEN @FECINI AND @FECFIN
)

SELECT DISTINCT
    TIPA.NOMBRE AS [TIPO IDENTIFICACION],
    I.PatientCode AS IDENTIFICACION,
    PAC.IPNOMCOMP AS NOMBRE,
    DATEDIFF(YEAR, PAC.IPFECNACI, ING.IFECHAING) AS [EDAD AÑOS],
    ING.NUMINGRES AS INGRESO,
    IC.Code + ' - ' + IC.Name AS CATEGORIA,
    CG.Code + ' - ' + CG.Name AS [GRUPO DE ATENCION],
    HA.HealthEntityCode AS [CODIGO EPS],
    ISNULL(HA.Code + ' - ', '') + CG.Name AS [ENTIDAD ADMINISTRADORA],
    CASE
        WHEN CG.EntityType = '1' THEN 'EPS Contributivo'
        WHEN CG.EntityType = '2' THEN 'EPS Subsidiado'
        WHEN CG.EntityType = '3' THEN 'ET Vinculados Municipios'
        WHEN CG.EntityType = '4' THEN 'ET Vinculados Departamentos'
        WHEN CG.EntityType = '5' THEN 'ARL Riesgos Laborales'
        WHEN CG.EntityType = '6' THEN 'MP Medicina Prepagada'
        WHEN CG.EntityType = '7' THEN 'IPS Privada'
        WHEN CG.EntityType = '8' THEN 'IPS Publica'
        WHEN CG.EntityType = '9' THEN 'Regimen Especial'
        WHEN CG.EntityType = '10' THEN 'Accidentes de transito'
        WHEN CG.EntityType = '11' THEN 'Fosyga'
        WHEN CG.EntityType = '12' THEN 'Otros'
        WHEN CG.EntityType = '13' THEN 'Aseguradoras'
        WHEN CG.EntityType = '99' THEN 'Particulares'
    END AS REGIMEN,
    TP.Name AS TERCERO,
    I.InvoiceNumber AS FACTURA,
	ESP.DESESPECI ESPECIALIDAD,
    I.InvoicedUser AS [USUARIO FACTURO],
    SU.NOMUSUARI AS [NOMBRE FACTURADOR],
    I.InvoiceDate AS [FECHA FACTURA],
    CAST(I.TotalInvoice AS NUMERIC(20, 2)) AS [TOTAL FACTURA],
    CAST(I.ThirdPartySalesValue AS NUMERIC(20, 2)) AS [TOTAL ENTIDAD],
    CAST(I.TotalPatientSalesPrice AS NUMERIC(20, 2)) AS [TOTAL PACIENTE],
    CASE 
        WHEN I.Status = 1 THEN 'Facturado'
        WHEN I.Status = 2 THEN 'Anulado'
    END AS [ESTADO FACTURA],
	--DIN.OBSSERIPS ObservacionInterconsulta,
    I.AnnulmentUser + ' - ' + SUA.NOMUSUARI AS [USUARIO ANULO],
    I.AnnulmentDate AS [FECHA ANULACION],
    Billing.BillingReversalReason.Name AS [RAZON ANULACION],
    I.DescriptionReversal AS [DESCRIPCION ANULACION]

FROM Billing.Invoice AS I
INNER JOIN Billing.InvoiceDetail BI ON BI.InvoiceId = I.ID
INNER JOIN Billing.ServiceOrderDetail SOD ON SOD.ID = BI.ServiceOrderDetailId
--JOIN HCORDINTE DIN ON DIN.NUMINGRES = I.ADMISSIONNUMBER
LEFT JOIN dbo.INESPECIA AS ESP WITH (NOLOCK) ON ESP.CODESPECI = SOD.PerformsProfessionalSpecialty
INNER JOIN CTE_FACTURACION_TOTAL AS FAC ON FAC.ID = I.id
INNER JOIN Billing.InvoiceCategories IC ON IC.Id = I.InvoiceCategoryId
LEFT JOIN Common.ThirdParty TP ON I.ThirdPartyId = TP.Id
LEFT JOIN Contract.CareGroup CG ON CG.Id = I.CareGroupId
LEFT JOIN Contract.HealthAdministrator HA ON HA.Id = I.HealthAdministratorId
LEFT JOIN DBO.INPACIENT PAC ON PAC.IPCODPACI = I.PatientCode
LEFT JOIN DBO.ADINGRESO ING ON ING.NUMINGRES = I.AdmissionNumber
LEFT JOIN Billing.BillingReversalReason ON I.ReversalReasonId = Billing.BillingReversalReason.Id
LEFT JOIN DBO.ADTIPOIDENTIFICA TIPA WITH (NOLOCK) ON TIPA.ID = PAC.IPTIPODOC
LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = I.InvoicedUser
LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = I.AnnulmentUser;

