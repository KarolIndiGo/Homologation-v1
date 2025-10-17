-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_AEF_Egresos_Pagos
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[FQ45_V_AEF_Egresos_Pagos]
AS
--SELECT 
--CASE C.IdUnitOperative WHEN 3 THEN 'BOGOTA' END AS Sede, C.Code AS [Nro Comprobante], C.CreationDate AS [Fecha de Creacion],
--C.DocumentDate AS [Fecha del Documento], CASE C.VoucherClass WHEN 1 THEN 'PAGO' END AS [Clase de Comprobante],
--CASE C.Status WHEN 2 THEN 'CONFIRMADO' END AS Estado, P.Number AS Cuenta, P.Name AS [Nombre de Cuenta],
--C.TransactionDate AS [Fecha de Consignacion], C.CheckNumber AS [Cheque/Nota], C.BeneficiaryIdentification AS [Nit Destinatario - Tercero],
--C.Beneficiary AS [Nombre Destinatario - Tercero], C.Value AS [Valor Pagado], CONCEPT.Code +' - '+ CONCEPT.Description AS [Concepto de Egreso],
--CASE C.ExpenseType WHEN 1 THEN 'Afecta Banco' WHEN 2 THEN 'Afecta Caja Menor' WHEN 3 THEN 'Afecta Caja Mayor' WHEN 4 THEN 'Producto Bancario' END AS [Tipo de Egreso],
--C.Detail AS Detalle, BankAccountNumber AS [Cuenta Bancaria], C.BankName AS Banco, FUN.Identification + ' - '+ FUN.Fullname AS Usuario, C.BeneficiaryIdentification AS [Nit CXP],
--C.Beneficiary AS [Tercero CXP], C.Value As Valor




--FROM 

--Treasury.VoucherTransaction AS C  INNER JOIN     --comprobante de egreso
--GeneralLedger.MainAccounts AS P  ON C.IdMainAccount = P.Id LEFT JOIN    --plan unico de cuentas
--Treasury.VoucherTransactionDetails AS D ON D.IdVoucherTransaction = C.Id	INNER JOIN
--Treasury.ExpenseConcepts AS CONCEPT ON D.IdExpenseConcept = CONCEPT.Id  LEFT JOIN  --concepto de egreso
--[Security].[Person] AS FUN ON C.CreationUser = FUN.Identification

--WHERE 
--(C.VoucherClass = 1)
--AND C.CreationDate >= '2024-01-01' -- Se añade filtro segun caso 313817, para traer solo información 2024 en adelante

SELECT        TOP (100) PERCENT uo.UnitName AS Sede, ce.Code AS [Nro comprobante], ce.CreationDate AS [Fecha creación], ce.DocumentDate AS [Fecha documento], 
                         CASE ce.VoucherClass WHEN '1' THEN 'Pago' WHEN '2' THEN 'Reembolso' WHEN '3' THEN 'Traslado' END AS [Clase Comprobante], 
                         CASE ce.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' WHEN '4' THEN 'Reversado' END AS Estado, c.Number AS Cuenta, c.Name AS [Nombre Cuenta], 
                         ce.TransactionDate AS [Fecha consignación], ce.CheckNumber AS [Cheque/Nota], ce.BeneficiaryIdentification AS [Nit Destinatario-Tercero], ce.Beneficiary AS [Nombre Destinatario-Tercero], ce.Value AS [Valor pagado], 
                         cone.Code + ' -' + cone.Description AS [Concepto de Egreso], rf.BillNumber AS Factura, rf.BillDate AS [Fecha factura], rf.ExpirationDate AS [Fecha vencimiento], cf.Code + ' - ' + cf.Name AS [Concepto Factura], 
                         df.AdvancedValue AS [Vr pagado factura], ccos.Code + ' - ' + ccos.Name AS [Centro Costo], c1.Number + ' - ' + c1.Name AS [Cuenta Contable], 
                         CASE ce.ExpenseType WHEN '1' THEN 'Afecta Banco' WHEN '2' THEN 'Afecta Caja Menor' WHEN '3' THEN 'Afecta Caja Mayor' WHEN '4' THEN 'Producto Bancario' END AS [Tipo de Egreso], ce.Detail AS Detalle, 
                         ce.BankAccountNumber AS [Cuenta bancaria], ce.BankName AS Banco, ce.CreationUser + '-' + sp.Fullname AS Usuario, tc.Nit AS [Nit CxP], tc.Name AS [Tercero CxP], dce.Value AS Valor
FROM            Treasury.VoucherTransaction AS ce INNER JOIN
                         GeneralLedger.MainAccounts AS c ON ce.IdMainAccount = c.Id INNER JOIN
                         Treasury.VoucherTransactionDetails AS dce ON ce.Id = dce.IdVoucherTransaction INNER JOIN
                         Common.ThirdParty AS t ON ce.IdThirdParty = t.Id INNER JOIN
                         Common.ThirdParty AS tc ON dce.IdThirdParty = tc.Id LEFT OUTER JOIN
                         Treasury.ExpenseConcepts AS cone ON cone.Id = dce.IdExpenseConcept LEFT OUTER JOIN
                         Treasury.DischargeBill AS df ON df.IdVoucherTransactionD = dce.Id LEFT OUTER JOIN
                         Treasury.TreasuryPaymentConcepts AS cf ON cf.Id = df.IdPaymentConcept LEFT OUTER JOIN
                         Payments.AccountPayable AS rf ON rf.Id = df.IdAccountPayable LEFT OUTER JOIN
                         Security.[User] AS s ON s.UserCode = ce.CreationUser LEFT OUTER JOIN
                         Security.Person AS sp ON sp.Id = s.IdPerson LEFT OUTER JOIN
                         Treasury.EntityBankAccounts AS eba ON eba.Id = ce.IdEntityBankAccount LEFT OUTER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = ce.IdUnitOperative LEFT OUTER JOIN
                         Payroll.CostCenter AS ccos ON ccos.Id = dce.IdCostCenter LEFT OUTER JOIN
                         GeneralLedger.MainAccounts AS c1 ON c1.Id = dce.IdMainAccount
WHERE        (ce.VoucherClass <> '3') AND year(ce.DocumentDate)>='2024'
