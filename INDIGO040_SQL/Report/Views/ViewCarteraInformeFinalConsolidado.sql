-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCarteraInformeFinalConsolidado
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: [Report].[ViewCarteraInformeFinalConsolidado]
Tipo:View
Observacion: 
Profesional: 
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:06-11-2024
Observaciones: SE AGREGA EL CAMPO [FECHA DOCUMENTO CALCULADO], siguendo la logica de la vista VReportPortfolioByAge
--------------------------------------
Version 2
Persona que modifico:
Fecha: 
Observaciones:
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewCarteraInformeFinalConsolidado]
as
SELECT V.*,CAST(ISNULL(V2.[VALOR PAGOS A FACTURA],0) AS NUMERIC) [VALOR PAGOS A FACTURA] 
FROM REPORT.ViewCarteraInformeFinal V
LEFT JOIN REPORT.ViewCarteraInformeFinal_Anticipos AS V2 ON V.ID=V2.AccountReceivableId


--Portfolio.RadicateInvoiceC ri.ConfirmDate,
--Portfolio.AccountReceivable  ar.AccountReceivableDate
