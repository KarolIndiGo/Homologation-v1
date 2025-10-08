-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_COMPROBANTESENTRADA_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_COMPROBANTESENTRADA_SINCONFIRMAR AS

SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], s.Name AS Proveedor, o.Name AS Almacen, i.Description, i.InvoiceNumber AS [Numero Factura], i.InvoiceDate AS [Fecha Factura], i.DayPeriod, i.Value, 
                  i.ValueDiscount, i.TotalValue, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM INDIGO031.Inventory.EntranceVoucher AS i 
INNER JOIN INDIGO031.Inventory.Warehouse AS o ON o.Id = i.WarehouseId 
INNER JOIN INDIGO031.Common.OperatingUnit AS u ON u.Id = i.OperatingUnitId 
INNER JOIN INDIGO031.Common.Supplier AS s ON s.Id = i.SupplierId
WHERE  (i.Status = 1)