-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Treasury_RecibosDeCaja
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create view [ViewInternal].[Treasury_RecibosDeCaja] as

SELECT  n.CODE as Código, LTRIM(RTRIM(T.NIT)) +'  - '+LTRIM(RTRIM(T.NAME)) as Tercero, LTRIM(RTRIM(M.NUMBER))+' - '+LTRIM(RTRIM(M.NAME)) AS Cuenta,
case CollectType when 1 then 'Caja'
			  when 2 then 'Bancos'
			   end as TipoRecuado, n.DocumentDate as FechaDocumento, n.Value as Valor, n.Detail as Detalle ,
case n.Status when 1 then 'Registrado' when 2 then 'Confirmado' when 3 then 'Anulado' when 4 then 'Reversado' end 'Estado Documento', 
n.ReversedDate as FechaReversa
FROM INDIGO031.Treasury.CashReceipts as n
LEFT JOIN INDIGO031.Common.ThirdParty AS T ON T.ID=N.IdThirdParty
LEFT JOIN INDIGO031.GeneralLedger.MainAccounts AS M ON M.ID=N.IdMainAccount
--left join INDIGO031.Treasury.VoucherTransaction as d on d.id=n.VoucherTransactionId
