-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_CXP_CUENTASXPAGAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_CXP_CUENTASXPAGAR AS

SELECT  
    Llave_FacturaNit, 

    -- Llave_NumeroIdentificacion (solo números + identificación)
    CONCAT(
        REPLACE(
            TRANSLATE(Factura, '0123456789', '0123456789'),
            ' ', ''
        ),
        ',', Identificación
    ) AS Llave_NumeroIdentificacion,

    Identificación,	
    Nit,	
    [Digito Verificacion],	
    [Nombre Tercero],	
    Code,	
    [Descripción Tipo Proveedor], 	
    [Tipo Proveedor],
    Factura,	 

    -- Letras (Factura sin números)
    REPLACE(
        Factura,
        REPLACE(
            TRANSLATE(Factura, '0123456789', '0123456789'),
            ' ', ''
        ),
        ''
    ) AS Letras,

    -- Numeros (solo dígitos de Factura)
    REPLACE(
        TRANSLATE(Factura, '0123456789', '0123456789'),
        ' ', ''
    ) AS Numeros, 

    [Fecha factura],	
    [Fecha vencimiento],	
    [Valor factura-De Radicación],
    Saldo,	
    Módulo,	
    [Cuenta contable],	
    [Descripción Cuenta Contable],	
    [Consecutivo C x P],	
    IdOperatingUnit,	
    Sede,	
    [Nro Cuenta],	
    [Tipo Cuenta],	
    [Código Banco],	
    Banco,
    [Fecha documento],	
    UsuarioModifica,	
    FechaModificacion,	
    Observaciones,	
    Estado,	
    Usuario,	
    [Fecha creación],
    UsiarioConfirma,	
    FechaConfirmacion,	
    CodUnidadRadicacion,	
    UnidadRadicacion

FROM (
     SELECT DISTINCT 
            e.Code AS Identificación, 
            t.Nit, 
            t.DigitVerification AS [Digito Verificacion], 
            t.Name AS [Nombre Tercero], 
            tp.Code,
            CASE tp.ParentId
                WHEN '1'  THEN 'FINANCIEROS'
                WHEN '15' THEN 'GASTOS'
                WHEN '71' THEN 'SERVICIOS'
            END AS [Descripción Tipo Proveedor], 
            tp.Name AS [Tipo Proveedor], 
            p.BillNumber AS Factura, 

            p.BillDate AS [Fecha factura], 
            p.ExpirationDate AS [Fecha vencimiento], 
            p.InvoiceValue AS [Valor factura-De Radicación], 
            p.Balance AS Saldo,
            CASE p.EntityName
                WHEN 'AccountPayable'   THEN 'Cuentas X Pagar'
                WHEN 'InitialBalance'   THEN 'Saldo Inicial'
                WHEN 'EntranceVoucher'  THEN 'Inventario'
            END AS Módulo, 
            c.Number AS [Cuenta contable], 
            c.Name AS [Descripción Cuenta Contable], 
            p.Code AS [Consecutivo C x P],
			p.IdOperatingUnit,
			uo.UnitName AS Sede, 
            cb.Number AS [Nro Cuenta],
            CASE cb.Type
                WHEN '1' THEN 'Ahorro'
                WHEN '2' THEN 'Corriente'
            END AS [Tipo Cuenta], 
            b.Code AS [Código Banco], 
            b.Name AS Banco, 
            p.DocumentDate AS [Fecha documento], 
            um.NOMUSUARI AS UsuarioModifica, 
            p.ModificationDate AS FechaModificacion, 
            p.Coments AS Observaciones,
            CASE p.Status
                WHEN '1' THEN 'Sin Confimar'
                WHEN '2' THEN 'Confirmado'
                WHEN '3' THEN 'Anulado'
            END AS Estado, 
            us.NOMUSUARI AS Usuario, 
            p.CreationDate AS [Fecha creación], 
            uc.NOMUSUARI AS UsiarioConfirma, 
            p.ConfirmationDate AS FechaConfirmacion,
			ur.Code AS CodUnidadRadicacion,
			ur.Name AS UnidadRadicacion,
			CONCAT(p.BillNumber,',',t.Nit) AS Llave_FacturaNit
     FROM INDIGO031.Payments.AccountPayable AS p 
          LEFT OUTER JOIN INDIGO031.Common.Supplier AS e  ON e.Id = p.IdSupplier
          INNER JOIN INDIGO031.Common.ThirdParty AS t  ON t.Id = p.IdThirdParty
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS c  ON c.Id = p.IdAccount
          LEFT OUTER JOIN INDIGO031.Common.OperatingUnit AS uo  ON uo.Id = p.IdOperatingUnit
          LEFT OUTER JOIN INDIGO031.Common.SupplierBankAccount AS cb  ON cb.SupplierId = e.Id and PaymentDefault = 1
          LEFT OUTER JOIN INDIGO031.Payroll.Bank AS b  ON b.Id = cb.BankId
          LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS us  ON us.CODUSUARI = p.CreationUser
          LEFT OUTER JOIN INDIGO031.Common.SupplierType AS tp  ON tp.Id = p.SupplierTypeId
          LEFT OUTER JOIN INDIGO031.Common.Person AS dp  ON dp.Id = t.PersonId
          LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS um  ON um.CODUSUARI = p.ModificationUser
          LEFT OUTER JOIN INDIGO031.Common.Person AS dpm  ON dpm.Id = t.PersonId
          LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS uc  ON uc.CODUSUARI = p.ConfirmationUser
          LEFT OUTER JOIN INDIGO031.Common.Person AS duc  ON duc.Id = t.PersonId
		  INNER JOIN INDIGO031.Payments.[FilingUnit] AS ur  ON ur.Id = p.FilingUnitId
     WHERE (p.Status not in ('3', '4'))
) AS A;