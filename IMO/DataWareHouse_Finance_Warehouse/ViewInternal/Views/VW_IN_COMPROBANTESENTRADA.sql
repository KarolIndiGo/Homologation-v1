-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IN_COMPROBANTESENTRADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IN_ComprobantesEntrada]
AS

SELECT 
    pr.Code AS Nit,
    pr.Name AS Proveedor,
    tp.Code + ' - ' + tp.Name AS [Tipo Proveedor],
    l.Code + ' - ' + l.Name AS [Línea Distribución],
    cce.Code AS Comprobante,
    up.UnitName AS Sede,
    CAST(cce.DocumentDate AS DATETIME) AS Fecha,
    DATEPART(MONTH, cce.DocumentDate) AS Mes,
    al.Code AS CodAlmacen,
    al.Name AS Almacen,
    cce.Description AS Observaciones,
    cce.IcaPercentage AS PorcICA,
    cce.InvoiceNumber AS Factura,
    cce.InvoiceDate AS FechaFactura,
    CASE cce.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado,
    p.Code AS CodigoProducto,
    p.Name AS Producto,
    ATC.Code AS CodigoMedicamento,
    ATC.Name AS Medicamento,
    sp.Code AS CodInsumo,
    sp.SupplieName AS Insumo,
    GF.Name AS GrupoFarmacológico,
    p.CodeCUM AS [Código CUM],
    p.CodeAlternative AS [Código alterno],
    p.CodeAlternativeTwo AS [Código alterno 2],
    gp.Code AS [Código Grupo],
    gp.Name AS [Nombre Grupo],
    sg.Code AS [Código Subgrupo],
    sg.Name AS [Nombre subgrupo],
    CASE dce.EntranceSource
        WHEN '1' THEN 'Ninguna' 
        WHEN '2' THEN 'OrdenCompra' 
        WHEN '3' THEN 'ContratoFijo' 
        WHEN '4' THEN 'Remision' 
        WHEN '5' THEN 'Remision de inventario en consignación'
    END AS Origen,
    dce.SourceCode AS DocumentoGeneraEntrada,
    CASE dce.EntranceSource WHEN 2 THEN po.DocumentDate WHEN 4 THEN re.RemissionDate END AS FechaDocumento,
    dce.Quantity AS Cantidad,
    dce.UnitValue AS VrUnitario,
    dce.SubTotalValue AS SubTotal,
    dce.IvaPercentage AS PorcIva,
    dce.IvaValue AS IVA,
    dce.DiscountPercentage AS PorcDescto,
    dce.DiscountValue AS Descuento,
    dce.TotalValue AS Total,
    cce.TotalValue AS TotalComprobante,
    dce.RTFPercentage AS PorcRetefuente,
    dce.RTFValue AS Retefuente,
    per.Fullname AS Usuario,
    cce.WithholdingTax AS ReteIva,
    tpr.Name AS [Tipo producto],
    CASE p.ProductWithPriceControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Maneja control precios],
    DEV.Code AS Devolucion,
    DEV.TotalValue AS ValorDevolucion,
    CASE WHEN DEV.TotalValue IS NULL THEN dce.TotalValue ELSE dce.TotalValue - DEV.TotalValue END AS TotalFinal,
    pg.Code AS CuentaXPagar,
    bh.BatchCode AS Lote,
    bh.ExpirationDate AS FechaVencimiento,
    CASE dce.EntranceSource
        WHEN 1 THEN 'Ninguna'
        WHEN 2 THEN 'Orden de compra'
        WHEN 3 THEN 'Contrato (Fijo)'
        WHEN 4 THEN 'Remision de entrada'
        WHEN 5 THEN 'Remision de inventario en consignación'
    END AS Ingreso,
    SourceCode AS CodigoIngreso
FROM [INDIGO035].[Inventory].[EntranceVoucher] AS cce
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS up
    ON up.Id = cce.OperatingUnitId
INNER JOIN [INDIGO035].[Inventory].[EntranceVoucherDetail] AS dce
    ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2'
INNER JOIN [INDIGO035].[Common].[Supplier] AS pr
    ON pr.Id = cce.SupplierId
INNER JOIN [INDIGO035].[Common].[SuppliersDistributionLines] AS dl
    ON dl.IdSupplier = pr.Id AND dl.Id = cce.SupplierDistributionLineId
INNER JOIN [INDIGO035].[Common].[DistributionLines] AS l
    ON l.Id = dl.IdDistributionLine
LEFT OUTER JOIN [INDIGO035].[Common].[SupplierType] AS tp
    ON tp.Id = cce.SupplierTypeId
LEFT OUTER JOIN [INDIGO035].[Security].[UserInt] AS u
    ON u.UserCode = cce.CreationUser
INNER JOIN [INDIGO035].[Security].[PersonInt] AS per
    ON per.Id = u.IdPerson
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS al
    ON al.Id = cce.WarehouseId
INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS p
    ON p.Id = dce.ProductId
LEFT OUTER JOIN [INDIGO035].[Inventory].[ATC] AS ATC
    ON ATC.Id = p.ATCId
LEFT OUTER JOIN [INDIGO035].[Inventory].[PharmacologicalGroup] AS GF
    ON GF.Id = ATC.PharmacologicalGroupId
LEFT OUTER JOIN [INDIGO035].[Inventory].[ProductGroup] AS gp
    ON gp.Id = p.ProductGroupId
LEFT OUTER JOIN [INDIGO035].[Inventory].[ProductSubGroup] AS sg
    ON sg.Id = p.ProductSubGroupId
LEFT OUTER JOIN [INDIGO035].[Inventory].[RemissionEntrance] AS re
    ON re.Code = dce.SourceCode
LEFT OUTER JOIN [INDIGO035].[Inventory].[PurchaseOrder] AS po
    ON po.Code = dce.SourceCode
LEFT OUTER JOIN [INDIGO035].[Inventory].[InventorySupplie] AS sp
    ON sp.Id = p.SupplieId
LEFT OUTER JOIN [INDIGO035].[Inventory].[ProductType] AS tpr
    ON tpr.Id = p.ProductTypeId
LEFT OUTER JOIN (
    SELECT 
        p.Code AS CODPRO,
        p.Name AS PRO,
        MAX(e.Code) AS Code,
        SUM(ed.TotalValue) AS TotalValue
    FROM [INDIGO035].[Inventory].[EntranceVoucher] AS e
    INNER JOIN [INDIGO035].[Inventory].[EntranceVoucherDetail] AS ed
        ON ed.EntranceVoucherId = e.Id
    INNER JOIN [INDIGO035].[Inventory].[EntranceVoucherDetailBatchSerial] AS db
        ON db.EntranceVoucherDetailId = ed.Id
    LEFT OUTER JOIN [INDIGO035].[Inventory].[EntranceVoucherDevolutionDetail] AS edd
        ON edd.EntranceVoucherDetailBatchSerialId = db.Id
    LEFT OUTER JOIN [INDIGO035].[Inventory].[EntranceVoucherDevolution] AS de
        ON de.Id = edd.EntranceVoucherDevolutionId
    LEFT OUTER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS p
        ON p.Id = ed.ProductId
    WHERE edd.Quantity > 0
    GROUP BY p.Code, p.Name
) AS DEV
    ON DEV.CODPRO = p.Code AND DEV.Code = cce.Code
LEFT OUTER JOIN [INDIGO035].[Inventory].[EntranceVoucherDetailBatchSerial] AS edbc
    ON edbc.EntranceVoucherDetailId = dce.Id AND edbc.Quantity = dce.Quantity
LEFT OUTER JOIN [INDIGO035].[Inventory].[BatchSerial] AS bh
    ON bh.ProductId = p.Id AND bh.Id = edbc.BatchSerialId AND Type = 1
LEFT JOIN [INDIGO035].[Payments].[AccountPayable] AS pg
    ON pg.EntityId = cce.Id AND pg.EntityName = 'EntranceVoucher'
WHERE cce.Status = '2'
  AND cce.DocumentDate >= '01-01-2020';