-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_ComprobanteEntrada_2021
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*SELECT pr.Code AS Nit,
       pr.Name AS Proveedor,
       cce.Code AS Comprobante,
       CASE cce.OperatingUnitId 
	   WHEN '4' THEN 'TUNJA'
	   WHEN '8' THEN 'NEIVA'
	   WHEN '9' THEN 'FLORENCIA'
	   WHEN '10' THEN 'CALI'
	   WHEN '13' THEN 'FACATATIVA'
	   WHEN '3' THEN 'BOGOTA' END AS Sede,
       cce.DocumentDate AS Fecha,
       DATEPART (month, cce.DocumentDate) AS Mes,
       al.Code AS CodAlmacen,
       al.Name AS Almacen,
       cce.Description AS Observaciones,
       cce.IcaPercentage AS PorcICA,
       cce.WithholdingICA AS [Retencion Ica],
       cce.InvoiceNumber AS Factura,
       cce.InvoiceDate AS FechaFactura,
       CASE cce.Status
          WHEN '1' THEN 'Registrado'
          WHEN '2' THEN 'Confirmado'
          WHEN '3' THEN 'Anulado'
       END AS Estado,
       p.Code AS CodigoProducto,
       p.Name AS Producto,
       ATC.Code AS CodigoATC,
       GF.Name AS GrupoFarmacológico,
       p.CodeCUM AS [Código CUM],
       p.CodeAlternative AS [Código alterno],
       p.CodeAlternativeTwo AS [Código alterno 2],
       sg.Code AS [Código Subgrupo],
       sg.Name AS [Nombre subgrupo],
       CASE dce.EntranceSource
          WHEN '1' THEN 'Ninguna'
          WHEN '2' THEN 'OrdenCompra'
          WHEN '3' THEN 'ContratoFijo'
          WHEN '4' THEN 'Remision'
       END AS Origen,
       dce.SourceCode AS DocumentoGeneraEntrada,
       dce.Quantity AS Cantidad,
       dce.UnitValue AS VrUnitario,
       dce.SubTotalValue AS SubTotal,
       p.ProductCost AS CostoProm,
       dce.IvaPercentage AS PorcIva,
       dce.IvaValue AS IVA,
       dce.DiscountPercentage AS PorcDescto,
       dce.DiscountValue AS Descuento,
       dce.TotalValue AS Total,
       cce.TotalValue AS TotalComprobante,
       dce.RTFPercentage AS PorcRetefuente,
       dce.RTFValue AS Retefuente,
       per.Fullname AS Usuario
FROM Inventory.EntranceVoucher AS cce 
     INNER JOIN Inventory.EntranceVoucherDetail AS dce 
        ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2'
     INNER JOIN Common.Supplier AS pr 
        ON pr.Id = cce.SupplierId
     INNER JOIN Security.[User] AS u 
        ON u.UserCode = cce.CreationUser
     INNER JOIN Security.Person AS per 
        ON per.Id = u.IdPerson
     INNER JOIN Inventory.Warehouse AS al 
        ON al.Id = cce.WarehouseId
     INNER JOIN Inventory.InventoryProduct AS p 
        ON p.Id = dce.ProductId
     LEFT OUTER JOIN Inventory.ATC AS ATC 
        ON ATC.Id = p.ATCId
     LEFT OUTER JOIN Inventory.PharmacologicalGroup AS GF
        ON GF.Id = ATC.PharmacologicalGroupId
     LEFT OUTER JOIN Inventory.ProductGroup AS gp
        ON gp.Id = p.ProductGroupId
     LEFT OUTER JOIN Inventory.ProductSubGroup AS sg
        ON sg.Id = p.ProductSubGroupId*/
CREATE VIEW [ViewInternal].[FQ45_V_INN_ComprobanteEntrada_2021]
AS
SELECT        pr.Code AS Nit, pr.Name AS Proveedor, cce.Code AS Comprobante, 
                         CASE cce.OperatingUnitId WHEN '4' THEN 'TUNJA' WHEN '8' THEN 'NEIVA' WHEN '9' THEN 'FLORENCIA' WHEN '10' THEN 'CALI' WHEN '13' THEN 'FACATATIVA' WHEN '3' THEN 'BOGOTA' END AS Sede, 
                         cce.DocumentDate AS Fecha, DATEPART(month, cce.DocumentDate) AS Mes, al.Code AS CodAlmacen, al.Name AS Almacen, cce.Description AS Observaciones, cce.IcaPercentage AS PorcICA, 
                         cce.WithholdingICA AS [Retencion Ica], cce.InvoiceNumber AS Factura, cce.InvoiceDate AS FechaFactura, CASE cce.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, 
                         p.Code AS CodigoProducto, p.Name AS Producto, ATC.Code AS CodigoATC, GF.Name AS GrupoFarmacológico, p.CodeCUM AS [Código CUM], p.CodeAlternative AS [Código alterno], p.CodeAlternativeTwo AS [Código alterno 2], 
                         sg.Code AS [Código Subgrupo], sg.Name AS [Nombre subgrupo], CASE dce.EntranceSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'ContratoFijo' WHEN '4' THEN 'Remision' END AS Origen, 
                         dce.SourceCode AS DocumentoGeneraEntrada, dce.Quantity AS Cantidad, dce.UnitValue AS VrUnitario, dce.SubTotalValue AS SubTotal, p.ProductCost AS CostoProm, dce.IvaPercentage AS PorcIva, dce.IvaValue AS IVA, 
                         dce.DiscountPercentage AS PorcDescto, dce.DiscountValue AS Descuento, dce.TotalValue AS Total, cce.TotalValue AS TotalComprobante, dce.RTFPercentage AS PorcRetefuente, dce.RTFValue AS Retefuente, 
                         tpr.Name AS [Tipo producto], CASE p.ProductWithPriceControl WHEN '0' THEN 'No Regulado' WHEN '1' THEN 'Regulado' END AS [Maneja control precios], DEV.Code AS Devolucion, DEV.TotalValue AS ValorDevolucion, 
                         CASE WHEN dev.TotalValue IS NULL THEN dce.TotalValue ELSE dce.TotalValue - dev.TotalValue END AS TotalFinal
FROM            Inventory.EntranceVoucher AS cce INNER JOIN
                         Inventory.EntranceVoucherDetail AS dce ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2' INNER JOIN
                         Common.Supplier AS pr ON pr.Id = cce.SupplierId INNER JOIN
                         Inventory.Warehouse AS al ON al.Id = cce.WarehouseId INNER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dce.ProductId LEFT OUTER JOIN
                         Inventory.ATC AS ATC ON ATC.Id = p.ATCId LEFT OUTER JOIN
                         Inventory.PharmacologicalGroup AS GF ON GF.Id = ATC.PharmacologicalGroupId LEFT OUTER JOIN
                         Inventory.ProductGroup AS gp ON gp.Id = p.ProductGroupId LEFT OUTER JOIN
                         Inventory.ProductSubGroup AS sg ON sg.Id = p.ProductSubGroupId LEFT OUTER JOIN
                         Inventory.ProductType AS tpr ON tpr.Id = p.ProductTypeId LEFT OUTER JOIN
                             (SELECT        p.Code AS CODPRO, p.Name AS PRO, MAX(e.Code) AS Code, SUM(ed.TotalValue) AS TotalValue
                               FROM            Inventory.EntranceVoucher AS e INNER JOIN
                                                         Inventory.EntranceVoucherDetail AS ed ON ed.EntranceVoucherId = e.Id INNER JOIN
                                                         Inventory.EntranceVoucherDetailBatchSerial AS db ON db.EntranceVoucherDetailId = ed.Id LEFT OUTER JOIN
                                                         Inventory.EntranceVoucherDevolutionDetail AS edd ON edd.EntranceVoucherDetailBatchSerialId = db.Id LEFT OUTER JOIN
                                                         Inventory.EntranceVoucherDevolution AS de ON de.Id = edd.EntranceVoucherDevolutionId LEFT OUTER JOIN
                                                         Inventory.InventoryProduct AS p ON p.Id = ed.ProductId
                               WHERE        (edd.Quantity > 0)
                               GROUP BY p.Code, p.Name) AS DEV ON DEV.CODPRO = p.Code AND DEV.Code = cce.Code
WHERE        (cce.Status = '2') AND (cce.InvoiceDate >= '2021-12-01 23:59:59')
