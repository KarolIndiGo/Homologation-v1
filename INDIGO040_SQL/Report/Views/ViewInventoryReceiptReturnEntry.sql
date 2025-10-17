-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventoryReceiptReturnEntry
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[ViewInventoryReceiptReturnEntry]
Tipo:Vistas
Observacion:Vista sobre la devolucion vs comprobante de entrada de inventarios.
Profesional: Nilsson Miguel Galindo Lopez
Fecha:25-01-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha: 
Ovservaciones: 
--------------------------------------
Version 3
Persona que modifico:
Fecha:
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewInventoryReceiptReturnEntry] AS

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
EVD.Code AS [CODIGO DE DEVOLUCION], 
EVD.DocumentDate AS [FECHA DEVOLUCION], 
PR.Name AS PROVEEDOR, 
EV.InvoiceNumber AS [# FACTURA], 
EVD.Description AS DESCRIPCION, 
EVD.FreightIVAPercentage AS [% IVA], 
EVD.FreightIVAValue AS [VALOR IVA], 
EVD.Value AS [SUB TOTAL], 
EVD.WithholdingICA AS ICA, 
EVD.RetentionSource AS [BASE RETENCION], 
EVD.TotalValue AS TOTAL, 
CASE EVD.status WHEN 1 THEN 'Registrado' 
				WHEN 2 THEN 'Confirmado' 
				WHEN 3 THEN 'Anulado' END AS ESTADO,
'1' AS CATIDAD,
CAST (EVD.DocumentDate as date) 'FECHA BUSQUEDA',
YEAR(EVD.DocumentDate) AS 'AÑO FECHA BUSQUEDA',
MONTH(EVD.DocumentDate) AS 'MES AÑO FECHA BUSQUEDA',
CONCAT(FORMAT(MONTH(EVD.DocumentDate), '00') ,' - ', 
	   CASE MONTH(EVD.DocumentDate) 
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
		END) AS 'MES NOMBRE FECHA BUSQUEDA',
DAY(EVD.DocumentDate) AS 'DIA FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM     
Inventory.EntranceVoucherDevolution AS EVD INNER JOIN
Inventory.EntranceVoucher AS EV ON EV.Id = EVD.EntranceVoucherId INNER JOIN
Common.Supplier AS PR ON PR.Id = EV.SupplierId
