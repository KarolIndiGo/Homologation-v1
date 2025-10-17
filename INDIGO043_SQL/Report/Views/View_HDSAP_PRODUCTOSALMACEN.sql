-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRODUCTOSALMACEN
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_PRODUCTOSALMACEN]
   
AS

select p.code CodProducto,
	   p.name DescripcionProducto,
	   p.FinalProductCost Costo,
	   p.LastPurchase UltimaCompra,
	   ISNULL(iva.Name, 'Sin Iva')IVA,
	   p.IUM IdentificadorUnico



from Inventory.InventoryProduct p 
join Inventory.ProductGroup pg on pg.id = p.ProductGroupId
left join GeneralLedger.GeneralLedgerIVA iva on iva.id = p.IVAId
left join Inventory.InventoryMeasurementUnit me on me.Id = p.MeasurementUnitId
where pg.code = 141 
