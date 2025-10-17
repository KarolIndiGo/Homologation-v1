-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_COMPROBANTE_EGRESO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_COMPROBANTE_EGRESO]
AS

SELECT 
       v.Code CodigoComprobante,
       v.DocumentDate Fecha,
	   t.nit Documento,
	   t.Name Nombre,
	   vd.Value Valor,
	   a.BillNumber Factura,
	   a.Coments Detalle
	   

FROM Treasury.VoucherTransaction v
join Treasury.VoucherTransactionDetails vd on vd.IdVoucherTransaction = v.id
join Treasury.DischargeBill db on db.IdVoucherTransactionD = vd.id
join Payments.AccountPayable a on a.id= db.IdAccountPayable
join Common.ThirdParty t on t.id = v.IdThirdParty
  

