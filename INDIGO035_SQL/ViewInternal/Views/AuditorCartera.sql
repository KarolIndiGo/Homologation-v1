-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: AuditorCartera
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE view [ViewInternal].[AuditorCartera]
as (
select
data.Documento,cast(data.Fecha as date) as Fecha, data.Codigo, data.Cuenta, sum(data.Debito) as Debito, sum(data.Credito) as Credito, isnull(cont.Debito,0) as DebitoContabilidad, isnull(cont.Credito,0) as CreditoContabilidad
from (
	select 
	'Radicacion' as Documento
	,rc.ConfirmDate as Fecha
	,RadicatedConsecutive as Codigo
	,masr.Id as IdCuenta
	,masr.Number as Cuenta
	,0 as Debito
	,rd.BalanceInvoice as Credito
	from Portfolio.RadicateInvoiceC rc
	inner join Portfolio.RadicateInvoiceD rd on rc.Id = rd.RadicateInvoiceCId
	inner join Portfolio.AccountReceivable ar on ar.InvoiceNumber = rd.InvoiceNumber and ar.AccountReceivableType = 2
	inner join GeneralLedger.MainAccounts masr on masr.Id = ar.AccountWithoutRadicateId
	where rc.State = 2
	union all
	select 
	'Radicacion' as Documento
	,rc.ConfirmDate as Fecha
	,RadicatedConsecutive as Codigo
	,mare.Id as IdCuenta
	,mare.Number as Cuenta
	,rd.BalanceInvoice as Debito
	,0 as Credito
	from Portfolio.RadicateInvoiceC rc
	inner join Portfolio.RadicateInvoiceD rd on rc.Id = rd.RadicateInvoiceCId
	inner join Portfolio.AccountReceivable ar on ar.InvoiceNumber = rd.InvoiceNumber and ar.AccountReceivableType = 2
	inner join GeneralLedger.MainAccounts mare on mare.Id = ar.AccountRadicateId
	where rc.State = 2
) as data
left join (
	select jv.EntityCode as Codigo,jvd.IdMainAccount as IdCuenta,sum(jvd.DebitValue) as Debito, sum(jvd.CreditValue) as Credito
	from GeneralLedger.JournalVouchers jv
	inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
	where jv.EntityName = 'RadicateInvoiceC' and jv.Status = 2
	group by jv.EntityCode,jvd.IdMainAccount
) as cont on data.IdCuenta = cont.IdCuenta and data.Codigo = cont.Codigo
 group by data.Documento,data.Fecha, data.Codigo, data.Cuenta, cont.Debito, cont.Credito

union all

select dataNota.Documento,cast(dataNota.Fecha as date) Fecha,dataNota.Codigo,dataNota.Cuenta,sum(dataNota.Debito) as Debito, sum(dataNota.Credito) as Credito, isnull(contNota.Debito,0) as DebitoContabilidad, isnull(contNota.Credito,0) as CreditoContabilidad
from (
select 
	'Notas' as Documento
	,n.NoteDate as Fecha
	,n.Code as Codigo
	,ma.Id as IdCuenta
	,ma.Number as Cuenta
	,case n.Nature when 1 then nara.AdjusmentValue else 0 end as Debito
	,case n.Nature when 1 then 0 else nara.AdjusmentValue end as Credito
	from Portfolio.PortfolioNote n
	inner join Portfolio.PortfolioNoteAccountReceivableAdvance nara on n.Id = nara.PortfolioNoteId
	inner join GeneralLedger.MainAccounts ma on ma.Id = nara.MainAccountId
	where n.Status = 2
union all
	select 
	'Notas' as Documento
	,n.NoteDate as Fecha
	,n.Code as Codigo
	,ma.Id as IdCuenta
	,ma.Number as Cuenta
	,case n.Nature when 1 then nara.AdjusmentValue else 0 end as Debito
	,case n.Nature when 1 then 0 else nara.AdjusmentValue end as Credito
	from Portfolio.PortfolioNote n
	inner join Portfolio.PortfolioNoteAccountReceivableAdvance nara on n.Id = nara.PortfolioNoteId
	inner join Portfolio.PortfolioAdvance pa on pa.Id = nara.PortfolioAdvanceId
	inner join GeneralLedger.MainAccounts ma on ma.Id = pa.MainAccountId
	where n.Status = 2
union all
select 
	'Notas' as Documento
	,n.NoteDate as Fecha
	,n.Code as Codigo
	,ma.Id as IdCuenta
	,ma.Number as Cuenta
	,case nd.Nature when 1 then nd.Value else 0 end as Debito
	,case nd.Nature when 1 then 0 else nd.Value end as Credito
	from Portfolio.PortfolioNote n
	inner join Portfolio.PortfolioNoteDetail nd on n.Id = nd.PortfolioNoteId
	inner join GeneralLedger.MainAccounts ma on ma.Id = nd.MainAccountId
	where n.Status = 2
union all
select 
	'Notas' as Documento
	,n.NoteDate as Fecha
	,n.Code as Codigo
	,ma.Id as IdCuenta
	,ma.Number as Cuenta
	,nd.Value as Debito
	,0 as Credito
	from Portfolio.PortfolioNote n
	inner join Portfolio.PortfolioNoteDistribution nd on n.Id = nd.PortfolioNoteId
	inner join GeneralLedger.MainAccounts ma on ma.Id = nd.MainAccountId
	where n.Status = 2
union all
select 
	'Notas' as Documento
	,n.NoteDate as Fecha
	,n.Code as Codigo
	,ma.Id as IdCuenta
	,ma.Number as Cuenta
	,0 as Debito
	,(select sum(Value) from Portfolio.PortfolioNoteDistribution where PortfolioNoteId = n.Id) as Credito
	from Portfolio.PortfolioNote n
	inner join Portfolio.PortfolioAdvance pa on pa.Id = n.PortfolioAdvanceId
	inner join GeneralLedger.MainAccounts ma on ma.Id = pa.MainAccountId
	where n.Status = 2 and n.NoteType = 4
) as dataNota
left join (
	select jv.EntityCode as Codigo,jvd.IdMainAccount as IdCuenta,sum(jvd.DebitValue) as Debito, sum(jvd.CreditValue) as Credito
	from GeneralLedger.JournalVouchers jv
	inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
	where jv.EntityName = 'PortfolioNote' and jv.Status = 2
	group by jv.EntityCode,jvd.IdMainAccount
) as contNota on contNota.IdCuenta = dataNota.IdCuenta and contNota.Codigo = dataNota.Codigo
group by dataNota.Documento,dataNota.Fecha,dataNota.Codigo,dataNota.IdCuenta,dataNota.Cuenta,contNota.Debito,contNota.Credito

)


















