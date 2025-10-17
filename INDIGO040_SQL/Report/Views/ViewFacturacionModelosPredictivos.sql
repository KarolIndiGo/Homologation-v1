-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewFacturacionModelosPredictivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [Report].[ViewFacturacionModelosPredictivos] as
WITH CTE_FACTURADOS_UNICOS AS
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
  WHERE 
   JV.LegalBookId = 1 AND 
   jv.EntityName ='Invoice' AND 
   IdJournalVoucher =29
  GROUP BY 
   JV.Id ,JV.EntityCode,
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
   INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting =JV.Id
  WHERE 
   JV.LegalBookId =1 AND 
   jv.EntityName ='Invoice' AND 
   IdJournalVoucher =30
  GROUP BY 
   YEAR(CAST(JV.VoucherDate AS DATE)) * 100 + MONTH(CAST(JV.VoucherDate AS DATE)),
   JV.Id,
   JV.EntityCode,
   JV.EntityId,
   JV.CreationUser 
 ),

CTE_DETALLE AS 
 (
  SELECT
   YEAR(SO.OrderDate) 'AÑO',
   MONTH(SO.OrderDate) 'MES',
   I.HealthAdministratorId,
   ING.NUMINGRES INGRESO,
   SO.Id 'ID_ORDEN',
   CAST(SO.OrderDate AS DATE) 'FECHA ORDEN',
   CAST(SOD.ServiceDate AS DATE) AS 'FECHA SERVICIO',
   SOD.InvoicedQuantity 'CANTIDAD',
   SOD.TotalSalesPrice 'VLR_UNITARIO',
   SOD.GrandTotalSalesPrice 'VLR_TOTAL',
   ISNULL(SOD.CUPSEntityId,0) 'DET_CUPS',
   ISNULL(SOD.ProductId,0) 'DET_PROD',
   ISNULL(SOD.IPSServiceId,0) 'DET_SERV',  
   SOD.CostCenterId,
   SOD.RecordType,
   'Si' [FACTURADO]
  FROM
   Billing.Invoice AS I 
   JOIN Billing.InvoiceDetail AS ID  ON I.ID =ID.InvoiceId
   JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id = ID.ServiceOrderDetailId 
   JOIN Billing.ServiceOrder AS SO ON SO.Id =SOD.ServiceOrderId 
   JOIN Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
   JOIN CTE_FACTURADOS_UNICOS AS UNI ON UNI.EntityId =I.Id 
   JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES =I.AdmissionNumber 
   JOIN Common .ThirdParty AS TP ON TP.Id =I.ThirdPartyId 
   JOIN Contract .CareGroup AS CG ON CG.Id =I.CareGroupId 
   JOIN DBO.INPACIENT AS PAC  ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN DBO.SEGusuaru AS USU ON USU.CODUSUARI =UNI.CreationUser 
   LEFT JOIN dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
 ),

 CTE_ANULADOS AS
 (
  SELECT 
   YEAR(SO.OrderDate) 'AÑO',
   MONTH(SO.OrderDate) 'MES',
   I.HealthAdministratorId,
   ING.NUMINGRES,
   SO.Id 'ID_ORDEN',
   CAST(SO.OrderDate AS DATE) 'FECHA ORDEN',
   CAST(SOD.ServiceDate AS DATE) AS 'FECHA DE SERVICIO',
   SOD.InvoicedQuantity 'CANTIDAD',
   SOD.TotalSalesPrice 'VLR_UNITARIO',
   SOD.GrandTotalSalesPrice*(-1) 'VLR_TOTAL',
   ISNULL(SOD.CUPSEntityId,0) 'DET_CUPS',
   ISNULL(SOD.ProductId,0) 'DET_PROD',
   ISNULL(SOD.IPSServiceId,0) 'DET_SERV',   
   SOD.CostCenterId,
   SOD.RecordType,
   'Si' [FACTURADO]
  FROM
   Billing.Invoice AS I --91.375.415
   JOIN Billing.InvoiceDetail AS ID  ON I.ID =ID.InvoiceId
   JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id = ID.ServiceOrderDetailId 
   JOIN Billing.ServiceOrder AS SO ON SO.Id =SOD.ServiceOrderId 
   JOIN Payroll.FunctionalUnit AS FU ON FU.Id = SOD.PerformsFunctionalUnitId
   JOIN CTE_ANULADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
   JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
   JOIN Common.ThirdParty AS TP  ON TP.Id =I.ThirdPartyId 
   JOIN Contract .CareGroup AS CG  ON CG.Id =I.CareGroupId 
   JOIN DBO.INPACIENT AS PAC   ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN DBO.SEGusuaru AS USU  ON USU.CODUSUARI =UNI.CreationUser
   LEFT JOIN dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = MED.CODESPEC1
),

CTE_PENDIENTE1 AS (
 SELECT 
  YEAR(SO.OrderDate) 'AÑO',
  MONTH(SO.OrderDate) 'MES',
  RCD.HealthAdministratorId,
  RC.ADMISSIONNUMBER,
  SO.Id 'ID_ORDEN',
  CAST(SO.OrderDate AS DATE) 'FECHA ORDEN',
  CAST(SOD.ServiceDate AS DATE) AS 'FECHA DE SERVICIO',
  SOD.InvoicedQuantity 'CANTIDAD',
  SOD.TotalSalesPrice 'VLR_UNITARIO',
  SOD.GrandTotalSalesPrice 'VLR_TOTAL',
  ISNULL(SOD.CUPSEntityId,0) 'DET_CUPS',
  ISNULL(SOD.ProductId,0) 'DET_PROD',
  ISNULL(SOD.IPSServiceId,0) 'DET_SERV',   
  SOD.CostCenterId,
  SOD.RecordType,
  'No' [FACTURADO]
 FROM 
  Contract.CareGroup cg
  JOIN Billing.RevenueControlDetail rcd ON cg.Id = rcd.CareGroupId
  JOIN BILLING.REVENUECONTROL AS RC ON RCD.REVENUECONTROLID = RC.ID
  JOIN Billing.ServiceOrderDetailDistribution sodd on sodd.RevenueControlDetailId = rcd.Id
  JOIN Billing.ServiceOrderDetail sod on sodd.ServiceOrderDetailId = sod.Id
  JOIN Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId 
  JOIN Payroll.FunctionalUnit FU on FU.Id = sod.PerformsFunctionalUnitId
  JOIN Contract.CUPSEntity ce on sod.CUPSEntityId = ce.Id
  JOIN Billing.BillingConcept bc on ce.BillingConceptId = bc.Id
  LEFT JOIN dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = MED.CODESPEC1
 WHERE 
  rcd.Status in (1,3) AND 
  sod.IsDelete = 0 AND 
  sod.SettlementType != 3 AND 
  sod.GrandTotalSalesPrice > 0 AND 
  cg.LiquidationType In (1, 3)
),

CTE_PENDIENTE2 AS (
 SELECT 
  YEAR(SO.OrderDate) 'AÑO',
  MONTH(SO.OrderDate) 'MES',
  RCD.HealthAdministratorId,
  RC.ADMISSIONNUMBER,
  SO.Id 'ID_ORDEN',
  CAST(SO.OrderDate AS DATE) 'FECHA ORDEN',
  CAST(SOD.ServiceDate AS DATE) AS 'FECHA DE SERVICIO',
  SOD.InvoicedQuantity 'CANTIDAD',
  SOD.TotalSalesPrice 'VLR_UNITARIO',
  SOD.GrandTotalSalesPrice 'VLR_TOTAL',
  ISNULL(SOD.CUPSEntityId,0) 'DET_CUPS',
  ISNULL(SOD.ProductId,0) 'DET_PROD',
  ISNULL(SOD.IPSServiceId,0) 'DET_SERV',   
  SOD.CostCenterId,
  SOD.RecordType,
  'No' [FACTURADO]
 FROM 
  Contract.CareGroup cg
  JOIN Billing.RevenueControlDetail rcd ON cg.Id = rcd.CareGroupId
  JOIN BILLING.REVENUECONTROL AS RC ON RCD.REVENUECONTROLID = RC.ID
  JOIN Billing.ServiceOrderDetailDistribution sodd on sodd.RevenueControlDetailId = rcd.Id
  JOIN Billing.ServiceOrderDetail sod on sodd.ServiceOrderDetailId = sod.Id
  JOIN Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId 
  JOIN Payroll.FunctionalUnit FU on FU.Id = sod.PerformsFunctionalUnitId
  JOIN Inventory.InventoryProduct ip on sod.ProductId = ip.Id
  JOIN Inventory.ProductGroup pg ON ip.ProductGroupId = pg.Id
  LEFT JOIN dbo.INPROFSAL AS MED ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED ON ESPMED.CODESPECI = MED.CODESPEC1
 WHERE 
  rcd.Status in (1,3) AND 
  sod.IsDelete = 0 AND 
  sod.SettlementType != 3 AND 
  sod.GrandTotalSalesPrice > 0 AND 
  cg.LiquidationType In (1, 3)
),

CTE_TOTAL as 
(
  SELECT * FROM CTE_DETALLE  
  UNION ALL
  SELECT * FROM CTE_ANULADOS
  UNION ALL
  SELECT * FROM CTE_PENDIENTE1 
  UNION ALL
  SELECT * FROM CTE_PENDIENTE2
)

SELECT 
 --COUNT(1) --312.586
 --SUM(VLR_TOTAL)
 T.[AÑO],
 T.[MES],
 RTRIM(HA.Name) [ENTIDAD],
 T.INGRESO,
 ING.IPCODPACI 'ID_PACIENTE',
 LTRIM(RTRIM(PAC.IPNOMCOMP)) 'PACIENTE',
 T.[ID_ORDEN],
 CAST(T.[FECHA ORDEN] as date) 'FECHA ORDEN',
 CAST (ING.IFECHAING as date) 'FECHA_ING',
 CONVERT(varchar, CAST (ING.IFECHAING as time),8) 'HORA_ING',
 CAST (ING.FECHEGRESO as date) 'FECHA_EGR',
 CONVERT(varchar, CAST (ING.FECHEGRESO as time),8) 'HORA_EGR',
 T.[FECHA SERVICIO],
 CONCAT(ISNULL(RTRIM(IPS.Code),RTRIM(IPR.CODE)) , '-' , SUBSTRING(ISNULL(RTRIM(IPS.Name),RTRIM(IPR.NAME)),1,60)) 'CONCEPTO',
 ISNULL(CUPS.Code,'N/A') 'CODIGO',
 SUBSTRING(ISNULL(RTRIM(CUPS.Description),'N/A'),1,60) 'DESCRIPCION',
 T.CANTIDAD,
 T.VLR_UNITARIO,
 T.VLR_TOTAL,
 ISNULL(GF.Name, GF2.Name) AS 'CLASE_SERVICIO',
 CONCAT(COST.Code, '-' , RTRIM(COST.Name)) 'CENTRO_COSTO',
 CONCAT(DIA.CODDIAGNO , '-' , DIA.NOMDIAGNO) AS 'DIAGNOSTICO',
 CASE T.RecordType WHEN 1 THEN 'Servicios' 
					WHEN 2 THEN 'Medicamentos' ELSE 'N/A' END 'TIPO_SERVICIO'
FROM 
 CTE_TOTAL T
 INNER JOIN Contract.HealthAdministrator AS HA  ON HA.Id = T.HealthAdministratorId
 INNER JOIN ADINGRESO AS ING ON ING.NUMINGRES = T.INGRESO
 INNER JOIN INPACIENT AS PAC ON PAC.IPCODPACI = ING.IPCODPACI
 LEFT JOIN Contract.CUPSEntity AS CUPS ON CUPS.Id = T.[DET_CUPS]
 LEFT JOIN Payroll.CostCenter AS COST ON COST.Id = T.CostCenterId
 LEFT JOIN Inventory.InventoryProduct AS IPR ON IPR.Id = T.[DET_PROD]
 LEFT JOIN Contract.IPSService AS IPS ON IPS.Id = T.[DET_SERV]
 LEFT JOIN Billing.BillingGroup AS GF ON GF.Id = CUPS.BillingGroupId
 LEFT JOIN Billing.BillingGroup AS GF2 ON GF2.Id = IPR.BillingGroupId
 LEFT JOIN INDIAGNOS AS DIA ON  ING.CODDIAING = DIA.CODDIAGNO
