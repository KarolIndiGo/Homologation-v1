-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VResumidoDepreciacionXCuenta
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE view [ViewInternal].[VResumidoDepreciacionXCuenta]
as (

select d.ClosingMonth, map.Number + ' - ' + map.Name as Cuenta,ma.Number + ' - ' + ma.Name as Cuenta2, sum(ddc.DepreciationValue) as Value
from FixedAsset.FixedAssetDepreciation d
inner join FixedAsset.FixedAssetDepreciationDetail dd on d.Id = dd.FixedAssetDepreciationId
inner join FixedAsset.FixedAssetDepreciationDetailCost ddc on ddc.FixedAssetDepreciationDetailId = dd.Id
inner join FixedAsset.FixedAssetPhysicalAsset ph on ph.Id = dd.FixedAssetPhysicalAssetId
inner join FixedAsset.FixedAssetItem i on i.Id = ph.ItemId
inner join FixedAsset.FixedAssetItemCatalog c on c.Id = i.ItemCatalogId
inner join GeneralLedger.MainAccounts ma on ma.Id = c.DepreciationAccountId 
inner join GeneralLedger.MainAccounts map on map.Id = ph.MainAccountId
where dd.LegalBookId = 1
group by d.ClosingMonth, map.Number, map.Name, ma.Number, ma.Name
)



