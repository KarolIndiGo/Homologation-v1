-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCarteraInformeFinal_Anticipos
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[ViewCarteraInformeFinal_Anticipos]
AS

  SELECT 
  PTD.AccountReceivableId,
  --AR.InvoiceNumber 'FACTURA',
  CAST(SUM(PTD.Value) AS NUMERIC) 'VALOR PAGOS A FACTURA' --PTD.PortfolioTrasferId ,
  FROM
  Portfolio.AccountReceivable AS AC  INNER JOIN
  Portfolio.PortfolioTransferDetail PTD ON AC.ID=PTD.AccountReceivableId INNER JOIN
  Portfolio.PortfolioTransfer AS CA ON PTD.PortfolioTrasferId = CA.Id /*IN V3*/ AND CA.Status=2 /*FN V3*/
--  WHERE AC.Balance >0
  GROUP BY PTD.AccountReceivableId
