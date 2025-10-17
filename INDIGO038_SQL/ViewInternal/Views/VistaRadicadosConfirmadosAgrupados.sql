-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaRadicadosConfirmadosAgrupados
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [ViewInternal].[VistaRadicadosConfirmadosAgrupados]
as (
select 
rc.RadicatedConsecutive as CuentaCobro,
t.Nit,
t.Name as Entidad,
case MA.Number when '14090103' then 'Contributivo' when '14090304' then 'Subsidiado' when '14090401' then 'Servicio IPS Privada' when '14090501' then 'Medicina Prepagada' when '14090601' then 'Compañias Aseguradoras' when '14090701' then 'Particulares' when '14090901' then 'Servicio IPS Publicas' when '14091004' then 'Regimen Especial' when '14091102' then 'Vinculados - Departamentos' when '14091103' then 'Vinculados Municipios' when '14091201' then 'Arl Riesgos Profesionales' when '14091403' then 'Accidentes de Transito' when '14090201' then 'Otras Cuentas X Cobrar' end as Regimen,
ic.Code + ' - ' + ic.Name as Categoria,
sum(ar.Value) as Valor,
cast(rc.ConfirmDateSystem as date) as FechaConfirmacion
from Portfolio.RadicateInvoiceC rc
inner join Portfolio.RadicateInvoiceD rd on rd.RadicateInvoiceCId = rc.Id
inner join Portfolio.AccountReceivable ar on ar.InvoiceNumber = rd.InvoiceNumber and ar.AccountReceivableType = 2
inner join Common.ThirdParty t on t.Id = ar.ThirdPartyId
inner join GeneralLedger.MainAccounts ma on ma.Id = ar.AccountWithoutRadicateId
left join Billing.Invoice i on i.InvoiceNumber = ar.InvoiceNumber
left join Billing.InvoiceCategories ic on ic.Id = i.InvoiceCategoryId
where ar.AccountReceivableType = 2 and rc.State = 2  and rd.State = 2
group by rc.RadicatedConsecutive, t.Nit, t.Name, MA.Number, ic.Code, ic.Name, cast(rc.ConfirmDateSystem as date)
)





