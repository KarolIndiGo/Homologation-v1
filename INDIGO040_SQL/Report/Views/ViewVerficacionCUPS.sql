-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewVerficacionCUPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[ViewVerficacionCUPS] AS
SELECT DISTINCT
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 ce.Code [Cod. CUPS],
 CASE ce.status WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' END AS [Estado CUP],
 CASE ce.financedresourceUPC WHEN 1 THEN 'Si' WHEN 0 THEN 'No' END AS [Financiado con Recursos de la UPC],
 ce.Description [Descripción CUPS],
 cg.Code as CodigoGrupo,
 cg.Description [Grupo CUPS],
 csg.Code as CodigoSubGrupo,
 csg.Description [Subgrupo CUPS],
 cd.Code as CodDescripcionRelacionada,
 cd.Name [Descripción Relacionada],
 ips.Name [Homologo],
 rm.Name [Manual],
 IIF(ce.Status = 1, 'Activo', 'Inactivo') [Estado],
 1 as 'CANTIDAD',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
 Contract.CUPSEntity ce
 INNER JOIN Contract.CupsSubgroup csg ON ce.CUPSSubGroupId = csg.Id
 INNER JOIN Contract.CupsGroup cg ON csg.CupsGroupId = cg.Id
 LEFT JOIN Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId
 LEFT JOIN Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
 LEFT JOIN Contract.CupsHomologation ch ON ce.Id = ch.CupsEntityId
 LEFT JOIN Contract.IPSService ips ON ch.IPSServiceId = ips.Id
 LEFT JOIN Contract.RateManualDetail rmd ON ips.Id = rmd.IPSServiceId
 LEFT JOIN Contract.RateManualDetailSurgical rmds ON ips.Id = rmds.IPSServiceId
 LEFT JOIN Contract.RateManual rm ON rmd.RateManualId = rm.Id OR rmds.RateManualId = rm.Id
