-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_V_CXP_CuentasXPagar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IMO_V_CXP_CuentasXPagar] as
--select * from Common.OperatingUnit


select Identificación, Nit, [Digito Verificacion], [Nombre Tercero], Code, [Descripción Tipo Proveedor], [Tipo Proveedor], Factura, 
--left(Factura,#final) as Letras,  dbo.udf_GetNumeric(Factura) as Numeros,
[Fecha factura], [Fecha vencimiento], [Valor factura-De Radicación], Saldo, Módulo, [Cuenta contable], [Descripción Cuenta Contable], [Id C x P], 
             [Consecutivo C x P], Sede, [Nro Cuenta], [Tipo Cuenta], [Código Banco], Banco, [Fecha documento], UsuarioModifica, FechaModificacion, Observaciones, Estado, Usuario, [Fecha creación], UsiarioConfirma, FechaConfirmacion, [E-mail], Comentarios
, CodUnidadRadicacion,UnidadRadicacion --se agrega campos por solicitud en caso 251123
from (
SELECT e.Code AS Identificación, t.Nit, t.DigitVerification AS [Digito Verificacion], t.Name AS [Nombre Tercero], tp.Code, 
           CASE tp.Parentid WHEN '1' THEN 'FINANCIEROS' 
		   WHEN '4' THEN 'PROVEEDORES' 
		   WHEN '7' THEN 'ACCIONISTAS' 
		   WHEN '10' THEN 'CONTRATISTAS, GASTOS FIJOS MENSUALES Y OBLIGACION SALARIAL'
		   WHEN '20' THEN 'GASTOS'
		   WHEN '46' THEN 'MEDICOS E IPS' END AS [Descripción Tipo Proveedor], tp.Name AS [Tipo Proveedor], p.BillNumber AS Factura, 
           p.BillDate AS [Fecha factura], p.ExpirationDate AS [Fecha vencimiento], p.InvoiceValue AS [Valor factura-De Radicación], p.Balance AS Saldo, CASE p.EntityName WHEN 'EntranceVoucher' THEN 'Comprobante Entrada' WHEN 'AccountPayable' THEN 'Cuentas X Pagar' WHEN 'InitialBalance' THEN 'Saldo Inicial' END AS Módulo, 
           c.Number AS [Cuenta contable], c.Name AS [Descripción Cuenta Contable], p.Id AS [Id C x P], p.Code AS [Consecutivo C x P], 
           'NEIVA' Sede, cb.Number AS [Nro Cuenta], 
           CASE cb.Type WHEN '1' THEN 'Ahorro' WHEN '2' THEN 'Corriente' END AS [Tipo Cuenta], b.Code AS [Código Banco], b.Name AS Banco, p.DocumentDate AS [Fecha documento], um.NOMUSUARI AS UsuarioModifica, p.ModificationDate AS FechaModificacion, CASE WHEN p.Coments IS NULL 
           THEN ib.observations ELSE p.coments END AS Observaciones, CASE p.Status WHEN '1' THEN 'Sin Confimar' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, us.NOMUSUARI AS Usuario, p.CreationDate AS [Fecha creación], uc.NOMUSUARI AS UsiarioConfirma, p.ConfirmationDate AS FechaConfirmacion, 
           m.Email AS [E-mail], p.Coments AS Comentarios,--, len(billnumber)-len(  dbo.udf_GetNumeric(BillNumber)) as #Final
		   ur.Code AS CodUnidadRadicacion, ur.Name AS UnidadRadicacion --se agrega campos por solicitud en caso 251123
FROM   Payments.AccountPayable AS p  LEFT OUTER JOIN
           Common.Supplier AS e  ON e.Id = p.IdSupplier INNER JOIN
           Common.ThirdParty AS t  ON t.Id = p.IdThirdParty INNER JOIN
           GeneralLedger.MainAccounts AS c  ON c.Id = p.IdAccount LEFT OUTER JOIN
           Common.OperatingUnit AS uo  ON uo.Id = p.IdOperatingUnit LEFT OUTER JOIN
           Common.SupplierBankAccount AS cb  ON cb.SupplierId = e.Id and  cb.PaymentDefault=1 LEFT OUTER JOIN
           Payroll.Bank AS b  ON b.Id = cb.BankId LEFT OUTER JOIN
           dbo.SEGusuaru AS us  ON us.CODUSUARI = p.CreationUser LEFT OUTER JOIN
           Common.SupplierType AS tp  ON tp.Id = p.SupplierTypeId LEFT OUTER JOIN
           Common.Person AS dp  ON dp.Id = t.PersonId LEFT OUTER JOIN
           (select max(id) as Id, IdPerson
		     from Common.Email
			 where type=1
			 group by idperson) AS m1  ON m1.IdPerson = t.PersonId LEFT OUTER JOIN
			 Common.Email as m on m.id=m1.Id LEFT OUTER JOIN
           dbo.SEGusuaru AS um  ON um.CODUSUARI = p.ModificationUser LEFT OUTER JOIN
           Common.Person AS dpm  ON dpm.Id = t.PersonId LEFT OUTER JOIN
           dbo.SEGusuaru AS uc  ON uc.CODUSUARI = p.ConfirmationUser LEFT OUTER JOIN
           Common.Person AS duc  ON duc.Id = t.PersonId LEFT OUTER JOIN
           Payments.InitialBalance AS ib  ON ib.Code = p.EntityCode AND ib.Id = p.EntityId left JOIN 
			Payments.[FilingUnit] AS ur  ON ur.Id = p.FilingUnitId

WHERE (p.Balance <> '0') AND (p.Status <> '3') --and t.nit='900433437'
) as a
--where a.[Consecutivo C x P]='002961'
