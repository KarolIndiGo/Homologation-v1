-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: PBIP_View_FIN_FACTURACION_CONTABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[PBIP_View_FIN_FACTURACION_CONTABILIDAD] AS

WITH CTE_FACTURACION_CONTABILIDAD AS
(
  SELECT
   'FACTURADO' ESTADO, 
   CASE TP.PersonType WHEN 1 THEN 'NATURAL' when 2 then 'JURIDICO' end 'TIPO',
   TP.Nit NIT,
   TP.Name 'ENTIDAD',
   SUM(JVD.CreditValue) 'VALOR', 
   YEAR(JV.[VoucherDate])*10000 + MONTH(JV.[VoucherDate])*100 + DAY(JV.[VoucherDate]) ID_TIEMPO
  FROM 
   GeneralLedger.JournalVouchers JV
   INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting =JV.Id 
   INNER JOIN Common .ThirdParty AS TP ON TP.Id =JVD.IdThirdParty 
  WHERE 
   EntityName ='Invoice' and 
   JV.LegalBookId ='1' and 
   IdJournalVoucher in (29) and jvd.CreditValue <> 0 
  GROUP BY 
   TP.Nit,
   TP.Name,
   TP.PersonType, 
   YEAR(JV.[VoucherDate])*10000 + MONTH(JV.[VoucherDate])*100 + DAY(JV.[VoucherDate])
  UNION ALL
  SELECT
   'ANULADOS' ESTADO, 
   CASE TP.PersonType WHEN 1 THEN 'NATURAL' when 2 then 'JURIDICO' end 'TIPO',
   TP.Nit NIT ,TP.Name 'ENTIDAD' ,SUM(JVD.DebitValue )*-1 'VALOR', 
   YEAR(JV.[VoucherDate])*10000 + MONTH(JV.[VoucherDate])*100 + DAY(JV.[VoucherDate]) ID_TIEMPO
  FROM 
   GeneralLedger .JournalVouchers JV
   INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting =JV.Id 
   INNER JOIN Common .ThirdParty AS TP ON TP.Id =JVD.IdThirdParty 
  WHERE
   EntityName ='Invoice' and JV.LegalBookId ='1' and IdJournalVoucher in (30) and jvd.DebitValue  <> 0
  GROUP BY 
   TP.Nit,
   TP.Name,
   TP.PersonType, 
   YEAR(JV.[VoucherDate])*10000 + MONTH(JV.[VoucherDate])*100 + DAY(JV.[VoucherDate])
)

SELECT 
 *
FROM CTE_FACTURACION_CONTABILIDAD 
