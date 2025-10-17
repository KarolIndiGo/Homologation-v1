-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_VIEW_V2_ERP_NOTAS_CREDITO_CONTABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0





/*******************************************************************************************************************
Nombre:[Report].[IND_VIEW_V2_ERP_NOTAS_CREDITO_CONTABILIDAD] 
Tipo:Vista
Observacion: Vista solicitada con el ticket 19475
Profesional:Nilsson Miguel Galindo
Fecha:14-08-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones: 
--------------------------------------
Version 3
Persona que modifico: 
Fecha: 
Observaciones:
***********************************************************************************************************************************/

CREATE VIEW [Report].[IND_VIEW_V2_ERP_NOTAS_CREDITO_CONTABILIDAD] AS


SELECT
		CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
		CASE AR.OpeningBalance WHEN 1 THEN 'SI' 
							   WHEN 0 THEN 'NO' END [SALDO INICIAL],
		CASE PN.Nature WHEN 1 THEN 'DEBITO'
					   WHEN 2 THEN 'CREDITO' END AS NATURE,
		PN.CODE AS [CODIGO NOTA],
		CASE PN.NoteType WHEN 1 THEN 'Factura Total'
						 WHEN 2 THEN 'Factura Cuota'
						 WHEN 3 THEN 'Anticipo'
						 WHEN 4 THEN 'Distribucion de Anticipo'
						 WHEN 6 THEN 'Factura Detallada'END AS [TIPO NOTA],
		CC.CODE AS [CODIGO CENTRO COSTO],
		CC.Name AS [DESCRIPCION CENTRO COSTO],
		PN.NoteDate AS [FECHA NOTA],
		CASE PND.Nature WHEN 1 THEN 'DEBITO' WHEN 2 THEN 'CREDITO' END [NATURALEZA MOVIMIENTO],
		MAIF.Number AS [NUMERO CUENTA FACTURACION],
		MAIF.Name AS [DESCRIPCION CUENTA FACTURACION],
		AR.InvoiceNumber AS [NRO FACTURA],
		PND.TotalConcept AS [VALOR FACTURA],
		FAC.invoicedate AS [FECHA FACTURA],
		PNARA.AdjusmentValue AS [VALOR AJUSTE],
		MAI.Number AS [NUMERO CUENTA AJUSTE],
		MAI.Name AS [DESCRIPCION CUNTA AJUSTE],
		TER.Nit AS [NIT CLIENTE],
		TER.Name AS [NOMBRE CLIENTE],
		PNC.Code AS [CODIGO CONCEPTO NOTA],
		PNC.Name AS [NOMBRE CONCEPTO NOTA],
		PER.Identification AS [IDENTIFICACION USUARIO CONFIRMACION],
		PER.Fullname AS [USUARIO CONFIRMACION],
		CAST(PN.NoteDate AS DATE) [FECHA BUSQUEDA],
		 YEAR(PN.NoteDate) AS [AÑO BUSQUEDA], 
		 MONTH(PN.NoteDate) AS [MES BUSQUEDA],
		 CASE MONTH(PN.NoteDate) WHEN 1 THEN 'ENERO'
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
								 WHEN 12 THEN 'DICIEMBRE' END AS [MES NOMBRE BUSQUEDA], 
		 DAY(PN.NoteDate) AS [DIA BUSQUEDA],
		 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
		GeneralLedger.JournalVouchers JV
		INNER JOIN Portfolio.PortfolioNote PN ON JV.EntityId=PN.Id AND JV.EntityName='PortfolioNote'
		LEFT JOIN Portfolio.PortfolioNoteAccountReceivableAdvance PNARA ON PN.ID=PNARA.PortfolioNoteId
		LEFT JOIN Portfolio.AccountReceivable AS AR ON PNARA.AccountReceivableId=AR.Id
		LEFT JOIN Portfolio.PortfolioNoteDetail PND ON PN.ID=PND.PortfolioNoteId
		LEFT JOIN Portfolio.PortfolioNoteConcept PNC ON PND.PortfolioNoteConceptId=PNC.Id
		LEFT JOIN Common.ThirdParty TER ON PND.ThirdPartyId=TER.Id
		LEFT JOIN Payroll.CostCenter CC ON PND.CostCenterId=CC.id
		LEFT JOIN Billing.Invoice FAC ON AR.InvoiceId=FAC.Id
		LEFT JOIN GeneralLedger.MainAccounts MAI ON PND.MainAccountId=MAI.Id
		LEFT JOIN GeneralLedger.MainAccounts MAIF ON PNARA.MainAccountId=MAIF.Id
		LEFT JOIN [Security].[User] US ON PN.ConfirmationUser=US.UserCode
		LEFT JOIN [Security].Person PER ON US.IdPerson=PER.Id
where	AR.OpeningBalance IN (0, 1)

