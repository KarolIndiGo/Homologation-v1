-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ORDENCOMPRAVSCOMPROBANTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_ORDENCOMPRAVSCOMPROBANTE]
AS


select 
       pc.code OrdenCompra,
       e.code NumComprobante,
	   p.code CodProducto,
	   p.name NombreProducto,
	   e.Description Observacion,
	   case e.status
	   when 1
	   then 'Registrado'
	   when 2
	   then 'Confirmado'
	   when 3
	   then 'Anulado'
	   end Estado,
	   e.DocumentDate FechaDocumento,
	   FORMAT(ev.UnitValue, 'C', 'es-CO') ValorUnitario,
	   ev.Quantity Cantidad,
	   pg.code CodGrupo,
	   pg.name Grupo,
	   FORMAT(ev.UnitValue * ev.Quantity + ev.IvaValue, 'C', 'es-CO') Total,
	   ev.IvaPercentage PorcentajeIva,
	   FORMAT(ev.IvaValue, 'C', 'es-CO') ValorIva 




from Inventory.EntranceVoucher e
join Inventory.EntranceVoucherDetail ev on ev.EntranceVoucherId = e.id
left join Inventory.PurchaseOrderDetail pd on pd.id = ev.PurchaseOrderDetailId
left join Inventory.PurchaseOrder pc on pc.id = pd.PurchaseOrderId
join Inventory.InventoryProduct p on p.id = ev.ProductId
join Inventory.ProductGroup pg on pg.id = p.ProductGroupId

