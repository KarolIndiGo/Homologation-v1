-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_TREASURY_RECIBOSDECAJA
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create view [ViewInternal].[VW_TREASURY_RECIBOSDECAJA] as

SELECT  n.Code as Código, LTRIM(RTRIM(T.Nit)) +'  - '+LTRIM(RTRIM(T.Name)) as Tercero, LTRIM(RTRIM(M.Number))+' - '+LTRIM(RTRIM(M.Name)) AS Cuenta,
case CollectType when 1 then 'Caja'
			  when 2 then 'Bancos'
			   end as TipoRecuado, n.DocumentDate as FechaDocumento, n.Value as Valor, n.Detail as Detalle ,
case n.Status when 1 then 'Registrado' when 2 then 'Confirmado' when 3 then 'Anulado' when 4 then 'Reversado' end 'Estado Documento', 
n.ReversedDate as FechaReversa
FROM INDIGO031.Treasury.CashReceipts as n
LEFT JOIN INDIGO031.Common.ThirdParty AS T ON T.Id=n.IdThirdParty
LEFT JOIN INDIGO031.GeneralLedger.MainAccounts AS M ON M.Id=n.IdMainAccount
--left join INDIGO031.Treasury.VoucherTransaction as d on d.id=n.VoucherTransactionId
