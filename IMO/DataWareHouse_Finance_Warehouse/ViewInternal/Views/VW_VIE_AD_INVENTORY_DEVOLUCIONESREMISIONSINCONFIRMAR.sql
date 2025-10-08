-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_DEVOLUCIONESREMISIONSINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_DevolucionesRemisionSinConfirmar]
AS

SELECT 
    o.UnitName AS Sucursal,
    r.Code AS Codigo,
    r.RemissionDate AS [Fecha Remision],
    CASE r.DevolutionType 
        WHEN 1 THEN 'Entrada' 
        WHEN 2 THEN 'Salida' 
    END AS [Tipo Devolucion],
    a.Name AS Almacen,
    r.Description,
    CASE r.Status 
        WHEN 1 THEN 'Registrado' 
        WHEN 2 THEN 'Confirmado' 
        WHEN 3 THEN 'Anulado' 
    END AS Estado
FROM [INDIGO035].[Inventory].[RemissionDevolution] AS r
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS o
    ON o.Id = r.OperatingUnitId
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS a
    ON a.Id = r.WarehouseId
WHERE r.Status = 1;