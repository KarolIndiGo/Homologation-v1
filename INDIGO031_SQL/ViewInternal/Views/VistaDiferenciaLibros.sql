-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaDiferenciaLibros
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE view [ViewInternal].[VistaDiferenciaLibros]
as (
select datacol.Anio, datacol.Mes, datacol.IdMainAccount, datacol.Number + ' - ' + datacol.Name as CuentaColgap, datacol.Nit, datacol.CodeCostCenter, datacol.DebitValue, datacol.CreditValue, manif.Number + ' - ' + manif.Name as CuentaNiif, isnull(datanif.DebitValue,0) as DebitValueNiif, isnull(datanif.CreditValue,0) as CreditValueNiif
from (
select MONTH(jv.VoucherDate) as Mes, year(jv.VoucherDate) as Anio, jvd.IdMainAccount,ma.Number, ma.Name, t.Nit, cc.Code as CodeCostCenter, jvd.IdThirdParty, jvd.IdCostCenter, sum(jvd.DebitValue) as DebitValue, sum(jvd.CreditValue) as CreditValue 
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount
left join Common.ThirdParty t on t.Id = jvd.IdThirdParty
left join Payroll.CostCenter cc on cc.Id = jvd.IdCostCenter
where ma.LegalBookId = 1 and jv.IsClosedYear = 0
group by MONTH(jv.VoucherDate), year(jv.VoucherDate), jvd.IdMainAccount, ma.Number, ma.Name, jvd.IdThirdParty, t.Nit, jvd.IdCostCenter, cc.Code
) as datacol inner join GeneralLedger.HomologationAccount ha on ha.OfficialMainAccountId = datacol.IdMainAccount inner join GeneralLedger.MainAccounts manif on manif.Id = ha.MainAccountId left join
(
select MONTH(jv.VoucherDate) as Mes, year(jv.VoucherDate) as Anio, jvd.IdMainAccount, jvd.IdThirdParty, jvd.IdCostCenter, sum(jvd.DebitValue) as DebitValue, sum(jvd.CreditValue) as CreditValue 
from GeneralLedger.JournalVouchers jv
inner join GeneralLedger.JournalVoucherDetails jvd on jv.Id = jvd.IdAccounting
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount
where ma.LegalBookId = 2 and jv.IsClosedYear = 0
group by MONTH(jv.VoucherDate), year(jv.VoucherDate), jvd.IdMainAccount, jvd.IdThirdParty, jvd.IdCostCenter
) as datanif on datacol.Anio = datanif.Anio and datacol.Mes = datanif.Mes and datanif.IdMainAccount = ha.MainAccountId and isnull(datacol.IdThirdParty,0) = isnull(datanif.IdThirdParty,0) and isnull(datacol.IdCostCenter, 0) = isnull(datanif.IdCostCenter,0)
where datacol.DebitValue <> isnull(datanif.DebitValue,0) or datacol.CreditValue <> isnull(datanif.CreditValue,0)
)
