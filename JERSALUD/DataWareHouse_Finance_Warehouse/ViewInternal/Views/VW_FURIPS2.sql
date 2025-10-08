-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_FURIPS2
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_FURIPS2
AS
(
SELECT Radicado, NumeroFactura, Ingreso, Tipo, CodigoCUM, Descripcion, SUM(Cantidad) AS Cantidad, SUM(ValorUnitario) AS ValorUnitario, SUM(SubTotal) AS SubTotal, SUM(Total) AS Total
FROM
(
    SELECT 
        rc.RadicatedConsecutive AS Radicado,
        i.InvoiceNumber AS NumeroFactura,
        i.AdmissionNumber AS Ingreso,
        CASE ce.RIPSConcept WHEN 14 THEN 5 ELSE 2 END AS Tipo,
        CASE ce.RIPSConcept WHEN 14 THEN '' ELSE ips.Code END AS CodigoCUM,
        LEFT(ips.Name, 40) AS Descripcion,
        sod.InvoicedQuantity AS Cantidad,
        sod.SubTotalSalesPrice AS ValorUnitario,
        sod.InvoicedQuantity * sod.SubTotalSalesPrice AS SubTotal,
        sod.InvoicedQuantity * sod.SubTotalSalesPrice AS Total
    FROM INDIGO031.Portfolio.RadicateInvoiceC rc
    INNER JOIN INDIGO031.Portfolio.RadicateInvoiceD rd ON rc.Id = rd.RadicateInvoiceCId
    INNER JOIN INDIGO031.Portfolio.AccountReceivable ar ON ar.InvoiceNumber = rd.InvoiceNumber
    INNER JOIN INDIGO031.Billing.Invoice i ON i.Id = ar.InvoiceId
    --INNER JOIN INDIGO031.Billing.InvoiceDetail AS (Id) ON (Id).InvoiceId = i.Id
    --INNER JOIN INDIGO031.Billing.ServiceOrderDetail sod ON sod.Id = (Id).ServiceOrderDetailId
    INNER JOIN INDIGO031.Billing.InvoiceDetail AS Id ON Id.InvoiceId = i.Id
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail sod ON sod.Id = Id.ServiceOrderDetailId
    INNER JOIN INDIGO031.Contract.CUPSEntity ce ON ce.Id = sod.CUPSEntityId
    INNER JOIN INDIGO031.Contract.IPSService ips ON ips.Id = sod.IPSServiceId
    WHERE sod.Presentation IN (1,3) AND sod.SubTotalSalesPrice > 0

    UNION ALL

    SELECT 
        rc.RadicatedConsecutive AS Radicado,
        i.InvoiceNumber AS NumeroFactura,
        i.AdmissionNumber AS Ingreso,
        2 AS Tipo,
        ips.Code AS CodigoCUM,
        LEFT(ips.Name, 40) AS Descripcion,
        sod.InvoicedQuantity AS Cantidad,
        sods.TotalSalesPrice AS ValorUnitario,
        sod.InvoicedQuantity * sods.TotalSalesPrice AS SubTotal,
        sod.InvoicedQuantity * sods.TotalSalesPrice AS Total
    FROM INDIGO031.Portfolio.RadicateInvoiceC rc
    INNER JOIN INDIGO031.Portfolio.RadicateInvoiceD rd ON rc.Id = rd.RadicateInvoiceCId
    INNER JOIN INDIGO031.Portfolio.AccountReceivable ar ON ar.InvoiceNumber = rd.InvoiceNumber
    INNER JOIN INDIGO031.Billing.Invoice i ON i.Id = ar.InvoiceId
    --INNER JOIN INDIGO031.Billing.InvoiceDetail AS (Id) ON (Id).InvoiceId = i.Id
    --INNER JOIN INDIGO031.Billing.ServiceOrderDetail sod ON sod.Id = (Id).ServiceOrderDetailId
    INNER JOIN INDIGO031.Billing.InvoiceDetail AS Id ON Id.InvoiceId = i.Id
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail sod ON sod.Id = Id.ServiceOrderDetailId
    INNER JOIN INDIGO031.Billing.ServiceOrderDetailSurgical sods ON sods.ServiceOrderDetailId = sod.Id
    INNER JOIN INDIGO031.Contract.IPSService ips ON ips.Id = sods.IPSServiceId
    WHERE sod.Presentation = 2 AND sods.TotalSalesPrice > 0

    UNION ALL

    SELECT 
        rc.RadicatedConsecutive AS Radicado,
        i.InvoiceNumber AS NumeroFactura,
        i.AdmissionNumber AS Ingreso,
        CASE pt.Class WHEN 2 THEN 1 ELSE 5 END AS Tipo,
        CASE pt.Class WHEN 2 THEN ip.CodeCUM ELSE '' END AS CodigoCUM,
        LEFT(ip.Name, 40) AS Descripcion,
        sod.InvoicedQuantity AS Cantidad,
        sod.SubTotalSalesPrice AS ValorUnitario,
        sod.InvoicedQuantity * sod.SubTotalSalesPrice AS SubTotal,
        sod.InvoicedQuantity * sod.SubTotalSalesPrice AS Total
    FROM INDIGO031.Portfolio.RadicateInvoiceC rc
    INNER JOIN INDIGO031.Portfolio.RadicateInvoiceD rd ON rc.Id = rd.RadicateInvoiceCId
    INNER JOIN INDIGO031.Portfolio.AccountReceivable ar ON ar.InvoiceNumber = rd.InvoiceNumber
    INNER JOIN INDIGO031.Billing.Invoice i ON i.Id = ar.InvoiceId
    --INNER JOIN INDIGO031.Billing.InvoiceDetail AS (Id) ON (Id).InvoiceId = i.Id
    --INNER JOIN INDIGO031.Billing.ServiceOrderDetail sod ON sod.Id = (Id).ServiceOrderDetailId
    INNER JOIN INDIGO031.Billing.InvoiceDetail AS Id ON Id.InvoiceId = i.Id
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail sod ON sod.Id = Id.ServiceOrderDetailId
    INNER JOIN INDIGO031.Inventory.InventoryProduct ip ON ip.Id = sod.ProductId
    INNER JOIN INDIGO031.Inventory.ProductType pt ON pt.Id = ip.ProductTypeId
    WHERE sod.SubTotalSalesPrice > 0
) AS data 
GROUP BY Radicado, NumeroFactura, Ingreso, Tipo, CodigoCUM, Descripcion
)
