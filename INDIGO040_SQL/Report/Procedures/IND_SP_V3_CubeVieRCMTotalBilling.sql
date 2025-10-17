-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V3_CubeVieRCMTotalBilling
-- Extracted by Fabric SQL Extractor SPN v3.9.0


---- ***** SCRIP CONSOLIDADO CABECERA FACTURACION ***** -----

CREATE PROCEDURE [Report].[IND_SP_V3_CubeVieRCMTotalBilling] 
@ANO AS INT,
@MES AS INT
AS

--DECLARE @ANO AS INT = YEAR(COMMON.GETDATE());
--DECLARE @MES AS INT = MONTH(COMMON.GETDATE());

------- ************************************************ SE VALIDA QUE CLIENTE ES PARA ASI SACAR EL ID DE LA CUENTA **********************************************************--

DECLARE @ID_COMPANY VARCHAR(9)=(CAST(DB_NAME() AS VARCHAR(9)));
DECLARE @TIPOFACTURA INT,@TIPOANULACION INT,@RECONOCIMIENTO INT,@TIPOFACTURABASICA INT
IF @ID_COMPANY='INDIGO036' BEGIN SET @TIPOFACTURA=116 SET @TIPOANULACION=14 SET @RECONOCIMIENTO=53 END --HOMI
IF @ID_COMPANY='INDIGO039' BEGIN SET @TIPOFACTURA=50 SET @TIPOANULACION=51 SET @RECONOCIMIENTO=55 END --SIEGOS Y SORDOS
IF @ID_COMPANY='INDIGO040' BEGIN SET @TIPOFACTURA=29 SET @TIPOANULACION=30 SET @RECONOCIMIENTO=92 SET @TIPOFACTURABASICA=90 END--HOSPITAL SAN JOSE
IF @ID_COMPANY='INDIGO041' BEGIN SET @TIPOFACTURA=68 SET @TIPOANULACION=69 SET @RECONOCIMIENTO=73 END; --SAN FRANCISCO
IF @ID_COMPANY='INDIGO043' BEGIN SET @TIPOFACTURA=27 SET @TIPOANULACION=26 SET @RECONOCIMIENTO=46 END; --SAN ANTONIO DE PITALITO


--*****************************************************************************************************************************************************************************--
--*************************************************************** SEGMENTO FACTURAS GENERADAS *********************************************************************************--
--*****************************************************************************************************************************************************************************--

--****************CTE PARA SACAR LAS FACTURAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA******************************--

WITH CTE_FACTURADOS_TOTAL_UNICOS
AS
(
	SELECT DISTINCT JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,AdmissionNumber, F.InvoiceNumber,JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME 'TIPO COMPROBANTE'
	FROM GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
	INNER  JOIN Billing .Invoice AS F  ON F.Id =JV.EntityId
	INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	WHERE YEAR(JV.VoucherDate) =@ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='Invoice' AND IdJournalVoucher=@TIPOFACTURA
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME
),

--****************CTE PARA SACAR LAS FACTURAS CAPITA DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA******************************--

CTE_FACTURADOS_CAPITADOS_TOTAL_UNICOS
AS
(
	SELECT DISTINCT JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,AdmissionNumber, F.InvoiceNumber,JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME 'TIPO COMPROBANTE'
	FROM GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
	INNER  JOIN Billing.Invoice AS F  ON F.Id =JV.EntityId
	INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	INNER JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =JVD.IdMainAccount
	WHERE YEAR(JV.VoucherDate) =@ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='InvoiceEntityCapitated' AND IdJournalVoucher=@TIPOFACTURA
	AND MA.Number BETWEEN '41000000' AND '41999999'
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME
),

--****************CTE PARA SACAR LAS FACTURAS BÁSICAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA******************************--

CTE_FACTURA_BASICA_UNICOS
AS
(
 	SELECT DISTINCT JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito, AdmissionNumber,I.InvoiceNumber,JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME 'TIPO COMPROBANTE'
	FROM GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
	INNER JOIN Billing.BasicBilling AS BB  ON BB.Id =JV.EntityId
	INNER JOIN Billing.Invoice AS I ON I.Id =BB.InvoiceId
	INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	WHERE YEAR(JV.VoucherDate) =@ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='BasicBilling' AND IdJournalVoucher=90--@TIPOFACTURABASICA
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE), AdmissionNumber,I.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME


),   
--*************************************** CTE TRAE LOS DATOS DEL ALTA MEDICA DE LAS FACTURAS A NIVEL DE CABECERA DE FACTURA ********************************************************--

CTE_ALTA_MEDICA_FACTURADOS
AS
(
	SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION',EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM HCREGEGRE EGR 
	INNER JOIN
	( SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA'  
	  FROM DBO.HCREGEGRE EGR 
	  INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS ING  ON EGR.NUMINGRES=ING.AdmissionNumber  
	  GROUP BY EGR.NUMINGRES,EGR.IPCODPACI
	)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
),

--****************CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO FACTURA********************--

CTE_FACTURADO_TOTAL_UNICO_GLOBAL
AS
(
   SELECT DISTINCT 'OPERACIONAL' 'TIPO VENTA' ,'FACTURADO' AS ESTADO, YEAR(UNI.VoucherDate) AS AÑO, MONTH(UNI.VoucherDate) AS MES,  DAY(UNI.VoucherDate) AS DIA, TP.Nit AS NIT,
   TP.Name AS ENTIDAD, CG.Code AS [CODIGO GRUPO ATENCION], CG.Name AS [GRUPO ATENCION], CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado'
   WHEN 3 THEN 'ET Vinculados Municipios' WHEN 4 THEN 'ET Vinculados Departamentos' WHEN 5 THEN 'ARL Riesgos Laborales' WHEN 6 THEN 'MP Medicina Prepagada'
   WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito' WHEN 11 THEN 'Fosyga' WHEN 12 THEN 'Otros'
   WHEN 13 THEN 'Aseguradoras' WHEN 99 THEN 'Particulares' ELSE 'Otros' END 'REGIMEN',
   I.PatientCode AS IDENTIFICACION, RTRIM(PAC.IPNOMCOMP) AS PACIENTE,   I.AdmissionNumber AS INGRESO, CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(ISNULL(ALT.[FECHA ALTA MEDICA],ING.IFECHAING) AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA], CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],CAST(I.InvoiceValue AS NUMERIC) 'VALOR SIN IVA',
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada'
   WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END 'TIPO FACTURA',ICT.Name 'CATERGORIA FACTURA',
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END [TIPO INGRESO],FUI.NAME 'UNIDAD FUNCIONAL INGRESO',ISNULL(FUE.NAME,FUI.NAME) 'UNIDAD FUNCIONAL EGRESO',
   OutputDiagnosis 'CIE 10',DIA.NOMDIAGNO 'DIAGNOSTICO',SU.NOMUSUARI 'USUARIO FACTURO',NULL 'FECHA ANULACION',NULL 'USUARIO ANULO',
   NULL 'CAUSA ANULACION',CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO', UNI.Consecutive 'CODIGO COMPROBANTE',UNI.[TIPO COMPROBANTE],
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' WHEN 2 THEN 'FEB' WHEN 3 THEN 'MAR' WHEN 4 THEN 'ABR' WHEN 5 THEN 'MAY' WHEN 6 THEN 'JUN' WHEN 7 THEN 'JUL' WHEN 8 THEN 'AGO'
   WHEN 9 THEN 'SEP' WHEN 10 THEN 'OCT' WHEN 11 THEN 'NOV' WHEN 12 THEN 'DIC' END 'MES AÑO',   
   (CASE DATENAME(dw,UNI.VoucherDate) when 'Monday' then 'LUN' when 'Tuesday' then 'MAR' when 'Wednesday' then 'MIE' when 'Thursday' then 'JUE' when 'Friday' then 'VIE'
     when 'Saturday' then 'SAB' when 'Sunday' then 'DOM' END) 'DIA SEMANA', 1 'CANTIDAD',
   I.ID InvoiceId , CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) 'Idunique' 
   FROM Billing.Invoice AS I
   INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS UNI  ON UNI.EntityId =I.Id
   INNER JOIN Billing.InvoiceDetail AS ID  ON ID.InvoiceId =I.Id
   INNER JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id =ID.ServiceOrderDetailId
   INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId
   INNER JOIN Payroll.FunctionalUnit AS FU  ON FU.Id = SOD.PerformsFunctionalUnitId
   INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
   INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   INNER JOIN dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
   LEFT JOIN Inventory.InventoryProduct AS IPR  ON IPR.Id = SOD.ProductId
   LEFT JOIN Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
   LEFT JOIN Contract.ContractDescriptions AS CD  ON CD.ID=DESCR.ContractDescriptionId
   LEFT JOIN Billing .ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
   LEFT JOIN Billing .ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
   LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
   LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
   LEFT JOIN Billing.InvoiceDetailSurgical AS IDS  ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
   LEFT JOIN Contract.IPSService AS IPS  ON IPS.Id =IDS.IPSServiceId 
   LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
   LEFT JOIN GeneralLedger.MainAccounts AS MA  ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
   LEFT JOIN Payroll.FunctionalUnit AS FUI  ON FUI.CODE = ING.UFUCODIGO
   LEFT JOIN Payroll.FunctionalUnit AS FUE  ON FUE.CODE = ING.UFUEGRMED
   LEFT JOIN DBO.INDIAGNOS AS DIA ON DIA.CODDIAGNO= I.OutputDiagnosis
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = i.InvoicedUser
   LEFT JOIN Billing.BillingReversalReason AS BRR ON BRR.Id=I.ReversalReasonId
   LEFT JOIN CTE_ALTA_MEDICA_FACTURADOS AS ALT  ON ALT.INGRESO =I.AdmissionNumber
   LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId

),

--****************CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS CAPITA, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA********************--

CTE_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL
AS
(

  SELECT  DISTINCT  'OPERACIONAL' 'TIPO VENTA', 'FACTURADO' AS ESTADO, YEAR(UNI.VoucherDate) AS AÑO, MONTH(UNI.VoucherDate) AS MES,  DAY(UNI.VoucherDate) AS DIA, TP.Nit AS NIT,
   TP.Name AS ENTIDAD, CG.Code AS [CODIGO GRUPO ATENCION], CG.Name AS [GRUPO ATENCION], CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado'
   WHEN 3 THEN 'ET Vinculados Municipios' WHEN 4 THEN 'ET Vinculados Departamentos' WHEN 5 THEN 'ARL Riesgos Laborales' WHEN 6 THEN 'MP Medicina Prepagada'
   WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito' WHEN 11 THEN 'Fosyga' WHEN 12 THEN 'Otros'
   WHEN 13 THEN 'Aseguradoras' WHEN 99 THEN 'Particulares' ELSE 'Otros' END 'REGIMEN' ,
   '00000000' AS IDENTIFICACION, 'FACTURA CAPITA' AS PACIENTE,   '00000000' AS INGRESO, CAST(IEC.InitialDate AS  DATE) AS [FECHA INGRESO],
   CAST(IEC.EndDate AS date) [FECHA EGRESO], I.InvoiceNumber AS [NRO FACTURA],CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA], CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],CAST(I.InvoiceValue AS NUMERIC) 'VALOR SIN IVA', 
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada'
   WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END 'TIPO FACTURA',ICT.Name 'CATERGORIA FACTURA',
   'CAPITA' [TIPO INGRESO],'' 'UNIDAD FUNCIONAL INGRESO','' 'UNIDAD FUNCIONAL EGRESO',
   '' 'CIE 10','' 'DIAGNOSTICO',SU.NOMUSUARI 'USUARIO FACTURO',NULL 'FECHA ANULACION',NULL 'USUARIO ANULO',
   NULL 'CAUSA ANULACION',NULL AS 'FECHA NACIMIENTO',   UNI.Consecutive 'CODIGO COMPROBANTE',UNI.[TIPO COMPROBANTE], 
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' WHEN 2 THEN 'FEB' WHEN 3 THEN 'MAR' WHEN 4 THEN 'ABR' WHEN 5 THEN 'MAY' WHEN 6 THEN 'JUN' WHEN 7 THEN 'JUL' WHEN 8 THEN 'AGO'
   WHEN 9 THEN 'SEP' WHEN 10 THEN 'OCT' WHEN 11 THEN 'NOV' WHEN 12 THEN 'DIC' END 'MES AÑO',   
  (CASE DATENAME(dw,UNI.VoucherDate) when 'Monday' then 'LUN' when 'Tuesday' then 'MAR' when 'Wednesday' then 'MIE' when 'Thursday' then 'JUE' when 'Friday' then 'VIE'
   when 'Saturday' then 'SAB' when 'Sunday' then 'DOM' END) 'DIA SEMANA', 1 'CANTIDAD',  
   I.ID InvoiceId,  CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + Rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) 'Idunique'
   FROM Billing.Invoice AS I
   INNER JOIN Billing.InvoiceEntityCapitated  IEC  ON IEC.InvoiceId =I.Id
   INNER JOIN CTE_FACTURADOS_CAPITADOS_TOTAL_UNICOS AS UNI  ON UNI.EntityId =IEC.Id
   INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   LEFT JOIN DBO.INDIAGNOS AS DIA ON DIA.CODDIAGNO= I.OutputDiagnosis
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = i.InvoicedUser
   LEFT JOIN Billing.BillingReversalReason AS BRR ON BRR.Id=I.ReversalReasonId
   LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId

),

--********CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS BASICAS NO OPERACIONAL, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA**********--

CTE_FACTURADO_BASICA_TOTAL_UNICO_GLOBAL
AS
(
 SELECT DISTINCT  'NO OPERACIONAL' 'TIPO VENTA', 'FACTURADO' AS ESTADO, YEAR(UNI.VoucherDate) AS AÑO, MONTH(UNI.VoucherDate) AS MES,  DAY(UNI.VoucherDate) AS DIA, TP.Nit AS NIT,
   TP.Name AS ENTIDAD, 'NO_OPERA' AS [CODIGO GRUPO ATENCION], 'NO OPERACIONAL' AS [GRUPO ATENCION], 'Otros' 'REGIMEN' ,
   '00000000' AS IDENTIFICACION, 'FACTURA CAPITA' AS PACIENTE,   '00000000' AS INGRESO, CAST(I.InvoiceDate AS  DATE) AS [FECHA INGRESO],
   CAST(I.InvoiceDate AS date) [FECHA EGRESO], I.InvoiceNumber AS [NRO FACTURA],CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA], CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],CAST(I.InvoiceValue AS NUMERIC) 'VALOR SIN IVA',
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada'
   WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END 'TIPO FACTURA','NO OPERACIONAL' 'CATERGORIA FACTURA',
   'CAPITA' [TIPO INGRESO],'' 'UNIDAD FUNCIONAL INGRESO','' 'UNIDAD FUNCIONAL EGRESO',
   '' 'CIE 10','' 'DIAGNOSTICO',SU.NOMUSUARI 'USUARIO FACTURO',NULL 'FECHA ANULACION',NULL 'USUARIO ANULO',
   NULL 'CAUSA ANULACION',NULL AS 'FECHA NACIMIENTO',   UNI.Consecutive 'CODIGO COMPROBANTE',UNI.[TIPO COMPROBANTE],
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' WHEN 2 THEN 'FEB' WHEN 3 THEN 'MAR' WHEN 4 THEN 'ABR' WHEN 5 THEN 'MAY' WHEN 6 THEN 'JUN' WHEN 7 THEN 'JUL' WHEN 8 THEN 'AGO'
   WHEN 9 THEN 'SEP' WHEN 10 THEN 'OCT' WHEN 11 THEN 'NOV' WHEN 12 THEN 'DIC' END 'MES AÑO', 
   (CASE DATENAME(dw,UNI.VoucherDate) when 'Monday' then 'LUN' when 'Tuesday' then 'MAR' when 'Wednesday' then 'MIE' when 'Thursday' then 'JUE' when 'Friday' then 'VIE'
   when 'Saturday' then 'SAB' when 'Sunday' then 'DOM' END) 'DIA SEMANA', 1 'CANTIDAD',
   I.ID InvoiceId , CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + Rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) 'Idunique'
   FROM Billing.BasicBilling AS BB
   INNER JOIN CTE_FACTURA_BASICA_UNICOS AS UNI  ON UNI.EntityId =BB.Id
   INNER JOIN Billing.Invoice AS I   ON I.Id =BB.InvoiceId
   INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   LEFT JOIN DBO.INDIAGNOS AS DIA ON DIA.CODDIAGNO= I.OutputDiagnosis
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = i.InvoicedUser
   LEFT JOIN Billing.BillingReversalReason AS BRR ON BRR.Id=I.ReversalReasonId
   LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId
 ),




--*****************************************************************************************************************************************************************************--
--*************************************************************** SEGMENTO FACTURAS ANULADAS GENERADAS ************************************************************************--
--*****************************************************************************************************************************************************************************--

--***************CTE PARA SACAR LAS FACTURAS ANULADAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO ANULACION DE FACTURA*********--

CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS
AS
(
	SELECT DISTINCT JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,AdmissionNumber, F.InvoiceNumber,JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME 'TIPO COMPROBANTE'
	FROM GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
	INNER  JOIN Billing .Invoice AS F  ON F.Id =JV.EntityId
	INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	WHERE YEAR(JV.VoucherDate) =@ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='Invoice' AND IdJournalVoucher=@TIPOANULACION
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME
),

--***************CTE PARA SACAR LAS FACTURAS CAPITAS ANULADAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO ANULACION DE FACTURA*********--

CTE_ANULADOS_FACTURADOS_CAPITA_TOTAL_UNICOS
AS
(
	SELECT DISTINCT JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,AdmissionNumber, F.InvoiceNumber,JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME 'TIPO COMPROBANTE'
	FROM GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
	INNER  JOIN Billing .Invoice AS F  ON F.Id =JV.EntityId
	INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	INNER JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =JVD.IdMainAccount
	WHERE YEAR(JV.VoucherDate) =@ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='InvoiceEntityCapitated' AND IdJournalVoucher=@TIPOANULACION 
	AND MA.Number BETWEEN '41000000' AND '41999999'
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME
),

--******************************* CTE TRAE LOS DATOS DEL ALTA MEDICA DE LAS FACTURAS ANULADAS A NIVEL DE CABECERA DE FACTURA ********************************************************--

CTE_ALTA_MEDICA_FACTURADOS_ANULADOS
AS
(
	SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION',EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM HCREGEGRE EGR 
	INNER JOIN
	( SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA'  
	  FROM DBO.HCREGEGRE EGR 
	  INNER JOIN CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS AS ING  ON EGR.NUMINGRES=ING.AdmissionNumber  
	  GROUP BY EGR.NUMINGRES,EGR.IPCODPACI
	)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
),

--********CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS ANULADAS, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO FACTURA********************--

CTE_ANULADOS_FACTURADO_TOTAL_UNICO_GLOBAL
AS
(
   SELECT DISTINCT  'OPERACIONAL' 'TIPO VENTA' ,'ANULADO' AS ESTADO, YEAR(UNI.VoucherDate) AS AÑO, MONTH(UNI.VoucherDate) AS MES,  DAY(UNI.VoucherDate) AS DIA, TP.Nit AS NIT,
   TP.Name AS ENTIDAD, CG.Code AS [CODIGO GRUPO ATENCION], CG.Name AS [GRUPO ATENCION], CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado'
   WHEN 3 THEN 'ET Vinculados Municipios' WHEN 4 THEN 'ET Vinculados Departamentos' WHEN 5 THEN 'ARL Riesgos Laborales' WHEN 6 THEN 'MP Medicina Prepagada'
   WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito' WHEN 11 THEN 'Fosyga' WHEN 12 THEN 'Otros'
   WHEN 13 THEN 'Aseguradoras' WHEN 99 THEN 'Particulares' ELSE 'Otros' END 'REGIMEN',
   I.PatientCode AS IDENTIFICACION, RTRIM(PAC.IPNOMCOMP) AS PACIENTE,   I.AdmissionNumber AS INGRESO, CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(ISNULL(ALT.[FECHA ALTA MEDICA],ING.IFECHAING) AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],  CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],CAST(I.InvoiceValue AS NUMERIC) 'VALOR SIN IVA',
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada'
   WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END 'TIPO FACTURA',ICT.Name 'CATERGORIA FACTURA',
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END [TIPO INGRESO],FUI.NAME 'UNIDAD FUNCIONAL INGRESO',ISNULL(FUE.NAME,FUI.NAME) 'UNIDAD FUNCIONAL EGRESO',
   OutputDiagnosis 'CIE 10',DIA.NOMDIAGNO 'DIAGNOSTICO',SU.NOMUSUARI 'USUARIO FACTURO',CAST(I.AnnulmentDate AS DATE) 'FECHA ANULACION',SUA.NOMUSUARI 'USUARIO ANULO',
   BRR.Name 'CAUSA ANULACION',CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO', UNI.Consecutive 'CODIGO COMPROBANTE',UNI.[TIPO COMPROBANTE], 
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' WHEN 2 THEN 'FEB' WHEN 3 THEN 'MAR' WHEN 4 THEN 'ABR' WHEN 5 THEN 'MAY' WHEN 6 THEN 'JUN' WHEN 7 THEN 'JUL' WHEN 8 THEN 'AGO'
   WHEN 9 THEN 'SEP' WHEN 10 THEN 'OCT' WHEN 11 THEN 'NOV' WHEN 12 THEN 'DIC' END 'MES AÑO', 
   (CASE DATENAME(dw,UNI.VoucherDate) when 'Monday' then 'LUN' when 'Tuesday' then 'MAR' when 'Wednesday' then 'MIE' when 'Thursday' then 'JUE' when 'Friday' then 'VIE'
   when 'Saturday' then 'SAB' when 'Sunday' then 'DOM' END) 'DIA SEMANA', 1 'CANTIDAD', 
   I.ID InvoiceId , CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) 'Idunique' 
   FROM Billing.Invoice AS I
   INNER JOIN CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS AS UNI  ON UNI.EntityId =I.Id
   INNER JOIN Billing.InvoiceDetail AS ID  ON ID.InvoiceId =I.Id
   INNER JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id =ID.ServiceOrderDetailId
   INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId
   INNER JOIN Payroll.FunctionalUnit AS FU  ON FU.Id = SOD.PerformsFunctionalUnitId
   INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
   INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   INNER JOIN dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
   LEFT JOIN Inventory.InventoryProduct AS IPR  ON IPR.Id = SOD.ProductId
   LEFT JOIN Contract.CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
   LEFT JOIN Contract.ContractDescriptions AS CD  ON CD.ID=DESCR.ContractDescriptionId
   LEFT JOIN Billing .ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
   LEFT JOIN Billing .ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
   LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
   LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
   LEFT JOIN Billing.InvoiceDetailSurgical AS IDS  ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
   LEFT JOIN Contract.IPSService AS IPS  ON IPS.Id =IDS.IPSServiceId 
   LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
   LEFT JOIN GeneralLedger.MainAccounts AS MA  ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
   LEFT JOIN Payroll.FunctionalUnit AS FUI  ON FUI.CODE = ING.UFUCODIGO
   LEFT JOIN Payroll.FunctionalUnit AS FUE  ON FUE.CODE = ING.UFUEGRMED
   LEFT JOIN DBO.INDIAGNOS AS DIA ON DIA.CODDIAGNO= I.OutputDiagnosis
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = i.InvoicedUser
   LEFT JOIN Billing.BillingReversalReason AS BRR ON BRR.Id=I.ReversalReasonId
   LEFT JOIN CTE_ALTA_MEDICA_FACTURADOS_ANULADOS AS ALT  ON ALT.INGRESO =I.AdmissionNumber
   LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId
),

--********CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS CAPITA ANULADAS, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO FACTURA******************--

CTE_ANULADOS_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL
AS
(
  SELECT  DISTINCT  'OPERACIONAL' 'TIPO VENTA','ANULADO' AS ESTADO, YEAR(UNI.VoucherDate) AS AÑO, MONTH(UNI.VoucherDate) AS MES,  DAY(UNI.VoucherDate) AS DIA, TP.Nit AS NIT,
   TP.Name AS ENTIDAD, CG.Code AS [CODIGO GRUPO ATENCION], CG.Name AS [GRUPO ATENCION], CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado'
   WHEN 3 THEN 'ET Vinculados Municipios' WHEN 4 THEN 'ET Vinculados Departamentos' WHEN 5 THEN 'ARL Riesgos Laborales' WHEN 6 THEN 'MP Medicina Prepagada'
   WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito' WHEN 11 THEN 'Fosyga' WHEN 12 THEN 'Otros'
   WHEN 13 THEN 'Aseguradoras' WHEN 99 THEN 'Particulares' ELSE 'Otros' END 'REGIMEN',
   '00000000' AS IDENTIFICACION, 'FACTURA CAPITA' AS PACIENTE,   '00000000' AS INGRESO, CAST(IEC.InitialDate AS  DATE) AS [FECHA INGRESO],
   CAST(IEC.EndDate AS date) [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],  CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],CAST(I.InvoiceValue AS NUMERIC) 'VALOR SIN IVA',
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada'
   WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END 'TIPO FACTURA',ICT.Name 'CATERGORIA FACTURA',
   'CAPITA' [TIPO INGRESO],'' 'UNIDAD FUNCIONAL INGRESO','' 'UNIDAD FUNCIONAL EGRESO',
   '' 'CIE 10','' 'DIAGNOSTICO',SU.NOMUSUARI 'USUARIO FACTURO',CAST(I.AnnulmentDate AS DATE) 'FECHA ANULACION',SUA.NOMUSUARI 'USUARIO ANULO',
   BRR.Name 'CAUSA ANULACION',NULL AS 'FECHA NACIMIENTO', UNI.Consecutive 'CODIGO COMPROBANTE',UNI.[TIPO COMPROBANTE], 
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' WHEN 2 THEN 'FEB' WHEN 3 THEN 'MAR' WHEN 4 THEN 'ABR' WHEN 5 THEN 'MAY' WHEN 6 THEN 'JUN' WHEN 7 THEN 'JUL' WHEN 8 THEN 'AGO'
   WHEN 9 THEN 'SEP' WHEN 10 THEN 'OCT' WHEN 11 THEN 'NOV' WHEN 12 THEN 'DIC' END 'MES AÑO', 
   (CASE DATENAME(dw,UNI.VoucherDate) when 'Monday' then 'LUN' when 'Tuesday' then 'MAR' when 'Wednesday' then 'MIE' when 'Thursday' then 'JUE' when 'Friday' then 'VIE'
   when 'Saturday' then 'SAB' when 'Sunday' then 'DOM' END) 'DIA SEMANA', 1 'CANTIDAD',   
   I.ID InvoiceId , CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) 'Idunique' 
   FROM Billing.Invoice AS I
   INNER JOIN Billing.InvoiceEntityCapitated  IEC  ON IEC.InvoiceId =I.Id
   INNER JOIN CTE_ANULADOS_FACTURADOS_CAPITA_TOTAL_UNICOS AS UNI  ON UNI.EntityId =IEC.Id
   INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   LEFT JOIN DBO.INDIAGNOS AS DIA ON DIA.CODDIAGNO= I.OutputDiagnosis
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = i.InvoicedUser
   LEFT JOIN Billing.BillingReversalReason AS BRR ON BRR.Id=I.ReversalReasonId
   LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId

),

CTE_CONSOLIDADO
AS
(
SELECT * FROM CTE_FACTURADO_TOTAL_UNICO_GLOBAL
UNION ALL 
SELECT * FROM CTE_ANULADOS_FACTURADO_TOTAL_UNICO_GLOBAL
UNION ALL
SELECT * FROM CTE_FACTURADO_BASICA_TOTAL_UNICO_GLOBAL

UNION ALL

SELECT * FROM CTE_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL
UNION ALL
SELECT * FROM CTE_ANULADOS_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL

)


--INSERT INTO Report.CubeVieRCMTotalBilling 

SELECT *  FROM CTE_CONSOLIDADO
--where Idunique not in (select idunique from Report.CubeVieRCMTotalBilling where AÑO=@ANO AND MES=@MES)
