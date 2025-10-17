-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: UploadVieRCMImagesProductivity
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: [Report].[UploadVieRCMImagesProductivity]
Tipo:Procedimiento Vista
Observacion:Productividad de imagenologia
Profesional:Andres Cabrera
Fecha Creación:12-08-2024
Profesional revisión:
Fecha Revisión:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
--------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/
CREATE VIEW [Report].[UploadVieRCMImagesProductivity]
AS

WITH CTE_CUPS
AS
(
   SELECT CUPS.Id,CUPS.Code [CUPS], CUPS.Description [DESCRIPCION CUPS], 
   CASE CUPS.ServiceType WHEN 1 then 'LABORATORIOS' WHEN 2 then 'PATOLOGIAS' WHEN 3 then 'IMAGENES DIAGNOSTICAS' WHEN 4 then 'PROCEDIMIENTOS NO QX'
   WHEN 5 then 'PROCEDIMIENTOS QX' WHEN 6 then 'INTERCONSULTAS'WHEN 7 then 'NINGUNO'WHEN 8 then 'CONSULTA EXTERNA' WHEN 9 THEN 'HEMOCOMPONENTES' ELSE 'OTROS' END AS 'TIPO SERVICIO',
   BG.CODE 'CODIGO FACTURACION',BG.NAME 'GRUPO FACTURACION',BC.CODE 'CODIGO CONCEPTO',BC.NAME 'CONCEPTO FACTURACION',CGC.Code 'CODIGO GRUPO',CGC.Name 'GRUPO CUPS',
   CSG.CODE 'CODIGO SUBGRUPO',CSG.Name  'SUBGRUPO CUPS',
   CASE ObtainCostCenter WHEN 1 THEN 'Unidad Funcional del Paciente' WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
   ELSE 'N/A' END 'OBTENER CC',CUPS.ServiceType
   FROM Contract.CUPSEntity AS CUPS
   INNER JOIN Billing.BillingGroup as BG WITH (NOLOCK) ON BG.Id=CUPS.BillingGroupId
   INNER JOIN Billing.BillingConcept as BC WITH (NOLOCK) ON BC.Id=CUPS.BillingConceptId
   INNER JOIN Contract.CupsSubgroup AS CSG WITH (NOLOCK) ON CSG.Id =CUPS.CUPSSubGroupId
   INNER JOIN Contract.CupsGroup AS CGC WITH (NOLOCK) ON CGC.Id =CSG.CupsGroupId
),

CTE_IPS
AS
(
 SELECT IPS.ID,IPS.Code [CODIGO SERVICIO IPS],IPS.Name [NOMBRE SERVICIO IPS], CASE IPS.ServiceClass WHEN 1 THEN 'Ninguno' WHEN 2 THEN 'Cirujano' WHEN 3 THEN 'Anestesiologo' WHEN 4 THEN 'Ayudante' 
 WHEN 5 THEN 'Derecho Sala' WHEN 6 THEN 'Materiales Sutura' WHEN 7 THEN 'Instrumentacion Quirurgica' ELSE 'Ninguno' end 'TIPO SERVICIO IPS',
 BC.CODE 'CODIGO CONCEPTO',BC.NAME 'CONCEPTO FACTURACION IPS QX',
 CASE ObtainCostCenter WHEN 1 THEN 'Unidad Funcional del Paciente' WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
 ELSE 'N/A' END 'OBTENER CC'
 FROM Contract.IPSService IPS WITH (NOLOCK)
 LEFT JOIN Billing.BillingConcept as BC WITH (NOLOCK) ON BC.Id=IPS.BillingConceptId
),

CTE_DATOS_IMAGENES
AS
(
SELECT SOD.ServiceOrderId,sod.Id ServiceOrderDetailId,SO.code 'NRO ORDEN',so.status,ISNULL(RC.PatientCode,SO.PatientCode) AS 'IDENTIFICACION',
ISNULL(RC.AdmissionNumber,SO.AdmissionNumber) AS 'INGRESO',CAST(SOD.ServiceDate AS DATE) 'FECHA SERVICIO',
SOD.CUPSEntityId,CUPS.[CUPS],CUPS.[DESCRIPCION CUPS],SOD.IPSServiceId,IPS.[CODIGO SERVICIO IPS],IPS.[NOMBRE SERVICIO IPS],
FU.Code 'CODIGO UFS',FU.Name AS 'UNIDAD FUNCIONAL SERVICIO',CC.Code 'CODIGO CC',CC.NAME 'CENTRO DE COSTO',TP.Nit AS NIT,TP.Name AS ENTIDAD,
isnull(ID.InvoicedQuantity,SOD.InvoicedQuantity) 'CANTIDAD',SOD.RateManualSalePrice,
isnull(CAST(ID.TotalSalesPrice AS NUMERIC(18,2)),cast(SOD.TotalSalesPrice as numeric(18,2))) 'VALOR UNITARIO',
isnull(CAST(ID.GrandTotalSalesPrice AS NUMERIC(18,2)),cast(SOD.GrandTotalSalesPrice as numeric(18,2))) 'VALOR TOTAL',
SOD.PerformsHealthProfessionalCode 'IDENTIFICACION PROFESIONAL',MED.NOMMEDICO 'PROFESIONAL',ESPMED.DESESPECI 'ESPECIALIDAD',
CASE SOD.Packaging WHEN 1 THEN 'SI' ELSE 'NO' END 'EMPAQUETADO',SOD.PackageServiceOrderDetailId,
CASE SettlementType WHEN 3 THEN 'SI' ELSE 'NO' END 'INCLUIDO EN SERVICIO',IncludeServiceOrderDetailId,
IsDelete,ID.ID Id_DetFac,I.InvoiceNumber 'NRO FACTURA'
FROM Billing.ServiceOrder AS SO
  INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
  INNER JOIN Payroll.CostCenter AS CC WITH (NOLOCK) ON CC.Id =SOD.CostCenterId
  INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = SOD.PerformsFunctionalUnitId
  INNER JOIN CTE_CUPS AS CUPS ON CUPS.Id=SOD.CUPSEntityId
  INNER JOIN CTE_IPS AS IPS WITH (NOLOCK) ON IPS.Id =SOD.IPSServiceId
  INNER JOIN Common.ThirdParty AS TP WITH (NOLOCK) ON TP.Id =SOD.ThirdPartyId 
  LEFT JOIN dbo.INPROFSAL AS MED  ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED  ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty
  LEFT JOIN Billing.ServiceOrderDetailDistribution sodd on sodd.ServiceOrderDetailId = sod.Id
  LEFT JOIN Billing.RevenueControlDetail as RCD ON RCD.Id=sodd.RevenueControlDetailId
  LEFT JOIN Billing.RevenueControl RC ON  RC.Id=RCD.RevenueControlId and SO.AdmissionNumber=RC.AdmissionNumber
  LEFT JOIN Billing.Invoice AS I ON I.AdmissionNumber=RC.AdmissionNumber AND I.RevenueControlDetailId=RCD.id
  LEFT JOIN Billing.InvoiceDetail AS ID ON ID.InvoiceId=I.Id and SOD.Id =ID.ServiceOrderDetailId

 WHERE SOD.RecordType=1 AND CUPS.ServiceType =3
),

CTE_DATOS_IMAGENES_EMPAQUETADO
AS
(
 SELECT SOD.ServiceOrderId,sod.Id ServiceOrderDetailId,so.status,SOD.CUPSEntityId,SOD.IPSServiceId,sod.PackageServiceOrderDetailId,
 ID.ID,I.InvoiceNumber 'NRO FACTURA'
 FROM Billing.ServiceOrder AS SO
  INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
  INNER JOIN CTE_CUPS AS CUPS ON CUPS.Id=SOD.CUPSEntityId
  LEFT JOIN Billing.ServiceOrderDetailDistribution sodd on sodd.ServiceOrderDetailId = sod.PackageServiceOrderDetailId
  LEFT JOIN Billing.RevenueControlDetail as RCD ON RCD.Id=sodd.RevenueControlDetailId
  LEFT JOIN Billing.RevenueControl RC ON  RC.Id=RCD.RevenueControlId and SO.AdmissionNumber=RC.AdmissionNumber
  LEFT JOIN Billing.Invoice AS I ON I.AdmissionNumber=RC.AdmissionNumber AND I.RevenueControlDetailId=RCD.id
  LEFT JOIN Billing.InvoiceDetail AS ID ON ID.InvoiceId=I.Id and SOD.PackageServiceOrderDetailId =ID.ServiceOrderDetailId
 WHERE SOD.RecordType=1 AND CUPS.ServiceType =3 AND SOD.Packaging=1
 ),

CTE_DATOS_IMAGENES_INCLUIDO
AS
(
 SELECT SOD.ServiceOrderId,sod.Id ServiceOrderDetailId,so.status,SOD.CUPSEntityId,SOD.IPSServiceId,SOD.SettlementType,SOD.IncludeServiceOrderDetailId ,
 ID.ID 'Id_DetFacInc',I.InvoiceNumber 'NRO FACTURA'
 FROM Billing.ServiceOrder AS SO
  INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
  INNER JOIN CTE_CUPS AS CUPS ON CUPS.Id=SOD.CUPSEntityId
  LEFT JOIN Billing.ServiceOrderDetailDistribution sodd on sodd.ServiceOrderDetailId = sod.IncludeServiceOrderDetailId
  LEFT JOIN Billing.RevenueControlDetail as RCD ON RCD.Id=sodd.RevenueControlDetailId
  LEFT JOIN Billing.RevenueControl RC ON  RC.Id=RCD.RevenueControlId and SO.AdmissionNumber=RC.AdmissionNumber
  LEFT JOIN Billing.Invoice AS I ON I.AdmissionNumber=RC.AdmissionNumber AND I.RevenueControlDetailId=RCD.id
  LEFT JOIN Billing.InvoiceDetail AS ID ON ID.InvoiceId=I.Id and SOD.IncludeServiceOrderDetailId =ID.ServiceOrderDetailId
   WHERE SOD.RecordType=1 AND CUPS.ServiceType =3 AND SettlementType IN (2,3)
)

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
IMG.ServiceOrderId,IMG.ServiceOrderDetailId,IMG.[NRO ORDEN],IMG.IDENTIFICACION,IMG.INGRESO,IMG.[FECHA SERVICIO],IMG.[CUPS],IMG.[DESCRIPCION CUPS],IMG.[CODIGO SERVICIO IPS],
IMG.[NOMBRE SERVICIO IPS], IMG.[CODIGO UFS], IMG.[UNIDAD FUNCIONAL SERVICIO],IMG.[CODIGO CC],IMG.[CENTRO DE COSTO],IMG.[NIT],IMG.[ENTIDAD],IMG.[CANTIDAD],
IMG.[VALOR UNITARIO],IMG.[VALOR TOTAL],IMG.[IDENTIFICACION PROFESIONAL],IMG.[PROFESIONAL],IMG.[ESPECIALIDAD],IMG.[EMPAQUETADO],IMG.[INCLUIDO EN SERVICIO],
IIF(IMG.STATUS=3,'ANULADO',IIF(IMG.[Id_DetFac] IS NOT NULL,'FACTURADO',IIF(PAQ.ID IS NOT NULL,'FACTURADO',IIF(INC.[Id_DetFacInc] IS NOT NULL,'FACTURADO','SIN FACTURAR')))) [ESTADO REGISTRO],
ISNULL(IMG.[NRO FACTURA],ISNULL(PAQ.[NRO FACTURA],INC.[NRO FACTURA])) [NRO FACTURA],
IMG.[Id_DetFac],PAQ.ID [Id_DetFacPaq],INC.[Id_DetFacInc],PAQ.[NRO FACTURA] 'NRO FACTURA PAQ',INC.[NRO FACTURA] 'NRO FACTURA INC',
   CAST(IMG.[FECHA SERVICIO] AS DATE) AS [FECHA BUSQUEDA],
   YEAR(IMG.[FECHA SERVICIO]) AS [AÑO BUSQUEDA],
   MONTH(IMG.[FECHA SERVICIO]) AS [MES BUSQUEDA], 
   CASE MONTH(IMG.[FECHA SERVICIO]) WHEN 1 THEN 'ENE' 
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
   (CASE DATENAME(dw,IMG.[FECHA SERVICIO]) WHEN 'Monday' THEN 'LUN' 
									  WHEN 'Tuesday' THEN 'MAR' 
									  WHEN 'Wednesday' THEN 'MIE' 
									  WHEN 'Thursday' THEN 'JUE' 
									  WHEN 'Friday' THEN 'VIE'
									  WHEN 'Saturday' THEN 'SAB' 
									  WHEN 'Sunday' THEN 'DOM' END) AS [DIA SEMANA], 
   DAY(IMG.[FECHA SERVICIO]) AS DIA, 
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM CTE_DATOS_IMAGENES IMG
LEFT JOIN CTE_DATOS_IMAGENES_EMPAQUETADO PAQ ON IMG.ServiceOrderDetailId=PAQ.ServiceOrderDetailId
LEFT JOIN CTE_DATOS_IMAGENES_INCLUIDO INC ON IMG.ServiceOrderDetailId=INC.ServiceOrderDetailId
--WHERE INGRESO='69759     '--'118200 '--'100893    '--'96722'--'78908     ' --'96722             '


--SET STATISTICS TIME OFF;