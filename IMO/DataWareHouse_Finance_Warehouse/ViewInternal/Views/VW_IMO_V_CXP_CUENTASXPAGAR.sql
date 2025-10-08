-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_V_CXP_CUENTASXPAGAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_V_CXP_CuentasXPagar
AS

SELECT e.Code AS Identificación, t.Nit, t.DigitVerification AS [Digito Verificacion], t.Name AS [Nombre Tercero], tp.Code, 
           CASE tp.ParentId WHEN '1' THEN 'FINANCIEROS' 
		   WHEN '4' THEN 'PROVEEDORES' 
		   WHEN '7' THEN 'ACCIONISTAS' 
		   WHEN '10' THEN 'CONTRATISTAS, GASTOS FIJOS MENSUALES Y OBLIGACION SALARIAL'
		   WHEN '20' THEN 'GASTOS'
		   WHEN '46' THEN 'MEDICOS E IPS' END AS [Descripción Tipo Proveedor], tp.Name AS [Tipo Proveedor], p.BillNumber AS Factura, 
           p.BillDate AS [Fecha factura], p.ExpirationDate AS [Fecha vencimiento], p.InvoiceValue AS [Valor factura-De Radicación], p.Balance AS Saldo, CASE p.EntityName WHEN 'EntranceVoucher' THEN 'Comprobante Entrada' WHEN 'AccountPayable' THEN 'Cuentas X Pagar' WHEN 'InitialBalance' THEN 'Saldo Inicial' END AS Módulo, 
           c.Number AS [Cuenta contable], c.Name AS [Descripción Cuenta Contable], p.Id AS [Id C x P], p.Code AS [Consecutivo C x P], 
           'NEIVA' Sede, cb.Number AS [Nro Cuenta], 
           CASE cb.Type WHEN '1' THEN 'Ahorro' WHEN '2' THEN 'Corriente' END AS [Tipo Cuenta], b.Code AS [Código Banco], b.Name AS Banco, p.DocumentDate AS [Fecha documento], um.NOMUSUARI AS UsuarioModifica, p.ModificationDate AS FechaModificacion, CASE WHEN p.Coments IS NULL 
           THEN ib.Observations ELSE p.Coments END AS Observaciones, CASE p.Status WHEN '1' THEN 'Sin Confimar' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, us.NOMUSUARI AS Usuario, p.CreationDate AS [Fecha creación], uc.NOMUSUARI AS UsiarioConfirma, p.ConfirmationDate AS FechaConfirmacion, 
           m.Email AS [E-mail], p.Coments AS Comentarios,--, len(billnumber)-len(  dbo.udf_GetNumeric(BillNumber)) as #Final
		   ur.Code AS CodUnidadRadicacion, ur.Name AS UnidadRadicacion --se agrega campos por solicitud en caso 251123
FROM   [INDIGO035].[Payments].[AccountPayable] AS p  LEFT OUTER JOIN
           [INDIGO035].[Common].[Supplier] AS e  ON e.Id = p.IdSupplier INNER JOIN
           [INDIGO035].[Common].[ThirdParty] AS t  ON t.Id = p.IdThirdParty INNER JOIN
           [INDIGO035].[GeneralLedger].[MainAccounts] AS c  ON c.Id = p.IdAccount LEFT OUTER JOIN
           [INDIGO035].[Common].[OperatingUnit] AS uo  ON uo.Id = p.IdOperatingUnit LEFT OUTER JOIN
           [INDIGO035].[Common].[SupplierBankAccount] AS cb  ON cb.SupplierId = e.Id and  cb.PaymentDefault=1 LEFT OUTER JOIN
           [INDIGO035].[Payroll].[Bank] AS b  ON b.Id = cb.BankId LEFT OUTER JOIN
           [INDIGO035].[dbo].[SEGusuaru] AS us  ON us.CODUSUARI = p.CreationUser LEFT OUTER JOIN
           [INDIGO035].[Common].[SupplierType] AS tp  ON tp.Id = p.SupplierTypeId LEFT OUTER JOIN
           [INDIGO035].[Common].[Person] AS dp  ON dp.Id = t.PersonId LEFT OUTER JOIN
           (select max(Id) as Id, IdPerson
		     from [INDIGO035].[Common].[Email]
			 where Type=1
			 group by IdPerson) AS m1  ON m1.IdPerson = t.PersonId LEFT OUTER JOIN
			 [INDIGO035].[Common].[Email] as m on m.Id=m1.Id LEFT OUTER JOIN
           [INDIGO035].[dbo].[SEGusuaru] AS um  ON um.CODUSUARI = p.ModificationUser LEFT OUTER JOIN
           [INDIGO035].[Common].[Person] AS dpm  ON dpm.Id = t.PersonId LEFT OUTER JOIN
           [INDIGO035].[dbo].SEGusuaru AS uc  ON uc.CODUSUARI = p.ConfirmationUser LEFT OUTER JOIN
           [INDIGO035].[Common].[Person] AS duc  ON duc.Id = t.PersonId LEFT OUTER JOIN
           [INDIGO035].[Payments].[InitialBalance] AS ib  ON ib.Code = p.EntityCode AND ib.Id = p.EntityId left JOIN 
		   [INDIGO035].[Payments].[FilingUnit] AS ur  ON ur.Id = p.FilingUnitId

WHERE (p.Balance <> '0') AND (p.Status <> '3') --and t.nit='900433437'
--where a.[Consecutivo C x P]='002961'