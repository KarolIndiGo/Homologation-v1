-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewVerficacionTarifasServicios
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[ViewVerficacionTarifasServicios] AS

WITH CTE_DEFINICION_TARIFAS_CABE
AS
(
  select DR.id,DR.Code ,DR.Name,dr.Status   from Contract .DefinitionRate as DR 
  WHERE DR.Status =1 --AND Code ='001HNE'
),
CTE_DEFINICION_TARIFAS_DETALLE
AS
(
  SELECT  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,DR.Code as CodPlantilla ,DR.Name as Plantilla, case when DRD.RuleType = 1 then 'Servicio' else 'Cups' end as TipoRegla,IPS.Code as CodIps ,
  IPS.Name AS ServicioIPS , cg.Code AS CodigoGrupo,cg.Name as Grupo,csg.Code as CodSubGrupo,csg.Name as SubGrupo ,CUPS.Code as CodCups ,CUPS.Description AS Cups,
  CASE CUPS.status WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' END AS [Estado CUP],CASE cups.financedresourceUPC WHEN 1 THEN 'Si' WHEN 0 THEN 'No' END AS [Financiado con Recursos de la UPC],
 case ConditionType when 5 then 'Ninguna' when 7 then 'DescripcionRelacionada' else 'Otro' end TipoCondicion,
 case DRD.LiquidationType when 1 then 'Fija' when 2 then 'Estandar' else 'N/A' end as TipoLiquidacion,
 DRD.SalesValue as 'ValorFijo',DRD.SalesValueWithSurcharge as 'ValorRecargo',RM.Name as Manual,DRD.RateVariation as '%Variacion',
 case DRDC .LiquidationType when 1 then 'Fija' when 2 then 'Estandar' else 'N/A' end TipoLiquidacionCondicion,
 case DRDC.ManualType when 1 then 'ISS' when 2 then 'Soat' else 'N/A' end TipoManaulCondicion ,DRDC.SalesValue as ValorCondicion,
 DRDC.SalesValueWithSurcharge ValorRecargoCondicion, RM2.Code AS Codigo,RM2.Name, CD.Code AS CodDescri, CD.Name AS DescripcionRelacionada,
 DRDC .RateVariation VariacionCondicion,IPS2 .Code as CodHijo, IPS2.Name AS ipsHijo,
 1 as 'CANTIDAD',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  
  FROM Contract .DefinitionRate as DR 
  INNER JOIN CTE_DEFINICION_TARIFAS_CABE CAB ON CAB.Id =DR.Id 
  INNER JOIN   Contract.DefinitionRateDetail as DRD ON DRD.DefinitionRateId =CAB.Id 
  LEFT JOIN Contract .CUPSEntity AS CUPS ON CUPS.Id =DRD.CUPSEntityId 
  LEFT JOIN Contract .IPSService AS IPS ON IPS.Id =DRD.IPSServiceId 
  left outer join Contract.CupsSubgroup csg ON CUPS.CUPSSubGroupId = csg.Id 
  LEFT OUTER JOIN Contract.CupsGroup cg ON csg.CupsGroupId = cg.Id 
  lEFT OUTER JOIN Contract.RateManual as RM on RM.Id =DRD.RateManualId 
  left outer join Contract.DefinitionRateDetailCondition as DRDC ON DRDC.DefinitionRateDetailId =DRD.Id 
  left outer join Contract.RateManual as RM2 on RM2.Id =DRDC.RateManualId 
  left outer join Contract.ContractDescriptions as CD on CD.Id =DRDC.ContractDescriptionId 
  left outer join Contract.DefinitionRateDetailSurgicalProcedures as DRDSP ON DRDSP.DefinitionRateDetailId =DRD.Id 
  left outer join Contract.IPSService AS IPS2 ON DRDSP.IPSServiceId =IPS2.Id
  --WHERE CUPS.Code ='010101'
)

SELECT * FROM CTE_DEFINICION_TARIFAS_DETALLE

--SELECT * FROM Contract .DefinitionRateDetailSurgicalProcedures 