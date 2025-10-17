-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_TARIFAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



    /*******************************************************************************************************************
Nombre:[Report].[IND_SP_V2_ERP_TARIFAS] 
Tipo: PROCEDIMIENTO ALMACENADO
Observacion:
Profesional:Andres Cabrera
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 26-06-2023
Ovservaciones: Se agrega la condicion a los CTE principales de la consulta que solo busque la tarifa indicada en la variable.
------------------------------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 13-07-2023
Observacion:Se ajusta el CTE_REGLA_GRUPOS_CUPS quitando la tabla Contract.IPSService AS IPSPADRE que no realizaba ninguna tarea, se elimina el distinct y se ajusta conecciones entre tablas
			para mejorar el performance de la consulta, esto solicitado por HOMI.
--------------------------------------------------------------------------------------------

--***********************************************************************************************************************************/

CREATE PROCEDURE [Report].[IND_SP_V2_ERP_TARIFAS] 
@TARIFA AS CHAR(20)

AS 

--declare @TARIFA CHAR(20)='99999H';

--select * from Contract.DefinitionRate

----IDENTIFICAMOS LOS MANUALES UNICOS
WITH CTE_MANUALES_UNICOS
AS
(
SELECT DISTINCT
ISNULL(G.RateManualId ,DRD.RateManualId) 
RateManualId,
RM.Code 'CODIGO MANUAL', 
RM.NAME 'MANUAL TARIFAS',
RM.Type 
 FROM 
 Contract.DefinitionRateDetail AS DRD
 INNER JOIN Contract.DefinitionRate DR ON DR.Id =DRD.DefinitionRateId /*IN V2*/AND DR.CODE=@TARIFA --FN V2
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId LEFT JOIN 
 (
    SELECT DISTINCT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract.RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
 ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
WHERE DR.Status =1 AND ISNULL(G.RateManualId ,DRD.RateManualId) IS NOT NULL
),
-----******SOLO MANUALES CON QUIRURGICOS*****-----
CTE_MANUALES_QX
AS
(
   SELECT RM.ID IDMANUAL,RM.Type,CASE RM.Type WHEN 1 THEN 'ISS 2001' WHEN 2 THEN 'ISS 2004' WHEN 3 THEN 'SOAT' END 'TIPO',RM.Code 'CODIGO MANUAL',RM.Name 'MANUAL','SERVICIOS QX' 'AGRUPADOR',
   CASE IPS.Presentation WHEN 1 THEN 'No quirurgico' WHEN 2 THEN 'Quirurgico' WHEN 3 THEN 'Paquete' END 'PRESENTACION',CASE ips.ServiceClass WHEN 1 THEN 'Ninguno' WHEN 2 THEN 'Cirujano' WHEN 3 THEN 'Anestesiologo' WHEN 4 THEN 'Ayudante' WHEN 5 THEN 'Derecho Sala' WHEN 6 THEN 'Materiales Sutura'
   WHEN 7 THEN 'Instrumentacion Quirurgica' ELSE 'Ninguno' END 'CLASE',RMDS.IPSServiceId IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',RMDS.SalesValue 'VALOR',
   UVR.Name 'RANGO UVR',UVR.InitialUVR 'INICIAL UVR' ,UVR.EndUVR 'FINAL UVR',SG.Id IDGRUPO,SG.Name 'GRUPO QUIRURGICO SOAT',SG.SurgeonService 'CIRUJANO SOAT',SG.AnesthesiologistService 'ANESTESIOLOGO SOAT',
   SG.AssistantService 'AYUDANTE SOAT',SG.RoomService 'SALA SOAT' ,SG.MaterialsService 'MATERIALES SOAT',ips.ServiceManual,MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL'
   FROM CTE_MANUALES_UNICOS UNI 
     INNER JOIN Contract .RateManual AS RM ON RM.Id =UNI.RateManualId 
     INNER JOIN Contract .RateManualDetailSurgical RMDS ON RM.Id =RMDS.RateManualId 
     INNER JOIN Contract .IPSService IPS ON IPS.Id =RMDS.IPSServiceId
	 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPS.AssociatedMaterialIPSServiceId 
     LEFT JOIN Contract .UVRRange AS UVR ON UVR.Id =RMDS.UVRRangeId 
     LEFT JOIN Contract .SurgicalGroup SG ON SG.Id =RMDS.SurgicalGroupId
),

-----******SACAMOS EL DETALLADO CONSOLIDADOS DE SERVICIOS DEL MANUAL********-----
CTE_MANUALES_DETALLADOS
AS
(
 -----***SERVICIOS NO QX-----
  SELECT RM.ID IDMANUAL,RM.Type,CASE RM.Type WHEN 1 THEN 'ISS 2001' WHEN 2 THEN 'ISS 2004' WHEN 3 THEN 'SOAT' END 'TIPO',RM.Code 'CODIGO MANUAL',RM.Name 'MANUAL','SERVICIOS' 'AGRUPADOR',
   CASE IPS.Presentation WHEN 1 THEN 'No quirurgico' WHEN 2 THEN 'Quirurgico' WHEN 3 THEN 'Paquete' END 'PRESENTACION',CASE ips.ServiceClass WHEN 1 THEN 'Ninguno' WHEN 2 THEN 'Cirujano' WHEN 3 THEN 'Anestesiologo' WHEN 4 THEN 'Ayudante' WHEN 5 THEN 'Derecho Sala' WHEN 6 THEN 'Materiales Sutura'
   WHEN 7 THEN 'Instrumentacion Quirurgica'ELSE 'Ninguno' END 'CLASE',RMD.IPSServiceId IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',RMD.SalesValue 'VALOR',
   NULL 'RANGO UVR',NULL 'INICIAL UVR' ,NULL 'FINAL UVR',NULL IDGRUPO,NULL 'GRUPO QUIRURGICO SOAT',NULL 'CIRUJANO SOAT',NULL 'ANESTESIOLOGO SOAT',NULL 'AYUDANTE SOAT',NULL 'SALA SOAT',NULL 'MATERIALES SOAT',
   ips.ServiceManual,MAT.AssociatedMaterialIPSServiceId ,MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL'
     FROM CTE_MANUALES_UNICOS UNI 
     INNER JOIN Contract .RateManual AS RM ON RM.Id =UNI.RateManualId 
     INNER JOIN Contract .RateManualDetail RMD ON RM.Id =RMD.RateManualId 
     INNER JOIN Contract .IPSService IPS ON IPS.Id =RMD.IPSServiceId
	 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPS.AssociatedMaterialIPSServiceId 
    --WHERE [CODIGO MANUAL] ='001' AND IPS.Code ='377800'
UNION ALL
  -----SERVICIOS QX
  SELECT RM.ID IDMANUAL,RM.Type,CASE RM.Type WHEN 1 THEN 'ISS 2001' WHEN 2 THEN 'ISS 2004' WHEN 3 THEN 'SOAT' END 'TIPO',RM.Code 'CODIGO MANUAL',RM.Name 'MANUAL','SERVICIOS QX' 'AGRUPADOR',
   CASE IPS.Presentation WHEN 1 THEN 'No quirurgico' WHEN 2 THEN 'Quirurgico' WHEN 3 THEN 'Paquete' END 'PRESENTACION',CASE ips.ServiceClass WHEN 1 THEN 'Ninguno' WHEN 2 THEN 'Cirujano' WHEN 3 THEN 'Anestesiologo' WHEN 4 THEN 'Ayudante' WHEN 5 THEN 'Derecho Sala' WHEN 6 THEN 'Materiales Sutura'
   WHEN 7 THEN 'Instrumentacion Quirurgica' ELSE 'Ninguno' END 'CLASE',RMDS.IPSServiceId IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',RMDS.SalesValue 'VALOR',
   UVR.Name 'RANGO UVR',UVR.InitialUVR 'INICIAL UVR' ,UVR.EndUVR 'FINAL UVR',SG.Id IDGRUPO,SG.Name 'GRUPO QUIRURGICO SOAT',SG.SurgeonService 'CIRUJANO SOAT',SG.AnesthesiologistService 'ANESTESIOLOGO SOAT',
   SG.AssistantService 'AYUDANTE SOAT',SG.RoomService 'SALA SOAT' ,SG.MaterialsService 'MATERIALES SOAT',ips.ServiceManual,MAT.AssociatedMaterialIPSServiceId ,MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL'
   FROM CTE_MANUALES_UNICOS UNI 
     INNER JOIN Contract .RateManual AS RM ON RM.Id =UNI.RateManualId 
     INNER JOIN Contract .RateManualDetailSurgical RMDS ON RM.Id =RMDS.RateManualId 
     INNER JOIN Contract .IPSService IPS ON IPS.Id =RMDS.IPSServiceId
     LEFT JOIN Contract .UVRRange AS UVR ON UVR.Id =RMDS.UVRRangeId 
     LEFT JOIN Contract .SurgicalGroup SG ON SG.Id =RMDS.SurgicalGroupId
	 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPS.AssociatedMaterialIPSServiceId 
    -- WHERE [CODIGO MANUAL] ='007'
),
--SELECT * FROM CTE_MANUALES_DETALLADOS WHERE [CODIGO SERVICIO] LIKE '870453%'

-----******SACAMOS LA REGLA POR SERVICIO IP********-----
CTE_REGLA_SERVICIOS_IPS
AS
(
----*****CONDICION NINGUN Y TIPO DE LIQUIDACION FIJA
 SELECT 
 DR.Id IDTARIFA,
 DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 NULL DESCRIPCION,NULL ESPECIALIDAD,NULL [UNIDAD FUNCIONAL],NULL [HORA INCIAL] ,NULL [HORA FINAL],CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',
 DRD.LiquidationType,NULL 'VIGENCIA MANUAL',ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(RateVariation,0) '% VARIACION',
 IPS.Id IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',IPSHIJO.Code + ' - ' + IPSHIJO.Name  'SERVICIO HIJO',IPS.ServiceManual,RM.Type,ISNULL(DRD.SalesValue,0) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
 MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL',0 'VALOR MATERIAL'
 FROM 
 Contract .DefinitionRateDetail DRD
  INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId /*IN V2*/AND DR.CODE=@TARIFA --FN V2
  INNER JOIN Contract .IPSService AS IPS ON IPS.Id =DRD.IPSServiceId 
  INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.Id =DRD.CUPSEntityId 
  LEFT JOIN Contract .DefinitionRateDetailSurgicalProcedures DRDSP ON DRDSP.DefinitionRateDetailId =DRD.Id 
  LEFT JOIN Contract .IPSService AS IPSQ ON IPSQ.Id =DRDSP.IPSServiceId
  LEFT JOIN Contract .SurgicalProcedureService SPS ON SPS.Id =DRDSP.SurgicalProcedureServiceId 
  LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
  LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId 
  LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPSHIJO.AssociatedMaterialIPSServiceId 
  WHERE DRD.RuleType =1 AND DR.Status =1 AND DRD.ConditionType=5 AND DRD.LiquidationType =1 --AND DR.Code ='003HC0' AND IPS.Code ='467202H'
UNION ALL
  ----*****CONDICION NINGUN Y TIPO DE LIQUIDACION ESTANDAR Y VARIABLE
  SELECT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
  WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
  WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
  NULL DESCRIPCION,NULL ESPECIALIDAD,NULL [UNIDAD FUNCIONAL],NULL [HORA INCIAL] ,NULL [HORA FINAL],CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',
  DRD.LiquidationType,RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL',ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(RateVariation,0) '% VARIACION',
  IPS.Id IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',IPSHIJO.Code + ' - ' + IPSHIJO.Name  'SERVICIO HIJO',IPS.ServiceManual,RM.Type,ISNULL(QX.VALOR,0) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
  MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL',QXM.VALOR 'VALOR MATERIAL'
  FROM  Contract .DefinitionRateDetail DRD
  INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId 
  INNER JOIN Contract .IPSService AS IPS ON IPS.Id =DRD.IPSServiceId 
  INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.Id =DRD.CUPSEntityId
  LEFT JOIN Contract .DefinitionRateDetailSurgicalProcedures DRDSP ON DRDSP.DefinitionRateDetailId =DRD.Id 
  LEFT JOIN Contract .IPSService AS IPSQ ON IPSQ.Id =DRDSP.IPSServiceId
  LEFT JOIN Contract .SurgicalProcedureService SPS ON SPS.Id =DRDSP.SurgicalProcedureServiceId 
  LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
  LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId 
  LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
  LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 LEFT JOIN CTE_MANUALES_QX AS QX ON ISNULL(G.RateManualId ,DRD.RateManualId) =QX.IDMANUAL AND IPSHIJO.Id =QX.IDSERVICIO AND RM.Type =IPSHIJO.ServiceManual
 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPSHIJO.AssociatedMaterialIPSServiceId 
 LEFT JOIN CTE_MANUALES_QX AS QXM ON ISNULL(G.RateManualId ,DRD.RateManualId) =QXM.IDMANUAL AND MAT.Id  =QXM.IDSERVICIO AND RM.Type =MAT.ServiceManual and QXM.IDGRUPO =IPS.SurgicalGroupId 

  WHERE DRD.RuleType =1 AND DR.Status =1 AND DRD.ConditionType=5 AND DRD.LiquidationType IN (2,3) 
UNION ALL
----*****CONDICION DIFERENTE A NINGUN Y TIPO LIQUIDACION FIJA
  SELECT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA',CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
  WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
  WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
  G.DESCRIPCION,G.ESPECIALIDAD,G.[UNIDAD FUNCIONAL],G.[HORA INCIAL] ,G.[HORA FINAL],G.[TIPO LIQUIDACION] ,
  G.LiquidationType,NULL 'VIGENCIA MANUAL',NULL RateManualId,NULL 'MANUAL TARIFAS',ISNULL(G.RateVariation,0) '% VARIACION',
  IPS.Id IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',NULL 'SERVICIO HIJO',IPS.ServiceManual,NULL Type,ISNULL(G.SalesValue,0) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
  NULL 'COD MATERIAL',NULL 'MATERIAL',0 'VALOR MATERIAL'
  FROM  Contract .DefinitionRateDetail DRD
  INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId 
  INNER JOIN Contract .IPSService AS IPS ON IPS.Id =DRD.IPSServiceId 
  INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.Id =DRD.CUPSEntityId
  INNER JOIN
 (
   SELECT DRDC.ID,DRDC.DefinitionRateDetailId,DRDC.StartTime 'HORA INCIAL',DRDC.EndTime 'HORA FINAL',CD.Code + ' - ' + CD.Name 'DESCRIPCION',ESP.DESESPECI 'ESPECIALIDAD',FU.Name 'UNIDAD FUNCIONAL',FUT.UnitType 'TIPO UNIDAD',
   CASE DRDC.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',DRDC.LiquidationType,DRDC.RateVariation,DRDC.SalesValue
   FROM Contract .DefinitionRateDetailCondition DRDC 
   LEFT JOIN Contract .ContractDescriptions CD ON CD.Id =DRDC.ContractDescriptionId 
   LEFT JOIN DBO.INESPECIA AS ESP ON ESP.CODESPECI =DRDC.SpecialtyId 
   LEFT JOIN Payroll .FunctionalUnit FU ON FU.Id =DRDC.FunctionalUnitId 
   LEFT JOIN Payroll .FunctionalUnit FUT ON FUT.UnitType  =DRDC.UnitTypeId
) AS G ON G.DefinitionRateDetailId  =DRD.Id 
  WHERE DRD.RuleType =1 AND DR.Status =1 AND DRD.ConditionType<>5 AND G.LiquidationType =1
UNION ALL
------*****CONDICION DIFERENTE A NINGUN Y TIPO LIQUIDACION ESTANDAR Y VARIABLE

  SELECT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
  WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
  WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
  CD.Code + ' - ' + CD.Name 'DESCRIPCION',ESP.DESESPECI 'ESPECIALIDAD',FU.Name 'UNIDAD FUNCIONAL',DRDC.StartTime 'HORA INCIAL',DRDC.EndTime 'HORA FINAL',CASE DRDC.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',
  DRDC.LiquidationType,RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL',ISNULL(G.RateManualId ,DRDC.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(DRDC.RateVariation,0) '% VARIACION',
  CH.IPSServiceId IDSERVICIO ,IPS.Code 'CODIGO SERVICIO',IPS.NAME 'SERVICIO',NULL 'SERVICIO HIJO',IPS.ServiceManual,RM.Type,ISNULL(DET.VALOR,0) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
  MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL',DET.VALOR 'VALOR MATERIAL'  
  FROM Contract .DefinitionRateDetailCondition DRDC
   INNER JOIN Contract .DefinitionRateDetail AS DRD ON DRD.Id =DRDC.DefinitionRateDetailId 
   INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId
   INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.ID=DRD.CUPSEntityId  AND CUPS.Status =1
   LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id
   LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId
   LEFT JOIN Contract .ContractDescriptions CD ON CD.Id =DRDC.ContractDescriptionId 
   LEFT JOIN DBO.INESPECIA AS ESP ON ESP.CODESPECI =DRDC.SpecialtyId 
   LEFT JOIN Payroll .FunctionalUnit FU ON FU.Id =DRDC.FunctionalUnitId 
   LEFT JOIN Payroll .FunctionalUnit FUT ON FUT.UnitType  =DRDC.UnitTypeId
   LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRDC.RateManualValidityId
   LEFT JOIN
    (
	SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
    ) AS G ON G.RateManualValidityId =DRDC.RateManualValidityId
	LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRDC.RateManualId)
	LEFT JOIN CTE_MANUALES_DETALLADOS DET ON ISNULL(G.RateManualId ,DRDC.RateManualId) =DET.IDMANUAL AND IPS.Id =DET.IDSERVICIO
	LEFT JOIN Contract .IPSService MAT ON MAT.Id =DET.AssociatedMaterialIPSServiceId 
   WHERE DRDC.LiquidationType IN (2,3) AND DRD.RuleType =1 AND DR.Status =1 AND DRD.ConditionType<>5 AND  RM.Type =IPS.ServiceManual
),
 ------------------------------------------**************************************************************************
 ---IDENTIFICACION DE CODIGO UNICOS EN REGLA IPS QUE NO SE DEBEN MOSTRAR EN REGLA GENERAL----

 CTE_CODIGOS_UNICOS_REGLA_IPS_CUPS_GRUPO_SUBGRUPO
 AS
 (
  ----SERVICIOS IPS PARA NO LLAMARLOS EN REGLA GENERAL
  SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
  WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
  ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS', IPS.Id IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO'
  FROM 
  Contract .DefinitionRateDetail DRD
  INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId 
  INNER JOIN Contract .IPSService AS IPS ON IPS.Id =DRD.IPSServiceId 
  INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.Id =DRD.CUPSEntityId 
  LEFT JOIN Contract .DefinitionRateDetailSurgicalProcedures DRDSP ON DRDSP.DefinitionRateDetailId =DRD.Id 
  LEFT JOIN Contract .IPSService AS IPSQ ON IPSQ.Id =DRDSP.IPSServiceId
  LEFT JOIN Contract .SurgicalProcedureService SPS ON SPS.Id =DRDSP.SurgicalProcedureServiceId 
  LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
  LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId 
  LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
  WHERE DRD.RuleType =1 AND DR.Status =1 AND RM.Type =IPS.ServiceManual --AND DR.Code ='026SO2'-- AND CUPS.Code ='053116'
  ---SERVICIOS CUPS PARA NO LLAMARLOS EN REGLA GENERAL
 UNION ALL
 SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS', IPS.Id IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.ID=DRD.CUPSEntityId  AND CUPS.Status =1
 LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id
 LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 WHERE DRD.RuleType =2 AND DR.Status =1 AND RM.Type =IPS.ServiceManual 
 ----SUB GRUPOS CUPS PARA NO LLAMARLOS EN REGLA GENERAL
 UNION ALL
  SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS', IPS.Id IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId
 INNER JOIN Contract .CupsSubgroup CSG ON CSG.CupsGroupId =DRD.CUPSSubgroupId 
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.CUPSSubGroupId =CSG.Id AND CUPS.Status =1
 LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id 
 LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId 
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 WHERE DRD.RuleType =3 AND DR.Status =1 AND  RM.Type =IPS.ServiceManual
  ----GRUPOS CUPS PARA NO LLAMARLOS EN REGLA GENERAL
 UNION ALL
  SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS', IPS.Id IDSERVICIO,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId
 INNER JOIN Contract .CupsGroup CG ON CG.Id =DRD.CUPSGroupId 
 INNER JOIN Contract .CupsSubgroup CSG ON CSG.CupsGroupId =CG.Id 
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.CUPSSubGroupId =CSG.Id AND CUPS.Status =1
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id 
 LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId
 LEFT JOIN Contract .SurgicalProcedureService AS SPS ON SPS.IPSServiceParentId =IPS.Id 
 LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
 LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 WHERE DRD.RuleType =4 AND DR.Status =1 AND RM.Type=IPS.ServiceManual  
),

  -----******SACAMOS LA REGLA POR CUPS********-----
CTE_REGLA_CUPS
AS
(
-----***CONDICION NINGUNA Y TIPO DE LIQUIDACION FIJA****-----
 SELECT DISTINCT DR.Id IDTARIFA,
 DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 NULL DESCRIPCION,NULL ESPECIALIDAD,NULL [UNIDAD FUNCIONAL],NULL [HORA INCIAL] ,NULL [HORA FINAL],CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',
 DRD.LiquidationType,NULL 'VIGENCIA MANUAL',ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(RateVariation,0) '% VARIACION',
 NULL IDSERVICIO ,NULL 'CODIGO SERVICIO',NULL'SERVICIO',NULL 'SERVICIO HIJO',NULL ServiceManual,RM.Type,ISNULL(DRD.SalesValue,0) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
 NULL 'COD MATERIAL',NULL 'MATERIAL',0 'VALOR MATERIAL'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId /*IN V2*/AND DR.CODE=@TARIFA --FN V2
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.ID=DRD.CUPSEntityId  AND CUPS.Status =1
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 WHERE DRD.RuleType =2 AND DR.Status =1 AND DRD.ConditionType=5 AND DRD.LiquidationType =1 --AND DR.Code ='026SO3'
 UNION ALL
-----***CONDICION NINGUNA Y TIPO DE LIQUIDACION ESTANDAR Y VIGENCIA****-----

 SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 NULL DESCRIPCION,NULL ESPECIALIDAD,NULL [UNIDAD FUNCIONAL],NULL [HORA INCIAL] ,NULL [HORA FINAL],CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',
 DRD.LiquidationType,RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL',ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(RateVariation,0) '% VARIACION',
 CH.IPSServiceId IDSERVICIO ,IPS.Code 'CODIGO SERVICIO',IPS.NAME 'SERVICIO',IPSHIJO.Code + ' - ' + IPSHIJO.Name 'SERVICIO HIJO',IPS.ServiceManual,RM.Type,ISNULL(DET.VALOR,ISNULL(QX.VALOR,0)) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
 MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL',QXM.VALOR 'VALOR MATERIAL'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.ID=DRD.CUPSEntityId AND CUPS.Status =1
 LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id
 LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId
 LEFT JOIN Contract .SurgicalProcedureService AS SPS ON SPS.IPSServiceParentId =IPS.Id 
 LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
 LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId 
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 LEFT JOIN CTE_MANUALES_DETALLADOS DET ON ISNULL(G.RateManualId ,DRD.RateManualId) =DET.IDMANUAL AND IPS.Id =DET.IDSERVICIO AND RM.Type =IPS.ServiceManual
 LEFT JOIN CTE_MANUALES_QX AS QX ON ISNULL(G.RateManualId ,DRD.RateManualId) =QX.IDMANUAL AND IPSHIJO.Id =QX.IDSERVICIO AND RM.Type =IPSHIJO.ServiceManual
 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPSHIJO.AssociatedMaterialIPSServiceId 
 LEFT JOIN CTE_MANUALES_QX AS QXM ON ISNULL(G.RateManualId ,DRD.RateManualId) =QXM.IDMANUAL AND MAT.Id  =QXM.IDSERVICIO AND RM.Type =MAT.ServiceManual and QXM.IDGRUPO =IPS.SurgicalGroupId 
 WHERE DRD.RuleType =2 AND DR.Status =1 AND DRD.ConditionType=5 AND DRD.LiquidationType IN (2,3) AND  RM.Type =IPS.ServiceManual--AND DR.Code ='026SO3'
  UNION ALL
-------CONDICION DIFERENTE A NINGUNA Y TIPO DE LIQUIDACION FIJA****-----

 SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA',CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 G.DESCRIPCION,G.ESPECIALIDAD,G.[UNIDAD FUNCIONAL],G.[HORA INCIAL] ,G.[HORA FINAL], G.[TIPO LIQUIDACION],G.LiquidationType,
 NULL 'VIGENCIA MANUAL',NULL RateManualId,NULL 'MANUAL TARIFAS',ISNULL(G.RateVariation,0) '% VARIACION',
 NULL IDSERVICIO ,NULL 'CODIGO SERVICIO',NULL'SERVICIO',NULL 'SERVICIO HIJO',NULL ServiceManual,NULL Type,ISNULL(G.SalesValue,0) 'VALOR',ISNULL(G.SalesValue,0) 'VALOR GENERAL',
 NULL 'COD MATERIAL',NULL 'MATERIAL',0 'VALOR MATERIAL'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.ID=DRD.CUPSEntityId  AND CUPS.Status =1
 INNER JOIN
 (
   SELECT DRDC.ID,DRDC.DefinitionRateDetailId,DRDC.StartTime 'HORA INCIAL',DRDC.EndTime 'HORA FINAL',CD.Code + ' - ' + CD.Name 'DESCRIPCION',ESP.DESESPECI 'ESPECIALIDAD',FU.Name 'UNIDAD FUNCIONAL',FUT.UnitType 'TIPO UNIDAD',
   CASE DRDC.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',DRDC.LiquidationType,DRDC.RateVariation,DRDC.SalesValue
   FROM Contract .DefinitionRateDetailCondition DRDC 
   LEFT JOIN Contract .ContractDescriptions CD ON CD.Id =DRDC.ContractDescriptionId 
   LEFT JOIN DBO.INESPECIA AS ESP ON ESP.CODESPECI =DRDC.SpecialtyId 
   LEFT JOIN Payroll .FunctionalUnit FU ON FU.Id =DRDC.FunctionalUnitId 
   LEFT JOIN Payroll .FunctionalUnit FUT ON FUT.UnitType  =DRDC.UnitTypeId
   --WHERE DRDC.LiquidationType =1
) AS G ON G.DefinitionRateDetailId  =DRD.Id 
 WHERE DRD.RuleType =2 AND DR.Status =1 AND DRD.ConditionType<>5 AND G.LiquidationType =1 
  UNION ALL

-----CONDICION DIFERENTE A NINGUNA Y TIPO DE LIQUIDACION ESTANDAR Y VARIABLEA****-----
  SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA',CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
   WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
   WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
   CD.Code + ' - ' + CD.Name 'DESCRIPCION',ESP.DESESPECI 'ESPECIALIDAD',FU.Name 'UNIDAD FUNCIONAL',DRDC.StartTime 'HORA INCIAL',DRDC.EndTime 'HORA FINAL',
   CASE DRDC.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',DRDC.LiquidationType,
   RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL',ISNULL(G.RateManualId ,DRDC.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(DRDC.RateVariation,0) '% VARIACION',
   CH.IPSServiceId IDSERVICIO ,IPS.Code 'CODIGO SERVICIO',IPS.NAME 'SERVICIO',IPSHIJO.Code + ' - ' + IPSHIJO.Name 'SERVICIO HIJO',IPS.ServiceManual,RM.Type,ISNULL(DET.VALOR,ISNULL(QX.VALOR,0)) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
   MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL',QXM.VALOR 'VALOR MATERIAL'
   FROM Contract .DefinitionRateDetailCondition DRDC
   INNER JOIN Contract .DefinitionRateDetail AS DRD ON DRD.Id =DRDC.DefinitionRateDetailId 
   INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId
   INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.ID=DRD.CUPSEntityId  AND CUPS.Status =1
   LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id
   LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId
   LEFT JOIN Contract .SurgicalProcedureService AS SPS ON SPS.IPSServiceParentId =IPS.Id 
   LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
   LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId
   LEFT JOIN Contract .ContractDescriptions CD ON CD.Id =DRDC.ContractDescriptionId 
   LEFT JOIN DBO.INESPECIA AS ESP ON ESP.CODESPECI =DRDC.SpecialtyId 
   LEFT JOIN Payroll .FunctionalUnit FU ON FU.Id =DRDC.FunctionalUnitId 
   LEFT JOIN Payroll .FunctionalUnit FUT ON FUT.UnitType  =DRDC.UnitTypeId
   LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRDC.RateManualValidityId
   LEFT JOIN
    (
	SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
    ) AS G ON G.RateManualValidityId =DRDC.RateManualValidityId
	LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRDC.RateManualId)
	LEFT JOIN CTE_MANUALES_DETALLADOS DET ON ISNULL(G.RateManualId ,DRDC.RateManualId) =DET.IDMANUAL AND IPS.Id =DET.IDSERVICIO --AND RM.Type =IPS.ServiceManual
	LEFT JOIN CTE_MANUALES_QX AS QX ON ISNULL(G.RateManualId ,DRD.RateManualId) =QX.IDMANUAL AND IPSHIJO.Id =QX.IDSERVICIO AND RM.Type =IPSHIJO.ServiceManual
	LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPSHIJO.AssociatedMaterialIPSServiceId 
    LEFT JOIN CTE_MANUALES_QX AS QXM ON ISNULL(G.RateManualId ,DRD.RateManualId) =QXM.IDMANUAL AND MAT.Id  =QXM.IDSERVICIO AND RM.Type =MAT.ServiceManual and QXM.IDGRUPO =IPS.SurgicalGroupId 
   WHERE DRDC.LiquidationType IN (2,3) AND DRD.RuleType =2 AND DR.Status =1 AND DRD.ConditionType<>5 AND  RM.Type =IPS.ServiceManual --and cups.Code ='306301' and dr.Code ='013HCS'
),

-------******SACAMOS LA REGLA POR SUB GRUPO CUPS********-----
CTE_REGLA_SUBGRUPOS_CUPS
AS
(
 SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType, CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',CSG.Name 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 NULL 'DESCRIPCION',NULL 'ESPECIALIDAD',NULL'UNIDAD FUNCIONAL',NULL 'HORA INCIAL',NULL 'HORA FINAL',
 CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION', DRD.LiquidationType,
 RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL', ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(RateVariation,0) '% VARIACION',
 CH.IPSServiceId IDSERVICIO ,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',NULL 'SERVICIO HIJO',IPS.ServiceManual,RM.Type,ISNULL(DET.VALOR,0) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
 MAT.Code  'COD MATERIAL',MAT.Name  'MATERIAL',DET.VALOR 'VALOR MATERIAL'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId /*IN V2*/AND DR.CODE=@TARIFA --FN V2
 INNER JOIN Contract .CupsSubgroup CSG ON CSG.CupsGroupId =DRD.CUPSSubgroupId 
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.CUPSSubGroupId =CSG.Id AND CUPS.Status =1
 LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id 
 LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId 
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 LEFT JOIN CTE_MANUALES_DETALLADOS DET ON ISNULL(G.RateManualId ,DRD.RateManualId) =DET.IDMANUAL AND IPS.Id =DET.IDSERVICIO
 LEFT JOIN Contract .IPSService MAT ON MAT.Id =DET.AssociatedMaterialIPSServiceId
 WHERE DRD.RuleType =3 AND DR.Status =1 AND  RM.Type =IPS.ServiceManual
),

-------******SACAMOS LA REGLA POR GRUPO CUPS********-----
/*IN V3
CTE_REGLA_GRUPOS_CUPS
AS
(
 SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType, CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',cg.name 'NOMBRE GRUPO',CSG.Name 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 NULL 'DESCRIPCION',NULL 'ESPECIALIDAD',NULL'UNIDAD FUNCIONAL',NULL 'HORA INCIAL',NULL 'HORA FINAL',
 CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',DRD.LiquidationType,
 RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL',ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(RateVariation,0) '% VARIACION',
 CH.IPSServiceId IDSERVICIO ,IPS.Code 'CODIGO SERVICIO',IPS.Name 'SERVICIO',IPSHIJO.Code + ' - ' + IPSHIJO.Name 'SERVICIO HIJO',IPS.ServiceManual,RM.Type,ISNULL(DET.VALOR,ISNULL(QX.VALOR,0)) 'VALOR' ,ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
 MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL',QXM.VALOR 'VALOR MATERIAL'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId /*IN V2*/AND DR.CODE=@TARIFA --FN V2
 INNER JOIN Contract .CupsGroup CG ON CG.Id =DRD.CUPSGroupId 
 INNER JOIN Contract .CupsSubgroup CSG ON CSG.CupsGroupId =CG.Id 
 INNER JOIN Contract .CUPSEntity AS CUPS ON CUPS.CUPSSubGroupId =CSG.Id AND CUPS.Status =1
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN Contract .CupsHomologation CH ON CH.CupsEntityId =CUPS.Id 
 LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId
 LEFT JOIN Contract .SurgicalProcedureService AS SPS ON SPS.IPSServiceParentId =IPS.Id 
 LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
 LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 LEFT JOIN CTE_MANUALES_DETALLADOS DET ON ISNULL(G.RateManualId ,DRD.RateManualId) =DET.IDMANUAL AND IPS.Id =DET.IDSERVICIO
 LEFT JOIN CTE_MANUALES_QX AS QX ON ISNULL(G.RateManualId ,DRD.RateManualId) =QX.IDMANUAL AND IPSHIJO.Id =QX.IDSERVICIO AND RM.Type =IPSHIJO.ServiceManual
 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPSHIJO.AssociatedMaterialIPSServiceId 
 LEFT JOIN CTE_MANUALES_QX AS QXM ON ISNULL(G.RateManualId ,DRD.RateManualId) =QXM.IDMANUAL AND MAT.Id  =QXM.IDSERVICIO AND RM.Type =MAT.ServiceManual and QXM.IDGRUPO =IPS.SurgicalGroupId 

 WHERE DRD.RuleType =4 AND DR.Status =1 AND RM.Type=IPS.ServiceManual   --AND DR.ID =29
 --AND CUPS.CODE IN ('997002')  --'971400','776943','010101',
),*/
CTE_REGLA_GRUPOS_CUPS
AS
(
 SELECT --DISTINCT 
 DR.Id IDTARIFA,
 DR.Code 'CODIGO TARIFA',
 DR.Name 'TARIFA', 
 CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',
 DRD.RuleType, 
 CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',
 CG.name 'NOMBRE GRUPO',
 CSG.Name 'SUBGRUPOS',
 CUPS.Code 'CUPS',
 CUPS.Description 'DESCRIPCION CUPS',
 NULL 'DESCRIPCION',
 NULL 'ESPECIALIDAD',
 NULL'UNIDAD FUNCIONAL',
 NULL 'HORA INCIAL',
 NULL 'HORA FINAL',
 CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',
 DRD.LiquidationType,
 RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL',
 ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,
 RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',
 ISNULL(RateVariation,0) '% VARIACION',
 CH.IPSServiceId IDSERVICIO ,
 IPS.Code 'CODIGO SERVICIO',
 IPS.Name 'SERVICIO',
 IPSHIJO.Code + ' - ' + IPSHIJO.Name 'SERVICIO HIJO',
 IPS.ServiceManual,
 RM.Type,
 ISNULL(DET.VALOR,ISNULL(QX.VALOR,0)) 'VALOR' ,
 ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
 MAT.Code 'COD MATERIAL',
 MAT.Name 'MATERIAL',
 QXM.VALOR 'VALOR MATERIAL'
 FROM 
 Contract.DefinitionRate DR
 INNER JOIN Contract.DefinitionRateDetail DRD ON DRD.DefinitionRateId=DR.Id /*IN V2*/AND DR.CODE=@TARIFA AND DRD.RuleType=4 AND DR.Status=1--FN V2
 INNER JOIN Contract.CupsGroup CG ON DRD.CUPSGroupId=CG.Id 
 INNER JOIN Contract.CupsSubgroup CSG ON CG.Id=CSG.CupsGroupId
 INNER JOIN Contract.CUPSEntity AS CUPS ON CSG.Id=CUPS.CUPSSubGroupId AND CUPS.Status =1
 LEFT JOIN Contract.RateManualValidity RMV ON DRD.RateManualValidityId=RMV.Id
 LEFT JOIN Contract.CupsHomologation CH ON CUPS.Id=CH.CupsEntityId 
 LEFT JOIN Contract.IPSService AS IPS ON CH.IPSServiceId=IPS.Id
 LEFT JOIN Contract.SurgicalProcedureService AS SPS ON SPS.IPSServiceParentId=IPS.Id 
 LEFT JOIN Contract.IPSService AS IPSHIJO ON SPS.IPSServiceId=IPSHIJO.Id
 LEFT JOIN
   (
    SELECT RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract.RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate AND RMVD.EndDate 
   ) AS G ON DRD.RateManualValidityId=G.RateManualValidityId
 LEFT JOIN Contract.RateManual AS RM ON ISNULL(G.RateManualId ,DRD.RateManualId)=RM.Id AND RM.Type=IPS.ServiceManual
 LEFT JOIN CTE_MANUALES_DETALLADOS DET ON ISNULL(G.RateManualId ,DRD.RateManualId)=DET.IDMANUAL AND IPS.Id =DET.IDSERVICIO
 LEFT JOIN CTE_MANUALES_QX AS QX ON ISNULL(G.RateManualId,DRD.RateManualId)=QX.IDMANUAL AND IPSHIJO.Id =QX.IDSERVICIO AND RM.Type =IPSHIJO.ServiceManual
 LEFT JOIN Contract.IPSService MAT ON IPSHIJO.AssociatedMaterialIPSServiceId=MAT.Id
 LEFT JOIN CTE_MANUALES_QX AS QXM ON ISNULL(G.RateManualId ,DRD.RateManualId)=QXM.IDMANUAL AND MAT.Id =QXM.IDSERVICIO AND RM.Type=MAT.ServiceManual and QXM.IDGRUPO=IPS.SurgicalGroupId 
 ),--FN V3

-----******SACAMOS LA REGLA GENERAL DE LA DEFINICION DE TARIFAS********-----
CTE_REGLA_GENERAL
AS
(
 SELECT DISTINCT DR.Id IDTARIFA,DR.Code 'CODIGO TARIFA',DR.Name 'TARIFA', CASE DRD.RuleType WHEN 1 THEN 'SERVICIO IPS' WHEN 2 THEN 'CUPS' WHEN 3 THEN 'SubGrupos CUPS' 
 WHEN 4 THEN 'Grupo CUPS' WHEN 5 THEN 'GENERAL' END 'TIPO REGLA',DRD.RuleType,CASE DRD.ConditionType WHEN 1 THEN 'Horario' WHEN 2 THEN 'Especialidad' WHEN 3 THEN 'Unidad Funcional' WHEN 4 THEN 'Tipo de Unidad' WHEN 5 THEN 'Ninguna' WHEN 6 THEN 'Rias'
 WHEN 7 THEN 'Descripcion' END 'CONDICION LIQUIDACION',NULL 'NOMBRE GRUPO',NULL 'SUBGRUPOS',CUPS.Code 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
 NULL 'DESCRIPCION',NULL 'ESPECIALIDAD',NULL'UNIDAD FUNCIONAL',NULL 'HORA INCIAL',NULL 'HORA FINAL',
 CASE DRD.LiquidationType WHEN 1 THEN 'Fija' WHEN 2 THEN 'Estandar' WHEN 3 THEN 'Vigencia' END 'TIPO LIQUIDACION',DRD.LiquidationType,
 RMV.Code + ' - ' + RMV.Name 'VIGENCIA MANUAL', ISNULL(G.RateManualId ,DRD.RateManualId) RateManualId,RM.Code + ' - ' + RM.NAME 'MANUAL TARIFAS',ISNULL(RateVariation,0) '% VARIACION',
 DET.IDSERVICIO ,DET.[CODIGO SERVICIO],DET.SERVICIO,IPSHIJO.Code + ' - ' + IPSHIJO.Name 'SERVICIO HIJO',DET.ServiceManual,RM.Type,ISNULL(DET.VALOR,ISNULL(QX.VALOR,0)) 'VALOR',ISNULL(DRD.SalesValue,0) 'VALOR GENERAL',
 MAT.Code 'COD MATERIAL',MAT.Name 'MATERIAL',QXM.VALOR 'VALOR MATERIAL'
 FROM Contract .DefinitionRateDetail DRD
 INNER JOIN Contract .DefinitionRate DR ON DR.Id =DRD.DefinitionRateId /*IN V2*/AND DR.CODE=@TARIFA --FN V2
 LEFT JOIN Contract .RateManualValidity RMV ON RMV.Id =DRD.RateManualValidityId
 LEFT JOIN
   (
    SELECT RMVD.Id ,RMVD.RateManualValidityId ,RMVD.RateManualId  
	FROM Contract .RateManualValidityDetail RMVD
	WHERE GETDATE() BETWEEN RMVD.InitialDate  AND RMVD.EndDate 
   ) AS G ON G.RateManualValidityId =DRD.RateManualValidityId 
 LEFT JOIN Contract .RateManual AS RM WITH (NOLOCK) ON RM.Id = ISNULL(G.RateManualId ,DRD.RateManualId)
 LEFT JOIN CTE_MANUALES_DETALLADOS DET ON ISNULL(G.RateManualId ,DRD.RateManualId) =DET.IDMANUAL --AND IPS.Id =DET.IDSERVICIO
 LEFT JOIN Contract .CupsHomologation CH ON CH.IPSServiceId=DET.IDSERVICIO 
 LEFT JOIN Contract .CUPSEntity CUPS ON CUPS.Id =CH.CupsEntityId 
 LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =CH.IPSServiceId
 LEFT JOIN Contract .SurgicalProcedureService AS SPS ON SPS.IPSServiceParentId =IPS.Id 
 LEFT JOIN Contract .IPSService AS IPSPADRE ON IPSPADRE.Id =SPS.IPSServiceParentId 
 LEFT JOIN Contract .IPSService AS IPSHIJO ON IPSHIJO.Id =SPS.IPSServiceId
 LEFT JOIN CTE_MANUALES_QX AS QX ON ISNULL(G.RateManualId ,DRD.RateManualId) =QX.IDMANUAL AND IPSHIJO.Id =QX.IDSERVICIO AND RM.Type =IPSHIJO.ServiceManual
 LEFT JOIN Contract .IPSService MAT ON MAT.Id =IPSHIJO.AssociatedMaterialIPSServiceId 
 LEFT JOIN CTE_MANUALES_QX AS QXM ON ISNULL(G.RateManualId ,DRD.RateManualId) =QXM.IDMANUAL AND MAT.Id  =QXM.IDSERVICIO AND RM.Type =MAT.ServiceManual and QXM.IDGRUPO =IPS.SurgicalGroupId 

 WHERE DRD.RuleType =5 AND DR.Status =1 AND RM.Type=DET.ServiceManual AND DET.[CODIGO SERVICIO] NOT IN 
 (SELECT [CODIGO SERVICIO]  FROM CTE_CODIGOS_UNICOS_REGLA_IPS_CUPS_GRUPO_SUBGRUPO)

)

 SELECT * FROM CTE_REGLA_SERVICIOS_IPS WHERE [CODIGO TARIFA] =@TARIFA     --'013HCS' AND CUPS ='453306'
UNION ALL
 SELECT * FROM CTE_REGLA_CUPS WHERE [CODIGO TARIFA]=@TARIFA -- AND CUPS ='453306'
UNION ALL
SELECT * FROM CTE_REGLA_SUBGRUPOS_CUPS WHERE [CODIGO TARIFA] = @TARIFA --'013HCS' AND CUPS ='453306'
UNION ALL
SELECT * FROM CTE_REGLA_GRUPOS_CUPS WHERE [CODIGO TARIFA] = @TARIFA --'013HCS' AND CUPS ='453306'
UNION ALL
 SELECT * FROM CTE_REGLA_GENERAL WHERE [CODIGO TARIFA] =@TARIFA --'013HCS' AND CUPS ='453306'
