-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_AUDITORIA_USUARIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_AUDITORIA_USUARIOS]
AS

select DISTINCT
       InvoiceNumber 'Numero Factura',
       i.InvoiceDate 'Fecha Factura',
	   i.AdmissionNumber 'Numero Ingreso',
	   ISNULL(cas.code, 'NO RECIBO' )'Código del recibo',
	   cas.DocumentDate 'Fecha Recibo',
	   so.OrderDate 'Fecha Prestacion Servicio',
	   i.InvoicedUser CodigoUsuario,
	   P.Fullname 'Nombre Facturador'


from Billing.invoice i
join billing.ServiceOrder so on so.AdmissionNumber = i.AdmissionNumber
join Billing.ServiceOrderDetail sod on sod.ServiceOrderId = so.id
LEFT JOIN  Portfolio.PortfolioAdvance POR ON POR.AdmissionNumber = i.AdmissionNumber
LEFT JOIN  Treasury.CashReceipts cas ON cas.id = por.CashReceiptId
INNER JOIN Security.[USER] us on us.UserCode = i.InvoicedUser
INNER JOIN Security.PERSON P ON P.ID = US.IdPerson

  

