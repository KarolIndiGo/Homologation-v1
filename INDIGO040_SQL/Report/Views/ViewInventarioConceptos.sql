-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventarioConceptos
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[ViewInventarioConceptos] as

WITH CTE_CONCEPTOS AS
(
select 
'03' AS CONCEPTO,
'Comprobante de Entrada' AS DESCRIPCION,
WarehouseId,ProductId,DocumentDate,Quantity,AverageCost
from Inventory.Kardex where EntityName = 'EntranceVoucher'
UNION ALL
select 
'04' AS CONCEPTO,
'Devolucion de Compra' AS DESCRIPCION,
WarehouseId,ProductId,DocumentDate,Quantity,AverageCost
from Inventory.Kardex where EntityName = 'EntranceVoucherDevolution'

UNION ALL
select 
'09' AS CONCEPTO,
'Dispensación Farmaceutica' AS DESCRIPCION,
WarehouseId,ProductId,DocumentDate,Quantity,AverageCost
from Inventory.Kardex where EntityName = 'PharmaceuticalDispensing'
UNION ALL
select 
'10' AS CONCEPTO,
'Devolucion Dispensacion Farmaceutica' AS DESCRIPCION,
WarehouseId,ProductId,DocumentDate,Quantity,AverageCost
from Inventory.Kardex where EntityName = 'PharmaceuticalDispensingDevolution'
UNION ALL
select 
'13' AS CONCEPTO,
'Orden de Traslado' AS DESCRIPCION,
K.WarehouseId,K.ProductId,K.DocumentDate,K.Quantity,K.AverageCost
from Inventory.Kardex K INNER JOIN
Inventory.TransferOrder OT ON K.EntityId=OT.ID AND OT.AdjustmentConceptId=5109
where K.EntityName = 'TransferOrder'
UNION ALL
select 
'14' AS CONCEPTO,
'Devolucion Orden de Traslado' AS DESCRIPCION,
WarehouseId,ProductId,DocumentDate,Quantity,AverageCost
from Inventory.Kardex where EntityName = 'TransferOrderDevolution'
),

CTE_PIVOT AS
(
SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
P.Code AS [Codigo Producto],
P.Name AS [Producto],
AL.Code AS [Codigo Almacen],
AL.Name AS Almacen,
CON.DESCRIPCION AS [Descripcion Concepto],
SUM(CON.Quantity) AS Cantidad,
CON.AverageCost AS [Valor Unitario],
YEAR(CON.DocumentDate) AS 'AÑO FECHA BUSQUEDA',
YEAR(CON.DocumentDate) AS 'AÑO BUSQUEDA',
MONTH(CON.DocumentDate) AS 'MES BUSQUEDA',
CONCAT(FORMAT(MONTH(CON.DocumentDate), '00') ,' - ', 
	   CASE MONTH(CON.DocumentDate) 
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
CTE_CONCEPTOS CON INNER JOIN
Inventory.InventoryProduct P ON CON.ProductId=P.ID INNER JOIN 
Inventory.Warehouse AL ON CON.WarehouseId=AL.Id
GROUP BY 
P.Code,P.Name,AL.Code,AL.Name,CON.DESCRIPCION,CON.AverageCost,YEAR(CON.DocumentDate),MONTH(CON.DocumentDate)
)
--select * from cte_pivot--194.786
SELECT * FROM 
(

	SELECT 
	ID_COMPANY,
	[Codigo Producto],
	Producto,
	[Codigo Almacen],
	Almacen,
	Pre.[Comprobante de Entrada],
	Pre.[Devolucion de Compra],
	Pre.[Dispensación Farmaceutica],
	Pre.[Devolucion Dispensacion Farmaceutica],
	Pre.[Orden de Traslado],
	Pre.[Devolucion Orden de Traslado],
	[Valor Unitario],
	[AÑO FECHA BUSQUEDA],
	[MES BUSQUEDA],
	[MES NOMBRE BUSQUEDA],
	ULT_ACTUAL
	FROM
	CTE_PIVOT
	SOURCE PIVOT (SUM(CANTIDAD) FOR [Descripcion Concepto] IN (
	[Comprobante de Entrada],
	[Devolucion de Compra],
	[Dispensación Farmaceutica],
	[Devolucion Dispensacion Farmaceutica],
	[Orden de Traslado],
	[Devolucion Orden de Traslado]))AS Pre
) AS CONCEPTOS
