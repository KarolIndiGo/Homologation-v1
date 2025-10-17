-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventarioSolicitudVsOrdenTraslado
-- Extracted by Fabric SQL Extractor SPN v3.9.0



    /*******************************************************************************************************************
Nombre: [Report].ViewInventarioSolicitudVsOrdenTraslado
Tipo:Vista
Observacion:Vista de solicitudes Vs ordenes de traslado
Profesional: Nilsson Miguel Galindo Lopez
Fecha:19-07-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Vercion 1
Persona que modifico: 
Fecha:
Ovservaciones: 
--------------------------------------
Vercion 2
Persona que modifico:
Fecha:
***********************************************************************************************************************************/
CREATE view [Report].[ViewInventarioSolicitudVsOrdenTraslado] as

WITH
CTE_TRASLADO AS
(
SELECT
ORTD.ID,
ORTD.InventoryRequestDetailId,
ORT.Code AS [Codigo Orden Traslado],
ORT.ConfirmationDate AS [Fecha Orden Traslado],
CASE ORT.Status WHEN 1 THEN 'Registrado' 
				WHEN 2 THEN 'Confirmado/Entregado' 
				WHEN 3 THEN 'Anulado' 
				WHEN 4 THEN 'En Transito' END AS [Estado Orden Traslado],
ORTD.Quantity AS [Cntidad Despachada]
FROM 
Inventory.TransferOrderDetail ORTD INNER JOIN
Inventory.TransferOrder ORT ON ORTD.TransferOrderId=ORT.Id AND ORT.Status=2
),
CTE_DEVOLUCION AS
(
SELECT 
BAT.TransferOrderDetailId,
BAT.Quantity,
OD.Code
FROM
Inventory.TransferOrderDetailBatchSerial BAT INNER JOIN
Inventory.TransferOrderDevolutionDetail ODD ON BAT.Id=ODD.TransferOrderDetailBatchSerialId INNER JOIN
Inventory.TransferOrderDevolution OD ON ODD.TransferOrderDevolutionId=OD.Id AND OD.Status=2
),
--------------------CTE CATIDAD ACTUAL DE PRODUCTOS------------------------------
CTE_INVETARIO_FISICO AS
(
SELECT
ProductId,
SUM(Quantity)AS CANTIDADP
FROM Inventory.PhysicalInventory 
GROUP BY ProductId
)

select 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
UOP.UnitCode+' - '+UOP.UnitName AS [Unidad Operativa],
SOL.Code AS[Codigo De Solicitud],
SOL.ConfirmationDate AS [Fecha de Solicitud],
CASE SOL.RequestType WHEN 1 THEN 'UNIDAD FUNCIONAL' ELSE 'ALMACEN' END AS [Tipo de Solicitud],
CASE WHEN SOL.TargetFunctionalUnitId IS NOT NULL THEN UFU.Code+' - '+UFU.Name ELSE ALM.Code+' - '+ALM.Name END AS [Solicitado Desde],
INV.Code AS [Codigo Producto],
INV.Name AS [Producto],
SOLD.Quantity AS [Cantidad Solicitada],
TRA.[Codigo Orden Traslado],
TRA.[Fecha Orden Traslado],
TRA.[Estado Orden Traslado],
TRA.[Cntidad Despachada],
SOLD.OutstandingQuantity AS [Cantidad Faltante],
DEV.Code AS [Codigo Devolucion],
DEV.Quantity AS [Cantidad Devuelta],
INVF.CANTIDADP AS [Cantidad Fisica],
 1 'CANTIDAD',
 CAST(SOL.ConfirmationDate AS date) AS 'FECHA BUSQUEDA',-- fecha confirmacion de la solicitud
 YEAR(SOL.ConfirmationDate) AS 'AÑO FECHA BUSQUEDA',
 MONTH(SOL.ConfirmationDate) AS 'MES AÑO FECHA BUSQUEDA',
 CASE MONTH(SOL.ConfirmationDate) WHEN 1 THEN 'ENERO'
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
FORMAT(DAY(SOL.ConfirmationDate), '00') AS 'DIA FECHA BUSQUEDA',
CONCAT(FORMAT(MONTH(SOL.ConfirmationDate), '00') ,' - ', 
CASE MONTH(SOL.ConfirmationDate) WHEN 1 THEN 'ENERO'
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
Inventory.InventoryRequest SOL INNER JOIN
Inventory.InventoryRequestDetail SOLD ON SOL.Id=SOLD.InventoryRequestId AND SOLD.OutstandingQuantity !=0 AND SOL.Status=2 JOIN
Inventory.InventoryProduct INV ON SOLD.InventoryProductId=INV.Id LEFT JOIN
CTE_TRASLADO TRA ON SOLD.Id=TRA.InventoryRequestDetailId LEFT JOIN
Common.OperatingUnit UOP ON SOL.OperatingUnitId=UOP.Id LEFT JOIN
Payroll.FunctionalUnit UFU ON SOL.TargetFunctionalUnitId=UFU.Id LEFT JOIN
Inventory.Warehouse ALM ON SOL.TargetWarehouseId=ALM.Id LEFT JOIN
CTE_DEVOLUCION DEV ON TRA.ID=DEV.TransferOrderDetailId LEFT JOIN
CTE_INVETARIO_FISICO INVF ON SOLD.InventoryProductId=INVF.ProductId


