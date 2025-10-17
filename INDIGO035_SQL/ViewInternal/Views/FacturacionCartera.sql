-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FacturacionCartera
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE view [ViewInternal].[FacturacionCartera]
as
(
select 
ar.InvoiceNumber as Factura
,AccountReceivableDate as FechaFactura
,t.Nit as NitEntidad
,t.Name as Entidad
,c.Code as Contracto
,cg.Code as CodigoGrupoAtencion
,cg.Name as GrupoAtencion
,ar.PortfolioStatus as EstadoCartera
,ar.OpeningBalance as SaldoInicial
,ar.Value as Valor
,ar.Balance as Saldo
from Portfolio.AccountReceivable ar
inner join Common.ThirdParty t on ar.ThirdPartyId = t.Id
left join Billing.Invoice i on i.Id = ar.InvoiceId
left join Contract.CareGroup cg on cg.Id = i.CareGroupId
left join Contract.Contract c on cg.ContractId = c.Id
where ar.AccountReceivableType = 2 and ar.Balance > 0 and ar.Status = 2

)





