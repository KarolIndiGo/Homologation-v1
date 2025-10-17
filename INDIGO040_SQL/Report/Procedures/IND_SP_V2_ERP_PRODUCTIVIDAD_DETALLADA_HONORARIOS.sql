-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PRODUCTIVIDAD_DETALLADA_HONORARIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


	CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PRODUCTIVIDAD_DETALLADA_HONORARIOS]
	    @FECHAINI date,
	    @FECHAFIN date
	AS


--DECLARE @FECHAINI AS DATE = '2023-11-20'; 
--DECLARE @FECHAFIN AS DATE = '2023-12-20'; 

DECLARE @ID_COMPANY VARCHAR(9)=(CAST(DB_NAME() AS VARCHAR(9)));
DECLARE @TIPOFACTURA INT,@TIPOANULACION INT,@RECONOCIMIENTO INT, @TIPOFACTURABASICA INT
--IF @ID_COMPANY='INDIGO036' BEGIN SET @TIPOFACTURA=116 SET @TIPOANULACION=14 SET @RECONOCIMIENTO=53 END --HOMI
--IF @ID_COMPANY='INDIGO039' BEGIN SET @TIPOFACTURA=50 SET @TIPOANULACION=51 SET @RECONOCIMIENTO=55 END --SIEGOS Y SORDOS
IF @ID_COMPANY='INDIGO040' BEGIN SET @TIPOFACTURA=29 SET @TIPOANULACION=30 SET @RECONOCIMIENTO=92 SET @TIPOFACTURABASICA=90 END;--HOSPITAL SAN JOSE
--IF @ID_COMPANY='INDIGO041' BEGIN SET @TIPOFACTURA=68 SET @TIPOANULACION=69 SET @RECONOCIMIENTO=73 END; --SAN FRANCISCO
--IF @ID_COMPANY='INDIGO043' BEGIN SET @TIPOFACTURA=27 SET @TIPOANULACION=26 SET @RECONOCIMIENTO=46 END; --SAN ANTONIO DE PITALITO

---------------------------------1.CABECERA  DATOS DE FACTURACION EVENTOS UNICOS--------------------------- 
WITH CTE_FACTURADOS_UNICOS   
AS
(
SELECT DISTINCT
	 JVT.Code 'CODIGO COMPROBANTE', 
	 JVT.Description 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,
	 JV.EntityId,
	 CAST(JV.VoucherDate AS DATE) VoucherDate,
	 CAST(sum(JVD.CreditValue) as numeric) Valor_Credito,
	 AdmissionNumber
	FROM 
	 GeneralLedger.JournalVouchers JV 
	 INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger.JournalVoucherTypes JVT  ON JVT.Id = JV.IdJournalVoucher
	 INNER JOIN Billing.Invoice AS F  ON F.Id =JV.EntityId
	WHERE 
	 CAST(JV.VoucherDate AS DATE) BETWEEN @FECHAINI AND @FECHAFIN AND
	 JV.LegalBookId =1 AND jv.EntityName ='Invoice' AND F.DocumentType <> 5 AND IdJournalVoucher = @TIPOFACTURA
	GROUP BY JVT.Code, JV.Consecutive, JVT.Description, JV.EntityCode, JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber
),

----------------------------------2.CABECERA DATOS DE ANULACION UNICOS DE FACTURAS EVENTO------------------------------------------
CTE_ANULADOS_UNICOS
AS
(
  SELECT DISTINCT 
	 JVT.Code 'CODIGO COMPROBANTE', 
	 JVT.Description 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,
	 JV.EntityId,
	 CAST (JV.VoucherDate AS DATE) VoucherDate,
	 CAST (SUM(JVD.CreditValue) AS NUMERIC) Valor_Credito,
	 F.AdmissionNumber
	FROM 
	 GeneralLedger.JournalVouchers JV 
	 INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT  ON JVT.Id =JV.IdJournalVoucher
	 LEFT JOIN Billing .Invoice AS F  ON F.Id =JV.EntityId
	WHERE 
	 CAST(JV.VoucherDate AS DATE) BETWEEN @FECHAINI AND @FECHAFIN AND 
	 JV.LegalBookId = 1 AND jv.EntityName ='Invoice' AND F.DocumentType <> 5 AND IdJournalVoucher = @TIPOANULACION
    GROUP BY JVT.Code,JV.Consecutive,JVT.Description, JV.EntityCode,JV.EntityId,CAST(JV.VoucherDate AS DATE),F.AdmissionNumber
),

------------------------------3.CABECERA DATOS DE NO FACTURABLES UNICOS OSEA REGISTROS DE SERVICIOS DE GRUPOS DE ATENCION TIPOS PGP O CAPITA---------------
CTE_NO_FACTURABLES_UNICOS
AS
(
 SELECT DISTINCT  
   I.ID,I.AdmissionNumber,I.PatientCode,I.HealthAdministratorId,I.ThirdPartyId,I.CareGroupId,I.InvoiceNumber, I.InvoicedDate,CAST(I.TotalInvoice AS NUMERIC) TotalInvoice
  FROM 
   Billing.Invoice I 
  WHERE 
   I.DocumentType = 5 AND I.Status =1 AND CAST(I.InvoicedDate AS DATE) BETWEEN @FECHAINI AND @FECHAFIN
),

--SELECT * FROM CTE_FACTURADOS_UNICOS 

/********************************************************************************************************************
----------------------------------DATOS DE LAS CONSULTAS PRINCIPALES - DETALLADO-------------------------------------
*********************************************************************************************************************/

--------------------------------1. DETALLADO - TODOS LOS SERVICIOS CON ESTADO FACTURADO EVENTO----------------------------------------------

CTE_FACTURADOS_DETALLE
AS
(
  SELECT --CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'FACTURA SALUD' [TIPO DOCUMENTO],-- UNI.[CODIGO COMPROBANTE],UNI.[COMPROBANTE CONTABLE],UNI.[CONSECUTIVO CONTABLE],ISNULL(ids.Id ,sod.Id) IDDETALLE,
   'FACTURADO' AS ESTADO,YEAR(UNI.VoucherDate) AS AÑO,MONTH(UNI.VoucherDate) AS MES, DAY(UNI.VoucherDate) AS DIA,
   TP.Nit AS NIT,TP.Name AS ENTIDAD,CG.Code AS [CODIGO GRUPO ATENCION],CG.Name AS [GRUPO ATENCION],
   I.PatientCode AS IDENTIFICACION, RTRIM(PAC.IPNOMCOMP) AS PACIENTE,I.AdmissionNumber AS INGRESO,
   CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO], CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(G.[FECHA ALTA MEDICA] AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA], CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA], I.TotalInvoice AS [TOTAL FACTURA], I.TotalPatientSalesPrice 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' WHEN 2 THEN 'PRODUCTOS' END AS [TIPO REGISTRO],
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'
					     WHEN 2 then 'Patologias'
					     WHEN 3 then 'Imagenes Diagnosticas'
					     WHEN 4 then 'Procedimeintos no Qx'
					     WHEN 5 then 'Procedimientos Qx'
					     WHEN 6 then 'Interconsultas'
					     WHEN 7 then 'Ninguno'
					     WHEN 8 then 'Consulta Externa' ELSE 'Otro' END AS [TIPO SERVICIO],
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' 
					     WHEN 2 THEN 'QUIRURGICO'  
					     WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS PRESENTACION, 
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO',ICT.Name 'CATERGORIA FACTURA', 
   CAST(SOD.ServiceDate AS DATE) AS [FECHA SERVICIO],ISNULL(CUPS.Code,IPR.Code) AS [CUPS/PRODUCTO],ISNULL(CUPS.Description,IPR.Description ) AS DESCRIPCION, 
   ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity) 'CANTIDAD',ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice) 'VALOR SERVICIO',
   SOD.CostValue 'COSTO SERVICIO', ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice) 'VALOR UNITARIO',--'' 'TARIFA IVA', 0 'VALOR IVA',
   ID.SubTotalPatientSalesPrice 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE', ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode))) 'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL', ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO', COST.CODE 'CODIGO CC CONTABILIZO', COST.Name 'CENTRO COSTO CONTABILIZO',
   MA.Number 'NRO CUENTA CONTABILIZO',MA.Name 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION',MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO',ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN', CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END [TIPO INGRESO],CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO'--, CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM Billing.Invoice AS I 
  INNER JOIN CTE_FACTURADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
  INNER JOIN Billing.InvoiceDetail AS ID  ON ID.InvoiceId =I.Id 
  INNER JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id =ID.ServiceOrderDetailId 
  INNER JOIN Billing .ServiceOrder AS SO  ON SO.Id =SOD.ServiceOrderId 
  INNER JOIN Payroll.FunctionalUnit AS FU  ON FU.Id = SOD.PerformsFunctionalUnitId
  INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
  INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
  INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
  INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
  INNER JOIN dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =I.PatientCode
  LEFT JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId 
  LEFT JOIN Billing.BillingConcept AS BCT  ON CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Inventory.InventoryProduct AS IPR  ON IPR.Id = SOD.ProductId
  LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI  ON GLI.Id = IPR.IVAId
  LEFT JOIN Inventory.ProductGroup PG  ON PG.Id = IPR.ProductGroupId
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD  ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS  ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
  LEFT JOIN Contract .IPSService AS IPS  ON IPS.Id =IDS.IPSServiceId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN 
    (SELECT 
	 EGR.NUMINGRES 'INGRESO',
	 EGR.IPCODPACI 'IDENTIFICACION',
	 EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM 
	 HCREGEGRE EGR 
	 INNER JOIN (SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA' 
	             FROM DBO.HCREGEGRE EGR  
				 GROUP BY EGR.NUMINGRES,EGR.IPCODPACI)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
	) as G ON G.INGRESO =SO.AdmissionNumber  
  LEFT JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC   ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC  ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU  ON SU.CODUSUARI = i.InvoicedUser
  LEFT JOIN DBO.SEGusuaru SUSO  ON SUSO.CODUSUARI = SO.CreationUser 
  LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId
  WHERE SOD.RecordType=1 AND CUPS.ServiceType<>1  AND --CAST (UNI.VoucherDate  AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and 
  CUPS.Code not in ('5DSA01','PCF_0003','7DS003','S55115','5DS004','5DS002','5DS003') AND BCT.Code <>'300'
),

CTE_FACTURADOS_ANULADOS_DETALLE
AS
(
SELECT -- CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'FACTURA SALUD ANULADAS' [TIPO DOCUMENTO],--   UNI.[CODIGO COMPROBANTE],   UNI.[COMPROBANTE CONTABLE],   UNI.[CONSECUTIVO CONTABLE],   isnull(ids.Id ,sod.Id) IDDETALLE,
   'ANULADOS' AS 'ESTADO',YEAR(UNI.VoucherDate) 'AÑO', MONTH(UNI.VoucherDate) 'MES', DAY(UNI.VoucherDate) 'DIA',
   TP.Nit 'NIT',TP.Name 'ENTIDAD',CG.Code 'CODIGO GRUPO ATENCION', CG.Name 'GRUPO ATENCION',I.PatientCode 'IDENTIFICACION',RTRIM(PAC.IPNOMCOMP) 'PACIENTE',
   I.AdmissionNumber 'INGRESO',CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(G.[FECHA ALTA MEDICA] AS DATE) END  'FECHA EGRESO',
   I.InvoiceNumber 'NRO FACTURA', CAST(I.InvoiceDate AS DATE) 'FECHA FACTURA', I.TotalInvoice 'TOTAL FACTURA',
   I.TotalPatientSalesPrice 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' WHEN 2 THEN 'PRODUCTOS' END 'TIPO REGISTRO',
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'WHEN 2 then 'Patologias'WHEN 3 then 'Imagenes Diagnosticas'WHEN 4 then 'Procedimeintos no Qx'WHEN 5 then 'Procedimientos Qx'
   WHEN 6 then 'Interconsultas'WHEN 7 then 'Ninguno'WHEN 8 then 'Consulta Externa' ELSE 'Otro' end 'TIPO SERVICIO',
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END 'PRESENTACION',
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO', ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO',
   ICT.Name 'CATERGORIA FACTURA', cast(SOD.ServiceDate AS DATE) 'FECHA SERVICIO', 
   ISNULL(CUPS.Code,IPR.Code)'CUPS/PRODUCTO',ISNULL(CUPS.Description,IPR.Description )'DESCRIPCION',ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',(ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity))*-1 'CANTIDAD',(ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice))*-1 'VALOR SERVICIO',SOD.CostValue*-1 'COSTO SERVICIO',
   (ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice))*-1 'VALOR UNITARIO',-- '' 'TARIFA IVA', 0 'VALOR IVA',
   ID.SubTotalPatientSalesPrice 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   (ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice))*-1 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE', ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit))'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL',ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',COST.CODE 'CODIGO CC CONTABILIZO',COST.Name 'CENTRO COSTO CONTABILIZO',MA.Number 'NRO CUENTA CONTABILIZO',
   MA.Name 'CUENTA CONTABILIZO',  CAST(I.AnnulmentDate AS DATE) 'FECHA ANULACION',  MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO', ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN', CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END [TIPO INGRESO], CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO'--,   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  FROM Billing.Invoice AS I 
   INNER JOIN CTE_ANULADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
   INNER JOIN Billing .InvoiceDetail AS ID  ON ID.InvoiceId =I.Id 
   INNER JOIN Billing .ServiceOrderDetail AS SOD   ON SOD.Id =ID.ServiceOrderDetailId
   INNER JOIN Billing .ServiceOrder AS SO  ON SO.Id =SOD.ServiceOrderId
   INNER JOIN Payroll.FunctionalUnit AS FU  ON FU.Id = SOD.PerformsFunctionalUnitId
   INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
   INNER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract .CareGroup AS CG   ON CG.Id =I.CareGroupId 
   INNER JOIN DBO.INPACIENT AS PAC  ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
   LEFT JOIN Billing.BillingConcept AS BCT  ON CUPS.BillingConceptId = BCT.Id
   LEFT JOIN Inventory.InventoryProduct AS IPR  ON IPR.Id = SOD.ProductId
   --LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI  ON GLI.Id = IPR.IVAId
   LEFT JOIN Inventory.ProductGroup PG  ON PG.Id = IPR.ProductGroupId
   LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
   LEFT JOIN Contract .ContractDescriptions AS CD  ON CD.ID=DESCR.ContractDescriptionId
   LEFT JOIN Billing .ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
   LEFT JOIN Billing .ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
   LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
   LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
   LEFT JOIN Billing .InvoiceDetailSurgical AS IDS  ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
   LEFT JOIN Contract .IPSService AS IPS   ON IPS.Id =IDS.IPSServiceId 
   LEFT JOIN dbo.INPROFSAL AS MEDQX   ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
   LEFT JOIN
  (SELECT 
	 EGR.NUMINGRES 'INGRESO',
	 EGR.IPCODPACI 'IDENTIFICACION',
	 EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM 
	 HCREGEGRE EGR 
	 INNER JOIN (SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA' 
	             FROM DBO.HCREGEGRE EGR  
				 GROUP BY EGR.NUMINGRES,EGR.IPCODPACI)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
	) as G ON G.INGRESO =SO.AdmissionNumber   
   LEFT JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
   LEFT JOIN MedicalFees.HealthProfessionalContract HPC  ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
   LEFT JOIN MedicalFees.MedicalFeesContract MFC  ON MFC.Id = HPC.MedicalFeesContractId
   LEFT JOIN DBO.SEGusuaru SU  ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUSO  ON SUSO.CODUSUARI = SO.CreationUser 
   LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId
   WHERE SOD.RecordType=1 AND CUPS.ServiceType<>1  AND --CAST (UNI.VoucherDate  AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and 
  CUPS.Code not in ('5DSA01','PCF_0003','7DS003','S55115','5DS004','5DS002','5DS003') AND BCT.Code <>'300'
),

CTE_REGISTROS_SERVICIOS_DETALLE
AS
(
  SELECT --CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'REGISTROS DE SERVICIOS' [TIPO DOCUMENTO],-- '' [CODIGO COMPROBANTE],'' [COMPROBANTE CONTABLE],'' [CONSECUTIVO CONTABLE],ISNULL(ids.Id ,sod.Id) IDDETALLE,
   'FACTURADO' AS ESTADO,YEAR(UNI.InvoicedDate) AS AÑO,MONTH(UNI.InvoicedDate) AS MES,DAY(UNI.InvoicedDate) AS DIA,
   TP.Nit AS NIT,TP.Name AS ENTIDAD,CG.Code AS [CODIGO GRUPO ATENCION],CG.Name AS [GRUPO ATENCION],
   I.PatientCode AS IDENTIFICACION,RTRIM(PAC.IPNOMCOMP) AS PACIENTE,I.AdmissionNumber AS INGRESO,
   CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO], CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(G.[FECHA ALTA MEDICA] AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA], CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],I.TotalInvoice AS [TOTAL FACTURA], 
   I.TotalPatientSalesPrice 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' WHEN 2 THEN 'PRODUCTOS' END AS [TIPO REGISTRO],
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'
					     WHEN 2 then 'Patologias'
					     WHEN 3 then 'Imagenes Diagnosticas'
					     WHEN 4 then 'Procedimeintos no Qx'
					     WHEN 5 then 'Procedimientos Qx'
					     WHEN 6 then 'Interconsultas'
					     WHEN 7 then 'Ninguno'
					     WHEN 8 then 'Consulta Externa' ELSE 'Otro' END AS [TIPO SERVICIO],
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' 
					     WHEN 2 THEN 'QUIRURGICO'  
					     WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS PRESENTACION, 
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO',
   ICT.Name 'CATERGORIA FACTURA', CAST(SOD.ServiceDate AS DATE) AS [FECHA SERVICIO], 
   ISNULL(CUPS.Code,IPR.Code) AS [CUPS/PRODUCTO],ISNULL(CUPS.Description,IPR.Description ) AS DESCRIPCION, 
   ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX',SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity) 'CANTIDAD',
   ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice) 'VALOR SERVICIO',SOD.CostValue 'COSTO SERVICIO',
   ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice) 'VALOR UNITARIO',--'' 'TARIFA IVA', 0 'VALOR IVA',
   ID.SubTotalPatientSalesPrice 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE', ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode))) 'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL', ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',COST.CODE 'CODIGO CC CONTABILIZO', COST.Name 'CENTRO COSTO CONTABILIZO', MA.Number 'NRO CUENTA CONTABILIZO',
   MA.Name 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION', MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO', ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END [TIPO INGRESO],CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO'--,CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM 
  Billing.Invoice AS I 
  INNER JOIN CTE_NO_FACTURABLES_UNICOS AS UNI ON UNI.ID =I.Id 
  INNER JOIN Billing.InvoiceDetail AS ID  ON ID.InvoiceId =I.Id 
  INNER JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id =ID.ServiceOrderDetailId
  INNER JOIN Billing .ServiceOrder AS SO  ON SO.ID=SOD.ServiceOrderId 
  INNER JOIN Payroll.FunctionalUnit AS FU  ON FU.Id = SOD.PerformsFunctionalUnitId
  INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
  INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
  INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
  INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
  INNER JOIN dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =I.PatientCode
  LEFT JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
  LEFT JOIN Billing.BillingConcept AS BCT  ON CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Inventory.InventoryProduct AS IPR  ON IPR.Id = SOD.ProductId
  --LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI  ON GLI.Id = IPR.IVAId
  LEFT JOIN Inventory.ProductGroup PG  ON PG.Id = IPR.ProductGroupId
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD  ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS  ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
  LEFT JOIN Contract .IPSService AS IPS  ON IPS.Id =IDS.IPSServiceId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN 
  (SELECT 
	 EGR.NUMINGRES 'INGRESO',
	 EGR.IPCODPACI 'IDENTIFICACION',
	 EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM 
	 HCREGEGRE EGR 
	 INNER JOIN (SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA' 
	             FROM DBO.HCREGEGRE EGR  
				 GROUP BY EGR.NUMINGRES,EGR.IPCODPACI)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
	) as G ON G.INGRESO =SO.AdmissionNumber   
  LEFT JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC   ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC  ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU  ON SU.CODUSUARI = i.InvoicedUser
  LEFT JOIN DBO.SEGusuaru SUSO  ON SUSO.CODUSUARI = SO.CreationUser
  LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId
  WHERE SOD.RecordType=1 AND CUPS.ServiceType<>1  AND --CAST (UNI.VoucherDate  AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and 
  CUPS.Code not in ('5DSA01','PCF_0003','7DS003','S55115','5DS004','5DS002','5DS003') AND BCT.Code <>'300'
),

CTE_PENDIENTE_FACTUAR_DETALLADO_EVENTO
AS
(
 SELECT --CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'EVENTO PENDIENTE DE FACTURAR' as 'TIPO DOCUMENTO',--   0 as 'CODIGO COMPROBANTE',   NULL as 'COMPROBANTE CONTABLE',   0 as 'CONSECUTIVO CONTABLE',   isnull(SODS.Id ,sod.Id) IDDETALLE,
   'RECONOCIDOS SIN FACTURAR' AS 'ESTADO', YEAR(SOD.ServiceDate)'AÑO',MONTH(SOD.ServiceDate)'MES', DAY(SOD.ServiceDate)'DIA',
   TP.Nit 'NIT',TP.Name 'ENTIDAD',CG.Code 'CODIGO GRUPO ATENCION',CG.Name 'GRUPO ATENCION',SO.PatientCode 'IDENTIFICACION', RTRIM(PAC.IPNOMCOMP) 'PACIENTE',SO.AdmissionNumber 'INGRESO',
   CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO', G.[FECHA ALTA MEDICA] 'FECHA EGRESO',
   'N/A' 'NRO FACTURA',NULL 'FECHA FACTURA', '0' 'TOTAL FACTURA',0 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' WHEN 2 THEN 'PRODUCTOS' END 'TIPO REGISTRO',
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'WHEN 2 then 'Patologias'WHEN 3 then 'Imagenes Diagnosticas'WHEN 4 then 'Procedimeintos no Qx'WHEN 5 then 'Procedimientos Qx'
   WHEN 6 then 'Interconsultas'WHEN 7 then 'Ninguno'WHEN 8 then 'Consulta Externa' ELSE 'Otro' end 'TIPO SERVICIO',
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END 'PRESENTACION',
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO', '' as 'CATERGORIA FACTURA',
   CAST(SOD.ServiceDate AS DATE) 'FECHA SERVICIO',
   ISNULL(CUPS.Code,IPR.Code)'CUPS/PRODUCTO',ISNULL(CUPS.Description,IPR.Description )'DESCRIPCION',ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name),'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',   ISNULL(SODS.InvoicedQuantity,SOD.InvoicedQuantity) 'CANTIDAD',ISNULL(SODS.RateManualSalePrice,SOD.RateManualSalePrice) 'VALOR SERVICIO',SOD.CostValue 'COSTO SERVICIO',
   ISNULL(SODS.RateManualSalePrice,SOD.TotalSalesPrice) 'VALOR UNITARIO',-- NULL as 'TARIFA IVA', 0 as 'VALOR IVA',
   0 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   ISNULL(SODS.TotalSalesPrice,SOD.GrandTotalSalesPrice) 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',ISNULL(SODS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit))'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL',ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' , FU.Name 'UNIDAD SOLICITO',COST.CODE 'CODIGO CC CONTABILIZO',COST.Name 'CENTRO COSTO CONTABILIZO',
   MA.Number 'NRO CUENTA CONTABILIZO',MA.Name 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION',
   MFC.ContractName 'AGREMIACION', SU.NOMUSUARI 'USUARIO',  ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
   CAST(SO.CreationDate AS DATE) 'FECHA ORDEN', CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END [TIPO INGRESO],
   CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO'--,CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  FROM Contract.CareGroup cg 
  INNER JOIN Billing.RevenueControlDetail rcd  ON cg.Id = rcd.CareGroupId
  INNER JOIN Billing.RevenueControl rc on rc.Id = rcd.RevenueControlId
  INNER JOIN Billing.ServiceOrderDetailDistribution sodd  on sodd.RevenueControlDetailId = rcd.Id
  INNER JOIN Billing.ServiceOrderDetail sod  on sodd.ServiceOrderDetailId = sod.Id --AND YEAR(SOD.ServiceDate)=YEAR(GETDATE()) AND MONTH(SOD.ServiceDate)=MONTH(GETDATE())
  INNER JOIN Billing.ServiceOrder AS SO  ON SO.Id =SOD.ServiceOrderId
  INNER JOIN Payroll.FunctionalUnit fu  on fu.Id = sod.PerformsFunctionalUnitId
  INNER JOIN Common .ThirdParty AS TP  ON TP.Id =RCD.ThirdPartyId
  INNER JOIN DBO.INPACIENT AS PAC  ON PAC.IPCODPACI =SO.PatientCode
  INNER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =RC.AdmissionNumber
  INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
  LEFT JOIN Contract.CUPSEntity CUPS  on sod.CUPSEntityId = CUPS.Id
  LEFT JOIN Billing.BillingConcept BCT  on CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Inventory.InventoryProduct ipr  on sod.ProductId = ipr.Id
  LEFT JOIN Inventory.ProductGroup pg  ON ipr.ProductGroupId = pg.Id
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD  ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing.ServiceOrderDetailSurgical AS SODS  ON SODS.ServiceOrderDetailId =SOD.Id AND SODS.OnlyMedicalFees = '0' AND SODS.SurchargeApply <>1
  LEFT JOIN Contract .IPSService AS IPS  ON IPS.Id =SODS.IPSServiceId 
  LEFT JOIN Billing .ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId
  LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =ISNULL(SODS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC  ON HPC.HealthProfessionalCode =  ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC  ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU  ON SU.CODUSUARI = ING.CODUSUCRE 
  LEFT JOIN DBO.SEGusuaru SUSO  ON SUSO.CODUSUARI = SO.CreationUser
  LEFT JOIN 
    (SELECT 
	 EGR.NUMINGRES 'INGRESO',
	 EGR.IPCODPACI 'IDENTIFICACION',
	 EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM 
	 HCREGEGRE EGR 
	 INNER JOIN (SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA' 
	             FROM DBO.HCREGEGRE EGR  
				 GROUP BY EGR.NUMINGRES,EGR.IPCODPACI)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
	) as G ON G.INGRESO =SO.AdmissionNumber 
 WHERE SOD.RecordType=1  AND CAST(SOD.ServiceDate AS DATE) BETWEEN  @FECHAINI AND @FECHAFIN AND
  rcd.Status in (1,3) AND sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND 
  cg.LiquidationType In (1, 3) and iNG.IESTADOIN IN (' ', 'P') AND CUPS.ServiceType<>1  AND --CAST (UNI.VoucherDate  AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and 
  CUPS.Code not in ('5DSA01','PCF_0003','7DS003','S55115','5DS004','5DS002','5DS003') AND BCT.Code <>'300'
),

CTE_PENDIENTE_FACTURAR_REGISTROS_SERVICIOS_EVENTO
AS
(
   SELECT --CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'REGISTROS DE SERVICIOS PENDIENTE FACTURAR' as 'TIPO DOCUMENTO',-- 0 as 'CODIGO COMPROBANTE', NULL as 'COMPROBANTE CONTABLE', 0 as 'CONSECUTIVO CONTABLE',isnull(SODS.Id ,sod.Id) IDDETALLE,
   'REGISTROS DE SERVICIOS PENDIENTES DE LIQUIDAR' AS 'ESTADO',YEAR(SOD.ServiceDate)'AÑO',MONTH(SOD.ServiceDate)'MES', DAY(SOD.ServiceDate)'DIA',
   TP.Nit 'NIT',TP.Name 'ENTIDAD',CG.Code 'CODIGO GRUPO ATENCION',CG.Name 'GRUPO ATENCION',SO.PatientCode 'IDENTIFICACION',
   RTRIM(PAC.IPNOMCOMP) 'PACIENTE',SO.AdmissionNumber 'INGRESO',CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',G.[FECHA ALTA MEDICA] 'FECHA EGRESO',
   'N/A' 'NRO FACTURA',NULL 'FECHA FACTURA', '0' 'TOTAL FACTURA',   
   0 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' WHEN 2 THEN 'PRODUCTOS' END 'TIPO REGISTRO',
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'WHEN 2 then 'Patologias'WHEN 3 then 'Imagenes Diagnosticas'WHEN 4 then 'Procedimeintos no Qx'WHEN 5 then 'Procedimientos Qx'
   WHEN 6 then 'Interconsultas'WHEN 7 then 'Ninguno'WHEN 8 then 'Consulta Externa' ELSE 'Otro' end 'TIPO SERVICIO',
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END 'PRESENTACION',
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO', '' as 'CATERGORIA FACTURA',
   CAST(SOD.ServiceDate AS DATE) 'FECHA SERVICIO',
   ISNULL(CUPS.Code,IPR.Code)'CUPS/PRODUCTO',ISNULL(CUPS.Description,IPR.Description )'DESCRIPCION',ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name),'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',   ISNULL(SODS.InvoicedQuantity,SOD.InvoicedQuantity) 'CANTIDAD',ISNULL(SODS.RateManualSalePrice,SOD.RateManualSalePrice) 'VALOR SERVICIO',SOD.CostValue 'COSTO SERVICIO',
   ISNULL(SODS.RateManualSalePrice,SOD.TotalSalesPrice) 'VALOR UNITARIO',-- NULL as 'TARIFA IVA', 0 as 'VALOR IVA',
   0 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   ISNULL(SODS.TotalSalesPrice,SOD.GrandTotalSalesPrice) 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',ISNULL(SODS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit))'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL',ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',COST.CODE 'CODIGO CC CONTABILIZO',COST.Name 'CENTRO COSTO CONTABILIZO',MA.Number 'NRO CUENTA CONTABILIZO',
   MA.Name 'CUENTA CONTABILIZO', NULL 'FECHA ANULACION', MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO',ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END [TIPO INGRESO],
   CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO'--,CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  FROM Contract.CareGroup cg 
  INNER JOIN Billing.RevenueControlDetail rcd  ON cg.Id = rcd.CareGroupId
  INNER JOIN Billing.RevenueControl rc on rc.Id = rcd.RevenueControlId
  INNER JOIN Billing.ServiceOrderDetailDistribution sodd  on sodd.RevenueControlDetailId = rcd.Id
  INNER JOIN Billing.ServiceOrderDetail sod  on sodd.ServiceOrderDetailId = sod.Id --AND YEAR(SOD.ServiceDate)=YEAR(GETDATE()) AND MONTH(SOD.ServiceDate)=MONTH(GETDATE())
  INNER JOIN Billing.ServiceOrder AS SO  ON SO.Id =SOD.ServiceOrderId
  INNER JOIN Payroll.FunctionalUnit fu  on fu.Id = sod.PerformsFunctionalUnitId
  INNER JOIN Common .ThirdParty AS TP  ON TP.Id =RCD.ThirdPartyId
  INNER JOIN DBO.INPACIENT AS PAC  ON PAC.IPCODPACI =SO.PatientCode
  INNER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =RC.AdmissionNumber
  INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
  LEFT JOIN Contract.CUPSEntity CUPS  on sod.CUPSEntityId = CUPS.Id
  LEFT JOIN Billing.BillingConcept BCT  on CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Inventory.InventoryProduct ipr  on sod.ProductId = ipr.Id
  LEFT JOIN Inventory.ProductGroup pg  ON ipr.ProductGroupId = pg.Id
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR  ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD  ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing.ServiceOrderDetailSurgical AS SODS  ON SODS.ServiceOrderDetailId =SOD.Id AND SODS.OnlyMedicalFees = '0' AND SODS.SurchargeApply <>1
  LEFT JOIN Contract .IPSService AS IPS  ON IPS.Id =SODS.IPSServiceId 
  LEFT JOIN Billing .ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId
  LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =ISNULL(SODS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC  ON HPC.HealthProfessionalCode =  ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC  ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU  ON SU.CODUSUARI = ING.CODUSUCRE 
  LEFT JOIN DBO.SEGusuaru SUSO  ON SUSO.CODUSUARI = SO.CreationUser
  LEFT JOIN 
    (SELECT 
	 EGR.NUMINGRES 'INGRESO',
	 EGR.IPCODPACI 'IDENTIFICACION',
	 EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM 
	 HCREGEGRE EGR 
	 INNER JOIN (SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA' 
	             FROM DBO.HCREGEGRE EGR  
				 GROUP BY EGR.NUMINGRES,EGR.IPCODPACI)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
	) as G ON G.INGRESO =SO.AdmissionNumber 
 WHERE  SOD.RecordType=1  AND CAST(SOD.ServiceDate AS DATE) BETWEEN  @FECHAINI AND @FECHAFIN AND
  rcd.Status in (1,3) AND  sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND cg.LiquidationType In (2) and iNG.IESTADOIN IN (' ', 'P')
  AND CUPS.ServiceType<>1  AND --CAST (UNI.VoucherDate  AS DATE) BETWEEN @FECHAINI AND @FECHAFIN and 
  CUPS.Code not in ('5DSA01','PCF_0003','7DS003','S55115','5DS004','5DS002','5DS003') AND BCT.Code <>'300'
)



SELECT * FROM CTE_FACTURADOS_DETALLE
UNION ALL
SELECT * FROM CTE_FACTURADOS_ANULADOS_DETALLE
UNION ALL
SELECT * FROM CTE_REGISTROS_SERVICIOS_DETALLE
UNION ALL
SELECT * FROM CTE_PENDIENTE_FACTUAR_DETALLADO_EVENTO
UNION ALL
SELECT * FROM CTE_PENDIENTE_FACTURAR_REGISTROS_SERVICIOS_EVENTO