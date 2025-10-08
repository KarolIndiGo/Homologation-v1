-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_FACTURACIONCARTERA
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_FACTURACIONCARTERA
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
from [INDIGO031].[Portfolio].[AccountReceivable] ar
inner join [INDIGO031].[Common].[ThirdParty] t on ar.ThirdPartyId = t.Id
left join [INDIGO031].[Billing].[Invoice] i on i.Id = ar.InvoiceId
left join [INDIGO031].[Contract].[CareGroup] cg on cg.Id = i.CareGroupId
left join [INDIGO031].[Contract].[Contract] c on cg.ContractId = c.Id
where ar.AccountReceivableType = 2 and ar.Balance > 0 and ar.Status = 2

)
