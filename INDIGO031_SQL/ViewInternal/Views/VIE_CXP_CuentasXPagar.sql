-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_CXP_CuentasXPagar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_CXP_CuentasXPagar] AS

SELECT  
Llave_FacturaNit, CONCAT(dbo.udf_GetNumeric(Factura),',',Identificación) AS Llave_NumeroIdentificacion, --se agrega por solicitud en caso 250750
Identificación,	Nit,	[Digito Verificacion],	[Nombre Tercero],	Code,	[Descripción Tipo Proveedor], 	[Tipo Proveedor],
Factura,	 left(Factura,#final) as Letras,  dbo.udf_GetNumeric(Factura) as Numeros, [Fecha factura],	[Fecha vencimiento],	[Valor factura-De Radicación],
Saldo,	Módulo,	[Cuenta contable],	[Descripción Cuenta Contable],	[Consecutivo C x P],	IdOperatingUnit,	Sede,	[Nro Cuenta],	[Tipo Cuenta],	[Código Banco],	Banco,
[Fecha documento],	UsuarioModifica,	FechaModificacion,	Observaciones,	Estado,	Usuario,	[Fecha creación],
UsiarioConfirma,	FechaConfirmacion,	CodUnidadRadicacion,	UnidadRadicacion

FROM (
     SELECT DISTINCT 
            e.Code AS Identificación, 
            t.Nit, 
            t.DigitVerification AS [Digito Verificacion], 
            t.Name AS [Nombre Tercero], 
            tp.Code,
            CASE tp.Parentid
                WHEN '1'
                THEN 'FINANCIEROS'
                WHEN '15'
                THEN 'GASTOS'
				WHEN '71'
                THEN 'SERVICIOS'
            END AS [Descripción Tipo Proveedor], 
            tp.Name AS [Tipo Proveedor], 
            p.BillNumber AS Factura, 
			len(billnumber)-len(  dbo.udf_GetNumeric(BillNumber)) as #Final, 
            p.BillDate AS [Fecha factura], 
            p.ExpirationDate AS [Fecha vencimiento], 
            p.InvoiceValue AS [Valor factura-De Radicación], 
            p.Balance AS Saldo,
            CASE p.EntityName
                WHEN 'AccountPayable'
                THEN 'Cuentas X Pagar'
                WHEN 'InitialBalance'
                THEN 'Saldo Inicial'
                WHEN 'EntranceVoucher'
                THEN 'Inventario'
            END AS Módulo, 
            c.Number AS [Cuenta contable], 
            c.Name AS [Descripción Cuenta Contable], 
            p.Code AS [Consecutivo C x P],
			p.IdOperatingUnit,
			uo.UnitName AS Sede, 
            cb.Number AS [Nro Cuenta],
            CASE cb.Type
                WHEN '1'
                THEN 'Ahorro'
                WHEN '2'
                THEN 'Corriente'
            END AS [Tipo Cuenta], 
            b.Code AS [Código Banco], 
            b.Name AS Banco, 
            p.DocumentDate AS [Fecha documento], 
            um.NOMUSUARI AS UsuarioModifica, 
            p.ModificationDate AS FechaModificacion, 
            p.Coments AS Observaciones,
            CASE p.STATUS
                WHEN '1'
                THEN 'Sin Confimar'
                WHEN '2'
                THEN 'Confirmado'
                WHEN '3'
                THEN 'Anulado'
            END AS Estado, 
            us.NOMUSUARI AS Usuario, 
            p.CreationDate AS [Fecha creación], 
            uc.NOMUSUARI AS UsiarioConfirma, 
            p.ConfirmationDate AS FechaConfirmacion,
			ur.Code AS CodUnidadRadicacion,
			ur.Name AS UnidadRadicacion,
			CONCAT(p.BillNumber,',',t.Nit) AS Llave_FacturaNit --se agrega por solicitud en caso 250750
     --m.Email AS [E-mail]
     FROM Payments.AccountPayable AS p 
          LEFT OUTER JOIN Common.Supplier AS e  ON e.Id = p.IdSupplier
          INNER JOIN Common.ThirdParty AS t  ON t.Id = p.IdThirdParty
          INNER JOIN GeneralLedger.MainAccounts AS c  ON c.Id = p.IdAccount
          LEFT OUTER JOIN Common.OperatingUnit AS uo  ON uo.Id = p.IdOperatingUnit
          LEFT OUTER JOIN Common.SupplierBankAccount AS cb  ON cb.SupplierId = e.Id and PaymentDefault = 1
          LEFT OUTER JOIN Payroll.Bank AS b  ON b.Id = cb.BankId
          LEFT OUTER JOIN dbo.SEGusuaru AS us  ON us.CODUSUARI = p.CreationUser
          LEFT OUTER JOIN Common.SupplierType AS tp  ON tp.Id = p.SupplierTypeId
          LEFT OUTER JOIN Common.Person AS dp  ON dp.Id = t.PersonId
         -- LEFT OUTER JOIN Common.Email AS m  ON m.IdPerson = t.PersonId
          LEFT OUTER JOIN dbo.SEGusuaru AS um  ON um.CODUSUARI = p.ModificationUser
          LEFT OUTER JOIN Common.Person AS dpm  ON dpm.Id = t.PersonId
          LEFT OUTER JOIN dbo.SEGusuaru AS uc  ON uc.CODUSUARI = p.ConfirmationUser
          LEFT OUTER JOIN Common.Person AS duc  ON duc.Id = t.PersonId
		  INNER JOIN Payments.[FilingUnit] AS ur  ON ur.Id = p.FilingUnitId
     WHERE
	-- (p.Balance <> '0') AND 
	 (p.STATUS not in ('3', '4'))) AS A
