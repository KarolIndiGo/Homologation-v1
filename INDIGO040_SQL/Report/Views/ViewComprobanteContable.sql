-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewComprobanteContable
-- Extracted by Fabric SQL Extractor SPN v3.9.0


    /*******************************************************************************************************************
Nombre: Report.ViewComprobanteContable
Tipo:VISTA
Observacion:Se realiza esta vista solicitada en el tickete 18473, para auditar los usuarios que tuvieron que ver con el comprobante contable.
Profesional:Nilsson Miguel Galindo
Fecha:18-06-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
----------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/

CREATE VIEW Report.ViewComprobanteContable
AS

WITH
CTE_USUARIOS AS 
(
SELECT 
US.UserCode,
PER.Identification,
PER.Fullname
FROM
Security.[User] US
INNER JOIN Security.Person PER ON US.IdPerson=PER.Id
)

SELECT
JV.VoucherDate AS [FECHA DEL COMPROBANTE],
JV.EntityCode AS [CODIGO DEL COMPROBANTE],
CASE JV.Status WHEN 1 THEN 'Registrado'
			   WHEN 2 THEN 'Confirmado'
			   WHEN 3 THEN 'Anulado' END AS [ESTADO COMPROBANTE],
CASE JV.EntityName WHEN 'AccountPayable' THEN 'CUENTA POR PAGAR' 
				   WHEN 'BasicBilling' THEN 'FACTURACIÓN BASICA' 
				   WHEN 'CashReceipts' THEN 'RECIBOS DE CAJA' 
				   WHEN 'Consignment' THEN 'CONSIGNACIÓN' 
				   WHEN 'ConsignmentInventoryRemission' THEN 'REMISION DE CONSIGNACIÓN'
				   WHEN 'ConsignmentInventoryRemissionDevolution' THEN 'DEVOLUCIÓN REMISION DE CONSIGNACIÓN'
				   WHEN 'InvoiceEntityCapitated' THEN 'FACTURAS A ENTIDADES CAPITADAS'
				   WHEN 'ConstitutionCashSmaller' THEN 'FONDO DE CAJA MENOR' 
				   WHEN 'CrossingAccount' THEN 'CUENTAS POR COBRAR VS CUENTPAS POR PAGAR' 
				   WHEN 'DeferredCausation' THEN 'CAUSACIÓN DIFERIDA' 
				   WHEN 'FixedAssetDepreciation' THEN 'DEPRECIACIÓN DE ACTIVOS FIJOS' 
				   WHEN 'FixedAssetEntry' THEN 'INGRESO DE ARTICULOS'
				   WHEN 'FixedAssetEntryDevolution' THEN 'DEVOLUCIÓN INGRESO DE ARTICULOS' 
				   WHEN 'FixedAssetTransaction' THEN 'TRANSACCIONES' 
				   WHEN 'InventoryAdjustment' THEN 'AJUSTE DE INVENTARIO' 
				   WHEN 'Invoice' THEN 'FACTURACION'
				   WHEN 'InvoiceEntityCapitated' THEN 'FACTURACION ENTIDADES CAPITADAS'
				   WHEN 'InvoiceEntityCapitatedDistribution' THEN 'DISTRIBUCIÓN DE INGRESOS ASOCIADOS A FACTURA MONTO FIJO'
				   WHEN 'JournalVouchers' THEN 'CONTABILIZACIÓN'
				   WHEN 'LoanMerchandise' THEN 'PRESTAMO DE INVENTARIOS'
				   WHEN 'LoanMerchandiseDevolution' THEN 'DEVOLUCIÓN DE PRESTAMO DE INVENTARIOS'
				   WHEN 'PaymentNotes' THEN 'CUENTAS POR PAGAR'
				   WHEN 'PaymentTransfer' THEN 'TRASLADO DE PAGOS'
				   WHEN 'PharmaceuticalDispensing' THEN 'DISPENSACIÓN FARMACEUTICA'
				   WHEN 'PharmaceuticalDispensingDevolution' THEN 'DEVOLUCIÓN DISPENSACIÓN FARMACEUTICA'
				   WHEN 'PharmaceuticalDispensingDevolutionReclassification' THEN 'RECLASIFICACIÓN DEVOLUCIÓN DISPENSACIÓN FARMACEUTICA'
				   WHEN 'PharmaceuticalDispensingReclassification' THEN 'RECLASIFICACIÓN DISPENSACIÓN FARMACEUTICA'
				   WHEN 'PortfolioNote' THEN 'NOTAS CUENTAS POR COBRAR'
				   WHEN 'PortfolioProvisionAndDeterioration' THEN 'PROVISIÓN Y DETERIORO CARTERA'
				   WHEN 'PortfolioReclassification' THEN 'RECLASIFICACION DE CARTERA'
				   WHEN 'PortfolioTransfer' THEN 'TRASLADOS DE CARTERA'
				   WHEN 'RemissionEntrance' THEN 'COMPROBANTE DE ENTRADA'
				   WHEN 'RemissionEntranceDevolution' THEN 'DEVOLUCIÓN COMPROBANTE DE ENTRADA'
				   WHEN 'RemissionReclassification' THEN 'RECLASIFICACION COMPROBANTE DE ENTRADA'
				   WHEN 'RevenueRecognition' THEN 'RECONOCIMIENTO DE INGRESOS'
				   WHEN 'ReverseRevenueRecognition' THEN 'REVERSION DE INGRESOS'
				   WHEN 'TransferOrder' THEN 'ORDEN DE TRASLADO'
				   WHEN 'TransferOrderDevolution' THEN 'DEVOLUCIÓN ORDEN DE TRASLADO'
				   WHEN 'TreasuryNote' THEN 'NOTAS DE TESORERIA'
				   WHEN 'VoucherTransaction' THEN 'COMPROBANTE DE EGRESO'
				   ELSE JV.EntityName END AS [TIPO DE COMPROBANTE],
MA.Name AS [CUENTA CONTABLE],
CONVERT(DECIMAL(18,2),JVD.DebitValue) AS [DEBITO],
CONVERT(DECIMAL(18,2),JVD.CreditValue) AS [CREDITO],
JV.CreationDate AS [FECHA CREACION],
UCRE.Identification+' - '+UCRE.Fullname AS [USUARIO CREACION],
JV.ConfirmationDate AS [FECHA CONFIRMACION],
UCON.Identification+' - '+UCON.Fullname AS [USUARIO CONFIRMACION],
JV.AnnulmentDate AS [FECHA ANULACION],
UAN.Identification+' - '+UAN.Fullname AS [USUARIO ANULACION],
CAST(JV.VoucherDate AS DATE) AS [FECHA BUSQUEDA]
FROM 
GeneralLedger.JournalVouchers JV
INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JV.Id=JVD.IdAccounting
INNER JOIN GeneralLedger.MainAccounts MA ON JVD.IdMainAccount=MA.Id
LEFT JOIN CTE_USUARIOS UCRE ON JV.CreationUser=UCRE.UserCode
LEFT JOIN CTE_USUARIOS UCON ON JV.ConfirmationUser=UCON.UserCode
LEFT JOIN CTE_USUARIOS UAN ON JV.AnnulmentUser=UAN.UserCode


--SELECT EntityName FROM GeneralLedger.JournalVouchers GROUP BY EntityName ORDER BY EntityName
--SELECT TOP 100* FROM GeneralLedger.JournalVoucherDetails WHERE IdAccounting=1466
--SELECT * FROM GeneralLedger.MainAccounts