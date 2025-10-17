-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_CUADRO_CONTROL_PROYECCION_CONTABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre:[Report].[IND_SP_V2_ERP_CUADRO_CONTROL_PROYECCION_CONTABILIDAD] 
Tipo:Procedimiento Almacenado
Observacion: 
Profesional: Ing. Andres Cabrera
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:15-11-2023
Ovservaciones: Se ajusta el procedimiento almacenado para que funcione en otras instituciones.
--------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:01-03-2023
Ovservaciones: Se ajusta la logica del CTE_DATOS_CONSOLIDADOS en el tipo 5, para que no la llave principal entre la tabla de reconocimiento
			  y la tabla de contabilización sea entityID.
***********************************************************************************************************************************/

CREATE PROCEDURE [Report].[IND_SP_V2_ERP_CUADRO_CONTROL_PROYECCION_CONTABILIDAD] 
AS

WITH CTE_REVERSION_RECONOCIMIENTOS_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.DebitValue ) Valor_Debito--,JVD.IdThirdParty 
  FROM GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  WHERE  YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND MONTH(JV.VoucherDate)=MONTH(COMMON.GETDATE ())
  AND JV.LegalBookId =1 AND jv.EntityName ='ReverseRevenueRecognition' AND IdJournalVoucher =93
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE)--,JVD.IdThirdParty 
),

CTE_FACTURADOS_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger.JournalVoucherTypes JVT  ON JVT.Id = JV.IdJournalVoucher
  INNER JOIN Billing.Invoice AS F  ON F.Id =JV.EntityId
  WHERE  YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND MONTH(JV.VoucherDate)=MONTH(COMMON.GETDATE ())
  --cast(JV.VoucherDate as date) between -- '2023-08-01' AND '2023-08-31'
  --IIF(day(COMMON.GETDATE())=1,cast(COMMON.GETDATE () as date), DATEADD(DAY,(day(COMMON.GETDATE())-1)*-1,cast(COMMON.GETDATE () as date))) and cast(COMMON.GETDATE () as date) 
  AND F.DocumentType <> 5 and JV.LegalBookId =1   AND jv.EntityName ='Invoice' AND IdJournalVoucher =29
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),
CTE_ANULADOS_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.DebitValue ) Valor_Debito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  LEFT JOIN Billing .Invoice AS F  ON F.Id =JV.EntityId
  WHERE  YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND MONTH(JV.VoucherDate)=MONTH(COMMON.GETDATE ())
  --cast(JV.VoucherDate as date) between -- '2023-08-01' AND '2023-08-31'
  --IIF(day(COMMON.GETDATE())=1,cast(COMMON.GETDATE () as date), DATEADD(DAY,(day(COMMON.GETDATE())-1)*-1,cast(COMMON.GETDATE () as date))) and cast(COMMON.GETDATE () as date) 
  AND F.DocumentType <> 5 AND JV.LegalBookId =1 AND jv.EntityName ='Invoice' AND IdJournalVoucher =30
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),

CTE_FACTURADOS_UNICOS_CAPITADOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT  ON JVT.Id =JV.IdJournalVoucher
  INNER JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =JVD.IdMainAccount
  WHERE YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND MONTH(JV.VoucherDate)=MONTH(COMMON.GETDATE ())
  --cast(JV.VoucherDate as date) between -- '2023-08-01' AND '2023-08-31'
  --IIF(day(COMMON.GETDATE())=1,cast(COMMON.GETDATE () as date), DATEADD(DAY,(day(COMMON.GETDATE())-1)*-1,cast(COMMON.GETDATE () as date))) and cast(COMMON.GETDATE () as date) 
  AND JV.LegalBookId =1   AND jv.EntityName ='InvoiceEntityCapitated' AND IdJournalVoucher =29 AND MA.Number BETWEEN '41000000' AND '41999999'
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),

CTE_ANULADOS_UNICOS_CAPITADOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.DebitValue ) Valor_Debito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT  ON JVT.Id =JV.IdJournalVoucher
  INNER JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =JVD.IdMainAccount
  WHERE  YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND MONTH(JV.VoucherDate)=MONTH(COMMON.GETDATE ())
  --cast(JV.VoucherDate as date) between -- '2023-08-01' AND '2023-08-31'
  --IIF(day(COMMON.GETDATE())=1,cast(COMMON.GETDATE () as date), DATEADD(DAY,(day(COMMON.GETDATE())-1)*-1,cast(COMMON.GETDATE () as date))) and cast(COMMON.GETDATE () as date) 
  AND JV.LegalBookId =1 AND jv.EntityName ='InvoiceEntityCapitated' AND IdJournalVoucher =30 AND MA.Number BETWEEN '41000000' AND '41999999'
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),
CTE_FACTURA_BASICA_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.CreditValue) Valor_Credito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  WHERE  YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND MONTH(JV.VoucherDate)=MONTH(COMMON.GETDATE ())
  --cast(JV.VoucherDate as date) between -- '2023-08-01' AND '2023-08-31'
  --IIF(day(COMMON.GETDATE())=1,cast(COMMON.GETDATE () as date), DATEADD(DAY,(day(COMMON.GETDATE())-1)*-1,cast(COMMON.GETDATE () as date))) and cast(COMMON.GETDATE () as date) 
  AND JV.LegalBookId =1 AND jv.EntityName ='BasicBilling' AND IdJournalVoucher =90
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),

CTE_NOTAS_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,sum(JVD.DebitValue) Valor_Debito,JV.CreationUser 
  FROM GeneralLedger.JournalVouchers JV 
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =JVD.IdMainAccount
  INNER JOIN Portfolio.PortfolioNote AS PN  ON PN.ID=JV.EntityId AND PN.STATUS=2
  WHERE  YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND MONTH(JV.VoucherDate)=MONTH(COMMON.GETDATE ())
  --cast(JV.VoucherDate as date) between --'2023-08-01' AND '2023-08-31'
  --IIF(day(COMMON.GETDATE())=1,cast(COMMON.GETDATE () as date), DATEADD(DAY,(day(COMMON.GETDATE())-1)*-1,cast(COMMON.GETDATE () as date))) and cast(COMMON.GETDATE () as date) 
  AND JV.LegalBookId =1   AND jv.EntityName ='PortfolioNote' AND IdJournalVoucher =10 --AND (MA.Number BETWEEN '41' AND '41999999')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser 
),

CTE_RECONOCIMIENTOS_UNICOS AS
 (
  SELECT 
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   CAST(JV.VoucherDate AS DATE) VoucherDate,
   sum(JVD.CreditValue) Valor_Credito
  FROM 
   GeneralLedger.JournalVouchers JV 
   INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
  WHERE  
   YEAR(JV.VoucherDate) = YEAR(COMMON.GETDATE ()) AND 
   MONTH(JV.VoucherDate) = MONTH(COMMON.GETDATE ()) AND 
   JV.LegalBookId = 1 AND 
   jv.EntityName ='RevenueRecognition' AND 
   IdJournalVoucher = 92
  GROUP BY 
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   CAST(JV.VoucherDate AS DATE)
 ),

CTE_PENDIENTE_RECONOCER
AS

(
SELECT sum(sod.GrandTotalSalesPrice) 'Valor Total'

  FROM Contract.CareGroup cg 
            JOIN Billing.RevenueControlDetail rcd  ON cg.Id = rcd.CareGroupId
            JOIN Billing.RevenueControl rc on rc.Id = rcd.RevenueControlId  ----**** MODIFICACION
			inner join dbo.ADINGRESO i on i.NUMINGRES = rc.AdmissionNumber  ----**** MODIFICACION
            --JOIN [Contract].ContractAccountingStructure cas on cas.Id = @contractAccountingStructureId
            JOIN Billing.ServiceOrderDetailDistribution sodd  on sodd.RevenueControlDetailId = rcd.Id
            JOIN Billing.ServiceOrderDetail sod  on sodd.ServiceOrderDetailId = sod.Id
            JOIN Payroll.FunctionalUnit f  on f.Id = sod.PerformsFunctionalUnitId
            JOIN Contract.CUPSEntity ce  on sod.CUPSEntityId = ce.Id
            JOIN Billing.BillingConcept bc  on ce.BillingConceptId = bc.Id
            WHERE --cg.Id = @CareGroupId And 
            rcd.Status in (1,3) AND sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND cg.LiquidationType In (1, 3) and i.IESTADOIN IN (' ', 'P')--rcd.Id = 189993

UNION ALL

SELECT sum(sod.GrandTotalSalesPrice) 'Valor Total'

   FROM Contract.CareGroup cg
            JOIN Billing.RevenueControlDetail rcd  ON cg.Id = rcd.CareGroupId
            JOIN Billing.RevenueControl rc on rc.Id = rcd.RevenueControlId  ----**** MODIFICACION
			inner join dbo.ADINGRESO i on i.NUMINGRES = rc.AdmissionNumber  ----**** MODIFICACION
           -- JOIN [Contract].ContractAccountingStructure cas on cas.Id = @contractAccountingStructureId
            JOIN Billing.ServiceOrderDetailDistribution sodd  on sodd.RevenueControlDetailId = rcd.Id
            JOIN Billing.ServiceOrderDetail sod  on sodd.ServiceOrderDetailId = sod.Id
            JOIN Inventory.InventoryProduct ip  on sod.ProductId = ip.Id
            JOIN Inventory.ProductGroup pg  ON ip.ProductGroupId = pg.Id
            WHERE --cg.Id = @CareGroupId And 
            rcd.Status in (1,3) AND sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND cg.LiquidationType In (1, 3) and i.IESTADOIN IN (' ', 'P')--rcd.Id = 189993
),

CTE_DATOS_CONSOLIDADOS
AS
(

--SELECT * FROM CTE_REVERSION_RECONOCIMIENTOS_UNICOS 

 SELECT '1. REVERSION RECONOCIMIENTO MES ANTERIOR' 'TIPO',(SUM(uni.Valor_Debito)*-1)  'VALOR TOTAL'
 FROM Billing.RevenueRecognition AS RR 
 INNER JOIN CTE_REVERSION_RECONOCIMIENTOS_UNICOS AS UNI  ON UNI.EntityId =RR.Id 
 GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)

UNION ALL

SELECT '2. FACTURACION TOTAL MES ACTUAL - SALUD' 'TIPO',SUM(G.[VALOR TOTAL] )  'VALOR TOTAL' FROM 
(
 SELECT '2. FACTURACION TOTAL MES ACTUAL - SALUD' 'TIPO',SUM(I.TotalInvoice)  'VALOR TOTAL'
    FROM Billing.Invoice AS I 
    INNER JOIN CTE_FACTURADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
    INNER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
    INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
    INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
    INNER JOIN DBO.INPACIENT AS PAC   ON PAC.IPCODPACI =I.PatientCode
    LEFT JOIN DBO.SEGusuaru AS USU  ON USU.CODUSUARI =UNI.CreationUser 
    GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)
 UNION 
  SELECT '2. FACTURACION TOTAL MES ACTUAL - SALUD' 'TIPO',SUM(I.TotalInvoice)  'VALOR TOTAL'
   FROM Billing.Invoice AS I 
   INNER JOIN Billing.InvoiceEntityCapitated  IEC  ON IEC.InvoiceId =I.Id 
   INNER JOIN CTE_FACTURADOS_UNICOS_CAPITADOS AS UNI  ON UNI.EntityId =IEC.Id 
   LEFT JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   LEFT JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   LEFT JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   LEFT JOIN DBO.INPACIENT AS PAC   ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN DBO.SEGusuaru AS USU  ON USU.CODUSUARI =UNI.CreationUser 
   GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)
) AS G

UNION ALL

SELECT '3. FACTURACION ANULADA TOTAL MES ACTUAL - SALUD' 'TIPO',(SUM(G.[VALOR TOTAL] )*-1)  'VALOR TOTAL' FROM
(
 SELECT '3. FACTURACION ANULADA TOTAL MES ACTUAL - SALUD' 'TIPO',(SUM(uni.Valor_Debito))  'VALOR TOTAL'
    FROM Billing.Invoice AS I 
    INNER JOIN CTE_ANULADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
    INNER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
    INNER JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
    INNER JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
    INNER JOIN DBO.INPACIENT AS PAC   ON PAC.IPCODPACI =I.PatientCode
    LEFT JOIN DBO.SEGusuaru AS USU  ON USU.CODUSUARI =UNI.CreationUser 
  UNION
   SELECT '3. FACTURACION ANULADA TOTAL MES ACTUAL - SALUD' 'TIPO',(SUM(uni.Valor_Debito))  'VALOR TOTAL'
   FROM Billing.Invoice AS I 
   INNER JOIN Billing.InvoiceEntityCapitated  IEC  ON IEC.InvoiceId =I.Id 
   INNER JOIN CTE_ANULADOS_UNICOS_CAPITADOS AS UNI  ON UNI.EntityId =IEC.Id 
   LEFT JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   LEFT JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   LEFT JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   LEFT JOIN DBO.INPACIENT AS PAC   ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN DBO.SEGusuaru AS USU  ON USU.CODUSUARI =UNI.CreationUser 
) AS G

UNION ALL

 SELECT '4. FACTURACION TOTAL MES - NO SALUD' 'TIPO',SUM(UNI.Valor_Credito)  'VALOR TOTAL'
    FROM Billing.BasicBilling AS I 
    INNER JOIN CTE_FACTURA_BASICA_UNICOS AS UNI  ON UNI.EntityId =I.Id 
	INNER JOIN Billing .Invoice AS F   ON F.Id =I.InvoiceId 
    GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)

UNION ALL

 SELECT '5. NOTAS CREDITOS MES ACTUAL' 'TIPO',(SUM(JVD.DebitValue)*-1)  'VALOR TOTAL'
 FROM GeneralLedger .JournalVoucherDetails JVD 
 INNER JOIN CTE_NOTAS_UNICOS UNI ON UNI.Id =JVD.IdAccounting 
 GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)

UNION ALL

 SELECT '6. PROYECCION RECONOCIMIENTO MES ACTUAL' 'TIPO', SUM([Valor Total]) 'VALOR TOTAL' FROM CTE_PENDIENTE_RECONOCER 


)


SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 *,
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
 CTE_DATOS_CONSOLIDADOS 
ORDER BY TIPO 



