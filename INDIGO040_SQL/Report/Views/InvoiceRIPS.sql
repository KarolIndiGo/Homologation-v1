-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: InvoiceRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.InvoiceRIPS AS

SELECT
'HOSPITAL SAN JOSE' AS EMPRESA,
case ep.StatusRIPS WHEN 1 then 'Registrado'
				   WHEN 2 then 'Validado'
				   WHEN 3 then 'Erroneo' END [ESTADO RIPS],
EP.CREATIONDATE AS [FECHA CREACION RIPTS],
CASE fac.[Status] WHEN 1 THEN 'Facturado'
				  WHEN 2 THEN 'Anulado' END AS [ESTADO FACTURA],
FAC.InvoiceNumber [NUMERO FACTURA],
FAC.TotalInvoice [TOTAL FACTURA],
FAC.InvoiceDate AS [FECHA FACTURA]
FROM 
Billing.ElectronicsProperties ep
INNER JOIN Billing.Invoice fac on ep.EntityId=fac.Id and ep.EntityName='Invoice'
INNER JOIN  Billing.ElectronicsRIPS rip on ep.Id = rip.ElectronicsPropertiesId
