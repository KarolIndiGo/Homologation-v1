-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_Fixed_CambioPlacaActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create VIEW [ViewInternal].[IMO_AD_Fixed_CambioPlacaActivos]
AS
SELECT cp.Id, cp.Code AS Código, cp.DocumentDate AS Fecha, cp.Detail AS Detalle, CASE Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dcp.OldPlate AS PlacaAntigua, 
                  dcp.NewPlate AS PlacaNueva
FROM     FixedAsset.FixedAssetChangePlate AS cp  INNER JOIN
                  FixedAsset.FixedAssetChangePlateDetail AS dcp  ON dcp.FixedAssetChangePlateId = cp.Id

