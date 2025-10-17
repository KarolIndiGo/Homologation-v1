-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_TSR_FlujoCaja_2023
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create view [ViewInternal].[V_TSR_FlujoCaja_2023] AS

SELECT * FROM (
SELECT        RC.Code, T .Nit, T .Name AS Tercero, 'Ingresos' AS 'Ingreso/Egreso', CASE RC.CollectType WHEN 1 THEN 'Caja' WHEN 2 THEN 'Bancos' END Afecta, CASE WHEN RC.IdCashRegister = 1 AND RC.IdBankAccount IS NULL 
                         THEN C.Name WHEN RC.IdCashRegister = 2 AND RC.IdBankAccount IS NULL THEN C.Code + ' - ' + C.Name WHEN RC.IdCashRegister = 3 AND RC.IdBankAccount IS NULL 
                         THEN C.Code + ' - ' + C.Name WHEN RC.IdCashRegister = 4 AND RC.IdBankAccount IS NULL THEN C.Code + ' - ' + C.Name WHEN RC.IdCashRegister = 5 AND RC.IdBankAccount IS NULL 
                         THEN C.Code + ' - ' + C.Name WHEN RC.IdBankAccount = 1 AND RC.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 2 AND RC.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 3 AND RC.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 4 AND RC.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 5 AND RC.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 6 AND RC.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 7 AND RC.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 8 AND RC.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN RC.IdBankAccount = 9 AND RC.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number END AS 'Caja/Cuenta', RC.DocumentDate AS FechaDocumento, CONVERT(money, RC.Value, 
                         100) AS VlrGeneral, CRC.Name AS Concepto, CU.Number AS CuentaContable, CONVERT(money, RCD.Value, 100) AS ValorDetalle, CASE RCD.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Naturaleza, 
                         '' AS 'Metodo', '' AS 'Numero', '' AS 'CuentaDestino', '' AS 'NombreDestino', ' ' AS 'Beneficiario', UO.UnitName AS Sede, RC.Detail AS Detalle
FROM            Treasury.CashReceipts RC JOIN
                         Treasury.CashReceiptDetails RCD ON RCD.IdCashReceipt = RC.Id AND RC.Status = 2 JOIN
                         Common.ThirdParty T ON RC.IdThirdParty = T .Id LEFT JOIN
                         Treasury.CashRegisters C ON RC.IdCashRegister = C.Id LEFT JOIN
                         Treasury.EntityBankAccounts CB ON RC.IdBankAccount = CB.Id LEFT JOIN
                         Payroll.Bank B ON CB.IdBank = B.Id JOIN
                         Treasury.CashReceiptConcepts CRC ON RCD.IdCashReceiptConcept = CRC.Id JOIN
                         GeneralLedger.MainAccounts CU ON CRC.IdMainAccount = CU.Id JOIN
                         Common.OperatingUnit UO ON RC.OperatingUnitId = UO.Id
UNION ALL
SELECT        CE.Code, T .Nit, T .Name AS Tercero, CASE CE.VoucherClass WHEN 1 THEN 'Pagos' WHEN 2 THEN 'Reembolso' WHEN 3 THEN 'Traslados' END AS TipoComp, 
                         CASE CE.ExpenseType WHEN 1 THEN 'Bancos' WHEN 2 THEN 'Caja Menor' WHEN 3 THEN 'Caja Mayor' WHEN 4 THEN 'ProductoBancario' END Afecta, CASE WHEN CE.IdCashRegister = 1 AND CE.IdEntityBankAccount IS NULL
                          THEN C.Name WHEN CE.IdCashRegister = 3 AND CE.IdEntityBankAccount IS NULL THEN C.Code + ' - ' + C.Name WHEN CE.IdCashRegister = 3 AND CE.IdEntityBankAccount IS NULL 
                         THEN C.Code + ' - ' + C.Name WHEN CE.IdCashRegister = 4 AND CE.IdEntityBankAccount IS NULL THEN C.Code + ' - ' + C.Name WHEN CE.IdCashRegister = 5 AND CE.IdEntityBankAccount IS NULL 
                         THEN C.Code + ' - ' + C.Name WHEN CE.IdCashRegister = 7 AND CE.IdEntityBankAccount IS NULL THEN C.Code + ' - ' + C.Name WHEN CE.IdCashRegister = 8 AND CE.IdEntityBankAccount IS NULL 
                         THEN C.Code + ' - ' + C.Name WHEN CE.IdEntityBankAccount = 1 AND CE.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 2 AND CE.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 3 AND CE.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 4 AND CE.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 5 AND CE.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 6 AND CE.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 7 AND CE.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 8 AND CE.IdCashRegister IS NULL 
                         THEN B.Name + ' - ' + CB.Number WHEN CE.IdEntityBankAccount = 9 AND CE.IdCashRegister IS NULL THEN B.Name + ' - ' + CB.Number END AS 'Caja/Cuenta', CE.DocumentDate AS FechaDocumento, CONVERT(money, 
                         CE.Value, 100) AS VlrGeneral, CASE WHEN CED.IdExpenseConcept IS NULL THEN CU1.Name WHEN CE.CheckReconciled IS NOT NULL THEN CRC.Description END AS Concepto, CU.Number AS CuentaContable, 
                         CASE WHEN (CE.VoucherClass <> 3) THEN CONVERT(money, CED.Value, 101) * - 1 WHEN CE.VoucherClass = 3 THEN CONVERT(money, CED.Value, 101) END AS VlrDetalle, 
                         CASE CED.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Naturaleza, CASE CE.PaymentMethod WHEN 1 THEN 'Cheque' WHEN 2 THEN 'NotaDebito' END AS Metodo, 
                         CASE CE.PaymentMethod WHEN 1 THEN CONVERT(varchar(15), CE.CheckNumber, 101) WHEN 2 THEN CE.NoteNumber END AS Numero, CU1.Number AS CuentaDestino, CU1.Name AS NombreDestino, 
                         CE.BeneficiaryIdentification + ' - ' + CE.Beneficiary AS Beneficiario, UO.UnitName AS Sede, CE.Detail
FROM            Treasury.VoucherTransaction CE JOIN
                         Treasury.VoucherTransactionDetails CED ON CED.IdVoucherTransaction = CE.Id AND CE.Status = 2 AND CE.VoucherClass IN (1, 2) AND CE.ExpenseType <> 2 LEFT JOIN
                         Common.ThirdParty T ON CE.IdThirdParty = T .Id LEFT JOIN
                         Treasury.CashRegisters C ON CE.IdCashRegister = C.Id LEFT JOIN
                         Treasury.EntityBankAccounts CB ON CE.IdEntityBankAccount = CB.Id LEFT JOIN
                         Payroll.Bank B ON CB.IdBank = B.Id LEFT JOIN
                         Treasury.ExpenseConcepts CRC ON CED.IdExpenseConcept = CRC.Id LEFT JOIN
                         GeneralLedger.MainAccounts CU ON CE.IdMainAccount = CU.Id LEFT JOIN
                         Common.OperatingUnit UO ON CE.IdUnitOperative = UO.Id LEFT JOIN
                         GeneralLedger.MainAccounts CU1 ON CED.IdMainAccount = CU1.Id
UNION ALL
SELECT        N .Code, T .Nit, T .Name AS Tercero, 'Notas' AS 'Ingreso/Egreso', CASE N .NoteType WHEN 1 THEN 'Nota a Cuenta Bancaria ' END Afecta, 
                         CASE WHEN N .EntityBankAccountId = 1 THEN B.Name + ' - ' + CB.Number WHEN N .EntityBankAccountId = 2 THEN B.Name + ' - ' + CB.Number WHEN N .EntityBankAccountId = 3 THEN B.Name + ' - ' + CB.Number WHEN N .EntityBankAccountId
                          = 4 THEN B.Name + ' - ' + CB.Number WHEN N .EntityBankAccountId = 5 THEN B.Name + ' - ' + CB.Number WHEN N .EntityBankAccountId = 6 THEN B.Name + ' - ' + CB.Number WHEN N .EntityBankAccountId = 7 THEN B.Name +
                          ' - ' + CB.Number WHEN N .EntityBankAccountId = 8 THEN B.Name + ' - ' + CB.Number WHEN N .EntityBankAccountId = 9 THEN B.Name + ' - ' + CB.Number END AS 'Caja/Cuenta', N .NoteDate AS FechaDocumento, 
                         CONVERT(money, N .Value, 100) AS VlrGeneral, CN.Description AS Concepto, CU.Number AS CuentaContable, (CONVERT(money, ND.Value, 101) * - 1) AS ValorDetalle, 
                         CASE ND.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Naturaleza, '' AS 'Metodo', '' AS 'Numero', '' AS 'CuentaDestino', '' AS 'NombreDestino', ' ' AS 'Beneficiario', UO.UnitName AS Sede, 
                         N .Description AS Detalle
FROM            Treasury.TreasuryNote N JOIN
                         Treasury.TreasuryNoteDetail ND ON ND.TreasuryNoteId = N .Id AND N .Status = 2 AND N .NoteType = 1 LEFT JOIN
                         Common.ThirdParty T ON ND.ThirdPartyId = T .Id LEFT JOIN
                         Treasury.EntityBankAccounts CB ON N .EntityBankAccountId = CB.Id LEFT JOIN
                         Payroll.Bank B ON CB.IdBank = B.Id JOIN
                         Treasury.NoteConcepts CN ON ND.NoteConceptId = CN.Id JOIN
                         GeneralLedger.MainAccounts CU ON ND.MainAccountId = CU.Id JOIN
                         Common.OperatingUnit UO ON N .OperatingUnitId = UO.Id
) AS A
WHERE YEAR(A.FechaDocumento)>='2023'
