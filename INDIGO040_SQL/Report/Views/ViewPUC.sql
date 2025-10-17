-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewPUC
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE View [Report].[ViewPUC] as

SELECT 
Number AS [NUMERO CUENTA],
MA.[Name] AS NOMBRE,
CASE Nature WHEN 1 THEN 'Debito' ELSE 'Credito' END AS [NATURALEZA],
CASE HandlesThirdParty WHEN 1 THEN 'SI' ELSE 'NO' END AS [MANEJA TERCERO],
CASE CloseThirdParty WHEN 1 THEN 'SI' ELSE 'NO' END AS [CIERRE TERCERO],
TER.Nit+' - '+TER.Name AS TERCERO,
CASE HandlesCostCenter WHEN 1 THEN 'SI' ELSE 'NO' END AS [MANEJA CENTRO COSTO],
CASE AllowsMovement WHEN 1 THEN 'SI' ELSE 'NO' END AS [CUENTA MOVIMIENTO],
CASE Status WHEN 1 THEN 'Activo' ELSE 'Inactivo' END AS ESTADO
FROM 
GeneralLedger.MainAccounts MA
LEFT JOIN Common.ThirdParty TER ON MA.IdThirdParty=TER.Id
where ma.LegalBookId = 1
