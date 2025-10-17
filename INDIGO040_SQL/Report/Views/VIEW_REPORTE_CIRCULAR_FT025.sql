-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_REPORTE_CIRCULAR_FT025
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [Report].[VIEW_REPORTE_CIRCULAR_FT025] as

	/********************************** OBTENCION DE DATOS **********************************/

	SELECT	CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
            tp.Nit NIT, 
			tp.Name TERCERO,
			CASE ar.EntityType
				WHEN 1 THEN 1 -- EPS Contributivo
				WHEN 2 THEN 2 -- EPS Subsidiado
				WHEN 3 THEN 5 -- ET Vinculados Municipios
				WHEN 4 THEN 5 -- ET Vinculados Departamentos
				WHEN 5 THEN 8 -- ARL Riesgos Laborales
				WHEN 6 THEN 3 -- MP Medicina Prepagada
				WHEN 7 THEN 7 -- IPS Privada
				WHEN 8 THEN 7 -- IPS Publica
				WHEN 9 THEN 4 -- Regimen Especial
				WHEN 10 THEN 9 -- Accidentes de transito
				WHEN 11 THEN 4 -- Fosyga
				WHEN 12 THEN 4 -- Otros
				WHEN 13 THEN 7 -- Aseguradoras
				WHEN 99 THEN 3 -- Particulares
				ELSE 0
			END [TIPO ENTIDAD],
			CASE ar.LiquidationType
				WHEN 1 THEN 2 -- Pago por Servicios
				WHEN 2 THEN 1 -- Capitacion
				WHEN 3 THEN 3 -- Factura Global
				WHEN 4 THEN 1 -- Capitacion Global
				WHEN 5 THEN 3 --  Global Prospectivo - PGP
				ELSE 6
			END [TIPO LIQUIDACIO],
			IIF(ar.LiquidationType IN (1,2,3,4,5), 'NA', 'Otro Tipo de Contratación') [TIPO CONTRATO],
			SUM(ar.CollectionValue) [VALOR RECAUDADO],
			SUM(ar.InvoiceValue) [VALOR FACTURADO],
			CAST(ar.DocumentDate AS DATE) [FECHA],
			1 as 'CANTIDAD',
			CAST(ar.DocumentDate AS date) AS 'FECHA BUSQUEDA',
			YEAR(ar.DocumentDate) AS 'AÑO BUSQUEDA',
			MONTH(ar.DocumentDate) AS 'MES BUSQUEDA',
			CONCAT(FORMAT(MONTH(ar.DocumentDate), '00') ,' - ', 
			CASE MONTH(ar.DocumentDate) 
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
				  WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE BUSQUEDA',
		    CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
			
	FROM
	(
		SELECT	ar.ThirdPartyId,
				ISNULL(cg.EntityType, 0) EntityType,
				ISNULL(cg.LiquidationType, 0) LiquidationType,
				ar.Value InvoiceValue,
				0 CollectionValue,
				CAST(ri.ConfirmDate AS DATE) DocumentDate
		FROM Portfolio.RadicateInvoiceC ri
		JOIN Portfolio.RadicateInvoiceD rid ON ri.Id = rid.RadicateInvoiceCId AND rid.Devolution = 0
		JOIN Portfolio.AccountReceivable ar ON rid.InvoiceNumber = ar.InvoiceNumber AND ar.AccountReceivableType = 2
		LEFT JOIN Contract.CareGroup cg ON ar.CareGroupId = cg.Id
		WHERE ri.State IN ('2')
			--AND CAST(ri.ConfirmDate AS DATE) BETWEEN @InitialDate AND @EndDate
	UNION ALL
		SELECT	ar.ThirdPartyId,
				ISNULL(cg.EntityType, 0) EntityType,
				ISNULL(cg.LiquidationType, 0) LiquidationType,
				0 InvoiceValue,
				0 /*ISNULL(pt.TransferValue, 0) ISNULL(cr.CashReceiptValue, 0) +
				IIF(CAST(ri.ConfirmDate AS DATE) BETWEEN @InitialDate AND @EndDate, ISNULL(pt.PreviousTransferValue, 0) + ISNULL(cr.PreviousCashReceiptValue, 0), 0)*/ CollectionValue,
				CAST(cr.DocumentDate AS DATE)
		FROM Portfolio.RadicateInvoiceC ri
		JOIN Portfolio.RadicateInvoiceD rid ON ri.Id = rid.RadicateInvoiceCId AND rid.Devolution = 0
		JOIN Portfolio.AccountReceivable ar ON rid.InvoiceNumber = ar.InvoiceNumber AND ar.AccountReceivableType = 2
		LEFT JOIN Contract.CareGroup cg ON ar.CareGroupId = cg.Id
		LEFT JOIN
		(
			SELECT 
				ptd.AccountReceivableId,
				CAST(pt.RecersalDate AS DATE) DocumentDate 
				/*SUM(IIF(CAST(pt.DocumentDate AS DATE) BETWEEN @InitialDate AND @EndDate, 0, ptd.Value)) PreviousTransferValue,
				SUM(IIF(CAST(pt.DocumentDate AS DATE) BETWEEN @InitialDate AND @EndDate, ptd.Value, 0)) TransferValue*/				
			FROM Portfolio.PortfolioTransfer pt
			JOIN Portfolio.PortfolioTransferDetail ptd ON pt.Id = ptd.PortfolioTrasferId
			WHERE pt.Status IN (2, 4) 
				--AND ,
				--CAST(cr.DocumentDate AS DATE) <= @EndDate
				--AND CAST(ISNULL(pt.RecersalDate, DATEADD(DAY, 1, @EndDate)) AS DATE) > @EndDate
			GROUP BY ptd.AccountReceivableId, CAST(pt.RecersalDate AS DATE) 
		) pt ON ar.Id = pt.AccountReceivableId
		LEFT JOIN
		(
			SELECT 
				crar.AccountReceivableId,
				CAST(cr.DocumentDate AS DATE) DocumentDate
				/*SUM(IIF(CAST(cr.DocumentDate AS DATE) BETWEEN @InitialDate AND @EndDate, 0, crar.Value)) PreviousCashReceiptValue,
				SUM(IIF(CAST(cr.DocumentDate AS DATE) BETWEEN @InitialDate AND @EndDate, crar.Value, 0)) CashReceiptValue*/
			FROM Treasury.CashReceipts cr
			JOIN Treasury.CashReceiptDetails crd ON cr.Id = crd.IdCashReceipt
			JOIN Treasury.CashReceiptAccountReceivable crar ON crd.Id = crar.CashReceiptDetailId
			WHERE cr.Status IN (2 , 4)
				--AND CAST(cr.DocumentDate AS DATE) <= @EndDate
				--AND CAST(ISNULL(cr.ReversedDate, DATEADD(DAY, 1, @EndDate)) AS DATE) > @EndDate
			GROUP BY crar.AccountReceivableId, CAST(cr.DocumentDate AS DATE)
		) cr ON ar.Id = cr.AccountReceivableId
		WHERE ri.State IN ('2')
			--AND CAST(ri.ConfirmDate AS DATE) <= @EndDate
			--AND (ISNULL(pt.TransferValue, 0) + ISNULL(pt.PreviousTransferValue, 0) + ISNULL(cr.CashReceiptValue, 0) + ISNULL(cr.PreviousCashReceiptValue, 0)) > 0
	) ar
	JOIN Common.ThirdParty tp ON ar.ThirdPartyId = tp.Id
	WHERE CAST(ar.DocumentDate AS DATE) IS NOT NULL
	GROUP BY tp.Nit, tp.Name, ar.EntityType, ar.LiquidationType, CAST(ar.DocumentDate AS DATE)
	
