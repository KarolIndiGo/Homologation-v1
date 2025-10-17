-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Fixed_CambioPlacaActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Fixed_CambioPlacaActivos] AS
SELECT cp.Id, cp.Code AS Código, cp.DocumentDate AS Fecha, cp.Detail AS Detalle, CASE Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dcp.OldPlate AS PlacaAntigua, 
                  dcp.NewPlate AS PlacaNueva
FROM     FixedAsset.FixedAssetChangePlate AS cp WITH (nolock) INNER JOIN
FixedAsset.FixedAssetChangePlateDetail AS dcp WITH (nolock) ON dcp.FixedAssetChangePlateId = cp.Id
