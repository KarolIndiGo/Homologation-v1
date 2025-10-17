-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURA
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_FACTURA]
AS

Select InvoiceDate FF,
       InvoiceNumber Factura,
	   AdmissionNumber Ingreso,
	   ine.NOMENTIDA Entidad
from billing.Invoice i
join ADINGRESO a on a.NUMINGRES = i.AdmissionNumber
join INENTIDAD ine on ine.CODENTIDA = a.CODENTIDA
where i.Status = 1


