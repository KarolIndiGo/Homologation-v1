-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CXP_CuentasXPagar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_CXP_CuentasXPagar] AS

SELECT   /*p.EntityCode,*/     e.Code AS Identificación, t.Nit, t.DigitVerification AS [Digito Verificacion], t.Name AS [Nombre Tercero], tp.Code, 
                         CASE tp.Parentid WHEN '1' THEN 'CONTRATISTAS GASTOS FIJOS MENSUALES Y OBLIGACION SALARIAL' WHEN '5' THEN 'GASTOS' WHEN '20' THEN 'FINANCIEROS' WHEN '40' THEN 'EMPLEADOS' WHEN '22' THEN 'PROVEEDOR'
                          END AS [Descripción Tipo Proveedor], tp.Name AS [Tipo Proveedor], p.BillNumber AS Factura, p.BillDate AS [Fecha factura], p.ExpirationDate AS [Fecha vencimiento], p.InvoiceValue AS [Valor factura-De Radicación], 
                         p.Balance AS Saldo, CASE p.EntityName WHEN 'AccountPayable' THEN 'Cuentas X Pagar' WHEN 'InitialBalance' THEN 'Saldo Inicial' WHEN 'EntranceVoucher' THEN 'Inventario' END AS Módulo, c.Number AS [Cuenta contable], 
                         c.Name AS [Descripción Cuenta Contable], p.Code AS [Consecutivo C x P], uo.[UnitName] as Sede, cb.Number AS [Nro Cuenta], 
                         CASE cb.Type WHEN '1' THEN 'Ahorro' WHEN '2' THEN 'Corriente' END AS [Tipo Cuenta], b.Code AS [Código Banco], b.Name AS Banco, p.DocumentDate AS [Fecha documento], um.NOMUSUARI AS UsuarioModifica, 
                         p.ModificationDate AS FechaModificacion, p.Coments AS Observaciones, CASE p.Status WHEN '1' THEN 'Sin Confimar' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, us.NOMUSUARI AS Usuario, 
                         p.CreationDate AS [Fecha creación], uc.NOMUSUARI AS UsiarioConfirma, 
						 p.ConfirmationDate AS FechaConfirmacion,-- m.Email AS [E-mail]
						 case e.ExposeFactoring when 1 then 'Si' when 0 then 'No' end as [ExposeFactoring],
						 al.Code AS CodAlmacen, al.Name AS Almacen
FROM            Payments.AccountPayable AS p  LEFT OUTER JOIN
                         Common.Supplier AS e  ON e.Id = p.IdSupplier INNER JOIN
                         Common.ThirdParty AS t  ON t.Id = p.IdThirdParty INNER JOIN
                         GeneralLedger.MainAccounts AS c  ON c.Id = p.IdAccount LEFT OUTER JOIN
                         Common.OperatingUnit AS uo  ON uo.Id = p.IdOperatingUnit LEFT OUTER JOIN
                             (SELECT DISTINCT Number, SupplierId, BankId, Type
                               FROM            Common.SupplierBankAccount
                               WHERE        (PaymentDefault = 1)) AS cb ON cb.SupplierId = e.Id LEFT OUTER JOIN
                         Payroll.Bank AS b  ON b.Id = cb.BankId LEFT OUTER JOIN
                         dbo.SEGusuaru AS us  ON us.CODUSUARI = p.CreationUser LEFT OUTER JOIN
                         Common.SupplierType AS tp  ON tp.Id = p.SupplierTypeId LEFT OUTER JOIN
                         Common.Person AS dp  ON dp.Id = t.PersonId LEFT OUTER JOIN
                        -- Common.Email AS m  ON m.IdPerson = t.PersonId LEFT OUTER JOIN
                         dbo.SEGusuaru AS um  ON um.CODUSUARI = p.ModificationUser LEFT OUTER JOIN
                         Common.Person AS dpm  ON dpm.Id = t.PersonId LEFT OUTER JOIN
                         dbo.SEGusuaru AS uc  ON uc.CODUSUARI = p.ConfirmationUser LEFT OUTER JOIN
                         Common.Person AS duc  ON duc.Id = t.PersonId left join
						 Inventory.EntranceVoucher AS cce ON cce.Code = P.EntityCode left join
						 Inventory.Warehouse AS al	ON al.Id = cce.WarehouseId

WHERE        (p.Balance <> '0') AND (p.Status <> '3')
--and p.entitycode='TJ0000013185'

--select * from Payments.AccountPayable where entitycode='TJ0000013185'

--select * from [ViewInternal].[FQ45_V_INN_ComprobanteEntrada] where Comprobante='TJ0000013185'

