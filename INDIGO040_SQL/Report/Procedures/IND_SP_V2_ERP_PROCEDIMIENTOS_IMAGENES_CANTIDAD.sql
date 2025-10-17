-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PROCEDIMIENTOS_IMAGENES_CANTIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PROCEDIMIENTOS_IMAGENES_CANTIDAD] AS

SELECT YEAR(SOD.ServiceDate) 'AÑO',MONTH(SOD.ServiceDate) 'MES',CUPS.CODE 'CUPS',CUPS.Description 'DESCRIPCION CUPS',CAST(SUM(sod.InvoicedQuantity)AS INT) 'CANTIDAD',ima.Protocolo 'PROTOCOLO',
BC.CODE 'CONCEPTO FACTUR',BC.Name 'NOMBRE CONCEPTO FACTUR',BG.NAME 'GRUPO FACTURACION',CG.NAME 'GRUPO CUPS',CSG.NAME 'SUBGRUPO CUPS',
CASE CUPS.ServiceType WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Procedimeintos no Qx' WHEN 5 THEN 'Procedimientos Qx'
WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa' ELSE 'Otros' end 'TIPO SERVICIO',   
CASE CUPS.ShowServiceMedicalOrder WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Procedimeintos no Qx' WHEN 5 THEN 'Procedimientos Qx'
WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa' ELSE 'Otro' end 'DONDE LO ORDENA MEDICO',
CASE CUPS.ShowDashboardOf WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Consulta Externa' WHEN 5 THEN 'Quimioterapias'
WHEN 6 THEN 'Radioterapias' WHEN 7 THEN 'Diálisis' WHEN 8 THEN 'Ninguno' WHEN 9 THEN 'Procedimiento no Qx' WHEN 10 THEN 'Procedimiento Qx' WHEN 11 THEN 'Interconsultas'
WHEN 12 THEN 'Otros Procedimientos' WHEN 13 THEN 'Braquiterapia' ELSE 'Otro' end 'FLUJO DASHBOARD'
FROM Billing.ServiceOrder AS SO
  INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
  INNER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
  INNER JOIN Report.TableCUPSEntityIma as ima on ima.code=cups.code
  INNER JOIN Billing.BillingConcept BC ON BC.ID=CUPS.BillingConceptId
  INNER JOIN Contract.CupsSubgroup AS CSG ON CSG.ID=CUPS.CUPSSubGroupId
  INNER JOIN Contract.CupsGroup AS CG ON CG.ID=CSG.CupsGroupId
  INNER JOIN Billing.BillingGroup AS BG ON BG.ID= CUPS.BillingGroupId
  --LEFT JOIN Contract.CupsHomologation CH ON CH.CupsEntityId =CUPS.Id
  --LEFT JOIN Contract.IPSService AS IPS ON IPS.Id =CH.IPSServiceId
  --LEFT JOIN Contract.SurgicalProcedureService AS SPS ON SPS.IPSServiceParentID=IPS.id
  --LEFT JOIN Contract.IPSService AS IPSS ON IPSS.Id =SPS.IPSServiceID
  --LEFT JOIN Billing.BillingConcept BCP ON BCP.ID=IPSS.BillingConceptId
  WHERE SO.STATUS<>3 AND CAST(SOD.ServiceDate AS DATE)>='2023-10-10' --AND CUPS.CODE='851102'
  GROUP BY YEAR(SOD.ServiceDate),MONTH(SOD.ServiceDate),CUPS.CODE,CUPS.Description,ima.Protocolo,  BC.CODE,BC.Name,BG.NAME,CG.NAME,CSG.NAME,
  CUPS.ServiceType,CUPS.ShowServiceMedicalOrder,CUPS.ShowDashboardOf
  ORDER BY YEAR(SOD.ServiceDate),MONTH(SOD.ServiceDate),CUPS.CODE