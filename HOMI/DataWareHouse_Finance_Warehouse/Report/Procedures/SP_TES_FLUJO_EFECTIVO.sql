-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: SP_TES_FLUJO_EFECTIVO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   PROCEDURE [Report].[SP_TES_FLUJO_EFECTIVO]
 @FechaInicial as DATETIME,
 @FechaFinal as DATETIME
AS

WITH CTE_RECIBOS_CAJA_CABECERA AS (
  SELECT
    RC.Id,
    CASE
      RC.Status
      WHEN 1 THEN 'Registrado'
      WHEN 2 THEN 'Confirmado'
      WHEN 3 THEN 'Anulado'
      WHEN 4 THEN 'Reversado'
    END Estado,
    RC.Code as CODIGO,
    RC.CreationUser,
    CASE
      RC.CollectType
      WHEN 1 THEN 'Caja'
      WHEN 2 THEN 'Bancos'
    END AFECTA,
    RC.IdBankAccount,
    RC.OperatingUnitId,
    RC.Status,
    RC.DocumentDate,
    RC.Detail,
    1 as 'CANTIDAD',
    RC.IdThirdParty,
    RC.IdCashRegister,
    RC.CollectType,
    RC.Code,
    RC.Value
  FROM
    INDIGO036.Treasury.CashReceipts RC
  where
    CAST(RC.DocumentDate AS DATE) BETWEEN @FechaInicial
    and @FechaFinal
),
CTE_RECIBOS_CAJA_DETALLE AS (
  SELECT
    'RECIBOS DE CAJA' 'TIPO',
    CASE
      RC.Status
      WHEN 1 THEN 'Registrado'
      WHEN 2 THEN 'Confirmado'
      WHEN 3 THEN 'Anulado'
      WHEN 4 THEN 'Reversado'
    END 'ESTADO',
    RC.Code as 'CODIGO',
    T.Nit,
    RTRIM(T.Name) AS 'TERCERO',
    'Ingresos' AS 'MOVIMIENTO',
    CASE
      RC.CollectType
      WHEN 1 THEN 'Caja'
      WHEN 2 THEN 'Bancos'
    END 'AFECTA',
    C.Code + ' - ' + C.Name AS 'CAJA',
    B.Name + ' - ' + CB.Number 'CUENTA',
    CAST(RC.DocumentDate AS DATE) AS 'FECHA DOCUMENTO',
    CAST(RC.DocumentDate AS TIME) AS 'HORA DOCUMENTO',
    -- CONVERT(money, RC.Value, 100) AS 'VALOR GENERAL',
    CONVERT(DECIMAL(18,2), RC.Value, 100) AS 'VALOR GENERAL',
    CU.Number AS 'CUENTA CONTABLE',
    -- CONVERT(money, RCD.Value, 100) AS 'VALOR DETALLE',
    CONVERT(DECIMAL(18,2), RCD.Value, 100) AS 'VALOR DETALLE',
    CASE
      RCD.Nature
      WHEN 1 THEN 'Debito'
      WHEN 2 THEN 'Credito'
    END AS 'NATURALEZA',
    CASE
      MP.PaymentMethodTypes
      WHEN 1 THEN 'EFECTIVO'
      WHEN 2 THEN 'CHEQUE'
      WHEN 3 THEN 'TARJETA'
      WHEN 4 THEN 'CONSIGNACIÓN'
    END AS 'METODO',
    CASE
      MP.PaymentMethodTypes
      WHEN 1 THEN ''
      WHEN 2 THEN MP.CheckNumber
      WHEN 3 THEN MP.CardNumber
      WHEN 4 THEN MP.DepositNumber
    END 'NUMERO',
    CU.Number AS 'CUENTA DESTINO',
    CRC.Code + ' - ' + CRC.Name AS 'NOMBRE DESTINO',
    '' AS 'BENEFICIARIO',
    CFE.Code + ' - ' + CFE.NameConcept 'FLUJO',
    USU.NOMUSUARI AS 'USUARIO',
    UO.UnitName AS 'SEDE',
    RC.Detail AS 'DETALLE',
    1 as 'CANTIDAD'
  FROM
    CTE_RECIBOS_CAJA_CABECERA RC
    INNER JOIN INDIGO036.Treasury.CashReceiptDetails RCD ON RCD.IdCashReceipt = RC.Id
    INNER JOIN INDIGO036.Common.ThirdParty T ON RC.IdThirdParty = T.Id
    INNER JOIN INDIGO036.Common.OperatingUnit UO ON RC.OperatingUnitId = UO.Id
    INNER JOIN INDIGO036.dbo.SEGusuaru USU ON RC.CreationUser = USU.CODUSUARI
    INNER JOIN INDIGO036.Treasury.PaymentMethods MP ON RC.Id = MP.IdCashReceipt
    LEFT JOIN INDIGO036.Treasury.CashFlowConcept CFE ON RCD.IdCashFlowConcept = CFE.Id
    LEFT JOIN INDIGO036.Treasury.CashRegisters C ON RC.IdCashRegister = C.Id
    LEFT JOIN INDIGO036.Treasury.EntityBankAccounts CB ON RC.IdBankAccount = CB.Id
    LEFT JOIN INDIGO036.Payroll.Bank B ON CB.IdBank = B.Id
    LEFT JOIN INDIGO036.Treasury.CashReceiptConcepts CRC ON RCD.IdCashReceiptConcept = CRC.Id
    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts CU ON CRC.IdMainAccount = CU.Id
),
CTE_EGRESOS_CABECERA AS (
  SELECT
    CE.*
  FROM
    INDIGO036.Treasury.VoucherTransaction CE
  WHERE
    CAST(CE.DocumentDate AS DATE) BETWEEN @FechaInicial
    and @FechaFinal
),
CTE_EGRESOS_DETALLE AS (
  SELECT
    'COMPROBANTE EGRESO' 'TIPO',
    CASE
      CE.Status
      WHEN 1 THEN 'Registrado'
      WHEN 2 THEN 'Confirmado'
      WHEN 3 THEN 'Anulado'
      WHEN 4 THEN 'Reversado'
    END 'ESTADO',
    CE.Code AS 'CODIGO',
    T.Nit,
    RTRIM(T.Name) AS 'TERCERO',
    CASE
      CE.VoucherClass
      WHEN 1 THEN 'Pagos'
      WHEN 2 THEN 'Reembolso'
      WHEN 3 THEN 'Traslados'
    END AS 'MOVIMIENTO',
    CASE
      CE.ExpenseType
      WHEN 1 THEN 'Bancos'
      WHEN 2 THEN 'Caja Menor'
      WHEN 3 THEN 'Caja Mayor'
      WHEN 4 THEN 'ProductoBancario'
    END 'AFECTA',
    C.Code + ' - ' + C.Name AS 'CAJA',
    B.Name + ' - ' + CB.Number 'CUENTA',
    CAST(CE.DocumentDate AS DATE) AS 'FECHA DOCUMENTO',
    CAST(CE.DocumentDate AS TIME) AS 'HORA DOCUMENTO',
    -- CONVERT(money, CE.Value, 100) AS 'VALOR GENERAL',
    CONVERT(DECIMAL(18,2), CE.Value, 100) AS 'VALOR GENERAL',
    CU.Number AS 'CUENTA CONTABLE',
    CASE
    --   WHEN (CE.VoucherClass <> 3) THEN CONVERT(money, CED.Value, 101) * - 1
    --   WHEN CE.VoucherClass = 3 THEN CONVERT(money, CED.Value, 101)
    WHEN (CE.VoucherClass <> 3) THEN CONVERT(DECIMAL(18,2), CED.Value, 101) * - 1
      WHEN CE.VoucherClass = 3 THEN CONVERT(DECIMAL(18,2), CED.Value, 101)
    END AS 'VALOR DETALLE',
    CASE
      CED.Nature
      WHEN 1 THEN 'Debito'
      WHEN 2 THEN 'Credito'
    END AS 'NATURALEZA',
    CASE
      CE.PaymentMethod
      WHEN 1 THEN 'Cheque'
      WHEN 2 THEN 'NotaDebito'
    END AS 'METODO',
    CASE
      CE.PaymentMethod
      WHEN 1 THEN CONVERT(varchar(15), CE.CheckNumber, 101)
      WHEN 2 THEN CE.NoteNumber
    END AS 'NUMERO',
    CU1.Number AS 'CUENTA DESTINO',
    CU1.Name AS 'NOMBRE DESTINO',
    CE.BeneficiaryIdentification + ' - ' + CE.Beneficiary AS 'BENEFICIARIO',
    CFE.Code + ' - ' + CFE.NameConcept 'FLUJO',
    USU.NOMUSUARI AS 'USUARIO',
    UO.UnitName AS 'SEDE',
    CE.Detail,
    1 as 'CANTIDAD'
  FROM
    CTE_EGRESOS_CABECERA CE
    INNER JOIN INDIGO036.Treasury.VoucherTransactionDetails CED ON CED.IdVoucherTransaction = CE.Id
    AND CE.ExpenseType <> 2
    INNER JOIN INDIGO036.dbo.SEGusuaru USU ON CE.CreationUser = USU.CODUSUARI
    LEFT JOIN INDIGO036.Common.ThirdParty T ON CE.IdThirdParty = T.Id
    LEFT JOIN INDIGO036.Treasury.CashFlowConcept CFE ON CED.IdCashFlowConcept = CFE.Id
    LEFT JOIN INDIGO036.Treasury.CashRegisters C ON CE.IdCashRegister = C.Id
    LEFT JOIN INDIGO036.Treasury.EntityBankAccounts CB ON CE.IdEntityBankAccount = CB.Id
    LEFT JOIN INDIGO036.Payroll.Bank B ON CB.IdBank = B.Id
    LEFT JOIN INDIGO036.Treasury.ExpenseConcepts CRC ON CED.IdExpenseConcept = CRC.Id
    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts CU ON CE.IdMainAccount = CU.Id
    LEFT JOIN INDIGO036.Common.OperatingUnit UO ON CE.IdUnitOperative = UO.Id
    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts CU1 ON CED.IdMainAccount = CU1.Id
),
CTE_NOTA_CABECERA AS (
  SELECT
    N.*
  From
    INDIGO036.Treasury.TreasuryNote N
  WHERE
    CAST(N.NoteDate AS DATE) BETWEEN @FechaInicial
    and @FechaFinal
),
CTE_NOTAS_DETALLE AS (
  SELECT
    'NOTAS' 'TIPO',
    CASE
      N.Status
      WHEN 1 THEN 'Registrado'
      WHEN 2 THEN 'Confirmado'
      WHEN 3 THEN 'Anulado'
    END 'ESTADO',
    N.Code AS 'CODIGO',
    T.Nit,
    RTRIM(T.Name) AS 'TERCERO',
    CASE
      N.NoteType
      WHEN 1 THEN 'Cuenta Bancaria'
      WHEN 3 THEN 'Reversión de Comprobante de Egreso'
      WHEN 4 THEN 'Reversión de Recibo de caja'
      WHEN 5 THEN 'Reversión de Consignacion'
      WHEN 7 THEN 'Devolución de Recibo de caja'
    END 'INGRESO/EGRESO',
    CASE
      N.NoteType
      WHEN 1 THEN 'CTA' + CB.Number
      WHEN 3 THEN 'CE' + CE.Code
      WHEN 4 THEN 'RC' + RC.Code
      WHEN 5 THEN 'C' + C.Code
      WHEN 7 THEN 'RC' + RC.Code
    END 'AFECTA',
    '' 'CAJA',
    '' 'CUENTA',
    CAST(N.NoteDate AS DATE) AS 'FECHA DOCUMENTO',
    CAST(N.NoteDate AS TIME) AS 'HORA DOCUMENTO',
    -- CONVERT(money, N.Value, 100) AS 'VALOR GENERAL',
    CONVERT(DECIMAL(18,2), N.Value, 100) AS 'VALOR GENERAL',
    CB.Number AS 'CUENTA CONTABLE',
    -- (CONVERT(money, ND.Value, 101) * - 1) AS 'VALOR DETALLE',
    (CONVERT(DECIMAL(18,2), ND.Value, 101) * - 1) AS 'VALOR DETALLE',
    CASE
      ND.Nature
      WHEN 1 THEN 'Debito'
      WHEN 2 THEN 'Credito'
    END AS 'NATURALEZA',
    '' AS 'METODO',
    '' AS 'NUMERO',
    '' AS 'CUENTA DESTINO',
    '' AS 'NOMBRE DESTINO',
    '' AS 'BENEFICIARIO',
    CFE.Code + ' - ' + CFE.NameConcept 'FLUJO',
    USU.NOMUSUARI AS 'USUARIO',
    UO.UnitName AS 'SEDE',
    N.Description AS 'DETALLE',
    1 as 'CANTIDAD'
  FROM
    CTE_NOTA_CABECERA N
    INNER JOIN INDIGO036.Common.OperatingUnit UO ON N.OperatingUnitId = UO.Id
    LEFT JOIN INDIGO036.Treasury.TreasuryNoteDetail ND ON ND.TreasuryNoteId = N.Id
    and N.NoteType NOT IN (1)
    LEFT JOIN INDIGO036.Treasury.CashFlowConcept CFE ON ND.IdCashFlowConcept = CFE.Id
    LEFT JOIN INDIGO036.Treasury.EntityBankAccounts CB ON CB.Id = N.EntityBankAccountId
    LEFT JOIN INDIGO036.Treasury.VoucherTransaction CE ON CE.Id = N.VoucherTransactionId
    LEFT JOIN INDIGO036.Treasury.CashReceipts RC ON RC.Id = N.CashReceiptId
    LEFT JOIN INDIGO036.Treasury.Consignment C ON C.Id = N.ConsignmentId
    LEFT JOIN INDIGO036.dbo.SEGusuaru USU ON N.CreationUser = USU.CODUSUARI,
    INDIGO036.Common.ThirdParty T
  WHERE
    ND.ThirdPartyId = T.Id
    OR CE.IdThirdParty = T.Id
    OR RC.IdThirdParty = T.Id
)
SELECT
  *
FROM
  CTE_RECIBOS_CAJA_DETALLE
UNION
ALL
SELECT
  *
FROM
  CTE_EGRESOS_DETALLE
UNION
ALL
SELECT
  *
FROM
  CTE_NOTAS_DETALLE;