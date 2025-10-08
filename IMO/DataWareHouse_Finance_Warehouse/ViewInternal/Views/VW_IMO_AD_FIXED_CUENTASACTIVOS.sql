-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_FIXED_CUENTASACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_AD_Fixed_CuentasActivos]
AS

SELECT pa.Id, 
CASE pa.AdquisitionType 
    WHEN '1' THEN (RTRIM(ma1.Number) + ' - ' + RTRIM(ma1.Name)) 
    WHEN '3' THEN (RTRIM(ma3.Number) + ' - ' + RTRIM(ma3.Name)) 
    WHEN '4' THEN (RTRIM(ma1.Number) + ' - ' + RTRIM(ma1.Name)) 
    WHEN '7' THEN (RTRIM(ma7.Number) + ' - ' + RTRIM(ma7.Name)) 
    WHEN '9' THEN (RTRIM(ma9.Number) + ' - ' + RTRIM(ma9.Name))
    WHEN '8' THEN (RTRIM(ma9.Number) + ' - ' + RTRIM(ma9.Name)) 
END AS CuentaContable, 

pa.Plate, it.Code, it.Description, fit.Code AS CodeType, fit.Name AS NameType, 
pa.HistoricalValue, ISNULL(pad.Valorization, 0) AS Valorization, 
ISNULL(pad.Devaluation, 0) AS Devaluation, 
ISNULL(pad.DepreciatedValue, 0) AS DepreciatedValue, 
ISNULL(pad.ResidualValue, 0) AS ResidualValue, 
pa.HasOutput, ISNULL(pad.LegalBookId, 0) AS LegalBookId
FROM   [INDIGO035].[FixedAsset].[FixedAssetPhysicalAsset] AS pa 
INNER JOIN [INDIGO035].[FixedAsset].[FixedAssetItem] AS it 
    ON it.Id = pa.ItemId 
INNER JOIN [INDIGO035].[FixedAsset].[FixedAssetItemType] AS fit 
    ON fit.Id = it.ItemTypeId 
INNER JOIN [INDIGO035].[FixedAsset].[FixedAssetItemCatalog] AS c 
    ON c.Id = it.ItemCatalogId 
LEFT OUTER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma1 
    ON pa.AdquisitionType IN ('1') AND ma1.Id = c.IncomeAccountId 
LEFT OUTER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma3 
    ON ma3.Id = c.DebitLoanAccountId 
LEFT OUTER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma4 
    ON ma4.Id = c.IncomeAccountId 
LEFT OUTER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma7 
    ON ma7.Id = c.IncomeLeasingAccountId 
LEFT OUTER JOIN [INDIGO035].[FixedAsset].[FixedAssetPhysicalAssetDetailBook] AS pad 
    ON pa.Id = pad.PhysicalAssetId AND pad.LegalBookId = '1' 
LEFT OUTER JOIN [INDIGO035].[FixedAsset].[FixedAssetItemCatalogAdquisitionType] AS CAT 
    ON CAT.ItemCatalogId = c.Id AND CAT.AdquisitionType = '9' AND CAT.LegalBookId = '1' 
LEFT OUTER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma9 
    ON ma9.Id = CAT.MainAccountId
-- WHERE pa.Plate = 'FCD0378'