-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: UploadCubeVieRCMProductivityAnalysisMath
-- Extracted by Fabric SQL Extractor SPN v3.9.0


-----****************************************************************************************************************************************************************************----
----****************************** SCRIPT PARA TRAER LOS DATOS DE PRODUCTIVIDAD DE TODOS LOS SERVICIOS CARGADOS A ORDENES DE SERVICIO *******************************************----
-----****************************************************************************************************************************************************************************----

CREATE view [Report].[UploadCubeVieRCMProductivityAnalysisMath] AS

SELECT  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,CASE CG.LiquidationType WHEN 1 THEN 'PAGO EVENTO' WHEN 2 THEN 'PAGO PGP' WHEN 3 THEN 'PAGO GLOBAL' WHEN 4 THEN 'PAGO GLOBA'
    WHEN 5 THEN 'PAGO PGP' END 'TIPO DOCUMENTO',    IIF(SOD.Packaging=1,G.[ESTADO],CASE I.Status WHEN 1 THEN 'FACTURADO' WHEN 2 THEN 'ANULADO' ELSE 'SIN FACTURAR' END) 'ESTADO REGISTRO',
   TP.Nit AS 'NIT',  TP.Name AS 'ENTIDAD', CG.Code AS 'CODIGO GRUPO ATENCION',CG.Name AS 'GRUPO ATENCION',
   CASE CG.EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado'
   WHEN 3 THEN 'ET Vinculados Municipios' WHEN 4 THEN 'ET Vinculados Departamentos' WHEN 5 THEN 'ARL Riesgos Laborales' WHEN 6 THEN 'MP Medicina Prepagada'
   WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito' WHEN 11 THEN 'Fosyga' WHEN 12 THEN 'Otros'
   WHEN 13 THEN 'Aseguradoras' WHEN 99 THEN 'Particulares' ELSE 'Otros' END 'REGIMEN',ISNULL(RC.PatientCode,SO.PatientCode) AS 'IDENTIFICACION PACIENTE',
   RTRIM(PAC.IPNOMCOMP) AS 'NOMBRE PACIENTE',  ISNULL(RC.AdmissionNumber,SO.AdmissionNumber) AS 'INGRESO', CASE ING.IESTADOIN WHEN ' ' THEN 'INGRESO ABIERTO' WHEN 'F' THEN 'INGRESO FACTURADO' 
   WHEN 'A' THEN 'INGRESO ANULADO' WHEN 'C' THEN 'INGRESO CERRADO' WHEN 'P' THEN 'INGRESO PARCIAL' END 'ESTADO INGRESO', CAST(ING.IFECHAING AS DATE) AS 'FECHA INGRESO',
   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST( ISNULL(ALT.[FECHA ALTA MEDICA],ING.FECHEGRESO) AS DATE) END AS 'FECHA EGRESO',  
   IIF(SOD.Packaging=1,G.InvoiceNumber,I.InvoiceNumber) AS 'NRO FACTURA',CAST(IIF(SOD.Packaging=1,G.InvoiceDate,I.InvoiceDate) AS DATE) AS 'FECHA FACTURA',
   ISNULL(CAST(IIF(SOD.Packaging=1,G.TotalInvoice,I.TotalInvoice) AS NUMERIC),0) 'TOTAL FACTURA',   
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' WHEN 2 THEN 'PRODUCTOS' END AS 'TIPO REGISTRO',
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'
 					   WHEN 2 then 'Patologias'
 					   WHEN 3 then 'Imagenes Diagnosticas'
 					   WHEN 4 then 'Procedimeintos no Qx'
 					   WHEN 5 then 'Procedimientos Qx'
 					   WHEN 6 then 'Interconsultas'
 					   WHEN 7 then 'Ninguno'
 					   WHEN 8 then 'Consulta Externa' ELSE 'Otro' END AS 'TIPO SERVICIO',
  CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' 
 					   WHEN 2 THEN 'QUIRURGICO' 
 					   WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS PRESENTACION, ISNULL(BG.CODE  + ' - ' + BG.NAME,PG.CODE  + ' - ' + PG.NAME) 'GRUPO FACTURACION',
  CAST(SOD.ServiceDate AS DATE) AS 'FECHA SERVICIO', 
  ISNULL(CUPS.Code,IPR.Code) AS 'CUPS/PRODUCTO',
  ISNULL(CUPS.Description,IPR.Description ) AS 'DESCRIPCION',ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'),1,60) AS 'DESCRIPCION DETALLE QX',
  CASE IPS.ServiceClass WHEN 1 THEN 'Ninguno' WHEN 2 THEN 'Cirujano' WHEN 3 THEN 'Anestesiologo' WHEN 4 THEN 'Ayudante' WHEN 5 THEN 'Derecho Sala' WHEN 6 THEN 'Materiales Sutura'
  WHEN 7 THEN 'Instrumentacion Quirurgica' ELSE 'Ninguno' end 'TIPO SERVICIO IPS',
  ISNULL(SODS.InvoicedQuantity,SOD.InvoicedQuantity) 'CANTIDAD',ISNULL(SODS.RateManualSalePrice,SOD.RateManualSalePrice) 'VALOR SERVICIO',
  CAST(ISNULL(SOD.CostValue,0) AS NUMERIC) 'COSTO SERVICIO',  ISNULL(SODS.RateManualSalePrice,SOD.TotalSalesPrice) 'VALOR UNITARIO',
  ISNULL(SODS.TotalSalesPrice,SOD.GrandTotalSalesPrice) 'VALOR DETALLE TOTAL',IIF(SOD.Packaging=1,0,ISNULL(SODS.TotalSalesPrice,SOD.GrandTotalSalesPrice)) 'VALOR TOTAL',
  CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
  ISNULL(CUPSP.Code,'N/A') 'CODIGO PAQUETE',ISNULL(CUPSP.Description,'N/A') 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
  WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION',ISNULL(CUPSI.Code,'N/A') 'CUPS QUE INCLUYE',
  ISNULL(CUPSI.Description,'N/A') 'NOMBRE CUPS QUE INCLUYE',ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',
  CASE UnitType WHEN 1 THEN 'Urgencias' WHEN 2 THEN 'Hospitalizacion' WHEN 3 THEN 'Apoyo Dx' WHEN 4 THEN 'Apoyo Terapeutico' WHEN 5 THEN 'Unidades de Cuidado Intensivo Adulto'
  WHEN 6 THEN 'Unidades de Cuidado Intermedio Adulto' WHEN 7 THEN  'Unidades de Cuidado Intensivo Pediatrica' WHEN 8 THEN 'Unidades de Cuidado Intermedio Pediatrica'
  WHEN 9 THEN 'Unidades de Cuidado Intensivo Neonatal' WHEN 10 THEN 'Unidades de Cuidado Intermedio Neonatal' WHEN 11 THEN 'Unidades de Cuidado Basico Neonatal'
  WHEN 12 THEN 'Unidad Renal' WHEN 13 THEN 'Unidad Oncologica' WHEN 14 THEN 'Unidad Medicina Nuclear' WHEN 15 THEN 'Consulta Externa' WHEN 16 THEN 'Unidad Mental' 
  WHEN 17 THEN 'Unidad de Quemados' WHEN 18 THEN 'Unidad de Cuidado Paliativo' WHEN 19 THEN 'Cirugia' WHEN 20 THEN 'Laboratorio' WHEN 21 THEN 'Cardiologia No Invasiva' 
  WHEN 22 THEN 'Cardiologia Invasiva' WHEN 23 THEN  'Gineco-Obstetricia'  WHEN 24 THEN 'Consulta Externa - Gineco-Obstetricia' WHEN 25 THEN 'Otras' ELSE 'Otras' END 'TIPO UNIDAD',
  ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
  CAST(PAC.IPFECNACI AS DATE) AS 'FECHA NACIMIENTO',CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END 'TIPO INGRESO',
  DIA.CODDIAGNO 'CIE 10',DIA.NOMDIAGNO 'DIAGNOSTICO',SO.CODE 'CODIGO ORDEN',SO.TimeStamp 'TIMESTAMP',SOD.ID 'ID DETALLE ORDEN'

FROM Billing.ServiceOrder AS SO
  INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
  LEFT JOIN Billing.ServiceOrderDetailDistribution sodd on sodd.ServiceOrderDetailId = sod.Id
  LEFT JOIN Billing.RevenueControlDetail as RCD ON RCD.Id=sodd.RevenueControlDetailId
  LEFT JOIN Billing.RevenueControl RC ON  RC.Id=RCD.RevenueControlId and SO.AdmissionNumber=RC.AdmissionNumber
  LEFT JOIN Billing.Invoice AS I ON I.AdmissionNumber=RC.AdmissionNumber AND I.RevenueControlDetailId=RCD.id
  LEFT JOIN Billing.InvoiceDetail AS ID ON ID.InvoiceId=I.Id and SOD.Id =ID.ServiceOrderDetailId
  LEFT JOIN
   (
   SELECT SOD.ID,SOD.CUPSEntityId,SOD.IPSServiceId,I.InvoiceNumber,I.TotalInvoice,I.InvoiceDate,
   CASE DocumentType WHEN 1 THEN 'EVENTO' when 2 THEN 'EVENTO' WHEN 3 THEN 'EVENTO' WHEN 4 THEN 'CAPITADA' 
   WHEN 5 THEN 'PGP' WHEN 6 THEN 'FACTURA BASICA' WHEN 7 THEN 'FACTURA VENTA PRODUCTOS' ELSE 'NO FACTURADO' END 'TIPO DOCUMENTO',
   CASE I.Status WHEN 1 THEN 'FACTURADO' WHEN 2 THEN 'ANULADO' ELSE 'SIN FACTURAR' END 'ESTADO'

   FROM Billing.ServiceOrder AS SO
    INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
    LEFT JOIN Billing.ServiceOrderDetailDistribution sodd on sodd.ServiceOrderDetailId = sod.Id
    LEFT JOIN Billing.RevenueControlDetail as RCD ON RCD.Id=sodd.RevenueControlDetailId
    LEFT JOIN Billing.RevenueControl RC ON  RC.Id=RCD.RevenueControlId and SO.AdmissionNumber=RC.AdmissionNumber
    LEFT JOIN Billing.Invoice AS I ON I.AdmissionNumber=RC.AdmissionNumber AND I.RevenueControlDetailId=RCD.id
    LEFT JOIN Billing.InvoiceDetail AS ID ON ID.InvoiceId=I.Id and SOD.Id =ID.ServiceOrderDetailId
     WHERE SOD.IsPackage=1
   ) AS G ON G.Id=SOD.PackageServiceOrderDetailId
   LEFT JOIN Common.ThirdParty AS TP  ON TP.Id =ISNULL(RCD.ThirdPartyId,SOD.ThirdPartyId)
   LEFT JOIN Contract.CareGroup AS CG  ON CG.Id =ISNULL(RCD.CareGroupId,SOD.CareGroupId)
   LEFT JOIN dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =ISNULL(RC.PatientCode,SO.PatientCode)
   LEFT JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES =ISNULL(RC.AdmissionNumber,SO.AdmissionNumber)
   LEFT JOIN
   (
    SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION',EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM HCREGEGRE EGR 
	INNER JOIN
	( SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA'  
	  FROM DBO.HCREGEGRE EGR 
	  GROUP BY EGR.NUMINGRES,EGR.IPCODPACI
    ) AS G ON G.INGRESO=EGR.NUMINGRES
	) AS ALT ON ALT.INGRESO=ING.NUMINGRES
   LEFT JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
   LEFT JOIN Inventory.InventoryProduct AS IPR  ON IPR.Id = SOD.ProductId
   LEFT JOIN Billing.BillingGroup as BG ON BG.Id=CUPS.BillingGroupId
   LEFT JOIN Inventory.ProductGroup AS PG ON PG.Id=IPR.ProductGroupId
   LEFT JOIN Billing.ServiceOrderDetailSurgical AS SODS  ON SODS.ServiceOrderDetailId =SOD.Id AND SODS.OnlyMedicalFees = '0' AND SODS.SurchargeApply <>1
   LEFT JOIN Contract.IPSService AS IPS  ON IPS.Id =SODS.IPSServiceId
   LEFT JOIN Billing.ServiceOrderDetail AS SODP  ON SODP.Id =SOD.PackageServiceOrderDetailId
   LEFT JOIN Contract.CUPSEntity AS CUPSP  ON CUPSP.Id = SODP.CUPSEntityId
   LEFT JOIN Billing.ServiceOrderDetail AS SODI  ON SODI.Id =SOD.IncludeServiceOrderDetailId
   LEFT JOIN Contract.CUPSEntity AS CUPSI  ON CUPSI.Id = SODI.CUPSEntityId
   LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
   LEFT JOIN Common.ThirdParty AS TPT  ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId
   LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
   LEFT JOIN Payroll.FunctionalUnit FU  ON FU.Id = SOD.PerformsFunctionalUnitId
   LEFT JOIN DBO.SEGusuaru SUSO  ON SUSO.CODUSUARI = SO.CreationUser
   LEFT JOIN DBO.INDIAGNOS AS DIA ON DIA.CODDIAGNO= ISNULL(ING.CODDIAEGR,ING.CODDIAING)
  
  WHERE SO.Status <>3 AND SOD.IsDelete=0 and SOD.InvoicedQuantity>0 
  --AND I.RevenueControlDetailId IS NOT NULL
  --AND -- YEAR(SOD.ServiceDate)=2023 AND MONTH(SOD.ServiceDate) =10 AND 
  --  AND SO.AdmissionNumber='760B804A4A' --'84445'--'84079'--'69889' --.... '71306' --'67759 '  '66101' -- '100677' ------    --  --'