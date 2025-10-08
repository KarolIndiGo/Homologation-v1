-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_TSR_FLUJOCAJA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_TSR_FLUJOCAJA AS

SELECT 
        RC.Code, 
        T.Nit, 
        T.Name AS Tercero, 
        'Ingresos' AS 'Ingreso/Egreso',
        CASE RC.CollectType
            WHEN 1 THEN 'Caja'
            WHEN 2 THEN 'Bancos'
        END Afecta,
        C.Code + ' - ' + C.Name AS 'Caja/Cuenta', 
        RC.DocumentDate AS FechaDocumento, 
        CAST(RC.Value AS DECIMAL(18,2)) AS VlrGeneral, 
        CRC.Name AS Concepto, 
        CU.Number AS CuentaContable, 
        CAST(RCD.Value AS DECIMAL(18,2)) AS ValorDetalle,
        CASE RCD.Nature
            WHEN 1 THEN 'Debito'
            WHEN 2 THEN 'Credito'
        END AS Naturaleza, 
        '' AS 'Metodo', 
        '' AS 'Numero', 
        '' AS 'CuentaDestino', 
        '' AS 'NombreDestino', 
        ' ' AS 'Beneficiario', 
        UO.UnitName AS Sede, 
        RC.Detail AS Detalle
     FROM INDIGO031.Treasury.CashReceipts RC
          JOIN INDIGO031.Treasury.CashReceiptDetails RCD ON RCD.IdCashReceipt = RC.Id
                                                          AND RC.Status = 2
          JOIN INDIGO031.Common.ThirdParty T ON RC.IdThirdParty = T.Id
          LEFT JOIN INDIGO031.Treasury.CashRegisters C ON RC.IdCashRegister = C.Id
          LEFT JOIN INDIGO031.Treasury.EntityBankAccounts CB ON RC.IdBankAccount = CB.Id
          LEFT JOIN INDIGO031.Payroll.Bank B ON CB.IdBank = B.Id
          JOIN INDIGO031.Treasury.CashReceiptConcepts CRC ON RCD.IdCashReceiptConcept = CRC.Id
          JOIN INDIGO031.GeneralLedger.MainAccounts CU ON CRC.IdMainAccount = CU.Id
          JOIN INDIGO031.Common.OperatingUnit UO ON RC.OperatingUnitId = UO.Id
     UNION ALL
     SELECT 
        CE.Code, 
        T.Nit, 
        T.Name AS Tercero,
        CASE CE.VoucherClass
            WHEN 1 THEN 'Pagos'
            WHEN 2 THEN 'Reembolso'
            WHEN 3 THEN 'Traslados'
        END AS TipoComp,
        CASE CE.ExpenseType
            WHEN 1 THEN 'Bancos'
            WHEN 2 THEN 'Caja Menor'
            WHEN 3 THEN 'Caja Mayor'
            WHEN 4 THEN 'ProductoBancario'
        END Afecta,
        C.Code + ' - ' + C.Name AS 'Caja/Cuenta', 
        CE.DocumentDate AS FechaDocumento, 
        CAST(CE.Value AS DECIMAL(18,2)) AS VlrGeneral,
        CASE
            WHEN CED.IdExpenseConcept IS NULL THEN CU1.Name
            WHEN CE.CheckReconciled IS NOT NULL THEN CRC.Description
        END AS Concepto, 
        CU.Number AS CuentaContable,
        CASE
            WHEN CE.VoucherClass <> 3 THEN CAST(CED.Value AS DECIMAL(18,2)) * -1
            WHEN CE.VoucherClass = 3  THEN CAST(CED.Value AS DECIMAL(18,2))
        END AS VlrDetalle,
        CASE CED.Nature
            WHEN 1 THEN 'Debito'
            WHEN 2 THEN 'Credito'
        END AS Naturaleza,
        CASE CE.PaymentMethod
            WHEN 1 THEN 'Cheque'
            WHEN 2 THEN 'NotaDebito'
        END AS Metodo,
        CASE CE.PaymentMethod
            WHEN 1 THEN CONVERT(VARCHAR(15), CE.CheckNumber, 101)
            WHEN 2 THEN CE.NoteNumber
        END AS Numero, 
        CU1.Number AS CuentaDestino, 
        CU1.Name AS NombreDestino, 
        CE.BeneficiaryIdentification + ' - ' + CE.Beneficiary AS Beneficiario, 
        UO.UnitName AS Sede, 
        CE.Detail
     FROM INDIGO031.Treasury.VoucherTransaction CE
          JOIN INDIGO031.Treasury.VoucherTransactionDetails CED ON CED.IdVoucherTransaction = CE.Id
                                                                 AND CE.Status = 2
                                                                 AND CE.VoucherClass IN(1, 2)
                                                                 AND CE.ExpenseType <> 2
          LEFT JOIN INDIGO031.Common.ThirdParty T ON CE.IdThirdParty = T.Id
          LEFT JOIN INDIGO031.Treasury.CashRegisters C ON CE.IdCashRegister = C.Id
          LEFT JOIN INDIGO031.Treasury.EntityBankAccounts CB ON CE.IdEntityBankAccount = CB.Id
          LEFT JOIN INDIGO031.Payroll.Bank B ON CB.IdBank = B.Id
          LEFT JOIN INDIGO031.Treasury.ExpenseConcepts CRC ON CED.IdExpenseConcept = CRC.Id
          LEFT JOIN INDIGO031.GeneralLedger.MainAccounts CU ON CE.IdMainAccount = CU.Id
          LEFT JOIN INDIGO031.Common.OperatingUnit UO ON CE.IdUnitOperative = UO.Id
          LEFT JOIN INDIGO031.GeneralLedger.MainAccounts CU1 ON CED.IdMainAccount = CU1.Id
     UNION ALL
     SELECT 
        N.Code, 
        T.Nit, 
        T.Name AS Tercero, 
        'Notas' AS 'Ingreso/Egreso',
        CASE N.NoteType
            WHEN 1 THEN 'Nota a Cuenta Bancaria '
        END Afecta,
        '' AS 'Caja/Cuenta', 
        N.NoteDate AS FechaDocumento, 
        CAST(N.Value AS DECIMAL(18,2)) AS VlrGeneral, 
        CN.Description AS Concepto, 
        CU.Number AS CuentaContable, 
        (CAST(ND.Value AS DECIMAL(18,2)) * -1) AS ValorDetalle,
        CASE ND.Nature
            WHEN 1 THEN 'Debito'
            WHEN 2 THEN 'Credito'
        END AS Naturaleza, 
        '' AS 'Metodo', 
        '' AS 'Numero', 
        '' AS 'CuentaDestino', 
        '' AS 'NombreDestino', 
        ' ' AS 'Beneficiario', 
        UO.UnitName AS Sede, 
        N.Description AS Detalle
     FROM INDIGO031.Treasury.TreasuryNote N
          JOIN INDIGO031.Treasury.TreasuryNoteDetail ND ON ND.TreasuryNoteId = N.Id
                                                         AND N.Status = 2
                                                         AND N.NoteType = 1
          LEFT JOIN INDIGO031.Common.ThirdParty T ON ND.ThirdPartyId = T.Id
          LEFT JOIN INDIGO031.Treasury.EntityBankAccounts CB ON N.EntityBankAccountId = CB.Id
          LEFT JOIN INDIGO031.Payroll.Bank B ON CB.IdBank = B.Id
          JOIN INDIGO031.Treasury.NoteConcepts CN ON ND.NoteConceptId = CN.Id
          JOIN INDIGO031.GeneralLedger.MainAccounts CU ON ND.MainAccountId = CU.Id
          JOIN INDIGO031.Common.OperatingUnit UO ON N.OperatingUnitId = UO.Id;