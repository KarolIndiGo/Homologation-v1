-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_INFORMEJUSTIDENOTASCREDITO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_INFORMEJUSTIDENOTASCREDITO] AS

select
    a.Code CODIGO_NOTA,
    d.InvoiceNumber FACTURA,
    b.Name ENTIDAD,
    a.NoteDate FECHA_NOTA,
    SUM(e.Value) VALOR,
    a.Observations OBSERVACION,
    f.NOMUSUARI USUARIO_CREACION,
    CASE
        when g.Status = '0' then 'Invalida'
        when g.Status = '1' then 'Registrada'
        when g.Status = '2' then 'Enviada'
        when g.Status = '3' then 'Validada'
        when g.Status = '4' then 'Validacion Fallida'
        when g.Status = '5' then 'Revisar en Sistema'
        when g.Status = '77' then 'Pendiente'
        else 'Validacion previa'
    end ESTADO_ENVIO
from INDIGO036.Portfolio.PortfolioNote a
    left join INDIGO036.Common.Customer b on a.CustomerId = b.Id
    left join INDIGO036.Portfolio.PortfolioNoteAccountReceivableAdvance c on a.Id = c.PortfolioNoteId
    left join INDIGO036.Portfolio.AccountReceivable d on c.AccountReceivableId = d.Id
    left join INDIGO036.Portfolio.PortfolioNoteDetail e on e.PortfolioNoteId = a.Id
    left join INDIGO036.dbo.SEGusuaru f on a.CreationUser = f.CODUSUARI
    left join INDIGO036.Billing.ElectronicDocument g on a.Id = g.Id
where
    a.Nature = 2
group by
    a.Code,
    d.InvoiceNumber,
    b.Name,
    a.NoteDate,
    a.Observations,
    a.CreationUser,
    f.NOMUSUARI,
    g.Status