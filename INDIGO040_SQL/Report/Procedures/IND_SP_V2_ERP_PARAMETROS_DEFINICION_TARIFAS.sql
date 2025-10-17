-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PARAMETROS_DEFINICION_TARIFAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[IND_SP_V2_ERP_PARAMETROS_DEFINICION_TARIFAS]
Tipo: Procedimiento Almacenado
Observacion:Manual de tarifas
Profesional:06-02-2024
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
-----------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/

CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PARAMETROS_DEFINICION_TARIFAS] AS

SELECT
DT.Code AS [CODGIGO DEFINICIÓN DE TARIFA],
DT.Name AS [DEFINICIÓN DE TARIFA],
DT.Description AS [DESCRIPTION DE DEFINICIÓN DE TARIFA],
CASE DTD.RuleType WHEN 1 THEN 'Servicio IPS'
				  WHEN 2 THEN 'CUPS'
				  WHEN 3 THEN 'SubGrupos CUPS'
				  WHEN 4 THEN 'Grupo CUPS'
				  WHEN 5 THEN 'General' END AS [TIPO DE REGLA],
IPS.Code+' - '+IPS.[Name] AS [SERVICIO IPS],
CUPS.CODE+' - '+CUPS.[Description] AS CUPS,
SUBC.CODE+' - '+SUBC.[Description] AS [SUB GRUPO CUPS],
GRUC.CODE+' - '+GRUC.[Description] AS [GRUPO CUPS],
CASE DTD.ConditionType WHEN 1 THEN 'Horario'
					   WHEN 2 THEN 'Especialidad'
					   WHEN 3 THEN 'Unidad Funcional'
					   WHEN 4 THEN 'Tipo de Unidad'
					   WHEN 5 THEN 'Ninguna'
					   WHEN 6 THEN 'RIAS' END AS [CONDICIÓN],
DTD.Weight AS PESO,
CASE DTD.LiquidationType WHEN 1 THEN 'Fija'
						 WHEN 2 THEN 'Estandar'
						 WHEN 3 THEN 'Vigencia' END AS [TIPO DE LIQUIDACIÓN],
CASE DTD.ManualType WHEN 1 THEN 'ISS 2001'
					WHEN 2 THEN 'ISS 2004'
					WHEN 3 THEN 'SOAT' END AS [MANUAL TARIFARIO],
DTD.SalesValue AS [VALOR SERVICIO],
DTD.SalesValueWithSurcharge AS [VALOR SERVICIO CON RECARGO]
FROM 
[Contract].DefinitionRate DT
INNER JOIN [Contract].DefinitionRateDetail DTD ON DT.Id=DefinitionRateId
LEFT JOIN [Contract].IPSService IPS ON DTD.IPSServiceId=IPS.Id AND DTD.RuleType=1
LEFT JOIN [Contract].CUPSEntity CUPS ON DTD.CUPSEntityId=CUPS.Id AND DTD.RuleType=2
LEFT JOIN [Contract].CupsSubgroup SUBC ON DTD.CUPSSubgroupId=SUBC.Id AND DTD.RuleType=3
LEFT JOIN [Contract].CupsGroup GRUC ON DTD.CUPSSubgroupId=GRUC.Id AND DTD.RuleType=4
--WHERE DT.Code='EPS037_001'



