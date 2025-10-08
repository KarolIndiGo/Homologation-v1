-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VISTADOCUMENTOSLIBROS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE View [ViewInternal].[VW_VISTADOCUMENTOSLIBROS] as 
(
select cast(am.VoucherDate as date) as DocumentDate, am.EntityId, am.EntityCode, am.EntityName, movcol.Consecutive, movcol.Cuenta, movcol.CreditValue, movcol.DebitValue, movniif.Consecutive as ConsecutiveNiif, isnull(movniif.CreditValue,0) as CreditValueNiif, isnull(movniif.DebitValue,0) as DebitValueNiif
from INDIGO031.GeneralLedger.AccountingMovement am
inner join (
select jv.AccountingMovementId,jv.Consecutive, jvt.Code + ' - ' + jvt.Name as JournalVoucherType, ma.Id as IdAccount, ma.Number + ' - ' + ma.Name as Cuenta, sum(jvd.DebitValue) as DebitValue, sum(jvd.CreditValue) as CreditValue
from INDIGO031.GeneralLedger.JournalVouchers jv
inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount
inner join INDIGO031.GeneralLedger.JournalVoucherTypes jvt on jvt.Id = jv.IdJournalVoucher
inner join INDIGO031.GeneralLedger.LegalBook lb on lb.Id = jv.LegalBookId
where lb.Id = 1
group by jv.AccountingMovementId,jv.Consecutive, jvt.Code, jvt.Name, ma.Id, ma.Number, ma.Name
) as movcol on movcol.AccountingMovementId = am.Id
left join INDIGO031.GeneralLedger.HomologationAccount ha on ha.OfficialMainAccountId = movcol.IdAccount
left join (
select jv.AccountingMovementId,jv.Consecutive, jvt.Code + ' - ' + jvt.Name as JournalVoucherType, ma.Id as IdAccount, sum(jvd.DebitValue) as DebitValue, sum(jvd.CreditValue) as CreditValue
from INDIGO031.GeneralLedger.JournalVouchers jv
inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount
inner join INDIGO031.GeneralLedger.JournalVoucherTypes jvt on jvt.Id = jv.IdJournalVoucher
inner join INDIGO031.GeneralLedger.LegalBook lb on lb.Id = jv.LegalBookId
where lb.Id = 2
group by jv.AccountingMovementId,jv.Consecutive, jvt.Code, jvt.Name, ma.Id
) as movniif on movniif.AccountingMovementId = am.Id and movniif.IdAccount = ha.MainAccountId
where movcol.DebitValue <> isnull(movniif.DebitValue,0) or movcol.CreditValue <> isnull(movniif.CreditValue,0)
)
