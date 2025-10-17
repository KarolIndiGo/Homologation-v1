-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViweDetailedCxC
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*******************************************************************************************************************
Nombre: Portfolio.GetAccountReceivableByAgeDetail
Tipo:Vista
Observacion:Obtiene las cuentas por cobrar para el informe de cartera por edades detallado por movimiento contable
Profesional: Miguel Angel Fonseca Castro
Fecha:2020-04-27
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico:Nilsson miguel Galindo
Fecha:28-02-2024
Ovservaciones: se utiliza la logica de la funcion Portfolio.GetAccountReceivableByAgeDetail y se agrega los comprobantes contables
			cuando la factura se anula.
------------------------------------------------------------------------------------------
Version 2
Persona que modifico:
Fecha:
Observaciones:
--------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/
CREATE VIEW Report.ViweDetailedCxC
as
	WITH
	--CTE CUENTAS POR PAGAR 
	temp_receivable as (
		SELECT *
		FROM Portfolio.AccountReceivable 
		--WHERE InvoiceNumber='5173199'

	),

	--Tabla de reclasificacion de documentos de cartera (Glosas)
	cte_PReclassification AS (
	SELECT p.Id,p.AccountReceivableId,p.SourceAccountId,p.TargetAccountId,p.Value
	from Portfolio.PortfolioReclassification p
		),

	cte_PRUnion as 
	(
				SELECT  p.id,
						p.AccountReceivableId,
						p.SourceAccountId mainAccountId,
						[Value],
						0 TypeST
				from cte_PReclassification p

			UNION ALL

				SELECT  p.id,
						p.AccountReceivableId,
						p.TargetAccountId mainAccountId,
						0,
						1 TypeST
				from cte_PReclassification p
	),

	 tem_PR as (	SELECT	cte.id,
							cte.mainAccountId,
							cte.[Value],
							cte.TypeST,
							cte.AccountReceivableId
					from cte_PRUnion sub
						JOIN cte_PRUnion cte on sub.id = cte.id and cte.mainAccountId=sub.mainAccountId and cte.AccountReceivableId= sub.AccountReceivableId
						),
	cte_accounting as (
		SELECT 
		ara.Id,ara.AccountReceivableId,ara.MainAccountId,ara.Value
		from Portfolio.AccountReceivableAccounting ara
		JOIN Portfolio.AccountReceivable ar on ara.AccountReceivableId = ar.Id
						),
		--CUENTAS DE COBRO
		temp_RI AS (

		SELECT rid.InvoiceNumber, 
		ri.Id, 
		rid.RadicatedNumber, 
		rid.RadicatedDate
		FROM 
		Portfolio.RadicateInvoiceC ri WITH (NOLOCK)
		JOIN Portfolio.RadicateInvoiceD rid WITH (NOLOCK) ON ri.Id = rid.RadicateInvoiceCId
		inner join temp_receivable r on r.InvoiceNumber = rid.InvoiceNumber
		WHERE ri.State = 2 AND rid.State = 2
		--GROUP BY rid.InvoiceNumber
	),
	temp_ARS AS (
		SELECT	ars.InvoiceNumber,
				pibara.value InitialBalanceValue,
				pibara.MainAccountId
		FROM Portfolio.PortfolioInitialBalanceAccountReceivable  ars WITH (NOLOCK)
		JOIN Portfolio.PortfolioInitialBalanceAccountReceivableAccounting pibara WITH(NOLOCK) ON ars.Id=pibara.PortfolioInitialBalanceAccountReceivableId
	),
	temp_ARA AS (
			
				SELECT ara.Id,ara.AccountReceivableId,isnull(cte.[Value],0) ValueReclasification
				from cte_accounting ara
				inner JOIN Portfolio.AccountReceivable ar WITH(NOLOCK) on ara.AccountReceivableId=ar.Id
				inner join tem_PR cte on ara.MainAccountId=cte.mainAccountId and ara.AccountReceivableId = cte.AccountReceivableId
				--WHERE ar.OpeningBalance= 0 

				UNION ALL

				SELECT ara.Id,ara.AccountReceivableId,isnull(cte.[Value],0) ValueReclasification
				from cte_accounting ara
				inner JOIN Portfolio.AccountReceivable ar WITH(NOLOCK) on ara.AccountReceivableId=ar.Id
				inner JOIN cte_accounting aramin on ar.Id=aramin.AccountReceivableId
				left join tem_PR cte on ara.MainAccountId=cte.mainAccountId and ara.AccountReceivableId = cte.AccountReceivableId
				WHERE ar.OpeningBalance= 0 AND
				 NOT EXISTS(SELECT 1 from tem_PR where AccountReceivableId =ara.AccountReceivableId ) AND aramin.Id = ARA.Id
				
				UNION ALL

				SELECT ara.Id,ara.AccountReceivableId,isnull(cte.[Value],0) ValueReclasification
				from cte_accounting ara
				inner JOIN Portfolio.AccountReceivable ar WITH(NOLOCK) on ara.AccountReceivableId=ar.Id
				left join temp_ARS ars on ar.InvoiceNumber = ars.InvoiceNumber and ara.MainAccountId = ars.MainAccountId
				left join tem_PR cte on ara.MainAccountId=cte.mainAccountId and ara.AccountReceivableId = cte.AccountReceivableId
				WHERE ar.OpeningBalance=1 AND (ars.MainAccountId is not null OR cte.mainAccountId is not null)
	),
	--RETENCION DE FACTURAS
	temp_ICR AS (
		SELECT c.InvoiceId, MAX(c.CalculateTaxAdvance) CalculateTaxAdvance, 
		SUM(c.Value) InitialRetention
		FROM Billing.InvoiceCustomerRetention c WITH (NOLOCK)
		JOIN temp_receivable r on r.InvoiceId = c.InvoiceId
		GROUP BY c.InvoiceId
	),
	
	temp_PN AS (
		SELECT 
			pnara.AccountReceivableId,
			PN.Code,
			SUM(IIF(pn.Nature = 1, pnara.AdjusmentValue, 0)) DebitValue,
			SUM(IIF(pn.Nature = 1, 0, pnara.AdjusmentValue)) CreditValue,
			SUM(ISNULL(pnarr.AdjustmetRetentionValue, 0)) AdjustmetRetentionValue,
			PN.ConfirmationDate,
			--MAX(IIF(@InitialDate IS NOT NULL AND CAST(pn.NoteDate AS DATE) >= @InitialDate AND CAST(pn.NoteDate AS DATE) <= @ClosingDate, 1, 0)) InPeriod,
			1 AS InPeriod,
			pnara.AccountReceivableAccountingId
		FROM Portfolio.PortfolioNote pn WITH (NOLOCK)
		JOIN Portfolio.PortfolioNoteAccountReceivableAdvance pnara WITH (NOLOCK) ON pn.Id = pnara.PortfolioNoteId
		JOIN temp_receivable r on r.Id = pnara.AccountReceivableId
		LEFT JOIN
		(
			SELECT 
			PortfolioNoteAccountReceivableId, 
			SUM(Value * IIF(Nature = 1, 1, -1)) AdjustmetRetentionValue
			FROM Portfolio.PortfolioNoteAccountReceivableRetention WITH (NOLOCK)
			GROUP BY PortfolioNoteAccountReceivableId
		) pnarr ON pnara.Id = pnarr.PortfolioNoteAccountReceivableId
		WHERE pn.Status = 2
		GROUP BY pnara.AccountReceivableId,pnara.AccountReceivableAccountingId,PN.ConfirmationDate,PN.Code
	),

	---CRUCE DE ANTICIPOS
	temp_PT AS (SELECT 
				ptd.AccountReceivableId,
				pt.code,
				CAST(SUM(ptd.ValueInCurrencyInvoice) AS DECIMAL(18,2)) TransferValue,
				--MAX(IIF(@InitialDate IS NOT NULL AND CAST(pt.DocumentDate AS DATE) >= @InitialDate AND CAST(pt.DocumentDate AS DATE) <= @ClosingDate, 1, 0)) InPeriod
				1 AS InPeriod,
				ara.Id AccountReceivableAccountingId,
				PT.ConfirmationDate
			FROM Portfolio.PortfolioTransfer pt WITH (NOLOCK)
			JOIN Portfolio.PortfolioTransferDetail ptd WITH (NOLOCK) ON pt.Id = ptd.PortfolioTrasferId
			JOIN Portfolio.AccountReceivableAccounting ara ON ptd.AccountReceivableId=ara.AccountReceivableId AND ptd.MainAccountId = ara.MainAccountId
			JOIN temp_receivable r on r.Id = ptd.AccountReceivableId
			WHERE pt.Status IN (2, 4) 
			GROUP BY ptd.AccountReceivableId,ara.Id,pt.code,PT.ConfirmationDate
			),

	temp_CR AS (SELECT 
				crar.AccountReceivableId,
				SUM(crar.Value) CashReceiptValue,
				--MAX(IIF(@InitialDate IS NOT NULL AND CAST(cr.DocumentDate AS DATE) >= @InitialDate AND CAST(cr.DocumentDate AS DATE) <= @ClosingDate, 1, 0)) InPeriod,
				1 AS InPeriod,
				ara.Id AccountReceivableAccountingId
				FROM Treasury.CashReceipts cr WITH (NOLOCK)
				JOIN Treasury.CashReceiptDetails crd WITH (NOLOCK) ON cr.Id = crd.IdCashReceipt
				JOIN Treasury.CashReceiptAccountReceivable crar WITH (NOLOCK) ON crd.Id = crar.CashReceiptDetailId
				JOIN Portfolio.AccountReceivableAccounting ara WITH(NOLOCK) ON crar.AccountReceivableId = ara.AccountReceivableId AND ara.MainAccountId= crd.IdMainAccount
				JOIN temp_receivable r on r.Id = crar.AccountReceivableId
				WHERE cr.Status IN (2 , 4)
				GROUP BY crar.AccountReceivableId,ara.Id
			),

	temp_CA AS (
			SELECT 
				cad.AccountReceivableId,
				SUM(cad.CrossingValue) CrossingValue,
				--MAX(IIF(@InitialDate IS NOT NULL AND CAST(ca.DocumentDate AS DATE) >= @InitialDate AND CAST(ca.DocumentDate AS DATE) <= @ClosingDate, 1, 0)) InPeriod,
				1 AS InPeriod,
				cad.AccountReceivableAccountingId
			FROM Treasury.CrossingAccount ca WITH (NOLOCK)
			JOIN Treasury.CrossingAccountDetailCxC cad WITH (NOLOCK) ON ca.Id = cad.CrossingAccountId
			JOIN temp_receivable r on r.Id = cad.AccountReceivableId
			WHERE ca.Status = 2
			GROUP BY cad.AccountReceivableId,cad.AccountReceivableAccountingId
		),
		--Comprobante contable cuando una factura se anula.
		CTE_COMPROBANTE_CONTABLE AS
		(
		SELECT
		SUM(DebitValue) AS DEVITOVAUCHERS,
		JV.EntityId,
		JV.EntityCode,
		JV.Consecutive
		FROM 
		GeneralLedger.JournalVouchers JV
		INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JV.Id=JVD.IdAccounting
		INNER JOIN GeneralLedger.JournalVoucherTypes TJV ON JV.IdJournalVoucher=TJV.Id AND TJV.Name LIKE '%ANULA%'
		--where EntityName='invoice' and EntityCode='HSJS11091'
		GROUP BY JV.EntityId,JV.EntityCode,JV.Consecutive
		)

	SELECT DISTINCT
	--ar.Id AS [ID CxC],
	AR.Code AS [CODIGO CxC],
				ar.OperatingUnitId AS [UNIDAD OPERATIVA CxC],
				--ISNULL(i.InvoiceCategoryId,ar.InvoiceCategoryId) as [ID CATEGORIA FACTURA],
				ISNULL(ar.CareGroupId, i.CareGroupId) [ID GRUPO ATENCIÓN],
				--i.ContractId AS [ID CONTRATO FACTURA],
				--ar.ThirdPartyId AS [ID TERCERO],			
				TRIM(ar.InvoiceNumber) AS [NUMERO FACTURA], 
				i.InvoiceDate as [FECHA FACTURA],
				i.AdmissionNumber AS [INGRESO],
				ar.AccountReceivableDate AS [FECHA CxC], 
				ar.AccountReceivableType AS [TIPO DE CxC],
				ar.NumberShares AS [NUMERO CUOTAS CxC],
				ar.Term AS [PLAZO DIAS CxC],
				ar.OpeningBalance AS [SALDO INICIAL CxC],
				-----------------------------------------------------------------------------------------------------------
				CASE ara.MainAccountId WHEN ar.AccountRadicateId THEN 3
									   WHEN ar.AccountObjectionRemediedId THEN 4
									   WHEN ar.AccountHardCollectionId THEN 15
									   WHEN ar.AccountLegalCollectionId THEN 16 ELSE 1 END [ESTADO CxC],
				CASE	
					CASE ara.MainAccountId
						WHEN ar.AccountRadicateId THEN 3
						WHEN ar.AccountObjectionRemediedId THEN 4
						WHEN ar.AccountHardCollectionId THEN 15
						WHEN ar.AccountLegalCollectionId THEN 16
						ELSE 1
					END
					-----------------------
					WHEN 1 THEN 'Sin Radicar'
					WHEN 2 THEN 'Radicada Sin Confirmar'
					WHEN 3 THEN 'Radicada Entidad'
					WHEN 4 THEN 'Objetada o Glosada'
					WHEN 7 THEN 'Certificada Parcial'
					WHEN 8 THEN 'Certificada Total'
					WHEN 14 THEN 'Devolucion Factura'
					WHEN 15 THEN 'Cuenta de Dificil Recaudo'
					WHEN 16 THEN 'Cobro Jurídico'
				END AS [ESTADO CxC NOMBRE],
				IIF(ar.OpeningBalance = 1, ric.RadicatedNumber, ri.RadicatedConsecutive) RadicatedConsecutive,ri.CreationUser AS [USUARIO RADICACIÓN],
				IIF(ar.OpeningBalance = 1, ISNULL(ric.RadicatedDate, ri.ConfirmDate), ri.ConfirmDate) AS [FECHA RADICACIÓN],
				ri.State AS [ESTADO RADICACIÓN],
				pgr.RegimenName AS RegimenCalculated,	
				mar.Number AS [NUMERO CUENTA PUC], 
				ar.AccountWithoutRadicateId AS [ID CUENTA CONTABLE SIN RADICAR],
				ar.AccountRadicateId [ID CUENTA CONTABLE RADICADA],
				ar.AccountHardCollectionId AS [ID CUENTA CONTABLE DIFISIL RECAUDO],
				ara.MainAccountId AS [CUENTA CONTABLE],
				-----------------------------------------------------------------------------------------------------------
				ara.Value AS [VALOR],
				ISNULL(icr.InitialRetention, 0) + ISNULL(pn.AdjustmetRetentionValue, 0) [VALOR RETENCIÓN],
				--ISNULL(ars.InitialBalanceValue, isnull(ara.Value,0)) AS [SALDO INICIAL],
				PN.Code AS [CODIGO NOTA],
				PN.ConfirmationDate AS [FECHA NOTA],
				ISNULL(pn.DebitValue, 0) AS [NOTA DEBITO],
				ISNULL(pn.CreditValue, 0) AS [NOTA CREDITO],
				pt.Code as [CODIGO CRUCE ANTICIPO CxC],
				ISNULL(pt.TransferValue, 0) AS [VALOR CRUCE ANTICIPO VS CxC],
				PT.ConfirmationDate AS [FECHA CRUCE ANTICIPO CxC],
				ISNULL(cr.CashReceiptValue, 0) AS [VALOR FACTURA],
				ISNULL(ca.CrossingValue, 0) AS [VALOR CRUCE CxC],
				c.Name [MONEDA],
				I.Status AS [ESTADO FACTURA],
				I.AnnulmentDate AS [FECHA ANULACIÓN],
				CC.Consecutive AS [CONSECUTIVO COMPROBANTE CONTABLE],
				CAST(ISNULL(i.InvoiceDate,ar.AccountReceivableDate) AS DATE) AS [FECHA BUSQUEDA]
		FROM temp_receivable AS ar WITH (NOLOCK)
		LEFT JOIN Billing.Invoice AS i WITH (NOLOCK) ON ar.InvoiceId = i.Id
		LEFT JOIN GeneralLedger.MainAccounts AS mar WITH (NOLOCK) ON mar.Id = ar.AccountWithoutRadicateId 
		LEFT JOIN Portfolio.GetRegimes() pgr ON mar.Number = pgr.AccountNumber
		LEFT JOIN temp_RI ric ON ar.InvoiceNumber = ric.InvoiceNumber
		LEFT JOIN Portfolio.RadicateInvoiceC ri WITH (NOLOCK) ON ric.Id = ri.Id
		/************************************** ESTADO AL CORTE **************************************/
		LEFT JOIN temp_ARA aram ON ar.Id = aram.AccountReceivableId
		LEFT JOIN Portfolio.AccountReceivableAccounting ara WITH (NOLOCK) ON aram.Id = ara.Id
		/**************************************** RETENCIONES ****************************************/
		LEFT JOIN temp_ICR icr ON i.Id = icr.InvoiceId
		/****************************************** BALANCE ******************************************/
		LEFT JOIN temp_ARS ars ON ar.InvoiceNumber = ars.InvoiceNumber AND ara.MainAccountId = ars.MainAccountId
		--LEFT JOIN temp_ARS ars ON ar.OpeningBalance = 1 AND ar.Id = ars.AccountReceivableId
		LEFT JOIN temp_PN pn ON ar.Id = pn.AccountReceivableId AND ara.Id=pn.AccountReceivableAccountingId
		LEFT JOIN temp_PT pt ON ar.Id = pt.AccountReceivableId AND ara.Id=pt.AccountReceivableAccountingId
		LEFT JOIN temp_CR cr ON ar.Id = cr.AccountReceivableId AND ara.Id= cr.AccountReceivableAccountingId
		LEFT JOIN temp_CA ca ON ar.Id = ca.AccountReceivableId AND ara.Id= ca.AccountReceivableAccountingId
		--LEFT JOIN Portfolio.PortfolioReclassification pr WITH(NOLOCK) ON pr.AccountReceivableId= ar.Id AND pr.SourceAccountId =ara.MainAccountId
		/****************************************** MONEDA ******************************************/
		LEFT JOIN Common.Currency c on c.Id = ar.CurrencyId
		LEFT JOIN CTE_COMPROBANTE_CONTABLE CC ON AR.InvoiceId=CC.EntityId
		--WHERE --AR.Id='3106'
		--NOT (ISNULL(i.DocumentType, 1) = 5 AND ar.AccountReceivableType = 6) AND 
		--AR.InvoiceNumber='HSJS11091'

	



		--select * from GeneralLedger.AccountingMovement where id in (78015,181469)
		--select * from GeneralLedger.JournalVoucherTypes where Id in (29,30)
		--SELECT * FROM GeneralLedger.JournalVouchers WHERE Id='181462'
		--SELECT * FROM GeneralLedger.JournalVoucherDetails WHERE IdAccounting='181462'


		