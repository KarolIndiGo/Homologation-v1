-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Billing_FacturacionDetallada_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_Billing_FacturacionDetallada_2025] AS
SELECT * FROM [ViewInternal].[IMO_Billing_FacturacionDetallada]
WHERE YEAR([Fecha Factura])='2025'