-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaCruceAnticipos
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE view [ViewInternal].[VistaCruceAnticipos]
as (



select pa.code as NumeroAnticipo, isnull(cr.Code, case pa.OpeningBalance when 1 then 'Saldo Inicial' end ) as DocumentoFuente, pa.DocumentDate as FechaDocumento, tp.nit as Nit, tp.name as Cliente, pa.Value as ValorAnticipo, pa.DebitValue as NotasDB, 
pa.CreditValue as NotasCR, pa.TransferValue as ValorCruzado, pa.DistributionValue as ValorDistribuido, pa.Balance as Saldo

  from Portfolio.PortfolioAdvance as pa left outer join treasury.CashReceipts as cr on pa.cashreceiptid = cr.id
inner join common.ThirdParty as tp on pa.ThirdPartyid = tp.id and tp.id in (select ThirdPartyId from Common.Customer)
where pa.Status = 2


)
