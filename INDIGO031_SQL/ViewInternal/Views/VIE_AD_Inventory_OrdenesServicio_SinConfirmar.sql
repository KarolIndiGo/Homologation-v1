-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_OrdenesServicio_SinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_OrdenesServicio_SinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code, CASE OrderType WHEN 1 THEN 'Productos' WHEN 2 THEN 'Servicios' END AS [Tipo de Orden], i.DocumentDate, i.DeliveredDate, s.Name AS Proveedor, o.Name AS Almacen, i.Description, 
                  i.PaymentMethod AS [Forma de Pago], i.Value, i.DiscountValue, i.IvaValue, i.TotalValue, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, 
                  i.CreationDate AS [Fecha Creacion]
FROM      Inventory.PurchaseOrder AS i INNER JOIN
                   Inventory.Warehouse AS o   ON o.Id = i.WarehouseId INNER JOIN
                   Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId INNER JOIN
                   Common.Supplier AS s   ON s.Id = i.SupplierId
WHERE  (i.Status = 1)

