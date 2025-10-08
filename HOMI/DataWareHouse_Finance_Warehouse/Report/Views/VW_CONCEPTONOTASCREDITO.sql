-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_CONCEPTONOTASCREDITO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_CONCEPTONOTASCREDITO]
AS

select
    a.BillingNoteId CODIGO_NOTA,
    b.Name ENTIDAD,
    a.InvoiceNumber FACTURA,
    h.NoteDate FECHA_NOTA,
    h.Observations,
    SUM(e.Value) VALOR,
    CASE
        when g.Status = '0' then 'Fallido'
        when g.Status = '1' then 'Exitoso'
        else 'No aplica'
    end ESTADO_ENVIO,
    CASE
        when g.Destination = '0' then 'Validacion previa'
        when g.Destination = '1' then 'Envio Documento Electronico a la DIAN'
        when g.Destination = '2' then 'Validacion del Documento Enviado'
        else 'No aplica'
    end DESTINO_ENVIO,
    CASE
        when g.Destination = '1' then 'Devolución o no aceptación de partes del servicio'
        when g.Destination = '2' then 'Anulación de factura electrónica'
        when g.Destination = '3' then 'Rebaja total aplicada'
        when g.Destination = '4' then 'Descuento total aplicado'
        when g.Destination = '5' then 'Rescisión: nulidad por falta de requisitos'
        when g.Destination = '6' then 'Otros'
        Else 'No aplica'
    end CONCEPTO
from INDIGO036.Billing.BillingNoteDetail a
left join INDIGO036.Common.Customer b on a.Id = b.Id
left join INDIGO036.Portfolio.PortfolioNoteDetail e on e.PortfolioNoteId = a.Id
left join INDIGO036.Billing.ElectronicDocumentDetail g on a.Id = g.Id
left join INDIGO036.Billing.BillingNote h on a.Id = h.Id
where h.Nature = 2
group by a.BillingNoteId,
    a.InvoiceNumber,
    b.Name,
    h.Observations,
    h.NoteDate,
    g.Status,
    g.Destination