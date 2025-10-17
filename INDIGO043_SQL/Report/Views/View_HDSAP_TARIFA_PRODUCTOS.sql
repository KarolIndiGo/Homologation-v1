-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TARIFA_PRODUCTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_TARIFA_PRODUCTOS]
AS


select pro.code CodigoProducto,
       pro.name NombreProducto,
	   pr.SalesValue Valor,
	   pr.SalesValueWithSurcharge ValorConRecargo,
	   p.Name NombreTarifa,
	   pr.InitialDate FechaInicial,
	   pr.EndDate FechaFinal,
	   p.ModificationDate FechaModificacion



from Inventory.ProductRate p
join Inventory.ProductRateDetail pr on pr.ProductRateId = p.id
join Inventory.InventoryProduct pro on pro.id = pr.ProductId
  

