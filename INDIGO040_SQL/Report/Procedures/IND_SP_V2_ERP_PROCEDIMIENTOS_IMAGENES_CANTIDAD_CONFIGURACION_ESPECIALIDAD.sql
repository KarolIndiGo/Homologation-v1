-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PROCEDIMIENTOS_IMAGENES_CANTIDAD_CONFIGURACION_ESPECIALIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PROCEDIMIENTOS_IMAGENES_CANTIDAD_CONFIGURACION_ESPECIALIDAD] AS


WITH CTE_CUPS_IPS_DET
AS
(
SELECT DISTINCT CUPS.CODE 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
CASE CUPS.ServiceType WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Procedimeintos no Qx' WHEN 5 THEN 'Procedimientos Qx'
WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa' ELSE 'Otros' end 'TIPO SERVICIO',
ima.Protocolo 'PROTOCOLO',BG.NAME 'GRUPO FACTURACION',CG.NAME 'GRUPO CUPS',CSG.NAME 'SUBGRUPO CUPS',
BC.CODE 'CONCEPTO FACTUR CUPS',BC.Name 'NOMBRE CONCEPTO FACTUR CUPS',CASE BC.ObtainCostCenter WHEN 1 THEN 'Unidad Funcional del Paciente en la Orden'
WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional' END 'OBTENER CC CUPS',CCCUPS.code +'-'+CCCUPS.NAME 'CC ESPECIFICO CUPS',
CASE CUPS.ShowServiceMedicalOrder WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Procedimeintos no Qx' WHEN 5 THEN 'Procedimientos Qx'
WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa' ELSE 'Otro' end 'DONDE LO ORDENA MEDICO',
CASE CUPS.ShowDashboardOf WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Consulta Externa' WHEN 5 THEN 'Quimioterapias'
WHEN 6 THEN 'Radioterapias' WHEN 7 THEN 'Diálisis' WHEN 8 THEN 'Ninguno' WHEN 9 THEN 'Procedimiento no Qx' WHEN 10 THEN 'Procedimiento Qx' WHEN 11 THEN 'Interconsultas'
WHEN 12 THEN 'Otros Procedimientos' WHEN 13 THEN 'Braquiterapia' ELSE 'Otro' end 'FLUJO DASHBOARD',
CASE IPS.ServiceManual WHEN 1 THEN 'ISS 2001' WHEN 2 THEN 'ISS 2004' WHEN 3 THEN 'SOAT' END 'TIPO MANUAL',
ips.code 'CODIGO SERVICIO HOMOLOGO',ips.Name 'DESCRIPCION SERVICIO HOMOLOGO',CASE IPSS.ServiceClass WHEN 1 THEN 'Ninguno' WHEN 2 THEN 'Cirujano'
WHEN 3 THEN 'Anestesiologo' WHEN 4 THEN 'Ayudante' WHEN 5 THEN 'Derecho Sala' WHEN 6 THEN 'Materiales Sutura' WHEN 7 THEN 'Instrumentacion Quirurgica' END 'CLASE DETQX',
ipss.code 'CODIGO SERVICIO DETALLE',ipss.Name 'DESCRIPCION SERVICIO DETALLE',CASE SPS.DefaultService WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' ELSE 'NO' END 'VALOR DEFECTO',
'' 'CODIGO SALA ASOCIADA',
BCP.CODE 'CONCEPTO FACTUR DETQX',BCP.Name 'NOMBRE CONCEPTO FACTUR DETQX',CASE BCP.ObtainCostCenter WHEN 1 THEN 'Unidad Funcional del Paciente en la Orden'
WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional' END 'OBTENER CC DETQX',CCDETQX.code +'-'+CCDETQX.NAME 'CC ESPECIFICO DETQX',
ESPQX.DESESPECI 'ESPECIALIDAD'
FROM Billing.ServiceOrder AS SO
  INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
  INNER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
  INNER JOIN Report.TableCUPSEntityIma as ima on ima.code=cups.code
  INNER JOIN Billing.BillingConcept BC ON BC.ID=CUPS.BillingConceptId
  INNER JOIN Contract.CupsSubgroup AS CSG ON CSG.ID=CUPS.CUPSSubGroupId
  INNER JOIN Contract.CupsGroup AS CG ON CG.ID=CSG.CupsGroupId
  INNER JOIN Billing.BillingGroup AS BG ON BG.ID= CUPS.BillingGroupId
  LEFT JOIN Contract.CupsHomologation CH ON CH.CupsEntityId =CUPS.Id
  LEFT JOIN Contract.IPSService AS IPS ON IPS.Id =CH.IPSServiceId
  LEFT JOIN Contract.SurgicalProcedureService AS SPS ON SPS.IPSServiceParentID=IPS.id
  LEFT JOIN Contract.IPSService AS IPSS ON IPSS.Id =SPS.IPSServiceID
  LEFT JOIN Billing.BillingConcept BCP ON BCP.ID=IPSS.BillingConceptId
  LEFT JOIN Payroll.CostCenter AS CCCUPS ON CCCUPS.ID=BC.CostCenterId
  LEFT JOIN Payroll.CostCenter AS CCDETQX ON CCDETQX.ID=BCP.CostCenterId
  LEFT JOIN Billing.ServiceOrderDetailSurgical SODS on SODS.ServiceOrderDetailId=SOD.ID AND IPSS.ID=SODS.IPSServiceId
  LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  WHERE SO.STATUS<>3 AND CAST(SOD.ServiceDate AS DATE)>='2023-10-10'
UNION ALL
SELECT DISTINCT CUPS.CODE 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
CASE CUPS.ServiceType WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Procedimeintos no Qx' WHEN 5 THEN 'Procedimientos Qx'
WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa' ELSE 'Otros' end 'TIPO SERVICIO',
ima.Protocolo 'PROTOCOLO',BG.NAME 'GRUPO FACTURACION',CG.NAME 'GRUPO CUPS',CSG.NAME 'SUBGRUPO CUPS',
BC.CODE 'CONCEPTO FACTUR CUPS',BC.Name 'NOMBRE CONCEPTO FACTUR CUPS',CASE BC.ObtainCostCenter WHEN 1 THEN 'Unidad Funcional del Paciente en la Orden'
WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional' END 'OBTENER CC CUPS',CCCUPS.code +'-'+CCCUPS.NAME 'CC ESPECIFICO CUPS',
CASE CUPS.ShowServiceMedicalOrder WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Procedimeintos no Qx' WHEN 5 THEN 'Procedimientos Qx'
WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa' ELSE 'Otro' end 'DONDE LO ORDENA MEDICO',
CASE CUPS.ShowDashboardOf WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Consulta Externa' WHEN 5 THEN 'Quimioterapias'
WHEN 6 THEN 'Radioterapias' WHEN 7 THEN 'Diálisis' WHEN 8 THEN 'Ninguno' WHEN 9 THEN 'Procedimiento no Qx' WHEN 10 THEN 'Procedimiento Qx' WHEN 11 THEN 'Interconsultas'
WHEN 12 THEN 'Otros Procedimientos' WHEN 13 THEN 'Braquiterapia' ELSE 'Otro' end 'FLUJO DASHBOARD',
CASE IPS.ServiceManual WHEN 1 THEN 'ISS 2001' WHEN 2 THEN 'ISS 2004' WHEN 3 THEN 'SOAT' END 'TIPO MANUAL',
ips.code 'CODIGO SERVICIO HOMOLOGO',ips.Name 'DESCRIPCION SERVICIO HOMOLOGO',CASE IPSSM.ServiceClass WHEN 1 THEN 'Ninguno' WHEN 2 THEN 'Cirujano'
WHEN 3 THEN 'Anestesiologo' WHEN 4 THEN 'Ayudante' WHEN 5 THEN 'Derecho Sala' WHEN 6 THEN 'Materiales Sutura' WHEN 7 THEN 'Instrumentacion Quirurgica' END 'CLASE DETQX',
IPSSM.code 'CODIGO SERVICIO DETALLE',IPSSM.Name 'DESCRIPCION SERVICIO DETALLE',CASE SPS.DefaultService WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' ELSE 'NO' END 'VALOR DEFECTO',
IPSS.code 'CODIGO SALA ASOCIADA',
BCPM.CODE 'CONCEPTO FACTUR DETQX',BCPM.Name 'NOMBRE CONCEPTO FACTUR DETQX',CASE BCPM.ObtainCostCenter WHEN 1 THEN 'Unidad Funcional del Paciente en la Orden'
WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional' END 'OBTENER CC DETQX',CCDETQXM.code +'-'+CCDETQXM.NAME 'CC ESPECIFICO DETQX',
ESPQX.DESESPECI 'ESPECIALIDAD'
FROM Billing.ServiceOrder AS SO
  INNER JOIN Billing.ServiceOrderDetail SOD ON SO.ID=SOD.ServiceOrderId
  INNER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
  INNER JOIN Report.TableCUPSEntityIma as ima on ima.code=cups.code
  INNER JOIN Billing.BillingConcept BC ON BC.ID=CUPS.BillingConceptId
  INNER JOIN Contract.CupsSubgroup AS CSG ON CSG.ID=CUPS.CUPSSubGroupId
  INNER JOIN Contract.CupsGroup AS CG ON CG.ID=CSG.CupsGroupId
  INNER JOIN Billing.BillingGroup AS BG ON BG.ID= CUPS.BillingGroupId
  LEFT JOIN Contract.CupsHomologation CH ON CH.CupsEntityId =CUPS.Id
  LEFT JOIN Contract.IPSService AS IPS ON IPS.Id =CH.IPSServiceId
  LEFT JOIN Contract.SurgicalProcedureService AS SPS ON SPS.IPSServiceParentID=IPS.id
  LEFT JOIN Contract.IPSService AS IPSS ON IPSS.Id =SPS.IPSServiceID
  LEFT JOIN Billing.BillingConcept BCP ON BCP.ID=IPSS.BillingConceptId
  LEFT JOIN Payroll.CostCenter AS CCCUPS ON CCCUPS.ID=BC.CostCenterId
  LEFT JOIN Payroll.CostCenter AS CCDETQX ON CCDETQX.ID=BCP.CostCenterId
  LEFT JOIN Contract.IPSService AS IPSSM ON IPSSM.Id =IPSS.AssociatedMaterialIPSServiceId
  LEFT JOIN Billing.BillingConcept BCPM ON BCPM.ID=IPSSM.BillingConceptId
  LEFT JOIN Payroll.CostCenter AS CCDETQXM ON CCDETQXM.ID=BCPM.CostCenterId
  LEFT JOIN Billing.ServiceOrderDetailSurgical SODS on SODS.ServiceOrderDetailId=SOD.ID AND IPSS.ID=SODS.IPSServiceId
  LEFT JOIN dbo.INPROFSAL AS MEDQX  ON MEDQX.CODPROSAL = SODS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX  ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  WHERE SO.STATUS<>3 AND IPSS.AssociatedMaterialIPSServiceId IS NOT NULL

)

SELECT * FROM CTE_CUPS_IPS_DET
--WHERE CUPS='261001'
 ORDER BY [CUPS], [CODIGO SERVICIO HOMOLOGO],[CLASE DETQX]