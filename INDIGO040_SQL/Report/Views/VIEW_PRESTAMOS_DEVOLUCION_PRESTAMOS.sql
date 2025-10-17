-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_PRESTAMOS_DEVOLUCION_PRESTAMOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [Report].[VIEW_PRESTAMOS_DEVOLUCION_PRESTAMOS] as

with cte_prestamo as
(
SELECT	ev.DocumentNumber [NUMERO COMPROBANTE],ev.DocumentDate [FECHA DOCUMENTO],CAST(ev.ConfirmationDate AS datetime ) [FECHA CONFIRMACION],ev.DocumentNumber [COMPROBANTE],
ev.LoanType [TIPO PRESTAMO],ev.UnitName [SEDE],
ev.Warehouse [BODEGA],ev.Operation [OPERACION],EV.tercero [TERCERO],
ev.ProductType [TIPO ACTIVIDAD],ev.CODIGO_PADRE [CODIGO PADRE],ev.NOMBRE_PADRE [NOMBRE PADRE],ev.HealthRegistration [REGISTRO SANITARIO],ev.ExpirationDate [FECHA EXPIRA REGISTRO],
EV.Code [CODIGO PRODUCTO],
ev.ProductName [PRODUCTO],ev.BatchCode [LOTE],ev.fechasanitario  [FECHA VENCIMIENTO],
ev.Quantity [CANTIDAD],ev.UnitValue [VALOR UNITARIO],(ev.Quantity * ev.UnitValue) [VALOR TOTAL],ev.CostCenter [CENTRO DE COSTO], 'PRESTAMOS DE INVENTARIOS' [TIPO]
FROM
(
	SELECT lm.Code DocumentNumber,lm.DocumentDate,lm.ConfirmationDate ,ou.UnitName,case lm.LoanType  when 1 then 'Entrada' when 2 then 'Salida' end LoanType,
	CONCAT(w.Code, ' - ', w.Name) Warehouse,IIF(lm.LoanType = 1, 'Suma', 'Resta') Operation,TP.Nit + ' - ' + tp.Name as tercero ,
	ISNULL(ATC.Code,ISS.Code ) AS CODIGO_PADRE,ISNULL(ATC.Name,ISS.SupplieName ) AS NOMBRE_PADRE,
pt.Name ProductType,ip.HealthRegistration,ip.ExpirationDate fechasanitario  ,ip.Code ,ip.Name ProductName,bs.BatchCode,bs.ExpirationDate,lmdbs.Quantity,lmd.UnitValue,cc.Name CostCenter
	FROM Common.OperatingUnit ou WITH (NOLOCK)
	JOIN Inventory.LoanMerchandise lm WITH (NOLOCK) ON ou.Id = lm.OperatingUnitId
	JOIN Inventory.LoanMerchandiseDetail lmd WITH (NOLOCK) ON lm.Id = lmd.LoanMerchandiseId
	JOIN Inventory.LoanMerchandiseDetailBatchSerial lmdbs WITH (NOLOCK) ON lmd.Id = lmdbs.LoanMerchandiseDetailId
	---------------------------------------------------------------------------------------------------------------
	JOIN Inventory.Warehouse w WITH (NOLOCK) ON lm.WarehouseId = w.Id
	JOIN Inventory.InventoryProduct ip WITH (NOLOCK) ON lmd.ProductId = ip.Id
	JOIN Inventory.ProductType pt WITH (NOLOCK) ON ip.ProductTypeId = pt.Id
	LEFT JOIN Inventory.ATC AS ATC WITH (NOLOCK) ON ATC.ID =IP.ATCId 
    LEFT JOIN Inventory.InventorySupplie AS ISS WITH (NOLOCK) ON ISS.ID =IP.SupplieId
	LEFT JOIN Inventory.BatchSerial bs WITH (NOLOCK) ON lmdbs.BatchSerialId = bs.Id
	---------------------------------------------------------------------------------------------------------------
	LEFT JOIN Payroll.CostCenter cc WITH (NOLOCK) ON cc.Id = w.CostCenterId
	LEFT JOIN Common.ThirdParty AS TP WITH (NOLOCK) ON TP.Id =lm.ThirdPartyId 
	WHERE lm.Status = 2 
) ev
UNION ALL
SELECT	ev.DocumentNumber [NUMERO COMPROBANTE],ev.DocumentDate [FECHA DOCUMENTO],ev.ConfirmationDate [FECHA CONFIRMACION],ev.documentoDevolver [COMPROBANTE],
'' [TIPO PRESTAMO],
ev.UnitName [SEDE],ev.Warehouse [BODEGA],ev.Operation [OPERACION],EV.tercero [TERCERO],
ev.ProductType [TIPO ACTIVIDAD],
ev.CODIGO_PADRE [CODIGO PADRE],ev.NOMBRE_PADRE [NOMBRE PADRE],ev.HealthRegistration [REGISTRO SANITARIO],ev.ExpirationDate [FECHA EXPIRA REGISTRO],EV.Code [CODIGO PRODUCTO],
ev.ProductName [PRODUCTO],ev.BatchCode [LOTE],ev.ExpirationDate [FECHA VENCIMIENTO],
ev.Quantity [CANTIDAD],ev.UnitValue [VALOR UNITARIO],(ev.Quantity * ev.UnitValue) [VALOR TOTAL],ev.CostCenter [CENTRO DE COSTO], 'DEVOLUCION PRESTAMOS DE INVENTARIOS' [TIPO]
FROM
(
	SELECT lmdev.Code DocumentNumber,lmdev.DocumentDate,lmdev.ConfirmationDate,lm.Code documentoDevolver ,ou.UnitName,CONCAT(w.Code, ' - ', w.Name) Warehouse,IIF(lm.LoanType = 1, 'Resta', 'Suma') Operation,
	TP.Nit + ' - ' + tp.Name as tercero ,
	ISNULL(ATC.Code,ISS.Code ) AS CODIGO_PADRE,ISNULL(ATC.Name,ISS.SupplieName ) AS NOMBRE_PADRE,
pt.Name ProductType,ip.HealthRegistration,ip.ExpirationDate fechasanitario ,ip .Code ,ip.Name ProductName,bs.BatchCode,bs.ExpirationDate,lmdevdbs.Quantity,lmd.UnitValue,cc.Name CostCenter
	FROM Inventory.LoanMerchandiseDevolution lmdev WITH (NOLOCK)
	JOIN Inventory.LoanMerchandiseDevolutionDetail lmdevd WITH (NOLOCK) ON lmdev.Id = lmdevd.LoanMerchandiseDevolutionId
	JOIN Inventory.LoanMerchandiseDevolutionDetailBatchSerial lmdevdbs WITH (NOLOCK) ON lmdevd.Id = lmdevdbs.LoanMerchandiseDevolutionDetailId
	JOIN Inventory.LoanMerchandiseDetail lmd WITH (NOLOCK) ON lmdevd.LoanMerchandiseDetaillId = lmd.Id
	JOIN Inventory.LoanMerchandise lm WITH (NOLOCK) ON lmd.LoanMerchandiseId = lm.Id
	JOIN Common.OperatingUnit ou WITH (NOLOCK) ON lm.OperatingUnitId = ou.Id
	---------------------------------------------------------------------------------------------------------------
	JOIN Inventory.Warehouse w WITH (NOLOCK) ON lm.WarehouseId = w.Id
	JOIN Inventory.InventoryProduct ip WITH (NOLOCK) ON lmd.ProductId = ip.Id
	JOIN Inventory.ProductType pt WITH (NOLOCK) ON ip.ProductTypeId = pt.Id
	LEFT JOIN Inventory .ATC AS ATC WITH (NOLOCK) ON ATC.ID =IP.ATCId 
    LEFT JOIN Inventory .InventorySupplie AS ISS WITH (NOLOCK) ON ISS.ID =IP.SupplieId
	---------------------------------------------------------------------------------------------------------------
	LEFT JOIN Inventory.PhysicalInventory phy WITH (NOLOCK) ON lmdevdbs.PhysicalInventoryId = phy.Id
	LEFT JOIN Inventory.BatchSerial bs WITH (NOLOCK) ON phy.BatchSerialId = bs.Id
	---------------------------------------------------------------------------------------------------------------
	LEFT JOIN Payroll.CostCenter cc WITH (NOLOCK) ON cc.Id = w.CostCenterId
	LEFT JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =lm.ThirdPartyId 
	WHERE lmdev.Status = 2
) ev

)

SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
  *,
 CAST([FECHA CONFIRMACION] AS date) AS 'FECHA BUSQUEDA',
 YEAR([FECHA CONFIRMACION]) AS 'AÑO BUSQUEDA',
 MONTH([FECHA CONFIRMACION]) AS 'MES BUSQUEDA',
 CONCAT(FORMAT(MONTH([FECHA CONFIRMACION]), '00') ,' - ', 
	   CASE MONTH([FECHA CONFIRMACION]) 
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
 cte_prestamo
