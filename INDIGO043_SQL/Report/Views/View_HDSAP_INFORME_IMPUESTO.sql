-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INFORME_IMPUESTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_INFORME_IMPUESTO]
AS


 SELECT  

    CAST(jv.VoucherDate AS DATE) AS Fecha  
    ,JVT.Code + ' ' + JVT.Name AS 'Tipo de comprobante'  
    ,jv.Consecutive Consecutivo  
    ,CASE JV.EntityName  
   WHEN 'AccountPayable' THEN 'Cuenta por Pagar'  
   WHEN 'BasicBilling' THEN 'Factura básica'  
   WHEN 'CashReceipts' THEN 'Recibo de caja'  
   WHEN 'PaymentNotes' THEN 'Nota'  
   WHEN 'PayrollLiquidation' THEN 'Liquidación de nomina'  
   WHEN 'PortfolioNote' THEN 'Nota'  
   WHEN 'TreasuryNote' THEN 'Nota'  
   WHEN 'VoucherTransaction' THEN 'Egreso'  
   WHEN 'PortfolioTransfer' THEN 'Cruce de anticipo vs CxC'  
   WHEN 'PaymentTransfer' THEN 'Cruce de anticipo vs CxP'  
   WHEN 'PortfolioReclassification' THEN 'Reclasificación documento de cartera'  
   ELSE JVT.NAME 
  END + ' ' + ISNULL(jv.EntityCode, '') AS 'Documento Origen'  
    ,ma.Number AS 'Cuenta Contable' 
    ,ma.Name AS 'Nombre Cuenta Contable ' 
	,case tp.PersonType
	when 1
	then 'Persona Natural'
	when 2
	then 'Persona Juridica'
	END
	AS 'Tipo Persona'
	,case tp.RetentionType
	when 0 
	then 'Ninguna'
	when 1 
	then 'Exento de retencion'
	when 2
	then 'Hace Retencion'
	when 3 
	then 'Autoretenedor'
	end 'Tipo Retencion'
	,case tp.ContributionType
	when 0 
	then 'Simplificado'
	when 1 
	then 'Común'
	when 2 
	then 'Empresa estatal'
	when 3 
	then 'Gran Contribuyente'
	end 'Tipo Contribuyente'
    ,tp.Nit AS 'Nit Tercero'
    ,tp.Name AS 'Nombre Tercero'  
    ,jvd.DebitValue  Debitos
    ,jvd.CreditValue Creditos
    ,jvd.Detail  Detalle
    ,ISNULL(rc.Name, '') AS 'Nombre Concepto Retencion'
    ,ISNULL(jvd.RetentionRate, ISNULL(rc.Rate, 0)) AS Tarifa  
    ,IIF  
  (  
   ma.FreelancerCategory = 1 AND ISNULL(jvd.BillingValue, 0) > 0,  
   jvd.BillingValue,  
   ISNULL(CASE ISNULL(jvd.RetentionRate, ISNULL(rc.Rate, 0))  
    WHEN 0 THEN CAST(jvd.BaseValue AS BIGINT)  
    WHEN 1 THEN CAST(jvd.BaseValue AS BIGINT)  
    ELSE CAST(ROUND((ABS(jvd.DebitValue - jvd.CreditValue) * 100 / ISNULL(jvd.RetentionRate, rc.Rate)), 1) AS BIGINT)  
   END, 0)  
  ) * IIF(ma.Nature = 1, IIF(jvd.DebitValue >= jvd.CreditValue, 1, -1), IIF(jvd.CreditValue >= jvd.DebitValue, 1, -1)  
  ) AS Base  
  --,IIF  
  --(  
  -- ma.FreelancerCategory = 1 AND ISNULL(jvd.BillingValue, 0) > 0,  
  -- jvd.BillingValue,  
  -- jvd.BaseValue  
  --) AS BaseValue  
    ,CASE jv.Status  
   WHEN 1 THEN 'Registrado'  
   WHEN 2 THEN 'Confirmado'  
   WHEN 3 THEN 'Anulado'  
  END AS Estado  
 FROM GeneralLedger.JournalVouchers AS jv WITH (NOLOCK)  
 INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID = JV.IdJournalVoucher  
 JOIN GeneralLedger.JournalVoucherDetails AS jvd WITH (NOLOCK) ON jv.Id = jvd.IdAccounting  
 JOIN GeneralLedger.MainAccounts AS ma WITH (NOLOCK) ON ma.Id = jvd.IdMainAccount  
 JOIN GeneralLedger.MainAccountClasses AS mc WITH (NOLOCK) ON mc.Id = ma.IdAccountClass  
 LEFT JOIN Common.ThirdParty AS tp WITH (NOLOCK) ON tp.Id = jvd.IdThirdParty  
 LEFT JOIN GeneralLedger.RetentionConcepts AS rc WITH (NOLOCK) ON rc.Id = jvd.IdRetention  
 WHERE   
  jv.LegalBookId = 1   
  AND jv.Status = 2   
  AND ma.RetencionType <> 0  

  

