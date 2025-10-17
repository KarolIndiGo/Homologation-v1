-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_FacturacionBasica
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[Billing_FacturacionBasica] as
SELECT 
    -- ① Fallback también a la fecha del documento básico
    COALESCE(I.InvoiceDate, DP.ConfirmationDate, B.DocumentDate) AS FechaFactura,
    -- ② Fallback también al código del documento básico
    COALESCE(I.InvoiceNumber, DP.Code, B.Code)                   AS NumeroFactura,

    CU.Name                                      AS Cliente,
    B.[Description]                              AS [Descripción],
    P.Code                                       AS CodProducto,
    P.Name                                       AS Producto,
    BD.Price                                     AS ValorUnitario,
    BD.Quantity                                  AS Cantidad,
    BD.Value                                     AS ValorTotal,

    -- ③ Concepto: primero BillingConcept; si no hay, Item del activo; si tampoco, el Producto
    CASE 
        WHEN NULLIF(LTRIM(RTRIM(CONC.Code)), '') IS NOT NULL THEN CONC.Code
        WHEN NULLIF(LTRIM(RTRIM(FAI.Code)), '')  IS NOT NULL THEN FAI.Code
        WHEN NULLIF(LTRIM(RTRIM(P.Code)), '')    IS NOT NULL THEN P.Code
        ELSE NULL
    END                                           AS [codigo concepto],
    CASE 
        WHEN NULLIF(LTRIM(RTRIM(CONC.Name)), '') IS NOT NULL THEN CONC.Name
        WHEN NULLIF(LTRIM(RTRIM(FAI.[Description])), '') IS NOT NULL THEN FAI.[Description]
        WHEN NULLIF(LTRIM(RTRIM(P.Name)), '')    IS NOT NULL THEN P.Name
        ELSE NULL
    END                                           AS [descripcion concepto],

    COALESCE(I.TotalValue, (B.Value + B.ValueIVA)) AS [valor factura]
FROM Billing.BasicBilling AS B WITH (NOLOCK)
INNER JOIN Billing.BasicBillingDetail AS BD WITH (NOLOCK)
        ON BD.BasicBillingId = B.Id
INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK)
        ON FU.Id = BD.FunctionalUnitId
INNER JOIN Common.Customer AS CU WITH (NOLOCK)
        ON CU.Id = B.CustomerId
LEFT  JOIN Billing.Invoice AS I WITH (NOLOCK)
        ON I.Id = B.InvoiceId
LEFT  JOIN Inventory.InventoryProduct AS P WITH (NOLOCK)
        ON P.Id = BD.ProductId
-- ✅ Join robusto: si no hay Invoice, usa el Id del documento básico
LEFT  JOIN Inventory.DocumentInvoiceProductSales AS DP WITH (NOLOCK)
        ON DP.InvoiceId = COALESCE(I.Id, B.Id)
LEFT  JOIN Billing.BillingConcept AS CONC WITH (NOLOCK)
        ON CONC.Id = BD.BillingConceptId
LEFT  JOIN FixedAsset.FixedAssetPhysicalAsset AS PA WITH (NOLOCK)
        ON PA.Id = BD.PhysicalAssetId
LEFT  JOIN FixedAsset.FixedAssetItem AS FAI WITH (NOLOCK)
        ON FAI.Id = PA.ItemId
-- WHERE I.InvoiceNumber = 'FCMN109'
;
