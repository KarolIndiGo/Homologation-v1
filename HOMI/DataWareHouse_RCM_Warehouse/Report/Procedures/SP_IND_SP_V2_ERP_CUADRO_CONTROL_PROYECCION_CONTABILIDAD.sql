-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_IND_SP_V2_ERP_CUADRO_CONTROL_PROYECCION_CONTABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   PROCEDURE [Report].[SP_IND_SP_V2_ERP_CUADRO_CONTROL_PROYECCION_CONTABILIDAD]
AS

DECLARE @ID_COMPANY VARCHAR(9) =(CAST(DB_NAME() AS VARCHAR(9)));

DECLARE @LegalBookA INT,
@ReverseRevenueRecognition INT,
@LegalBookB INT,
@Invoice INT,
@Anulacion INT,
@Notas INT,
@Reconocido INT 

IF @ID_COMPANY = 'INDIGO036' BEGIN
SET
  @LegalBookA = 2
SET
  @ReverseRevenueRecognition = 54
SET
  @LegalBookB = 1
SET
  @Invoice = 116
SET
  @Anulacion = 14
SET
  @Notas = 21
SET
  @Reconocido = 53
END --HOMI
IF @ID_COMPANY = 'INDIGO043' BEGIN
SET
  @LegalBookA = 1
SET
  @ReverseRevenueRecognition = 61
SET
  @LegalBookB = 1
SET
  @Invoice = 27
SET
  @Anulacion = 26
SET
  @Notas = 12
SET
  @Reconocido = 46
END;

--San Antonio de Pitalito
--select * from GeneralLedger.LegalBook
--SELECT * FROM  GeneralLedger.JournalVouchers WHERE LegalBookId=2 AND EntityName ='RevenueRecognition'
--select * from GeneralLedger.JournalVoucherTypes WHERE id=53
WITH CTE_REVERSION_RECONOCIMIENTOS_UNICOS AS (
  SELECT
    DISTINCT JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE) VoucherDate,
    sum(JVD.DebitValue) Valor_Debito --,JVD.IdThirdParty 
  FROM
    INDIGO036.GeneralLedger.JournalVouchers JV
    INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
  WHERE
    cast(JV.VoucherDate as date) between --'2024-02-01' AND '2024-02-29'
    IIF(
      day(GETDATE()) = 1,
      cast(GETDATE () as date),
      DATEADD(
        DAY,
(day(GETDATE()) -1) * -1,
        cast(GETDATE () as date)
      )
    )
    and cast(GETDATE () as date)
    AND JV.LegalBookId = @LegalBookA
    AND JV.EntityName = 'ReverseRevenueRecognition'
    AND IdJournalVoucher = @ReverseRevenueRecognition --and JV.EntityCode in ('IND161991','IND166671')
  GROUP BY
    JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE) --,JVD.IdThirdParty 
),
CTE_FACTURADOS_UNICOS AS (
  SELECT
    DISTINCT JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE) VoucherDate,
    sum(JVD.CreditValue) Valor_Credito,
    JV.CreationUser
  FROM
    INDIGO036.GeneralLedger.JournalVouchers JV
    INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
  WHERE
    cast(JV.VoucherDate as date) between -- '2023-08-01' AND '2023-08-31'
    IIF(
      day(GETDATE()) = 1,
      cast(GETDATE () as date),
      DATEADD(
        DAY,
(day(GETDATE()) -1) * -1,
        cast(GETDATE () as date)
      )
    )
    and cast(GETDATE () as date)
    AND JV.LegalBookId = @LegalBookB
    AND JV.EntityName = 'Invoice'
    AND IdJournalVoucher = @Invoice --and JV.EntityCode in ('IND161039')
  GROUP BY
    JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE),
    JV.CreationUser
),
CTE_ANULADOS_UNICOS AS (
  SELECT
    DISTINCT JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE) VoucherDate,
    sum(JVD.DebitValue) Valor_Debito,
    JV.CreationUser
  FROM
    INDIGO036.GeneralLedger.JournalVouchers JV
    INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
  WHERE
    cast(JV.VoucherDate as date) between -- '2023-08-01' AND '2023-08-31'
    IIF(
      day(GETDATE()) = 1,
      cast(GETDATE () as date),
      DATEADD(
        DAY,
(day(GETDATE()) -1) * -1,
        cast(GETDATE () as date)
      )
    )
    and cast(GETDATE () as date)
    AND JV.LegalBookId = @LegalBookB
    AND JV.EntityName = 'Invoice'
    AND IdJournalVoucher = @Anulacion --and JV.EntityCode in ('IND161039')
  GROUP BY
    JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE),
    JV.CreationUser
),
CTE_NOTAS_UNICOS AS (
  SELECT
    DISTINCT JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE) VoucherDate,
    sum(JVD.DebitValue) Valor_Debito,
    JV.CreationUser
  FROM
    INDIGO036.GeneralLedger.JournalVouchers JV
    INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
    INNER JOIN INDIGO036.GeneralLedger.MainAccounts AS MA ON MA.Id = JVD.IdMainAccount
  WHERE
    cast(JV.VoucherDate as date) between --'2024-02-01' AND '2024-02-29'
    IIF(
      day(GETDATE()) = 1,
      cast(GETDATE () as date),
      DATEADD(
        DAY,
(day(GETDATE()) -1) * -1,
        cast(GETDATE () as date)
      )
    )
    and cast(GETDATE () as date)
    AND JV.LegalBookId = @LegalBookB
    AND JV.EntityName = 'PortfolioNote'
    AND IdJournalVoucher = @Notas
    AND (
      MA.Number BETWEEN '41'
      AND '41999999'
    ) --and JV.EntityCode in ('IND161039')
  GROUP BY
    JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE),
    JV.CreationUser
),
CTE_RECONOCIMIENTOS_UNICOS AS (
  SELECT
    DISTINCT JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE) VoucherDate,
    sum(JVD.CreditValue) Valor_Credito --,JVD.IdThirdParty 
  FROM
    INDIGO036.GeneralLedger.JournalVouchers JV
    INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails AS JVD ON JVD.IdAccounting = JV.Id
  WHERE
    cast(JV.VoucherDate as date) between --'2023-08-01' AND '2023-08-31'
    IIF(
      day(GETDATE()) = 1,
      cast(GETDATE () as date),
      DATEADD(
        DAY,
(day(GETDATE()) -1) * -1,
        cast(GETDATE () as date)
      )
    )
    and cast(GETDATE () as date)
    AND JV.LegalBookId = @LegalBookB
    AND JV.EntityName = 'RevenueRecognition'
    AND IdJournalVoucher = @Reconocido --and JV.EntityCode in ('IND161991','IND166671')
  GROUP BY
    JV.Id,
    JV.EntityCode,
    JV.EntityId,
    CAST(JV.VoucherDate AS DATE) --,JVD.IdThirdParty 
),
CTE_PENDIENTE_RECONOCER AS (
  SELECT
    sum(sod.GrandTotalSalesPrice) 'Valor Total'
  FROM
    INDIGO036.Contract.CareGroup cg
    JOIN INDIGO036.Billing.RevenueControlDetail rcd ON cg.Id = rcd.CareGroupId --JOIN [Contract].ContractAccountingStructure cas on cas.Id = @contractAccountingStructureId
    JOIN INDIGO036.Billing.ServiceOrderDetailDistribution sodd on sodd.RevenueControlDetailId = rcd.Id
    JOIN INDIGO036.Billing.ServiceOrderDetail sod on sodd.ServiceOrderDetailId = sod.Id
    JOIN INDIGO036.Payroll.FunctionalUnit f on f.Id = sod.PerformsFunctionalUnitId
    JOIN INDIGO036.Contract.CUPSEntity ce on sod.CUPSEntityId = ce.Id
    JOIN INDIGO036.Billing.BillingConcept bc on ce.BillingConceptId = bc.Id
  WHERE
    --cg.Id = @CareGroupId And 
    rcd.Status in (1, 3)
    AND sod.IsDelete = 0
    AND sod.SettlementType != 3
    AND sod.GrandTotalSalesPrice > 0
    AND cg.LiquidationType In (1, 3) --rcd.Id = 189993
  UNION
  ALL
  SELECT
    sum(sod.GrandTotalSalesPrice) 'Valor Total'
  FROM
    INDIGO036.Contract.CareGroup cg
    JOIN INDIGO036.Billing.RevenueControlDetail rcd ON cg.Id = rcd.CareGroupId -- JOIN [Contract].ContractAccountingStructure cas on cas.Id = @contractAccountingStructureId
    JOIN INDIGO036.Billing.ServiceOrderDetailDistribution sodd on sodd.RevenueControlDetailId = rcd.Id
    JOIN INDIGO036.Billing.ServiceOrderDetail sod on sodd.ServiceOrderDetailId = sod.Id
    JOIN INDIGO036.Inventory.InventoryProduct ip on sod.ProductId = ip.Id
    JOIN INDIGO036.Inventory.ProductGroup pg ON ip.ProductGroupId = pg.Id
  WHERE
    --cg.Id = @CareGroupId And 
    rcd.Status in (1, 3)
    AND sod.IsDelete = 0
    AND sod.SettlementType != 3
    AND sod.GrandTotalSalesPrice > 0
    AND cg.LiquidationType In (1, 3) --rcd.Id = 189993
),
CTE_DATOS_CONSOLIDADOS AS (
  --SELECT * FROM CTE_REVERSION_RECONOCIMIENTOS_UNICOS 
  SELECT
    '1. REVERSION RECONOCIMIENTO MES ANTERIOR' 'TIPO',
(SUM(UNI.Valor_Debito) * -1) 'VALOR TOTAL'
  FROM
    INDIGO036.Billing.RevenueRecognition AS RR
    INNER JOIN CTE_REVERSION_RECONOCIMIENTOS_UNICOS AS UNI ON UNI.EntityId = RR.Id
  GROUP BY
    YEAR(UNI.VoucherDate),
    MONTH(UNI.VoucherDate)
  UNION
  ALL
  SELECT
    '2. FACTURACION TOTAL MES ACTUAL' 'TIPO',
    SUM(I.TotalInvoice) 'VALOR TOTAL'
  FROM
    INDIGO036.Billing.Invoice AS I
    INNER JOIN CTE_FACTURADOS_UNICOS AS UNI ON UNI.EntityId = I.Id
    INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = I.AdmissionNumber
    INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = I.ThirdPartyId
    INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = I.CareGroupId
    INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode
    LEFT JOIN INDIGO036.dbo.SEGusuaru AS USU ON USU.CODUSUARI = UNI.CreationUser
  GROUP BY
    YEAR(UNI.VoucherDate),
    MONTH(UNI.VoucherDate)
  UNION
  ALL
  SELECT
    '3. FACTURACION ANULADA TOTAL MES ACTUAL' 'TIPO',
(SUM(UNI.Valor_Debito) * -1) 'VALOR TOTAL'
  FROM
    INDIGO036.Billing.Invoice AS I
    INNER JOIN CTE_ANULADOS_UNICOS AS UNI ON UNI.EntityId = I.Id
    INNER JOIN INDIGO036.dbo.ADINGRESO AS ING ON ING.NUMINGRES = I.AdmissionNumber
    INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id = I.ThirdPartyId
    INNER JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = I.CareGroupId
    INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode
    LEFT JOIN INDIGO036.dbo.SEGusuaru AS USU ON USU.CODUSUARI = UNI.CreationUser
  UNION
  ALL
  SELECT
    '4. NOTAS CREDITOS MES ACTUAL' 'TIPO',
(SUM(JVD.DebitValue) * -1) 'VALOR TOTAL'
  FROM
    INDIGO036.GeneralLedger.JournalVoucherDetails JVD
    INNER JOIN CTE_NOTAS_UNICOS UNI ON UNI.Id = JVD.IdAccounting
  GROUP BY
    YEAR(UNI.VoucherDate),
    MONTH(UNI.VoucherDate) --UNION ALL
    -- SELECT '4. RECONOCIMIENTO MES ACTUAL' 'TIPO',SUM(RRD.GrandTotalSalesPrice)  'VALOR TOTAL'
    -- FROM Billing.RevenueRecognition AS RR 
    -- INNER JOIN CTE_RECONOCIMIENTOS_UNICOS AS UNI  ON UNI.Id =RR.JournalVoucherId
    -- INNER JOIN Billing .RevenueRecognitionDetail AS RRD  ON RRD.RevenueRecognitionId =RR.Id
    -- INNER JOIN Contract .CareGroup AS CG  ON CG.Id =RR.CareGroupId 
    -- LEFT JOIN Billing .ServiceOrderDetail AS SOD  ON SOD.Id =RRD.ServiceOrderDetailId 
    -- LEFT JOIN Billing .ServiceOrder AS SO  ON SO.Id =SOD.ServiceOrderId
    -- LEFT JOIN Billing .RevenueControlDetail AS RCD ON RCD.Id =RRD.RevenueControlDetailId 
    -- LEFT JOIN Billing .RevenueControl AS RC ON RC.Id =RCD.RevenueControlId
    -- LEFT JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES =ISNULL(SO.AdmissionNumber,RC.AdmissionNumber)
    -- LEFT JOIN dbo.INPACIENT AS PAC  ON PAC.IPCODPACI =ISNULL(SO.PatientCode,RC.PatientCode)
    -- LEFT JOIN Contract .Contract AS CON   ON CON.Id =CG.ContractId 
    -- LEFT JOIN Contract.HealthAdministrator AS HA  ON HA.Id =CON.HealthAdministratorId 
    -- LEFT JOIN Common .ThirdParty AS TP  ON TP.Id =ISNULL(HA.ThirdPartyId,RRD.ThirdPartySalesPrice  )
    -- GROUP BY YEAR(UNI.VoucherDate),MONTH(UNI.VoucherDate)
  UNION
  ALL
  SELECT
    '5. PROYECCION RECONOCIMIENTO MES ACTUAL' 'TIPO',
    SUM([Valor Total]) 'VALOR TOTAL'
  FROM
    CTE_PENDIENTE_RECONOCER
)
SELECT
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
  *,
  CONVERT(
    DATETIME,
    GETDATE() AT TIME ZONE 'Pakistan Standard Time',
    1
  ) AS ULT_ACTUAL
FROM
  CTE_DATOS_CONSOLIDADOS
ORDER BY
  TIPO