-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_CXP_CuentasXPagar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_CXP_CuentasXPagar] AS
--select * from Common.OperatingUnit


SELECT	e.Code AS Identificación, t.Nit, t.DigitVerification AS [Digito Verificacion], t.Name AS [Nombre Tercero], tp.Code, 
		CASE tp.Parentid WHEN '1' THEN 'FINANCIEROS' WHEN '13' THEN 'GASTOS' WHEN '3' THEN 'PROVEEDORES' WHEN '6' THEN 'ACCIONISTAS'
		WHEN '9' THEN 'CONTRATISTAS, GASTOS FIJOS MENSUALES Y OBLIGACION SALARIAL'WHEN '18' THEN 'MEDICOS E IPS' END AS [Descripción Tipo Proveedor], 
		tp.Name AS [Tipo Proveedor], p.BillNumber AS Factura, p.BillDate AS [Fecha factura], p.ExpirationDate AS [Fecha vencimiento], p.InvoiceValue AS [Valor factura-De Radicación], 
        p.Balance AS Saldo, CASE p.EntityName WHEN 'AccountPayable' THEN 'Cuentas X Pagar' WHEN 'InitialBalance' THEN 'Saldo Inicial' WHEN 'EntranceVoucher' THEN 'Inventario' END AS Módulo, c.Number AS [Cuenta contable], 
        c.Name AS [Descripción Cuenta Contable], p.Code AS [Consecutivo C x P], 
		/*CASE p.IdOperatingUnit 
		WHEN '7' THEN 'BOGOTA' 
		WHEN '8' THEN 'TUNJA'
		WHEN '9' THEN 'DUITAMA'
		WHEN '10' THEN 'SOGAMOSO'
		WHEN '11' THEN 'CHIQUINQUIRA'
		WHEN '12' THEN 'MONIQUIRA'
		WHEN '13' THEN 'GARAGOA'
		WHEN '14' THEN 'SOATA'
		WHEN '15' THEN 'GUATEQUE'
		WHEN '16' THEN 'VILLAVICENCIO'
		WHEN '17' THEN 'ACACIAS'
		WHEN '18' THEN 'GRANADA'
		WHEN '19' THEN 'PUERTO LOPEZ'
		WHEN '20' THEN 'PUERTO GAITAN'
		WHEN '22' THEN 'YOPAL'
		END AS Sede*/
		uo.UnitName AS Sede, cb.Number AS [Nro Cuenta], 
        CASE cb.Type WHEN '1' THEN 'Ahorro' WHEN '2' THEN 'Corriente' END AS [Tipo Cuenta], b.Code AS [Código Banco], b.Name AS Banco, p.DocumentDate AS [Fecha documento], um.NOMUSUARI AS UsuarioModifica, 
        p.ModificationDate AS FechaModificacion, p.Coments AS Observaciones, CASE p.Status WHEN '1' THEN 'Sin Confimar' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, us.NOMUSUARI AS Usuario, 
        p.CreationDate AS [Fecha creación], uc.NOMUSUARI AS UsiarioConfirma, p.ConfirmationDate AS FechaConfirmacion, m.Email AS [E-mail],
		ur.Code AS CodUnidadRadicacion, ur.Name AS UnidadRadicacion

FROM    Payments.AccountPayable AS p LEFT OUTER JOIN
        Common.Supplier AS e ON e.Id = p.IdSupplier INNER JOIN
        Common.ThirdParty AS t ON t.Id = p.IdThirdParty INNER JOIN
        GeneralLedger.MainAccounts AS c ON c.Id = p.IdAccount LEFT OUTER JOIN
        Common.OperatingUnit AS uo ON uo.Id = p.IdOperatingUnit LEFT OUTER JOIN
        Common.SupplierBankAccount AS cb ON cb.SupplierId = e.Id and cb.PaymentDefault=1 LEFT OUTER JOIN
        Payroll.Bank AS b ON b.Id = cb.BankId LEFT OUTER JOIN
        dbo.SEGusuaru AS us ON us.CODUSUARI = p.CreationUser LEFT OUTER JOIN
        Common.SupplierType AS tp ON tp.Id = p.SupplierTypeId LEFT OUTER JOIN
        Common.Person AS dp ON dp.Id = t.PersonId LEFT OUTER JOIN
        (select max(id) as Id, IdPerson
		     from Common.Email
			 where type=1
			 group by idperson) AS m1  ON m1.IdPerson = t.PersonId LEFT OUTER JOIN
			 Common.Email as m on m.id=m1.Id LEFT OUTER JOIN 
		
		--Common.Email AS m ON m.IdPerson = t.PersonId LEFT OUTER JOIN
        dbo.SEGusuaru AS um ON um.CODUSUARI = p.ModificationUser LEFT OUTER JOIN
        Common.Person AS dpm ON dpm.Id = t.PersonId LEFT OUTER JOIN
        dbo.SEGusuaru AS uc ON uc.CODUSUARI = p.ConfirmationUser LEFT OUTER JOIN
        Common.Person AS duc ON duc.Id = t.PersonId left JOIN 
		Payments.[FilingUnit] AS ur  ON ur.Id = p.FilingUnitId
WHERE        (p.Balance <> '0') AND (p.Status <> '4')

--SELECT * FROM Common.SupplierType
