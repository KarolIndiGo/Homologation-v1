-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VRESUMIDODEPRECIACIONXCUENTA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VRESUMIDODEPRECIACIONXCUENTA
as (

select d.ClosingMonth, map.Number + ' - ' + map.Name as Cuenta,ma.Number + ' - ' + ma.Name as Cuenta2, sum(ddc.DepreciationValue) as Value
from INDIGO031.FixedAsset.FixedAssetDepreciation d
inner join INDIGO031.FixedAsset.FixedAssetDepreciationDetail dd on d.Id = dd.FixedAssetDepreciationId
inner join INDIGO031.FixedAsset.FixedAssetDepreciationDetailCost ddc on ddc.FixedAssetDepreciationDetailId = dd.Id ---
inner join INDIGO031.FixedAsset.FixedAssetPhysicalAsset ph on ph.Id = dd.FixedAssetPhysicalAssetId
inner join INDIGO031.FixedAsset.FixedAssetItem i on i.Id = ph.ItemId
inner join INDIGO031.FixedAsset.FixedAssetItemCatalog c on c.Id = i.ItemCatalogId 
inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = c.DepreciationAccountId 
inner join INDIGO031.GeneralLedger.MainAccounts map on map.Id = ph.MainAccountId
where dd.LegalBookId = 1
group by d.ClosingMonth, map.Number, map.Name, ma.Number, ma.Name
)
