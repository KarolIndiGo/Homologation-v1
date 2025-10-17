-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VCarteraRadicataXPaciente
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE view [ViewInternal].[VCarteraRadicataXPaciente]
as
(
select 
rc.RadicatedConsecutive as Radicado
, tp.Nit as Nit
, tp.Name as Entidad
,ar.InvoiceNumber as Factura
,case paci.IPTIPODOC when '1' then 'Cédula de Ciudadanía' when '2' then 'Cédula de Extranjería' when '3' then 'Tarjeta de Identidad' when '4' then 'Registro Civil' when '5' then 'Pasaporte' when '6' then 'Adulto Sin Identificación' when '7' then 'Menor Sin Identificación' else '' end as TipoIdentificacionPaciente
,rd.PatientCode as IdentificacionPaciente
,rd.PatientName as NombrePaciente
,rd.IngressDate as FechaIngreso
,cast(rd.InvoiceDate as date) as FechaFactura
,rc.ConfirmDateSystem as FechaRadicado
,isnull(fur.numsoa,'') as NumeroPoliza
,cast(rd.InvoiceValueEntity + rd.InvoiceValuePacient as decimal(18,0)) as ValorBrutoFactura
,cast(rd.InvoiceValuePacient as decimal(18,0)) as ValorCuotaRecuperacion
,cast(isnull(rd.CreditNoteValue,0)as decimal(18,0)) as ValorNotaCredito
,cast(isnull(rd.DebitNoteValue,0)as decimal(18,0)) as ValorNotaDebito
,cast(rd.BalanceInvoice as decimal(18,0)) as ValorNetoFactura
,isnull(notas.Value,0) as TotalNotas
,isnull(pagos.Valor,0) as TotalPagos
,ar.Balance as SaldoActual
from Portfolio.AccountReceivable ar
inner join Common.ThirdParty as tp on ar.ThirdPartyId = tp.Id
inner join Portfolio.RadicateInvoiceD rd on rd.InvoiceNumber = ar.InvoiceNumber and rd.State = 2
inner join Portfolio.RadicateInvoiceC rc on rc.Id = rd.RadicateInvoiceCId and rc.State = 2
left join (select ar.InvoiceNumber, sum(ptd.Value) as Valor from Portfolio.PortfolioTransfer pt
inner join Portfolio.PortfolioTransferDetail ptd on pt.Id = ptd.PortfolioTrasferId
inner join Portfolio.AccountReceivable ar on ar.Id = ptd.AccountReceivableId
where pt.Status = 2 and ar.AccountReceivableType = 2
group by ar.InvoiceNumber) as pagos on pagos.InvoiceNumber = ar.InvoiceNumber
left join (select ar.InvoiceNumber, sum(pnd.AdjusmentValue) as Value from Portfolio.PortfolioNote pn
inner join Portfolio.PortfolioNoteAccountReceivableAdvance pnd on pnd.PortfolioNoteId = pn.Id
inner join Portfolio.AccountReceivable ar on ar.Id = pnd.AccountReceivableId
where ar.AccountReceivableType = 2
group by ar.InvoiceNumber) as notas on notas.InvoiceNumber = ar.InvoiceNumber
left join dbo.INPACIENT paci on paci.IPCODPACI = rd.PatientCode
left join dbo.ADFURIPSU AS FUR on fur.NUMINGRES = rd.ingressnumber
where ar.AccountReceivableType = 2
)
