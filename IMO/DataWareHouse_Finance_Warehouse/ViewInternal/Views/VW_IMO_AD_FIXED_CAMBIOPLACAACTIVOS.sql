-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_FIXED_CAMBIOPLACAACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_AD_Fixed_CambioPlacaActivos]
AS

SELECT 
    cp.Id, 
    cp.Code AS Código, 
    cp.DocumentDate AS Fecha, 
    cp.Detail AS Detalle, 
    CASE Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, 
    dcp.OldPlate AS PlacaAntigua, 
    dcp.NewPlate AS PlacaNueva
FROM [INDIGO035].[FixedAsset].[FixedAssetChangePlate] AS cp
INNER JOIN [INDIGO035].[FixedAsset].[FixedAssetChangePlateDetail] AS dcp
    ON dcp.FixedAssetChangePlateId = cp.Id;