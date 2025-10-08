-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_NOTASCARTERA_FACTURACIONELECTRONICA
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_NOTASCARTERA_FACTURACIONELECTRONICA] AS 


select distinct( nc.Id) as IdNota,  nc.Code AS Nota, nc.NoteDate AS Fecha, 
nc.Observations AS Observaciones, CASE nc.Nature WHEN '1' THEN 'Debito' WHEN '2' THEN 'Credito' END AS Tipo, 
CASE
WHEN nc.Nature=1 AND fa.ConceptId=1 THEN 'Intereses'
WHEN nc.Nature=1 AND fa.ConceptId=2 THEN 'Gastos por cobrar'
WHEN nc.Nature=1 AND fa.ConceptId=3 THEN 'Cambio del valor'
WHEN nc.Nature=2 AND fa.ConceptId=1 THEN 'Devolución o no aceptación de partes del servicio'
WHEN nc.Nature=2 AND fa.ConceptId=2 THEN 'Anulación de factura electrónica'
WHEN nc.Nature=2 AND fa.ConceptId=3 THEN 'Rebaja total aplicada'
WHEN nc.Nature=2 AND fa.ConceptId=4 THEN 'Descuento total aplicado'
WHEN nc.Nature=2 AND fa.ConceptId=5 THEN 'Rescisión: nulidad por falta de requisitos'
WHEN nc.Nature=2 AND fa.ConceptId=6 THEN 'Otros'
END AS ConcetoCXC,
 e.ConsecutivoDian, ar.InvoiceNumber as Factura, NaturalezaFE,
		   [Estado Nota DIAN], [Estado Envio DIAN]
from INDIGO031.Portfolio.PortfolioNote as nc 
inner join INDIGO031.Portfolio.PortfolioNoteAccountReceivableAdvance as fa on fa.PortfolioNoteId = nc.Id
inner join INDIGO031.Portfolio.AccountReceivable as ar on ar.Id = fa.AccountReceivableId
left outer join (
SELECT
distinct(bn.Code) as ConsecutivoDian,
InvoiceNumber,  CASE bn.Nature WHEN 1 THEN 'Debito' when 2 then 'Credito' end as NaturalezaFE, 
CASE ed.Status 
			 WHEN 0 THEN 'Invalida' 
			 WHEN 1 THEN 'Registrada' 
			 WHEN 2 THEN 'Enviada y Recibida' 
			 WHEN 3 THEN 'Validada' 
			 WHEN 4 THEN 'Validacion Fallida' 
			 WHEN 99 THEN 'Pendiente - Proc. Validacion' 
			 WHEN 88 THEN 'Pendiente - Proc. Envio' 
			 when 77 then 'No Procesa - Dif. Version'  END AS [Estado Nota DIAN],  
			
			 CASE A.Status WHEN 0 THEN 'Fallido' WHEN 1 THEN 'Exitoso' ELSE '' END AS [Estado Envio DIAN],
			 bn.EntityId
 FROM	INDIGO031.Billing.BillingNote	bn	
 INNER JOIN INDIGO031.Billing.BillingNoteDetail	bnd	 on	bnd.BillingNoteId=bn.Id	
 INNER JOIN INDIGO031.Billing.ElectronicDocument	ed	 on	ed.EntityId=bn.Id	and ed.EntityName='BillingNote'
 INNER JOIN (
					select  ElectronicDocumentId, max(Id) as max_Id
					from    INDIGO031.Billing.ElectronicDocumentDetail  AS T 
					group by  T.ElectronicDocumentId ) as R on  R.ElectronicDocumentId= ed.Id
LEFT OUTER JOIN INDIGO031.Billing.ElectronicDocumentDetail AS A ON A.Id= R.max_Id

WHERE  year(bn.NoteDate)>='2021') as e on e.EntityId=nc.Id
where year(nc.NoteDate)>='2021'  --and nc.code='0000002760'
--order by ar.InvoiceNumber
