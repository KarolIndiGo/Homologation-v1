-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_SOLICITUDES_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_Solicitudes_SinConfirmar]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code AS Codigo,
    i.DocumentDate AS [Fecha Documento],
    CASE i.RequestType WHEN 1 THEN 'Unidad Funcional' WHEN 2 THEN 'Almacen' END AS TipoSolicitud,
    CASE i.MovementType WHEN 1 THEN 'Consumo' WHEN 2 THEN 'Traslado' END AS Tipo,
    o.Name AS AlmacenOrigen,
    o1.Name AS AlmacenDestino,
    i.Observation AS Observacion,
    CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM [INDIGO035].[Inventory].[InventoryRequest] AS i
LEFT OUTER JOIN [INDIGO035].[Inventory].[Warehouse] AS o
    ON o.Id = i.SourceWarehouseId
LEFT OUTER JOIN [INDIGO035].[Inventory].[Warehouse] AS o1
    ON o.Id = i.TargetWarehouseId
LEFT OUTER JOIN [INDIGO035].[Common].[OperatingUnit] AS u
    ON u.Id = i.OperatingUnitId
WHERE i.Status = 1;