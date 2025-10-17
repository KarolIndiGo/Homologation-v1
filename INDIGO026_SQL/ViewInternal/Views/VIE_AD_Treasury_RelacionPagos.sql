-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Treasury_RelacionPagos
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE view [ViewInternal].[VIE_AD_Treasury_RelacionPagos]
AS
SELECT uo.UnitName AS Sede, ce.Code AS [Nro comprobante], ce.CreationDate AS [Fecha creación], ce.DocumentDate AS [Fecha documento], 
                  CASE ce.VoucherClass WHEN '1' THEN 'Pago' WHEN '2' THEN 'Reembolso' WHEN '3' THEN 'Traslado' END AS [Clase Comprobante], 
                  CASE ce.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' WHEN '4' THEN 'Reversado' END AS Estado, c.Number AS Cuenta, c.Name AS [Nombre Cuenta], 
                  ce.TransactionDate AS [Fecha consignación], ce.CheckNumber AS Cheque, ce.NoteNumber AS Nota, ce.BeneficiaryIdentification AS [Nit Destinatario-Tercero], ce.Beneficiary AS [Nombre Destinatario-Tercero], 
                  ce.Value AS [Valor pagado], cone.Code + ' -' + cone.Description AS [Concepto de Egreso], rf.BillNumber AS Factura, rf.BillDate AS [Fecha factura], rf.ExpirationDate AS [Fecha vencimiento], cf.Code + ' - ' + cf.Name AS [Concepto Factura], 
                  df.AdvancedValue AS [Vr pagado factura], ccos.Code + ' - ' + ccos.Name AS [Centro Costo], c1.Number + ' - ' + c1.Name AS [Cuenta Contable], 
                  CASE ce.ExpenseType WHEN '1' THEN 'Afecta Banco' WHEN '2' THEN 'Afecta Caja Menor' WHEN '3' THEN 'Afecta Caja Mayor' WHEN '4' THEN 'Producto Bancario' END AS [Tipo de Egreso], ce.Detail AS Detalle, 
                  ce.BankAccountNumber AS [Cuenta bancaria], ce.BankName AS Banco,tc.Nit AS [Nit CxP], tc.Name AS [Tercero CxP], dce.Value AS Valor, nota.Description AS DetalleReversion, 
                  pr.Name AS Proveedor, ST.Name AS [Tipo Proveedor], rf.Code AS CxP, rf.coments as [Observacion CxP], pb.Number AS [CuentaBancaria Proveedor], bp.Name AS [Banco Proveedor]
FROM     Treasury.VoucherTransaction AS ce  INNER JOIN
                  GeneralLedger.MainAccounts AS c  ON ce.IdMainAccount = c.Id INNER JOIN
                  Treasury.VoucherTransactionDetails AS dce  ON ce.Id = dce.IdVoucherTransaction INNER JOIN
                  Common.ThirdParty AS t  ON ce.IdThirdParty = t.Id INNER JOIN
                  Common.ThirdParty AS tc  ON dce.IdThirdParty = tc.Id LEFT OUTER JOIN
                  Treasury.ExpenseConcepts AS cone  ON cone.Id = dce.IdExpenseConcept LEFT OUTER JOIN
                  Treasury.DischargeBill AS df  ON df.IdVoucherTransactionD = dce.Id LEFT OUTER JOIN
                  Treasury.TreasuryPaymentConcepts AS cf  ON cf.Id = df.IdPaymentConcept LEFT OUTER JOIN
                  Payments.AccountPayable AS rf  ON rf.Id = df.IdAccountPayable LEFT OUTER JOIN
                  --Security.[User] AS s  ON s.UserCode = ce.CreationUser LEFT OUTER JOIN
                  --Security.Person AS sp  ON sp.Id = s.IdPerson LEFT OUTER JOIN
                  Treasury.EntityBankAccounts AS eba  ON eba.Id = ce.IdEntityBankAccount LEFT OUTER JOIN
                  Common.OperatingUnit AS uo  ON uo.Id = ce.IdUnitOperative LEFT OUTER JOIN
                  Payroll.CostCenter AS ccos  ON ccos.Id = dce.IdCostCenter LEFT OUTER JOIN
                  GeneralLedger.MainAccounts AS c1  ON c1.Id = dce.IdMainAccount LEFT OUTER JOIN
                  Treasury.TreasuryNote AS nota  ON nota.VoucherTransactionId = ce.Id LEFT OUTER JOIN
                  Common.SupplierType AS ST  ON ST.Id = rf.SupplierTypeId LEFT OUTER JOIN
                  Common.Supplier AS pr  ON pr.Id = rf.IdSupplier left outer join 
				  Common.SupplierBankAccount AS pb  ON pb.SupplierId = pr.Id left outer join
				  Payroll.Bank AS bp  ON bp.Id = pb.BankId
WHERE  (ce.VoucherClass <> '3')
