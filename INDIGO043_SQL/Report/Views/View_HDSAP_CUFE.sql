-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CUFE
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_CUFE]
AS


select 'Tipo de documento' 'Factura electrónica',
       I.CUFE,
	   InvoiceNumber Factura,
	   InvoiceDate [Fecha Emisión],
	   E.ShippingDate [Fecha Recepción],
	   '891180134' 'NIT Emisor' ,
	   'HOSPITAL DEPARTAMENTAL SAN ANTONIO DE PITALITO' 'Nombre Emisor' ,
	   T.NIT 'NIT Receptor',
	   T.NAME 'Nombre Receptor',
	   I.TotalValue Total

	   
from Billing.Invoice I
JOIN Billing.ElectronicDocument E ON CONCAT(Prefix,DocumentNumber) = I.InvoiceNumber
JOIN Common.ThirdParty T ON T.ID = I.ThirdPartyId
 




