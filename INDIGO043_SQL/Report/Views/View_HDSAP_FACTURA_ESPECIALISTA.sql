-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURA_ESPECIALISTA
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_FACTURA_ESPECIALISTA]
AS


select  
        pac.IPCODPACI Documento,
		pac.IPNOMCOMP NombrePaciente,
		(datediff (year,pac.IPFECNACI, getdate ())) Edad,
		i.InvoiceDate FechaFacturacion,
		i.InvoiceNumber Factura,
		INE.NOMENTIDA EPS



from Billing.Invoice i
INNER JOIN Billing.InvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId = I.Id 
INNER JOIN Billing.ServiceOrderDetail AS  SOD WITH (NOLOCK) ON SOD.Id = ID.ServiceOrderDetailId 
JOIN ADINGRESO a  WITH (NOLOCK) on  a.NUMINGRES = i.AdmissionNumber
JOIN INPACIENT pac WITH (NOLOCK) on pac.IPCODPACI = a.IPCODPACI
JOIN INENTIDAD INE ON INE.CODENTIDA = A.CODENTIDA
LEFT JOIN dbo.INPROFSAL AS MED WITH (NOLOCK) ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode

where sod.PerformsHealthProfessionalCode = 'me400'

