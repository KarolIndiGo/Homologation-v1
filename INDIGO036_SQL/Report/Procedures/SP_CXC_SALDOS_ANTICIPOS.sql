-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_CXC_SALDOS_ANTICIPOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[SP_CXC_SALDOS_ANTICIPOS]
AS
SELECT PA.Code 'CODIGO' ,TP.Nit 'NIT', TP.Name 'CLIENTE' ,MA.Number 'CUENTA',MA.Name 'NOMBRE CUENTA',PA.DocumentDate 'FECHA DOCUMENTO',PA.Value 'VALOR',
PA.Observations 'OBSERVACIONES'
FROM  Portfolio .PortfolioAdvance PA
INNER JOIN Common .ThirdParty AS TP ON TP.Id =PA.ThirdPartyId 
INNER JOIN GeneralLedger.MainAccounts  AS MA ON MA.ID=PA.MainAccountId 
where OpeningBalance =1
ORDER BY PA.Code