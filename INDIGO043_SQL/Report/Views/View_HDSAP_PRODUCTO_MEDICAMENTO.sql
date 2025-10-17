-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRODUCTO_MEDICAMENTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_PRODUCTO_MEDICAMENTO]
AS


select distinct
       p.Code CodigoProducto,
       p.name NombreProducto,
	   a.Code CodigoMedicamento,
	   a.Name NombreMedicamento,
	   case p.Status
	   when 1
	   then 'Activo'
	   when 0
	   then 'Inactivo'
	   end Estado


from Inventory.InventoryProduct p
join Inventory.ATC a on a.id = p.ATCId

