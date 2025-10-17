-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Treasury_ComprobantesEgreso
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[Treasury_NotasTesoreria]    Script Date: 18/06/2025 8:50:04 p. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE view [ViewInternal].[Treasury_ComprobantesEgreso] as

SELECT  n.CODE as Código, LTRIM(RTRIM(T.NIT)) +'  - '+LTRIM(RTRIM(T.NAME)) as Tercero, LTRIM(RTRIM(M.NUMBER))+' - '+LTRIM(RTRIM(M.NAME)) AS Cuenta,
case VoucherClass when 1 then 'Pago'
			  when 2 then 'Reembolso'
			  when 3 then 'Traslado'
			   end as Clase, n.DocumentDate as FechaDocumento, n.Value as Valor, n.Detail as Detalle ,
case n.Status when 1 then 'Registrado' when 2 then 'Confirmado' when 3 then 'Anulado' when 4 then 'Reversado' end 'Estado Documento', 
n.ReversedDate as FechaReversa
FROM INDIGO031.Treasury.VoucherTransaction as n
LEFT JOIN INDIGO031.Common.ThirdParty AS T ON T.ID=N.IdThirdParty
LEFT JOIN INDIGO031.GeneralLedger.MainAccounts AS M ON M.ID=N.IdMainAccount
--left join INDIGO031.Treasury.VoucherTransaction as d on d.id=n.VoucherTransactionId
