-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_DISPENSACIONES
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_DISPENSACIONES] 
AS
 select pd.ServiceDate FechaDispensacion,
        p.AdmissionNumber NumeroIngreso,
        i.code CodigoProducto,
		i.name NombreProducto,
		f.Name UnidadFuncional,
		pd.Quantity CantidadDispensada,
		pd.ReturnedQuantity CantidadDevuelta

		 
 from Inventory.PharmaceuticalDispensing p
 join Inventory.PharmaceuticalDispensingDetail pd on pd.PharmaceuticalDispensingId = p.id
 JOIN Payroll.FunctionalUnit f on f.id = pd.FunctionalUnitId
 join Inventory.InventoryProduct i on i.id = pd.ProductId
 join Common.ThirdParty t on t.id = pd.ThirdPartyId



