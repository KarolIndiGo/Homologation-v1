-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_DepreciacionActivosContabilidad
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_DepreciacionActivosContabilidad]
AS


select distinct
ct.Code as 'Codigo catalogo',
ct.[Description] as NombreCatalogo,
CONCAT(fai.Code, '-'  , fai.Description) as ArticuloDetalle,
fapa.Plate as Placa,
fapa.AdquisitionDate as FechaAdquisición,
fapa.InstallationDate FechaInstalacion,
fapa.HistoricalValue ValorHistorico,
t.Value Valorizacion,
faid.[LifeTime] as 'Vida util',
fadd.DepreciatedDays as 'Dias Depreciado',
fadd.ResidualValue ValorResidual,
fapad.DepreciatedDays DiasDepreciados,
fapad.DaysPendingDepreciate DiasPendientesDepreciar,
fadd.DepreciationValue as 'Depreciación mes',
fad.ClosingMonth as Mes,
fadd.AccumulatedDepreciation as 'Valor Acomulado Depreciación',
fad.ClosingDate Ultimocierre

from FixedAsset.FixedAssetDepreciationDetail fadd
inner join GeneralLedger.LegalBook lb on lb.Id = fadd.LegalBookId
inner join FixedAsset.FixedAssetPhysicalAsset fapa on fapa.Id = fadd.FixedAssetPhysicalAssetId
left join FixedAsset.FixedAssetPhysicalAssetDetailBook fapad on fapad.PhysicalAssetId = fapa.id
left join FixedAsset.FixedAssetTransactiondetail  t on t.PhysicalAssetId = fapa.id 
inner join FixedAsset.FixedAssetItem fai on fai.Id = fapa.ItemId
inner join FixedAsset.FixedAssetItemDetail faid on fai.Id= faid.FixedAssetItemId
inner join FixedAsset.FixedAssetDepreciation fad on fad.Id = fadd.FixedAssetDepreciationId
inner join FixedAsset.FixedAssetItemCatalog  ct on fai.ItemCatalogId = ct.Id
--where fapa.plate = '007402' and ClosingYear='2020'
  

