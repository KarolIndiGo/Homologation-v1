-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_PBI_IND_FACTURACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [Report].[View_PBI_IND_FACTURACION] as

WITH CTE_RECONOCIMIENTOS_UNICOS AS
 (
  SELECT DISTINCT  
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)) VoucherDate,
   sum(JVD.CreditValue) Valor_Credito
  FROM 
   GeneralLedger.JournalVouchers JV 
   INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD ON JVD.IdAccounting =JV.Id
  WHERE 
   JV.LegalBookId = 1 AND 
   jv.EntityName ='RevenueRecognition' AND 
   IdJournalVoucher =92
  GROUP BY 
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE))
 ),

CTE_REVERSION_RECONOCIMIENTOS_UNICOS AS
(
  SELECT DISTINCT  
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)) VoucherDate,
   sum(JVD.DebitValue ) Valor_Debito
  FROM 
   GeneralLedger.JournalVouchers JV 
   INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD ON JVD.IdAccounting =JV.Id
  WHERE 
   JV.LegalBookId =1  AND 
   jv.EntityName ='ReverseRevenueRecognition' AND 
   IdJournalVoucher =93
  GROUP BY 
   JV.Id,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)),
   JV.EntityCode,
   JV.EntityId
),

CTE_FACTURADOS_UNICOS AS
(
  SELECT DISTINCT  
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)) VoucherDate,
   sum(JVD.CreditValue) Valor_Credito,
   JV.CreationUser 
  FROM 
   GeneralLedger.JournalVouchers JV 
   INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
   INNER JOIN GeneralLedger.JournalVoucherTypes JVT  ON JVT.Id = JV.IdJournalVoucher
   INNER JOIN Billing.Invoice AS F  ON F.Id =JV.EntityId
  WHERE 
   JV.LegalBookId =1 AND 
   jv.EntityName ='Invoice' AND 
   F.DocumentType <> 5 AND 
   IdJournalVoucher = 29
  GROUP BY 
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)),
   JV.CreationUser 
),

CTE_ANULADOS_UNICOS AS
 (
  SELECT DISTINCT  
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)) VoucherDate,
   sum(JVD.DebitValue) Valor_Debito,
   JV.CreationUser 
  FROM 
   GeneralLedger.JournalVouchers JV 
   INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
   INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT  ON JVT.Id =JV.IdJournalVoucher
   LEFT JOIN Billing.Invoice AS F  ON F.Id =JV.EntityId
  WHERE 
   JV.LegalBookId = 1 AND 
   jv.EntityName ='Invoice' AND 
   F.DocumentType <> 5 AND 
   IdJournalVoucher = 30
  GROUP BY 
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)),
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   JV.CreationUser 
 ),


CTE_FACTURADOS_UNICOS_CAPITADOS AS
 (
  SELECT DISTINCT  
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)) VoucherDate,
   sum(JVD.CreditValue) Valor_Credito,
   JV.CreationUser 
  FROM 
   GeneralLedger.JournalVouchers JV 
   INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
   INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT  ON JVT.Id =JV.IdJournalVoucher
   INNER JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =JVD.IdMainAccount

  WHERE 
   JV.LegalBookId = 1 AND 
   jv.EntityName = 'InvoiceEntityCapitated' AND 
   IdJournalVoucher = 29 AND
   MA.Number BETWEEN '41000000' AND '41999999'
  GROUP BY 
   JV.Id ,JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)),
   JV.CreationUser 
),


 CTE_ANULADOS_UNICOS_CAPITADOS AS
 (
  SELECT DISTINCT 
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)) VoucherDate,
   sum(JVD.DebitValue ) Valor_Debito,
   JV.CreationUser 
  FROM 
   GeneralLedger.JournalVouchers JV 
   INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JVD.IdAccounting =JV.Id
   INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT  ON JVT.Id =JV.IdJournalVoucher
   INNER JOIN GeneralLedger .MainAccounts AS MA  ON MA.Id =JVD.IdMainAccount
  WHERE 
   JV.LegalBookId = 1 AND 
   jv.EntityName ='InvoiceEntityCapitated' AND 
   IdJournalVoucher= 30 AND 
   MA.Number BETWEEN '41000000' AND '41999999'
  GROUP BY 
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)),
   JV.CreationUser 
 ),
 
 CTE_RECONOCIDO AS
 (
  SELECT 
   0 SODID,
   UNI.VoucherDate [ID_TIEMPO],
   CAST(I.InvoiceDate as date) [FECHA_SERVICIO],
   UNI.Valor_Credito [DET_VALOR_TOTAL],
   0 [DET_CANTIDAD],
   0 [DET_CUPS],
   I.HealthAdministratorId,
   '' EntityName,
   999999 ID_UFUN,
   0 [ID_ESPEC],
   'Reconocido' [FACTURADO]
  FROM 
   Billing.RevenueRecognition AS RR 
   INNER JOIN CTE_RECONOCIMIENTOS_UNICOS AS UNI ON UNI.Id = RR.JournalVoucherId ---14275159271.09000
   INNER JOIN GeneralLedger.JournalVouchers AS JV ON UNI.Id = JV.Id 
   INNER JOIN Billing.Invoice AS I ON JV.EntityId =I.Id 
),

 CTE_RECONOCIDO_REVERSADO AS
 (
  SELECT 
   0 SODID,
   UNI.VoucherDate [ID_TIEMPO],
   CAST(I.InvoiceDate as date) [FECHA_SERVICIO],
   uni.Valor_Debito * -1 [DET_VALOR_TOTAL],
   0 [DET_CANTIDAD],
   0 [DET_CUPS],
   I.HealthAdministratorId,
   '' EntityName,
   999999 UFUCODIGO,
   0 [ID_ESPEC],
   'Reversado' [FACTURADO]
  FROM 
   Billing.RevenueRecognition AS RR 
   INNER JOIN CTE_REVERSION_RECONOCIMIENTOS_UNICOS AS UNI ON UNI.Id =RR.JournalVoucherReverseId ---14275159271.09000
   INNER JOIN GeneralLedger.JournalVouchers AS JV ON UNI.Id = JV.Id 
   INNER JOIN Billing.Invoice AS I ON JV.EntityId =I.Id 
),

CTE_DETALLE AS 
 (
  SELECT
   SOD.Id,
   VoucherDate [ID_TIEMPO],
   SOD.ServiceDate [FECHA_SERVICIO],
   ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) [DET_VALOR_TOTAL],
   SOD.InvoicedQuantity [DET_CANTIDAD],
   ISNULL(SOD.CUPSEntityId,0) [DET_CUPS],
   I.HealthAdministratorId,
   SO.EntityName,
   FU.Code [ID_UFUN],
   MED.CODESPEC1 [ID_ESPEC],
   'Si' [FACTURADO]
  FROM
   Billing.Invoice AS I
   INNER JOIN CTE_FACTURADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
   INNER JOIN Billing.InvoiceDetail AS ID ON ID.InvoiceId =I.Id 
   INNER JOIN Billing.ServiceOrderDetail AS SOD ON SOD.Id =ID.ServiceOrderDetailId
   INNER JOIN Billing .ServiceOrder AS SO ON SO.Id =SOD.ServiceOrderId 
   INNER JOIN Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
   INNER JOIN Payroll.CostCenter AS COST ON COST.Id =SOD.CostCenterId
   INNER JOIN dbo.ADINGRESO AS ING ON ING.NUMINGRES =I.AdmissionNumber 
   INNER JOIN Common .ThirdParty AS TP ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract .CareGroup AS CG ON CG.Id =I.CareGroupId 
   INNER JOIN dbo.INPACIENT AS PAC ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN Billing.InvoiceDetailSurgical AS IDS ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
   LEFT JOIN DBO.SEGusuaru AS USU ON USU.CODUSUARI = UNI.CreationUser 
   LEFT JOIN dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   ),

CTE_ANULADOS AS
 (
  SELECT 
   SOD.Id,
   VoucherDate [ID_TIEMPO],
   CAST (SOD.ServiceDate as date) [FECHA_SERVICIO],
   ((ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice))*-1) [DET_VALOR_TOTAL],
   SOD.InvoicedQuantity [DET_CANTIDAD],
   ISNULL(SOD.CUPSEntityId,0) [DET_CUPS],
   I.HealthAdministratorId,
   SO.EntityName,
   FU.Code [ID_UFUN],
   MED.CODESPEC1 [ID_ESPEC],
   'Si' [FACTURADO]
  FROM
   Billing.Invoice AS I 
   INNER JOIN CTE_ANULADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
   INNER JOIN Billing.InvoiceDetail AS ID  ON ID.InvoiceId =I.Id 
   INNER JOIN Billing.ServiceOrderDetail AS SOD   ON SOD.Id =ID.ServiceOrderDetailId
   INNER JOIN Billing.ServiceOrder AS SO  ON SO.Id =SOD.ServiceOrderId
   INNER JOIN Payroll.FunctionalUnit AS FU  ON FU.Id = SOD.PerformsFunctionalUnitId
   INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
   INNER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   INNER JOIN Common.ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract.CareGroup AS CG   ON CG.Id =I.CareGroupId 
   INNER JOIN DBO.INPACIENT AS PAC  ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN Billing .InvoiceDetailSurgical AS IDS	ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'   
   LEFT JOIN dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = MED.CODESPEC1
),

CTE_CAPITA AS
 (
  SELECT
   0 SODID,
   VoucherDate [ID_TIEMPO],
   CAST(I.InvoiceDate as date) [FECHA_SERVICIO],
   I.TotalInvoice [DET_VALOR_TOTAL],
   0 [DET_CANTIDAD],
   0 [DET_CUPS],
   I.HealthAdministratorId,
   '' EntityName,
   999999 UFUCODIGO,
   0 [ID_ESPEC],
   'Capita' [FACTURADO]
  FROM  
   Billing.Invoice AS I 
   INNER JOIN Billing.InvoiceEntityCapitated  IEC  ON IEC.InvoiceId =I.Id 
   INNER JOIN CTE_FACTURADOS_UNICOS_CAPITADOS AS UNI  ON UNI.EntityId =IEC.Id 
 ),

CTE_ANULADOS_CAPITA AS 
 (
  SELECT
   0 SODID,
   VoucherDate [FECHA DE SERVICIO],
   CAST(I.InvoiceDate as date) [FECHA_SERVICIO],
   uni.Valor_Debito * -1 [DET_VALOR_TOTAL],
   0 [DET_CANTIDAD],
   0 [DET_CUPS],
   I.HealthAdministratorId,
   '' EntityName,
   999999 UFUCODIGO,
   0 [ID_ESPEC],
   'Capita' [FACTURADO]
  FROM Billing.Invoice AS I 
   INNER JOIN Billing.InvoiceEntityCapitated  IEC  ON IEC.InvoiceId =I.Id 
   INNER JOIN CTE_ANULADOS_UNICOS_CAPITADOS AS UNI  ON UNI.EntityId =IEC.Id 
   LEFT JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   LEFT JOIN Common .ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   LEFT JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   LEFT JOIN DBO.INPACIENT AS PAC   ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN DBO.SEGusuaru AS USU  ON USU.CODUSUARI =UNI.CreationUser 
  ),

CTE_PENDIENTE AS (
 SELECT 
  SOD.Id,
  (YEAR(CONVERT(DATE,CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1))) * 100) + MONTH(CONVERT(DATE,CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1))) [ID_TIEMPO],
  CAST (SOD.ServiceDate as date) [FECHA_SERVICIO],
  sod.GrandTotalSalesPrice [DET_VALOR_TOTAL],
  sod.InvoicedQuantity [DET_CANTIDAD],
  ISNULL(sod.CUPSEntityId,0) [DET_CUPS],
  RCD.HealthAdministratorId,
  SO.EntityName,
  FU.Code [ID_UFUN],
  MED.CODESPEC1 [ID_ESPEC],
  'No' [FACTURADO]
 FROM 
  Contract.CareGroup cg 
  INNER JOIN Billing.RevenueControlDetail rcd  ON cg.Id = rcd.CareGroupId
  INNER JOIN Billing.RevenueControl rc on rc.Id = rcd.RevenueControlId
  INNER JOIN Billing.ServiceOrderDetailDistribution sodd  on sodd.RevenueControlDetailId = rcd.Id
  INNER JOIN Billing.ServiceOrderDetail sod  on sodd.ServiceOrderDetailId = sod.Id
  INNER JOIN Billing.ServiceOrder AS SO  ON SO.Id =SOD.ServiceOrderId
  INNER JOIN Payroll.FunctionalUnit fu  on fu.Id = sod.PerformsFunctionalUnitId
  INNER JOIN Common .ThirdParty AS TP  ON TP.Id =RCD.ThirdPartyId
  INNER JOIN DBO.INPACIENT AS PAC  ON PAC.IPCODPACI =SO.PatientCode
  INNER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =RC.AdmissionNumber
  INNER JOIN Payroll.CostCenter AS COST  ON COST.Id =SOD.CostCenterId
  LEFT JOIN dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = MED.CODESPEC1
 WHERE 
  rcd.Status in (1,3) AND 
  sod.IsDelete = 0 AND 
  sod.SettlementType != 3 AND 
  sod.GrandTotalSalesPrice > 0 AND 
  cg.LiquidationType In (1, 3) and iNG.IESTADOIN IN (' ', 'P')
),

CTE_TOTAL_FACTURACION AS (
  SELECT * FROM CTE_RECONOCIDO
  UNION ALL
  SELECT * FROM CTE_RECONOCIDO_REVERSADO
  UNION ALL
  SELECT * FROM CTE_DETALLE
  UNION ALL
  SELECT * FROM CTE_ANULADOS
  UNION ALL
  SELECT * FROM CTE_CAPITA
  UNION ALL
  SELECT * FROM CTE_ANULADOS_CAPITA
  UNION ALL
  SELECT * FROM CTE_PENDIENTE
 )

 SELECT
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
  [ID_TIEMPO] [ID_TIEMPO],
  SUM([DET_VALOR_TOTAL]) [DET_VALOR_TOTAL],
  SUM([DET_CANTIDAD]) [DET_CANTIDAD],
  COUNT (DISTINCT [DET_CUPS]) [DET_CUPS],
  RTRIM(HA.Name) [ENTIDAD],
  CASE WHEN F.EntityName = 'ServiceOrder' THEN 'MANUAL' ELSE 'STELLA' END TIPO_RECONOCIMIENTO,
  CONVERT(int, LTRIM(RTRIM(ISNULL(F.ID_UFUN,0)))) [ID_UFUN],
  CONVERT(int, LTRIM(RTRIM(ISNULL(F.[ID_ESPEC],0)))) [ID_ESPEC],
  [FACTURADO],
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM
  CTE_TOTAL_FACTURACION F
  INNER JOIN Contract.HealthAdministrator AS HA  ON HA.Id =F.HealthAdministratorId
 GROUP BY
  [ID_TIEMPO],
  RTRIM(HA.Name),
  CASE WHEN F.EntityName = 'ServiceOrder' THEN 'MANUAL' ELSE 'STELLA' END,
  CONVERT(int, LTRIM(RTRIM(ISNULL(F.ID_UFUN,0)))) ,
  CONVERT(int, LTRIM(RTRIM(ISNULL(F.[ID_ESPEC],0)))),
  [FACTURADO]

  --ORDER BY 1

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Report].[View_PBI_IND_FACTURACION]') AND type in (N'U'))
--DROP EXTERNAL TABLE [Report].[View_PBI_IND_FACTURACION]
--GO

--CREATE EXTERNAL TABLE [Report].[View_PBI_IND_FACTURACION]
--(
--	[ID_COMPANY] [varchar](9) NULL,
--	[ID_TIEMPO] [int] NULL,
--	[DET_VALOR_TOTAL] [numeric](38, 5) NULL,
--	[DET_CANTIDAD] [int] NULL,
--	[DET_CUPS] [int] NULL,
--	[ENTIDAD] [varchar](300) NULL,
--	[TIPO_RECONOCIMIENTO] [varchar](6) NOT NULL,
--	[ID_UFUN] [int] NULL,
--	[ID_ESPEC] [int] NULL,
--	[FACTURADO] [varchar](10) NOT NULL,
--	[ULT_ACTUAL] [datetime] NULL
--)
--WITH (DATA_SOURCE = [INDIGO040],SCHEMA_NAME = N'Report',OBJECT_NAME = N'View_PBI_IND_FACTURACION')
--GO
