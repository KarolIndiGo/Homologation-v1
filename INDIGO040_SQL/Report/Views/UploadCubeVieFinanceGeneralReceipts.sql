-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: UploadCubeVieFinanceGeneralReceipts
-- Extracted by Fabric SQL Extractor SPN v3.9.0






--CREATE PROCEDURE [GeneralLedger].[SP_COMPROBANTES_GENERAL]
--DECLARE	@FECINI Datetime='2024-05-01';
--declare	@FECFIN Datetime ='2024-05-02';
--AS


 CREATE VIEW [Report].[UploadCubeVieFinanceGeneralReceipts] as

	WITH sedes AS 
	(
		SELECT DISTINCT
			cc.code,
			br.name 
		FROM payroll.costcenter AS cc
		INNER JOIN payroll.functionalunit AS uf ON  cc.code = uf.code
		INNER JOIN payroll.branchoffice AS br ON uf.branchofficeid = br.id
	)

	SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
		ISNULL(sed.name,'N/A') 'SEDE',--[Sede],
		JV.Consecutive as 'NRO COMPROBANTE',--[NroComprobante],
		JVT.Code + ' - ' + JVT.Name 'TIPO COMPROBANTE',--[TipoComprobante],
		JV.VoucherDate 'FECHA COMPROBANTE',--[FechaComprobante], 
		case JV.Status 
			when 1 then 'Registrado' 
			when 2 then 'Confirmado' 
			when 3 then 'Anulado' end 'ESTADO',--[Estado],
		JV.EntityCode 'DOCUMENTO ORIGEN',--[DocumentoOrigen],
		case JV.EntityName WHEN 'InvoiceEntityCapitated' THEN 'Factura Capitada'
WHEN 'CashReceipts' THEN 'Recibo de Caja'
WHEN 'RemissionReclassification' THEN 'Remisión Reclasificación' 
WHEN 'FixedAssetDepreciation' THEN 'Depreciación'
WHEN 'FixedAssetTransaction' THEN 'Transacción de Activos Fijos'
WHEN 'Invoice' THEN 'Factura'
WHEN 'PharmaceuticalDispensingReclassification' THEN 'Reclasificación de dispensadores farmacéuticos'
WHEN 'ConsignmentInventoryRemission'THEN 'Remisión de Inventario en Consignación'
WHEN 'LoanMerchandiseDevolution'THEN 'Devolución de Préstamo de Mercancía'
WHEN 'PortfolioReclassification' THEN 'Reclasificación de Documentos de Cartera'
WHEN 'BasicBilling' THEN 'Factura Básica'
WHEN 'PaymentTransfer' THEN 'Cruce de Anticipo Vs CXP'
WHEN 'PortfolioTransfer' THEN 'Cruce de Anticipo vs CXC'
WHEN 'AccountPayable' THEN 'Cuentas por Pagar'
WHEN 'PaymentNotes' THEN 'Notas de Pago'
WHEN 'TreasuryNote' THEN 'Nota de Tesorería'
WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmacéutica'
WHEN 'ConstitutionCashSmaller' THEN 'Constitución Efectivo Más Pequeño'
WHEN 'LoanMerchandise' THEN 'Préstamo de Mercancía'
WHEN 'Consignment' THEN 'Consignación'
WHEN 'TransferOrderDevolution' THEN 'Devolución Orden de Traslado'
WHEN 'PharmaceuticalDispensingDevolutionReclassification' THEN 'Reclasificación de la devolución de la dispensación farmacéutica'
WHEN 'PharmaceuticalDispensingDevolution' THEN 'Devolución Dispensación Farmacéutica'
WHEN 'RemissionEntranceDevolution' THEN 'Devolución de entrada a la remisión'
WHEN 'RevenueRecognition' THEN 'Reconocimiento de ingresos'
WHEN 'FixedAssetEntryDevolution' THEN 'Devolución de Entrada de Activos Fijos'
WHEN 'InvoiceEntityCapitatedDistribution' THEN 'Distribución Monto Fijo'
WHEN 'ConsignmentInventoryRemissionDevolution' THEN 'Devolución de remisión de inventario en consignación' 
WHEN 'FixedAssetEntry' THEN 'Entrada de Activo Fijo'
WHEN 'TransferOrder'  THEN 'Orden de Traslado'
WHEN 'JournalVouchers' THEN 'Contabilidad'
WHEN 'InventoryAdjustment' THEN 'Ajuste de Inventario'
WHEN 'RemissionEntrance' THEN 'Remisión de Entrada'
WHEN 'FixedAssetActiveOutput' THEN 'Salida Activo'
WHEN 'PortfolioNote' THEN 'Nota Cuenta por Cobrar'
WHEN 'VoucherTransaction' THEN 'Comprobante Contable'
WHEN 'CrossingAccount' THEN 'Cruce de Cuentas'
WHEN 'ReverseRevenueRecognition' THEN 'Reconocimiento inverso de ingresos'
WHEN 'DeferredCausation' THEN 'Causación Diferido'
END
AS  'ORIGEN',--[Origen],
		MA.Number 'CUENTA CONTABLE',--[CuentaContable],
		MA.Name 'DESCRIPCION CUENTA',--[DescripcionCuenta],
		TP.Nit 'NIT',--[NIT],
		TP.Name 'TERCERO',--[Tercero] ,
		CC.Code AS 'CODIGO CENTRO COSTO',--[CodigoCentroCosto],
		CC.Name 'CENTRO COSTO',--[CentroCosto],
		JVD.DebitValue 'VALOR DEBITO',--[ValorDebito],
		JVD.CreditValue 'VALOR CREDITO',--[ValorCredito],
		JVD.Detail 'DETALLE',--[Detalle],
		jv.creationuser AS 'CODIGO USUARIO CREO',--[CodUsuarioCreo],
		pcre.fullname AS 'USUARIO CREO',--[UsuarioCreo],
		JV.ConfirmationUser 'CODIGO USUARIO CONFIRMO',--[CodUsuarioConfirmo], 
		PER.Fullname 'USUARIO CONFIRMO',--[UsuarioConfirmo],
		JV.ConfirmationDate 'FECHA CONFIRMACION',--[FechaConfirmacion]
	    CAST(JV.VoucherDate AS DATE) AS [FECHA BUSQUEDA],
	    CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
		--into INDIGODWH.GeneralLedger.STG_REPORTE_COMPROBANTES_CONTABLES
	FROM GeneralLedger .JournalVouchers JV WITH (NOLOCK)
	JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher  --AND jvt.id IN(033)
	JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JV.Id =JVD.IdAccounting 
	JOIN GeneralLedger .MainAccounts as MA WITH (NOLOCK) ON MA.Id =JVD.IdMainAccount 
	LEFT JOIN Security.[UserINT] AS USU WITH (NOLOCK) ON USU.UserCode =JV.ConfirmationUser 
	LEFT JOIN Security.PersonINT AS PER WITH (NOLOCK) ON PER.Id =USU.IdPerson 

	LEFT JOIN Security.[UserINT] AS ucre WITH (NOLOCK) ON jv.creationuser = ucre.usercode
	LEFT JOIN Security.PersonINT AS pcre WITH (NOLOCK) ON ucre.idperson = pcre.id

	LEFT JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =JVD.IdThirdParty 
	LEFT JOIN Payroll .CostCenter AS CC WITH (NOLOCK) ON CC.Id =JVD.IdCostCenter 
	LEFT JOIN sedes AS sed ON cc.code = sed.code -- linea insertada  el 2024-01-22
	/* Lineas comentadas el 2024-01-22
	LEFT JOIN Payroll .FunctionalUnit FU WITH (NOLOCK) ON FU.CostCenterId =CC.Id 
	LEFT JOIN Payroll .BranchOffice BO  WITH (NOLOCK) ON BO.Id  =FU.BranchOfficeId
	*/
	
	WHERE jv.LegalBookId = 1 AND YEAR(JV.VoucherDate)>=2024
	--CAST(JV.VoucherDate AS DATE) BETWEEN @FECINI AND @FECFIN


