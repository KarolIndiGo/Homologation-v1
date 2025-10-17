-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_CUADRO_CONTROL_CONTABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_CUADRO_CONTROL_CONTABILIDAD] 
@ANO AS INT,
@MES AS INT
AS

--DECLARE @ANO as int = 2023;
--DECLARE @MES as int = 10;

WITH CTE_REVERSION_RECONOCIMIENTOS_UNICOS ---NUMERO 1---
AS
(
  SELECT DISTINCT  JV.Id,JV.Consecutive,JVT.Description,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.DebitValue-JVD.CreditValue) Valor_Debito--,JVD.IdThirdParty 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .MainAccounts as MA WITH (NOLOCK) ON MA.Id=JVD.IdMainAccount
  INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT ON JVT.Id =JV.IdJournalVoucher
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='ReverseRevenueRecognition' AND IdJournalVoucher =93 AND MA.Number like '4%'
  --and JV.EntityCode in ('IND161991','IND166671')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.Consecutive,JVT.Description--,JVD.IdThirdParty 
),

CTE_FACTURADOS_UNICOS ---NUMERO 2---
AS
(
  SELECT DISTINCT  JV.Id,JV.Consecutive,JVT.Description ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue-JVD.DebitValue) Valor_Credito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger.MainAccounts AS MA ON MA.ID=JVD.IdMainAccount
  INNER JOIN Billing .Invoice AS F  ON F.Id =JV.EntityId AND F.DocumentType <>5
  INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT ON JVT.Id =JV.IdJournalVoucher 
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND MA.Number between '41000000' and '69999999' AND jv.EntityName ='Invoice' AND IdJournalVoucher =29 
  --and JV.EntityCode in ('IND161039')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser ,JV.Consecutive,JVT.Description
),

CTE_FACTURADOS_UNICOS_CAPITADOS ---NUMERO 3---
AS
(
  SELECT DISTINCT  JV.Id,JV.Consecutive,JVT.Description,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT ON JVT.Id =JV.IdJournalVoucher
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1   AND jv.EntityName ='InvoiceEntityCapitated' AND IdJournalVoucher =29
  --and JV.EntityCode in ('IND161039')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser ,JV.Consecutive,JVT.Description
),

CTE_ANULADOS_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue ) Valor_Credito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='Invoice' AND IdJournalVoucher =30
  --and JV.EntityCode in ('IND161039')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),


CTE_ANULADOS_UNICOS_CAPITADOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.DebitValue ) Valor_Debito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='InvoiceEntityCapitated' AND IdJournalVoucher =30
  --and JV.EntityCode in ('IND161039')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),
CTE_FACTURA_BASICA_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='BasicBilling' AND IdJournalVoucher =90
  --and JV.EntityCode in ('IND161039')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),

CTE_NOTAS_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.DebitValue) Valor_Debito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =JVD.IdMainAccount
  INNER JOIN Portfolio.PortfolioNote AS PN WITH (NOLOCK) ON PN.ID=JV.EntityId AND PN.STATUS=2
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='PortfolioNote' AND IdJournalVoucher =10
  --AND (MA.Number BETWEEN '41' AND '41999999')
  --and JV.EntityCode in ('IND161039')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser
),

CTE_RECONOCIMIENTOS_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue-JVD.DebitValue) Valor_Credito--,JVD.IdThirdParty 
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .MainAccounts as MA WITH (NOLOCK) ON MA.Id=JVD.IdMainAccount
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='RevenueRecognition' AND IdJournalVoucher =92 AND MA.Number like '4%'
  --and JV.EntityCode in ('IND161991','IND166671')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE)--,JVD.IdThirdParty 
),


CTE_DATOS_CONSOLIDADOS AS
 (

--SELECT * FROM CTE_REVERSION_RECONOCIMIENTOS_UNICOS 

 SELECT '1. REVERSION RECONOCIMIENTO MES ANTERIOR' 'TIPO',(SUM(uni.Valor_Debito)*-1)  'VALOR TOTAL'
 FROM Billing.RevenueRecognition AS RR WITH (NOLOCK)
 INNER JOIN CTE_REVERSION_RECONOCIMIENTOS_UNICOS AS UNI WITH (NOLOCK) ON UNI.EntityId =RR.Id
 GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)

UNION ALL

 SELECT '2. FACTURACION TOTAL MES - SALUD' 'TIPO',SUM(UNI.Valor_Credito) 'VALOR TOTAL'   --SUM(I.TotalInvoice+I.ThirdPartyDiscountValue)  'VALOR TOTAL'--+I.ThirdPartyDiscountValue
    FROM Billing.Invoice AS I WITH (NOLOCK)
    INNER JOIN CTE_FACTURADOS_UNICOS AS UNI WITH (NOLOCK) ON UNI.EntityId =I.Id 
    INNER JOIN DBO.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
    INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
    INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
    INNER JOIN DBO.INPACIENT AS PAC  WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
    LEFT JOIN DBO.SEGusuaru AS USU WITH (NOLOCK) ON USU.CODUSUARI =UNI.CreationUser 
    GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)

 UNION ALL

  SELECT '3. FACTURACION TOTAL MES - PGP SALUD' 'TIPO',SUM(I.TotalInvoice)  'VALOR TOTAL'
   FROM Billing.Invoice AS I WITH (NOLOCK)
   INNER JOIN Billing.InvoiceEntityCapitated  IEC WITH (NOLOCK) ON IEC.InvoiceId =I.Id 
   INNER JOIN CTE_FACTURADOS_UNICOS_CAPITADOS AS UNI WITH (NOLOCK) ON UNI.EntityId =IEC.Id 
   LEFT JOIN DBO.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
   LEFT JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
   LEFT JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
   LEFT JOIN DBO.INPACIENT AS PAC  WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN DBO.SEGusuaru AS USU WITH (NOLOCK) ON USU.CODUSUARI =UNI.CreationUser 
   GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)

UNION ALL

SELECT '4. FACTURACION ANULADA TOTAL MES - SALUD' 'TIPO',(SUM(G.[VALOR TOTAL] )*-1)  'VALOR TOTAL' FROM
(
 SELECT '4. FACTURACION ANULADA TOTAL MES - SALUD' 'TIPO',(SUM(uni.Valor_Credito ))  'VALOR TOTAL'
    FROM Billing.Invoice AS I WITH (NOLOCK)
    INNER JOIN CTE_ANULADOS_UNICOS AS UNI WITH (NOLOCK) ON UNI.EntityId =I.Id 
    INNER JOIN DBO.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
    INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
    INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
    INNER JOIN DBO.INPACIENT AS PAC  WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
    LEFT JOIN DBO.SEGusuaru AS USU WITH (NOLOCK) ON USU.CODUSUARI =UNI.CreationUser 
  UNION
   SELECT '4. FACTURACION ANULADA TOTAL MES - SALUD' 'TIPO',(SUM(uni.Valor_Debito ))  'VALOR TOTAL'
   FROM Billing.Invoice AS I WITH (NOLOCK)
   INNER JOIN Billing.InvoiceEntityCapitated  IEC WITH (NOLOCK) ON IEC.InvoiceId =I.Id 
   INNER JOIN CTE_ANULADOS_UNICOS_CAPITADOS AS UNI WITH (NOLOCK) ON UNI.EntityId =IEC.Id 
   LEFT JOIN DBO.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
   LEFT JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
   LEFT JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
   LEFT JOIN DBO.INPACIENT AS PAC  WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN DBO.SEGusuaru AS USU WITH (NOLOCK) ON USU.CODUSUARI =UNI.CreationUser 
) AS G

UNION ALL

 SELECT '5. FACTURACION TOTAL MES - NO SALUD' 'TIPO',SUM(UNI.Valor_Credito)  'VALOR TOTAL'
    FROM Billing.BasicBilling AS I WITH (NOLOCK)
    INNER JOIN CTE_FACTURA_BASICA_UNICOS AS UNI WITH (NOLOCK) ON UNI.EntityId =I.Id 
	INNER JOIN Billing .Invoice AS F  WITH (NOLOCK) ON F.Id =I.InvoiceId 
    GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)

UNION ALL

 SELECT '6. NOTAS CREDITOS MES' 'TIPO',(SUM(JVD.DebitValue)*-1)  'VALOR TOTAL'
 FROM GeneralLedger .JournalVoucherDetails JVD
 INNER JOIN CTE_NOTAS_UNICOS UNI ON UNI.Id =JVD.IdAccounting 
 GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)
UNION ALL

 SELECT '7. RECONOCIMIENTO MES' 'TIPO',(SUM(uni.Valor_Credito ))  'VALOR TOTAL'
 FROM Billing.RevenueRecognition AS RR WITH (NOLOCK)
 INNER JOIN CTE_RECONOCIMIENTOS_UNICOS AS UNI WITH (NOLOCK) ON UNI.EntityId =RR.Id 
 GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)
)

SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 @ANO 'AÑO', @MES 'MES', *,
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
 CTE_DATOS_CONSOLIDADOS 
ORDER BY 
 TIPO 