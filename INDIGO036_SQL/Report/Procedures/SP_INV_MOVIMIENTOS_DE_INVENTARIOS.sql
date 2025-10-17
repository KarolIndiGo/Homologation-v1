-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_INV_MOVIMIENTOS_DE_INVENTARIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE PROCEDURE [Report].[SP_INV_MOVIMIENTOS_DE_INVENTARIOS]
 @FechaInicial Datetime, 
 @FechaFinal Datetime 

AS


-----------------------------------*********************************************************---
------ DEVOLUCION DE DISPENSACIONES----  *********************YA REVISADO***********************
WITH CTE_KARDEX_DEVOLUCIONES_DISPENSACIONES_UNICOS
AS
(
  SELECT DISTINCT  K.EntityId ,K.EntityCode  
  FROM Inventory .Kardex K 
  WHERE K.EntityName ='PharmaceuticalDispensingDevolution' AND cast(k.DocumentDate  AS DATE) BETWEEN @FechaInicial AND @FechaFinal
),
CTE_DEVOLUCIONES_DISPENSACIONES
AS
(
 SELECT PDD.CODE 'CODIGO DEVOLUCION',CAST(PDD.DocumentDate AS DATE) 'FECHA DEVOLUCION',PD.Code 'CODIGO DE LA DISPENSACION',W.Code 'CODIGO ALMACEN',
  RTRIM(W.Name) 'ALMACEN',FU.Name 'UNIDAD FUNCIONAL',ISNULL(ATC.Code,ISS.Code ) AS 'CODIGO PADRE',RTRIM(ISNULL(ATC.Name,ISS.SupplieName )) AS 'NOMBRE PADRE', TP2.Name AS 'NOMBRE PROVEEDOR',
  IP.Code 'CODIGO PRODUCTO', RTRIM(IP.Name) 'PRODUCTO',PDDD.Quantity 'CANTIDAD DEVUELTA',PDDE.AverageCost 'PRECIO',
  PDDD.Quantity*PDDE.AverageCost 'COSTO TOTAL',bs.BatchCode 'LOTE',bs.ExpirationDate 'FECHA VENCIMIENTO',PDD.AdmissionNumber INGRESO,CAST(ING.IFECHAING AS DATE) as 'FECHA INGRESO',
  PAC.IPCODPACI AS 'IDENTIFICACION',RTRIM(PAC.IPNOMCOMP) AS 'PACIENTE',TP2.Nit NIT,RTRIM(HA.Name) AS ENTIDAD,RTRIM(CG.Name) AS 'GRUPO ATENCION',
  CASE PT.Class WHEN 2 THEN 'MEDICAMENTO' WHEN 3 THEN 'INSUMO' ELSE 'OTRO' END 'TIPO PRODUCTO',year(PDD.DocumentDate) 'AÑO',month(PDD.DocumentDate) 'MES',
  'Entrada' 'TIPO',IP.MinimumStock 'STOCK MINIMO' ,IP.MaximumStock 'STOCK MAXIMO',IP.ProductCost 'COSTO PRODUCTO'
  --, PDDE.ProductId IdProducto,PDD.id IdDev
  FROM Inventory .PharmaceuticalDispensingDevolution PDD
  INNER JOIN CTE_KARDEX_DEVOLUCIONES_DISPENSACIONES_UNICOS AS KAR ON KAR.EntityId =PDD.Id 
  INNER JOIN Inventory .PharmaceuticalDispensingDevolutionDetail AS PDDD ON PDD.ID =PDDD.PharmaceuticalDispensingDevolutionId
  INNER JOIN dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =PDD.AdmissionNumber 
  INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =ING.IPCODPACI
  INNER JOIN dbo.ADCENATEN AS CEN WITH (NOLOCK) ON CEN.CODCENATE =ING.CODCENATE
  INNER JOIN Inventory .PharmaceuticalDispensingDetailBatchSerial AS PDDBS ON PDDD.PharmaceuticalDispensingDetailBatchSerialId =PDDBS.Id  
  INNER JOIN Inventory .PharmaceuticalDispensingDetail AS PDDE ON PDDE.ID=PDDBS.PharmaceuticalDispensingDetailId 
  INNER JOIN Payroll .FunctionalUnit AS FU ON FU.Id =PDDE.FunctionalUnitId
  INNER JOIN Inventory.PharmaceuticalDispensing pd WITH (NOLOCK) ON PDDE.PharmaceuticalDispensingId = pd.Id
  INNER JOIN Inventory.Warehouse w WITH (NOLOCK) ON pdd.WarehouseId = w.Id
  INNER JOIN Inventory.InventoryProduct ip WITH (NOLOCK) ON PDDE.ProductId = ip.Id
  INNER JOIN Inventory .ProductType AS PT WITH (NOLOCK) ON PT.ID =IP.ProductTypeId 
  LEFT JOIN Inventory.PhysicalInventory phy WITH (NOLOCK) ON pddbs.PhysicalInventoryId = phy.Id
  LEFT JOIN Inventory.BatchSerial bs WITH (NOLOCK) ON phy.BatchSerialId = bs.Id
  LEFT JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =PDDE.CareGroupId    --=PDD.CareGroupId 
  LEFT JOIN Contract .HealthAdministrator AS HA WITH (NOLOCK) ON HA.Id =PDDE.HealthAdministratorId   --=PDD.HealthAdministratorId 
  LEFT JOIN Common .ThirdParty AS TP2 WITH (NOLOCK) ON TP2.Id =PDDE.ThirdPartyId 
  LEFT JOIN Inventory .ATC AS ATC WITH (NOLOCK) ON ATC.ID =IP.ATCId
  LEFT JOIN Inventory .InventorySupplie AS ISS WITH (NOLOCK) ON ISS.ID =IP.SupplieId
  WHERE  PDD.Status =2 --cast(PDD.DocumentDate  AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND
  --group by PDD.id,PDDE.ProductId,PDD.CODE,CAST(PDD.DocumentDate AS DATE),FU.Name
),
CTE_DEVOLUCIONES_DISPENSACION_FINAL
AS
(
SELECT 'DEVOLUCION DISPENSACIONES' MOVIMIENTO, K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN ,K.[UNIDAD FUNCIONAL],K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,
SUM(K.[CANTIDAD DEVUELTA]) [CANTIDAD],CAST((SUM(K.PRECIO))/COUNT(K.[CODIGO PRODUCTO]) AS DECIMAL) 'COSTO PROMEDIO', K.[STOCK MINIMO] ,K.[STOCK MAXIMO],
K.[COSTO PRODUCTO] ,NULL 'CONCEPTO MOVIMIENTO',SUM(K.[CANTIDAD DEVUELTA]*K.PRECIO) 'COSTO TOTAL'
FROM CTE_DEVOLUCIONES_DISPENSACIONES  K
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN ,K.[UNIDAD FUNCIONAL],K.[NOMBRE PROVEEDOR]  ,K.[CODIGO PRODUCTO],K.PRODUCTO ,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],
K.[COSTO PRODUCTO]
),
-----------------------------------*********************************************************---
------ DISPENSACIONES----




CTE_K_DISPENSACIONES
AS
(
 SELECT CASE K.MovementType 
		WHEN 1  THEN 'Entrada' 
		WHEN 2 THEN 'Salida' 
		END TIPO, WH.Code 'CODIGO ALMACEN',
		WH.Name 'ALMACEN',
		CS.NAME 'NOMBRE PROVEEDOR',
		PRO.Code 'CODIGO PRODUCTO',
		PRO.Description 'PRODUCTO',
		year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',
		PRO.MinimumStock 'STOCK MINIMO' ,
		PRO.MaximumStock 'STOCK MAXIMO',
		K.ProductId,
		SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code) PRECIO, 
		K.EntityId, K.EntityCode ,PRO.ProductCost
 FROM	Inventory .Kardex K
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId 

		WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='PharmaceuticalDispensing'
		/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =123 */
 GROUP BY K.MovementType,WH.Code,
		WH.Name,PRO.Code,
		PRO.Description,
		year(K.DocumentDate),month(K.DocumentDate),
		K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
		PRO.MaximumStock,PRO.ProductCost, CS.NAME
),

CTE_DISPENSACIONES
AS
(
  SELECT PD.id IdDis,PDD.ProductId IdProducto,
		PD.CODE,
		CAST(PD.CONFIRMATIONDATE AS DATE) FECHA,
		sum(PDD.Quantity) 'CANTIDAD' ,
		FU.Name 'UNIDAD FUNCIONAL'
  FROM Inventory .PharmaceuticalDispensing AS PD
		INNER JOIN Inventory .PharmaceuticalDispensingDetail AS PDD ON PDD.PharmaceuticalDispensingId =PD.Id 
		INNER JOIN Payroll .FunctionalUnit AS FU ON FU.Id =PDD.FunctionalUnitId
	 WHERE CAST(PD.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND PD.STATUS=2 
		/*AND PDD.CODE IN ('0000016635','2897','0000036590') and PDD.ProductId=123 */
  GROUP BY PD.id,PDD.ProductId,PD.CODE,
		CAST(PD.CONFIRMATIONDATE AS DATE),FU.Name
),

CTE_DISPENSACION_FINAL
AS
(
SELECT 'DISPENSACIONES' MOVIMIENTO, 
		K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,
		K.ALMACEN,DIS.[UNIDAD FUNCIONAL],
		K.[NOMBRE PROVEEDOR],
		K.[CODIGO PRODUCTO],K.PRODUCTO,
		SUM(ISNULL(K.CANTIDAD,DIS.CANTIDAD)) [CANTIDAD],
		CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS DECIMAL)'COSTO PROMEDIO', 
		K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
		SUM(ISNULL(K.CANTIDAD,DIS.CANTIDAD)*K.PRECIO) 'COSTO TOTAL'
FROM	CTE_K_DISPENSACIONES K
		LEFT JOIN CTE_DISPENSACIONES DIS ON DIS.IdDis  =K.EntityId AND DIS.IdProducto =K.ProductId 
		--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,
		K.ALMACEN,DIS.[UNIDAD FUNCIONAL],
		K.[NOMBRE PROVEEDOR],
		K.[CODIGO PRODUCTO],
		K.PRODUCTO,
		K.[STOCK MINIMO] ,
		K.[STOCK MAXIMO],K.ProductCost 
),


---------------------------------*********************************************************---
---- ORDENES DE TRASLADOS----


CTE_K_ORDENES_TRASLADOS
AS
(
 SELECT CASE K.MovementType 
		WHEN 1  THEN 'Entrada' 
		WHEN 2 THEN 'Salida' 
		END TIPO, WH.Code 'CODIGO ALMACEN',
		WH.Name 'ALMACEN' , 
		CS.NAME 'NOMBRE PROVEEDOR',
		PRO.Code 'CODIGO PRODUCTO',
		PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',
		PRO.MinimumStock 'STOCK MINIMO' ,
		PRO.MaximumStock 'STOCK MAXIMO',
		K.ProductId,
		SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, 
		K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM	Inventory .Kardex K
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId
		WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='TransferOrder'
		/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,
		WH.Code,WH.Name,
		PRO.Code,PRO.Description,
		year(K.DocumentDate),month(K.DocumentDate),
		K.ProductId,K.EntityId, 
		K.EntityCode,PRO.MinimumStock,
		PRO.MaximumStock,PRO.ProductCost, CS.NAME 
),
CTE_ORDENES_TRASLADOS
AS
(
  SELECT TFO.ID IdTra,
		CASE TFO.OrderType 
		WHEN 1 THEN 'Traslado' 
		WHEN 2 THEN 'Consumo' 
		WHEN 3 THEN 'Traslado en Transito' 
		END 'TIPO ORDEN',
		CASE TFO.DispatchTo 
		WHEN 1 THEN 'Almacen' 
		WHEN 2 THEN 'Unidad Funcional' 
		END 'DESAPACHAR A',
		WH.Code 'CODIGO ALMACEN',
		WH.Name 'ALMACEN',
		WHT.Code 'CODIGO ALMACEN DESTINO',
		WHT.Name 'ALMACEN DESTINO',FU.Name 'UNIDAD FUNCIONAL',
		AC.Code 'CODIGO CONCEPTO' ,AC.Name 'CONCEPTO',
		PRO.Code 'CODIGO PRODUCTO', PRO.Description 'PRODUCTO',
		SUM(TOD.Quantity) 'CANTIDAD',AVG(CAST(TOD.Value AS decimal)) 'VALOR',
		SUM(TOD.Quantity)*AVG(CAST(TOD.Value AS decimal)) 'TOTAL',TFO.CODE,TOD.ProductId
  FROM	Inventory .TransferOrder TFO
		INNER JOIN Inventory .TransferOrderDetail AS TOD ON TFO.ID=TOD.TransferOrderId 
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =TOD.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =TFO.SourceWareHouseId
		LEFT JOIN Inventory .Warehouse AS WHT ON WHT.Id =TFO.TargetWareHouseId
		LEFT JOIN Payroll .FunctionalUnit AS FU ON FU.Id =TFO.TargetFunctionalUnitId
		LEFT JOIN Inventory .AdjustmentConcept AS AC ON AC.Id =TFO.AdjustmentConceptId
		WHERE cast(TFO.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal --TFO.CODE IN ('005418','003965')
  GROUP BY TFO.ID,TFO.OrderType,
		TFO.DispatchTo,WH.Code,
		WH.Name,WHT.Code,WHT.Name,
		FU.Name,AC.Code,
		AC.Name,PRO.Code,PRO.Description,TFO.CODE,TOD.ProductId
),
CTE_ORDEN_TRASLADO_FINAL
AS
(
SELECT	'ORDENES DE TRASLADO' MOVIMIENTO, 
		K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,
		K.ALMACEN,TRA.[UNIDAD FUNCIONAL],
		K.[NOMBRE PROVEEDOR],
		K.[CODIGO PRODUCTO],K.PRODUCTO,
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)) [CANTIDAD],
		CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO', 
		K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,
		K.ProductCost 'COSTO PRODUCTO' ,
		TRA.CONCEPTO 'CONCEPTO MOVIMIENTO',
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)*K.PRECIO) 'COSTO TOTAL'
FROM	CTE_K_ORDENES_TRASLADOS  K
		LEFT JOIN CTE_ORDENES_TRASLADOS TRA ON TRA.IdTra   =K.EntityId AND TRA.ProductId  =K.ProductId 
		--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,
		K.ALMACEN,TRA.[UNIDAD FUNCIONAL],
		K.[NOMBRE PROVEEDOR],
		K.[CODIGO PRODUCTO],
		K.PRODUCTO,K.[STOCK MINIMO] ,
		K.[STOCK MAXIMO],K.ProductCost ,
		TRA.CONCEPTO
),

-----------------------------------*********************************************************---
------ DEVOLUCION DE ORDENES DE TRASLADO----

CTE_K_DEVOLUCION_ORDENES_TRASLADOS
AS
(
 SELECT CASE K.MovementType 
			WHEN 1  THEN 'Entrada' 
			WHEN 2 THEN 'Salida' 
			END TIPO, WH.Code 'CODIGO ALMACEN',
			WH.Name 'ALMACEN' , 
			CS.NAME 'NOMBRE PROVEEDOR',
			PRO.Code 'CODIGO PRODUCTO',
			PRO.Description 'PRODUCTO',
			year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',
			PRO.MinimumStock 'STOCK MINIMO' ,
			PRO.MaximumStock 'STOCK MAXIMO',
			K.ProductId,
			SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code) PRECIO, 
			K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM		Inventory .Kardex K
			INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
			INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
			INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId

 WHERE		cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='TransferOrderDevolution'
			/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY	K.MovementType,WH.Code,WH.Name,
			PRO.Code,PRO.Description,
			year(K.DocumentDate),month(K.DocumentDate),
			K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
			PRO.MaximumStock,PRO.ProductCost, CS.NAME
),
CTE_DEVOLUCION_ORDENES_TRASLADOS
AS
(
	SELECT	TOD.id IdDev,TODE.ProductId IdProducto,TOD.CODE,CAST(TOD.CONFIRMATIONDATE AS DATE) FECHA,sum(TODD.Quantity) 'CANTIDAD DEVUELTA' ,FU.Name 'UNIDAD FUNCIONAL',
			AC.Code 'CODIGO CONCEPTO' ,AC.Name 'CONCEPTO'
	FROM Inventory .TransferOrderDevolution  AS TOD
			INNER JOIN Inventory .TransferOrderDevolutionDetail AS TODD ON TOD.ID =TODD.TransferOrderDevolutionId 
			LEFT JOIN Inventory .TransferOrderDetailBatchSerial  AS TODBS ON TODD.TransferOrderDetailBatchSerialId  =TODBS.Id  
			LEFT JOIN Inventory .TransferOrderDetail  AS TODE ON TODE.ID=TODBS.TransferOrderDetailId  
			LEFT JOIN Inventory .TransferOrder AS TFO ON TFO.ID=TODE.TransferOrderId 
			LEFT JOIN Payroll .FunctionalUnit AS FU ON FU.Id =TFO.TargetFunctionalUnitId
			LEFT JOIN Inventory .AdjustmentConcept AS AC ON AC.Id =TFO.AdjustmentConceptId
	 WHERE CAST(TOD.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND TOD.STATUS=2 
			/*AND PDD.CODE IN ('0000016635','2897','0000036590') and pdde.ProductId=123*/
	 group by TOD.id,TODE.ProductId,TOD.CODE,CAST(TOD.CONFIRMATIONDATE AS DATE),FU.Name, AC.Code,AC.Name 
),
CTE_DEVOLUCION_ORDEN_TRASLADO_FINAL
AS
(
	SELECT 'DEVOLUCION ORDENES DE TRASLADO' MOVIMIENTO, 
			K.TIPO,K.AÑO ,K.MES,	
			K.[CODIGO ALMACEN] ,
			K.ALMACEN,TRA.[UNIDAD FUNCIONAL],
			K.[NOMBRE PROVEEDOR],
			K.[CODIGO PRODUCTO],K.PRODUCTO,
			SUM(ISNULL(TRA.[CANTIDAD DEVUELTA],K.CANTIDAD)) [CANTIDAD],
			CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO',
			K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,TRA.CONCEPTO 'CONCEPTO MOVIMIENTO',
			SUM(ISNULL(TRA.[CANTIDAD DEVUELTA],K.CANTIDAD)*K.PRECIO) 'COSTO TOTAL'
	FROM	CTE_K_DEVOLUCION_ORDENES_TRASLADOS   K
			LEFT JOIN CTE_DEVOLUCION_ORDENES_TRASLADOS  TRA ON TRA.IdDev =K.EntityId AND TRA.IdProducto =K.ProductId 
			--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
	GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,
			K.ALMACEN,
			K.[NOMBRE PROVEEDOR],
			TRA.[UNIDAD FUNCIONAL],
			K.[CODIGO PRODUCTO],
			K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost,TRA.CONCEPTO
),



---------------------------------*********************************************************---
---- PRESTAMOS DE MERCANCIA----


 
CTE_K_PRESTAMOS_MERCANCIAS
AS
(
	SELECT CASE K.MovementType 
			WHEN 1  THEN 'Entrada' 
			WHEN 2 THEN 'Salida' 
			END TIPO, WH.Code 'CODIGO ALMACEN',
			WH.Name 'ALMACEN' , 
			CS.NAME 'NOMBRE PROVEEDOR',
			PRO.Code 'CODIGO PRODUCTO',
			PRO.Description 'PRODUCTO',
			year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',
			PRO.MinimumStock 'STOCK MINIMO' ,
			PRO.MaximumStock 'STOCK MAXIMO',
			K.ProductId,SUM(K.Quantity ) CANTIDAD,
			SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
	FROM	Inventory .Kardex K
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId

		WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='LoanMerchandise'
		/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
	GROUP BY K.MovementType,
			WH.Code,WH.Name,PRO.Code,PRO.Description,
			year(K.DocumentDate),month(K.DocumentDate),
			K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
			PRO.MaximumStock,PRO.ProductCost, CS.NAME
),
CTE_PRESTAMOS_MERCANCIAS
AS
(
	SELECT	LM.ID IdPre,
			CASE LM.LoanType  
			WHEN 1 THEN 'Entrada' 
			WHEN 2 THEN 'Salida' 
			END 'TIPO PRESTAMO',
			WH.Code 'CODIGO ALMACEN',
			WH.Name 'ALMACEN',
			PRO.Code 'CODIGO PRODUCTO', 
			PRO.Description 'PRODUCTO',
			SUM(LMD.Quantity) 'CANTIDAD',
			AVG(CAST(LMD.UnitValue  AS decimal)) 'VALOR',  
			SUM(LMD.Quantity)*AVG(CAST(LMD.UnitValue AS decimal)) 'TOTAL',
			LM.CODE,LMD.ProductId 
  FROM		Inventory .LoanMerchandise LM
		INNER JOIN Inventory .LoanMerchandiseDetail AS LMD ON LM.ID=LMD.LoanMerchandiseId  
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =LMD.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =LM.WarehouseId 
		WHERE cast(LM.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND LM.Status =2--TFO.CODE IN ('005418','003965')
  GROUP BY	LM.ID,LM.LoanType,
			WH.Code,WH.Name,
			PRO.Code,
			PRO.Description,
			LM.CODE,LMD.ProductId
),
CTE_PRESTAMOS_MERCANCIAS_FINAL
AS
(
	SELECT	'PRESTAMOS MERCANCIA' MOVIMIENTO, 
			K.TIPO,K.AÑO ,K.MES,
			K.[CODIGO ALMACEN] ,
			K.ALMACEN,NULL [UNIDAD FUNCIONAL],
			K.[NOMBRE PROVEEDOR],
			K.[CODIGO PRODUCTO],
			K.PRODUCTO,
			SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)) [CANTIDAD],
			CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO',
			K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,
			NULL 'CONCEPTO MOVIMIENTO',
			SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)*K.PRECIO) 'COSTO TOTAL'
	FROM	CTE_K_PRESTAMOS_MERCANCIAS   K
		LEFT JOIN CTE_PRESTAMOS_MERCANCIAS   TRA ON TRA.IdPre  =K.EntityId AND TRA.ProductId  =K.ProductId 
			--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
	GROUP BY K.TIPO,K.AÑO ,K.MES,
			K.[CODIGO ALMACEN] ,
			K.[NOMBRE PROVEEDOR],
			K.ALMACEN,K.[CODIGO PRODUCTO],
			K.PRODUCTO,K.[STOCK MINIMO] ,
			K.[STOCK MAXIMO],K.ProductCost
),



-----------------------------------*********************************************************---
------ DEVOLUCION PRESTAMOS DE MERCANCIA----



CTE_K_DEVOLUCION_PRESTAMOS_MERCANCIAS
AS
(
	SELECT CASE K.MovementType 
		WHEN 1  THEN 'Entrada' 
		WHEN 2 THEN 'Salida' END TIPO, 
		WH.Code 'CODIGO ALMACEN',
		WH.Name 'ALMACEN' , 
		CS.NAME 'NOMBRE PROVEEDOR',
		PRO.Code 'CODIGO PRODUCTO',
		PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
		K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.Value )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
	FROM Inventory .Kardex K
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId

		WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='LoanMerchandiseDevolution'
		/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */

	GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
		PRO.MaximumStock,PRO.ProductCost, CS.NAME 
),
CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS
	AS
(
	SELECT	LMD.id IdDev,LMDDB.ProductId,LMD.CODE,
			CAST(LMD.CONFIRMATIONDATE AS DATE) 
			FECHA,sum(LMDD.Quantity) 'CANTIDAD DEVUELTA' ,
			NULL 'UNIDAD FUNCIONAL'
		
	FROM	Inventory .LoanMerchandiseDevolution  AS LMD
			INNER JOIN Inventory .LoanMerchandiseDevolutionDetail AS LMDD ON LMD.ID =LMDD.LoanMerchandiseDevolutionId  
			LEFT JOIN Inventory .LoanMerchandiseDetail   AS LMDDB ON LMDDB.Id   =LMDD.LoanMerchandiseDetaillId 
			WHERE CAST(LMD.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND LMD.STATUS=2 
			/*AND PDD.CODE IN ('0000016635','2897','0000036590') and pdde.ProductId=123*/
	GROUP BY  LMD.id,LMDDB.ProductId ,LMD.CODE,CAST(LMD.CONFIRMATIONDATE AS DATE)
),
CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS_FINAL
AS
(
	SELECT	'DEVOLUCION PRESTAMOS MERCANCIA' MOVIMIENTO, 
			K.TIPO,K.AÑO ,
			K.MES,K.[CODIGO ALMACEN] ,
			K.ALMACEN,
			NULL [UNIDAD FUNCIONAL],
			K.[NOMBRE PROVEEDOR],
			K.[CODIGO PRODUCTO], K.PRODUCTO,
			SUM(ISNULL(K.CANTIDAD,TRA.[CANTIDAD DEVUELTA])) [CANTIDAD],
			CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO',
			K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,
			K.ProductCost 'COSTO PRODUCTO' ,
			NULL 'CONCEPTO MOVIMIENTO',
			SUM(ISNULL(K.CANTIDAD,TRA.[CANTIDAD DEVUELTA])*K.PRECIO) 'COSTO TOTAL'
	FROM	CTE_K_DEVOLUCION_PRESTAMOS_MERCANCIAS   K
			LEFT JOIN CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS  TRA ON TRA.IdDev=K.EntityId AND TRA.ProductId =K.ProductId 
			--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
	GROUP BY K.TIPO,K.AÑO ,K.MES,
			K.[CODIGO ALMACEN] ,
			K.ALMACEN,
			K.[NOMBRE PROVEEDOR],
			K.[CODIGO PRODUCTO],
			K.PRODUCTO,K.[STOCK MINIMO] ,
			K.[STOCK MAXIMO],
			K.ProductCost
),


-----------------------------------*********************************************************---
------ COMPROBANTE DE ENTRADA----




 
CTE_K_COMPROBANTE_ENTRADA
AS
(
 SELECT CASE K.MovementType 
			WHEN 1  THEN 'Entrada' 
			WHEN 2 THEN 'Salida' 
			END TIPO, WH.Code 'CODIGO ALMACEN',
			WH.Name 'ALMACEN',
			CS.NAME 'NOMBRE PROVEEDOR',
			PRO.Code 'CODIGO PRODUCTO',
			PRO.Description 'PRODUCTO',
			year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',
			PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
			K.ProductId, SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, 
			K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM Inventory .Kardex K
			INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
			INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
			INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId

 WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='EntranceVoucher'
 /*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
			PRO.MaximumStock,PRO.ProductCost, CS.NAME 
			),
CTE_COMPROBANTE_ENTRADA
AS
(
  SELECT EV.ID IdCom,  
			WH.Code 'CODIGO ALMACEN',
			WH.Name 'ALMACEN',
			PRO.Code 'CODIGO PRODUCTO', 
			PRO.Description 'PRODUCTO',
			SUM(EVD.Quantity) 'CANTIDAD',
			AVG(CAST(EVD.UnitValue  AS decimal)) 'VALOR',  
			SUM(EVD.Quantity)*AVG(CAST(EVD.UnitValue AS decimal)) 'TOTAL',
			EV.CODE,EVD.ProductId 
  FROM Inventory .EntranceVoucher EV
			INNER JOIN Inventory .EntranceVoucherDetail AS EVD ON EV.ID=EVD.EntranceVoucherId  
			INNER JOIN Inventory .Warehouse AS WH ON WH.Id =EV.WarehouseId
			INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =EVD.ProductId 
			WHERE cast(EV.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND EV.Status =2--TFO.CODE IN ('005418','003965')
  GROUP BY EV.ID,WH.Code,WH.Name,PRO.Code,PRO.Description,EV.CODE,EVD.ProductId
),
CTE_COMPROBANTE_ENTRADA_FINAL
AS
(
SELECT 'COMPROBANTE DE ENTRADA' MOVIMIENTO, 
			K.TIPO,K.AÑO ,
			K.MES,K.[CODIGO ALMACEN] ,
			K.ALMACEN,NULL [UNIDAD FUNCIONAL],
			K.[NOMBRE PROVEEDOR],
			K.[CODIGO PRODUCTO],K.PRODUCTO,
			SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)) [CANTIDAD],
			CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO',
			K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
			SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)*K.PRECIO) 'COSTO TOTAL'
FROM CTE_K_COMPROBANTE_ENTRADA   K
			LEFT JOIN CTE_COMPROBANTE_ENTRADA  TRA ON TRA.IdCom =K.EntityId AND TRA.ProductId =K.ProductId 
--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost
),





-----------------------------------*********************************************************---
------ DEVOLUCION COMPROBANTE DE ENTRADA----


CTE_K_DEVOLUCION_COMPROBANTE_ENTRADA
AS
(
 SELECT CASE K.MovementType 
		WHEN 1  THEN 'Entrada' 
		WHEN 2 THEN 'Salida' 
		END TIPO, WH.Code 'CODIGO ALMACEN',
		WH.Name 'ALMACEN' , 
		CS.NAME 'NOMBRE PROVEEDOR',
		PRO.Code 'CODIGO PRODUCTO',
		PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
		K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM Inventory .Kardex K
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId

		WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='EntranceVoucherDevolution'
		/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,  WH.Code,  WH.Name,  PRO.Code,  PRO.Description,  year(K.DocumentDate), month(K.DocumentDate), K.ProductId, K.EntityId, 
		K.EntityCode,PRO.MinimumStock,
		PRO.MaximumStock,PRO.ProductCost,  CS.NAME
		),

CTE_DEVOLUCION_COMPROBANTE_ENTRADA
AS
(
 SELECT EVD.id IdDev,ENVD.ProductId,EVD.CODE, CAST(EVD.CONFIRMATIONDATE AS DATE) FECHA,  sum(EVDD.Quantity) 'CANTIDAD DEVUELTA' ,
		NULL 'UNIDAD FUNCIONAL'
	 
 FROM Inventory.EntranceVoucherDevolution  AS EVD
     INNER JOIN Inventory .EntranceVoucherDevolutionDetail AS EVDD ON EVD.ID =EVDD.EntranceVoucherDevolutionId  
	 LEFT JOIN Inventory .EntranceVoucherDetailBatchSerial   AS EVDBS ON EVDD.EntranceVoucherDetailBatchSerialId   =EVDBS.Id
	 LEFT JOIN Inventory .EntranceVoucherDetail AS ENVD ON EVDBS.EntranceVoucherDetailId=ENVD.Id 

	WHERE CAST(EVD.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND EVD.STATUS=2 
	 /*AND PDD.CODE IN ('0000016635','2897','0000036590') and pdde.ProductId=123*/
	 group by EVD.id,ENVD.ProductId ,EVD.CODE,CAST(EVD.CONFIRMATIONDATE AS DATE)
),
CTE_DEVOLUCION_COMPROBANTE_ENTRADA_FINAL
AS
(
SELECT 'DEVOLUCION COMPROBATE DE ENTRADA' MOVIMIENTO, 
		K.TIPO, K.AÑO, K.MES, K.[CODIGO ALMACEN], K.ALMACEN, NULL [UNIDAD FUNCIONAL],
		K.[NOMBRE PROVEEDOR],
		K.[CODIGO PRODUCTO],K.PRODUCTO,
		SUM(ISNULL(K.CANTIDAD,TRA.[CANTIDAD DEVUELTA])) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal)'COSTO PROMEDIO',
		K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
		SUM(ISNULL(K.CANTIDAD,TRA.[CANTIDAD DEVUELTA])*K.PRECIO) 'COSTO TOTAL'
FROM CTE_K_DEVOLUCION_COMPROBANTE_ENTRADA   K
		LEFT JOIN CTE_DEVOLUCION_COMPROBANTE_ENTRADA  TRA ON TRA.IdDev=K.EntityId AND TRA.ProductId =K.ProductId 
		--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN, K.[NOMBRE PROVEEDOR], K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost
		),





-----------------------------------*********************************************************---
------AJUSTE DE INVENTARIO--------********YA REVISADO**********


CTE_K_AJUSTE_INVENTARIO
AS
(
 SELECT CASE K.MovementType 
		WHEN 1  THEN 'Entrada'	
		WHEN 2 THEN 'Salida' 
		END TIPO, WH.Code 'CODIGO ALMACEN',
		WH.Name 'ALMACEN' , 
		CS.NAME 'NOMBRE PROVEEDOR',
		PRO.Code 'CODIGO PRODUCTO',
		PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
		K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost)/count(pro.Code) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM Inventory .Kardex K
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId

		WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='InventoryAdjustment'
		/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
		PRO.MaximumStock,PRO.ProductCost, CS.NAME
		),
CTE_AJUSTE_INVENTARIO
AS
(
  SELECT IA.ID IdAju, CASE IA.AdjustmentType 
		WHEN 1 THEN 'Entrada' 
		WHEN 2 THEN 'Salida' 
		WHEN 3 THEN 'Inventario Fisico' 
		END 'TIPO AJUSTE',
		WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN',PRO.Code 'CODIGO PRODUCTO', PRO.Description 'PRODUCTO',SUM(IAD.Quantity) 'CANTIDAD',
		AVG(CAST(IAD.UnitValue  AS decimal)) 'VALOR',  SUM(IAD.Quantity)*AVG(CAST(IAD.UnitValue AS decimal)) 'TOTAL',IA.CODE,IAD.ProductId ,
		AC.Code 'CODIGO CONCEPTO' ,AC.Name 'CONCEPTO'
  FROM Inventory .InventoryAdjustment IA
		INNER JOIN Inventory .InventoryAdjustmentDetail AS IAD ON IA.ID=IAD.InventoryAdjustmentId 
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =IAD.ProductId 
		LEFT JOIN Inventory .Warehouse AS WH ON WH.Id =IA.WarehouseId
		LEFT JOIN Inventory .AdjustmentConcept as AC on AC.Id =IA.AdjustmentConceptId 
		WHERE cast(IA.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND IA.Status =2--TFO.CODE IN ('005418','003965')
  GROUP BY IA.ID,IA.AdjustmentType,WH.Code,WH.Name,PRO.Code,PRO.Description,IA.CODE,IAD.ProductId,AC.Code,AC.Name 
),
CTE_AJUSTE_INVENTARIO_FINAL
AS
(
SELECT 'AJUSTE DE INVENTARIO' MOVIMIENTO, 
		K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,
		K.ALMACEN,NULL [UNIDAD FUNCIONAL],
		K.[NOMBRE PROVEEDOR],
		K.[CODIGO PRODUCTO],K.PRODUCTO,
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD )) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO', 
		K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,TRA.CONCEPTO 'CONCEPTO MOVIMIENTO',
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD )*K.PRECIO) 'COSTO TOTAL'
FROM CTE_K_AJUSTE_INVENTARIO  K
		LEFT JOIN CTE_AJUSTE_INVENTARIO TRA ON TRA.IdAju =K.EntityId AND TRA.ProductId  =K.ProductId 
		--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN, K.[NOMBRE PROVEEDOR], K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost ,
		TRA.CONCEPTO
		),



-----------------------------------*********************************************************---
------REMISION DE ENTRADA----


 CTE_K_REMISION_ENTRADA
AS
(
 SELECT CASE K.MovementType 
		WHEN 1  THEN 'Entrada' 
		WHEN 2 THEN 'Salida' 
		END TIPO, 
		WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN' ,       
		CS.NAME 'NOMBRE PROVEEDOR',
		PRO.Code 'CODIGO PRODUCTO',
		PRO.Description 'PRODUCTO',
		year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
		K.ProductId, SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM Inventory .Kardex K
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId

		WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='RemissionEntrance'
		/*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
		PRO.MaximumStock,PRO.ProductCost,  CS.NAME 
		),
CTE_REMISION_ENTRADA
AS
(
  SELECT RE.ID IdEnt, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN',PRO.Code 'CODIGO PRODUCTO', PRO.Description 'PRODUCTO',SUM(RED.Quantity) 'CANTIDAD',
		AVG(CAST(RED.UnitValue  AS decimal)) 'VALOR',  SUM(RED.Quantity)*AVG(CAST(RED.UnitValue AS decimal)) 'TOTAL',RE.CODE,RED.ProductId
  FROM Inventory .RemissionEntrance RE
		INNER JOIN Inventory .RemissionEntranceDetail AS RED ON RE.ID=RED.RemissionEntranceId
		INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =RED.ProductId 
		LEFT JOIN Inventory .Warehouse AS WH ON WH.Id =RE.WarehouseId
		WHERE cast(RE.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND RE.Status =2--TFO.CODE IN ('005418','003965')
  GROUP BY RE.ID,WH.Code,WH.Name,PRO.Code,PRO.Description,RE.CODE,RED.ProductId
),
CTE_REMISION_ENTRADA_FINAL
AS
(
	SELECT 'REMISION DE ENTRADA' MOVIMIENTO, K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,NULL [UNIDAD FUNCIONAL],K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD )) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO', K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD )*K.PRECIO) 'COSTO TOTAL'
	FROM CTE_K_REMISION_ENTRADA  K
		LEFT JOIN CTE_REMISION_ENTRADA TRA ON TRA.IdEnt =K.EntityId AND TRA.ProductId  =K.ProductId 
		--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
	GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN, K.[NOMBRE PROVEEDOR], K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost
),

-----------------------------------*********************************************************---
------REMISION DE SALIDA----
 CTE_K_REMISION_SALIDA
		AS
		(
		 SELECT CASE K.MovementType WHEN 1  THEN 'Entrada' WHEN 2 THEN 'Salida' END TIPO, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN', CS.NAME 'NOMBRE PROVEEDOR' , PRO.Code 'CODIGO PRODUCTO',
		 PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
		 K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
		 FROM Inventory .Kardex K
		 INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		 INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		 INNER JOIN Common.supplier AS CS ON CS.ID = WH.SupplierId
		 WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='RemissionOutput'
		 /*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
		 GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
		 PRO.MaximumStock,PRO.ProductCost, CS.NAME
		),
CTE_REMISION_SALIDA
		AS
		(
		  SELECT RO.ID IdSal, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN',PRO.Code 'CODIGO PRODUCTO', PRO.Description 'PRODUCTO',SUM(ROD.Quantity) 'CANTIDAD',
		  AVG(CAST(ROD.SalePrice  AS decimal)) 'VALOR',  SUM(ROD.Quantity)*AVG(CAST(ROD.SalePrice AS decimal)) 'TOTAL',RO.CODE,ROD.ProductId
		  FROM Inventory .RemissionOutput RO
		  INNER JOIN Inventory .RemissionOutputDetail AS ROD ON RO.Id=ROD.RemissionOutputId 
		  INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =ROD.ProductId 
		  LEFT JOIN Inventory .Warehouse AS WH ON WH.Id =RO.WarehouseId
		  WHERE cast(RO.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND RO.Status =2--TFO.CODE IN ('005418','003965')
		  GROUP BY RO.ID,WH.Code,WH.Name,PRO.Code,PRO.Description,RO.CODE,ROD.ProductId
		),
CTE_REMISION_SALIDA_FINAL
		AS
		(
		SELECT 'REMISION DE SALIDA' MOVIMIENTO, K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN], K.ALMACEN, NULL [UNIDAD FUNCIONAL], K.[NOMBRE PROVEEDOR], K.[CODIGO PRODUCTO],K.PRODUCTO,
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD )) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO', K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
		SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD )*K.PRECIO) 'COSTO TOTAL'
		FROM CTE_K_REMISION_SALIDA  K
		LEFT JOIN CTE_REMISION_SALIDA TRA ON TRA.IdSal =K.EntityId AND TRA.ProductId  =K.ProductId 
		--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
		GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost
		),
-----------------------------------*********************************************************---
------ DEVOLUCION DE REMISION----
CTE_K_DEVOLUCION_REMISION
		AS
		(
	SELECT CASE K.MovementType WHEN 1  THEN 'Entrada' WHEN 2 THEN 'Salida' END TIPO, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN',CS.NAME 'NOMBRE PROVEEDOR' , PRO.Code 'CODIGO PRODUCTO',
		 PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
		 K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
	FROM Inventory .Kardex K
		 INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
		 INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
		 INNER JOIN Common.Supplier AS CS ON CS.ID = WH.SupplierId

	WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='RemissionDevolution'
		 /*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
	GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
		 PRO.MaximumStock,PRO.ProductCost , CS.NAME
		),
CTE_DEVOLUCION_REMISION
		AS
		(
	SELECT RD.id IdDev,
		   CASE RD.DevolutionType 
				WHEN 1 THEN 'Entrada' 
				WHEN 2 THEN 'Salida' 
				WHEN 3 THEN 'Inventario en consignación' 
			END 'TIPO DEVOLUCION',
		   RDD.ProductId, RD.CODE,
				CAST(RD.CONFIRMATIONDATE AS DATE) FECHA,
				SUM (RDD.Quantity) 'CANTIDAD DEVUELTA' ,
				NULL 'UNIDAD FUNCIONAL'
	FROM Inventory.RemissionDevolution  AS RD
	INNER JOIN Inventory .RemissionDevolutionDetail AS RDD ON RD.ID =RDD.RemissionDevolutionId  
	WHERE CAST(RD.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND RD.STATUS=2 
			/*AND PDD.CODE IN ('0000016635','2897','0000036590') and pdde.ProductId=123*/
	GROUP BY RD.id,RD.DevolutionType,RDD.ProductId ,RD.CODE,CAST(RD.CONFIRMATIONDATE AS DATE)
),
CTE_DEVOLUCION_REMISION_FINAL
		AS
		(
		SELECT 'DEVOLUCION DE REMISIONES' MOVIMIENTO, K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,NULL [UNIDAD FUNCIONAL],K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,
		SUM(ISNULL(K.CANTIDAD,TRA.[CANTIDAD DEVUELTA])) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO',K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
		SUM(ISNULL(K.CANTIDAD,TRA.[CANTIDAD DEVUELTA])*K.PRECIO) 'COSTO TOTAL'
		FROM CTE_K_DEVOLUCION_REMISION  K
		LEFT JOIN CTE_DEVOLUCION_REMISION  TRA ON TRA.IdDev=K.EntityId AND TRA.ProductId =K.ProductId 


		--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
		GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,K.[NOMBRE PROVEEDOR], K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost
		),
-----------------------------------*********************************************************---
------ REMISION EN INVENTARIOS EN CONSIGNACION----


CTE_K_REMISION_INVENTARIOS_CONSIGNACION
AS
(
 SELECT CASE K.MovementType WHEN 1  THEN 'Entrada' WHEN 2 THEN 'Salida' END TIPO, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN', CS.NAME 'NOMBRE PROVEEDOR' , PRO.Code 'CODIGO PRODUCTO',
 PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
 K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code)  PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM Inventory .Kardex K
 INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Common.Supplier AS CS ON CS.ID = WH.SupplierId
 
 WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='ConsignmentInventoryRemission'
 /*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
 PRO.MaximumStock,PRO.ProductCost, CS.NAME
),

CTE_REMISION_INVENTARIOS_CONSIGNACION
AS
(
  SELECT CIR.ID IdREM, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN',CS.NAME 'NOMBRE PROVEEDOR',PRO.Code 'CODIGO PRODUCTO', PRO.Description 'PRODUCTO',SUM(CIRD.Quantity) 'CANTIDAD',
  AVG(CAST(CIRD.UnitValue  AS decimal)) 'VALOR',  SUM(CIRD.Quantity)*AVG(CAST(CIRD.UnitValue AS decimal)) 'TOTAL',CIR.CODE,CIRD.ProductId
  FROM Inventory.ConsignmentInventoryRemission CIR
  INNER JOIN Inventory.ConsignmentInventoryRemissionDetail AS CIRD ON CIR.Id=CIRD.ConsignmentInventoryRemissionId 
  INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =CIRD.ProductId 
  LEFT JOIN Inventory .Warehouse AS WH ON WH.Id =CIR.WarehouseId
  INNER JOIN Common.Supplier AS CS ON CS.ID = WH.SupplierId


  WHERE cast(CIR.CONFIRMATIONDATE AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND CIR.Status =2--TFO.CODE IN ('005418','003965')
  GROUP BY CIR.ID,WH.Code,WH.Name,PRO.Code,PRO.Description,CIR.CODE,CIRD.ProductId, CS.NAME
),
CTE_REMISION_INVENTARIOS_CONSIGNACION_FINAL
AS
(
SELECT 'REMISION INVENTARIOS EN CONSIGNACION' MOVIMIENTO, K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,NULL [UNIDAD FUNCIONAL],K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,
SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO', K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
SUM(ISNULL(K.CANTIDAD,TRA.CANTIDAD)*K.PRECIO) 'COSTO TOTAL'
FROM CTE_K_REMISION_INVENTARIOS_CONSIGNACION  K
LEFT JOIN CTE_REMISION_INVENTARIOS_CONSIGNACION TRA ON TRA.IdREM =K.EntityId AND TRA.ProductId  =K.ProductId 



--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost, K.[NOMBRE PROVEEDOR]
),
-----------------------------------*********************************************************---
------ CONTROL DE INVENTARIOS----
CTE_K_CONTROL_INVENTARIOS
AS
(
 SELECT CASE K.MovementType WHEN 1  THEN 'Entrada' WHEN 2 THEN 'Salida' END TIPO, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN',CS.NAME 'NOMBRE PROVEEDOR' , PRO.Code 'CODIGO PRODUCTO',
 PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
 K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM Inventory .Kardex K
 INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Common.Supplier AS CS ON CS.ID = WH.SupplierId
 WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='InventoryControl'
 /*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
 PRO.MaximumStock,PRO.ProductCost, CS.NAME 
),
CTE_CONTROL_INVENTARIOS_FINAL
AS
(
SELECT 'CONTROL DE INVENTARIOS' MOVIMIENTO, K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,NULL [UNIDAD FUNCIONAL],K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,
SUM(ISNULL(K.CANTIDAD,'0')) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO', K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' ,NULL 'CONCEPTO MOVIMIENTO',
SUM(ISNULL(K.CANTIDAD,'0')*K.PRECIO) 'COSTO TOTAL'
FROM CTE_K_CONTROL_INVENTARIOS  K
--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost, K.[NOMBRE PROVEEDOR]
),
-----------------------------------*********************************************************---
------ FACTURA DE PRODUCTOS----
CTE_K_FACTURA_PRODUCTOS
AS
(
 SELECT CASE K.MovementType WHEN 1  THEN 'Entrada' WHEN 2 THEN 'Salida' END TIPO, WH.Code 'CODIGO ALMACEN',WH.Name 'ALMACEN',CS.NAME 'NOMBRE PROVEEDOR', PRO.Code 'CODIGO PRODUCTO',
 PRO.Description 'PRODUCTO',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',PRO.MinimumStock 'STOCK MINIMO' ,PRO.MaximumStock 'STOCK MAXIMO',
 K.ProductId,SUM(K.Quantity ) CANTIDAD,SUM(K.AverageCost )/COUNT(PRO.Code ) PRECIO, K.EntityId, K.EntityCode ,PRO.ProductCost 
 FROM Inventory .Kardex K
 INNER JOIN Inventory .InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory .Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Common.Supplier AS CS ON CS.ID = WH.SupplierId  
 WHERE cast(k.DocumentDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND K.EntityName ='BasicBilling'
 /*AND K.EntityCode IN ('0000016635','2897','0000036590')AND K.ProductId =1719 */
 GROUP BY K.MovementType,WH.Code,WH.Name,PRO.Code,PRO.Description,year(K.DocumentDate),month(K.DocumentDate),K.ProductId,K.EntityId, K.EntityCode,PRO.MinimumStock,
 PRO.MaximumStock,PRO.ProductCost,  CS.NAME
),
CTE_FACTURA_PRODUCTOS_FINAL
AS
(
SELECT 'FACTURA PRODUCTOS' MOVIMIENTO, K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,NULL [UNIDAD FUNCIONAL],K.[NOMBRE PROVEEDOR],K.[CODIGO PRODUCTO],K.PRODUCTO,
SUM(ISNULL(K.CANTIDAD,'0')) [CANTIDAD],CAST(SUM(K.PRECIO)/COUNT(K.[CODIGO PRODUCTO]) AS decimal) 'COSTO PROMEDIO', K.[STOCK MINIMO] ,K.[STOCK MAXIMO] ,K.ProductCost 'COSTO PRODUCTO' 
,NULL 'CONCEPTO MOVIMIENTO',
SUM(ISNULL(K.CANTIDAD,'0')*K.PRECIO) 'COSTO TOTAL'
FROM CTE_K_FACTURA_PRODUCTOS  K
--WHERE K.ProductId =123 --AND K.EntityCode LIKE '%36590%'
GROUP BY K.TIPO,K.AÑO ,K.MES,K.[CODIGO ALMACEN] ,K.ALMACEN,K.[CODIGO PRODUCTO],K.PRODUCTO,K.[STOCK MINIMO] ,K.[STOCK MAXIMO],K.ProductCost,K.[NOMBRE PROVEEDOR]
)

SELECT * FROM CTE_FACTURA_PRODUCTOS_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_CONTROL_INVENTARIOS_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'    
UNION ALL
SELECT * FROM CTE_REMISION_INVENTARIOS_CONSIGNACION_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'         
UNION ALL
SELECT * FROM CTE_DEVOLUCION_REMISION_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_REMISION_SALIDA_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_REMISION_ENTRADA_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_AJUSTE_INVENTARIO_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_DEVOLUCION_COMPROBANTE_ENTRADA_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_COMPROBANTE_ENTRADA_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_PRESTAMOS_MERCANCIAS_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_DEVOLUCION_ORDEN_TRASLADO_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_ORDEN_TRASLADO_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_DISPENSACION_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'
UNION ALL
SELECT * FROM CTE_DEVOLUCIONES_DISPENSACION_FINAL --WHERE [CODIGO PRODUCTO] ='1103210001'

--GO


