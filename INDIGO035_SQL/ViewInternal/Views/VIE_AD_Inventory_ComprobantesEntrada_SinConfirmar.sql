-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_ComprobantesEntrada_SinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[VIE_AD_Inventory_ComprobantesEntrada_SinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], s.Name AS Proveedor, o.Name AS Almacen, i.Description, i.InvoiceNumber AS [Numero Factura], i.InvoiceDate AS [Fecha Factura], i.DayPeriod, i.Value, 
                  i.ValueDiscount, i.TotalValue, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM      Inventory.EntranceVoucher AS i INNER JOIN
                   Inventory.Warehouse AS o ON o.Id = i.WarehouseId INNER JOIN
                   Common.OperatingUnit AS u ON u.Id = i.OperatingUnitId INNER JOIN
                   Common.Supplier AS s ON s.Id = i.SupplierId
WHERE  (i.Status = 1)
