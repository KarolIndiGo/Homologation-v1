-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_CuentasXpagar_Conceptos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[VIE_CuentasXpagar_Conceptos]
AS
SELECT        e.Code AS Identificación, t.Nit, t.DigitVerification AS [Digito Verificacion], t.Name AS [Nombre Tercero], tp.Code, 
                          CASE tp.Parentid WHEN '1' THEN 'FINANCIEROS' WHEN '15' THEN 'GASTOS' END AS [Descripción Tipo Proveedor], tp.Name AS [Tipo Proveedor], p.BillNumber AS Factura, p.BillDate AS [Fecha factura], p.ExpirationDate AS [Fecha vencimiento], p.InvoiceValue AS [Valor factura-De Radicación], 
                         p.Balance AS Saldo, CASE p.EntityName WHEN 'AccountPayable' THEN 'Cuentas X Pagar' WHEN 'InitialBalance' THEN 'Saldo Inicial' WHEN 'EntranceVoucher' THEN 'Inventario' END AS Módulo, c.Number AS [Cuenta contable], 
                         c.Name AS [Descripción Cuenta Contable], p.Code AS [Consecutivo C x P], CASE WHEN c1.Number LIKE '2%' THEN - (DCxp.Value) WHEN c1.Number NOT LIKE '2%' THEN (DCxp.Value) END AS VlrDetalle, 
                         cc.Name AS CentroCosto, c1.Number AS CuentaDetalle, Con.Name AS Concepto, cb.Number AS [Nro Cuenta], CASE cb.Type WHEN '1' THEN 'Ahorro' WHEN '2' THEN 'Corriente' END AS [Tipo Cuenta], b.Code AS [Código Banco], 
                         b.Name AS Banco, p.DocumentDate AS [Fecha documento], um.NOMUSUARI AS UsuarioModifica, p.ModificationDate AS FechaModificacion, p.Coments AS Observaciones, 
                         CASE p.Status WHEN '1' THEN 'Sin Confimar' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, us.NOMUSUARI AS Usuario, p.CreationDate AS [Fecha creación], uc.NOMUSUARI AS UsiarioConfirma, 
                         p.ConfirmationDate AS FechaConfirmacion, m.Email AS [E-mail]
FROM            Payments.AccountPayable AS p LEFT OUTER JOIN
                         Common.Supplier AS e ON e.Id = p.IdSupplier INNER JOIN
                         Common.ThirdParty AS t ON t.Id = p.IdThirdParty INNER JOIN
                         GeneralLedger.MainAccounts AS c ON c.Id = p.IdAccount LEFT OUTER JOIN
                         Payments.AccountPayableDetailConcept AS DCxp ON DCxp.IdAccountPayable = p.Id LEFT OUTER JOIN
                         Payroll.CostCenter AS cc ON DCxp.IdCostCenter = cc.Id INNER JOIN
                         GeneralLedger.MainAccounts AS c1 ON DCxp.IdAccount = c1.Id INNER JOIN
                         Payments.AccountPayableConcepts AS Con ON DCxp.IdConceptAccountPayable = Con.Id LEFT OUTER JOIN
                         Common.SupplierBankAccount AS cb ON cb.SupplierId = e.Id LEFT OUTER JOIN
                         Payroll.Bank AS b ON b.Id = cb.BankId LEFT OUTER JOIN
                         dbo.SEGusuaru AS us ON us.CODUSUARI = p.CreationUser LEFT OUTER JOIN
                         Common.SupplierType AS tp ON tp.Id = p.SupplierTypeId LEFT OUTER JOIN
                         Common.Person AS dp ON dp.Id = t.PersonId LEFT OUTER JOIN
                         Common.Email AS m ON m.IdPerson = t.PersonId LEFT OUTER JOIN
                         dbo.SEGusuaru AS um ON um.CODUSUARI = p.ModificationUser LEFT OUTER JOIN
                         Common.Person AS dpm ON dpm.Id = t.PersonId LEFT OUTER JOIN
                         dbo.SEGusuaru AS uc ON uc.CODUSUARI = p.ConfirmationUser LEFT OUTER JOIN
                         Common.Person AS duc ON duc.Id = t.PersonId
WHERE        (p.Balance <> '0') AND (p.Status <> '4')
