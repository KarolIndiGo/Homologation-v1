-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CUPS_VALOR
-- Extracted by Fabric SQL Extractor SPN v3.9.0









CREATE VIEW [Report].[View_HDSAP_CUPS_VALOR]
AS
SELECT Contract.CUPSEntity.Code AS Cups, 
Contract.CUPSEntity.Description AS NombreCups, 
Contract.IPSService.Code AS CodigoSoat, 
Contract.IPSService.Name AS NombreSoat, 
SUB.NAME,
SUB.Description,
cg.name NombreGrupo,
cg.Description DescripcionGrupo,
Contract.SurgicalGroup.Code AS CodGrupoQX, 
Contract.SurgicalGroup.Name AS NombreGrupoQX,
Contract.RateManual.Code AS CodigoManual, 
Contract.RateManual.Name AS NombreManual, 
Contract.RateManualDetail.SalesValueWithSurcharge AS Valor,
Contract.RateManualDetail.SalesValue AS ValorConRecargo

FROM (Contract.RateManualDetail RIGHT JOIN (Contract.SurgicalGroup RIGHT JOIN 
((Contract.CUPSEntity 
LEFT JOIN Contract.CupsHomologation ON Contract.CUPSEntity.Id = Contract.CupsHomologation.CupsEntityId) 
LEFT JOIN Contract.IPSService ON Contract.CupsHomologation.IPSServiceId = Contract.IPSService.Id)
ON Contract.SurgicalGroup.Id = Contract.IPSService.SurgicalGroupId) ON Contract.RateManualDetail.IPSServiceId = Contract.IPSService.Id) 
JOIN Contract.CupsSubgroup SUB ON SUB.ID = Contract.CUPSEntity.CUPSSubGroupId
JOIN Contract.CupsGroup CG ON CG.Id = SUB.CupsGroupId
LEFT JOIN Contract.RateManual ON Contract.RateManualDetail.RateManualId = Contract.RateManual.Id;

