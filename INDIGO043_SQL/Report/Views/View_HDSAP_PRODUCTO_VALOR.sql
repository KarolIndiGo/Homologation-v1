-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRODUCTO_VALOR
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_PRODUCTO_VALOR]
AS

select i.code CodigoProducto,
       i.name NombreProducto,
	   i.ProductCost ValorProducto,
	   i.FinalProductCost UltimoCosto,
	   p.Quantity Cantidad,
	   pg.Name GrupoProducto
from Inventory.InventoryProduct i
join Inventory.PhysicalInventory p on p.ProductId = i.id
join Inventory.ProductGroup pg on pg.id = i.ProductGroupId

