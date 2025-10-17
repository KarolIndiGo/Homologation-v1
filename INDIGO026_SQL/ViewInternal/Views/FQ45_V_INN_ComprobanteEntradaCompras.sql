-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_ComprobanteEntradaCompras
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[FQ45_V_INN_ComprobanteEntradaCompras]
AS
SELECT     pr.Code AS Nit, pr.Name AS Proveedor, 
cast(cce.DocumentDate as datetime) AS Fecha,
--cce.DocumentDate AS Fecha, 
                         al.Code AS CodAlmacen, al.Name AS Almacen, cce.Description AS Observaciones, cce.InvoiceNumber AS Factura, 
						 cast(cce.InvoiceDate as datetime) AS FechaFactura,
						 --cce.InvoiceDate AS FechaFactura, 
                         p.Code AS CodigoProducto, p.Name AS Producto, 
                         p.CodeCUM AS [Código CUM], p.CodeAlternative AS [Código alterno], atc.code AS [Código Medicamento],
						 atc.name as [Medicamento], sg.code+'-'+sg.name as [Subgrupo],
                         dce.SourceCode AS DocumentoGeneraEntrada, 
                         dce.Quantity AS Cantidad, dce.UnitValue AS VrUnitario, dce.SubTotalValue AS SubTotal, p.ProductCost AS CostoProm,
                         dce.TotalValue AS Total, per.Fullname AS Usuario
FROM            Inventory.EntranceVoucher AS cce  INNER JOIN
                        Inventory.EntranceVoucherDetail AS dce  ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2' INNER JOIN
                         Common.Supplier AS pr  ON pr.Id = cce.SupplierId INNER JOIN
                         Security.[User] AS u  ON u.UserCode = cce.CreationUser INNER JOIN
                         Security.Person AS per  ON per.Id = u.IdPerson INNER JOIN
                         Inventory.Warehouse AS al  ON al.Id = cce.WarehouseId INNER JOIN
                         Inventory.InventoryProduct AS p  ON p.Id = dce.ProductId LEFT OUTER JOIN
                         Inventory.ATC AS ATC  ON ATC.Id = p.ATCId LEFT OUTER JOIN
                         Inventory.PharmacologicalGroup AS GF ON GF.Id = ATC.PharmacologicalGroupId LEFT OUTER JOIN
                         Inventory.ProductGroup AS gp ON gp.Id = p.ProductGroupId LEFT OUTER JOIN
                         Inventory.ProductSubGroup AS sg ON sg.Id = p.ProductSubGroupId
WHERE        (cce.Status = '2') AND (cce.InvoiceDate >= '20180101')
UNION ALL (
SELECT     pr.Code AS Nit, pr.Name AS Proveedor, 
cast(cce.DocumentDate as datetime) AS Fecha,
--cce.DocumentDate AS Fecha, 
                         al.Code AS CodAlmacen, al.Name AS Almacen, cce.Description AS Observaciones, cce.InvoiceNumber AS Factura, 
						 cast(cce.InvoiceDate as datetime) AS FechaFactura,
						 --cce.InvoiceDate AS FechaFactura, 
                         p.Code AS CodigoProducto, p.Name AS Producto, 
                         p.CodeCUM AS [Código CUM], p.CodeAlternative AS [Código alterno], atc.code AS [Código Medicamento],
						 atc.name as [Medicamento], sg.code+'-'+sg.name as [Subgrupo],
                         dce.SourceCode AS DocumentoGeneraEntrada, 
                         dce.Quantity AS Cantidad, dce.UnitValue AS VrUnitario, dce.SubTotalValue AS SubTotal, p.ProductCost AS CostoProm,
                         dce.TotalValue AS Total, per.Fullname AS Usuario
FROM            Inventory.EntranceVoucher AS cce  INNER JOIN
                        Inventory.EntranceVoucherDetail AS dce  ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2' INNER JOIN
                         Common.Supplier AS pr  ON pr.Id = cce.SupplierId INNER JOIN
                         Security.[User] AS u  ON u.UserCode = cce.CreationUser INNER JOIN
                         Security.Person AS per  ON per.Id = u.IdPerson INNER JOIN
                         Inventory.Warehouse AS al  ON al.Id = cce.WarehouseId INNER JOIN
                         Inventory.InventoryProduct AS p  ON p.Id = dce.ProductId LEFT OUTER JOIN
                         Inventory.ATC AS ATC  ON ATC.Id = p.ATCId LEFT OUTER JOIN
                         Inventory.PharmacologicalGroup AS GF ON GF.Id = ATC.PharmacologicalGroupId LEFT OUTER JOIN
                         Inventory.ProductGroup AS gp ON gp.Id = p.ProductGroupId LEFT OUTER JOIN
                         Inventory.ProductSubGroup AS sg ON sg.Id = p.ProductSubGroupId
WHERE        (cce.Status = '2') AND (cce.InvoiceDate >= '20190101')
)
