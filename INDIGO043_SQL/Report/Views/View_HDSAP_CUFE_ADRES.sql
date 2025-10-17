-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CUFE_ADRES
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_CUFE_ADRES]
AS


select h.Name Entidad,
       InvoiceNumber Factura,
       CUFE,
	   InvoiceDate [Fecha Factura],
	   AdmissionNumber Ingreso
	   
from Billing.Invoice b
join Contract.HealthAdministrator h on h.id = b.HealthAdministratorId
--where ThirdPartyId = '191853'



