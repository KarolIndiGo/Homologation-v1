-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_COMPROBANTEENTRADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_COMPROBANTEENTRADA AS

SELECT 
    pr.Code AS Nit,
    pr.Name AS Proveedor,
    cce.Code AS Comprobante,
    UO.UnitName AS Sede,
    cce.DocumentDate AS Fecha,
    DATEPART(month, cce.DocumentDate) AS Mes,
    al.Code AS CodAlmacen,
    al.Name AS Almacen,
    cce.Description AS Observaciones,
    cce.IcaPercentage AS PorcICA,
    cce.InvoiceNumber AS Factura,
    cce.InvoiceDate AS FechaFactura,
    CASE cce.Status
        WHEN '1' THEN 'Registrado'
        WHEN '2' THEN 'Confirmado'
        WHEN '3' THEN 'Anulado'
    END AS Estado,
    p.Code AS CodigoProducto,
    p.Name AS Producto,
    tpr.Name AS [Tipo Producto],
    ATC.Code AS CodMedicamento,
    ATC.Name AS Medicamento,
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
    CAST(dce.UnitValue AS DECIMAL(19, 4)) AS VrUnitario,
    CAST(dce.SubTotalValue AS DECIMAL(19, 4)) AS SubTotal,
    CAST(p.ProductCost AS DECIMAL(19, 4)) AS CostoProm,
    dce.IvaPercentage AS PorcIva,
    dce.IvaValue AS IVA,
    dce.DiscountPercentage AS PorcDescto,
    dce.DiscountValue AS Descuento,
    CAST(dce.TotalValue AS DECIMAL(19, 4)) AS Total,
    CAST(cce.TotalValue AS DECIMAL(19, 4)) AS TotalComprobante,
    dce.RTFPercentage AS PorcRetefuente,
    dce.RTFValue AS Retefuente,
    per.Fullname AS Usuario,
    ATC.AbbreviationName AS Abreviatura,
    CASE p.POSProduct
        WHEN 1 THEN 'POS'
        WHEN 0 THEN 'NO POS'
    END AS POS,
    CASE p.ProductWithPriceControl
        WHEN 1 THEN 'Regulado'
        WHEN 0 THEN 'Standard'
    END AS 'Precio Regulado',
    CASE ATC.HighCost
        WHEN 1 THEN 'Alto Costo'
        WHEN 0 THEN 'Standard'
    END AS AltoCosto
FROM 
    INDIGO031.Inventory.EntranceVoucher AS cce
    INNER JOIN INDIGO031.Inventory.EntranceVoucherDetail AS dce ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2'
    INNER JOIN INDIGO031.Common.Supplier AS pr ON pr.Id = cce.SupplierId
    INNER JOIN INDIGO031.Security.UserInt AS u ON u.UserCode = cce.CreationUser
    INNER JOIN INDIGO031.Security.PersonInt AS per ON per.Id = u.IdPerson
    INNER JOIN INDIGO031.Inventory.Warehouse AS al ON al.Id = cce.WarehouseId
    INNER JOIN INDIGO031.Inventory.InventoryProduct AS p ON p.Id = dce.ProductId
    LEFT OUTER JOIN INDIGO031.Inventory.ATC ON ATC.Id = p.ATCId
    LEFT OUTER JOIN INDIGO031.Inventory.PharmacologicalGroup AS GF ON GF.Id = ATC.PharmacologicalGroupId
    LEFT OUTER JOIN INDIGO031.Inventory.ProductGroup AS gp ON gp.Id = p.ProductGroupId
    LEFT OUTER JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = p.ProductSubGroupId
    JOIN INDIGO031.Common.OperatingUnit UO ON cce.OperatingUnitId = UO.Id
    JOIN INDIGO031.Inventory.ProductType tpr ON p.ProductTypeId = tpr.Id
WHERE 
    (cce.Status = '2')
    AND (cce.InvoiceDate >= '20200701');