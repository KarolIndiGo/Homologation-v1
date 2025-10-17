-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_V_INN_ComprobanteEntrada
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[MM_V_INN_ComprobanteEntrada]
AS
SELECT pr.Code AS Nit, pr.Name AS Proveedor, cce.Code AS Comprobante, CASE cce.OperatingUnitId WHEN '5' THEN 'BOGOTA' WHEN '7' THEN 'CALI' END AS Sede, cce.DocumentDate AS Fecha, DATEPART(month, cce.DocumentDate) AS Mes, al.Code AS CodAlmacen, 
             al.Name AS Almacen, cce.Description AS Observaciones, cce.IcaPercentage AS PorcICA, cce.InvoiceNumber AS Factura, cce.InvoiceDate AS FechaFactura, CASE cce.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, 
             p.Code AS CodigoProducto, p.Name AS Producto, ATC.Code AS CodMedicamento, ATC.Name AS Medicamento, GF.Name AS GrupoFarmacológico, p.CodeCUM AS [Código CUM], p.CodeAlternative AS [Código alterno], p.CodeAlternativeTwo AS [Código alterno 2], 
             sg.Code AS [Código Subgrupo], sg.Name AS [Nombre subgrupo], CASE dce.EntranceSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'ContratoFijo' WHEN '4' THEN 'Remision' END AS Origen, dce.SourceCode AS DocumentoGeneraEntrada, 
             dce.Quantity AS Cantidad, dce.UnitValue AS VrUnitario, dce.SubTotalValue AS SubTotal, p.ProductCost AS CostoProm, dce.IvaPercentage AS PorcIva, dce.IvaValue AS IVA, dce.DiscountPercentage AS PorcDescto, dce.DiscountValue AS Descuento, dce.TotalValue AS Total, 
             cce.TotalValue AS TotalComprobante, dce.RTFPercentage AS PorcRetefuente, dce.RTFValue AS Retefuente
FROM  Inventory.EntranceVoucher AS cce INNER JOIN
             INDIGO022.Inventory.EntranceVoucherDetail AS dce ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2' INNER JOIN
             INDIGO022.Common.Supplier AS pr ON pr.Id = cce.SupplierId INNER JOIN
             INDIGO022.Inventory.Warehouse AS al ON al.Id = cce.WarehouseId INNER JOIN
             INDIGO022.Inventory.InventoryProduct AS p ON p.Id = dce.ProductId LEFT OUTER JOIN
             INDIGO022.Inventory.ATC AS ATC ON ATC.Id = p.ATCId LEFT OUTER JOIN
             INDIGO022.Inventory.PharmacologicalGroup AS GF ON GF.Id = ATC.PharmacologicalGroupId LEFT OUTER JOIN
             INDIGO022.Inventory.ProductGroup AS gp ON gp.Id = p.ProductGroupId LEFT OUTER JOIN
             INDIGO022.Inventory.ProductSubGroup AS sg ON sg.Id = p.ProductSubGroupId
WHERE (cce.Status = '2') AND (cce.InvoiceDate >= '20210101')
