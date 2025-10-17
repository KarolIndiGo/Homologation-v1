-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURA_ANULADA_VS_FACTURA_REEMPLAZO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_FACTURA_ANULADA_VS_FACTURA_REEMPLAZO]
AS


SELECT
    A.AdmissionNumber AS Ingreso,
    A.InvoiceNumber AS Factura_Anulada,
    A.InvoiceDate AS Fecha_Anulada,
    R.InvoiceNumber AS Factura_Reemplazo,
    R.InvoiceDate AS Fecha_Reemplazo

FROM
    Billing.Invoice AS A
    INNER JOIN Billing.Invoice AS R ON A.AdmissionNumber = R.AdmissionNumber
WHERE A.Status = 2 
      AND R.Status = 1



