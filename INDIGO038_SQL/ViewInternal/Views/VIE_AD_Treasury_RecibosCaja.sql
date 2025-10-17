-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Treasury_RecibosCaja
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VIE_AD_Treasury_RecibosCaja]
AS
SELECT uo.UnitName AS Sede, cr.Code AS [Nro Recibo], t.Nit, t.DigitVerification AS [Dígito verificación], t.Nit AS Tercero, t.Name AS NombreTercero, CASE cr.CollectType WHEN '1' THEN 'Caja' WHEN '2' THEN 'Bancos' END AS [Tipo de recaudo], c.Number AS Cuenta, c.Name AS [Nombre cuenta], cr.Detail AS Detalle, 
           cr.DocumentDate AS Fecha, CASE MONTH(cr.DocumentDate) 
           WHEN '1' THEN 'Ene' WHEN '2' THEN 'Feb' WHEN '3' THEN 'Mar' WHEN '4' THEN 'Abr' WHEN '5' THEN 'May' WHEN '6' THEN 'Jun' WHEN '7' THEN 'Jul' WHEN '8' THEN 'Ago' WHEN '9' THEN 'Sep' WHEN '10' THEN 'Oct' WHEN '11' THEN 'Nov' WHEN '12' THEN 'Dic' END AS Mes, DAY(cr.DocumentDate) AS Día, 
           cr.PaymentResponsibles AS [Responsable pago], cr.Value AS Valor, crc.Code AS Código, crc.Name AS Concepto, CASE cr.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' WHEN '4' THEN 'Reversado' END AS Estado, RTRIM(ccos.Code) + ' - ' + RTRIM(ccos.Name) AS CentroCosto, 
           dr.Value AS Vr, cr.CreationUser + ' - ' + p.Fullname AS Crea, cr.CreationDate AS [Fecha crea], cr.ModificationUser + '-' + pm.Fullname AS Modifica, cr.ModificationDate AS [Fecha mofica], cr.AnnulmentUser + ' - ' + pa.Fullname AS Anula, cr.AnnulmentDate AS [Fecha anula], cr.ConfirmationUser + ' - ' + pc.Fullname AS Confirma, 
           cr.ConfirmationDate AS [Fecha confirma], Caja.Code AS Caja, Caja.Name AS [Descripción Caja], nota.Description AS DetalleReversion, crc.Id AS ide, YEAR(cr.DocumentDate) AS Año, harc.Name AS Entidad
FROM   Treasury.CashReceipts AS cr  INNER JOIN
           Common.ThirdParty AS t  ON t.Id = cr.IdThirdParty INNER JOIN
           GeneralLedger.MainAccounts AS c  ON c.Id = cr.IdMainAccount INNER JOIN
           Security.[User] AS u  ON u.UserCode = cr.CreationUser INNER JOIN
           Security.Person AS p  ON p.Id = u.IdPerson LEFT OUTER JOIN
           Security.[User] AS um  ON um.UserCode = cr.ModificationUser LEFT OUTER JOIN
           Security.Person AS pm  ON pm.Id = um.IdPerson LEFT OUTER JOIN
           Security.[User] AS ua  ON ua.UserCode = cr.AnnulmentUser LEFT OUTER JOIN
           Security.Person AS pa  ON pa.Id = ua.IdPerson LEFT OUTER JOIN
           Security.[User] AS uc  ON uc.UserCode = cr.ConfirmationUser LEFT OUTER JOIN
           Security.Person AS pc  ON pc.Id = uc.IdPerson LEFT OUTER JOIN
           Treasury.CashRegisters AS cj  ON cj.Id = cr.IdCashRegister LEFT OUTER JOIN
           Common.SupplierBankAccount AS cb  ON cb.Id = cr.IdBankAccount LEFT OUTER JOIN
           Payroll.Bank AS b  ON b.Id = cb.BankId LEFT OUTER JOIN
           Common.OperatingUnit AS uo  ON uo.Id = cr.OperatingUnitId LEFT OUTER JOIN
           Treasury.CashReceiptDetails AS dr  ON dr.IdCashReceipt = cr.Id LEFT OUTER JOIN
           Treasury.CashReceiptConcepts AS crc  ON dr.IdCashReceiptConcept = crc.Id LEFT OUTER JOIN
           Treasury.CashRegisters AS Caja  ON Caja.Id = cr.IdCashRegister LEFT OUTER JOIN
           Treasury.TreasuryNote AS nota  ON nota.CashReceiptId = cr.Id LEFT OUTER JOIN
           Payroll.CostCenter AS ccos  ON ccos.Id = dr.IdCostCenter LEFT OUTER JOIN
           Common.ThirdParty AS Trc  ON Trc.Id = cr.IdThirdParty LEFT OUTER JOIN
           dbo.INPACIENT AS pac ON pac.IPCODPACI = Trc.Nit LEFT OUTER JOIN
           Contract.HealthAdministrator AS harc ON harc.Id = pac.GENCONENTITY


