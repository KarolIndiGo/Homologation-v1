-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCashFlow
-- Extracted by Fabric SQL Extractor SPN v3.9.0






/*******************************************************************************************************************
Nombre: [Report].[ViewCashFlow]
Tipo:View
Observacion: Flujo de caja
Profesional: Nilsson Miguel Galindo Lopez
Fecha:16-05-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:25-04-2023
Observaciones: Para los comprobantes de egreso se agrega el campo concepto de pago, por solicitud de HOMI
--------------------------------------
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 09-11-2023
Observaciones: En tipo de nota se agrega el case 1 y 2
--------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 19-02-2024
Observaciones: Se agrega el campo de reponsable de pago, esto solicitado en el ticket 15071
--------------------------------------
Version 4
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 26-07-2024
Observaciones: Se CAMBIA LA LOGICA PAR EL CALCULO DE VALOR DE DETALLE CUANDO ES UN COMPROBANTE DE EGRESO. ESTO SOLICITADO POR HOMI EN EL TICKET 19372
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewCashFlow] AS

 ------Recibos de caja


SELECT	CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
		'RECIBOS DE CAJA' AS TIPO,
		CASE RC.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'Reversado' END ESTADO,
		RC.Code as CODIGO, --0000016579
		T.NIT, 
		T.Name AS TERCERO, 
		RC.PaymentResponsibles AS [RESPONSABLE DE PAGO],
		'Ingresos' AS 'INGRESO/EGRESO', 
		'' AS [TIPO DE COMPROBANTE], 
		CASE RC.CollectType WHEN 1 THEN 'Caja' 
							WHEN 2 THEN 'Bancos' END AFECTA, 
		C.Code + ' - ' + C.Name AS CAJA,
		B.Name + ' - ' + CB.Number CUENTA,
		CAST(RC.DocumentDate AS DATE) AS [FECHA DOCUMENTO], 
		CAST(RC.DocumentDate AS TIME) AS [HORA DOCUMENTO],
		CONVERT(money, RC.Value,100) AS [VALOR GENERAL], 
		CU.Number AS [CUENTA CONTABLE],
		CONVERT(money, RCD.Value, 100) AS [VALOR DETALLE], 
		CASE RCD.Nature WHEN 1 THEN 'Debito' 
						WHEN 2 THEN 'Credito' END AS NATURALEZA, 
		CASE MP.PaymentMethodTypes WHEN 1 THEN 'EFECTIVO'
								   WHEN 2 THEN 'CHEQUE'
								   WHEN 3 THEN 'TARJETA'
								   WHEN 4 THEN 'CONSIGNACIÓN'END AS METODO,
		CASE MP.PaymentMethodTypes WHEN 1 THEN ''
								   WHEN 2 THEN MP.CheckNumber
								   WHEN 3 THEN MP.CardNumber
								   WHEN 4 THEN MP.DepositNumber END REFERENCIA, 
		CU.Number AS [CUENTA DESTINO], 
		CRC.Code + ' - ' + CRC.Name AS [NOMBRE DESTINO], 
		'' AS 'BENEFICIARIO',
		CFE.Code + ' - ' + CFE.NameConcept FLUJO,
		'' AS [CONCEPTO DE PAGO],
		USU.NOMUSUARI AS [USUARIO],
		UO.UnitName AS SEDE, 
		RC.Detail AS DETALLE,
		1 as 'CANTIDAD',
		CAST(RC.DocumentDate AS date) AS 'FECHA BUSQUEDA'
		,YEAR(RC.DocumentDate) AS 'AÑO FECHA BUSQUEDA'
		,MONTH(RC.DocumentDate) AS 'MES AÑO FECHA BUSQUEDA'
		,CASE MONTH(RC.DocumentDate) 
			WHEN 1 THEN 'ENERO'
			WHEN 2 THEN 'FEBRERO'
			WHEN 3 THEN 'MARZO'
			WHEN 4 THEN 'ABRIL'
			WHEN 5 THEN 'MAYO'
			WHEN 6 THEN 'JUNIO'
			WHEN 7 THEN 'JULIO'
			WHEN 8 THEN 'AGOSTO'
			WHEN 9 THEN 'SEPTIEMBRE'
			WHEN 10 THEN 'OCTUBRE'
			WHEN 11 THEN 'NOVIEMBRE'
			WHEN 12 THEN 'DICIEMBRE'
		  END AS 'MES NOMBRE FECHA BUSQUEDA'
		, FORMAT(DAY(RC.DocumentDate), '00') AS 'DIA FECHA BUSQUEDA',
		CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM		Treasury.CashReceipts RC 
			JOIN Treasury.CashReceiptDetails RCD ON RCD.IdCashReceipt = RC.Id 
			LEFT JOIN Treasury.CashFlowConcept CFE ON RCD.IdCashFlowConcept = CFE.Id 
			JOIN Common.ThirdParty T ON RC.IdThirdParty = T .Id 
			LEFT JOIN Treasury.CashRegisters C ON RC.IdCashRegister = C.Id 
			LEFT JOIN Treasury.EntityBankAccounts CB ON RC.IdBankAccount = CB.Id 
			LEFT JOIN Payroll.Bank B ON CB.IdBank = B.Id 
			JOIN Treasury.CashReceiptConcepts CRC ON RCD.IdCashReceiptConcept = CRC.Id 
			--JOIN dbo.Homologo_FlujoCaja FC ON CONCAT('I', CRC.Id) = FC.Llave 
			JOIN GeneralLedger.MainAccounts CU ON CRC.IdMainAccount = CU.Id 
			JOIN Common.OperatingUnit UO ON RC.OperatingUnitId = UO.Id 
			LEFT JOIN dbo.SEGusuaru USU ON RC.CreationUser=USU.CODUSUARI 
			INNER JOIN Treasury.PaymentMethods MP ON RC.Id=MP.IdCashReceipt
			WHERE RC.Code='0000020811'

UNION ALL
---- COMPROBANTES DE EGRESO

SELECT	CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
		'COMPROBANTES DE EGRESO' AS TIPO,
		CASE CE.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'Reversado' END ESTADO,
		CE.Code AS CODIGO, 
		T.NIT, 
		T.Name AS TERCERO, 
		'' AS [RESPONSABLE DE PAGO],
		'' AS [INGRESO/EGRESO],
		CASE CE.VoucherClass WHEN 1 THEN 'Pagos' 
							 WHEN 2 THEN 'Reembolso' 
							 WHEN 3 THEN 'Traslados' END AS [TIPO DE COMPROBANTE], 
		CASE CE.ExpenseType WHEN 1 THEN 'Bancos' 
							WHEN 2 THEN 'Caja Menor' 
							WHEN 3 THEN 'Caja Mayor' 
							WHEN 4 THEN 'ProductoBancario' END AFECTA, 
		C.Code + ' - ' + C.Name AS CAJA,
		B.Name + ' - ' + CB.Number CUENTA,
		CAST(CE.DocumentDate AS DATE) AS [FECHA DOCUMENTO], 
		CAST(CE.DocumentDate AS TIME) AS [HORA DOCUMENTO],
		CONVERT(money, CE.Value, 100) AS [VALOR GENERAL], 
		CU.Number AS [CUENTA CONTABLE], 
		--IN V4 CASE WHEN (CE.VoucherClass <> 3) THEN CONVERT(money, CED.Value, 101) * - 1 
		--	 WHEN CE.VoucherClass = 3 THEN CONVERT(money, CED.Value, 101) END AS [VALOR DETALLE],
		CASE WHEN CED.Nature = 1 THEN CONVERT(money, CED.Value, 101) * - 1 
			 WHEN CED.Nature = 2 THEN CONVERT(money, CED.Value, 101) END AS [VALOR DETALLE],--IN V4
		CASE CED.Nature WHEN 1 THEN 'Debito' 
						WHEN 2 THEN 'Credito' END AS NATURALEZA, 
		CASE CE.PaymentMethod WHEN 1 THEN 'Cheque' 
							  WHEN 2 THEN 'NotaDebito' END AS Metodo,
		CASE CE.PaymentMethod WHEN 1 THEN CONVERT(varchar(15), CE.CheckNumber, 101) 
							  WHEN 2 THEN CE.NoteNumber END AS NUMERO, 
		CU1.Number AS [CUENTA DESTINO], 
		CU1.Name AS [NOMBRE DESTINO], 
		CE.BeneficiaryIdentification + ' - ' + CE.Beneficiary AS BENEFICIARIO,
		CFE.Code + ' - ' + CFE.NameConcept AS FLUJO, 
		TPC.Code+' - '+TPC.Name AS [CONCEPTO DE PAGO],
		USU.NOMUSUARI AS [USUARIO],
		UO.UnitName AS SEDE, 
		CE.Detail AS DETALLE,
		1 as 'CANTIDAD',
		CAST(CE.DocumentDate AS date) AS 'FECHA BUSQUEDA'
		, YEAR(CE.DocumentDate) AS 'AÑO FECHA BUSQUEDA'
		, MONTH(CE.DocumentDate) AS 'MES AÑO FECHA BUSQUEDA'
		, CASE MONTH(CE.DocumentDate) 
			WHEN 1 THEN 'ENERO'
			WHEN 2 THEN 'FEBRERO'
			WHEN 3 THEN 'MARZO'
			WHEN 4 THEN 'ABRIL'
			WHEN 5 THEN 'MAYO'
			WHEN 6 THEN 'JUNIO'
			WHEN 7 THEN 'JULIO'
			WHEN 8 THEN 'AGOSTO'
			WHEN 9 THEN 'SEPTIEMBRE'
			WHEN 10 THEN 'OCTUBRE'
			WHEN 11 THEN 'NOVIEMBRE'
			WHEN 12 THEN 'DICIEMBRE'
		  END AS 'MES NOMBRE FECHA BUSQUEDA'
		, FORMAT(DAY(CE.DocumentDate), '00') AS 'DIA FECHA BUSQUEDA',
		CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM   		Treasury.VoucherTransaction CE JOIN
			Treasury.VoucherTransactionDetails CED ON CED.IdVoucherTransaction = CE.Id AND CE.ExpenseType <> 2 LEFT JOIN
			Treasury.CashFlowConcept CFE ON CED.IdCashFlowConcept = CFE.Id JOIN
			Common.ThirdParty T ON CE.IdThirdParty = T .Id LEFT JOIN
			Treasury.CashRegisters C ON CE.IdCashRegister = C.Id LEFT JOIN
			Treasury.EntityBankAccounts CB ON CE.IdEntityBankAccount = CB.Id LEFT JOIN
			Payroll.Bank B ON CB.IdBank = B.Id LEFT JOIN
			Treasury.ExpenseConcepts CRC ON CED.IdExpenseConcept = CRC.Id LEFT JOIN
			GeneralLedger.MainAccounts CU ON CE.IdMainAccount = CU.Id LEFT JOIN
			Common.OperatingUnit UO ON CE.IdUnitOperative = UO.Id LEFT JOIN
			GeneralLedger.MainAccounts CU1 ON CED.IdMainAccount = CU1.Id LEFT JOIN
			dbo.SEGusuaru USU ON CE.CreationUser=USU.CODUSUARI LEFT JOIN
			Treasury.SchedulePaymentDetail SPD ON CE.Id=SPD.VoucherTransactionId AND SPD.Id=(SELECT MAX(A.Id) FROM Treasury.SchedulePaymentDetail A WHERE CE.Id=A.VoucherTransactionId) LEFT JOIN
			Treasury.TreasuryPaymentConcepts TPC ON SPD.PaymentConceptId=TPC.Id
			--where ce.Code='0000021798'
			--order by CED.Value
UNION ALL
---- Notas

Select CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
		'NOTAS DE TESORERIA' AS TIPO,
		CASE N.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END ESTADO,
		N.Code AS CODIGO,
		T.Nit, 
		T.Name AS TERCERO,
		'' AS [RESPONSABLE DE PAGO],
		CASE N.NoteType WHEN 1 THEN 'Nota a Cuenta Bancaria'
						WHEN 2 THEN 'Nota a caja' 
						WHEN 3 THEN 'Reversión de Comprobante de Egreso' 
						WHEN 4 THEN 'Reversión de Recibo de caja' 
						WHEN 5 THEN 'Reversión de Consignacion'
						WHEN 7 THEN 'Devolución de Recibo de caja' END [INGRESO/EGRESO], --WHEN 1 THEN 'Cuenta Bancaria'
		'' AS [TIPO DE COMPROBANTE], 
		CASE N.NoteType WHEN 1 THEN 'CTA' + CB.Number 
						--WHEN 2 THEN CashRegisterId 
						WHEN 3 THEN 'CE' + CE.Code 
						WHEN 4 THEN 'RC' + RC.Code	
						WHEN 5 THEN 'C' + C.Code 
						WHEN 7 THEN 'RC' + RC.Code	END AFECTA,
		'' Caja,
		'' Cuenta,
		CAST(N .NoteDate AS DATE) AS [FECHA DOCUMENTO], 
		CAST(N .NoteDate AS TIME) AS [HORA DOCUMENTO],
		CASE WHEN (N.NoteType = 3) THEN CONVERT(money, CE.Value, 101) * - 1 
			 WHEN n.NoteType = 4 THEN CONVERT(money, RC.Value, 101) * - 1
			 WHEN N.NoteType = 5 THEN CONVERT(money, C.Value, 101) * - 1
			 WHEN N.NoteType = 7 THEN CONVERT(money, RC.Value, 101) * - 1 END AS [VALOR DETALLE],
		CB.Number AS CuentaContable, 
		(CONVERT(money, ND.Value, 101) * - 1) AS [VALOR DETALLE], 
		CASE ND.Nature WHEN 1 THEN 'Debito' 
					   WHEN 2 THEN 'Credito' END AS NATURALEZA, 
		'' AS METODO, 
		'' AS REFERENCIA, 
		'' AS [CUENTA DESTINO], 
		'' AS [NOMBRE DESTINO], 
		'' AS BENEFICIARIO, 
		CFE.Code + ' - ' + CFE.NameConcept FLUJO, 
		'' AS [CONCEPTO DE PAGO],
		USU.NOMUSUARI AS [USUARIO],
		UO.UnitName AS SEDE, 
		N .Description AS DETALLE,
		1 as 'CANTIDAD',
		CAST(N .NoteDate AS date) AS 'FECHA BUSQUEDA'
		, YEAR(N .NoteDate) AS 'AÑO FECHA BUSQUEDA'
		, MONTH(N .NoteDate) AS 'MES AÑO FECHA BUSQUEDA'
		, CASE MONTH(N .NoteDate) 
			WHEN 1 THEN 'ENERO'
			WHEN 2 THEN 'FEBRERO'
			WHEN 3 THEN 'MARZO'
			WHEN 4 THEN 'ABRIL'
			WHEN 5 THEN 'MAYO'
			WHEN 6 THEN 'JUNIO'
			WHEN 7 THEN 'JULIO'
			WHEN 8 THEN 'AGOSTO'
			WHEN 9 THEN 'SEPTIEMBRE'
			WHEN 10 THEN 'OCTUBRE'
			WHEN 11 THEN 'NOVIEMBRE'
			WHEN 12 THEN 'DICIEMBRE'
		  END AS 'MES NOMBRE FECHA BUSQUEDA'
		, FORMAT(DAY(N .NoteDate), '00') AS 'DIA FECHA BUSQUEDA',
		CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
From	Treasury.TreasuryNote N LEFT JOIN
		Treasury.TreasuryNoteDetail ND ON ND.TreasuryNoteId = N .Id	and N.NoteType NOT IN (1) LEFT JOIN
		Treasury.CashFlowConcept CFE ON ND.IdCashFlowConcept = CFE.Id LEFT JOIN
		Treasury.EntityBankAccounts CB ON CB.Id = N.EntityBankAccountId LEFT JOIN
		Treasury.VoucherTransaction CE ON CE.Id = N.VoucherTransactionId LEFT JOIN
		Treasury.CashReceipts RC ON RC.Id = N.CashReceiptId LEFT JOIN
		Treasury.Consignment C ON C.Id = N.ConsignmentId LEFT JOIN 
		Common.OperatingUnit UO ON N .OperatingUnitId = UO.Id LEFT JOIN
		dbo.SEGusuaru USU ON N.CreationUser=USU.CODUSUARI,
		Common.ThirdParty T
WHERE	ND.ThirdPartyId = T.Id OR
		CE.IdThirdParty = T.Id OR
		RC.IdThirdParty = T.Id
--ORDER BY [FECHA DOCUMENTO]
