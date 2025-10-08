-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_ORDENESSERVICIO_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_ORDENESSERVICIO_SINCONFIRMAR
AS
SELECT u.UnitName AS Sucursal, i.Code, CASE OrderType WHEN 1 THEN 'Productos' WHEN 2 THEN 'Servicios' END AS [Tipo de Orden], i.DocumentDate, i.DeliveredDate, s.Name AS Proveedor, o.Name AS Almacen, i.Description, 
                  i.PaymentMethod AS [Forma de Pago], i.Value, i.DiscountValue, i.IvaValue, i.TotalValue, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, 
                  i.CreationDate AS [Fecha Creacion]
FROM      INDIGO031.Inventory.PurchaseOrder AS i INNER JOIN
                   INDIGO031.Inventory.Warehouse AS o   ON o.Id = i.WarehouseId INNER JOIN
                   INDIGO031.Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId INNER JOIN
                   INDIGO031.Common.Supplier AS s   ON s.Id = i.SupplierId
WHERE  (i.Status = 1)