-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_V_CXP_Extracto
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_V_CXP_Extracto] AS

SELECT        e.Code AS Identificación, t.Nit, t.DigitVerification AS [Digito Verificacion], t.Name AS [Nombre Tercero], tp.Code,
                             (SELECT        Name
                               FROM            Common.SupplierType
                               WHERE        (Id = tp.ParentId)) AS [Descripción Tipo Proveedor], tp.Name AS [Tipo Proveedor], p.BillNumber AS Factura, p.BillDate AS [Fecha factura], p.ExpirationDate AS [Fecha vencimiento], 
                         p.InvoiceValue AS [Valor factura-De Radicación], p.Balance AS Saldo, 
                         CASE p.EntityName WHEN 'EntranceVoucher' THEN 'Comprobante Entrada' WHEN 'AccountPayable' THEN 'Cuentas X Pagar' WHEN 'InitialBalance' THEN 'Saldo Inicial' 
						  WHEN 'FixedAssetEntry' THEN 'Ingreso de activo fijo'  WHEN 'FixedAssetTransaction' THEN 'Transacción de activo fijo' WHEN 'MedicalFeesLiquidation' THEN 'Liquidación de honorarios médicos'
						  WHEN 'LoadMassive' THEN 'Carga masiva' END AS Módulo, 
						 c.Number AS [Cuenta contable], c.Name AS [Descripción Cuenta Contable], p.Id AS [Id C x P], p.Code AS [Consecutivo C x P], 
                         CASE p.IdOperatingUnit WHEN '2' THEN 'BOGOTA' WHEN '3' THEN 'FLORENCIA' WHEN '4' THEN 'TUNJA' WHEN '1' THEN 'NEIVA' WHEN '5' THEN 'PITALITO' WHEN '17' THEN 'FACATATIVA' WHEN '18' THEN 'SOGAMOSO' END AS
                          Sede, cb.Number AS [Nro Cuenta], CASE cb.Type WHEN '1' THEN 'Ahorro' WHEN '2' THEN 'Corriente' END AS [Tipo Cuenta], b.Code AS [Código Banco], b.Name AS Banco, p.DocumentDate AS [Fecha documento], 
                         um.NOMUSUARI AS UsuarioModifica, p.ModificationDate AS FechaModificacion, p.Coments AS Observaciones, 
                         CASE p.Status WHEN '1' THEN 'Sin Confimar' WHEN '2' THEN 'Confirmado,' WHEN '3' THEN 'Anulado' END AS Estado, us.NOMUSUARI AS Usuario, p.CreationDate AS [Fecha creación], uc.NOMUSUARI AS UsiarioConfirma, 
                         p.ConfirmationDate AS FechaConfirmacion, m.Email AS [E-mail], p.Coments AS Comentarios
FROM            Payments.AccountPayable AS p LEFT OUTER JOIN
                         Common.Supplier AS e ON e.Id = p.IdSupplier INNER JOIN
                         Common.ThirdParty AS t ON t.Id = p.IdThirdParty INNER JOIN
                         GeneralLedger.MainAccounts AS c ON c.Id = p.IdAccount LEFT OUTER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = p.IdOperatingUnit LEFT OUTER JOIN
                         (SELECT DISTINCT Number, SupplierId, BankId, Type
                               FROM            Common.SupplierBankAccount
                               WHERE        (PaymentDefault = 1)) AS cb ON cb.SupplierId = e.Id LEFT OUTER JOIN
						
                         Payroll.Bank AS b ON b.Id = cb.BankId LEFT OUTER JOIN
                         dbo.SEGusuaru AS us ON us.CODUSUARI = p.CreationUser LEFT OUTER JOIN
                         Common.SupplierType AS tp ON tp.Id = p.SupplierTypeId LEFT OUTER JOIN
                         Common.Person AS dp ON dp.Id = t.PersonId LEFT OUTER JOIN
                        (select max(id) as Id, IdPerson
		     from Common.Email
			 where type=1
			 group by idperson) AS m1  ON m1.IdPerson = t.PersonId LEFT OUTER JOIN
						Common.Email AS m ON m.IdPerson = m1.id LEFT OUTER JOIN
                         dbo.SEGusuaru AS um ON um.CODUSUARI = p.ModificationUser LEFT OUTER JOIN
                         Common.Person AS dpm ON dpm.Id = t.PersonId LEFT OUTER JOIN
                         dbo.SEGusuaru AS uc ON uc.CODUSUARI = p.ConfirmationUser LEFT OUTER JOIN
                         Common.Person AS duc ON duc.Id = t.PersonId
WHERE        (p.Status <> '3') AND (p.CreationDate BETWEEN '2025-01-01' AND '2025-12-31')


--select distinct EntityName from Payments.AccountPayable