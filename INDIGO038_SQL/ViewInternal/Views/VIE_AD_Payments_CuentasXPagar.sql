-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Payments_CuentasXPagar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[VIE_AD_Payments_CuentasXPagar]    Script Date: 21/04/2025 2:40:55 p. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO



CREATE VIEW [ViewInternal].[VIE_AD_Payments_CuentasXPagar]
AS
     SELECT e.Code AS Identificación, 
            t.Nit, 
            t.DigitVerification AS [Digito Verificacion], 
            t.Name AS [Nombre Tercero], 
            tp.Code,
            CASE tp.Parentid
                WHEN '1'
                THEN 'CONTRATISTAS GASTOS FIJOS MENSUALES Y OBLIGACION SALARIAL'
                WHEN '5'
                THEN 'GASTOS'
                WHEN '20'
                THEN 'FINANCIEROS'
                WHEN '30'
                THEN 'MEDICOS E IPS'
                WHEN '22'
                THEN 'RED PRESTADORA'
            END AS [Descripción Tipo Proveedor], 
            tp.Name AS [Tipo Proveedor], 
            p.BillNumber AS Factura, 
            p.BillDate AS [Fecha factura], 
            p.ExpirationDate AS [Fecha vencimiento], 
            p.InvoiceValue AS [Valor factura-De Radicación], 
            p.Balance AS Saldo,
            CASE p.EntityName
                WHEN 'AccountPayable'
                THEN 'Cuentas X Pagar'
                WHEN 'InitialBalance'
                THEN 'Saldo Inicial'
            END AS Módulo, 
            c.Number AS [Cuenta contable], 
            c.Name AS [Descripción Cuenta Contable], 
            p.Code AS [Consecutivo C x P],
            CASE p.IdOperatingUnit
                WHEN '9'
                THEN 'BOGOTA'
                WHEN '10'
                THEN 'FLORENCIA'
                WHEN '13'
                THEN 'TUNJA'
                WHEN '14'
                THEN 'NEIVA'
                WHEN '15'
                THEN 'PITALITO'
                WHEN '17'
                THEN 'FACATATIVA'
                WHEN '18'
                THEN 'SOGAMOSO'
            END AS Sede, 
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
			--cb.state as [cuenta bancaria],
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
            MAX(m.Email) AS [E-mail]
     FROM Payments.AccountPayable AS p 
          LEFT OUTER JOIN Common.Supplier AS e  ON e.Id = p.IdSupplier
          INNER JOIN Common.ThirdParty AS t  ON t.Id = p.IdThirdParty
          INNER JOIN GeneralLedger.MainAccounts AS c  ON c.Id = p.IdAccount
          LEFT OUTER JOIN Common.OperatingUnit AS uo  ON uo.Id = p.IdOperatingUnit
          LEFT OUTER JOIN Common.SupplierBankAccount AS cb  ON cb.SupplierId = e.Id
          LEFT OUTER JOIN Payroll.Bank AS b  ON b.Id = cb.BankId
          LEFT OUTER JOIN dbo.SEGusuaru AS us  ON us.CODUSUARI = p.CreationUser
          LEFT OUTER JOIN Common.SupplierType AS tp  ON tp.Id = p.SupplierTypeId
          LEFT OUTER JOIN Common.Person AS dp  ON dp.Id = t.PersonId
          LEFT OUTER JOIN Common.Email AS m  ON m.IdPerson = t.PersonId
          LEFT OUTER JOIN dbo.SEGusuaru AS um  ON um.CODUSUARI = p.ModificationUser
          LEFT OUTER JOIN Common.Person AS dpm  ON dpm.Id = t.PersonId
          LEFT OUTER JOIN dbo.SEGusuaru AS uc  ON uc.CODUSUARI = p.ConfirmationUser
          LEFT OUTER JOIN Common.Person AS duc  ON duc.Id = t.PersonId
     WHERE(p.Balance <> '0')
          AND (p.STATUS <> '3')
          AND (p.DocumentDate >= '01-01-2019')-- and cb.State=1
		 -- and p.BillNumber in ( 'dse597', 'sae9197')
     GROUP BY e.Code, 
              t.Nit, 
              t.DigitVerification, 
              t.Name, 
              tp.Code, 
              tp.Parentid, 
              tp.Name, 
              p.BillNumber, 
              p.BillDate, 
              p.ExpirationDate, 
              p.InvoiceValue, 
              p.Balance, 
              p.EntityName, 
              c.Number, 
              c.Name, 
              p.Code, 
              p.IdOperatingUnit, 
              cb.Number, 
              cb.Type, 
              b.Code, 
              b.Name, 
              p.DocumentDate, 
              um.NOMUSUARI, 
              p.ModificationDate, 
              p.Coments, 
              p.STATUS, 
              us.NOMUSUARI, 
              p.CreationDate, 
              uc.NOMUSUARI, 
              p.ConfirmationDate;
			 -- cb.State;

--order by p.DocumentDate asc




