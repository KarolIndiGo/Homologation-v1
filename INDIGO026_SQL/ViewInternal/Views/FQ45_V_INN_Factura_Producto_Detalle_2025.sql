-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Factura_Producto_Detalle_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_Factura_Producto_Detalle_2025] AS

-- =========================
-- A) VENTA DE PRODUCTOS (detalle)
-- =========================
SELECT
    FAC.InvoiceNumber                                AS Factura,
    'Producto'                                       AS TipoFactura,
    DOC.Code                                         AS Documento,
    DOC.DocumentDate                                 AS [Fecha del Documento],
    CLI.Nit                                          AS [Nit del Cliente],
    CLI.Name                                         AS Cliente,
    SUC.Name                                         AS Sucursal,
    CIU.Name                                         AS Ciudad,
    DOC.Description                                  AS Descripcion,
    ALM.Code + ' - ' + ALM.Name                      AS [Centro de Costo],
    W.Name                                           AS Almacen,
    PRO.Code                                         AS [Codigo del Producto],
    PRO.Name                                         AS Producto,
    atc.Code                                         AS CodMedicamento,
    atc.Name                                         AS Medicamento,
    sg.Code + '-' + sg.Name                          AS [Subgrupo],
    CASE PRO.IVAId WHEN 1 THEN 'NO' WHEN 2 THEN 'SI' WHEN 3 THEN 'SI' END AS Iva,
    DETA.Quantity                                    AS Cantidad,
    DETA.SalePrice                                   AS [Valor Unitario],
    DOC.Value                                        AS Subtotal,
    DOC.ValueTax                                     AS [IVA FACTURA],
    DOC.Value + DOC.ValueTax                         AS [Total sin Retenciones],
    FAC.TotalInvoice                                 AS [Valor Facturado],
    PER1.NOMUSUARI                                   AS [User Creacion],     -- CreationUser
    PER.NOMUSUARI                                    AS [User Confirmacion], -- ConfirmationUser
    pg.Name                                          AS Grupo,
    costo.AverageCost                                AS CostoProducto,
    (DETA.Quantity * DETA.SalePrice)                 AS VentaTotal,
    (costo.AverageCost * DETA.Quantity)              AS CostoProductoTotal,
    PRO.FinalProductCost                             AS UltimoCosto,
    (DETA.Quantity * DETA.SalePrice) - (costo.AverageCost * DETA.Quantity) AS VrMargen,
    (
      ((DETA.Quantity * DETA.SalePrice) - (costo.AverageCost * DETA.Quantity))
      / NULLIF(DETA.Quantity * DETA.SalePrice, 0)
    )                                                AS [%Margen],
    CASE WHEN FAC.Status = 1 THEN 'Facturado'
         WHEN FAC.Status = 2 THEN 'Anulado' END      AS EstadoFactura,
    PER.CODUSUARI,                                   -- código ConfirmationUser
    DOC.CreationUser
FROM Billing.Invoice AS FAC
INNER JOIN Inventory.DocumentInvoiceProductSales AS DOC
        ON FAC.Id = DOC.InvoiceId
INNER JOIN Common.Customer AS CLI
        ON CLI.ThirdPartyId = FAC.ThirdPartyId
LEFT  JOIN Payroll.BranchOffice AS SUC
        ON DOC.BranchOfficeId = SUC.Id
LEFT  JOIN Common.City AS CIU
        ON SUC.CityId = CIU.Id
INNER JOIN Payroll.FunctionalUnit AS ALM
        ON DOC.FunctionalUnitId = ALM.Id
INNER JOIN Inventory.DocumentInvoiceProductSalesDetail AS DETA
        ON DETA.DocumentInvoiceProductSalesId = DOC.Id
INNER JOIN Inventory.InventoryProduct AS PRO
        ON DETA.ProductId = PRO.Id
LEFT  JOIN dbo.SEGusuaru AS PER1
        ON DOC.CreationUser = PER1.CODUSUARI
LEFT  JOIN dbo.SEGusuaru AS PER
        ON DOC.ConfirmationUser = PER.CODUSUARI
LEFT  JOIN Inventory.ATC             AS atc ON atc.Id = PRO.ATCId
LEFT  JOIN Inventory.ProductSubGroup AS sg  ON sg.Id  = PRO.ProductSubGroupId
LEFT  JOIN Inventory.ProductGroup    AS pg  ON pg.Id  = PRO.ProductGroupId
LEFT  JOIN Inventory.Warehouse       AS W   ON W.Id   = DOC.WarehouseId
LEFT  JOIN (
    SELECT ProductId, AverageCost, EntityCode
    FROM Inventory.Kardex
    WHERE EntityName = 'DocumentInvoiceProductSales'
) AS costo
    ON  costo.EntityCode = DOC.Code
    AND costo.ProductId  = PRO.Id
WHERE FAC.DocumentType = 7
  AND DOC.DocumentDate >= '2025-01-01'
  AND DOC.DocumentDate <  '2026-01-01'

UNION ALL

-- =========================
-- B) LIQUIDACIÓN (cabecera de factura asistencial)
-- =========================
SELECT
    FAC.InvoiceNumber                               AS Factura,
    'Liquidación'                                   AS TipoFactura,
    NULL                                            AS Documento,
    FAC.InvoiceDate                                 AS [Fecha del Documento],
    CLI.Nit                                         AS [Nit del Cliente],
    CLI.Name                                        AS Cliente,
    NULL                                            AS Sucursal,
    NULL                                            AS Ciudad,
    FAC.Observation                                 AS Descripcion,
    NULL                                            AS [Centro de Costo],
    NULL                                            AS Almacen,
    NULL                                            AS [Codigo del Producto],
    NULL                                            AS Producto,
    NULL                                            AS CodMedicamento,
    NULL                                            AS Medicamento,
    NULL                                            AS [Subgrupo],
    CASE WHEN FAC.ValueTax > 0 THEN 'SI' ELSE 'NO' END AS Iva,
    NULL                                            AS Cantidad,
    NULL                                            AS [Valor Unitario],
    FAC.InvoiceValue                                AS Subtotal,
    FAC.ValueTax                                    AS [IVA FACTURA],
    FAC.InvoiceValue + FAC.ValueTax                 AS [Total sin Retenciones],
    FAC.TotalInvoice                                AS [Valor Facturado],
    PER_INV.NOMUSUARI                               AS [User Creacion],      -- InvoicedUser
    NULL                                            AS [User Confirmacion],
    NULL                                            AS Grupo,
    NULL                                            AS CostoProducto,
    NULL                                            AS VentaTotal,
    NULL                                            AS CostoProductoTotal,
    NULL                                            AS UltimoCosto,
    NULL                                            AS VrMargen,
    NULL                                            AS [%Margen],
    CASE WHEN FAC.Status = 1 THEN 'Facturado'
         WHEN FAC.Status = 2 THEN 'Anulado' END     AS EstadoFactura,
    PER_INV.CODUSUARI,                              -- código InvoicedUser
    FAC.InvoicedUser
FROM Billing.Invoice AS FAC
LEFT JOIN Common.Customer AS CLI
       ON CLI.ThirdPartyId = FAC.ThirdPartyId
LEFT JOIN dbo.SEGusuaru AS PER_INV
       ON FAC.InvoicedUser = PER_INV.CODUSUARI
WHERE FAC.DocumentType IN (1,2,3)   -- Ajusta si quieres incluir otros tipos
  AND FAC.InvoiceDate >= '2025-01-01'
  AND FAC.InvoiceDate <  '2026-01-01'

UNION ALL

-- =========================
-- C) FACTURACIÓN BÁSICA (cabecera)
-- =========================
SELECT
    FAC.InvoiceNumber                              AS Factura,              -- puede ser NULL si aún no tiene InvoiceId
    'Básica'                                       AS TipoFactura,
    BB.Code                                        AS Documento,
    BB.DocumentDate                                AS [Fecha del Documento],
    CLI_BB.Nit                                     AS [Nit del Cliente],
    CLI_BB.Name                                    AS Cliente,
    NULL                                           AS Sucursal,
    NULL                                           AS Ciudad,
    BB.Description                                 AS Descripcion,
    FU.Code + ' - ' + FU.Name                      AS [Centro de Costo],
    W.Name                                         AS Almacen,
    NULL                                           AS [Codigo del Producto],
    NULL                                           AS Producto,
    NULL                                           AS CodMedicamento,
    NULL                                           AS Medicamento,
    NULL                                           AS [Subgrupo],
    CASE WHEN BB.ValueIVA > 0 THEN 'SI' ELSE 'NO' END AS Iva,
    NULL                                           AS Cantidad,
    NULL                                           AS [Valor Unitario],
    BB.Value                                       AS Subtotal,
    BB.ValueIVA                                    AS [IVA FACTURA],
    (BB.Value - BB.ValueDiscount + BB.ValueIVA)    AS [Total sin Retenciones],
    COALESCE(FAC.TotalInvoice, BB.TotalValue)      AS [Valor Facturado],
    PER_CRE.NOMUSUARI                              AS [User Creacion],
    PER_CONF.NOMUSUARI                             AS [User Confirmacion],
    NULL                                           AS Grupo,
    NULL                                           AS CostoProducto,
    NULL                                           AS VentaTotal,
    NULL                                           AS CostoProductoTotal,
    NULL                                           AS UltimoCosto,
    NULL                                           AS VrMargen,
    NULL                                           AS [%Margen],
    CASE WHEN FAC.Status = 1 THEN 'Facturado'
         WHEN FAC.Status = 2 THEN 'Anulado'
         ELSE NULL END                             AS EstadoFactura,
    PER_CONF.CODUSUARI,                            -- código ConfirmationUser (si aplica)
    BB.CreationUser
FROM Billing.BasicBilling AS BB
LEFT JOIN Billing.Invoice AS FAC
       ON FAC.Id = BB.InvoiceId
LEFT JOIN Common.Customer AS CLI_BB
       ON CLI_BB.Id = BB.CustomerId
LEFT JOIN Payroll.FunctionalUnit AS FU
       ON FU.Id = BB.FunctionalUnitId
LEFT JOIN Inventory.Warehouse AS W
       ON W.Id = BB.WarehouseId
LEFT JOIN dbo.SEGusuaru AS PER_CRE
       ON BB.CreationUser = PER_CRE.CODUSUARI
LEFT JOIN dbo.SEGusuaru AS PER_CONF
       ON BB.ConfirmationUser = PER_CONF.CODUSUARI
WHERE BB.DocumentDate >= '2025-01-01'
  AND BB.DocumentDate <  '2026-01-01';
