-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TRASLADOS_ACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_TRASLADOS_ACTIVOS]
AS

select f.DocumentDate Fecha,
       f.Code [Numero Traslado],
	   fi.Code [Articulo],
	   fi.[Description] [Nombre Articulo],
	   fa.Plate Placa,
	   fl.[Name] [Nombre Ubicacion Anterior],
	   fl1.[Name] [Nombre Nueva ubicación]

from FixedAsset.FixedAssetTransfer f
join FixedAsset.FixedAssetTransferDetail d on d.FixedAssetTransferId = f.id
join FixedAsset.FixedAssetPhysicalAsset fa on fa.Id = d.PhysicalAssetId
join FixedAsset.FixedAssetLocation fal on fal.Id = fa.LocationId
join FixedAsset.FixedAssetItem  fi on fi.Id = fa.ItemId
join FixedAsset.FixedAssetLocation fl on fl.Id = f.SourceLocationId
join FixedAsset.FixedAssetLocation fl1 on fl1.Id = f.TargetLocationId

