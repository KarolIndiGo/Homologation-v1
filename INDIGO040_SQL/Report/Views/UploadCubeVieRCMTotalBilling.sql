-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: UploadCubeVieRCMTotalBilling
-- Extracted by Fabric SQL Extractor SPN v3.9.0








/*******************************************************************************************************************
Nombre: [Report].[UploadCubeVieRCMTotalBilling]
Tipo:Procedimiento Vista
Observacion:Cubo consolidado del proceso de facturación.
Profesional:Andres Cabrera
Fecha Creación:03-03-2024
Profesional revisión:
Fecha Revisión:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:Nilsson Miguel Galindo
Fecha:04-04-2024
Observaciones:Se crea cte CTE_COMPANY, para tener en cuenta los id de cada compañia y tener un unico script,
			  ademas se cambia la logica del filtro de la fecha solo teniendo en cuenta 30 días al dia actual. 
--------------------------------------
Version 3
Persona que modifico: Andrés Cabrera
Fecha: 22-04-2024
Observaciones: Se adiciona el estado de la factura en la variable Idunique, ya que cuando se anula la factura aparece duplicado
--------------------------------------
Version 4
Persona que modifico: Andrés Cabrera
Fecha: 24-04-2024
Observaciones: Se adiciona el segmento de la fecha de alta si el tipo de destino es 12, aplica cuando hay inconsistencias de registros que no se guardan en HCREGEGRE
--------------------------------------
Version 5
Persona que modifico: 
Fecha: 
Observaciones: 
***********************************************************************************************************************************/


CREATE view [Report].[UploadCubeVieRCMTotalBilling] AS

---- ***** SCRIP CONSOLIDADO CABECERA FACTURACION ***** -----



--*****************************************************************************************************************************************************************************--
--*************************************************************** SEGMENTO FACTURAS GENERADAS *********************************************************************************--
--*****************************************************************************************************************************************************************************--

--****************CTE PARA SACAR LAS FACTURAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA******************************--

WITH 
CTE_COMPANY AS
(
SELECT
IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO036','116',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO039','50',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO040','29',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO041','68',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO043','27',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO045','11',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO046','11',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO047','11','')))))))) AS IdJournalVoucherInvoice,
--SELECT TOP 10 * FROM GeneralLedger.JournalVouchers WHERE EntityName='INVOICE'
IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO036','116',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO039','50',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO040','29',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO041','68',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO043','27',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO045','11',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO046','11',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO047','11','')))))))) AS IdJournalVoucherInvoiceEntityCapitated,
--SELECT TOP 10 * FROM GeneralLedger.JournalVouchers WHERE EntityName='InvoiceEntityCapitated'
IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO036','94',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO039','53',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO040','90',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO041','71',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO043','27',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO045','11',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO046','11',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO047','11','')))))))) AS IdJournalVoucherBasicBilling,
--SELECT TOP 10 * FROM GeneralLedger.JournalVouchers WHERE EntityName='BasicBilling'
IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO036','14',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO039','51',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO040','30',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO041','69',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO043','26',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO045','14',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO046','14',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO047','14','')))))))) AS IdJournalVoucherInvoiceAnulado,
--SELECT TOP 10 * FROM GeneralLedger.JournalVouchers WHERE EntityName='Invoice' AND IdJournalVoucher!=11
IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO036','',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO039','51',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO040','30',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO041','',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO043','',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO045','14',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO046','14',
	IIF(CAST(DB_NAME() AS VARCHAR(9))='INDIGO047','14','')))))))) AS IdJournalVoucherInvoiceEntityCapitatedAnulado
--SELECT TOP 10 * FROM GeneralLedger.JournalVouchers WHERE EntityName='InvoiceEntityCapitated' AND IdJournalVoucher!=11
),

CTE_UNIDAD_OPERATIVA
AS
(
SELECT 
U.Id,
UnitName AS [UNIDAD OPERATIVA],
C.Name AS [CIUDAD UNIDAD OPERATIVA]
FROM 
Common.OperatingUnit U INNER JOIN
Common.City C ON U.IdCity=C.Id
),

CTE_FACTURADOS_TOTAL_UNICOS
AS
(
	SELECT DISTINCT 
	JV.EntityId,
	CAST(JV.VoucherDate AS DATE) AS VoucherDate,
	sum(JVD.CreditValue) AS Valor_Credito,
	AdmissionNumber, 
	F.InvoiceNumber,
	JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME AS [TIPO COMPROBANTE],
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
	FROM 
	GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD ON JV.Id=JVD.IdAccounting
	INNER JOIN Billing.Invoice AS F ON JV.EntityId=F.Id
	INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JV.IdJournalVoucher=JVT.Id
	INNER JOIN CTE_COMPANY COMPANY ON JV.IdJournalVoucher=COMPANY.IdJournalVoucherInvoice
	INNER JOIN CTE_UNIDAD_OPERATIVA UN ON F.OperatingUnitId=UN.Id
	WHERE 
	CAST(JV.VoucherDate AS DATE) BETWEEN CAST(common.getdate()-5 AS DATE) AND CAST(COMMON.GETDATE() AS DATE) AND
	JV.LegalBookId=1 
	AND jv.EntityName ='Invoice' 
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME,
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
),

--****************CTE PARA SACAR LAS FACTURAS CAPITA DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA******************************--

CTE_FACTURADOS_CAPITADOS_TOTAL_UNICOS
AS
(
	SELECT DISTINCT 
	JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,
	SUM(JVD.CreditValue) Valor_Credito,
	AdmissionNumber, 
	F.InvoiceNumber,
	JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME AS [TIPO COMPROBANTE],
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
	FROM 
	GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD ON JV.Id=JVD.IdAccounting
	INNER JOIN Billing.InvoiceEntityCapitated AS IEC ON IEC.Id=JV.EntityId
	INNER JOIN Billing.Invoice AS F ON F.Id=IEC.InvoiceId	
	INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JV.IdJournalVoucher=JVT.Id
	INNER JOIN GeneralLedger.MainAccounts AS MA ON JVD.IdMainAccount=MA.Id
	INNER JOIN CTE_COMPANY COMPANY ON JV.IdJournalVoucher=COMPANY.IdJournalVoucherInvoiceEntityCapitated
	INNER JOIN CTE_UNIDAD_OPERATIVA UN ON F.OperatingUnitId=UN.Id
	WHERE 
	CAST(JV.VoucherDate AS DATE) BETWEEN CAST(common.getdate()-5 AS DATE) AND CAST(COMMON.GETDATE() AS DATE) AND
	JV.LegalBookId=1 
	AND jv.EntityName='InvoiceEntityCapitated' 
	AND MA.Number BETWEEN '41000000' AND '41999999'
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME,
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
),

--****************CTE PARA SACAR LAS FACTURAS BÁSICAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA******************************--

CTE_FACTURA_BASICA_UNICOS
AS
(
 	SELECT DISTINCT 
	JV.EntityId,
	CAST(JV.VoucherDate AS DATE) VoucherDate,
	SUM(JVD.CreditValue) Valor_Credito, 
	AdmissionNumber,
	I.InvoiceNumber,
	JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME AS [TIPO COMPROBANTE],
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
	FROM 
	GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD  ON JV.Id=JVD.IdAccounting
	INNER JOIN Billing.BasicBilling AS BB ON JV.EntityId=BB.Id
	INNER JOIN Billing.Invoice AS I ON BB.InvoiceId=I.Id
	INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JV.IdJournalVoucher=JVT.Id
	INNER JOIN CTE_COMPANY COMPANY ON JV.IdJournalVoucher=COMPANY.IdJournalVoucherBasicBilling
	INNER JOIN CTE_UNIDAD_OPERATIVA UN ON I.OperatingUnitId=UN.Id
	WHERE 
	CAST(JV.VoucherDate AS DATE) BETWEEN CAST(common.getdate()-5 AS DATE) AND CAST(COMMON.GETDATE() AS DATE) AND 
	JV.LegalBookId =1 
	AND jv.EntityName ='BasicBilling'
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE), AdmissionNumber,I.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME,
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]

),   
--*************************************** CTE TRAE LOS DATOS DEL ALTA MEDICA DE LAS FACTURAS A NIVEL DE CABECERA DE FACTURA ********************************************************--

CTE_ALTA_MEDICA_FACTURADOS
AS
(
	SELECT 
	EGR.NUMINGRES AS INGRESO,
	EGR.FECALTPAC AS [FECHA ALTA MEDICA]
	FROM HCREGEGRE EGR 
	INNER JOIN
	( SELECT 
		EGR.NUMINGRES AS INGRESO,
		MAX(EGR.FECALTPAC) AS [FECHA ALTA MEDICA] 
	  FROM DBO.HCREGEGRE EGR 
	  INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS ING  ON EGR.NUMINGRES=ING.AdmissionNumber  
	  GROUP BY EGR.NUMINGRES
	)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
),

--************************************************ CTE TRAE LOS DATOS DEL ALTA MEDICA TIPO SALIDA=12 ******************************************************************************--

CTE_SALIDA_FACTURADOS
AS
(
	SELECT HIS.NUMINGRES 'INGRESO' ,HIS.IPCODPACI 'IDENTIFICACION',HIS.FECHISPAC 'FECHA SALIDA'  
	FROM HCHISPACA HIS 
	INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS ING  ON HIS.NUMINGRES=ING.AdmissionNumber
	INNER JOIN
	( SELECT HIS.NUMINGRES 'INGRESO' ,HIS.IPCODPACI 'IDENTIFICACION' ,MAX(ID) 'ID'  
	  FROM DBO.HCHISPACA HIS 
	  INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS ING  ON HIS.NUMINGRES=ING.AdmissionNumber  
	  WHERE HIS.INDICAPAC=12
	  GROUP BY HIS.NUMINGRES,HIS.IPCODPACI
	)  AS G ON G.INGRESO=HIS.NUMINGRES AND G.[ID]=HIS.ID
),

--****************CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO FACTURA********************--

CTE_FACTURADO_TOTAL_UNICO_GLOBAL
AS
(
   SELECT DISTINCT
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   UNI.[UNIDAD OPERATIVA],
   UNI.[CIUDAD UNIDAD OPERATIVA],
   'OPERACIONAL' AS [TIPO VENTA],
   'FACTURA EVENTO' AS [TIPO MODALIDAD],
   'FACTURADO' AS ESTADO,
   TP.Nit AS NIT,
   TP.Name AS ENTIDAD, 
   CG.Code AS [CODIGO GRUPO ATENCION], 
   CG.Name AS [GRUPO ATENCION], 
   CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' 
					  WHEN 2 THEN 'EPS Subsidiado'
					  WHEN 3 THEN 'ET Vinculados Municipios' 
					  WHEN 4 THEN 'ET Vinculados Departamentos' 
					  WHEN 5 THEN 'ARL Riesgos Laborales' 
					  WHEN 6 THEN 'MP Medicina Prepagada'
					  WHEN 7 THEN 'IPS Privada' 
					  WHEN 8 THEN 'IPS Publica' 
					  WHEN 9 THEN 'Regimen Especial' 
					  WHEN 10 THEN 'Accidentes de transito' 
					  WHEN 11 THEN 'Fosyga' 
					  WHEN 12 THEN 'Otros'
					  WHEN 13 THEN 'Aseguradoras' 
					  WHEN 99 THEN 'Particulares' ELSE 'Otros' END AS REGIMEN,
   I.PatientCode AS IDENTIFICACION, 
   RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
   CAST(PAC.IPFECNACI AS DATE) AS [FECHA NACIMIENTO],
   I.AdmissionNumber AS INGRESO, 
   CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE) ELSE CAST( ISNULL(ALT.[FECHA ALTA MEDICA],ISNULL(ALT2.[FECHA SALIDA],ING.FECHEGRESO)) AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA], 
   CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA],
   CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],
   CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],
   CAST(I.InvoiceValue AS NUMERIC) 'VALOR SIN IVA',
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' 
					 WHEN 2 THEN 'Factura EAPB Sin Contrato' 
					 WHEN 3 THEN 'Factura Particular' 
					 WHEN 4 THEN 'Factura Capitada'
					 WHEN 5 THEN 'Control de Capitacion' 
					 WHEN 6 THEN 'Factura Basica' 
					 WHEN 7 THEN 'Factura de Venta de Productos' END AS [TIPO FACTURA],
   ICT.Name AS [CATERGORIA FACTURA],
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' 
					  WHEN 2 THEN 'HOSPITALARIO' END AS [TIPO INGRESO],
   FUI.NAME AS [UNIDAD FUNCIONAL INGRESO],
   ISNULL(FUE.NAME,FUI.NAME) AS [UNIDAD FUNCIONAL EGRESO],
   OutputDiagnosis AS [CIE 10],
   DIA.NOMDIAGNO AS [DIAGNOSTICO],
   SU.NOMUSUARI AS [USUARIO FACTURO],
   NULL AS [FECHA ANULACION],
   NULL AS [USUARIO ANULO],
   NULL AS [CAUSA ANULACION],
   UNI.Consecutive AS [CODIGO COMPROBANTE],
   UNI.[TIPO COMPROBANTE],
   1 AS CANTIDAD,
   CAST(UNI.VoucherDate AS DATE) AS [FECHA BUSQUEDA],
   YEAR(UNI.VoucherDate) AS [AÑO BUSQUEDA],
   MONTH(UNI.VoucherDate) AS [MES BUSQUEDA],
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' 
							   WHEN 2 THEN 'FEB' 
							   WHEN 3 THEN 'MAR' 
							   WHEN 4 THEN 'ABR' 
							   WHEN 5 THEN 'MAY' 
							   WHEN 6 THEN 'JUN' 
							   WHEN 7 THEN 'JUL' 
							   WHEN 8 THEN 'AGO'
							   WHEN 9 THEN 'SEP' 
							   WHEN 10 THEN 'OCT' 
							   WHEN 11 THEN 'NOV' 
							   WHEN 12 THEN 'DIC' END AS [MES NOMBRE BUSQUEDA],   
   (CASE DATENAME(dw,UNI.VoucherDate) WHEN 'Monday' THEN 'LUN'
									  WHEN 'Tuesday' THEN 'MAR' 
									  WHEN 'Wednesday' THEN 'MIE' 
									  WHEN 'Thursday' THEN 'JUE' 
									  when 'Friday' THEN 'VIE'
									  WHEN 'Saturday' THEN 'SAB' 
									  WHEN 'Sunday' THEN 'DOM' END) AS [DIA SEMANA],  
   DAY(UNI.VoucherDate) AS DIA, 
   I.ID InvoiceId, 
   CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2)) + rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) + cast('F' as char(1)) AS Idunique,
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
   FROM 
   Billing.Invoice AS I
   INNER JOIN CTE_FACTURADOS_TOTAL_UNICOS AS UNI ON UNI.EntityId =I.Id
   LEFT JOIN Billing.InvoiceDetail AS ID ON I.Id=ID.InvoiceId
   LEFT JOIN Billing.ServiceOrderDetail AS SOD ON ID.ServiceOrderDetailId=SOD.Id
   LEFT JOIN Billing.ServiceOrder AS SO ON SOD.ServiceOrderId=SO.Id
   LEFT JOIN Payroll.FunctionalUnit AS FU ON SOD.PerformsFunctionalUnitId=FU.Id
   LEFT JOIN Payroll.CostCenter AS COST ON SOD.CostCenterId=COST.Id
   LEFT JOIN dbo.ADINGRESO AS ING ON I.AdmissionNumber=ING.NUMINGRES
   LEFT JOIN Common.ThirdParty AS TP ON I.ThirdPartyId=TP.Id
   LEFT JOIN Contract .CareGroup AS CG ON I.CareGroupId=CG.Id
   LEFT JOIN dbo.INPACIENT AS PAC ON I.PatientCode=PAC.IPCODPACI
   LEFT JOIN Contract.CUPSEntity AS CUPS ON SOD.CUPSEntityId=CUPS.Id
   LEFT JOIN Inventory.InventoryProduct AS IPR ON SOD.ProductId=IPR.Id
   LEFT JOIN Contract.CUPSEntityContractDescriptions AS DESCR ON SOD.CUPSEntityContractDescriptionId=DESCR.Id AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
   LEFT JOIN Contract.ContractDescriptions AS CD ON DESCR.ContractDescriptionId=CD.ID
   LEFT JOIN Billing.ServiceOrderDetail AS SODP ON SOD.PackageServiceOrderDetailId=SODP.Id
   LEFT JOIN Contract.CUPSEntity AS CUPSP ON SODP.CUPSEntityId=CUPSP.Id
   LEFT JOIN Billing.ServiceOrderDetail AS SODI ON SOD.IncludeServiceOrderDetailId=SODI.Id
   LEFT JOIN Contract.CUPSEntity AS CUPSI ON SODI.CUPSEntityId=CUPSI.Id
   LEFT JOIN dbo.INPROFSAL AS MED ON SOD.PerformsHealthProfessionalCode=MED.CODPROSAL
   LEFT JOIN dbo.INESPECIA AS ESPMED ON SOD.PerformsProfessionalSpecialty=ESPMED.CODESPECI
   LEFT JOIN Common.ThirdParty AS TPT ON SOD.PerformsHealthProfessionalThirdPartyId=TPT.Id 
   LEFT JOIN Billing.InvoiceDetailSurgical AS IDS ON ID.Id=IDS.InvoiceDetailId AND IDS.OnlyMedicalFees='0'
   LEFT JOIN Contract.IPSService AS IPS ON IDS.IPSServiceId=IPS.Id
   LEFT JOIN dbo.INPROFSAL AS MEDQX ON IDS.PerformsHealthProfessionalCode=MEDQX.CODPROSAL
   LEFT JOIN dbo.INESPECIA AS ESPQX ON MEDQX.CODESPEC1=ESPQX.CODESPECI
   LEFT JOIN GeneralLedger.MainAccounts AS MA ON ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)=MA.Id
   LEFT JOIN Payroll.FunctionalUnit AS FUI ON ING.UFUCODIGO=FUI.CODE
   LEFT JOIN Payroll.FunctionalUnit AS FUE ON ING.UFUEGRMED=FUE.CODE
   LEFT JOIN DBO.INDIAGNOS AS DIA ON I.OutputDiagnosis=DIA.CODDIAGNO
   LEFT JOIN DBO.SEGusuaru SU ON I.InvoicedUser=SU.CODUSUARI
   LEFT JOIN DBO.SEGusuaru SUA ON I.InvoicedUser=SUA.CODUSUARI
   LEFT JOIN Billing.BillingReversalReason AS BRR ON I.ReversalReasonId=BRR.Id
   LEFT JOIN CTE_ALTA_MEDICA_FACTURADOS AS ALT ON I.AdmissionNumber=ALT.INGRESO
   LEFT JOIN CTE_SALIDA_FACTURADOS AS ALT2  ON ALT2.INGRESO =I.AdmissionNumber
   LEFT JOIN Billing.InvoiceCategories ICT ON I.InvoiceCategoryId=ICT.Id
),

--****************CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS CAPITA, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA********************--

CTE_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL
AS
(
  SELECT DISTINCT
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
  UNI.[UNIDAD OPERATIVA],
  UNI.[CIUDAD UNIDAD OPERATIVA],
  'OPERACIONAL' AS [TIPO VENTA], 
  'FACTURA GLOBAL PGP' AS [TIPO MODALIDAD],
  'FACTURADO' AS ESTADO, 
  TP.Nit AS NIT,
  TP.Name AS ENTIDAD, 
  CG.Code AS [CODIGO GRUPO ATENCION], 
  CG.Name AS [GRUPO ATENCION], 
  CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' 
					 WHEN 2 THEN 'EPS Subsidiado'
					 WHEN 3 THEN 'ET Vinculados Municipios' 
					 WHEN 4 THEN 'ET Vinculados Departamentos' 
					 WHEN 5 THEN 'ARL Riesgos Laborales' 
					 WHEN 6 THEN 'MP Medicina Prepagada'
					 WHEN 7 THEN 'IPS Privada' 
					 WHEN 8 THEN 'IPS Publica' 
					 WHEN 9 THEN 'Regimen Especial' 
					 WHEN 10 THEN 'Accidentes de transito' 
					 WHEN 11 THEN 'Fosyga' 
					 WHEN 12 THEN 'Otros'
					 WHEN 13 THEN 'Aseguradoras' 
					 WHEN 99 THEN 'Particulares' ELSE 'Otros' END AS REGIMEN,
   '00000000' AS IDENTIFICACION, 
   'FACTURA CAPITA' AS PACIENTE,
   NULL AS [FECHA NACIMIENTO],
   '00000000' AS INGRESO, 
   CAST(IEC.InitialDate AS DATE) AS [FECHA INGRESO],
   CAST(IEC.EndDate AS DATE) AS [FECHA EGRESO], 
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA], 
   CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], 
   CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],
   CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],
   CAST(I.InvoiceValue AS NUMERIC) AS [VALOR SIN IVA], 
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' 
					 WHEN 2 THEN 'Factura EAPB Sin Contrato' 
					 WHEN 3 THEN 'Factura Particular' 
					 WHEN 4 THEN 'Factura Capitada'
					 WHEN 5 THEN 'Control de Capitacion' 
					 WHEN 6 THEN 'Factura Basica' 
					 WHEN 7 THEN 'Factura de Venta de Productos' END AS [TIPO FACTURA],
   ICT.Name AS 'CATERGORIA FACTURA',
   'CAPITA' AS [TIPO INGRESO],
   '' AS [UNIDAD FUNCIONAL INGRESO],
   '' AS [UNIDAD FUNCIONAL EGRESO],
   '' AS [CIE 10],
   '' AS [DIAGNOSTICO],
   SU.NOMUSUARI AS [USUARIO FACTURO],
   NULL 'FECHA ANULACION',
   NULL AS [USUARIO ANULO],
   NULL 'CAUSA ANULACION',
   UNI.Consecutive AS [CODIGO COMPROBANTE],
   UNI.[TIPO COMPROBANTE], 
   1 AS CANTIDAD,
   CAST(UNI.VoucherDate AS DATE) AS [FECHA BUSQUEDA],
   YEAR(UNI.VoucherDate) AS [AÑO BUSQUEDA],
   MONTH(UNI.VoucherDate) AS [MES BUSQUEDA],
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' 
							   WHEN 2 THEN 'FEB' 
							   WHEN 3 THEN 'MAR' 
							   WHEN 4 THEN 'ABR' 
							   WHEN 5 THEN 'MAY' 
							   WHEN 6 THEN 'JUN' 
							   WHEN 7 THEN 'JUL' 
							   WHEN 8 THEN 'AGO'
							   WHEN 9 THEN 'SEP' 
							   WHEN 10 THEN 'OCT' 
							   WHEN 11 THEN 'NOV' 
							   WHEN 12 THEN 'DIC' END AS [MES NOMBRE BUSQUEDA],   
  (CASE DATENAME(dw,UNI.VoucherDate) WHEN 'Monday' THEN 'LUN' 
									 WHEN 'Tuesday' THEN 'MAR' 
									 WHEN 'Wednesday' THEN 'MIE' 
									 WHEN 'Thursday' THEN 'JUE' 
									 WHEN 'Friday' THEN 'VIE'
									 WHEN 'Saturday' THEN 'SAB' 
									 WHEN 'Sunday' THEN 'DOM' END) AS [DIA SEMANA],   
   DAY(UNI.VoucherDate) AS DIA, 
   I.ID InvoiceId,  
   CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + Rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) + cast('F' as char(1)) AS Idunique,
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
   FROM 
   Billing.Invoice AS I
   INNER JOIN Billing.InvoiceEntityCapitated IEC ON I.Id=IEC.InvoiceId
   INNER JOIN CTE_FACTURADOS_CAPITADOS_TOTAL_UNICOS AS UNI ON IEC.Id=UNI.EntityId
   INNER JOIN Common.ThirdParty AS TP ON I.ThirdPartyId=TP.Id
   INNER JOIN Contract .CareGroup AS CG ON I.CareGroupId=CG.Id
   LEFT JOIN DBO.INDIAGNOS AS DIA ON DIA.CODDIAGNO=I.OutputDiagnosis
   LEFT JOIN DBO.SEGusuaru SU ON I.InvoicedUser=SU.CODUSUARI
   LEFT JOIN DBO.SEGusuaru SUA ON I.InvoicedUser=SUA.CODUSUARI
   LEFT JOIN Billing.BillingReversalReason AS BRR ON I.ReversalReasonId=BRR.Id
   LEFT JOIN Billing.InvoiceCategories ICT ON I.InvoiceCategoryId=ICT.Id
),

--********CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS BASICAS NO OPERACIONAL, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO TIPO FACTURA**********--

CTE_FACTURADO_BASICA_TOTAL_UNICO_GLOBAL
AS
(
 SELECT DISTINCT
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
  UNI.[UNIDAD OPERATIVA],
  UNI.[CIUDAD UNIDAD OPERATIVA],
  'NO OPERACIONAL' AS [TIPO VENTA],
  'FACTURA BASICA' AS [TIPO MODALIDAD],
  'FACTURADO' AS ESTADO, 
  TP.Nit AS NIT,
  TP.Name AS ENTIDAD, 
  'NO_OPERA' AS [CODIGO GRUPO ATENCION], 
  'NO OPERACIONAL' AS [GRUPO ATENCION], 
  'Otros' AS REGIMEN,
  '00000000' AS IDENTIFICACION, 
  'FACTURA CAPITA' AS PACIENTE,
  NULL AS [FECHA NACIMIENTO],
  '00000000' AS INGRESO, 
  CAST(I.InvoiceDate AS  DATE) AS [FECHA INGRESO],
  CAST(I.InvoiceDate AS date) [FECHA EGRESO], I.InvoiceNumber AS [NRO FACTURA],CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA], CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
  CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
  CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],CAST(I.InvoiceValue AS NUMERIC) 'VALOR SIN IVA',
  CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' 
					WHEN 2 THEN 'Factura EAPB Sin Contrato' 
					WHEN 3 THEN 'Factura Particular' 
					WHEN 4 THEN 'Factura Capitada'
					WHEN 5 THEN 'Control de Capitacion' 
					WHEN 6 THEN 'Factura Basica' 
					WHEN 7 THEN 'Factura de Venta de Productos' END AS [TIPO FACTURA],
  'NO OPERACIONAL' AS [CATERGORIA FACTURA],
  'CAPITA' AS [TIPO INGRESO],
  '' AS [UNIDAD FUNCIONAL INGRESO],
  '' AS [UNIDAD FUNCIONAL EGRESO],
  '' AS [CIE 10],
  '' AS [DIAGNOSTICO],
  SU.NOMUSUARI AS [USUARIO FACTURO],
  NULL AS [FECHA ANULACION],
  NULL AS [USUARIO ANULO],
  NULL AS [CAUSA ANULACION],
  UNI.Consecutive AS [CODIGO COMPROBANTE],
  UNI.[TIPO COMPROBANTE],
  1 AS CANTIDAD,
  CAST(UNI.VoucherDate AS DATE) AS [FECHA BUSQUEDA],
  YEAR(UNI.VoucherDate) AS [AÑO BUSQUEDA],
  MONTH(UNI.VoucherDate) AS [MES BUSQUEDA],
  CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' 
							  WHEN 2 THEN 'FEB' 
							  WHEN 3 THEN 'MAR' 
							  WHEN 4 THEN 'ABR' 
							  WHEN 5 THEN 'MAY' 
							  WHEN 6 THEN 'JUN' 
							  WHEN 7 THEN 'JUL' 
							  WHEN 8 THEN 'AGO'
							  WHEN 9 THEN 'SEP' 
							  WHEN 10 THEN 'OCT' 
							  WHEN 11 THEN 'NOV' 
							  WHEN 12 THEN 'DIC' END AS [MES NOMBRE BUSQUEDA], 
  (CASE DATENAME(dw,UNI.VoucherDate) WHEN 'Monday' THEN 'LUN' 
									 WHEN 'Tuesday' THEN 'MAR' 
									 WHEN 'Wednesday' THEN 'MIE' 
									 WHEN 'Thursday' THEN 'JUE' 
									 WHEN 'Friday' THEN 'VIE'
									 WHEN 'Saturday' THEN 'SAB' 
									 WHEN 'Sunday' THEN 'DOM' END) AS [DIA SEMANA],   
  DAY(UNI.VoucherDate) AS DIA, 
  I.ID InvoiceId , CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + Rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) + cast('F' as char(1)) 'Idunique',
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  FROM 
  Billing.BasicBilling AS BB
  INNER JOIN CTE_FACTURA_BASICA_UNICOS AS UNI ON BB.Id=UNI.EntityId
  INNER JOIN Billing.Invoice AS I ON BB.InvoiceId=I.Id
  INNER JOIN Common .ThirdParty AS TP ON I.ThirdPartyId=TP.Id
  LEFT JOIN DBO.INDIAGNOS AS DIA ON I.OutputDiagnosis=DIA.CODDIAGNO
  LEFT JOIN DBO.SEGusuaru SU ON I.InvoicedUser=SU.CODUSUARI
  LEFT JOIN DBO.SEGusuaru SUA ON I.InvoicedUser=SUA.CODUSUARI
  LEFT JOIN Billing.BillingReversalReason AS BRR ON I.ReversalReasonId=BRR.Id
  LEFT JOIN Billing.InvoiceCategories ICT ON I.InvoiceCategoryId=ICT.Id
 ),

--*****************************************************************************************************************************************************************************--
--*************************************************************** SEGMENTO FACTURAS ANULADAS GENERADAS ************************************************************************--
--*****************************************************************************************************************************************************************************--

--***************CTE PARA SACAR LAS FACTURAS ANULADAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO ANULACION DE FACTURA*********--

CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS
AS
(
	SELECT DISTINCT 
	JV.EntityId,
	CAST(JV.VoucherDate AS DATE) 
	VoucherDate,
	SUM(JVD.CreditValue) AS Valor_Credito,
	AdmissionNumber, 
	F.InvoiceNumber,
	JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME AS [TIPO COMPROBANTE],
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
	FROM 
	GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD ON JV.Id=JVD.IdAccounting
	INNER JOIN Billing.Invoice AS F ON JV.EntityId=F.Id
	INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JV.IdJournalVoucher=JVT.Id
	INNER JOIN CTE_COMPANY COMPANY ON JV.IdJournalVoucher=COMPANY.IdJournalVoucherInvoiceAnulado
	INNER JOIN CTE_UNIDAD_OPERATIVA UN ON F.OperatingUnitId=UN.Id
	WHERE 
	CAST(JV.VoucherDate AS DATE) BETWEEN CAST(common.getdate()-5 AS DATE) AND CAST(COMMON.GETDATE() AS DATE) AND 
	JV.LegalBookId =1 
	AND jv.EntityName ='Invoice'
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME,
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
),

--***************CTE PARA SACAR LAS FACTURAS CAPITAS ANULADAS DEL MES DESEADO, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO ANULACION DE FACTURA*********--

CTE_ANULADOS_FACTURADOS_CAPITA_TOTAL_UNICOS
AS
(
	SELECT DISTINCT 
	JV.EntityId,
	CAST(JV.VoucherDate AS DATE) AS VoucherDate,
	SUM(JVD.CreditValue) AS Valor_Credito,
	AdmissionNumber, 
	F.InvoiceNumber,
	JV.Consecutive,
	JVT.Code + ' - ' + JVT.NAME AS [TIPO COMPROBANTE],
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
	FROM 
	GeneralLedger.JournalVouchers JV 
	INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD ON JV.Id=JVD.IdAccounting
	INNER JOIN Billing.InvoiceEntityCapitated AS IEC ON IEC.Id=JV.EntityId
	INNER JOIN Billing.Invoice AS F ON F.Id=IEC.InvoiceId	
	INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JV.IdJournalVoucher=JVT.Id
	INNER JOIN GeneralLedger.MainAccounts AS MA ON JVD.IdMainAccount=MA.Id
	INNER JOIN CTE_COMPANY COMPANY ON JV.IdJournalVoucher=COMPANY.IdJournalVoucherInvoiceEntityCapitatedAnulado
	INNER JOIN CTE_UNIDAD_OPERATIVA UN ON F.OperatingUnitId=UN.Id
	WHERE 
	CAST(JV.VoucherDate AS DATE) BETWEEN CAST(common.getdate()-5 AS DATE) AND CAST(COMMON.GETDATE() AS DATE) AND 
	JV.LegalBookId =1 
	AND jv.EntityName ='InvoiceEntityCapitated' 
	AND MA.Number BETWEEN '41000000' AND '41999999'
	GROUP BY JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber, F.InvoiceNumber,JV.Consecutive,JVT.Code + ' - ' + JVT.NAME,
	UN.[UNIDAD OPERATIVA],
	UN.[CIUDAD UNIDAD OPERATIVA]
),

--******************************* CTE TRAE LOS DATOS DEL ALTA MEDICA DE LAS FACTURAS ANULADAS A NIVEL DE CABECERA DE FACTURA ********************************************************--

CTE_ALTA_MEDICA_FACTURADOS_ANULADOS
AS
(
	SELECT 
	EGR.NUMINGRES AS INGRESO,
	EGR.FECALTPAC AS [FECHA ALTA MEDICA] 
	FROM HCREGEGRE EGR 
	INNER JOIN
	( SELECT 
		EGR.NUMINGRES AS INGRESO,
		MAX(EGR.FECALTPAC) AS [FECHA ALTA MEDICA]
	  FROM DBO.HCREGEGRE EGR 
	  INNER JOIN CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS AS ING  ON EGR.NUMINGRES=ING.AdmissionNumber  
	  GROUP BY EGR.NUMINGRES
	)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
),

--************************************************ CTE TRAE LOS DATOS DEL ALTA MEDICA TIPO SALIDA=12 ******************************************************************************--

CTE_SALIDA_FACTURADOS_ANULADOS
AS
(
	SELECT HIS.NUMINGRES 'INGRESO' ,HIS.IPCODPACI 'IDENTIFICACION',HIS.FECHISPAC 'FECHA SALIDA'  
	FROM HCHISPACA HIS 
	INNER JOIN CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS AS ING  ON HIS.NUMINGRES=ING.AdmissionNumber
	INNER JOIN
	( SELECT HIS.NUMINGRES 'INGRESO' ,HIS.IPCODPACI 'IDENTIFICACION' ,MAX(ID) 'ID'  
	  FROM DBO.HCHISPACA HIS 
	  INNER JOIN CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS AS ING  ON HIS.NUMINGRES=ING.AdmissionNumber  
	  WHERE HIS.INDICAPAC=12
	  GROUP BY HIS.NUMINGRES,HIS.IPCODPACI
	)  AS G ON G.INGRESO=HIS.NUMINGRES AND G.[ID]=HIS.ID
),

--********CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS ANULADAS, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO FACTURA********************--

CTE_ANULADOS_FACTURADO_TOTAL_UNICO_GLOBAL
AS
(
   SELECT DISTINCT  
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   UNI.[UNIDAD OPERATIVA],
   UNI.[CIUDAD UNIDAD OPERATIVA],
   'OPERACIONAL' AS [TIPO VENTA],
   'FACTURA EVENTO' AS [TIPO MODALIDAD],
   'ANULADO' AS ESTADO,
   TP.Nit AS NIT,
   TP.Name AS ENTIDAD, 
   CG.Code AS [CODIGO GRUPO ATENCION], 
   CG.Name AS [GRUPO ATENCION], 
   CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' 
					  WHEN 2 THEN 'EPS Subsidiado'
					  WHEN 3 THEN 'ET Vinculados Municipios' 
					  WHEN 4 THEN 'ET Vinculados Departamentos' 
					  WHEN 5 THEN 'ARL Riesgos Laborales' 
					  WHEN 6 THEN 'MP Medicina Prepagada'
					  WHEN 7 THEN 'IPS Privada' 
					  WHEN 8 THEN 'IPS Publica' 
					  WHEN 9 THEN 'Regimen Especial' 
					  WHEN 10 THEN 'Accidentes de transito' 
					  WHEN 11 THEN 'Fosyga' 
					  WHEN 12 THEN 'Otros'
					  WHEN 13 THEN 'Aseguradoras' 
					  WHEN 99 THEN 'Particulares' ELSE 'Otros' END AS REGIMEN,
   I.PatientCode AS IDENTIFICACION, 
   RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
   CAST(PAC.IPFECNACI AS DATE) AS [FECHA NACIMIENTO],
   I.AdmissionNumber AS INGRESO, 
   CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
   CASE WHEN ING.TIPOINGRE=1 THEN CAST(ING.IFECHAING AS DATE) ELSE CAST( ISNULL(ALT.[FECHA ALTA MEDICA],ISNULL(ALT2.[FECHA SALIDA],ING.FECHEGRESO)) AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],  
   CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], 
   CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],
   CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],
   CAST(I.InvoiceValue AS NUMERIC) AS [VALOR SIN IVA],
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' 
					 WHEN 2 THEN 'Factura EAPB Sin Contrato' 
					 WHEN 3 THEN 'Factura Particular' 
					 WHEN 4 THEN 'Factura Capitada'
					 WHEN 5 THEN 'Control de Capitacion' 
					 WHEN 6 THEN 'Factura Basica' 
					 WHEN 7 THEN 'Factura de Venta de Productos' END AS [TIPO FACTURA],
   ICT.Name AS [CATERGORIA FACTURA],
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' 
					  WHEN 2 THEN 'HOSPITALARIO' END AS [TIPO INGRESO],
   FUI.NAME AS [UNIDAD FUNCIONAL INGRESO],
   ISNULL(FUE.NAME,FUI.NAME) AS [UNIDAD FUNCIONAL EGRESO],
   OutputDiagnosis AS [CIE 10],
   DIA.NOMDIAGNO AS [DIAGNOSTICO],
   SU.NOMUSUARI AS [USUARIO FACTURO],
   CAST(I.AnnulmentDate AS DATE) AS [FECHA ANULACION],
   SUA.NOMUSUARI AS [USUARIO ANULO],
   BRR.Name AS [CAUSA ANULACION],
   UNI.Consecutive AS [CODIGO COMPROBANTE],
   UNI.[TIPO COMPROBANTE],
   1 AS CANTIDAD,
   CAST(UNI.VoucherDate AS DATE) AS [FECHA BUSQUEDA],
   YEAR(UNI.VoucherDate) AS [AÑO BUSQUEDA],
   MONTH(UNI.VoucherDate) AS [MES BUSQUEDA],
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' 
							   WHEN 2 THEN 'FEB' 
							   WHEN 3 THEN 'MAR' 
							   WHEN 4 THEN 'ABR' 
							   WHEN 5 THEN 'MAY' 
							   WHEN 6 THEN 'JUN' 
							   WHEN 7 THEN 'JUL' 
							   WHEN 8 THEN 'AGO'
							   WHEN 9 THEN 'SEP' 
							   WHEN 10 THEN 'OCT' 
							   WHEN 11 THEN 'NOV' 
							   WHEN 12 THEN 'DIC' END AS [MES NOMBRE BUSQUEDA], 
   (CASE DATENAME(dw,UNI.VoucherDate) WHEN 'Monday' THEN 'LUN' 
									  WHEN 'Tuesday' THEN 'MAR' 
									  WHEN 'Wednesday' THEN 'MIE' 
									  WHEN 'Thursday' THEN 'JUE' 
									  WHEN 'Friday' THEN 'VIE'
									  WHEN 'Saturday' THEN 'SAB' 
									  WHEN 'Sunday' THEN 'DOM' END) AS [DIA SEMANA],  
   DAY(UNI.VoucherDate) AS DIA, 
   I.ID InvoiceId , 
   CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2)) + rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) + cast('A' as char(1)) AS Idunique,
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
   FROM 
   Billing.Invoice AS I
   INNER JOIN CTE_ANULADOS_FACTURADOS_TOTAL_UNICOS AS UNI  ON I.Id=UNI.EntityId
   LEFT JOIN Billing.InvoiceDetail AS ID ON I.Id=ID.InvoiceId
   LEFT JOIN Billing.ServiceOrderDetail AS SOD ON ID.ServiceOrderDetailId=SOD.Id
   LEFT JOIN Billing .ServiceOrder AS SO ON SOD.ServiceOrderId=SO.Id
   LEFT JOIN Payroll.FunctionalUnit AS FU ON SOD.PerformsFunctionalUnitId=FU.Id
   LEFT JOIN Payroll.CostCenter AS COST ON SOD.CostCenterId=COST.Id
   LEFT JOIN dbo.ADINGRESO AS ING ON I.AdmissionNumber=ING.NUMINGRES
   LEFT JOIN Common .ThirdParty AS TP ON I.ThirdPartyId=TP.Id
   LEFT JOIN Contract .CareGroup AS CG ON I.CareGroupId=CG.Id
   LEFT JOIN dbo.INPACIENT AS PAC ON I.PatientCode=PAC.IPCODPACI
   LEFT JOIN Contract.CUPSEntity AS CUPS ON SOD.CUPSEntityId=CUPS.Id
   LEFT JOIN Inventory.InventoryProduct AS IPR ON SOD.ProductId=IPR.Id
   LEFT JOIN Contract.CUPSEntityContractDescriptions AS DESCR ON SOD.CUPSEntityContractDescriptionId=DESCR.Id AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
   LEFT JOIN Contract.ContractDescriptions AS CD ON DESCR.ContractDescriptionId=CD.ID
   LEFT JOIN Billing .ServiceOrderDetail AS SODP ON SOD.PackageServiceOrderDetailId=SODP.Id
   LEFT JOIN Contract.CUPSEntity AS CUPSP ON SODP.CUPSEntityId=CUPSP.Id
   LEFT JOIN Billing .ServiceOrderDetail AS SODI ON SOD.IncludeServiceOrderDetailId=SODI.Id
   LEFT JOIN Contract.CUPSEntity AS CUPSI ON SODI.CUPSEntityId=CUPSI.Id
   LEFT JOIN dbo.INPROFSAL AS MED ON SOD.PerformsHealthProfessionalCode=MED.CODPROSAL
   LEFT JOIN dbo.INESPECIA AS ESPMED ON SOD.PerformsProfessionalSpecialty=ESPMED.CODESPECI
   LEFT JOIN Common.ThirdParty AS TPT ON SOD.PerformsHealthProfessionalThirdPartyId=TPT.Id
   LEFT JOIN Billing.InvoiceDetailSurgical AS IDS ON ID.Id=IDS.InvoiceDetailId AND IDS.OnlyMedicalFees = '0'
   LEFT JOIN Contract.IPSService AS IPS ON IDS.IPSServiceId=IPS.Id
   LEFT JOIN dbo.INPROFSAL AS MEDQX ON IDS.PerformsHealthProfessionalCode=MEDQX.CODPROSAL
   LEFT JOIN dbo.INESPECIA AS ESPQX ON MEDQX.CODESPEC1=ESPQX.CODESPECI
   LEFT JOIN GeneralLedger.MainAccounts AS MA ON ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)=MA.Id
   LEFT JOIN Payroll.FunctionalUnit AS FUI ON ING.UFUCODIGO=FUI.CODE
   LEFT JOIN Payroll.FunctionalUnit AS FUE ON ING.UFUEGRMED=FUE.CODE
   LEFT JOIN DBO.INDIAGNOS AS DIA ON I.OutputDiagnosis=DIA.CODDIAGNO
   LEFT JOIN DBO.SEGusuaru SU ON I.InvoicedUser=SU.CODUSUARI
   LEFT JOIN DBO.SEGusuaru SUA ON I.InvoicedUser=SUA.CODUSUARI
   LEFT JOIN Billing.BillingReversalReason AS BRR ON I.ReversalReasonId=BRR.Id
   LEFT JOIN CTE_ALTA_MEDICA_FACTURADOS_ANULADOS AS ALT ON I.AdmissionNumber=ALT.INGRESO
   LEFT JOIN CTE_SALIDA_FACTURADOS_ANULADOS AS ALT2  ON ALT2.INGRESO =I.AdmissionNumber
   LEFT JOIN Billing.InvoiceCategories ICT ON I.InvoiceCategoryId=ICT.Id
),

--********CTE TRAE LOS DATOS BASICOS DE LA CABECERA DE FACTURAS CAPITA ANULADAS, DEBEN SER REGISTROS UNICOS DESDE CONTABILIDAD POR EL TIPO DE DOCUMENTO IPO FACTURA******************--

CTE_ANULADOS_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL
AS
(
  SELECT DISTINCT  
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   UNI.[UNIDAD OPERATIVA],
	UNI.[CIUDAD UNIDAD OPERATIVA],
   'OPERACIONAL' AS [TIPO VENTA],
   'FACTURA GLOBAL PGP' AS [TIPO MODALIDAD],
   'ANULADO' AS ESTADO, 
   TP.Nit AS NIT,
   TP.Name AS ENTIDAD, 
   CG.Code AS [CODIGO GRUPO ATENCION], 
   CG.Name AS [GRUPO ATENCION], 
   CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' 
					  WHEN 2 THEN 'EPS Subsidiado'
					  WHEN 3 THEN 'ET Vinculados Municipios' 
					  WHEN 4 THEN 'ET Vinculados Departamentos' 
					  WHEN 5 THEN 'ARL Riesgos Laborales' 
					  WHEN 6 THEN 'MP Medicina Prepagada'
					  WHEN 7 THEN 'IPS Privada' 
					  WHEN 8 THEN 'IPS Publica' 
					  WHEN 9 THEN 'Regimen Especial' 
					  WHEN 10 THEN 'Accidentes de transito' 
					  WHEN 11 THEN 'Fosyga' 
					  WHEN 12 THEN 'Otros'
					  WHEN 13 THEN 'Aseguradoras' 
					  WHEN 99 THEN 'Particulares' ELSE 'Otros' END AS REGIMEN,
   '00000000' AS IDENTIFICACION, 
   'FACTURA CAPITA' AS PACIENTE,
   NULL AS [FECHA NACIMIENTO],
   '00000000' AS INGRESO, 
   CAST(IEC.InitialDate AS DATE) AS [FECHA INGRESO],
   CAST(IEC.EndDate AS date) [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],  
   CAST(I.InvoiceExpirationDate AS DATE) AS [FECHA VENCIMIENTO],
   CAST(I.TotalInvoice AS NUMERIC) AS [TOTAL FACTURA], 
   CAST(I.ThirdPartySalesValue AS NUMERIC) AS [TOTAL VALOR ENTIDAD],
   CAST(I.TotalPatientSalesPrice AS NUMERIC) AS [TOTAL VALOR PACIENTE],
   CAST(I.ValueTax AS NUMERIC) AS [VALOR IVA],
   CAST(I.InvoiceValue AS NUMERIC) AS [VALOR SIN IVA],
   CASE DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' 
					 WHEN 2 THEN 'Factura EAPB Sin Contrato' 
					 WHEN 3 THEN 'Factura Particular' 
					 WHEN 4 THEN 'Factura Capitada'
					 WHEN 5 THEN 'Control de Capitacion' 
					 WHEN 6 THEN 'Factura Basica' 
					 WHEN 7 THEN 'Factura de Venta de Productos' END AS [TIPO FACTURA],
   ICT.Name AS [CATERGORIA FACTURA],
   'CAPITA' AS [TIPO INGRESO],
   '' AS [UNIDAD FUNCIONAL INGRESO],
   '' AS [UNIDAD FUNCIONAL EGRESO],
   '' AS [CIE 10],
   '' AS DIAGNOSTICO,
   SU.NOMUSUARI AS [USUARIO FACTURO],
   CAST(I.AnnulmentDate AS DATE) AS [FECHA ANULACION],
   SUA.NOMUSUARI AS [USUARIO ANULO],
   BRR.Name AS [CAUSA ANULACION],
   UNI.Consecutive AS [CODIGO COMPROBANTE],
   UNI.[TIPO COMPROBANTE],
   1 CANTIDAD,
   CAST(UNI.VoucherDate AS DATE) AS [FECHA BUSQUEDA],
   YEAR(UNI.VoucherDate) AS [AÑO BUSQUEDA],
   MONTH(UNI.VoucherDate) AS [MES BUSQUEDA], 
   CASE MONTH(UNI.VoucherDate) WHEN 1 THEN 'ENE' 
							   WHEN 2 THEN 'FEB' 
							   WHEN 3 THEN 'MAR' 
							   WHEN 4 THEN 'ABR' 
							   WHEN 5 THEN 'MAY' 
							   WHEN 6 THEN 'JUN' 
							   WHEN 7 THEN 'JUL' 
							   WHEN 8 THEN 'AGO'
							   WHEN 9 THEN 'SEP' 
							   WHEN 10 THEN 'OCT' 
							   WHEN 11 THEN 'NOV' 
							   WHEN 12 THEN 'DIC' END AS [MES NOMBRE BUSQUEDA], 
   (CASE DATENAME(dw,UNI.VoucherDate) WHEN 'Monday' THEN 'LUN' 
									  WHEN 'Tuesday' THEN 'MAR' 
									  WHEN 'Wednesday' THEN 'MIE' 
									  WHEN 'Thursday' THEN 'JUE' 
									  WHEN 'Friday' THEN 'VIE'
									  WHEN 'Saturday' THEN 'SAB' 
									  WHEN 'Sunday' THEN 'DOM' END) AS [DIA SEMANA], 
   DAY(UNI.VoucherDate) AS DIA, 
   I.ID InvoiceId , 
   CAST(YEAR(UNI.VoucherDate) AS CHAR(4)) + CAST(MONTH(UNI.VoucherDate) AS CHAR(2))  + rtrim(CAST(DAY(UNI.VoucherDate) AS CHAR(2))) + cast(I.Id as varchar) + cast('A' as char(1)) AS Idunique,
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
   FROM 
   Billing.Invoice AS I
   INNER JOIN Billing.InvoiceEntityCapitated IEC ON I.Id=IEC.InvoiceId
   INNER JOIN CTE_ANULADOS_FACTURADOS_CAPITA_TOTAL_UNICOS AS UNI ON IEC.Id=UNI.EntityId
   INNER JOIN Common.ThirdParty AS TP ON I.ThirdPartyId=TP.Id 
   INNER JOIN Contract .CareGroup AS CG ON I.CareGroupId=CG.Id
   LEFT JOIN DBO.INDIAGNOS AS DIA ON I.OutputDiagnosis=DIA.CODDIAGNO
   LEFT JOIN DBO.SEGusuaru SU ON I.InvoicedUser=SU.CODUSUARI
   LEFT JOIN DBO.SEGusuaru SUA ON I.InvoicedUser=SUA.CODUSUARI
   LEFT JOIN Billing.BillingReversalReason AS BRR ON I.ReversalReasonId=BRR.Id
   LEFT JOIN Billing.InvoiceCategories ICT ON I.InvoiceCategoryId=ICT.Id
)


SELECT * FROM CTE_FACTURADO_TOTAL_UNICO_GLOBAL-- WHERE [FECHA BUSQUEDA] BETWEEN CAST(common.getdate()-5 AS DATE) and CAST(common.getdate() AS DATE)
UNION ALL 
SELECT * FROM CTE_ANULADOS_FACTURADO_TOTAL_UNICO_GLOBAL
UNION ALL
SELECT * FROM CTE_FACTURADO_BASICA_TOTAL_UNICO_GLOBAL
UNION ALL
SELECT * FROM CTE_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL 
UNION ALL
SELECT * FROM CTE_ANULADOS_FACTURADO_CAPITA_TOTAL_UNICO_GLOBAL

