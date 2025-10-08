-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VRESUMIDODEPRECIACIONXCUENTA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VResumidoDepreciacionXCuenta
AS 

select d.ClosingMonth, map.Number + ' - ' + map.Name as Cuenta,ma.Number + ' - ' + ma.Name as Cuenta2, sum(ddc.DepreciationValue) as Value
from [INDIGO035].[FixedAsset].[FixedAssetDepreciation] d
inner join [INDIGO035].[FixedAsset].[FixedAssetDepreciationDetail] dd on d.Id = dd.FixedAssetDepreciationId
inner join [INDIGO035].[FixedAsset].[FixedAssetDepreciationDetailCost] ddc on ddc.FixedAssetDepreciationDetailId = dd.Id
inner join [INDIGO035].[FixedAsset].[FixedAssetPhysicalAsset] ph on ph.Id = dd.FixedAssetPhysicalAssetId
inner join [INDIGO035].[FixedAsset].[FixedAssetItem] i on i.Id = ph.ItemId
inner join [INDIGO035].[FixedAsset].[FixedAssetItemCatalog] c on c.Id = i.ItemCatalogId
inner join [INDIGO035].[GeneralLedger].[MainAccounts] ma on ma.Id = c.DepreciationAccountId 
inner join [INDIGO035].[GeneralLedger].[MainAccounts] map on map.Id = ph.MainAccountId
where dd.LegalBookId = 1
group by d.ClosingMonth, map.Number, map.Name, ma.Number, ma.Name
