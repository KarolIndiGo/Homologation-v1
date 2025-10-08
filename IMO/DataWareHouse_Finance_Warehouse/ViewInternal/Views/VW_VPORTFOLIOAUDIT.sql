-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VPORTFOLIOAUDIT
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VPortfolioAudit
AS 

select *
from (
--- Cuentas contables sin Radicar
select rc.RadicatedConsecutive, ma.Number + ' - ' + ma.Name as Cuenta, sum(rd.BalanceInvoice) as ValorRadicado, data.EntityCode, data.Value as ValorContabilidad
from [INDIGO035].[Portfolio].[RadicateInvoiceC] rc
inner join [INDIGO035].[Portfolio].[RadicateInvoiceD] rd on rd.RadicateInvoiceCId = rc.Id
inner join [INDIGO035].[Portfolio].[AccountReceivable] ar on ar.InvoiceNumber = rd.InvoiceNumber and ar.AccountReceivableType = 2
inner join [INDIGO035].[GeneralLedger].[MainAccounts] ma on ma.Id = ar.AccountWithoutRadicateId
left join (
select jv.EntityId, jv.EntityCode, jvd.IdMainAccount, sum(jvd.CreditValue) + sum(jvd.DebitValue) as Value
from [INDIGO035].[GeneralLedger].[JournalVouchers] jv
inner join [INDIGO035].[GeneralLedger].[JournalVoucherDetails] jvd on jvd.IdAccounting = jv.Id
where jv.EntityName = 'RadicateInvoiceC' and jv.LegalBookId = 1
group by jv.EntityId, jv.EntityCode, jvd.IdMainAccount
) as data on data.EntityId = rc.Id and data.IdMainAccount = ma.Id
where rc.State in (2) and cast(rc.RadicatedDate as date) > '07/01/2016'
group by rc.RadicatedConsecutive, data.EntityCode, data.Value, ma.Number, ma.Name
union all
--- Cuentas contables de Radicadas
select rc.RadicatedConsecutive, ma.Number + ' - ' + ma.Name as Cuenta, sum(rd.BalanceInvoice) as ValorRadicado, data.EntityCode, data.Value as ValorContabilidad
from [INDIGO035].[Portfolio].[RadicateInvoiceC] rc
inner join [INDIGO035].[Portfolio].[RadicateInvoiceD] rd on rd.RadicateInvoiceCId = rc.Id
inner join [INDIGO035].[Portfolio].[AccountReceivable] ar on ar.InvoiceNumber = rd.InvoiceNumber and ar.AccountReceivableType = 2
inner join [INDIGO035].[GeneralLedger].[MainAccounts] ma on ma.Id = ar.AccountRadicateId
left join (
select jv.EntityId, jv.EntityCode, jvd.IdMainAccount, sum(jvd.CreditValue) + sum(jvd.DebitValue) as Value
from [INDIGO035].[GeneralLedger].[JournalVouchers] jv
inner join [INDIGO035].[GeneralLedger].[JournalVoucherDetails] jvd on jvd.IdAccounting = jv.Id
where jv.EntityName = 'RadicateInvoiceC' and jv.LegalBookId = 1
group by jv.EntityId, jv.EntityCode, jvd.IdMainAccount
) as data on data.EntityId = rc.Id and data.IdMainAccount = ma.Id
where rc.State in (2) and cast(rc.RadicatedDate as date) > '07/01/2016'
group by rc.RadicatedConsecutive, data.EntityCode, data.Value, ma.Number, ma.Name
) as data2
where data2.ValorRadicado <> isnull(data2.ValorContabilidad,0)
