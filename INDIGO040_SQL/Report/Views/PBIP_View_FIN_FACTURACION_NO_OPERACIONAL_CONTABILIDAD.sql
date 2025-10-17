-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: PBIP_View_FIN_FACTURACION_NO_OPERACIONAL_CONTABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[PBIP_View_FIN_FACTURACION_NO_OPERACIONAL_CONTABILIDAD] AS
SELECT 
 YEAR(JV.[VoucherDate])*10000 + MONTH(JV.[VoucherDate])*100 + DAY(JV.[VoucherDate]) ID_TIEMPO,
 CASE TP.PersonType WHEN 1 THEN 'NATURAL' when 2 then 'JURIDICO' end 'TIPO',
 TP.Nit NIT,
 TP.Name 'ENTIDAD',
 SUM(JVD.DebitValue)  'VALOR'
FROM 
 GeneralLedger .JournalVouchers JV
 INNER JOIN GeneralLedger .JournalVoucherDetails JVD ON JVD.IdAccounting =JV.Id 
 INNER JOIN Common .ThirdParty AS TP ON TP.Id =JVD.IdThirdParty 
 WHERE 
  EntityName ='BasicBilling'
 GROUP BY 
  YEAR(JV.[VoucherDate])*10000 + MONTH(JV.[VoucherDate])*100 + DAY(JV.[VoucherDate]),
  TP.Nit,
  TP.Name,
  TP.PersonType

