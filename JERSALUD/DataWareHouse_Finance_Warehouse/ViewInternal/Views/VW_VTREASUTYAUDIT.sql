-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VTREASUTYAUDIT
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VTREASUTYAUDIT
as (
select 'Recibos de caja' as Entity
    , cr.Code
    , DocumentDate
    , cr.CreationUser
    , Detail
    , cr.Value as TreasuryValue
    , isnull(b.Value,0) as GeneralValue
    , c.Code + ' - ' + c.Name as Cash
    , eba.Code + ' - ' + eba.Number as EntityBank
from INDIGO031.Treasury.CashReceipts cr
left join INDIGO031.Treasury.CashRegisters c on c.Id = cr.IdCashRegister
left join INDIGO031.Treasury.EntityBankAccounts eba on eba.Id = cr.IdBankAccount
left join (
    select EntityCode, sum(DebitValue) as Value
    from INDIGO031.GeneralLedger.JournalVouchers jv
    inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
    inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
    where EntityName = 'CashReceipts'
    group by EntityCode
    ) as b on b.EntityCode = cr.Code
where cr.Value <> isnull(b.Value,0) and cr.Status in (2,4)

union all

select 'Comprobante de Egreso' as Entity
    , vt.Code
    , DocumentDate
    , vt.CreationUser
    , Detail
    , vt.Value as TreasuryValue
    , isnull(b.Value,0) as GeneralValue
    , c.Code + ' - ' + c.Name as Cash
    , eba.Code + ' - ' + eba.Number as EntityBank
from INDIGO031.Treasury.VoucherTransaction vt
left join INDIGO031.Treasury.CashRegisters c on c.Id = vt.IdCashRegister
left join INDIGO031.Treasury.EntityBankAccounts eba on eba.Id = vt.IdEntityBankAccount
left join (
    select EntityCode, sum(DebitValue) as Value
    from INDIGO031.GeneralLedger.JournalVouchers jv
    inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
    inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
    where EntityName = 'VoucherTransaction'
    group by EntityCode
    ) b on vt.Code = b.EntityCode
where vt.Value <> isnull(b.Value,0) and vt.Status in (2,4)

union all

select 'Notas DB/CR' as Entity
    , tn.Code
    , tn.NoteDate as DocumentDate
    , tn.CreationUser
    , tn.Description as Detail
    , tn.Value as TreasuryValue
    , isnull(b.Value,0) as GeneralValue
    , c.Code + ' - ' + c.Name as Cash
    , eba.Code + ' - ' + eba.Number as EntityBank
from INDIGO031.Treasury.TreasuryNote tn
left join INDIGO031.Treasury.CashRegisters c on c.Id = tn.CashRegisterId
left join INDIGO031.Treasury.EntityBankAccounts eba on eba.Id = tn.EntityBankAccountId
left join (
    select EntityCode, sum(DebitValue) as Value
    from INDIGO031.GeneralLedger.JournalVouchers jv
    inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
    inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
    where EntityName = 'TreasuryNote'
    group by EntityCode
    ) b on tn.Code = b.EntityCode
where tn.Value <> isnull(b.Value,0) and tn.Status in (2,4) and NoteType in (1,2)

union all

select 'Notas Rev CE' as Entity
    , tn.Code
    , tn.NoteDate as DocumentDate
    , tn.CreationUser
    , tn.Description as Detail
    , vt.Value as TreasuryValue
    , isnull(b.Value,0) as GeneralValue
    , c.Code + ' - ' + c.Name as Cash
    , eba.Code + ' - ' + eba.Number as EntityBank
from INDIGO031.Treasury.TreasuryNote tn
inner join INDIGO031.Treasury.VoucherTransaction vt on vt.Id = tn.VoucherTransactionId
left join INDIGO031.Treasury.CashRegisters c on c.Id = tn.CashRegisterId
left join INDIGO031.Treasury.EntityBankAccounts eba on eba.Id = tn.EntityBankAccountId
left join (
    select EntityCode, sum(DebitValue) as Value
    from INDIGO031.GeneralLedger.JournalVouchers jv
    inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
    inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
    where EntityName = 'TreasuryNote'
    group by EntityCode
    ) b on tn.Code = b.EntityCode
where vt.Value <> isnull(b.Value,0) and tn.Status in (2,4) and NoteType = 3

union all

select 'Notas Rev RC' as Entity
    , tn.Code
    , tn.NoteDate as DocumentDate
    , tn.CreationUser
    , tn.Description as Detail
    , cr.Value as TreasuryValue
    , isnull(b.Value,0) as GeneralValue
    , c.Code + ' - ' + c.Name as Cash
    , eba.Code + ' - ' + eba.Number as EntityBank
from INDIGO031.Treasury.TreasuryNote tn
inner join INDIGO031.Treasury.CashReceipts cr on cr.Id = tn.CashReceiptId
left join INDIGO031.Treasury.CashRegisters c on c.Id = tn.CashRegisterId
left join INDIGO031.Treasury.EntityBankAccounts eba on eba.Id = tn.EntityBankAccountId
left join (
    select EntityCode, sum(DebitValue) as Value
    from INDIGO031.GeneralLedger.JournalVouchers jv
    inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
    inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
    where EntityName = 'TreasuryNote'
    group by EntityCode
    ) b on tn.Code = b.EntityCode
where cr.Value <> isnull(b.Value,0) and tn.Status in (2,4) and NoteType = 4

union all

select 'Consignaciones' as Entity
    , cs.Code
    , cs.DocumentDate
    , cs.CreationUser
    , cs.Description as Detail
    , cs.Value as TreasuryValue
    , isnull(b.Value,0) as GeneralValue
    , '' as Cash
    , eba.Code + ' - ' + eba.Number as EntityBank
from INDIGO031.Treasury.Consignment cs
left join INDIGO031.Treasury.EntityBankAccounts eba on eba.Id = cs.EntityBankAccountId
left join (
    select EntityCode, sum(DebitValue) as Value
    from INDIGO031.GeneralLedger.JournalVouchers jv
    inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
    inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
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
from INDIGO031.GeneralLedger.JournalVouchers jv
inner join INDIGO031.GeneralLedger.JournalVoucherDetails jvd on jvd.IdAccounting = jv.Id
inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount and ma.LegalBookId = 1
left join INDIGO031.Treasury.CashRegisters cr on cr.IdMainAccount = jvd.IdMainAccount
left join INDIGO031.Treasury.EntityBankAccounts eba on eba.IdMainAccount = jvd.IdMainAccount
where jvd.IdMainAccount in (
select IdMainAccount from INDIGO031.Treasury.CashRegisters 
union all 
select IdMainAccount from INDIGO031.Treasury.EntityBankAccounts)
and EntityName not in ('CashReceipts','TreasuryNote','Consignment', 'VoucherTransaction') and jv.Status = 2
group by jv.Consecutive, jv.VoucherDate, jv.CreationUser, jv.Detail, cr.Code, cr.Name, eba.Code, eba.Number
)