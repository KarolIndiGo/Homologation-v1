-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventarioOrdenCvsCompronateE
-- Extracted by Fabric SQL Extractor SPN v3.9.0






/*******************************************************************************************************************
Nombre: Report.ViewInventarioOrdenCvsCompronateE
Tipo:Vista
Observacion:Comprobante de entrada VS orden de entrada
Profesional: Nilsson Miguel Galindo Lopez
Fecha:25-07-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Vercion 1
Persona que modifico: Nilsson Galindo
Fecha: 26-10-2023
Ovservaciones: Se quita condición, para que muestre todas las ordenes de compra
--------------------------------------
Vercion 2
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:1-11-2023
Ovservaciones:Se modifica la logica para que tambien el informe muestre las ordenes de entrada a si no tenga 
			  asociada una orden de compra.
--------------------------------------
Vercion 3
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:12-03-2024
Ovservaciones:sE GREGAN LOS CAMPOS DE LOTE, EMPAQUE, REGISTRO INVIME, CADENA DE FRIO Y CUENTAS POR PAGAR.
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewInventarioOrdenCvsCompronateE]
as

SELECT DISTINCT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
TER.Nit AS [NIT PROVEEDOR],
PRO.Name AS [PROVEEDOR],
ISNULL(OC.Code,'') AS [ORDEN DE COMPRA],
OC.ConfirmationDate AS [FECHA DE DOCUMENTO],
ALM.Name AS ALMACEN,
INV.Code+' - '+INV.Name AS PRODUCTO,
LOT.BatchCode AS [LOTE/SERIAL],
EMP.NAME AS [EMPAQUE],
INV.HealthRegistration AS [REGISTRO INVIMA],
CASE INV.Storage WHEN 1 THEN 'Ambiente: 20 ° C - 25 ° C (Permitida 15 ° C y 30 ° C)'
				 WHEN 2 THEN 'Ambiente controlada: 20 ° C - 25 ° C'
				 WHEN 3 THEN 'En frío: 8 ° C - 15 ° C'
				 WHEN 4 THEN 'Refrigerador: 2 ° C - 8 ° C'
				 WHEN 5 THEN 'Congelador: -25 ° C - 10 ° C' END AS [CADENA DE FRIO],
CONVERT(VARCHAR,CAST(OCD.Value AS MONEY),1) AS [VALOR UNITARIO O.C.],
CONVERT(VARCHAR,CAST(OCD.IvaValue AS MONEY),1) AS [VALOR DE IVA O.C.],
CONVERT(VARCHAR,CAST(OCD.SubTotalValue AS MONEY),1) AS [SUBTOTAL O.C.],
CONVERT(VARCHAR,CAST(OCD.TotalValue AS MONEY),1) AS [TOTAL VALOR O.C.],
ISNULL(OCD.Quantity,0) AS [CANTIDAD ORDEN DE COMPRA],
OED.Quantity AS [CANTIDAD COMPROBANTE DE ENTRADA],
ISNULL(OCD.OutstandingQuantity,-(OED.Quantity)) AS [CANTIDAD PENDIENTE],
OE.Code as [COMPROBANTE DE ENTRADA],
OE.ConfirmationDate AS [FECHA COMPROBANTE DE ENTRADA],
OE.InvoiceNumber AS FACTURA,
OE.InvoiceDate AS [FECHA FACTURA],
CONVERT(VARCHAR,CAST(OED.UnitValue AS MONEY),1) AS [VALOR UNITARIO C.E.],
CONVERT(VARCHAR,CAST(OED.IvaValue AS MONEY),1) AS [VALOR IVA C.E.],
CONVERT(VARCHAR,CAST(OED.SubTotalValue AS MONEY),1) AS [SUBTOTAL C.E.],
CONVERT(VARCHAR,CAST(OED.TotalValue AS MONEY),1) AS [TOTAL VALOR C.E.],
CP.CODE AS [CUENTA POR PAGAR],
 CAST(ISNULL(OE.ConfirmationDate,OC.ConfirmationDate) AS date) AS 'FECHA BUSQUEDA',
 YEAR(ISNULL(OE.ConfirmationDate,OC.ConfirmationDate)) AS 'AÑO FECHA BUSQUEDA',
 MONTH(ISNULL(OE.ConfirmationDate,OC.ConfirmationDate)) AS 'MES AÑO FECHA BUSQUEDA',
 CASE MONTH(ISNULL(OE.ConfirmationDate,OC.ConfirmationDate)) WHEN 1 THEN 'ENERO'
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
							   WHEN 12 THEN 'DICIEMBRE' END AS 'MES NOMBRE FECHA BUSQUEDA',
FORMAT(DAY(ISNULL(OE.ConfirmationDate,OC.ConfirmationDate)), '00') AS 'DIA FECHA BUSQUEDA',
CONCAT(FORMAT(MONTH(ISNULL(OE.ConfirmationDate,OC.ConfirmationDate)), '00') ,' - ', 
CASE MONTH(ISNULL(OE.ConfirmationDate,OC.ConfirmationDate)) WHEN 1 THEN 'ENERO'
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
							  WHEN 12 THEN 'DICIEMBRE' END) MES_LABEL_INGRESO,
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
from 
Inventory.PurchaseOrder OC 
INNER JOIN Inventory.PurchaseOrderDetail OCD ON OC.Id=OCD.PurchaseOrderId and OC.Status=2
FULL OUTER JOIN Inventory.EntranceVoucherDetail OED ON OCD.id=OED.PurchaseOrderDetailId
INNER JOIN Inventory.InventoryProduct INV ON ISNULL(OCD.ProductId,OED.ProductId)=INV.Id 
INNER JOIN Inventory.PackagingUnit EMP ON INV.PackagingUnitId=EMP.Id
LEFT JOIN Inventory.EntranceVoucher OE ON OED.EntranceVoucherId=OE.Id and OE.status=2
LEFT JOIN Common.Supplier PRO ON ISNULL(OC.SupplierId,OE.SupplierId)=PRO.Id
LEFT JOIN Common.ThirdParty TER ON PRO.IdThirdParty=TER.Id
LEFT JOIN Inventory.Warehouse ALM ON ISNULL(OC.WarehouseId,OE.WarehouseId)=ALM.Id
LEFT JOIN Payments.AccountPayable CP ON OE.Id=CP.EntityId AND CP.EntityName='EntranceVoucher'
LEFT JOIN Inventory.Kardex KD ON OE.ID=KD.EntityId AND KD.EntityName = 'EntranceVoucher'
LEFT JOIN Inventory.BatchSerial LOT ON KD.BatchSerialId=LOT.Id
--WHERE OE.Code='0100006507'

--15.237

--SELECT TOP 100 * FROM Inventory.EntranceVoucherDetail WHERE EntranceVoucherId='5661'
--SELECT TOP 100 * FROM Inventory.EntranceVoucher WHERE InvoiceNumber='FEV92921'

----select top 100* from Inventory.InventoryProduct
--select top 100* from Inventory.Kardex where EntityName = 'EntranceVoucher' and EntityId=5661
--SELECT * FROM Inventory.BatchSerial 
