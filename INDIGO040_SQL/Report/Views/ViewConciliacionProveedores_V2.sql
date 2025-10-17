-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewConciliacionProveedores_V2
-- Extracted by Fabric SQL Extractor SPN v3.9.0











/*******************************************************************************************************************
Nombre: [Report].[ViewConciliacionProveedores_V2]
Tipo:View
Observacion: Trae inforcion de de cuentas por pagar, y su respectivo 
Profesional: Nilsson Miguel Galindo Lopez
Fecha: 16-11-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico: Nilsson Miguel Galindo Lopez		
Fecha:2024-08-23
Ovservaciones: Se cambia la logica para calcular el iva
--------------------------------------
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez	
Fecha:2024-09-18
Ovservaciones: sE AGREGA INFORMACIÓN DEL DOCUMENTO SOPORTE.
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewConciliacionProveedores_V2] as


WITH

CTE_CONCEPTOS AS
(
SELECT 
AD.IdAccountPayable,
SUM(AD.[VALUE]) AS [VALUE],
AD.NATURE
FROM 
Payments.AccountPayableDetailConcept AD INNER JOIN
Payments.AccountPayableConcepts AC ON AD.IdConceptAccountPayable=AC.Id AND IdRetentionConcept IS NULL
--WHERE AD.IdAccountPayable=6823
GROUP BY AD.IdAccountPayable,AD.NATURE
),

--CTE_IVA AS
--(
--	SELECT 
--	AD.IdAccountPayable,
--	SUM(AD.[VALUE]) AS [TOTAL],
--	SUM(AD.BaseValue) AS IVA
--	FROM 
--	Payments.AccountPayableDetailConcept AD INNER JOIN
--	Payments.AccountPayableConcepts AC ON AD.IdConceptAccountPayable=AC.Id AND (AC.[Name]='AD IMPUESTOS TASAS Y GRAVAMENES')
--	--WHERE AD.IdAccountPayable=14404
--	GROUP BY AD.IdAccountPayable
--	--99408.00
--),
CTE_IVA AS
(
	SELECT 
	AD.IdAccountPayable,
	SUM(AD.IvaValue) AS [TOTAL],
	SUM(AD.BaseValue) AS IVA
	FROM 
	Payments.AccountPayableDetailConcept AD INNER JOIN
	Payments.AccountPayableConcepts AC ON AD.IdConceptAccountPayable=AC.Id AND AD.IvaValue IS NOT NULL AND AD.IvaValue!='0.00'
	--WHERE AD.IdAccountPayable=24580
	GROUP BY AD.IdAccountPayable
),

CTE_RTIVA AS
(
	SELECT 
	AD.IdAccountPayable,
	SUM(AD.[VALUE]) AS [TOTAL],
	SUM(AD.BaseValue) AS IVA
	FROM 
	Payments.AccountPayableDetailConcept AD INNER JOIN
	Payments.AccountPayableConcepts AC ON AD.IdConceptAccountPayable=AC.Id AND (AC.[Name] LIKE '%RETEIVA%' OR AC.[Name] LIKE '%RETENCION IVA%')
	--WHERE AD.IdAccountPayable=14404
	GROUP BY AD.IdAccountPayable
	--99408.00
),
CTE_RTF AS
(
	SELECT 
	AD.IdAccountPayable,
	SUM(AD.[VALUE]) AS [TOTAL]
	FROM 
	Payments.AccountPayableDetailConcept AD 
	INNER JOIN payments.AccountPayableConcepts C ON AD.IdConceptAccountPayable=C.Id
	WHERE C.Code LIKE '%RF%'
	--WHERE AD.IdAccountPayable=6823
	GROUP BY AD.IdAccountPayable
),
CTE_ICA AS
(
	SELECT 
	AD.IdAccountPayable,
	SUM(AD.[VALUE]) AS [TOTAL]
	FROM 
	Payments.AccountPayableDetailConcept AD 
	WHERE AD.DETAIL LIKE '%RETENCION ICA%' OR AD.DETAIL LIKE '%RETENCIÓN ICA%'
	GROUP BY AD.IdAccountPayable
),

CTE_DESCUENTOS_FINANCIEROS AS
(
	SELECT 
	AccountPayableId,
	SUM(PNAP.AdjustmentValueShare) AS [VALUE],'CREDITO' AS NATURE
	FROM
	Payments.PaymentNotesAccountPayableAdvance PNAP  INNER JOIN
	Payments.PaymentNotes NCP ON PNAP.PaymentNoteId=NCP.Id AND NCP.Status=2 INNER JOIN
	Payments.PaymentsNoteDetails NCPD ON NCP.ID=NCPD.IdPaymentsNote AND IdAccount=2998
	GROUP BY AccountPayableId
),
CTE_NUMERO_CCP AS 
(
	SELECT 
	AD.IdAccountPayable,
	COUNT(AD.ID) AS NOTAS,
	AD.NATURE
	FROM 
	Payments.AccountPayableDetailConcept AD INNER JOIN
	Payments.AccountPayableConcepts AC ON AD.IdConceptAccountPayable=AC.Id AND IdRetentionConcept IS NULL
	--WHERE AD.IdAccountPayable=6823
	GROUP BY AD.IdAccountPayable,AD.NATURE
),

CTE_CUENTAS_BANCARIAS AS
(
	SELECT 
	ROW_NUMBER ( )   
	OVER (PARTITION BY SupplierId  order by SupplierId DESC) 'NUMERO',
	SupplierId,Number,BAN.Name
	FROM
	Common.SupplierBankAccount CB INNER JOIN
	Payroll.Bank BAN ON CB.BankId=BAN.Id
),

CTE_BASE AS
--TRAE LE VALOR VASE PARA REALIZAR EL CALCULOS DE LAS DIFERENTES RETENCIONES.
(
SELECT 
SUM(APDC.BaseValue) AS [BASE RETENCION],
APDC.IdAccountPayable
FROM 
Payments.AccountPayableDetailConcept APDC WHERE DETAIL LIKE '%RTF%'
GROUP BY APDC.IdAccountPayable
--DETAIL LIKE '%IVA TARIFA%'
--DETAIL LIKE '%IVA ARTICULO%'
),
--CTE_BASE_IVA AS
----TRAE LE VALOR VASE PARA REALIZAR EL CALCULOS DE LAS DIFERENTES RETENCIONES.
--(
--SELECT 
--APDC.BaseValue AS [BASE RETENCION],
--APDC.IdAccountPayable
--FROM 
--Payments.AccountPayableDetailConcept APDC WHERE DETAIL LIKE '%IVA TARIFA%' OR DETAIL LIKE '%IVA ARTICULO%'
--GROUP BY APDC.IdAccountPayable,APDC.BaseValue 
--),
----------------------------------------------------CTE'S PARA NOTAS---------------------------------------------------------
CTE_CONCEPTOS_NOTAS AS
(
SELECT 
IdPaymentsNote,
COUNT(NATURE) AS NUMERO,
SUM(VALUE) AS VALOR,
CASE Nature WHEN 1 THEN 'DEBITO' ELSE 'CREDITO' END AS NATURALEZA
FROM Payments.PaymentsNoteDetails 
WHERE Comments NOT LIKE '%RTF%' AND Comments NOT LIKE '%RETENCION ICA%' AND Comments NOT LIKE '%RETENCION IVA%'
GROUP BY IdPaymentsNote,Nature
),

CTE_NOTA_BASE AS
(
SELECT 
IdPaymentsNote,
BaseValue
FROM Payments.PaymentsNoteDetails 
WHERE Comments LIKE '%RTF%' AND Comments LIKE '%RETENCION ICA%'
GROUP BY IdPaymentsNote,BaseValue
),

CTE_NOTA_BASE_IVA AS
(
SELECT 
IdPaymentsNote,
BaseValue
FROM Payments.PaymentsNoteDetails 
WHERE Comments LIKE '%RETENCION IVA%'
GROUP BY IdPaymentsNote,BaseValue
),


CTE_NOTA_RTF AS
(
SELECT 
IdPaymentsNote,
COUNT(NATURE) AS NUMERO,
SUM(VALUE) AS VALOR,
CASE Nature WHEN 1 THEN 'DEBITO' ELSE 'CREDITO' END AS NATURALEZA
FROM Payments.PaymentsNoteDetails 
WHERE Comments LIKE '%RTF%'
GROUP BY IdPaymentsNote,Nature
),

CTE_NOTA_ICA AS
(
SELECT 
IdPaymentsNote,
COUNT(NATURE) AS NUMERO,
SUM(VALUE) AS VALOR,
CASE Nature WHEN 1 THEN 'DEBITO' ELSE 'CREDITO' END AS NATURALEZA
FROM Payments.PaymentsNoteDetails 
WHERE Comments LIKE '%RETENCION ICA%'
GROUP BY IdPaymentsNote,Nature
),
CTE_NOTA_IVA AS
(
SELECT 
IdPaymentsNote,
COUNT(NATURE) AS NUMERO,
SUM(VALUE) AS VALOR,
SUM(BaseValue) AS TOTAL,
CASE Nature WHEN 1 THEN 'DEBITO' ELSE 'CREDITO' END AS NATURALEZA
FROM Payments.PaymentsNoteDetails 
WHERE Comments LIKE '%RETENCION IVA%'
GROUP BY IdPaymentsNote,Nature
),

CTE_IVA_ACTIVOS_FIJOS AS
(
SELECT 
ATV.Id,
SUM(ATVD.IvaValue) AS ACT_IVA,
SUM(ATVD.SubTotalValue) AS ACT_BASE
FROM 
FixedAsset.FixedAssetEntry ATV
INNER JOIN FixedAsset.FixedAssetEntryItem ATVD ON ATV.Id=ATVD.FixedAssetEntryId AND IvaValue!='0.00'
GROUP BY ATV.Id
)
--SELECT * FROM FixedAsset.FixedAssetEntryItem
SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
CASE CP.EntityName WHEN 'EntranceVoucher' THEN 'COMPROBANTE DE ENTRADA' 
				   WHEN 'InitialBalance' THEN 'SALDO INICIAL' 
				   WHEN 'FixedAssetEntry' THEN 'ENTRADA DE ACTIVOS FIJOS' ELSE 'CUENTAS POR PAGAR' END [TIPO DE DOCUMENTO],
CP.EntityCode AS [CODIGO DEL DOCUMENTO],
CP.DocumentDate AS [FECHA CxP/ANTICIPO],
CP.Code AS [CUENTA CxP],
NULL AS [CODIGO NOTA CxP],
PRO.Code+' - '+PRO.Name AS PROVEEDOR,
CP.BillNumber AS FACTURA,
CASE CP.STATUS WHEN 1 THEN 'REGISTRADO'
			   WHEN 2 THEN 'CONFIRMADO'
			   WHEN 3 THEN 'ANULADO' END AS ESTADO,
NT1.NOTAS AS [#CONCEPTO DEBITO],
DEB.[Value] AS [VALOR CONCEPTO DEBITO],
NT2.NOTAS AS [#CONCEPTO CREDITO],
CRE.[Value] AS [VALOR CONCEPTO CREDITO],
B.[BASE RETENCION],
RTF.TOTAL AS [RETEFUENTE],
ICA.TOTAL AS [RETEICA],
RTIVA.TOTAL AS [RETEIVA],
ISNULL(IVA.IVA,ACT_BASE) AS [BASE IVA],
ISNULL(IVA.TOTAL,ACT_IVA) AS IVA,
PP.DiscountRate AS [PRONTO PAGO],
DFN.[VALUE] AS [DESCUENTOS FINANCIERO],
CP.[Value] AS [TOTAL CxP],
CP.InvoiceValue as [VALOR TOTAL FACTURA],
FE.NameConcept AS [FLUJO DE EFECTIVO],
CE.Code AS [COMPROBANTE EGRESO],
CE.[VALUE] AS [VALOR TOTAL C.E],
CE.CreationDate AS [FECHA C.E],
FD.AdvancedValue AS [C.E FACTURA],
CP.BALANCE AS [SALDO CxP],
CB.Number AS [CUENTA BANCARIA],
CB.[NAME] AS BANCO,
NULL AS [VALOR ANTICIPO],
NULL AS [SALDO],
DE.DocumentNumber AS [NUMERO DOCUMENTO SOPORTE],
DE.CUDS,
1 as 'CANTIDAD',
CAST(CP.DocumentDate AS date) AS 'FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
Payments.AccountPayable CP INNER JOIN
Common.Supplier PRO ON CP.IdSupplier=PRO.Id AND CP.Status=2 INNER JOIN
CTE_CONCEPTOS DEB ON CP.ID=DEB.IdAccountPayable AND DEB.NATURE=1 LEFT JOIN
CTE_NUMERO_CCP NT1 ON CP.ID=NT1.IdAccountPayable AND NT1.NATURE=1 LEFT JOIN
CTE_CONCEPTOS CRE ON CP.Id=CRE.IdAccountPayable AND CRE.NATURE=2 LEFT JOIN
CTE_NUMERO_CCP NT2 ON CP.ID=NT2.IdAccountPayable AND NT2.NATURE=2 LEFT JOIN
CTE_IVA IVA ON CP.Id=IVA.IdAccountPayable LEFT JOIN
CTE_RTIVA RTIVA ON CP.Id=RTIVA.IdAccountPayable LEFT JOIN
CTE_RTF RTF ON CP.Id=RTF.IdAccountPayable LEFT JOIN
CTE_ICA ICA ON CP.Id=ICA.IdAccountPayable LEFT JOIN
CTE_DESCUENTOS_FINANCIEROS DFN ON CP.Id=DFN.AccountPayableId LEFT JOIN
Treasury.DischargeBill FD ON CP.ID=FD.IdAccountPayable AND FD.ID=(SELECT MAX(F.ID) FROM Treasury.DischargeBill F WHERE FD.IdAccountPayable=F.IdAccountPayable) LEFT JOIN
Treasury.VoucherTransactionDetails CED ON FD.IdVoucherTransactionD=CED.Id LEFT JOIN
Treasury.VoucherTransaction CE ON CED.IdVoucherTransaction=CE.Id AND CE.STATUS=2 LEFT JOIN
CTE_CUENTAS_BANCARIAS CB ON PRO.ID=CB.SupplierId AND CB.NUMERO=1  LEFT JOIN
Treasury.CashFlowConcept FE ON CED.IdCashFlowConcept=FE.Id LEFT JOIN
Common.PromptPaymentDiscount PP ON PRO.ID=PP.SUPPLIERID
LEFT JOIN CTE_BASE B ON CP.ID=B.IdAccountPayable
LEFT JOIN CTE_IVA_ACTIVOS_FIJOS ACT ON CP.EntityId=ACT.Id AND CP.EntityName='FixedAssetEntry'
LEFT JOIN Billing.ElectronicSupportDocument DE ON CP.Id=DE.EntityId AND DE.EntityName='AccountPayable'
----LEFT JOIN CTE_BASE_IVA BIVA ON CP.Id=BIVA.IdAccountPayable
--WHERE CP.EntityName='FixedAssetEntry' and cp.Code='0000011583'
UNION ALL

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
CASE PN.EntityName WHEN 'EntranceVoucherDevolution' THEN 'DEVOLUCION DE COMPRA' ELSE 'NOTA CxP' END AS [TIPO DE DOCUMENTO],
PN.EntityCode AS [CODIGO DEL DOCUMENTO],
CP.DocumentDate AS [FECHA CxP/ANTICIPO],
CP.Code AS [CUENTA CxP],
PN.Code AS [CODIGO NOTA CxP],
PRO.Code+' - '+PRO.Name AS PROVEEDOR,
CP.BillNumber AS FACTURA,
CASE PN.STATUS WHEN 1 THEN 'REGISTRADO'
			   WHEN 2 THEN 'CONFIRMADO'
			   WHEN 3 THEN 'ANULADO' END AS ESTADO,
CCND.NUMERO AS [#CONCEPTO DEBITO],
CCND.VALOR AS [VALOR CONCEPTO DEBITO],
CCNC.NUMERO AS [#CONCEPTO CREDITO],
CCNC.VALOR AS [VALOR CONCEPTO CREDITO],
B.BaseValue AS [BASE RETENCION],
-(RTF.VALOR) AS [RETEFUENTE],
-(ICA.VALOR) AS [RETEICA],
-(IVA.TOTAL) AS [RETEIVA],
BIVA.BaseValue AS [BASE IVA],
-(IVA.VALOR) AS [IVA],
NULL AS [PRONTO PAGO],
NULL AS [DESCUENTOS FINANCIERO],
-(CCND.VALOR) AS [TOTAL CxP],
-(CP.InvoiceValue) as [VALOR TOTAL FACTURA],
NULL AS [FLUJO DE EFECTIVO],
NULL AS [COMPROBANTE EGRESO],
NULL AS [VALOR TOTAL C.E],
NULL AS [FECHA C.E],
NULL AS [C.E FACTURA],
CP.BALANCE AS [SALDO CxP],
NULL AS [CUENTA BANCARIA],
NULL AS BANCO,
NULL AS [VALOR ANTICIPO],
NULL AS [SALDO],
'' AS [NUMERO DOCUMENTO SOPORTE],
'' AS CUDS,
1 as 'CANTIDAD',
CAST(CP.DocumentDate AS date) AS 'FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
Payments.PaymentNotes PN
INNER JOIN Payments.PaymentNotesAccountPayableAdvance PNAPA ON PN.Id=PNAPA.PaymentNoteId AND PN.Status=2
INNER JOIN Payments.AccountPayable CP ON PNAPA.AccountPayableId=CP.Id
INNER JOIN Common.Supplier PRO ON CP.IdSupplier=PRO.Id
LEFT JOIN CTE_CONCEPTOS_NOTAS CCND ON PN.Id=CCND.IdPaymentsNote AND CCND.NATURALEZA='DEBITO'
LEFT JOIN CTE_CONCEPTOS_NOTAS CCNC ON PN.Id=CCNC.IdPaymentsNote AND CCNC.NATURALEZA='CREDITO'
LEFT JOIN CTE_NOTA_BASE B ON PN.Id=B.IdPaymentsNote
LEFT JOIN CTE_NOTA_RTF RTF ON PN.Id=RTF.IdPaymentsNote
LEFT JOIN CTE_NOTA_ICA ICA ON PN.Id=ICA.IdPaymentsNote
LEFT JOIN CTE_NOTA_IVA IVA ON PN.Id=IVA.IdPaymentsNote
LEFT JOIN CTE_NOTA_BASE_IVA BIVA ON PN.Id=BIVA.IdPaymentsNote
--WHERE CP.BillNumber='LB - 5861'
UNION ALL

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
CASE WHEN IBA.ID IS NOT NULL THEN 'ANTICIPOS SALDOS INICIALES' ELSE 'ANTICPOS' END AS [TIPO DE DOCUMENTO],
PA.CODE AS [CODIGO DEL DOCUMENTO],
PT.DocumentDate AS [FECHA CxP/ANTICIPO],
AP.Code AS [CUENTA CxP],
NULL AS [CODIGO NOTA CxP],
PRO.Code+' - '+PRO.Name AS PROVEEDOR,
AP.BillNumber AS FACTURA,
CASE PA.Status WHEN 1 THEN 'Registrado'
			   WHEN 2 THEN 'Confirmado'
			   WHEN 3 THEN 'Anulado' END AS ESTADO,
NULL AS [#CONCEPTO DEBITO],
NULL AS [VALOR CONCEPTO DEBITO],
NULL AS [#CONCEPTO CREDITO],
NULL AS [VALOR CONCEPTO CREDITO],
NULL AS [BASE RETENCION],
NULL AS [RETEFUENTE],
NULL AS [RETEICA],
NULL AS [RETEIVA],
NULL AS [BASE IVA],
NULL AS [IVA],
NULL AS [PRONTO PAGO],
NULL AS [DESCUENTOS FINANCIERO],
NULL AS [TOTAL CxP],
AP.Value AS [VALOR TOTAL FACTURA],
NULL AS [FLUJO DE EFECTIVO],
NULL AS [COMPROBANTE EGRESO],
NULL AS [VALOR TOTAL C.E],
NULL AS [FECHA C.E],
NULL AS [C.E FACTURA],
NULL AS [SALDO CxP],
NULL AS [CUENTA BANCARIA],
NULL AS BANCO,
AP.Value AS [VALOR ANTICIPO],
AP.Balance AS [SALDO],
'' AS [NUMERO DOCUMENTO SOPORTE],
'' AS CUDS,
1 as 'CANTIDAD',
CAST(PT.DocumentDate AS date) AS 'FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
Payments.AdvancePayments PA
INNER JOIN Payments.PaymentTransfer PT ON PA.Id=PT.AdvancePaymentId AND PA.Status=2
INNER JOIN Payments.PaymentTransferDetail PTD ON PT.Id=PTD.PaymentTransferId
INNER JOIN Common.Supplier PRO ON PA.IdSupplier=PRO.Id
LEFT JOIN Payments.AccountPayable AP ON PTD.AccountPayableId=AP.Id
LEFT JOIN Payments.InitialBalanceAdvance IBA ON PA.ID=IBA.AdvancePaymentsId
--WHERE ap.BillNumber='LB - 5861'
