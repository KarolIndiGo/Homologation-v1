-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventarioFisico
-- Extracted by Fabric SQL Extractor SPN v3.9.0




    /*******************************************************************************************************************
Nombre: [Report].[ViewInventarioFisico]
Tipo:Vista
Observacion:Inventario fisico por almacen
Profesional: Nilsson Miguel Galindo Lopez
Fecha:03-08-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 01-02-2023
Ovservaciones: Se agrega el campo precio de venta por requerimiento de San Francisco
--------------------------------------
Version 3
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha: 21-11-2023
Observacion:Se adiciona los campos de IVA
--***********************************************************************************************************************************/


CREATE view [Report].[ViewInventarioFisico] as

WITH 
CTE_ENTRADA AS
(
select RED.ProductId,RE.DocumentDate,PRO.Name from 
Inventory.EntranceVoucher RE inner join
Inventory.EntranceVoucherDetail RED ON RE.Id=RED.EntranceVoucherId INNER JOIN 
Common.Supplier PRO ON RE.SupplierId=PRO.Id
)
SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
w.Name AS ALMACEN, 
INV.Code AS [CODIGO DE PRODUCTO], 
INV.CodeCUM AS [CODIGO CUM],
INV.Name AS PRODUCTO, 
ATC.CODE AS [CODIGO ATC],
DCI.CODE AS [CODIGO DCI],
AR.NAME AS [VIA DE ADMINISTRACION],
PG.NAME AS [GRUPO FARMACOLOGICO],
ATC.CONCENTRATION AS CONCENTRACION, 
RL.NAME AS [NIVEL DE RIESGO],
b.BatchCode AS LOTE, 
FAB.Name AS FABRICANTE,
CASE INV.ProductControl WHEN 0 THEN 'NO' 
						WHEN 1 THEN 'SI' END AS [DE CONTROL],
CASE INV.POSProduct WHEN 1 THEN 'SI'
					WHEN 0 THEN 'NO' END AS POS,
b.ExpirationDate AS [FECHA DE VENCIMIENTO], 
CASE WHEN DATEDIFF(DAY,GETDATE(),b.ExpirationDate)<=0 THEN 0 else DATEDIFF(DAY,GETDATE(),b.ExpirationDate) end AS [DIAS PARA VENCIMIENTO],
F.Quantity AS [CANTIDAD ACTUAL], 
INV.ProductCost AS [COSTO PROMEDIO], 
INV.FinalProductCost AS [COSTO ULTIMA COMPRA], 
CE.IvaValue AS [IVA ULTIMA COMPRA],
CE.IvaPercentage AS [% IVA ULTIMA COMPRA],
/*IN V2*/INV.SellingPrice AS [PRECIO DE VENTA],/*FN V2*/
CONVERT(date, INV.LastPurchase, 103) AS [FECHA ULTIMA COMPRA],
INV.MinimumStock AS [STOK MINIMO],
INV.MaximumStock AS [STOK MAXIMO],
(select top(1)[Name] from CTE_ENTRADA EN where INV.Id=EN.ProductId ORDER BY EN.DocumentDate ASC) AS PROVEEDOR,
INV.HealthRegistration AS [REGISTRO SANITARIO],
CAST(INV.ExpirationDate AS DATE) AS [FECHA DE VENCIMIENTO RS],
CAST(INV.LastPurchase AS date) AS [FECHA BUSQUEDA],
YEAR(INV.LastPurchase) AS [AÑO FECHA BUSQUEDA],
MONTH(INV.LastPurchase) AS [MES AÑO FECHA BUSQUEDA],
CASE MONTH(INV.LastPurchase) WHEN 1 THEN 'ENERO'
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
							 WHEN 12 THEN 'DICIEMBRE' END AS [MES NOMBRE FECHA BUSQUEDA],
FORMAT(DAY(INV.LastPurchase), '00') AS [DIA FECHA BUSQUEDA],
CONCAT(FORMAT(MONTH(b.ExpirationDate), '00') ,' - ', 
CASE MONTH(b.ExpirationDate) WHEN 1 THEN 'ENERO'
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
							 WHEN 12 THEN 'DICIEMBRE'END) MES_LABEL_VENCIMIENTO,
YEAR(b.ExpirationDate) AS [AÑO FECHA VENCIMIENTO],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM   
Inventory.PhysicalInventory AS F INNER JOIN
Inventory.Warehouse AS w ON w.Id = F.WarehouseId AND F.Quantity <> 0 INNER JOIN
Inventory.InventoryProduct AS INV ON INV.Id = F.ProductId LEFT JOIN
Inventory.BatchSerial AS b ON b.Id = F.BatchSerialId LEFT JOIN
Inventory.ATC AS ATC ON INV.ATCId=ATC.Id LEFT JOIN
Inventory.DCI AS DCI ON DCI.Id =ATC.DCIId LEFT JOIN
Inventory.AdministrationRoute AS AR ON ATC.AdministrationRouteId =AR.Id LEFT JOIN
Inventory.PharmacologicalGroup AS PG ON ATC.PharmacologicalGroupiD =PG.ID 
LEFT JOIN Inventory.InventoryRiskLevel AS RL ON ATC.InventoryRiskLevelId =RL.ID
LEFT JOIN Inventory.Manufacturer FAB ON INV.ManufacturerId=FAB.Id
LEFT JOIN Inventory.EntranceVoucherDetail CE ON F.ProductId=CE.ProductId AND CE.Id=(SELECT MAX(C.ID) FROM Inventory.EntranceVoucherDetail C WHERE F.ProductId=C.ProductId)
