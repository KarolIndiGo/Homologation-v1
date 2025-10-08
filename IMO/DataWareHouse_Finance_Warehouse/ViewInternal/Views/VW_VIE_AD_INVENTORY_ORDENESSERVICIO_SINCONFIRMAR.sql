-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_ORDENESSERVICIO_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_OrdenesServicio_SinConfirmar]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code,
    CASE i.OrderType WHEN 1 THEN 'Productos' WHEN 2 THEN 'Servicios' END AS [Tipo de Orden],
    i.DocumentDate,
    i.DeliveredDate,
    s.Name AS Proveedor,
    o.Name AS Almacen,
    i.Description,
    i.PaymentMethod AS [Forma de Pago],
    i.Value,
    i.DiscountValue,
    i.IvaValue,
    i.TotalValue,
    CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado,
    i.CreationDate AS [Fecha Creacion]
FROM [INDIGO035].[Inventory].[PurchaseOrder] AS i
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS o
    ON o.Id = i.WarehouseId
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS u
    ON u.Id = i.OperatingUnitId
INNER JOIN [INDIGO035].[Common].[Supplier] AS s
    ON s.Id = i.SupplierId
WHERE i.Status = 1;