-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Factura_Producto_DocElectronico
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[FQ45_V_INN_Factura_Producto_DocElectronico] as 
SELECT o.UnitName as UnidadOperativa, fp.Code as CodigoFacturaProducto, fp.ConfirmationDate as Fecha, fp.TotalValue as Total,case fp.Status when 1 then 'Registrado' when 2 then 'Confirmado'
when 3 then 'Anulado' end as EstadoFacturaProducto,InvoiceNumber as Factura, DOC.NumDocumentoElectronico, doc.FechaDocumento, doc.Naturaleza, DocumentoOrigen, sum(doc.ValorNota) as ValorNota, Concepto
, case when cc.NumDocumento is not null then cc.NumDocumento else nc.NotaCxC end as [Nota/CContable]
FROM Inventory.DocumentInvoiceProductSales as fp 
INNER JOIN Billing.Invoice as i on fp.InvoiceId=i.id
INNER JOIN Common.OperatingUnit as o on o.id=fp.OperatingUnitId 
LEFT OUTER JOIN 
(-- Documento Electronico
select n.code as NumDocumentoElectronico, n.NoteDate as FechaDocumento, case n.Nature when 1 then 'Debito' when 2 then 'Credito' end as Naturaleza, 
 n.EntityId as IdDOrigen, case n.EntityName when 'PortfolioNote' then 'Notas CxC' when 'DocumentInvoiceProductSales' then 'FacturaProducto' end as DocumentoOrigen, 
 nd.InvoiceId as IdFactura, nd.AdjusmentValue as ValorNota, case when n.Nature=1 and nd.ConceptId=1 then 'Intereses' when  n.Nature=1 and nd.ConceptId=2 then 'Gastos por cobrar'
 when  n.Nature=1 and nd.ConceptId=3 then 'Cambio del valor'  when  n.Nature=2 and nd.ConceptId=1 then 'Devolución o no aceptación de partes del servicio' 
  when  n.Nature=2 and nd.ConceptId=2 then 'Anulación de factura electrónica'  when  n.Nature=2 and nd.ConceptId=3 then 'Rebaja total aplicada' 
  when  n.Nature=2 and nd.ConceptId=4 then 'Descuento total aplicado'   when  n.Nature=2 and nd.ConceptId=5 then 'Rescisión: nulidad por falta de requisitos' 
   when  n.Nature=2 and nd.ConceptId=6 then 'Otros' end as Concepto, case when n.EntityName='PortfolioNote' THEN InvoiceNumber ELSE PR.CODE end as Documento
from Billing.BillingNote as n 
inner join Billing.BillingNoteDetail as nd on nd.BillingNoteId=n.Id
inner join Common.OperatingUnit as u on u.id=n.OperatingUnitId
left outer join Inventory.DocumentInvoiceProductSales as pr on pr.id=n.EntityId
--left outer join Billing.Invoice as fac on fac.id=n.EntityId
where year(n.NoteDate)>=2021 and n.Nature=2) AS DOC ON DOC.IdFactura=I.ID
LEFT OUTER JOIN 
(-- Cc Anulacion CxC
select CONCAT(tp.code,'-',jv.Consecutive) as NumDocumento, jv.EntityCode as Documento
from GeneralLedger.JournalVouchers as jv
inner join GeneralLedger.JournalVoucherTypes as tp on tp.id=jv.IdJournalVoucher
where jv.IdJournalVoucher=30 and year(jv.ConfirmationDate)>=2021) AS CC ON CC.Documento=doc.Documento
LEFT OUTER JOIN 
(---- Notas Cartera
SELECT u.UnitName as UnidadOperativa, n.code as NotaCxC, n.ConfirmationDate as FechaNotaCxC, case n.Nature when 1 then 'Debito' when 2 then 'Credito' end as Naturaleza, 
acr.InvoiceNumber as Factura, AdjusmentValue as ValorNota
FROM Portfolio.PortfolioNote as n 
--inner join Portfolio.PortfolioNoteDetail as nd on nd.PortfolioNoteId=n.Id
inner join Common.OperatingUnit as u on u.id=n.OperatingUnitId
inner join Portfolio.PortfolioNoteAccountReceivableAdvance as pnd on pnd.PortfolioNoteId=n.Id
inner join Portfolio.AccountReceivable as acr on acr.id=pnd.AccountReceivableId
where year(n.NoteDate)>=2021 and n.Nature=2) AS NC ON NC.Factura=DOC.Documento
where year(fp.DocumentDate)>=2021 --and fp.Status=3
group by o.UnitName, fp.Code, fp.ConfirmationDate, fp.TotalValue , fp.Status, InvoiceNumber, DOC.NumDocumentoElectronico,doc.FechaDocumento, doc.Naturaleza, DocumentoOrigen, Concepto, cc.NumDocumento,nc.NotaCxC
--and InvoiceNumber='FQE31200'
-- and n.EntityId='14715'

-- and n.id='2885'
--group by u.UnitName, n.code, n.NoteDate, n.Nature, acr.InvoiceNumber

-- and jv.EntityCode='014715' 


