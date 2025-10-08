-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_PRODUCTIVIDAD_V1
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   PROCEDURE Report.SP_PRODUCTIVIDAD_V1
    @FECHAINI   DATE,
    @FECHAFIN   DATE,
    @ID_COMPANY VARCHAR(17) = 'INDIGO036'  -- parámetro de compañía (default)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TIPOFACTURA INT, @TIPOANULACION INT, @RECONOCIMIENTO INT;

    -- Mapeo de tipos por compañía
    IF @ID_COMPANY = 'INDIGO036' BEGIN SET @TIPOFACTURA = 116; SET @TIPOANULACION = 14; SET @RECONOCIMIENTO = 53; END;
    IF @ID_COMPANY = 'INDIGO040' BEGIN SET @TIPOFACTURA = 29;  SET @TIPOANULACION = 30; SET @RECONOCIMIENTO = 92; END;
    IF @ID_COMPANY = 'INDIGO045' BEGIN SET @TIPOFACTURA = 11;  SET @TIPOANULACION = 30; SET @RECONOCIMIENTO = 92; END;
    IF @ID_COMPANY = 'INDIGO046' BEGIN SET @TIPOFACTURA = 11;  SET @TIPOANULACION = 30; SET @RECONOCIMIENTO = 92; END;
    IF @ID_COMPANY = 'INDIGO047' BEGIN SET @TIPOFACTURA = 11;  SET @TIPOANULACION = 30; SET @RECONOCIMIENTO = 92; END;

    /* --- CTEs --- */
    WITH
    CTE_CUPS AS (
        SELECT
            CUPS.Id,
            CUPS.Code,
            CUPS.Description,
            CASE CUPS.ServiceType
                WHEN 1 THEN 'LABORATORIOS'
                WHEN 2 THEN 'PATOLOGIAS'
                WHEN 3 THEN 'IMAGENES DIAGNOSTICAS'
                WHEN 4 THEN 'PROCEDIMIENTOS NO QX'
                WHEN 5 THEN 'PROCEDIMIENTOS QX'
                WHEN 6 THEN 'INTERCONSULTAS'
                WHEN 7 THEN 'NINGUNO'
                WHEN 8 THEN 'CONSULTA EXTERNA'
                ELSE 'OTROS'
            END AS 'TIPO SERVICIO',
            BG.Code 'CODIGO FACTURACION',
            BG.Name 'GRUPO FACTURACION',
            BC.Code 'CODIGO CONCEPTO',
            BC.Name 'CONCEPTO FACTURACION',
            CGC.Code 'CODIGO GRUPO',
            CGC.Name 'GRUPO CUPS',
            CSG.Code 'CODIGO SUBGRUPO',
            CSG.Name 'SUBGRUPO CUPS',
            CASE ObtainCostCenter
                WHEN 1 THEN 'Unidad Funcional del Paciente'
                WHEN 2 THEN 'Centro de Costo Específico'
                WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
                ELSE 'N/A'
            END 'OBTENER CC'
        FROM INDIGO036.Contract.CUPSEntity AS CUPS
        INNER JOIN INDIGO036.Billing.BillingGroup AS BG ON BG.Id = CUPS.BillingGroupId
        INNER JOIN INDIGO036.Billing.BillingConcept AS BC ON BC.Id = CUPS.BillingConceptId
        INNER JOIN INDIGO036.Contract.CupsSubgroup AS CSG ON CSG.Id = CUPS.CUPSSubGroupId
        INNER JOIN INDIGO036.Contract.CupsGroup AS CGC ON CGC.Id = CSG.CupsGroupId
    ),
    CTE_PRODUCTOS AS (
        SELECT
            IPR.Id,
            IPR.Code,
            IPR.Name,
            PG.Code 'CODIGO PRODUCTO',
            PG.Name 'GRUPO PRODUCTO',
            PSG.Code 'CODIGO SUBGRUPO',
            PSG.Name 'SUBGRUPO PRODUCTO',
            BG.Code 'CODIGO FACTURACION',
            BG.Name 'GRUPO FACTURACION',
            CASE PT.Class
                WHEN '2' THEN 'MEDICAMENTOS'
                WHEN '3' THEN 'INSUMOS'
                ELSE 'SERVICIOS'
            END AS [TIPO REGISTRO]
        FROM INDIGO036.Inventory.InventoryProduct AS IPR
        INNER JOIN INDIGO036.Inventory.ProductGroup AS PG ON PG.Id = IPR.ProductGroupId
        INNER JOIN INDIGO036.Inventory.ProductSubGroup AS PSG ON PSG.Id = IPR.ProductSubGroupId
        INNER JOIN INDIGO036.Inventory.ProductType AS PT ON IPR.ProductTypeId = PT.Id
        LEFT  JOIN INDIGO036.Billing.BillingGroup AS BG ON BG.Id = IPR.BillingGroupId
    ),
    CTE_IPS AS (
        SELECT
            IPS.Id,
            IPS.Code,
            IPS.Name,
            CASE IPS.ServiceClass
                WHEN 1 THEN 'Ninguno'
                WHEN 2 THEN 'Cirujano'
                WHEN 3 THEN 'Anestesiologo'
                WHEN 4 THEN 'Ayudante'
                WHEN 5 THEN 'Derecho Sala'
                WHEN 6 THEN 'Materiales Sutura'
                WHEN 7 THEN 'Instrumentacion Quirurgica'
                ELSE 'Ninguno'
            END 'TIPO SERVICIO IPS',
            BC.Code 'CODIGO CONCEPTO',
            BC.Name 'CONCEPTO FACTURACION IPS QX',
            CASE ObtainCostCenter
                WHEN 1 THEN 'Unidad Funcional del Paciente'
                WHEN 2 THEN 'Centro de Costo Específico'
                WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
                ELSE 'N/A'
            END 'OBTENER CC'
        FROM INDIGO036.Contract.IPSService AS IPS
        LEFT  JOIN INDIGO036.Billing.BillingConcept AS BC ON BC.Id = IPS.BillingConceptId
    ),
    CTE_FACTURADOS_TOTAL_UNICOS AS (
        SELECT DISTINCT
            JV.EntityId,
            CAST(JV.VoucherDate AS DATE) VoucherDate,
            SUM(CAST(JVD.CreditValue AS NUMERIC(18,2))) Valor_Credito,
            F.AdmissionNumber,
            F.InvoiceNumber,
            JV.Consecutive,
            JVT.Code + ' - ' + JVT.Name 'TIPO COMPROBANTE',
            C.Name 'CIUDAD',
            F.OutputDiagnosis 'CIE10',
            DIA.NOMDIAGNO 'DIAGNOSTICO',
            CASE F.Status WHEN 1 THEN 'FACTURADO' WHEN 2 THEN 'ANULADO' END 'ESTADO FACTURACION',
            CAST(F.AnnulmentDate AS DATE) 'FECHA ANULACION',
            F.InvoicedUser,
            F.AnnulmentUser
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
        INNER JOIN INDIGO036.Billing.Invoice AS F ON F.Id = JV.EntityId
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherTypes AS JVT ON JVT.Id = JV.IdJournalVoucher
        INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = F.ThirdPartyId
        INNER JOIN INDIGO036.Common.OperatingUnit AS OU ON OU.Id = F.OperatingUnitId
        INNER JOIN INDIGO036.Common.City AS C ON C.Id = OU.IdCity
        INNER JOIN INDIGO036.dbo.INDIAGNOS AS DIA ON DIA.CODDIAGNO = F.OutputDiagnosis
        -- AJUSTE CLAVE: evitar caída de filas por usuarios inexistentes
        LEFT  JOIN INDIGO036.dbo.SEGusuaru SUF ON SUF.CODUSUARI = F.InvoicedUser
        -- AJUSTE CLAVE: categoría opcional
        LEFT  JOIN INDIGO036.Billing.InvoiceCategories AS IC ON IC.Id = F.InvoiceCategoryId
        LEFT  JOIN INDIGO036.dbo.SEGusuaru SUA ON SUA.CODUSUARI = F.AnnulmentUser
        WHERE CAST(JV.VoucherDate AS DATE) BETWEEN @FECHAINI AND @FECHAFIN
          AND JV.LegalBookId = 1
          AND JV.EntityName = 'Invoice'
          AND JV.IdJournalVoucher = @TIPOFACTURA
        GROUP BY JV.EntityId, CAST(JV.VoucherDate AS DATE), F.AdmissionNumber, F.InvoiceNumber, JV.Consecutive,
                 JVT.Code + ' - ' + JVT.Name, C.Name, F.OutputDiagnosis, DIA.NOMDIAGNO, F.Status,
                 CAST(F.AnnulmentDate AS DATE), F.InvoicedUser, F.AnnulmentUser
    ),
    CTE_PAQUETE_UNICO AS (
        SELECT DISTINCT
            CASE PAC.IPTIPODOC
                WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS'
                WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' WHEN 9 THEN 'CN' WHEN 10 THEN 'CD' WHEN 11 THEN 'SC' WHEN 12 THEN 'PE'
                WHEN 13 THEN 'PT' WHEN 14 THEN 'DE' WHEN 15 THEN 'SI' WHEN 16 THEN 'NI'
            END AS [TIPO IDENTIFICACION],
            I.CUFE,
            CA.NOMCENATE 'CENTRO ATENCION',
            SOD.Id,
            SO.AdmissionNumber,
            I.PatientCode AS IDENTIFICACION,
            RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
            I.AdmissionNumber AS INGRESO,
            CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO/ADMISION],
            CAST(ISNULL(ING.FECHEGRESO, I.OutputDate) AS DATE) AS [FECHA EGRESO/ALTA],
            UNI.[CIE10],
            UNI.[DIAGNOSTICO],
            ING.IAUTORIZA,
            CA.CODIPSSEC 'CODIGO HABILITACION',
            CASE I.Status WHEN 1 THEN 'FACTURADO' WHEN 2 THEN 'ANULADO' END 'ESTADO FACTURACION',
            I.InvoiceNumber AS [NRO FACTURA],
            CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
            UNI.[CIUDAD],
            UNI.[FECHA ANULACION],
            CAST(I.InvoiceDate AS DATE) AS 'FECHA BUSQUEDA',
            CAST(I.InitialDate AS DATE) 'FECHA INGRESO/CORTE FACTURA',
            CAST(I.OutputDate AS DATE) 'FECHA EGRESO/CORTE FACTURA',
            I.TotalInvoice AS [TOTAL FACTURA],
            TP.Nit AS NIT,
            TP.Name AS ENTIDAD,
            CG.Code AS [CODIGO GRUPO ATENCION],
            CG.Name AS [GRUPO ATENCION]
        FROM INDIGO036.Billing.Invoice AS I
        INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS UNI ON UNI.EntityId = I.Id
        INNER JOIN INDIGO036.Billing.InvoiceDetail AS ID ON ID.InvoiceId = I.Id
        INNER JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = ID.ServiceOrderDetailId
        INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = I.AdmissionNumber
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode
        INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = I.ThirdPartyId
        INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = I.CareGroupId
        LEFT  JOIN INDIGO036.dbo.ADCENATEN AS CA ON ING.CODCENATE = CA.CODCENATE
        WHERE SOD.IsPackage = 1
    ),
    CTE_DATOS_FACTURACION AS (
        SELECT
            'CONTABILIDAD INGRESO' AS 'ESTADO CONSOLIDADO',
            'FACTURADO' 'ESTADO REGISTRO',
            I.PatientCode AS IDENTIFICACION,
            RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
            I.AdmissionNumber AS INGRESO,
            CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO/ADMISION],
            CAST(ISNULL(ING.FECHEGRESO, I.OutputDate) AS DATE) AS [FECHA EGRESO/ALTA],
            I.InvoiceNumber AS [NRO FACTURA],
            CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
            I.TotalInvoice AS [TOTAL FACTURA],
            TP.Nit AS NIT,
            TP.Name AS ENTIDAD,
            CG.Code AS [CODIGO GRUPO ATENCION],
            CG.Name AS [GRUPO ATENCION],
            ISNULL(IPR.[TIPO REGISTRO], 'SERVICIO') AS 'TIPO REGISTRO',
            ISNULL(CUPS.[TIPO SERVICIO], IPR.[TIPO REGISTRO]) 'TIPO SERVICIO',
            CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS 'PRESENTACION',
            ISNULL(CUPS.[GRUPO FACTURACION], IPR.[GRUPO FACTURACION]) 'GRUPO FACTURACION',
            CAST(SOD.ServiceDate AS DATE) AS 'FECHA SERVICIO',
            ISNULL(CUPS.Code, IPR.Code) AS 'CUPS/PRODUCTO',
            REPLACE(ISNULL(CUPS.Description, IPR.Name), ',', '') AS 'DESCRIPCION',
            ISNULL(IPSS.Code, 'N/A') AS ' CODIGO SERVICIO IPS',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSS.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION SERVICIO IPS',
            ISNULL(IPSQX.Code, 'N/A') AS 'CODIGO DETALLE QX',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSQX.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION DETALLE QX',
            ISNULL(IPSQX.[TIPO SERVICIO IPS], 'Ninguno') 'TIPO SERVICIO IPS',
            CD.Name 'DESCRIPCION RELACIONADA',
            ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(SOD.RateManualSalePrice AS NUMERIC(18,2))) 'VALOR SERVICIO',
            ISNULL(IDS.InvoicedQuantity, ID.InvoicedQuantity) 'CANTIDAD',
            ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(ID.TotalSalesPrice AS NUMERIC(18,2))) 'VALOR UNITARIO',
            ISNULL(CAST(SOD.CostValue AS NUMERIC(18,2)) * ISNULL(IDS.InvoicedQuantity, ID.InvoicedQuantity), 0) 'COSTO SERVICIO',
            0 'VALOR DETALLE PAQUETE',
            ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(ID.GrandTotalSalesPrice AS NUMERIC(18,2))) 'VALOR DETALLE FACTURA',
            IIF((ID.Presentation = 2 AND ID.SubTotalPatientSalesPrice <> 0),
                CAST(IDS.TotalSalesPrice - ((IDS.TotalSalesPrice * (ID.SubTotalPatientSalesPrice / ID.GrandTotalSalesPrice))) AS NUMERIC(18,2)),
                ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(ID.ThirdPartySalesPrice AS NUMERIC(18,2)))
            ) 'VALOR ENTIDAD',
            IIF((ID.Presentation = 2 AND ID.SubTotalPatientSalesPrice <> 0),
                CAST((IDS.TotalSalesPrice * (ID.SubTotalPatientSalesPrice / ID.GrandTotalSalesPrice)) AS NUMERIC(18,2)),
                CAST(ID.SubTotalPatientSalesPrice AS NUMERIC(18,2))
            ) 'VALOR PACIENTE',
            CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',
            CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
            '' 'CODIGO PAQUETE',
            '' 'NOMBRE PAQUETE',
            CASE SOD.SettlementType WHEN 3 THEN 'SI (No se cobra nada)' ELSE 'NO (Se cobra)' END 'SERVICIO INCLUIDO',
            CUPSI.Code 'CUPS QUE INCLUYE',
            CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            SO.Id 'ID_CABECERA',
            SOD.Id 'ID_DETALLE'
        FROM INDIGO036.Billing.Invoice AS I
        INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS UNI ON UNI.EntityId = I.Id
        INNER JOIN INDIGO036.Billing.InvoiceDetail AS ID ON ID.InvoiceId = I.Id
        INNER JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = ID.ServiceOrderDetailId
        INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
        INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = CAST(I.AdmissionNumber AS CHAR)
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode
        INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = I.ThirdPartyId
        INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = I.CareGroupId
        LEFT  JOIN INDIGO036.dbo.ADCENATEN AS CA ON ING.CODCENATE = CA.CODCENATE
        LEFT  JOIN CTE_CUPS AS CUPS ON CUPS.Id = SOD.CUPSEntityId
        LEFT  JOIN CTE_PRODUCTOS AS IPR ON IPR.Id = SOD.ProductId
        LEFT  JOIN CTE_IPS AS IPSS ON IPSS.Id = SOD.IPSServiceId
        LEFT  JOIN INDIGO036.Billing.InvoiceDetailSurgical AS IDS ON IDS.InvoiceDetailId = ID.Id AND IDS.OnlyMedicalFees = '0'
        LEFT  JOIN CTE_IPS AS IPSQX ON IPSQX.Id = IDS.IPSServiceId
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId AND SOD.CUPSEntityId = DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
        LEFT  JOIN CTE_CUPS AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
        LEFT  JOIN INDIGO036.Payroll.CostCenter AS CC ON CC.Id = ISNULL(IDS.CostCenterId, SOD.CostCenterId)
        LEFT  JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = ISNULL(IDS.IncomeMainAccountId, SOD.IncomeMainAccountId)
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MEDQX ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPQX ON ESPQX.CODESPECI = MEDQX.CODESPEC1

        UNION ALL

        SELECT
            'CONTABILIDAD INGRESO','FACTURADO',
            UNI.[IDENTIFICACION], UNI.[PACIENTE], UNI.[INGRESO],
            UNI.[FECHA INGRESO/ADMISION], UNI.[FECHA EGRESO/ALTA],
            UNI.[NRO FACTURA], UNI.[FECHA FACTURA], UNI.[TOTAL FACTURA],
            UNI.[NIT], UNI.[ENTIDAD], UNI.[CODIGO GRUPO ATENCION], UNI.[GRUPO ATENCION],
            ISNULL(IPR.[TIPO REGISTRO],'SERVICIO'),
            ISNULL(CUPS.[TIPO SERVICIO],IPR.[TIPO REGISTRO]),
            CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END,
            ISNULL(CUPS.[GRUPO FACTURACION],IPR.[GRUPO FACTURACION]),
            CAST(SOD.ServiceDate AS DATE),
            ISNULL(CUPS.Code,IPR.Code),
            REPLACE(ISNULL(CUPS.Description,IPR.Name), ',', ''),
            ISNULL(IPSS.Code,'N/A'),
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSS.Name),'N/A'),1,60), ',', ''),
            ISNULL(IPSQX.Code,'N/A'),
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSQX.Name),'N/A'),1,60), ',', ''),
            ISNULL(IPSQX.[TIPO SERVICIO IPS],'Ninguno'),
            CD.Name,
            ISNULL(CAST(SODS.RateManualSalePrice AS NUMERIC(18,2)),CAST(SOD.RateManualSalePrice AS NUMERIC(20,2))),
            ISNULL(SODS.InvoicedQuantity,SOD.InvoicedQuantity),
            ISNULL(CAST(SODS.TotalSalesPrice AS NUMERIC(18,2)),CAST(SOD.TotalSalesPrice AS NUMERIC(20,2))),
            ISNULL(CAST(SOD.CostValue AS NUMERIC(18,2)) * ISNULL(SODS.InvoicedQuantity,SOD.InvoicedQuantity),0),
            IIF(SOD.Packaging=0,0,ISNULL(CAST(SODS.TotalSalesPrice AS NUMERIC(18,2)),CAST(SOD.GrandTotalSalesPrice AS NUMERIC(18,2)))),
            0, 0,  -- VALOR DETALLE FACTURA, VALOR ENTIDAD
            0,
            CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END,
            CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END,
            '' , '',
            CASE SOD.SettlementType WHEN 3 THEN 'SI (No se cobra nada)' ELSE 'NO (Se cobra)' END,
            CUPSI.Code, CUPSI.Description,
            SO.Id, SOD.Id
        FROM INDIGO036.Billing.ServiceOrderDetail AS SOD
        INNER JOIN CTE_PAQUETE_UNICO AS UNI ON UNI.Id = SOD.PackageServiceOrderDetailId
        INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
        INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON CAST(ING.NUMINGRES AS CHAR) = CAST(SO.AdmissionNumber AS CHAR)
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetailSurgical SODS ON SODS.ServiceOrderDetailId = SOD.Id
        LEFT  JOIN CTE_CUPS AS CUPS ON CUPS.Id = SOD.CUPSEntityId
        LEFT  JOIN CTE_PRODUCTOS AS IPR ON IPR.Id = SOD.ProductId
        LEFT  JOIN CTE_IPS AS IPSS ON IPSS.Id = SOD.IPSServiceId
        LEFT  JOIN CTE_IPS AS IPSQX ON IPSQX.Id = SODS.IPSServiceId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODP ON SODP.Id = SOD.PackageServiceOrderDetailId
        LEFT  JOIN CTE_CUPS AS CUPSP ON CUPSP.Id = SODP.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId AND SOD.CUPSEntityId = DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Payroll.CostCenter AS CC ON CC.Id = ISNULL(SODS.CostCenterId, SOD.CostCenterId)
        LEFT  JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = ISNULL(SODS.IncomeMainAccountId, SOD.IncomeMainAccountId)
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
        LEFT  JOIN CTE_CUPS AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
        LEFT  JOIN INDIGO036.dbo.SEGusuaru SUSO ON SUSO.CODUSUARI = SO.CreationUser
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MEDQX ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPQX ON ESPQX.CODESPECI = MEDQX.CODESPEC1
    ),
    CTE_RECONOCIMIENTO_UNICO AS (
        SELECT DISTINCT JV.Id, JV.EntityId, CAST(JV.VoucherDate AS DATE) VoucherDate, SUM(CAST(JVD.CreditValue AS NUMERIC(18,2))) Valor_Credito
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
        INNER JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = JVD.IdMainAccount
        WHERE CAST(JV.VoucherDate AS DATE) BETWEEN @FECHAINI AND @FECHAFIN
          AND JV.LegalBookId = 1 AND JV.EntityName = 'RevenueRecognition'
          AND JV.IdJournalVoucher = @RECONOCIMIENTO AND MA.Number LIKE '4%'
        GROUP BY JV.Id, JV.EntityCode, JV.EntityId, CAST(JV.VoucherDate AS DATE)
    ),
    CTE_DATOS_RECONOCIMIENTO AS (
        SELECT
            'CONTABILIDAD INGRESO' AS 'ESTADO CONSOLIDADO','RECONOCIDO' 'ESTADO REGISTRO',
            PAC.IPCODPACI 'IDENTIFICACION', RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
            ING.NUMINGRES 'INGRESO', CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO', CAST(ING.FECHEGRESO AS DATE) [FECHA EGRESO/ALTA],
            'N/A' 'NRO FACTURA', NULL 'FECHA FACTURA', '0' 'TOTAL FACTURA', TP.Nit AS NIT, TP.Name AS ENTIDAD,
            CG.Code AS [CODIGO GRUPO ATENCION], CG.Name AS [GRUPO ATENCION],
            ISNULL(IPR.[TIPO REGISTRO], 'SERVICIO') AS 'TIPO REGISTRO',
            ISNULL(CUPS.[TIPO SERVICIO], IPR.[TIPO REGISTRO]) 'TIPO SERVICIO',
            CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS 'PRESENTACION',
            ISNULL(CUPS.[GRUPO FACTURACION], IPR.[GRUPO FACTURACION]) 'GRUPO FACTURACION',
            CAST(SOD.ServiceDate AS DATE) 'FECHA SERVICIO',
            ISNULL(CUPS.Code, IPR.Code) AS 'CUPS/PRODUCTO',
            REPLACE(ISNULL(CUPS.Description, IPR.Name), ',', '') AS 'DESCRIPCION',
            ISNULL(IPSS.Code, 'N/A') AS ' CODIGO SERVICIO IPS',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSS.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION SERVICIO IPS',
            ISNULL(IPSQX.Code, 'N/A') AS 'CODIGO DETALLE QX',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSQX.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION DETALLE QX',
            ISNULL(IPSQX.[TIPO SERVICIO IPS], 'Ninguno') 'TIPO SERVICIO IPS',
            CD.Name 'DESCRIPCION RELACIONADA',
            ISNULL(CAST(SODS.RateManualSalePrice AS NUMERIC(18,2)), CAST(RRD.RateManualSalePrice AS NUMERIC(20,2))) 'VALOR SERVICIO',
            ISNULL(SODS.InvoicedQuantity, RRD.InvoicedQuantity) 'CANTIDAD',
            ISNULL(CAST(SODS.TotalSalesPrice AS NUMERIC(18,2)), CAST(SOD.TotalSalesPrice AS NUMERIC(20,2))) 'VALOR UNITARIO',
            ISNULL(CAST(SOD.CostValue AS NUMERIC(18,2)) * ISNULL(SODS.InvoicedQuantity, SOD.InvoicedQuantity), 0) 'COSTO SERVICIO',
            IIF(SOD.Packaging = 0, 0, ISNULL(CAST(SODS.TotalSalesPrice AS NUMERIC(18,2)), CAST(RRD.GrandTotalSalesPrice AS NUMERIC(18,2)))) 'VALOR DETALLE PAQUETE',
            ISNULL(CAST(SODS.TotalSalesPrice AS NUMERIC(18,2)), CAST(RRD.GrandTotalSalesPrice AS NUMERIC(18,2))) 'VALOR DETALLE FACTURA',
            0 'VALOR ENTIDAD', 0 'VALOR PACIENTE',
            CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',
            CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
            CUPSP.Code 'CODIGO PAQUETE', CUPSP.Description 'NOMBRE PAQUETE',
            CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado'
                 WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' WHEN 4 THEN '% del mismo servicio' ELSE 'otro' END 'TIPO LIQUIDACION',
            CUPSI.Code 'CUPS QUE INCLUYE', CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            SO.Id 'ID_CABECERA', SOD.Id 'ID_DETALLE'
        FROM INDIGO036.Billing.RevenueRecognition AS RR
        INNER JOIN CTE_RECONOCIMIENTO_UNICO AS UNI ON UNI.EntityId = RR.Id   -- V3
        INNER JOIN INDIGO036.Billing.RevenueRecognitionDetail AS RRD ON RRD.RevenueRecognitionId = RR.Id
        INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = RR.CareGroupId
        INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = RRD.PerformsFunctionalUnitId
        INNER JOIN INDIGO036.Payroll.CostCenter AS COST ON COST.Id = RRD.CostCenterId
        LEFT  JOIN INDIGO036.Contract.Contract AS CON ON CON.Id = CG.ContractId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator AS HA ON HA.Id = CON.HealthAdministratorId
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = ISNULL(HA.ThirdPartyId, RRD.ThirdPartySalesPrice)
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = RRD.ServiceOrderDetailId
        LEFT  JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
        LEFT  JOIN INDIGO036.Billing.RevenueControlDetail AS RCD ON RCD.Id = RRD.RevenueControlDetailId
        LEFT  JOIN INDIGO036.Billing.RevenueControl AS RC ON RC.Id = RCD.RevenueControlId
        LEFT  JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = ISNULL(RRD.AdmissionNumber, ISNULL(SO.AdmissionNumber, RC.AdmissionNumber))
        LEFT  JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = ISNULL(ING.IPCODPACI, ISNULL(SO.PatientCode, RC.PatientCode))
        LEFT  JOIN CTE_CUPS AS CUPS ON CUPS.Id = ISNULL(SOD.CUPSEntityId, RRD.CUPSEntityId)
        LEFT  JOIN CTE_PRODUCTOS AS IPR ON IPR.Id = ISNULL(SOD.ProductId, RRD.ProductId)
        LEFT  JOIN CTE_IPS AS IPSS ON IPSS.Id = ISNULL(SOD.IPSServiceId, RRD.IPSServiceId)
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetailSurgical SODS ON SODS.ServiceOrderDetailId = SOD.Id
        LEFT  JOIN CTE_IPS AS IPSQX ON IPSQX.Id = SODS.IPSServiceId
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId AND SOD.CUPSEntityId = DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODP ON SODP.Id = SOD.PackageServiceOrderDetailId
        LEFT  JOIN INDIGO036.Contract.CUPSEntity AS CUPSP ON CUPSP.Id = SODP.CUPSEntityId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
        LEFT  JOIN INDIGO036.Contract.CUPSEntity AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
    ),
    CTE_ANULADOS_UNICOS AS (
        SELECT DISTINCT JV.EntityId, CAST(JV.VoucherDate AS DATE) VoucherDate, SUM(JVD.CreditValue) Valor_Credito, F.AdmissionNumber
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
        LEFT  JOIN INDIGO036.Billing.Invoice AS F ON F.Id = JV.EntityId
        WHERE CAST(JV.VoucherDate AS DATE) BETWEEN @FECHAINI AND @FECHAFIN
          AND JV.LegalBookId = 1 AND JV.EntityName = 'Invoice' AND JV.IdJournalVoucher = @TIPOANULACION
        GROUP BY JV.Id, JV.EntityCode, JV.EntityId, CAST(JV.VoucherDate AS DATE), F.AdmissionNumber
    ),
    CTE_DATOS_ANULADOS AS (
        SELECT
            'CONTABILIDAD INGRESO' AS 'ESTADO CONSOLIDADO','ANULADO' 'ESTADO REGISTRO',
            I.PatientCode AS IDENTIFICACION, RTRIM(PAC.IPNOMCOMP) AS PACIENTE, I.AdmissionNumber AS INGRESO,
            CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO/ADMISION],
            CAST(ISNULL(ING.FECHEGRESO, I.OutputDate) AS DATE) AS [FECHA EGRESO/ALTA],
            I.InvoiceNumber AS [NRO FACTURA], CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
            I.TotalInvoice * -1 AS [TOTAL FACTURA], TP.Nit AS NIT, TP.Name AS ENTIDAD,
            CG.Code AS [CODIGO GRUPO ATENCION], CG.Name AS [GRUPO ATENCION],
            ISNULL(IPR.[TIPO REGISTRO], 'SERVICIO') AS 'TIPO REGISTRO',
            ISNULL(CUPS.[TIPO SERVICIO], IPR.[TIPO REGISTRO]) 'TIPO SERVICIO',
            CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS 'PRESENTACION',
            ISNULL(CUPS.[GRUPO FACTURACION], IPR.[GRUPO FACTURACION]) 'GRUPO FACTURACION',
            CAST(SOD.ServiceDate AS DATE) AS 'FECHA SERVICIO',
            ISNULL(CUPS.Code, IPR.Code) AS 'CUPS/PRODUCTO',
            REPLACE(ISNULL(CUPS.Description, IPR.Name), ',', '') AS 'DESCRIPCION',
            ISNULL(IPSS.Code, 'N/A') AS ' CODIGO SERVICIO IPS',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSS.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION SERVICIO IPS',
            ISNULL(IPSQX.Code, 'N/A') AS 'CODIGO DETALLE QX',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSQX.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION DETALLE QX',
            ISNULL(IPSQX.[TIPO SERVICIO IPS], 'Ninguno') 'TIPO SERVICIO IPS',
            CD.Name 'DESCRIPCION RELACIONADA',
            (ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(SOD.RateManualSalePrice AS NUMERIC(18,2)))) * -1 'VALOR SERVICIO',
            (ISNULL(IDS.InvoicedQuantity, ID.InvoicedQuantity)) * -1 'CANTIDAD',
            (ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(ID.TotalSalesPrice AS NUMERIC(18,2)))) * -1 'VALOR UNITARIO',
            (ISNULL(CAST(SOD.CostValue AS NUMERIC(18,2)) * ISNULL(IDS.InvoicedQuantity, ID.InvoicedQuantity), 0)) * -1 'COSTO SERVICIO',
            0 * -1 'VALOR DETALLE PAQUETE',
            (ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(ID.GrandTotalSalesPrice AS NUMERIC(18,2)))) * -1 'VALOR DETALLE FACTURA',
            (IIF((ID.Presentation = 2 AND ID.SubTotalPatientSalesPrice <> 0),
                 CAST(IDS.TotalSalesPrice - ((IDS.TotalSalesPrice * (ID.SubTotalPatientSalesPrice / ID.GrandTotalSalesPrice))) AS NUMERIC(18,2)),
                 ISNULL(CAST(IDS.TotalSalesPrice AS NUMERIC(18,2)), CAST(ID.ThirdPartySalesPrice AS NUMERIC(18,2))))) * -1 'VALOR ENTIDAD',
            (IIF((ID.Presentation = 2 AND ID.SubTotalPatientSalesPrice <> 0),
                 CAST((IDS.TotalSalesPrice * (ID.SubTotalPatientSalesPrice / ID.GrandTotalSalesPrice)) AS NUMERIC(18,2)),
                 CAST(ID.SubTotalPatientSalesPrice AS NUMERIC(18,2)))) * -1 'VALOR PACIENTE',
            CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',
            CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
            '' 'CODIGO PAQUETE', '' 'NOMBRE PAQUETE',
            CASE SOD.SettlementType WHEN 3 THEN 'SI (No se cobra nada)' ELSE 'NO (Se cobra)' END 'SERVICIO INCLUIDO',
            CUPSI.Code 'CUPS QUE INCLUYE',
            CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            SO.Id 'ID_CABECERA', SOD.Id 'ID_DETALLE'
        FROM INDIGO036.Billing.Invoice AS I
        INNER JOIN CTE_ANULADOS_UNICOS AS UNI ON UNI.EntityId = I.Id
        INNER JOIN INDIGO036.Billing.InvoiceDetail AS ID ON ID.InvoiceId = I.Id
        INNER JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = ID.ServiceOrderDetailId
        INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
        INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = CAST(I.AdmissionNumber AS CHAR)
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode
        INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = I.ThirdPartyId
        INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = I.CareGroupId
        LEFT  JOIN INDIGO036.dbo.ADCENATEN AS CA ON ING.CODCENATE = CA.CODCENATE
        LEFT  JOIN CTE_CUPS AS CUPS ON CUPS.Id = SOD.CUPSEntityId
        LEFT  JOIN CTE_PRODUCTOS AS IPR ON IPR.Id = SOD.ProductId
        LEFT  JOIN CTE_IPS AS IPSS ON IPSS.Id = SOD.IPSServiceId
        LEFT  JOIN INDIGO036.Billing.InvoiceDetailSurgical AS IDS ON IDS.InvoiceDetailId = ID.Id AND IDS.OnlyMedicalFees = '0'
        LEFT  JOIN CTE_IPS AS IPSQX ON IPSQX.Id = IDS.IPSServiceId
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId AND SOD.CUPSEntityId = DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
        LEFT  JOIN CTE_CUPS AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
        LEFT  JOIN INDIGO036.Payroll.CostCenter AS CC ON CC.Id = ISNULL(IDS.CostCenterId, SOD.CostCenterId)
        LEFT  JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = ISNULL(IDS.IncomeMainAccountId, SOD.IncomeMainAccountId)
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MEDQX ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPQX ON ESPQX.CODESPECI = MEDQX.CODESPEC1
    ),
    CTE_NO_FACTURABLES_UNICOS AS (
        SELECT
            'NO FACTURABLES' AS 'ESTADO CONSOLIDADO','NO FACTURABLES CON CARGOS' 'ESTADO REGISTRO',
            SO.PatientCode 'IDENTIFICACION', RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
            SO.AdmissionNumber 'INGRESO', CAST(ING.IFECHAING AS DATE) [FECHA INGRESO/ADMISION], CAST(ING.FECHEGRESO AS DATE) [FECHA EGRESO/ALTA],
            'N/A' AS [NRO FACTURA], NULL AS [FECHA FACTURA], 0 AS [TOTAL FACTURA],
            TP.Nit AS NIT, TP.Name AS ENTIDAD, CG.Code AS [CODIGO GRUPO ATENCION], CG.Name AS [GRUPO ATENCION],
            ISNULL(IPR.[TIPO REGISTRO], 'SERVICIO') AS 'TIPO REGISTRO',
            ISNULL(CUPS.[TIPO SERVICIO], IPR.[TIPO REGISTRO]) 'TIPO SERVICIO',
            CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS 'PRESENTACION',
            ISNULL(CUPS.[GRUPO FACTURACION], IPR.[GRUPO FACTURACION]) 'GRUPO FACTURACION',
            CAST(SOD.ServiceDate AS DATE) AS 'FECHA SERVICIO',
            ISNULL(CUPS.Code, IPR.Code) AS 'CUPS/PRODUCTO',
            REPLACE(ISNULL(CUPS.Description, IPR.Name), ',', '') AS 'DESCRIPCION',
            ISNULL(IPSS.Code, 'N/A') AS ' CODIGO SERVICIO IPS',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSS.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION SERVICIO IPS',
            ISNULL(IPSQX.Code, 'N/A') AS 'CODIGO DETALLE QX',
            REPLACE(SUBSTRING(ISNULL(RTRIM(IPSQX.Name), 'N/A'), 1, 60), ',', '') AS 'DESCRIPCION DETALLE QX',
            ISNULL(IPSQX.[TIPO SERVICIO IPS], 'Ninguno') 'TIPO SERVICIO IPS',
            CD.Name 'DESCRIPCION RELACIONADA',
            ISNULL(CAST(SODS.RateManualSalePrice AS NUMERIC(18,2)), CAST(SOD.RateManualSalePrice AS NUMERIC(20,2))) 'VALOR SERVICIO',
            ISNULL(SODS.InvoicedQuantity, SOD.InvoicedQuantity) 'CANTIDAD',
            ISNULL(CAST(SODS.TotalSalesPrice AS NUMERIC(18,2)), CAST(SOD.TotalSalesPrice AS NUMERIC(20,2))) 'VALOR UNITARIO',
            ISNULL(CAST(SOD.CostValue AS NUMERIC(18,2)) * ISNULL(SODS.InvoicedQuantity, SOD.InvoicedQuantity), 0) 'COSTO SERVICIO',
            IIF(SOD.Packaging = 0, 0, ISNULL(CAST(SODS.TotalSalesPrice AS NUMERIC(18,2)), CAST(SOD.GrandTotalSalesPrice AS NUMERIC(18,2)))) 'VALOR DETALLE PAQUETE',
            ISNULL(SODS.TotalSalesPrice, SOD.GrandTotalSalesPrice) 'VALOR DETALLE FACTURA',
            0 'VALOR ENTIDAD', 0 'VALOR PACIENTE',
            CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',
            CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
            '' 'CODIGO PAQUETE', '' 'NOMBRE PAQUETE',
            CASE SOD.SettlementType WHEN 3 THEN 'SI (No se cobra nada)' ELSE 'NO (Se cobra)' END 'SERVICIO INCLUIDO',
            CUPSI.Code 'CUPS QUE INCLUYE', CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
            SO.Id 'ID_CABECERA', SOD.Id 'ID_DETALLE'
        FROM INDIGO036.Billing.ServiceOrderDetail AS SOD
        INNER JOIN INDIGO036.Contract.CareGroup CG ON CG.Id = SOD.CareGroupId
        INNER JOIN INDIGO036.Billing.ServiceOrder SO ON SO.Id = SOD.ServiceOrderId
        INNER JOIN INDIGO036.Payroll.FunctionalUnit fu ON fu.Id = SOD.PerformsFunctionalUnitId
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = SO.PatientCode
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = SO.AdmissionNumber
        INNER JOIN INDIGO036.Payroll.CostCenter AS COST ON COST.Id = SOD.CostCenterId
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = SOD.ThirdPartyId
        LEFT  JOIN CTE_CUPS AS CUPS ON CUPS.Id = SOD.CUPSEntityId
        LEFT  JOIN CTE_PRODUCTOS AS IPR ON IPR.Id = SOD.ProductId
        LEFT  JOIN CTE_IPS AS IPSS ON IPSS.Id = SOD.IPSServiceId
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.Id = SOD.CUPSEntityContractDescriptionId AND SOD.CUPSEntityId = DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetailSurgical AS SODS ON SODS.ServiceOrderDetailId = SOD.Id AND SODS.OnlyMedicalFees = '0' AND SODS.SurchargeApply <> 1
        LEFT  JOIN CTE_IPS AS IPSQX ON IPSQX.Id = SODS.IPSServiceId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODP ON SODP.Id = SOD.PackageServiceOrderDetailId
        LEFT  JOIN INDIGO036.Contract.CUPSEntity AS CUPSP ON CUPSP.Id = SODP.CUPSEntityId
        LEFT  JOIN INDIGO036.Billing.ServiceOrderDetail AS SODI ON SODI.Id = SOD.IncludeServiceOrderDetailId
        LEFT  JOIN INDIGO036.Contract.CUPSEntity AS CUPSI ON CUPSI.Id = SODI.CUPSEntityId
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TPT ON TPT.Id = SOD.PerformsHealthProfessionalThirdPartyId
        LEFT  JOIN INDIGO036.dbo.INPROFSAL AS MEDQX ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
        LEFT  JOIN INDIGO036.dbo.INESPECIA AS ESPQX ON ESPQX.CODESPECI = MEDQX.CODESPEC1
        WHERE CG.LiquidationType = 2 AND CAST(SOD.ServiceDate AS DATE) BETWEEN @FECHAINI AND @FECHAFIN AND SO.Status <> 3
    ),
    CTE_NO_FACTURABLE_JUSTIFICADO AS (
        SELECT 'NO FACTURABLES JUSTIFICADOS' AS 'ESTADO CONSOLIDADO', J.Description  'ESTADO REGISTRO',TER.IPCODPACI 'IDENTIFICACION',RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
               TER.NUMINGRES'INGRESO',CAST(ING.IFECHAING AS DATE) [FECHA INGRESO/ADMISION],CAST(ING.FECHEGRESO AS DATE) [FECHA EGRESO/ALTA], 'N/A' AS [NRO FACTURA],
               NULL AS [FECHA FACTURA],0 AS [TOTAL FACTURA],TP.Nit AS NIT,TP.Name AS ENTIDAD,CG.Code AS [CODIGO GRUPO ATENCION],CG.Name AS [GRUPO ATENCION],
               'SERVICIO' AS 'TIPO REGISTRO',CUPS.[TIPO SERVICIO] 'TIPO SERVICIO','NO QUIRURGICO' 'PRESENTACION', CUPS.[GRUPO FACTURACION] 'GRUPO FACTURACION',
               CAST(TER.FECREGSIS AS DATE) AS 'FECHA SERVICIO', CUPS.Code AS 'CUPS/PRODUCTO',REPLACE(CUPS.Description, ',', '')  AS 'DESCRIPCION',
               'N/A' 'CODIGO SERVICIO IPS','N/A' 'DESCRIPCION SERVICIO IPS','N/A' 'CODIGO DETALLE QX','N/A' 'DESCRIPCION DETALLE QX',
               'Ninguno' 'TIPO SERVICIO IPS',CD.Name 'DESCRIPCION RELACIONADA',
               0 'VALOR SERVICIO',1 'CANTIDAD',0 'VALOR UNITARIO',0 'COSTO SERVICIO',0 'VALOR DETALLE PAQUETE',0 'VALOR DETALLE FACTURA',0 'VALOR ENTIDAD',0 'VALOR PACIENTE',
               'NO' 'ES PAQUETE','NO' 'INCLUIDO EN PAQUETE','' 'CODIGO PAQUETE','' 'NOMBRE PAQUETE',
               'NO (Se cobra)' 'SERVICIO INCLUIDO',NULL 'CUPS QUE INCLUYE',NULL 'NOMBRE CUPS QUE INCLUYE',NULL 'ID_CABECERA', NULL 'ID_DETALLE'
        FROM INDIGO036.dbo.HCPROCTER AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.CODCONSEC=JUS.EntityId and EntityName='HCPROCTER'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(FECREGSIS AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCPROCTER'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, TER.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               TER.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(TER.FECRECEXA AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORDPATO AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.AUTO=JUS.EntityId and EntityName='HCORDPATO'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(TER.FECRECEXA AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCORDPATO'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, TER.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               TER.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(TER.FECORDMED AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORDPRON AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.AUTO=JUS.EntityId and EntityName='HCORDPRON'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(TER.FECORDMED AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCORDPRON'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, TER.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               TER.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(TER.FECHAINT AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORDINTE AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.AUTO=JUS.EntityId and EntityName='HCORDINTE'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(TER.FECHAINT AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCORDINTE'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, TER.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               TER.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(TER.FECORDMED AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORDPROQ AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.AUTO=JUS.EntityId and EntityName='HCORDPROQ'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(TER.FECORDMED AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCORDPROQ'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, TER.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               TER.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(TER.FECRECMUE AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORDLABO AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.AUTO=JUS.EntityId and EntityName='HCORDLABO'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(TER.FECRECMUE AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCORDLABO'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, TER.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               TER.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(INF.FECHORINI AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCQXREALI AS TER
        INNER JOIN INDIGO036.dbo.HCQXINFOR INF ON INF.NUMINGRES=TER.NUMINGRES AND INF.IPCODPACI=TER.IPCODPACI AND INF.NUMEFOLIO=TER.NUMEFOLIO
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.CONSECUQX=JUS.EntityId and EntityName='HCQXREALI'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(INF.FECHORINI AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCQXREALI'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, CO.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               CO.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(CO.FECORDMED AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORHEMSER AS TER
        INNER JOIN INDIGO036.dbo.HCORHEMCO CO ON TER.HCORHEMCOID=CO.ID
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =CO.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =CO.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.ID=JUS.EntityId and EntityName='HCORHEMSER'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(CO.FECORDMED AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCORHEMSER'
        UNION ALL
        SELECT 'NO FACTURABLES JUSTIFICADOS', J.Description, TER.IPCODPACI, RTRIM(PAC.IPNOMCOMP),
               TER.NUMINGRES, CAST(ING.IFECHAING AS DATE), CAST(ING.FECHEGRESO AS DATE),'N/A', NULL, 0, TP.Nit, TP.Name, CG.Code, CG.Name,
               'SERVICIO', CUPS.[TIPO SERVICIO], 'NO QUIRURGICO', CUPS.[GRUPO FACTURACION],
               CAST(TER.FECRECEXA AS DATE), CUPS.Code, REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno', CD.Name,
               0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)', NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORDIMAG AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        INNER JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.AUTO=JUS.EntityId and EntityName='HCORDIMAG'
        INNER JOIN INDIGO036.Billing.BillingJustificationControl J ON JUS.JustificationId=J.Id
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(TER.FECRECEXA AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and EntityName='HCORDIMAG'
    ),
    CTE_HC_SIN_CARGOS AS (
        SELECT  'HISTORIA CLINICA SIN CARGOS' AS 'ESTADO CONSOLIDADO','REALIZADO SIN CARGAR'  'ESTADO REGISTRO',TER.IPCODPACI 'IDENTIFICACION',RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
                TER.NUMINGRES'INGRESO',CAST(ING.IFECHAING AS DATE) [FECHA INGRESO/ADMISION],CAST(ING.FECHEGRESO AS DATE) [FECHA EGRESO/ALTA], 'N/A' AS [NRO FACTURA],
                NULL AS [FECHA FACTURA],0 AS [TOTAL FACTURA],TP.Nit AS NIT,TP.Name AS ENTIDAD,CG.Code AS [CODIGO GRUPO ATENCION],CG.Name AS [GRUPO ATENCION],
                'SERVICIO' AS 'TIPO REGISTRO',CUPS.[TIPO SERVICIO] 'TIPO SERVICIO','NO QUIRURGICO' 'PRESENTACION', CUPS.[GRUPO FACTURACION] 'GRUPO FACTURACION',
                CAST(TER.FECREGSIS AS DATE) AS 'FECHA SERVICIO', CUPS.Code AS 'CUPS/PRODUCTO',REPLACE(CUPS.Description, ',', '')  AS 'DESCRIPCION',
                'N/A' 'CODIGO SERVICIO IPS','N/A' 'DESCRIPCION SERVICIO IPS','N/A' 'CODIGO DETALLE QX','N/A' 'DESCRIPCION DETALLE QX',
                'Ninguno' 'TIPO SERVICIO IPS',CD.Name 'DESCRIPCION RELACIONADA',
                0 'VALOR SERVICIO',1 'CANTIDAD',0 'VALOR UNITARIO',0 'COSTO SERVICIO',0 'VALOR DETALLE PAQUETE',0 'VALOR DETALLE FACTURA',0 'VALOR ENTIDAD',0 'VALOR PACIENTE',
                'NO' 'ES PAQUETE','NO' 'INCLUIDO EN PAQUETE','' 'CODIGO PAQUETE','' 'NOMBRE PAQUETE',
                'NO (Se cobra)' 'SERVICIO INCLUIDO',NULL 'CUPS QUE INCLUYE',NULL 'NOMBRE CUPS QUE INCLUYE',NULL 'ID_CABECERA', NULL 'ID_DETALLE'
        FROM INDIGO036.dbo.HCPROCTER AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        LEFT  JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.CODCONSEC=JUS.EntityId and EntityName='HCPROCTER'
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE CAST(FECREGSIS AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and (GENSERVICEORDER is null and JUS.Id is null)

        UNION ALL

        SELECT  'HISTORIA CLINICA SIN CARGOS','REALIZADO SIN CARGAR',
                TER.IPCODPACI,RTRIM(PAC.IPNOMCOMP),TER.NUMINGRES,CAST(ING.IFECHAING AS DATE),CAST(ING.FECHEGRESO AS DATE),
                'N/A',NULL,0,TP.Nit,TP.Name,CG.Code,CG.Name,'SERVICIO',CUPS.[TIPO SERVICIO],'NO QUIRURGICO',CUPS.[GRUPO FACTURACION],
                CAST(TER.FECRECEXA AS DATE),CUPS.Code,REPLACE(CUPS.Description, ',', ''),'N/A','N/A','N/A','N/A','Ninguno',CD.Name,
                0,1,0,0,0,0,0,0,'NO','NO','','','NO (Se cobra)',NULL,NULL,NULL,NULL
        FROM INDIGO036.dbo.HCORDPATO AS TER
        INNER JOIN CTE_CUPS AS CUPS  ON CUPS.Code=TER.CODSERIPS
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =TER.IPCODPACI
        INNER JOIN INDIGO036.dbo.ADINGRESO AS ING  ON ING.NUMINGRES =TER.NUMINGRES
        LEFT  JOIN INDIGO036.Billing.AccountControlJustification JUS ON TER.AUTO=JUS.EntityId and EntityName='HCORDPATO'
        LEFT  JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =IDDESCRIPCIONRELACIONADA  AND CUPS.Id=DESCR.CUPSEntityId
        LEFT  JOIN INDIGO036.Contract.ContractDescriptions AS CD  ON CD.Id=DESCR.ContractDescriptionId
        LEFT  JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id=ING.GENCONENTITY
        LEFT  JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =HA.ThirdPartyId
        LEFT  JOIN INDIGO036.Contract.CareGroup CG ON CG.Id=ING.GENCAREGROUP
        WHERE TER.ESTSERIPS IN (2,3,4)
          AND CAST(TER.FECRECEXA AS DATE) BETWEEN @FECHAINI AND @FECHAFIN
          AND (GENSERVICEORDER IS NULL AND JUS.Id IS NULL)
    )
    SELECT * FROM CTE_DATOS_FACTURACION
    UNION ALL SELECT * FROM CTE_DATOS_RECONOCIMIENTO
    UNION ALL SELECT * FROM CTE_DATOS_ANULADOS
    UNION ALL SELECT * FROM CTE_NO_FACTURABLES_UNICOS
    UNION ALL SELECT * FROM CTE_NO_FACTURABLE_JUSTIFICADO
    UNION ALL SELECT * FROM CTE_HC_SIN_CARGOS;
END;
