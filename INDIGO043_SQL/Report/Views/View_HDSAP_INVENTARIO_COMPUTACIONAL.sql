-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INVENTARIO_COMPUTACIONAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_INVENTARIO_COMPUTACIONAL]
AS


SELECT fai.Description Nombre,
FAPA.PLATE Placa,
       FAPA.Serie Serie,
	   FAT.Name Marca,
	   FAPA.Model Modelo,
	   FAPA.AdquisitionDate,
	   datediff(YEAR, FAPA.AdquisitionDate, getdate()) TiempoVidaAños,
	   fal.Name Ubicacion,
	   fapa.Status 
FROM FixedAsset.FixedAssetPhysicalAsset AS FAPA
     INNER JOIN FixedAsset.FixedAssetItem AS FAI ON FAPA.ItemId = FAI.ID
     INNER JOIN FixedAsset.FixedAssetLocation AS FAL ON FAPA.LocationId = FAL.Id
     INNER JOIN FixedAsset.FixedAssetTrademark AS FAT ON FAPA.TrademarkId = FAT.Id
WHERE FAI.ItemCatalogId='30' 
  

