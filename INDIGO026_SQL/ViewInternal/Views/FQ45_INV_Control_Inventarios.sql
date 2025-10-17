-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_INV_Control_Inventarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_INV_Control_Inventarios]
AS
select ii.Code as Cod_ControlInv, ip.Code as Cod_Producto, ip.[Name] as Nombre_Producto, iw.Code as Cod_Bodega ,iw.[Name] as Nombre_Bodega 
, iid.Quantity as Cantidad, ip.ProductCost as Valor_Unitario, (iid.Quantity * ip.ProductCost) as Costo_Total  from Inventory.InventoryControl ii
inner join Inventory.InventoryControlDetail iid on ii.Id = iid.InventoryControlId
inner join Inventory.Warehouse iw on ii.WarehouseId = iw.Id
inner join Inventory.InventoryProduct ip on ip.Id = iid.ProductId
