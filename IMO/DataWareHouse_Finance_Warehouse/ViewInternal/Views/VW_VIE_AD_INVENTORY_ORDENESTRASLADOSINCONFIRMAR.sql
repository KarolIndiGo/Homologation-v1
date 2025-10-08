-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_ORDENESTRASLADOSINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_OrdenesTrasladoSinConfirmar]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code AS Codigo,
    i.OperatingUnitId,
    i.DocumentDate AS [Fecha Documento],
    CASE i.OrderType WHEN 1 THEN 'Traslado' WHEN 2 THEN 'Consumo' END AS [Tipo Orden],
    CASE i.DispatchTo WHEN 1 THEN 'Almacen' WHEN 2 THEN 'Unidad Funcional' END AS [Despachar a],
    o.Name AS [Almacen Origen],
    d.Name AS [Almacen Destino],
    i.Description AS Descripcion,
    CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado,
    i.CreationDate AS [Fecha Creacion]
FROM [INDIGO035].[Inventory].[TransferOrder] AS i
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS o
    ON o.Id = i.SourceWarehouseId
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS d
    ON d.Id = i.TargetWarehouseId
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS u
    ON u.Id = i.OperatingUnitId
WHERE i.Status = 1;