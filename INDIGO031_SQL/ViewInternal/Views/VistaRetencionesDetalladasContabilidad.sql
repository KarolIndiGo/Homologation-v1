-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaRetencionesDetalladasContabilidad
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE view [ViewInternal].[VistaRetencionesDetalladasContabilidad]
as (
select CAST(jv.VoucherDate AS DATE) AS VoucherDate, ma.Number, ma.Name as Cuenta, t.Nit, t.Name as Tercero,jvd.DebitValue, jvd.CreditValue, jvd.Detail, rc.Name as Retencion, jvd.RetentionRate, case isnull(RetentionRate,0) when 0 then cast(BaseValue as bigint) when 1 then cast(BaseValue as bigint) else cast(ROUND((CreditValue * 100 / RetentionRate),1) as bigint) end as Base, case jv.Status when 1 then 'Registrado' when 2 then 'Confirmado' when 3 then 'Anulado' end Estado
from GeneralLedger.JournalVoucherDetails jvd
inner join GeneralLedger.MainAccounts ma on ma.Id = jvd.IdMainAccount
inner join GeneralLedger.JournalVouchers jv on jv.Id = jvd.IdAccounting
left join Common.ThirdParty t on t.Id = jvd.IdThirdParty
left join GeneralLedger.RetentionConcepts rc on rc.Id = jvd.IdRetention
where ma.AllowsMovement = 1 and (ma.Number like '2436%' or ma.Number like '2445%') and jv.Status = 2 and jv.LegalBookId = 1
)
