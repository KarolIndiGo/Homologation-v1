-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Fixed_CuentasActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Fixed_CuentasActivos]
AS
SELECT pa.Id, 
CASE pa.AdquisitionType WHEN '1' THEN (rtrim(ma1.number) + ' - ' + rtrim(ma1.name)) 
WHEN '3' THEN (rtrim(ma3.number) + ' - ' + rtrim(ma3.name)) 
WHEN '4' THEN (rtrim(ma1.number) + ' - ' + rtrim(ma1.name)) 
WHEN '7' THEN (rtrim(ma7.number) + ' - ' + rtrim(ma7.name)) 
WHEN '9' THEN (rtrim(ma9.number) + ' - ' + rtrim(ma9.name))
WHEN '8' THEN (rtrim(ma9.number) + ' - ' + rtrim(ma9.name)) END AS CuentaContable, 

pa.Plate, it.Code, it.Description, fit.Code AS CodeType, fit.Name AS NameType, pa.HistoricalValue, ISNULL(pad.Valorization, 0) AS Valorization, ISNULL(pad.Devaluation, 0) AS Devaluation, ISNULL(pad.DepreciatedValue, 0) AS DepreciatedValue, ISNULL(pad.ResidualValue, 0) 
           AS ResidualValue, pa.HasOutput, ISNULL(pad.LegalBookId, 0) AS LegalBookId
FROM   FixedAsset.FixedAssetPhysicalAsset AS pa INNER JOIN
           FixedAsset.FixedAssetItem AS it ON it.Id = pa.ItemId INNER JOIN
           FixedAsset.FixedAssetItemType AS fit ON fit.Id = it.ItemTypeId INNER JOIN
           FixedAsset.FixedAssetItemCatalog AS c ON c.Id = it.ItemCatalogId LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS ma1 ON pa.AdquisitionType IN ('1') AND ma1.Id = c.IncomeAccountId LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS ma3 ON ma3.Id = c.DebitLoanAccountId LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS ma4 ON ma4.Id = c.IncomeAccountId LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS ma7 ON ma7.Id = c.IncomeLeasingAccountId LEFT OUTER JOIN
           FixedAsset.FixedAssetPhysicalAssetDetailBook AS pad ON pa.Id = pad.PhysicalAssetId AND pad.LegalBookId = '1' LEFT OUTER JOIN
           FixedAsset.FixedAssetItemCatalogAdquisitionType AS CAT ON CAT.ItemCatalogId = c.Id AND CAT.AdquisitionType = '9' AND CAT.LegalBookId = '1' LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS ma9 ON ma9.Id = CAT.MainAccountId
		  -- where pa.Plate='FCD0378'
