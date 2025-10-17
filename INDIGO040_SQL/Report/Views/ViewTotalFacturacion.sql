-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewTotalFacturacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [Report].[ViewTotalFacturacion] AS
 SELECT 
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
  ((YEAR(CAST(JV.VoucherDate AS DATE))  * 100) + MONTH(CAST(JV.VoucherDate AS DATE))) [ID_TIEMPO_VENTAS],
  jv.EntityName, 
  IdJournalVoucher,
  SUM(JVD.CreditValue) Valor_Credito,
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM 
  GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  INNER JOIN Billing.Invoice AS F  ON F.Id =JV.EntityId AND F.DocumentType <> 5
 WHERE 
  JV.LegalBookId = 1 AND jv.EntityName  IN ('Invoice', 'InvoiceEntityCapitated') 
 GROUP BY
  ((YEAR(CAST(JV.VoucherDate AS DATE))  * 100) + MONTH(CAST(JV.VoucherDate AS DATE))),
  jv.EntityName, 
  IdJournalVoucher