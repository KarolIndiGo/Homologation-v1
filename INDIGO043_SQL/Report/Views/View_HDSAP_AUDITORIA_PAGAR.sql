-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_AUDITORIA_PAGARÉ
-- Extracted by Fabric SQL Extractor SPN v3.9.0





/*******************************************************************************************************************
Nombre: Auditoria Pagare
Tipo:Vista
Observacion: Auditoria Pagare (Con las mejoras)
Profesional: Milton Urbano Bolañoz
Fecha:02-09-2025 (Modificació) _ Factura_Basica
-----------------------------------------------------------------*/







CREATE VIEW [Report].[View_HDSAP_AUDITORIA_PAGARÉ]
AS

select p.code CodigoPagaré,
       i.invoicenumber Factura,
	   i.patientcode Documento,
	   i.PatientPaidValue ValorPagaré, --- valor paciente 
	   ---p.value ValorPagaré, --- Valor entidad 
	   i.invoicedate FechaFactura,
	   i.InvoicedUser UsuarioCrea,
	   su.NOMUSUARI Usuario,
	   ad.numingres Ingreso,
	   ad.IFECHAING FechaIngreso,
	   case i.DocumentType
	   when 1 then 'Factura EAPB con Contrato'
	   when 2 then 'Factura EAPB Sin Contrato'
	   when 3 then 'Factura Particular'
	   end Tipofactura,
	   rc.Code ReciboCaja,
	   rc.DocumentDate FechaRecibo,
	   rc.Value ValorReciboCaja,
	   case rc.Status 
	   when 1 then 'registrado'
	   when 2 then 'Confirmado'
	   when 3 then 'Anulado' 
	   when 4 then 'Reversado' 
	   end 'EstadoRecibo',
	   rc.Detail DetalleRecibo,
	   case p.Status 
	   when 1 then 'Registrado'
	   when 2 then 'Confirmado'
	   when 3 then 'Anulado'
	   end EstadoPagaré
	  
       
from Portfolio.AccountReceivable p
join billing.invoice i on i.id = p.invoiceid
join ADINGRESO ad on ad.NUMINGRES = i.admissionnumber 
LEFT JOIN Portfolio.PortfolioAdvance  PD on pd.AdmissionNumber = i.AdmissionNumber
LEFT JOIN Treasury.CashReceipts rc on rc.Id = pd.CashReceiptId
LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
where  i.DocumentType in (1,2,3) 
	and i.PatientPaidValue <> 0
	---and i.InvoicedDate >= '2025-08-01' 

---order by InvoicedDate DESC

