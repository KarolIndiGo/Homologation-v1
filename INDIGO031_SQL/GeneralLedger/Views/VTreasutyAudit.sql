-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: GeneralLedger
-- Object: VTreasutyAudit
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [GeneralLedger].[VTreasutyAudit]
as
select ROW_NUMBER() OVER(ORDER BY DocumentDate ASC) as Row ,Entity,Code,DocumentDate, CreationUser,Detail, TreasuryValue, GeneralValue, Cash, EntityBank, Number, MainAccount, LegalBookId from (
select 'Recibos de caja' as Entity,cr.Code,DocumentDate, cr.CreationUser,Detail, cr.Value as TreasuryValue, isnull(b.Value,0) as GeneralValue, c.Code + ' - ' + c.Name as Cash, eba.Code + ' - ' + eba.Number as EntityBank
,ma.Number as Number, ma.Name as MainAccount, gl.Id as LegalBookId
from Treasury.CashReceipts cr
inner join GeneralLedger.MainAccounts as ma on ma.Id = cr.IdMainAccount
inner join GeneralLedger.LegalBook as gl on gl.Id = ma.LegalBookId
left join Treasury.CashRegisters c on c.Id = cr.IdCashRegister
left join Treasury.EntityBankAccounts eba on eba.Id = cr.IdBankAccount
left join (
select EntityCode, sum(DebitValue) as Value
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
where EntityName = 'CashReceipts'
group by EntityCode
) as b on b.EntityCode = cr.Code
where cr.Value <> isnull(b.Value,0) and cr.Status in (2,4)
union all
select 'Comprobante de Egreso' as Entity,vt.Code,DocumentDate,vt.CreationUser,vt.Detail, sum(vtd.[Value]) as TreasuryValue, isnull(b.Value,0) as GeneralValue, c.Code + ' - ' + c.Name as Cash, eba.Code + ' - ' + eba.Number as EntityBank
,ma.Number as Number, ma.Name as MainAccount, gl.Id as LegalBookId
from Treasury.VoucherTransaction vt
inner join Treasury.VoucherTransactionDetails vtd on vtd.IdVoucherTransaction = vt.Id and vtd.Nature = 1
inner join GeneralLedger.MainAccounts as ma on ma.Id = vt.IdMainAccount
inner join GeneralLedger.LegalBook as gl on gl.Id = ma.LegalBookId
left join Treasury.CashRegisters c on c.Id = vt.IdCashRegister
left join Treasury.EntityBankAccounts eba on eba.Id = vt.IdEntityBankAccount
left join (
select EntityCode, sum(DebitValue) as Value
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
where EntityName = 'VoucherTransaction' and jv.Status in (2,4)
group by EntityCode
) b on vt.Code = b.EntityCode
where vt.Status in (2,4)
group by vt.Code, vt.DocumentDate, vt.CreationUser, vt.Detail, b.[Value], c.Code,c.[Name], eba.Code, eba.[Number], ma.Number, ma.[Name], gl.Id
having sum(vtd.Value) <> isnull(b.Value,0) 
union all
select 'Notas DB/CR' as Entity,tn.Code,tn.NoteDate as DocumentDate,tn.CreationUser,tn.Description as Detail, tn.Value as TreasuryValue, isnull(b.Value,0) as GeneralValue, c.Code + ' - ' + c.Name as Cash, eba.Code + ' - ' + eba.Number as EntityBank
,ma.Number as Number, ma.Name as MainAccount, gl.Id as LegalBookId
from Treasury.TreasuryNote tn
left join GeneralLedger.MainAccounts as ma on ma.Id = tn.MainAccountId
left join GeneralLedger.LegalBook as gl on gl.Id = ma.LegalBookId
left join Treasury.CashRegisters c on c.Id = tn.CashRegisterId
left join Treasury.EntityBankAccounts eba on eba.Id = tn.EntityBankAccountId
left join (
select EntityCode, sum(DebitValue) as Value
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
where EntityName = 'TreasuryNote'
group by EntityCode
) b on tn.Code = b.EntityCode
where tn.Value <> isnull(b.Value,0) and tn.Status in (2,4) and NoteType in (1,2)
union all
select 'Notas Rev CE' as Entity,tn.Code,tn.NoteDate as DocumentDate,tn.CreationUser,tn.Description as Detail, vt.Value as TreasuryValue, isnull(b.Value,0) as GeneralValue, c.Code + ' - ' + c.Name as Cash, eba.Code + ' - ' + eba.Number as EntityBank
,ma.Number as Number, ma.Name as MainAccount, gl.Id as LegalBookId
from Treasury.TreasuryNote tn
inner join Treasury.VoucherTransaction vt on vt.Id = tn.VoucherTransactionId
left join GeneralLedger.MainAccounts as ma on ma.Id = tn.MainAccountId
left join GeneralLedger.LegalBook as gl on gl.Id = ma.LegalBookId
left join Treasury.CashRegisters c on c.Id = tn.CashRegisterId
left join Treasury.EntityBankAccounts eba on eba.Id = tn.EntityBankAccountId
left join (
select EntityCode, sum(DebitValue) as Value
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
where EntityName = 'TreasuryNote'
group by EntityCode
) b on tn.Code = b.EntityCode
where vt.Value <> isnull(b.Value,0) and tn.Status in (2,4) and NoteType = 3
union all
select 'Notas Rev RC' as Entity,tn.Code,tn.NoteDate as DocumentDate,tn.CreationUser,tn.Description as Detail, cr.Value as TreasuryValue, isnull(b.Value,0) as GeneralValue, c.Code + ' - ' + c.Name as Cash, eba.Code + ' - ' + eba.Number as EntityBank
,ma.Number as Number, ma.Name as MainAccount, gl.Id as LegalBookId
from Treasury.TreasuryNote tn
inner join Treasury.CashReceipts cr on cr.Id = tn.CashReceiptId
left join GeneralLedger.MainAccounts as ma on ma.Id = tn.MainAccountId
left join GeneralLedger.LegalBook as gl on gl.Id = ma.LegalBookId
left join Treasury.CashRegisters c on c.Id = tn.CashRegisterId
left join Treasury.EntityBankAccounts eba on eba.Id = tn.EntityBankAccountId
left join (
select EntityCode, sum(DebitValue) as Value
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
where EntityName = 'TreasuryNote'
group by EntityCode
) b on tn.Code = b.EntityCode
where cr.Value <> isnull(b.Value,0) and tn.Status in (2,4) and NoteType = 4
union all
select 'Consignaciones' as Entity,cs.Code,cs.DocumentDate,cs.CreationUser,cs.Description as Detail, cs.Value as TreasuryValue, isnull(b.Value,0) as GeneralValue, '' as Cash, eba.Code + ' - ' + eba.Number as EntityBank
,ma.Number as Number, ma.Name as MainAccount, gl.Id as LegalBookId
from Treasury.Consignment cs
inner join GeneralLedger.MainAccounts as ma on ma.Id = cs.MainAccountId
inner join GeneralLedger.LegalBook as gl on gl.Id = ma.LegalBookId
left join Treasury.EntityBankAccounts eba on eba.Id = cs.EntityBankAccountId
left join (
select EntityCode, sum(DebitValue) as Value
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
where EntityName = 'Consignment'
group by EntityCode
) b on cs.Code = b.EntityCode
where cs.Value <> isnull(b.Value,0) and cs.Status in (2,4)
union all
select 'Ajuste Contable' as Entity,
cast(jv.Consecutive as varchar(20)) as Code,
jv.VoucherDate as DocumentDate,
jv.CreationUser,
jv.Detail,
0 as TreasuryValue,
sum(jvd.DebitValue) as GeneralValue,
cr.Code + ' - ' + cr.Name as Cash,
eba.Code + ' - ' + eba.Number as EntityBank
,ma.Number as Number, ma.Name as MainAccount
, gl.Id as LegalBookId
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jvd.IdAccounting = jv.Id
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
inner join GeneralLedger.LegalBook as gl on gl.Id = ma.LegalBookId
left join Treasury.CashRegisters cr on cr.IdMainAccount = jvd.IdMainAccount
left join Treasury.EntityBankAccounts eba on eba.IdMainAccount = jvd.IdMainAccount
where jvd.IdMainAccount in (select IdMainAccount from Treasury.CashRegisters union all select IdMainAccount from Treasury.EntityBankAccounts)
and EntityName not in ('CashReceipts','TreasuryNote','Consignment', 'VoucherTransaction') and jv.Status = 2
group by jv.Consecutive, jv.VoucherDate, jv.CreationUser, jv.Detail, cr.Code, cr.Name, eba.Code, eba.Number, ma.Number, ma.Name, gl.Id
) as Datos









