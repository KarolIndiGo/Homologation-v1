-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaDocumentosLibros
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE View [ViewInternal].[VistaDocumentosLibros]
as (
select cast(am.VoucherDate as date) as DocumentDate, am.EntityId, am.EntityCode, am.EntityName, movcol.Consecutive, movcol.Cuenta, movcol.CreditValue, movcol.DebitValue, movniif.Consecutive as ConsecutiveNiif, isnull(movniif.CreditValue,0) as CreditValueNiif, isnull(movniif.DebitValue,0) as DebitValueNiif
from GeneralLedger.AccountingMovement am
inner join (
select jv.AccountingMovementId,jv.Consecutive, jvt.Code + ' - ' + jvt.Name as JournalVoucherType, ma.Id as IdAccount, ma.Number + ' - ' + ma.Name as Cuenta, sum(jvd.DebitValue) as DebitValue, sum(jvd.CreditValue) as CreditValue
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount
inner join GeneralLedger.JournalVoucherTypes jvt on jvt.Id = jv.IdJournalVoucher
inner join GeneralLedger.LegalBook lb on lb.Id = jv.LegalBookId
where lb.Id = 1
group by jv.AccountingMovementId,jv.Consecutive, jvt.Code, jvt.Name, ma.Id, ma.Number, ma.Name
) as movcol on movcol.AccountingMovementId = am.Id
left join GeneralLedger.HomologationAccount ha on ha.OfficialMainAccountId = movcol.IdAccount
left join (
select jv.AccountingMovementId,jv.Consecutive, jvt.Code + ' - ' + jvt.Name as JournalVoucherType, ma.Id as IdAccount, sum(jvd.DebitValue) as DebitValue, sum(jvd.CreditValue) as CreditValue
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount
inner join GeneralLedger.JournalVoucherTypes jvt on jvt.Id = jv.IdJournalVoucher
inner join GeneralLedger.LegalBook lb on lb.Id = jv.LegalBookId
where lb.Id = 2
group by jv.AccountingMovementId,jv.Consecutive, jvt.Code, jvt.Name, ma.Id
) as movniif on movniif.AccountingMovementId = am.Id and movniif.IdAccount = ha.MainAccountId
where movcol.DebitValue <> isnull(movniif.DebitValue,0) or movcol.CreditValue <> isnull(movniif.CreditValue,0)
)
