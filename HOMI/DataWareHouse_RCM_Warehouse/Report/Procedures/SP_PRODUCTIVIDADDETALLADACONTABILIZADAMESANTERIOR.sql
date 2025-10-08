-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_PRODUCTIVIDADDETALLADACONTABILIZADAMESANTERIOR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   PROCEDURE [Report].[SP_PRODUCTIVIDADDETALLADACONTABILIZADAMESANTERIOR]
    @ANO INT,
    @MES INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TIPOFACTURA    INT = 116;
    DECLARE @TIPOANULACION  INT = 14;
    DECLARE @RECONOCIMIENTO INT = 53;

    WITH TBL_CONCEPTOS_FACTURACION AS (
        SELECT
            *
        FROM
            (
                SELECT
                    BC.Id ID_CON,
                    BC.Code 'CODIGO',
                    BC.Name 'NOMBRE CONCEPTO',
                    CASE
                        BC.ConceptType
                        WHEN 1 THEN 'Facturación Básica'
                        when 2 then 'Facturacion Salud'
                    END 'TIPO CONCEPTO',
                    CASE
                        BC.ObtainCostCenter
                        WHEN 1 THEN 'Unidad Funcional del Paciente'
                        WHEN 2 THEN 'Centro de Costo Específico'
                        WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
                        ELSE ''
                    END 'OBTENER CENTRO COSTO',
                    IIF(BC.ObtainCostCenter = 2, CC.Code, '') 'CODIGO CC',
                    IIF(BC.ObtainCostCenter = 2, CC.Name, '') 'CENTRO COSTO',
                    CASE
                        BC.AccountingType
                        WHEN 1 THEN 'Cuenta Unica de Ingreso'
                        WHEN 2 THEN 'Cuenta por Tipo de Unidad'
                        ELSE ''
                    END 'TIPO CONTABILIZACION',
                    IIF(
                        BC.AccountingType = 1,
                        MA.Number,
                        IIF(BC.ConceptType = 1, MA.Number, '')
                    ) 'CUENTA ENTIDAD',
                    IIF(
                        BC.AccountingType = 1,
                        MA.Name,
                        IIF(BC.ConceptType = 1, MA.Name, '')
                    ) 'CUENTA INGRESO ENTIDAD',
                    IIF(
                        BC.AccountingType = 1,
                        MA2.Number,
                        IIF(BC.ConceptType = 1, MA2.Number, '')
                    ) 'CUENTA PARTICULAR',
                    IIF(
                        BC.AccountingType = 1,
                        MA2.Name,
                        IIF(BC.ConceptType = 1, MA2.Name, '')
                    ) 'CUENTA INGRESO PARTICULAR',
                    IIF(
                        BC.AccountingType = 1,
                        MA3.Number,
                        IIF(BC.ConceptType = 1, MA3.Number, '')
                    ) 'CUENTA RECONOCIMIENTO',
                    IIF(
                        BC.AccountingType = 1,
                        MA3.Name,
                        IIF(BC.ConceptType = 1, MA3.Name, '')
                    ) 'CUENTA INGRESO RECONOCIMIENTO',
                    IIF(
                        BC.AccountingType = 1,
                        MA4.Number,
                        IIF(BC.ConceptType = 1, MA4.Number, '')
                    ) 'CUENTA HONORARIOS',
                    IIF(
                        BC.AccountingType = 1,
                        MA4.Name,
                        IIF(BC.ConceptType = 1, MA4.Name, '')
                    ) 'CUENTA GASTO HONORARIO',
                    IIF(
                        BC.AccountingType = 1,
                        MA9.Number,
                        IIF(BC.ConceptType = 1, MA9.Number, '')
                    ) 'CUENTA DESCUENTO',
                    IIF(
                        BC.AccountingType = 1,
                        MA9.Name,
                        IIF(BC.ConceptType = 1, MA9.Name, '')
                    ) 'CUENTA PARA DESCUENTO',
                    CASE
                        BCA.UnitType
                        WHEN 1 THEN 'URGENCIAS'
                        WHEN 2 THEN 'HOSPITALIZACION'
                        WHEN 3 THEN 'QUIROFANO'
                        WHEN 4 THEN 'CONSULTA EXTERNA'
                    END 'TIPO UNIDAD',
                    MA5.Number + '-' + 'IE' + '/' + MA6.Number + '-' + 'IP' + '/' + MA8.Number + '-' + 'GH' + '/' + MA7.Number + '-' + 'RI' 'CUENTA INGRESO UF '
                FROM
                    INDIGO036.Billing.BillingConcept BC
                    LEFT JOIN INDIGO036.Payroll.CostCenter AS CC ON CC.Id = BC.ObtainCostCenter
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA ON MA.Id = BC.EntityIncomeAccountId
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA2 ON MA2.Id = BC.IndividualIncomeAccountId
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA3 ON MA3.Id = BC.IncomeRecognitionPendingBillingMainAccountId
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA4 ON MA4.Id = BC.FeesExpensesAccountId
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA9 ON MA9.Id = BC.DiscountAccountId
                    LEFT JOIN INDIGO036.Billing.BillingConceptAccount AS BCA ON BCA.BillingConceptId = BC.Id
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA5 ON MA5.Id = BCA.EntityIncomeAccountId
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA6 ON MA6.Id = BCA.IndividualIncomeAccountId
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA7 ON MA7.Id = BCA.IncomeRecognitionMainAccountId
                    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA8 ON MA8.Id = BCA.FeesExpensesAccountId
            ) AS SourceTable PIVOT (
                MAX([CUENTA INGRESO UF]) FOR [TIPO UNIDAD] In(
                    [URGENCIAS],
                    [HOSPITALIZACION],
                    [QUIROFANO],
                    [CONSULTA EXTERNA]
                )
            ) AS PVTTABLE
    ),
    TBL_FACTURADOS_UNICOS AS (
        SELECT
            DISTINCT JV.EntityId,
            CAST(JV.VoucherDate AS DATE) VoucherDate,
            sum(JVD.CreditValue) Valor_Credito,
            AdmissionNumber
        FROM
            INDIGO036.GeneralLedger.JournalVouchers JV
            INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
            LEFT JOIN INDIGO036.Billing.Invoice AS F ON F.Id = JV.EntityId
        WHERE
            YEAR(JV.VoucherDate) = @ANO
            AND MONTH(JV.VoucherDate) = @MES
            AND JV.LegalBookId = 1
            AND JV.EntityName = 'Invoice'
            AND IdJournalVoucher = @TIPOFACTURA
        GROUP BY
            JV.EntityId,
            CAST(JV.VoucherDate AS DATE),
            AdmissionNumber
    ),
    TBL_ALTA_MEDICA_FACTURADOS AS (
        SELECT
            EGR.NUMINGRES 'INGRESO',
            EGR.IPCODPACI 'IDENTIFICACION',
            EGR.FECALTPAC 'FECHA ALTA MEDICA'
        FROM
            INDIGO036.dbo.HCREGEGRE EGR
            INNER JOIN (
                SELECT
                    EGR.NUMINGRES 'INGRESO',
                    EGR.IPCODPACI 'IDENTIFICACION',
                    MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA'
                FROM
                    INDIGO036.dbo.HCREGEGRE EGR
                    INNER JOIN TBL_FACTURADOS_UNICOS AS ING ON EGR.NUMINGRES = ING.AdmissionNumber
                GROUP BY
                    EGR.NUMINGRES,
                    EGR.IPCODPACI
            ) AS G ON G.INGRESO = EGR.NUMINGRES
            AND G.[FECHA ALTA MEDICA] = EGR.FECALTPAC
    ),
    TBL_ANULADOS_UNICOS AS (
        SELECT
            DISTINCT JV.EntityId,
            CAST(JV.VoucherDate AS DATE) VoucherDate,
            sum(JVD.CreditValue) Valor_Credito,
            F.AdmissionNumber
        FROM
            INDIGO036.GeneralLedger.JournalVouchers JV
            INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
            LEFT JOIN INDIGO036.Billing.Invoice AS F ON F.Id = JV.EntityId
        WHERE
            YEAR(JV.VoucherDate) = @ANO
            AND MONTH(JV.VoucherDate) = @MES
            AND JV.LegalBookId = 1
            AND JV.EntityName = 'Invoice'
            AND IdJournalVoucher = @TIPOANULACION
        GROUP BY
            JV.Id,
            JV.EntityCode,
            JV.EntityId,
            CAST(JV.VoucherDate AS DATE),
            F.AdmissionNumber
    ),
    TBL_ALTA_MEDICA_ANULADOS AS (
        SELECT
            EGR.NUMINGRES 'INGRESO',
            EGR.IPCODPACI 'IDENTIFICACION',
            EGR.FECALTPAC 'FECHA ALTA MEDICA'
        FROM
            INDIGO036.dbo.HCREGEGRE EGR
            INNER JOIN (
                SELECT
                    EGR.NUMINGRES 'INGRESO',
                    EGR.IPCODPACI 'IDENTIFICACION',
                    MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA'
                FROM
                    INDIGO036.dbo.HCREGEGRE EGR
                    INNER JOIN TBL_ANULADOS_UNICOS AS ING ON EGR.NUMINGRES = ING.AdmissionNumber
                GROUP BY
                    EGR.NUMINGRES,
                    EGR.IPCODPACI
            ) AS G ON G.INGRESO = EGR.NUMINGRES
            AND G.IDENTIFICACION = EGR.IPCODPACI
            AND G.[FECHA ALTA MEDICA] = EGR.FECALTPAC
    ),
    TBL_RECONOCIMIENTOS_UNICOS AS (
        SELECT
            DISTINCT JV.Id,
            JV.EntityId,
            CAST(JV.VoucherDate AS DATE) VoucherDate,
            sum(JVD.CreditValue) Valor_Credito
        FROM
            INDIGO036.GeneralLedger.JournalVouchers JV
            INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
        WHERE
            YEAR(JV.VoucherDate) = @ANO
            AND MONTH(JV.VoucherDate) = @MES
            AND JV.LegalBookId = 1
            AND JV.EntityName = 'RevenueRecognition'
            AND IdJournalVoucher = @RECONOCIMIENTO
        GROUP BY
            JV.Id,
            JV.EntityCode,
            JV.EntityId,
            CAST(JV.VoucherDate AS DATE)
    ),
    CTE_1 AS (
        SELECT
            CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
            ISNULL(IDS.Id, SOD.Id) IDDETALLE,
            'FACTURADO' AS ESTADO,
            YEAR(UNI.VoucherDate) AS AÑO,
            MONTH(UNI.VoucherDate) AS MES,
            DAY(UNI.VoucherDate) AS DIA,
            TP.Nit AS NIT,
            TP.Name AS ENTIDAD,
            CG.Code AS [CODIGO GRUPO ATENCION],
            CG.Name AS [GRUPO ATENCION],
            I.PatientCode AS IDENTIFICACION,
            RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
            I.AdmissionNumber AS INGRESO,
            CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
            CASE
                WHEN ING.TIPOINGRE = 1 THEN CAST(ING.IFECHAING AS DATE)
                ELSE CAST(ALT.[FECHA ALTA MEDICA] AS DATE)
            END AS [FECHA EGRESO],
            I.InvoiceNumber AS [NRO FACTURA],
            CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
            I.TotalInvoice AS [TOTAL FACTURA],
            CASE
                SOD.RecordType
                WHEN 1 THEN 'SERVICIOS'
                WHEN 2 THEN 'PRODUCTOS'
            END AS [TIPO REGISTRO],
            CASE
                CUPS.ServiceType
                WHEN 1 then 'Laboratorios'
                WHEN 2 then 'Patologias'
                WHEN 3 then 'Imagenes Diagnosticas'
                WHEN 4 then 'Procedimeintos no Qx'
                WHEN 5 then 'Procedimientos Qx'
                WHEN 6 then 'Interconsultas'
                WHEN 7 then 'Ninguno'
                WHEN 8 then 'Consulta Externa'
                ELSE 'Otro'
            END AS [TIPO SERVICIO],
            CASE
                SOD.Presentation
                WHEN 1 THEN 'NO QUIRURGICO'
                WHEN 2 THEN 'QUIRURGICO'
                WHEN 3 THEN 'PAQUETE'
                ELSE 'NO QUIRURGICO'
            END AS PRESENTACION,
            CAST(SOD.ServiceDate AS DATE) AS [FECHA SERVICIO],
            ISNULL(CUPS.Code, IPR.Code) AS [CUPS/PRODUCTO],
            ISNULL(CUPS.Description, IPR.Description) AS DESCRIPCION,
            ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX',
            SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'), 1, 60) AS 'DESCRIPCION DETALLE QX',
            CD.Name 'DECRIPCION RELACIONADA',
            ISNULL(IDS.InvoicedQuantity, ID.InvoicedQuantity) 'CANTIDAD',
            ISNULL(IDS.RateManualSalePrice, SOD.RateManualSalePrice) 'VALOR SERVICIO',
            SOD.CostValue 'COSTO SERVICIO',
            ISNULL(IDS.RateManualSalePrice, ID.TotalSalesPrice) 'VALOR UNITARIO',
            ISNULL(IDS.TotalSalesPrice, ID.GrandTotalSalesPrice) 'VALOR TOTAL',
            CASE
                SOD.IsPackage
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'ES PAQUETE',
            CASE
                SOD.Packaging
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'INCLUIDO EN PAQUETE',
            CUPSP.Code 'CODIGO PAQUETE',
            CUPSP.Description 'NOMBRE PAQUETE',
            CASE
                SOD.SettlementType
                WHEN 1 THEN 'Por manual de tarifas'
                WHEN 2 THEN '% otro servicio cargado'
                WHEN 3 THEN '100% incluido en otro servicio (No se cobra)'
                when 4 then '% del mismo servicio'
                else 'otro'
            end 'TIPO LIQUIDACION',
            CUPSI.Code 'CUPS QUE INCLUYE',
            CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            ISNULL(
                IDS.PerformsHealthProfessionalCode,
                ISNULL(MED.CODPROSAL, TPT.Nit)
            ) 'IDENTIFICACION PROFESIONAL',
            RTRIM(
                ISNULL(MEDQX.NOMMEDICO, ISNULL(MED.NOMMEDICO, TPT.Name))
            ) 'PROFESIONAL',
            ISNULL(ESPQX.DESESPECI, ESPMED.DESESPECI) 'ESPECIALIDAD',
            FU.Code 'CODIGO UNIDAD SOLICITO',
            FU.Name 'UNIDAD SOLICITO',
            COST.Code 'CODIGO CC CONTABILIZO',
            COST.Name 'CENTRO COSTO CONTABILIZO',
            MA.Number 'NRO CUENTA CONTABILIZO',
            MA.Name 'CUENTA CONTABILIZO',
            NULL 'FECHA ANULACION',
            CONQX.*,
            CONVERT(
                DATETIME,
                GETDATE() AT TIME ZONE 'Pakistan Standard Time',
                1
            ) AS ULT_ACTUAL
        FROM
            INDIGO036.Billing.Invoice AS I
            INNER JOIN TBL_FACTURADOS_UNICOS AS UNI ON UNI.EntityId = I.Id
            INNER JOIN INDIGO036.Billing.InvoiceDetail AS ID ON ID.InvoiceId = I.Id
            INNER JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = ID.ServiceOrderDetailId
            INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
            INNER JOIN INDIGO036.Payroll.CostCenter AS COST ON COST.Id = SOD.CostCenterId
            INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = I.AdmissionNumber
            INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = I.ThirdPartyId
            INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = I.CareGroupId
            INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPS ON CUPS.Id = SOD.CUPSEntityId
            LEFT JOIN INDIGO036.Inventory.InventoryProduct AS IPR ON IPR.Id = SOD.ProductId
            LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId
            AND SOD.CUPSEntityId = DESCR.CUPSEntityId
            LEFT JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODP ON SODP.Id = SOD.PackageServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSP ON CUPSP.Id = SODP.CUPSEntityId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
            LEFT JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
            LEFT JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
            LEFT JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetailSurgical AS IDS ON IDS.ServiceOrderDetailId = SOD.Id
            AND IDS.OnlyMedicalFees = '0'
            LEFT JOIN INDIGO036.Contract.IPSService AS IPS ON IPS.Id = IDS.IPSServiceId
            LEFT JOIN INDIGO036.dbo.INPROFSAL AS MEDQX ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
            LEFT JOIN INDIGO036.dbo.INESPECIA AS ESPQX ON ESPQX.CODESPECI = MEDQX.CODESPEC1
            LEFT JOIN TBL_CONCEPTOS_FACTURACION AS CONQX ON CONQX.ID_CON = ISNULL(
                IDS.BillingConceptId,
                ISNULL(DESCR.BillingConceptId, SOD.BillingConceptId)
            )
            LEFT JOIN TBL_ALTA_MEDICA_FACTURADOS AS ALT ON ALT.INGRESO = I.AdmissionNumber
            LEFT JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = ISNULL(IDS.IncomeMainAccountId, SOD.IncomeMainAccountId)
    ),
    CTE_2 AS (
        SELECT
            CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
            RRD.Id IDDETALLE,
            'RECONOCIMIENTO CONTABILIZADO' AS 'ESTADO',
            YEAR(UNI.VoucherDate) 'AÑO',
            MONTH(UNI.VoucherDate) 'MES',
            DAY(UNI.VoucherDate) 'DIA',
            ISNULL(TP.Nit, '999') 'NIT',
            ISNULL(TP.Name, 'PARTICULAR') 'ENTIDAD',
            CG.Code 'CODIGO GRUPO ATENCION',
            CG.Name 'GRUPO ATENCION',
            PAC.IPCODPACI 'IDENTIFICACION',
            RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
            ING.NUMINGRES 'INGRESO',
            CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',
            G2.[FECHA ALTA MEDICA] 'FECHA EGRESO',
            'N/A' 'NRO FACTURA',
            NULL 'FECHA FACTURA',
            '0' 'TOTAL FACTURA',
            CASE
                SOD.RecordType
                WHEN 1 THEN 'SERVICIOS'
                WHEN 2 THEN 'PRODUCTOS'
            END 'TIPO REGISTRO',
            CASE
                CUPS.ServiceType
                WHEN 1 then 'Laboratorios'
                WHEN 2 then 'Patologias'
                WHEN 3 then 'Imagenes Diagnosticas'
                WHEN 4 then 'Procedimeintos no Qx'
                WHEN 5 then 'Procedimientos Qx'
                WHEN 6 then 'Interconsultas'
                WHEN 7 then 'Ninguno'
                WHEN 8 then 'Consulta Externa'
                ELSE 'Otro'
            end 'TIPO SERVICIO',
            CASE
                SOD.Presentation
                WHEN 1 THEN 'NO QUIRURGICO'
                WHEN 2 THEN 'QUIRURGICO'
                WHEN 3 THEN 'PAQUETE'
                ELSE 'NO QUIRURGICO'
            END 'PRESENTACION',
            CAST(SOD.ServiceDate AS DATE) 'FECHA SERVICIO',
            ISNULL(CUPS.Code, IPR.Code) 'CUPS/PRODUCTO',
            ISNULL(CUPS.Description, IPR.Description) 'DESCRIPCION',
            '' AS 'CODIGO DETALLE QX',
            '' 'DESCRIPCION DETALLE QX',
            CD.Name 'DECRIPCION RELACIONADA',
            RRD.InvoicedQuantity 'CANTIDAD',
            RRD.RateManualSalePrice 'VALOR SERVICIO',
            SOD.CostValue 'COSTO SERVICIO',
            SOD.TotalSalesPrice 'VALOR UNITARIO',
            RRD.GrandTotalSalesPrice 'VALOR TOTAL',
            CASE
                SOD.IsPackage
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'ES PAQUETE',
            CASE
                SOD.Packaging
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'INCLUIDO EN PAQUETE',
            CUPSP.Code 'CODIGO PAQUETE',
            CUPSP.Description 'NOMBRE PAQUETE',
            CASE
                SOD.SettlementType
                WHEN 1 THEN 'Por manual de tarifas'
                WHEN 2 THEN '% otro servicio cargado'
                WHEN 3 THEN '100% incluido en otro servicio (No se cobra)'
                when 4 then '% del mismo servicio'
                else 'otro'
            end 'TIPO LIQUIDACION',
            CUPSI.Code 'CUPS QUE INCLUYE',
            CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            ISNULL(MED.CODPROSAL, TPT.Nit) 'IDENTIFICACION PROFESIONAL',
            RTRIM(ISNULL(MED.NOMMEDICO, TPT.Name)) 'PROFESIONAL',
            ESPMED.DESESPECI 'ESPECIALIDAD',
            FU.Code 'CODIGO UNIDAD SOLICITO',
            FU.Name 'UNIDAD SOLICITO',
            COST.Code 'CODIGO CC CONTABILIZO',
            COST.Name 'CENTRO COSTO CONTABILIZO',
            MA.Number 'NRO CUENTA CONTABILIZO',
            MA.Name 'CUENTA CONTABILIZO',
            NULL 'FECHA ANULACION',
            CONF.*,
            CONVERT(
                DATETIME,
                GETDATE() AT TIME ZONE 'Pakistan Standard Time',
                1
            ) AS ULT_ACTUAL
        FROM
            INDIGO036.Billing.RevenueRecognition AS RR
            INNER JOIN TBL_RECONOCIMIENTOS_UNICOS AS UNI ON
            UNI.EntityId = RR.Id
            INNER JOIN INDIGO036.Billing.RevenueRecognitionDetail AS RRD ON RRD.RevenueRecognitionId = RR.Id
            INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = RR.CareGroupId
            INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = RRD.PerformsFunctionalUnitId
            INNER JOIN INDIGO036.Payroll.CostCenter AS COST ON COST.Id = RRD.CostCenterId
            LEFT JOIN INDIGO036.Contract.Contract AS CON ON CON.Id = CG.ContractId
            LEFT JOIN INDIGO036.Contract.HealthAdministrator AS HA ON HA.Id = CON.HealthAdministratorId
            LEFT JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = ISNULL(HA.ThirdPartyId, RRD.ThirdPartySalesPrice)
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = RRD.ServiceOrderDetailId
            LEFT JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
            LEFT JOIN INDIGO036.Billing.RevenueControlDetail AS RCD ON RCD.Id = RRD.RevenueControlDetailId
            LEFT JOIN INDIGO036.Billing.RevenueControl AS RC ON RC.Id = RCD.RevenueControlId
            LEFT JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = ISNULL(
                RRD.AdmissionNumber,
                ISNULL(SO.AdmissionNumber, RC.AdmissionNumber)
            )
            LEFT JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = ISNULL(
                ING.IPCODPACI,
                ISNULL(SO.PatientCode, RC.PatientCode)
            )
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPS ON CUPS.Id = ISNULL(SOD.CUPSEntityId, RRD.CUPSEntityId)
            LEFT JOIN INDIGO036.Inventory.InventoryProduct AS IPR ON IPR.Id = ISNULL(SOD.ProductId, RRD.ProductId)
            LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId
            AND SOD.CUPSEntityId = DESCR.CUPSEntityId
            LEFT JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODP ON SODP.Id = SOD.PackageServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSP ON CUPSP.Id = ISNULL(SODP.CUPSEntityId, RRD.CUPSEntityId)
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSI ON CUPSI.Id = ISNULL(SODI.CUPSEntityId, RRD.CUPSEntityId)
            LEFT JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
            LEFT JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
            LEFT JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
            LEFT JOIN TBL_CONCEPTOS_FACTURACION AS CONF ON CONF.ID_CON = RRD.BillingConceptId
            LEFT JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = RRD.IncomeRecognitionMainAccountId
            LEFT JOIN (
                SELECT
                    EGR.NUMINGRES 'INGRESO',
                    EGR.IPCODPACI 'IDENTIFICACION',
                    EGR.FECALTPAC 'FECHA ALTA MEDICA'
                FROM
                    INDIGO036.dbo.HCREGEGRE EGR
                    INNER JOIN (
                        SELECT
                            EGR.NUMINGRES 'INGRESO',
                            EGR.IPCODPACI 'IDENTIFICACION',
                            MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA'
                        FROM
                            INDIGO036.dbo.HCREGEGRE EGR
                        GROUP BY
                            EGR.NUMINGRES,
                            EGR.IPCODPACI
                    ) AS G ON G.INGRESO = EGR.NUMINGRES
                    AND G.IDENTIFICACION = EGR.IPCODPACI
                    AND G.[FECHA ALTA MEDICA] = EGR.FECALTPAC
            ) AS G2 ON G2.INGRESO = ING.NUMINGRES
    ),
    CTE_3 AS (
        select
            CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
            SOD.Id IDDETALLE,
            'NO FACTURABLES' 'ESTADO',
            @ANO AS 'AÑO',
            @MES AS 'MES',
            1 'DIA',
            TP.Nit 'NIT',
            TP.Name 'ENTIDAD',
            CG.Code 'CODIGO GRUPO ATENCION',
            CG.Name 'GRUPO ATENCION',
            SO.PatientCode 'IDENTIFICACION',
            RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
            SO.AdmissionNumber 'INGRESO',
            CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',
            G2.[FECHA ALTA MEDICA] 'FECHA EGRESO',
            'N/A' 'NRO FACTURA',
            NULL 'FECHA FACTURA',
            '0' 'TOTAL FACTURA',
            CASE
                SOD.RecordType
                WHEN 1 THEN 'SERVICIOS'
                WHEN 2 THEN 'PRODUCTOS'
            END 'TIPO REGISTRO',
            CASE
                CUPS.ServiceType
                WHEN 1 then 'Laboratorios'
                WHEN 2 then 'Patologias'
                WHEN 3 then 'Imagenes Diagnosticas'
                WHEN 4 then 'Procedimeintos no Qx'
                WHEN 5 then 'Procedimientos Qx'
                WHEN 6 then 'Interconsultas'
                WHEN 7 then 'Ninguno'
                WHEN 8 then 'Consulta Externa'
                ELSE 'Otro'
            end 'TIPO SERVICIO',
            CASE
                SOD.Presentation
                WHEN 1 THEN 'NO QUIRURGICO'
                WHEN 2 THEN 'QUIRURGICO'
                WHEN 3 THEN 'PAQUETE'
                ELSE 'NO QUIRURGICO'
            END 'PRESENTACION',
            CAST(SOD.ServiceDate AS DATE) 'FECHA SERVICIO',
            ISNULL(CUPS.Code, IPR.Code) 'CUPS/PRODUCTO',
            ISNULL(CUPS.Description, IPR.Description) 'DESCRIPCION',
            ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX',
            SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'), 1, 60) AS 'DESCRIPCION DETALLE QX',
            CD.Name 'DECRIPCION RELACIONADA',
            ISNULL(SODS.InvoicedQuantity, SOD.InvoicedQuantity) 'CANTIDAD',
            ISNULL(
                SODS.RateManualSalePrice,
                SOD.RateManualSalePrice
            ) 'VALOR SERVICIO',
            SOD.CostValue 'COSTO SERVICIO',
            ISNULL(SODS.RateManualSalePrice, SOD.TotalSalesPrice) 'VALOR UNITARIO',
            ISNULL(SODS.TotalSalesPrice, SOD.GrandTotalSalesPrice) 'VALOR TOTAL',
            CASE
                SOD.IsPackage
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'ES PAQUETE',
            CASE
                SOD.Packaging
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'INCLUIDO EN PAQUETE',
            CUPSP.Code 'CODIGO PAQUETE',
            CUPSP.Description 'NOMBRE PAQUETE',
            CASE
                SOD.SettlementType
                WHEN 1 THEN 'Por manual de tarifas'
                WHEN 2 THEN '% otro servicio cargado'
                WHEN 3 THEN '100% incluido en otro servicio (No se cobra)'
                when 4 then '% del mismo servicio'
                else 'otro'
            end 'TIPO LIQUIDACION',
            CUPSI.Code 'CUPS QUE INCLUYE',
            CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            ISNULL(
                SODS.PerformsHealthProfessionalCode,
                ISNULL(MED.CODPROSAL, TPT.Nit)
            ) 'IDENTIFICACION PROFESIONAL',
            RTRIM(
                ISNULL(MEDQX.NOMMEDICO, ISNULL(MED.NOMMEDICO, TPT.Name))
            ) 'PROFESIONAL',
            ISNULL(ESPQX.DESESPECI, ESPMED.DESESPECI) 'ESPECIALIDAD',
            FU.Code 'CODIGO UNIDAD SOLICITO',
            FU.Name 'UNIDAD SOLICITO',
            NULL 'CODIGO CC CONTABILIZO',
            NULL 'CENTRO COSTO CONTABILIZO',
            NULL 'NRO CUENTA CONTABILIZO',
            NULL 'CUENTA CONTABILIZO',
            NULL 'FECHA ANULACION',
            CONQX.*,
            CONVERT(
                DATETIME,
                GETDATE() AT TIME ZONE 'Pakistan Standard Time',
                1
            ) AS ULT_ACTUAL
        from
            INDIGO036.Billing.ServiceOrderDetail as SOD
            INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = SOD.CareGroupId
            INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
            INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU on FU.Id = SOD.PerformsFunctionalUnitId
            INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = SO.PatientCode
            INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = SO.AdmissionNumber
            INNER JOIN INDIGO036.Payroll.CostCenter AS COST ON COST.Id = SOD.CostCenterId
            LEFT JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = SOD.ThirdPartyId
            LEFT JOIN INDIGO036.Contract.CUPSEntity CUPS on SOD.CUPSEntityId = CUPS.Id
            LEFT JOIN INDIGO036.Billing.BillingConcept AS BC on CUPS.BillingConceptId = BC.Id
            LEFT JOIN INDIGO036.Inventory.InventoryProduct AS IPR on SOD.ProductId = IPR.Id
            LEFT JOIN INDIGO036.Inventory.ProductGroup AS PG ON IPR.ProductGroupId = PG.Id
            LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId
            AND SOD.CUPSEntityId = DESCR.CUPSEntityId
            LEFT JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetailSurgical AS SODS ON SODS.ServiceOrderDetailId = SOD.Id
            AND SODS.OnlyMedicalFees = '0'
            AND SODS.SurchargeApply <> 1
            LEFT JOIN INDIGO036.Contract.IPSService AS IPS ON IPS.Id = SODS.IPSServiceId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODP ON SODP.Id = SOD.PackageServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSP ON CUPSP.Id = SODP.CUPSEntityId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
            LEFT JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
            LEFT JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
            LEFT JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
            LEFT JOIN INDIGO036.dbo.INPROFSAL AS MEDQX ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
            LEFT JOIN INDIGO036.dbo.INESPECIA AS ESPQX ON ESPQX.CODESPECI = MEDQX.CODESPEC1
            LEFT JOIN TBL_CONCEPTOS_FACTURACION AS CONQX ON CONQX.ID_CON = ISNULL(
                SODS.BillingConceptId,
                ISNULL(DESCR.BillingConceptId, SOD.BillingConceptId)
            )
            LEFT JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = ISNULL(
                SODS.IncomeMainAccountId,
                SOD.IncomeMainAccountId
            )
            LEFT JOIN (
                SELECT
                    EGR.NUMINGRES 'INGRESO',
                    EGR.IPCODPACI 'IDENTIFICACION',
                    EGR.FECALTPAC 'FECHA ALTA MEDICA'
                FROM
                    INDIGO036.dbo.HCREGEGRE EGR
                    INNER JOIN (
                        SELECT
                            EGR.NUMINGRES 'INGRESO',
                            EGR.IPCODPACI 'IDENTIFICACION',
                            MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA'
                        FROM
                            INDIGO036.dbo.HCREGEGRE EGR
                        GROUP BY
                            EGR.NUMINGRES,
                            EGR.IPCODPACI
                    ) AS G ON G.INGRESO = EGR.NUMINGRES
                    AND G.IDENTIFICACION = EGR.IPCODPACI
                    AND G.[FECHA ALTA MEDICA] = EGR.FECALTPAC
            ) AS G2 ON G2.INGRESO = ING.NUMINGRES
        WHERE
            CG.LiquidationType = 2
            AND YEAR(SOD.ServiceDate) = @ANO
            AND MONTH(SOD.ServiceDate) = @MES
            AND SO.Status <> 3
    ),
    CTE_4 AS (
        SELECT
            CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
            isnull(IDS.Id, SOD.Id) IDDETALLE,
            'ANULADOS' AS 'ESTADO',
            YEAR(UNI.VoucherDate) 'AÑO',
            MONTH(UNI.VoucherDate) 'MES',
            DAY(UNI.VoucherDate) 'DIA',
            TP.Nit 'NIT',
            TP.Name 'ENTIDAD',
            CG.Code 'CODIGO GRUPO ATENCION',
            CG.Name 'GRUPO ATENCION',
            I.PatientCode 'IDENTIFICACION',
            RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
            I.AdmissionNumber 'INGRESO',
            CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',
            CASE
                WHEN ING.TIPOINGRE = 1 THEN CAST(ING.IFECHAING AS DATE)
                ELSE CAST(ALT.[FECHA ALTA MEDICA] AS DATE)
            END 'FECHA EGRESO',
            I.InvoiceNumber 'NRO FACTURA',
            CAST(I.InvoiceDate AS DATE) 'FECHA FACTURA',
            I.TotalInvoice 'TOTAL FACTURA',
            CASE
                SOD.RecordType
                WHEN 1 THEN 'SERVICIOS'
                WHEN 2 THEN 'PRODUCTOS'
            END 'TIPO REGISTRO',
            CASE
                CUPS.ServiceType
                WHEN 1 then 'Laboratorios'
                WHEN 2 then 'Patologias'
                WHEN 3 then 'Imagenes Diagnosticas'
                WHEN 4 then 'Procedimeintos no Qx'
                WHEN 5 then 'Procedimientos Qx'
                WHEN 6 then 'Interconsultas'
                WHEN 7 then 'Ninguno'
                WHEN 8 then 'Consulta Externa'
                ELSE 'Otro'
            end 'TIPO SERVICIO',
            CASE
                SOD.Presentation
                WHEN 1 THEN 'NO QUIRURGICO'
                WHEN 2 THEN 'QUIRURGICO'
                WHEN 3 THEN 'PAQUETE'
                ELSE 'NO QUIRURGICO'
            END 'PRESENTACION',
            cast(SOD.ServiceDate AS DATE) 'FECHA SERVICIO',
            ISNULL(CUPS.Code, IPR.Code) 'CUPS/PRODUCTO',
            ISNULL(CUPS.Description, IPR.Description) 'DESCRIPCION',
            ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX',
            SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'), 1, 60) AS 'DESCRIPCION DETALLE QX',
            CD.Name 'DECRIPCION RELACIONADA',
            (
                ISNULL(IDS.InvoicedQuantity, ID.InvoicedQuantity)
            ) * -1 'CANTIDAD',
            (
                ISNULL(IDS.RateManualSalePrice, SOD.RateManualSalePrice)
            ) * -1 'VALOR SERVICIO',
            SOD.CostValue * -1 'COSTO SERVICIO',
            (
                ISNULL(IDS.RateManualSalePrice, ID.TotalSalesPrice)
            ) * -1 'VALOR UNITARIO',
            (
                ISNULL(IDS.TotalSalesPrice, ID.GrandTotalSalesPrice)
            ) * -1 'VALOR TOTAL',
            CASE
                SOD.IsPackage
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'ES PAQUETE',
            CASE
                SOD.Packaging
                WHEN 0 THEN 'NO'
                WHEN 1 THEN 'SI'
            END 'INCLUIDO EN PAQUETE',
            CUPSP.Code 'CODIGO PAQUETE',
            CUPSP.Description 'NOMBRE PAQUETE',
            CASE
                SOD.SettlementType
                WHEN 1 THEN 'Por manual de tarifas'
                WHEN 2 THEN '% otro servicio cargado'
                WHEN 3 THEN '100% incluido en otro servicio (No se cobra)'
                when 4 then '% del mismo servicio'
                else 'otro'
            end 'TIPO LIQUIDACION',
            CUPSI.Code 'CUPS QUE INCLUYE',
            CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            ISNULL(
                IDS.PerformsHealthProfessionalCode,
                ISNULL(MED.CODPROSAL, TPT.Nit)
            ) 'IDENTIFICACION PROFESIONAL',
            RTRIM(
                ISNULL(MEDQX.NOMMEDICO, ISNULL(MED.NOMMEDICO, TPT.Name))
            ) 'PROFESIONAL',
            ISNULL(ESPQX.DESESPECI, ESPMED.DESESPECI) 'ESPECIALIDAD',
            FU.Code 'CODIGO UNIDAD SOLICITO',
            FU.Name 'UNIDAD SOLICITO',
            COST.Code 'CODIGO CC CONTABILIZO',
            COST.Name 'CENTRO COSTO CONTABILIZO',
            MA.Number 'NRO CUENTA CONTABILIZO',
            MA.Name 'CUENTA CONTABILIZO',
            CAST(I.AnnulmentDate AS DATE) 'FECHA ANULACION',
            CONQX.*,
            CONVERT(
                DATETIME,
                GETDATE() AT TIME ZONE 'Pakistan Standard Time',
                1
            ) AS ULT_ACTUAL
        FROM
            INDIGO036.Billing.Invoice AS I
            INNER JOIN TBL_ANULADOS_UNICOS AS UNI ON UNI.EntityId = I.Id
            INNER JOIN INDIGO036.Billing.InvoiceDetail AS ID ON ID.InvoiceId = I.Id
            INNER JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = ID.ServiceOrderDetailId
            INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
            INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
            INNER JOIN INDIGO036.Payroll.CostCenter AS COST ON COST.Id = SOD.CostCenterId
            INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = I.AdmissionNumber
            INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = I.ThirdPartyId
            INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = I.CareGroupId
            INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPS ON CUPS.Id = SOD.CUPSEntityId
            LEFT JOIN INDIGO036.Inventory.InventoryProduct AS IPR ON IPR.Id = SOD.ProductId
            LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId
            AND SOD.CUPSEntityId = DESCR.CUPSEntityId
            LEFT JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODP ON SODP.Id = SOD.PackageServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSP ON CUPSP.Id = SODP.CUPSEntityId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
            LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
            LEFT JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
            LEFT JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
            LEFT JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
            LEFT JOIN INDIGO036.Billing.ServiceOrderDetailSurgical AS IDS ON IDS.ServiceOrderDetailId = SOD.Id
            AND IDS.OnlyMedicalFees = '0'
            LEFT JOIN INDIGO036.Contract.IPSService AS IPS ON IPS.Id = IDS.IPSServiceId
            LEFT JOIN INDIGO036.dbo.INPROFSAL AS MEDQX ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
            LEFT JOIN INDIGO036.dbo.INESPECIA AS ESPQX ON ESPQX.CODESPECI = MEDQX.CODESPEC1
            LEFT JOIN TBL_CONCEPTOS_FACTURACION AS CONQX ON CONQX.ID_CON = ISNULL(
                IDS.BillingConceptId,
                ISNULL(DESCR.BillingConceptId, SOD.BillingConceptId)
            )
            LEFT JOIN TBL_ALTA_MEDICA_ANULADOS AS ALT ON ALT.INGRESO = I.AdmissionNumber
            LEFT JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = ISNULL(IDS.IncomeMainAccountId, SOD.IncomeMainAccountId)
    )
    SELECT * FROM CTE_1
    UNION ALL
    SELECT * FROM CTE_2
    UNION ALL
    SELECT * FROM CTE_3
    UNION ALL
    SELECT * FROM CTE_4
    ;
END;
