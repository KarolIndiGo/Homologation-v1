-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRODUCTOSCOMPRADOSPORMES
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_PRODUCTOSCOMPRADOSPORMES]
AS
     SELECT ev.Code AS NumeroComprobanteEntrada, 
            pro.Code AS Codigo, 
            pro.Name AS NombreProducto, 
            PT.Name AS TipoProducto, 
			PG.Code CodProd,
			pg.Name NomProd,
            evd.Quantity AS Cantidad, 
			evd.UnitValue ValorUnitario,
			evd.TotalValue as ValorTotal,
            SU.Code AS Nit, 
            SU.Name AS NombreProveedor, 
            evd.SourceCode AS NumeroOrdenCompra, 
            ev.DocumentDate AS Fecha, 
            MONTH(ev.DocumentDate) Mes, 
            YEAR(ev.DocumentDate) AS Año,
			ev.Description Detalle
     FROM Inventory.EntranceVoucher AS ev
          INNER JOIN Inventory.EntranceVoucherDetail AS evd ON ev.Id = evd.EntranceVoucherId
          INNER JOIN Inventory.InventoryProduct AS pro ON evd.ProductId = pro.Id
          INNER JOIN Common.Supplier AS SU ON ev.SupplierId = SU.Id
          INNER JOIN Inventory.ProductType AS PT ON pro.ProductTypeId = PT.Id
		  INNER JOIN Inventory.ProductGroup PG ON PG.ID = PRO.ProductGroupId


