-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VISTACRUCEANTICIPOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE view [ViewInternal].[VW_VISTACRUCEANTICIPOS] as 
(
select pa.Code as NumeroAnticipo, isnull(cr.Code, case pa.OpeningBalance when 1 then 'Saldo Inicial' end ) as DocumentoFuente, pa.DocumentDate as FechaDocumento, tp.Nit as Nit, tp.Name as Cliente, pa.Value as ValorAnticipo, pa.DebitValue as NotasDB, 
pa.CreditValue as NotasCR, pa.TransferValue as ValorCruzado, pa.DistributionValue as ValorDistribuido, pa.Balance as Saldo

  from INDIGO031.Portfolio.PortfolioAdvance as pa left outer join INDIGO031.Treasury.CashReceipts as cr on pa.CashReceiptId = cr.Id
inner join INDIGO031.Common.ThirdParty as tp on pa.ThirdPartyId = tp.Id and tp.Id in (select ThirdPartyId from INDIGO031.Common.Customer)
where pa.Status = 2


)
