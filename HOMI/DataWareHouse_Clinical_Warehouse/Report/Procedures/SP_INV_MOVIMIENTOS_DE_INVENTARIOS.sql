-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: SP_INV_MOVIMIENTOS_DE_INVENTARIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.SP_INV_MOVIMIENTOS_DE_INVENTARIOS
 @FechaInicial DATE, 
 @FechaFinal DATE 

AS

WITH CTE_KARDEX_DEVOLUCIONES_DISPENSACIONES_UNICOS AS (
  SELECT
    DISTINCT K.EntityId,
    K.EntityCode
  FROM
    [INDIGO036].[Inventory].[Kardex] K
  WHERE
    K.EntityName = 'PharmaceuticalDispensingDevolution'
    AND cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
),
CTE_DEVOLUCIONES_DISPENSACIONES AS (
  SELECT
    PDD.Code AS 'CODIGO DEVOLUCION',
    CAST(PDD.DocumentDate AS DATE) AS 'FECHA DEVOLUCION',
    PD.Code AS 'CODIGO DE LA DISPENSACION',
    W.Code AS 'CODIGO ALMACEN',
    RTRIM(W.Name) AS 'ALMACEN',
    FU.Name AS 'UNIdAD FUNCIONAL',
    ISNULL(ATC.Code, ISS.Code) AS 'CODIGO PADRE',
    RTRIM(ISNULL(ATC.Name, ISS.SupplieName)) AS 'NOMBRE PADRE',
    TP2.Name AS 'NOMBRE PROVEEDOR',
    IP.Code AS 'CODIGO PRODUCTO',
    RTRIM(IP.Name) AS 'PRODUCTO',
    PDDD.Quantity AS 'CANTIdAD DEVUELTA',
    PDDE.AverageCost AS 'PRECIO',
    PDDD.Quantity * PDDE.AverageCost AS 'COSTO TOTAL',
    BS.BatchCode AS 'LOTE',
    BS.ExpirationDate AS 'FECHA VENCIMIENTO',
    PDD.AdmissionNumber AS INGRESO,
    CAST(ING.IFECHAING AS DATE) AS 'FECHA INGRESO',
    PAC.IPCODPACI AS 'IdENTIFICACION',
    RTRIM(PAC.IPNOMCOMP) AS 'PACIENTE',
    TP2.Nit AS NIT,
    RTRIM(HA.Name) AS ENTIdAD,
    RTRIM(CG.Name) AS 'GRUPO ATENCION',
    CASE
      PT.Class
      WHEN 2 THEN 'MEDICAMENTO'
      WHEN 3 THEN 'INSUMO'
      ELSE 'OTRO'
    END AS 'TIPO PRODUCTO',
    year(PDD.DocumentDate) AS 'AÑO',
    month(PDD.DocumentDate) AS 'MES',
    'Entrada' AS 'TIPO',
    IP.MinimumStock AS 'STOCK MINIMO',
    IP.MaximumStock AS 'STOCK MAXIMO',
    IP.ProductCost AS 'COSTO PRODUCTO'
  FROM
    [INDIGO036].[Inventory].[PharmaceuticalDispensingDevolution] PDD
    INNER JOIN CTE_KARDEX_DEVOLUCIONES_DISPENSACIONES_UNICOS AS KAR ON KAR.EntityId = PDD.Id
    INNER JOIN [INDIGO036].[Inventory].[PharmaceuticalDispensingDevolutionDetail] AS PDDD ON PDD.Id = PDDD.PharmaceuticalDispensingDevolutionId
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING ON ING.NUMINGRES = PDD.AdmissionNumber
    INNER JOIN [INDIGO036].[dbo].[INPACIENT] AS PAC ON PAC.IPCODPACI = ING.IPCODPACI
    INNER JOIN [INDIGO036].[dbo].[ADCENATEN] AS CEN ON CEN.CODCENATE = ING.CODCENATE
    INNER JOIN [INDIGO036].[Inventory].[PharmaceuticalDispensingDetailBatchSerial] AS PDDBS ON PDDD.PharmaceuticalDispensingDetailBatchSerialId = PDDBS.Id
    INNER JOIN [INDIGO036].[Inventory].[PharmaceuticalDispensingDetail] AS PDDE ON PDDE.Id = PDDBS.PharmaceuticalDispensingDetailId
    INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = PDDE.FunctionalUnitId
    INNER JOIN [INDIGO036].[Inventory].[PharmaceuticalDispensing] PD ON PDDE.PharmaceuticalDispensingId = PD.Id
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] W ON PDD.WarehouseId = W.Id
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] IP ON PDDE.ProductId = IP.Id
    INNER JOIN [INDIGO036].[Inventory].[ProductType] AS PT ON PT.Id = IP.ProductTypeId
    LEFT JOIN [INDIGO036].[Inventory].[PhysicalInventory] PHY ON PDDBS.PhysicalInventoryId = PHY.Id
    LEFT JOIN [INDIGO036].[Inventory].[BatchSerial] BS ON PHY.BatchSerialId = BS.Id
    LEFT JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = PDDE.CareGroupId
    LEFT JOIN INDIGO036.Contract.HealthAdministrator AS HA ON HA.Id = PDDE.HealthAdministratorId
    LEFT JOIN INDIGO036.Common.ThirdParty AS TP2 ON TP2.Id = PDDE.ThirdPartyId
    LEFT JOIN [INDIGO036].[Inventory].[ATC] AS ATC ON ATC.Id = IP.ATCId
    LEFT JOIN [INDIGO036].[Inventory].[InventorySupplie] AS ISS ON ISS.Id = IP.SupplieId
  WHERE
    PDD.Status = 2
),
CTE_DEVOLUCIONES_DISPENSACION_FINAL AS (
  SELECT
    'DEVOLUCION DISPENSACIONES' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(K.[CANTIdAD DEVUELTA]) AS [CANTIdAD],
    CAST(
      (SUM(K.PRECIO)) / COUNT(K.[CODIGO PRODUCTO]) AS DECIMAL
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.[COSTO PRODUCTO],
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(K.[CANTIdAD DEVUELTA] * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_DEVOLUCIONES_DISPENSACIONES K
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.[COSTO PRODUCTO]
),
CTE_K_DISPENSACIONES AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'PharmaceuticalDispensing'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_DISPENSACIONES AS (
  SELECT
    PD.Id AS IdDis,
    PDD.ProductId AS IdProducto,
    PD.Code,
    CAST(PD.ConfirmationDate AS DATE) AS FECHA,
    sum(PDD.Quantity) AS 'CANTIdAD',
    FU.Name AS 'UNIdAD FUNCIONAL'
  FROM
    [INDIGO036].[Inventory].[PharmaceuticalDispensing] AS PD
    INNER JOIN [INDIGO036].[Inventory].[PharmaceuticalDispensingDetail] AS PDD ON PDD.PharmaceuticalDispensingId = PD.Id
    INNER JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = PDD.FunctionalUnitId
  WHERE
    CAST(PD.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND PD.Status = 2
  GROUP BY
    PD.Id,
    PDD.ProductId,
    PD.Code,
    CAST(PD.ConfirmationDate AS DATE),
    FU.Name
),
CTE_DISPENSACION_FINAL AS (
  SELECT
    'DISPENSACIONES' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    DIS.[UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, DIS.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS DECIMAL
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, DIS.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_DISPENSACIONES K
    LEFT JOIN CTE_DISPENSACIONES DIS ON DIS.IdDis = K.EntityId
    AND DIS.IdProducto = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    DIS.[UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_ORDENES_TRASLADOS AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'TransferOrder'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_ORDENES_TRASLADOS AS (
  SELECT
    TFO.Id AS IdTra,
    CASE
      TFO.OrderType
      WHEN 1 THEN 'Traslado'
      WHEN 2 THEN 'Consumo'
      WHEN 3 THEN 'Traslado en Transito'
    END AS 'TIPO ORDEN',
    CASE
      TFO.DispatchTo
      WHEN 1 THEN 'Almacen'
      WHEN 2 THEN 'Unidad Funcional'
    END AS 'DESAPACHAR A',
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    WHT.Code AS 'CODIGO ALMACEN DESTINO',
    WHT.Name AS 'ALMACEN DESTINO',
    FU.Name AS 'UNIdAD FUNCIONAL',
    AC.Code AS 'CODIGO CONCEPTO',
    AC.Name AS 'CONCEPTO',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    SUM(TOD.Quantity) AS 'CANTIdAD',
    AVG(CAST(TOD.Value AS decimal)) AS 'VALOR',
    SUM(TOD.Quantity) * AVG(CAST(TOD.Value AS decimal)) AS 'TOTAL',
    TFO.Code,
    TOD.ProductId
  FROM
    [INDIGO036].[Inventory].[TransferOrder] TFO
    INNER JOIN [INDIGO036].[Inventory].[TransferOrderDetail] AS TOD ON TFO.Id = TOD.TransferOrderId
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = TOD.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = TFO.SourceWarehouseId
    LEFT JOIN [INDIGO036].[Inventory].[Warehouse] AS WHT ON WHT.Id = TFO.TargetWarehouseId
    LEFT JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = TFO.TargetFunctionalUnitId
    LEFT JOIN [INDIGO036].[Inventory].[AdjustmentConcept] AS AC ON AC.Id = TFO.AdjustmentConceptId
  WHERE
    cast(TFO.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
  GROUP BY
    TFO.Id,
    TFO.OrderType,
    TFO.DispatchTo,
    WH.Code,
    WH.Name,
    WHT.Code,
    WHT.Name,
    FU.Name,
    AC.Code,
    AC.Name,
    PRO.Code,
    PRO.Description,
    TFO.Code,
    TOD.ProductId
),
CTE_ORDEN_TRASLADO_FINAL AS (
  SELECT
    'ORDENES DE TRASLADO' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    TRA.[UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    TRA.CONCEPTO AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_ORDENES_TRASLADOS K
    LEFT JOIN CTE_ORDENES_TRASLADOS TRA ON TRA.IdTra = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    TRA.[UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost,
    TRA.CONCEPTO
),
CTE_K_DEVOLUCION_ORDENES_TRASLADOS AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'TransferOrderDevolution'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_DEVOLUCION_ORDENES_TRASLADOS AS (
  SELECT
    TOD.Id AS IdDev,
    TODE.ProductId AS IdProducto,
    TOD.Code,
    CAST(TOD.ConfirmationDate AS DATE) AS FECHA,
    sum(TODD.Quantity) AS 'CANTIdAD DEVUELTA',
    FU.Name AS 'UNIdAD FUNCIONAL',
    AC.Code AS 'CODIGO CONCEPTO',
    AC.Name AS 'CONCEPTO'
  FROM
    [INDIGO036].[Inventory].[TransferOrderDevolution] AS TOD
    INNER JOIN [INDIGO036].[Inventory].[TransferOrderDevolutionDetail] AS TODD ON TOD.Id = TODD.TransferOrderDevolutionId
    LEFT JOIN [INDIGO036].[Inventory].[TransferOrderDetailBatchSerial] AS TODBS ON TODD.TransferOrderDetailBatchSerialId = TODBS.Id
    LEFT JOIN [INDIGO036].[Inventory].[TransferOrderDetail] AS TODE ON TODE.Id = TODBS.TransferOrderDetailId
    LEFT JOIN [INDIGO036].[Inventory].[TransferOrder] AS TFO ON TFO.Id = TODE.TransferOrderId
    LEFT JOIN INDIGO036.Payroll.FunctionalUnit AS FU ON FU.Id = TFO.TargetFunctionalUnitId
    LEFT JOIN [INDIGO036].[Inventory].[AdjustmentConcept] AS AC ON AC.Id = TFO.AdjustmentConceptId
  WHERE
    CAST(TOD.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND TOD.Status = 2
  GROUP BY
    TOD.Id,
    TODE.ProductId,
    TOD.Code,
    CAST(TOD.ConfirmationDate AS DATE),
    FU.Name,
    AC.Code,
    AC.Name
),
CTE_DEVOLUCION_ORDEN_TRASLADO_FINAL AS (
  SELECT
    'DEVOLUCION ORDENES DE TRASLADO' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    TRA.[UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(TRA.[CANTIdAD DEVUELTA], K.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    TRA.CONCEPTO AS 'CONCEPTO MOVIMIENTO',
    SUM(
      ISNULL(TRA.[CANTIdAD DEVUELTA], K.CANTIdAD) * K.PRECIO
    ) AS 'COSTO TOTAL'
  FROM
    CTE_K_DEVOLUCION_ORDENES_TRASLADOS K
    LEFT JOIN CTE_DEVOLUCION_ORDENES_TRASLADOS TRA ON TRA.IdDev = K.EntityId
    AND TRA.IdProducto = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    TRA.[UNIdAD FUNCIONAL],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost,
    TRA.CONCEPTO
),
CTE_K_PRESTAMOS_MERCANCIAS AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'LoanMerchandise'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_PRESTAMOS_MERCANCIAS AS (
  SELECT
    LM.Id AS IdPre,
    CASE
      LM.LoanType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS 'TIPO PRESTAMO',
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    SUM(LMD.Quantity) AS 'CANTIdAD',
    AVG(CAST(LMD.UnitValue AS decimal)) AS 'VALOR',
    SUM(LMD.Quantity) * AVG(CAST(LMD.UnitValue AS decimal)) AS 'TOTAL',
    LM.Code,
    LMD.ProductId
  FROM
    [INDIGO036].[Inventory].[LoanMerchandise] LM
    INNER JOIN [INDIGO036].[Inventory].[LoanMerchandiseDetail] AS LMD ON LM.Id = LMD.LoanMerchandiseId
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = LMD.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = LM.WarehouseId
  WHERE
    cast(LM.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND LM.Status = 2
  GROUP BY
    LM.Id,
    LM.LoanType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    LM.Code,
    LMD.ProductId
),
CTE_PRESTAMOS_MERCANCIAS_FINAL AS (
  SELECT
    'PRESTAMOS MERCANCIA' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_PRESTAMOS_MERCANCIAS K
    LEFT JOIN CTE_PRESTAMOS_MERCANCIAS TRA ON TRA.IdPre = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.[NOMBRE PROVEEDOR],
    K.ALMACEN,
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_DEVOLUCION_PRESTAMOS_MERCANCIAS AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.Value) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'LoanMerchandiseDevolution'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS AS (
  SELECT
    LMD.Id AS IdDev,
    LMDDB.ProductId,
    LMD.Code,
    CAST(LMD.ConfirmationDate AS DATE) AS FECHA,
    sum(LMDD.Quantity) AS 'CANTIdAD DEVUELTA',
    NULL AS 'UNIdAD FUNCIONAL'
  FROM
    [INDIGO036].[Inventory].[LoanMerchandiseDevolution] AS LMD
    INNER JOIN [INDIGO036].[Inventory].[LoanMerchandiseDevolutionDetail] AS LMDD ON LMD.Id = LMDD.LoanMerchandiseDevolutionId
    LEFT JOIN [INDIGO036].[Inventory].[LoanMerchandiseDetail] AS LMDDB ON LMDDB.Id = LMDD.LoanMerchandiseDetaillId
  WHERE
    CAST(LMD.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND LMD.Status = 2
  GROUP BY
    LMD.Id,
    LMDDB.ProductId,
    LMD.Code,
    CAST(LMD.ConfirmationDate AS DATE)
),
CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS_FINAL AS (
  SELECT
    'DEVOLUCION PRESTAMOS MERCANCIA' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.[CANTIdAD DEVUELTA])) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(
      ISNULL(K.CANTIdAD, TRA.[CANTIdAD DEVUELTA]) * K.PRECIO
    ) AS 'COSTO TOTAL'
  FROM
    CTE_K_DEVOLUCION_PRESTAMOS_MERCANCIAS K
    LEFT JOIN CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS TRA ON TRA.IdDev = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_COMPROBANTE_ENTRADA AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'EntranceVoucher'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_COMPROBANTE_ENTRADA AS (
  SELECT
    EV.Id AS IdCom,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    SUM(EVD.Quantity) AS 'CANTIdAD',
    AVG(CAST(EVD.UnitValue AS decimal)) AS 'VALOR',
    SUM(EVD.Quantity) * AVG(CAST(EVD.UnitValue AS decimal)) AS 'TOTAL',
    EV.Code,
    EVD.ProductId
  FROM
    [INDIGO036].[Inventory].[EntranceVoucher] EV
    INNER JOIN [INDIGO036].[Inventory].[EntranceVoucherDetail] AS EVD ON EV.Id = EVD.EntranceVoucherId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = EV.WarehouseId
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = EVD.ProductId
  WHERE
    cast(EV.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND EV.Status = 2
  GROUP BY
    EV.Id,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    EV.Code,
    EVD.ProductId
),
CTE_COMPROBANTE_ENTRADA_FINAL AS (
  SELECT
    'COMPROBANTE DE ENTRADA' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_COMPROBANTE_ENTRADA K
    LEFT JOIN CTE_COMPROBANTE_ENTRADA TRA ON TRA.IdCom = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_DEVOLUCION_COMPROBANTE_ENTRADA AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'EntranceVoucherDevolution'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_DEVOLUCION_COMPROBANTE_ENTRADA AS (
  SELECT
    EVD.Id AS IdDev,
    ENVD.ProductId,
    EVD.Code,
    CAST(EVD.ConfirmationDate AS DATE) AS FECHA,
    sum(EVDD.Quantity) AS 'CANTIdAD DEVUELTA',
    NULL AS 'UNIdAD FUNCIONAL'
  FROM
    [INDIGO036].[Inventory].[EntranceVoucherDevolution] AS EVD
    INNER JOIN [INDIGO036].[Inventory].[EntranceVoucherDevolutionDetail] AS EVDD ON EVD.Id = EVDD.EntranceVoucherDevolutionId
    LEFT JOIN [INDIGO036].[Inventory].[EntranceVoucherDetailBatchSerial] AS EVDBS ON EVDD.EntranceVoucherDetailBatchSerialId = EVDBS.Id
    LEFT JOIN [INDIGO036].[Inventory].[EntranceVoucherDetail] AS ENVD ON EVDBS.EntranceVoucherDetailId = ENVD.Id
  WHERE
    CAST(EVD.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND EVD.Status = 2
  GROUP BY
    EVD.Id,
    ENVD.ProductId,
    EVD.Code,
    CAST(EVD.ConfirmationDate AS DATE)
),
CTE_DEVOLUCION_COMPROBANTE_ENTRADA_FINAL AS (
  SELECT
    'DEVOLUCION COMPROBATE DE ENTRADA' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.[CANTIdAD DEVUELTA])) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(
      ISNULL(K.CANTIdAD, TRA.[CANTIdAD DEVUELTA]) * K.PRECIO
    ) AS 'COSTO TOTAL'
  FROM
    CTE_K_DEVOLUCION_COMPROBANTE_ENTRADA K
    LEFT JOIN CTE_DEVOLUCION_COMPROBANTE_ENTRADA TRA ON TRA.IdDev = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_AJUSTE_INVENTARIO AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / count(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'InventoryAdjustment'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_AJUSTE_INVENTARIO AS (
  SELECT
    IA.Id AS IdAju,
    CASE
      IA.AdjustmentType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
      WHEN 3 THEN 'Inventario Fisico'
    END AS 'TIPO AJUSTE',
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    SUM(IAD.Quantity) AS 'CANTIdAD',
    AVG(CAST(IAD.UnitValue AS decimal)) AS 'VALOR',
    SUM(IAD.Quantity) * AVG(CAST(IAD.UnitValue AS decimal)) AS 'TOTAL',
    IA.Code,
    IAD.ProductId,
    AC.Code AS 'CODIGO CONCEPTO',
    AC.Name AS 'CONCEPTO'
  FROM
    [INDIGO036].[Inventory].[InventoryAdjustment] IA
    INNER JOIN [INDIGO036].[Inventory].[InventoryAdjustmentDetail] AS IAD ON IA.Id = IAD.InventoryAdjustmentId
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = IAD.ProductId
    LEFT JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = IA.WarehouseId
    LEFT JOIN [INDIGO036].[Inventory].[AdjustmentConcept] AS AC ON AC.Id = IA.AdjustmentConceptId
  WHERE
    cast(IA.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND IA.Status = 2
  GROUP BY
    IA.Id,
    IA.AdjustmentType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    IA.Code,
    IAD.ProductId,
    AC.Code,
    AC.Name
),
CTE_AJUSTE_INVENTARIO_FINAL AS (
  SELECT
    'AJUSTE DE INVENTARIO' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    TRA.CONCEPTO AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_AJUSTE_INVENTARIO K
    LEFT JOIN CTE_AJUSTE_INVENTARIO TRA ON TRA.IdAju = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost,
    TRA.CONCEPTO
),
CTE_K_REMISION_ENTRADA AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'RemissionEntrance'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_REMISION_ENTRADA AS (
  SELECT
    RE.Id AS IdEnt,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    SUM(RED.Quantity) AS 'CANTIdAD',
    AVG(CAST(RED.UnitValue AS decimal)) AS 'VALOR',
    SUM(RED.Quantity) * AVG(CAST(RED.UnitValue AS decimal)) AS 'TOTAL',
    RE.Code,
    RED.ProductId
  FROM
    [INDIGO036].[Inventory].[RemissionEntrance] RE
    INNER JOIN [INDIGO036].[Inventory].[RemissionEntranceDetail] AS RED ON RE.Id = RED.RemissionEntranceId
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = RED.ProductId
    LEFT JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = RE.WarehouseId
  WHERE
    cast(RE.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND RE.Status = 2
  GROUP BY
    RE.Id,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    RE.Code,
    RED.ProductId
),
CTE_REMISION_ENTRADA_FINAL AS (
  SELECT
    'REMISION DE ENTRADA' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_REMISION_ENTRADA K
    LEFT JOIN CTE_REMISION_ENTRADA TRA ON TRA.IdEnt = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_REMISION_SALIdA AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'RemissionOutput'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_REMISION_SALIdA AS (
  SELECT
    RO.Id AS IdSal,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    SUM(ROD.Quantity) AS 'CANTIdAD',
    AVG(CAST(ROD.SalePrice AS decimal)) AS 'VALOR',
    SUM(ROD.Quantity) * AVG(CAST(ROD.SalePrice AS decimal)) AS 'TOTAL',
    RO.Code,
    ROD.ProductId
  FROM
    [INDIGO036].[Inventory].[RemissionOutput] RO
    INNER JOIN [INDIGO036].[Inventory].[RemissionOutputDetail] AS ROD ON RO.Id = ROD.RemissionOutputId
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = ROD.ProductId
    LEFT JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = RO.WarehouseId
  WHERE
    cast(RO.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND RO.Status = 2
  GROUP BY
    RO.Id,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    RO.Code,
    ROD.ProductId
),
CTE_REMISION_SALIdA_FINAL AS (
  SELECT
    'REMISION DE SALIdA' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_REMISION_SALIdA K
    LEFT JOIN CTE_REMISION_SALIdA TRA ON TRA.IdSal = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_DEVOLUCION_REMISION AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'RemissionDevolution'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_DEVOLUCION_REMISION AS (
  SELECT
    RD.Id AS IdDev,
    CASE
      RD.DevolutionType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
      WHEN 3 THEN 'Inventario en consignación'
    END AS 'TIPO DEVOLUCION',
    RDD.ProductId,
    RD.Code,
    CAST(RD.ConfirmationDate AS DATE) AS FECHA,
    SUM(RDD.Quantity) AS 'CANTIdAD DEVUELTA',
    NULL AS 'UNIdAD FUNCIONAL'
  FROM
    [INDIGO036].[Inventory].[RemissionDevolution] AS RD
    INNER JOIN [INDIGO036].[Inventory].[RemissionDevolutionDetail] AS RDD ON RD.Id = RDD.RemissionDevolutionId
  WHERE
    CAST(RD.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND RD.Status = 2
  GROUP BY
    RD.Id,
    RD.DevolutionType,
    RDD.ProductId,
    RD.Code,
    CAST(RD.ConfirmationDate AS DATE)
),
CTE_DEVOLUCION_REMISION_FINAL AS (
  SELECT
    'DEVOLUCION DE REMISIONES' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.[CANTIdAD DEVUELTA])) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(
      ISNULL(K.CANTIdAD, TRA.[CANTIdAD DEVUELTA]) * K.PRECIO
    ) AS 'COSTO TOTAL'
  FROM
    CTE_K_DEVOLUCION_REMISION K
    LEFT JOIN CTE_DEVOLUCION_REMISION TRA ON TRA.IdDev = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost
),
CTE_K_REMISION_INVENTARIOS_CONSIGNACION AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'ConsignmentInventoryRemission'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_REMISION_INVENTARIOS_CONSIGNACION AS (
  SELECT
    CIR.Id AS IdREM,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    SUM(CIRD.Quantity) AS 'CANTIdAD',
    AVG(CAST(CIRD.UnitValue AS decimal)) AS 'VALOR',
    SUM(CIRD.Quantity) * AVG(CAST(CIRD.UnitValue AS decimal)) AS 'TOTAL',
    CIR.Code,
    CIRD.ProductId
  FROM
    [INDIGO036].[Inventory].[ConsignmentInventoryRemission] CIR
    INNER JOIN [INDIGO036].[Inventory].[ConsignmentInventoryRemissionDetail] AS CIRD ON CIR.Id = CIRD.ConsignmentInventoryRemissionId
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = CIRD.ProductId
    LEFT JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = CIR.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(CIR.ConfirmationDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND CIR.Status = 2
  GROUP BY
    CIR.Id,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    CIR.Code,
    CIRD.ProductId,
    CS.Name
),
CTE_REMISION_INVENTARIOS_CONSIGNACION_FINAL AS (
  SELECT
    'REMISION INVENTARIOS EN CONSIGNACION' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD)) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, TRA.CANTIdAD) * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_REMISION_INVENTARIOS_CONSIGNACION K
    LEFT JOIN CTE_REMISION_INVENTARIOS_CONSIGNACION TRA ON TRA.IdREM = K.EntityId
    AND TRA.ProductId = K.ProductId
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost,
    K.[NOMBRE PROVEEDOR]
),
CTE_K_CONTROL_INVENTARIOS AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'InventoryControl'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_CONTROL_INVENTARIOS_FINAL AS (
  SELECT
    'CONTROL DE INVENTARIOS' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, '0')) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, '0') * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_CONTROL_INVENTARIOS K
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost,
    K.[NOMBRE PROVEEDOR]
),
CTE_K_FACTURA_PRODUCTOS AS (
  SELECT
    CASE
      K.MovementType
      WHEN 1 THEN 'Entrada'
      WHEN 2 THEN 'Salida'
    END AS TIPO,
    WH.Code AS 'CODIGO ALMACEN',
    WH.Name AS 'ALMACEN',
    CS.Name AS 'NOMBRE PROVEEDOR',
    PRO.Code AS 'CODIGO PRODUCTO',
    PRO.Description AS 'PRODUCTO',
    year(K.DocumentDate) AS 'AÑO',
    month(K.DocumentDate) AS 'MES',
    PRO.MinimumStock AS 'STOCK MINIMO',
    PRO.MaximumStock AS 'STOCK MAXIMO',
    K.ProductId,
    SUM(K.Quantity) AS CANTIdAD,
    SUM(K.AverageCost) / COUNT(PRO.Code) AS PRECIO,
    K.EntityId,
    K.EntityCode,
    PRO.ProductCost
  FROM
    [INDIGO036].[Inventory].[Kardex] K
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO ON PRO.Id = K.ProductId
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AS WH ON WH.Id = K.WarehouseId
    INNER JOIN INDIGO036.Common.Supplier AS CS ON CS.Id = WH.SupplierId
  WHERE
    cast(K.DocumentDate AS DATE) BETWEEN @FechaInicial
    AND @FechaFinal
    AND K.EntityName = 'BasicBilling'
  GROUP BY
    K.MovementType,
    WH.Code,
    WH.Name,
    PRO.Code,
    PRO.Description,
    year(K.DocumentDate),
    month(K.DocumentDate),
    K.ProductId,
    K.EntityId,
    K.EntityCode,
    PRO.MinimumStock,
    PRO.MaximumStock,
    PRO.ProductCost,
    CS.Name
),
CTE_FACTURA_PRODUCTOS_FINAL AS (
  SELECT
    'FACTURA PRODUCTOS' AS MOVIMIENTO,
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    NULL AS [UNIdAD FUNCIONAL],
    K.[NOMBRE PROVEEDOR],
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    SUM(ISNULL(K.CANTIdAD, '0')) AS [CANTIdAD],
    CAST(
      SUM(K.PRECIO) / COUNT(K.[CODIGO PRODUCTO]) AS decimal
    ) AS 'COSTO PROMEDIO',
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost AS 'COSTO PRODUCTO',
    NULL AS 'CONCEPTO MOVIMIENTO',
    SUM(ISNULL(K.CANTIdAD, '0') * K.PRECIO) AS 'COSTO TOTAL'
  FROM
    CTE_K_FACTURA_PRODUCTOS K
  GROUP BY
    K.TIPO,
    K.AÑO,
    K.MES,
    K.[CODIGO ALMACEN],
    K.ALMACEN,
    K.[CODIGO PRODUCTO],
    K.PRODUCTO,
    K.[STOCK MINIMO],
    K.[STOCK MAXIMO],
    K.ProductCost,
    K.[NOMBRE PROVEEDOR]
)
SELECT
  *
FROM
  CTE_FACTURA_PRODUCTOS_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_CONTROL_INVENTARIOS_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_REMISION_INVENTARIOS_CONSIGNACION_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_DEVOLUCION_REMISION_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_REMISION_SALIdA_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_REMISION_ENTRADA_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_AJUSTE_INVENTARIO_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_DEVOLUCION_COMPROBANTE_ENTRADA_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_COMPROBANTE_ENTRADA_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_DEVOLUCION_PRESTAMOS_MERCANCIAS_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_PRESTAMOS_MERCANCIAS_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_DEVOLUCION_ORDEN_TRASLADO_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_ORDEN_TRASLADO_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_DISPENSACION_FINAL
UNION
ALL
SELECT
  *
FROM
  CTE_DEVOLUCIONES_DISPENSACION_FINAL