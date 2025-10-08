-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: VW_VIEWINVENTARIOCONCEPTOSMOVIMIENTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW Report.VW_VIEWINVENTARIOCONCEPTOSMOVIMIENTO
AS

WITH CTE_CONCEPTOS AS (
    SELECT
        '01' AS CONCEPTO,
        EntityCode AS CODIGO,
        'FACTURACION BASICA' AS DESCRIPCION,
        K.WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.Value,
        K.AverageCost,
        CONVERT(NUMERIC(18, 2),(Quantity * K.Value)) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        MovementType,
        '' AS Code,
        '' AS Movimiento,
        BatchSerialId,
        B.FunctionalUnitId,
        '' AS CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].[Kardex] K
        INNER JOIN INDIGO036.Billing.BasicBilling B ON K.EntityId = B.Id
        AND K.EntityName = 'BasicBilling'
    UNION ALL
    select
        '02' AS CONCEPTO,
        K.EntityCode AS CODIGO,
        'Remisión de Inventario en Consignación' AS DESCRIPCION,
        K.WarehouseId,
        ProductId,
        DocumentDate,
        Quantity,
        K.Value,
        AverageCost,
        CONVERT(NUMERIC(18, 2),(Quantity * K.Value)) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        K.MovementType,
        '' AS Code,
        '' AS Movimiento,
        BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    from
        [INDIGO036].[Inventory].[Kardex] K
    WHERE
        K.EntityName = 'ConsignmentInventoryRemission'
    UNION ALL
    SELECT
        '03' AS CONCEPTO,
        E.Code AS CODIGO,
        'Comprobante de Entrada' AS DESCRIPCION,
        E.WarehouseId,
        ED.ProductId,
        E.DocumentDate,
        IIF(R.Code IS NULL, ED.Quantity, 0) AS Quantity,
        IIF(R.Code IS NULL, ED.UnitValue, 0) AS [Value],
        K.AverageCost,
        CONVERT(
            NUMERIC(18, 2),
            IIF(R.Code IS NULL,(ED.TotalValue), 0)
        ) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        1 AS MovementType,
        '' AS Code,
        '' AS Movimiento,
        K.BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        E.SupplierId,
        CASE
            WHEN R.Code IS NOT NULL THEN 'Remisión'
            WHEN ED.ConsignmentInventoryRemissionDetailBatchSerialId IS NOT NULL THEN 'Consignación'
        END AS [TIPO LEGALIZACION],
        RD.Quantity AS [CANTIDAD LEGALIZADO],
        R.Code [CODIGO REMISION],
        R.RemissionDate AS [FECHA REMISION],
        IIF(R.Code IS NULL, 0, ED.TotalValue) AS [VALOR REMISION],
        CP.Code AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].[EntranceVoucherDetail] ED
        INNER JOIN [INDIGO036].[Inventory].[EntranceVoucher] E ON ED.EntranceVoucherId = E.Id
        INNER JOIN INDIGO036.Payments.AccountPayable CP ON E.Id = CP.EntityId
        AND CP.EntityName = 'EntranceVoucher'
        INNER JOIN [INDIGO036].[Inventory].[Kardex] K ON K.Id =(
            SELECT
                MAX(A.Id)
            FROM
                [INDIGO036].[Inventory].[Kardex] A
            WHERE
                E.Id = A.EntityId
                AND ED.ProductId = A.ProductId
                AND ED.Quantity = A.Quantity
        )
        LEFT JOIN [INDIGO036].[Inventory].[RemissionEntranceDetailBatchSerial] REDBS ON ED.RemissionEntranceDetailBatchSerialId = REDBS.Id
        LEFT JOIN [INDIGO036].[Inventory].[RemissionEntranceDetail] RD ON REDBS.RemissionEntranceDetailId = RD.Id
        LEFT JOIN [INDIGO036].[Inventory].[RemissionEntrance] R ON RD.RemissionEntranceId = R.Id
    UNION ALL
    SELECT
        '04' AS CONCEPTO,
        EVD.Code AS CODIGO,
        'Devolucion de Compra' AS DESCRIPCION,
        EVD.WarehouseId,
        DEV.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.Value,
        AverageCost,
        CONVERT(
            NUMERIC(18, 2),
            IIF(
                DEV.IvaPercentage = 0,
                DEV.UnitValue * EVDD.Quantity,
                (DEV.UnitValue +(DEV.UnitValue * IvaPercentage) / 100) * EVDD.Quantity
            )
        ) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        MovementType,
        '' AS Code,
        '' AS Movimiento,
        K.BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        EV.SupplierId AS SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        PN.Code AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].[EntranceVoucherDevolutionDetail] EVDD
        INNER JOIN [INDIGO036].[Inventory].[EntranceVoucherDevolution] EVD ON EVDD.EntranceVoucherDevolutionId = EVD.Id
        AND EVDD.Quantity != 0
        INNER JOIN [INDIGO036].[Inventory].[EntranceVoucherDetailBatchSerial] EVDBS ON EVDD.EntranceVoucherDetailBatchSerialId = EVDBS.Id
        INNER JOIN [INDIGO036].[Inventory].[EntranceVoucherDetail] DEV ON EVDBS.EntranceVoucherDetailId = DEV.Id
        INNER JOIN [INDIGO036].[Inventory].[EntranceVoucher] EV ON DEV.EntranceVoucherId = EV.Id
        INNER JOIN [INDIGO036].[Inventory].[Kardex] K ON K.Id =(
            SELECT
                MAX(A.Id)
            FROM
                [INDIGO036].[Inventory].[Kardex] A
            WHERE
                EVD.Id = A.EntityId
                AND DEV.ProductId = A.ProductId
                AND A.EntityName = 'EntranceVoucherDevolution'
        )
        LEFT JOIN INDIGO036.Payments.PaymentNotes PN ON EVD.PaymentNoteId = PN.Id
    UNION ALL
    SELECT
        '05' AS CONCEPTO,
        EntityCode AS CODIGO,
        'Ajuste de Inventario' AS DESCRIPCION,
        K.WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.AverageCost AS PreviousCost,
        K.AverageCost,
        CONVERT(NUMERIC(18, 2),(K.Quantity * K.Value)) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        K.MovementType,
        AC.Code,
        AC.Name AS Movimiento,
        K.BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        NULL AS SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL AS [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].[InventoryAdjustment] AI
        LEFT JOIN [INDIGO036].[Inventory].[InventoryAdjustmentDetail] AID ON AI.Id = AID.InventoryAdjustmentId
        LEFT JOIN [INDIGO036].[Inventory].[InventoryAdjustmentControl] IAC ON AI.Id = IAC.InventoryAdjustmentId
        LEFT JOIN [INDIGO036].[Inventory].[InventoryControlDetailBatchSerial] ICDBS ON IAC.InventoryControlDetailBatchSerialId = ICDBS.Id
        LEFT JOIN [INDIGO036].[Inventory].[InventoryControlDetail] ICD ON ICDBS.InventoryControlDetailId = ICD.Id
        LEFT JOIN [INDIGO036].[Inventory].[Kardex] K ON K.Id =(
            SELECT
                MAX(A.Id)
            FROM
                [INDIGO036].[Inventory].[Kardex] A
            WHERE
                (
                    AI.Id = A.EntityId
                    AND AID.ProductId = A.ProductId
                    AND AID.Quantity = A.Quantity
                    AND A.EntityName = 'InventoryAdjustment'
                )
                OR (
                    AI.Id = A.EntityId
                    AND ICD.ProductId = A.ProductId
                    AND IAC.QuantityAdjustment = A.Quantity
                    AND A.EntityName = 'InventoryAdjustment'
                )
        )
        LEFT JOIN [INDIGO036].[Inventory].[AdjustmentConcept] AC ON ISNULL(AI.AdjustmentConceptId, AID.AdjustmentConceptId) = AC.Id
    UNION ALL
    select
        '06' AS CONCEPTO,
        EntityCode AS CODIGO,
        'Control de inventario' AS DESCRIPCION,
        WarehouseId,
        ProductId,
        DocumentDate,
        Quantity,
        Value,
        AverageCost,
        CONVERT(NUMERIC(18, 2),(Quantity * Value)) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        MovementType,
        '' AS Code,
        '' AS Movimiento,
        BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    from
        [INDIGO036].[Inventory].[Kardex]
    where
        EntityName = 'InventoryControl'
    UNION ALL
    select
        '07' AS CONCEPTO,
        EntityCode AS CODIGO,
        'Prestamo Mercancia' AS DESCRIPCION,
        WarehouseId,
        ProductId,
        DocumentDate,
        Quantity,
        Value,
        AverageCost,
        CONVERT(NUMERIC(18, 2),(Quantity * Value)) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        MovementType,
        '' AS Code,
        '' AS Movimiento,
        BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    from
        [INDIGO036].[Inventory].[Kardex]
    where
        EntityName = 'LoanMerchandise'
    UNION ALL
    select
        '08' AS CONCEPTO,
        EntityCode AS CODIGO,
        'Devolución de Préstamo' AS DESCRIPCION,
        WarehouseId,
        ProductId,
        DocumentDate,
        Quantity,
        Value,
        AverageCost,
        CONVERT(NUMERIC(18, 2),(Quantity * PreviousCost)) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        MovementType,
        '' AS Code,
        '' AS Movimiento,
        BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    from
        [INDIGO036].[Inventory].[Kardex]
    where
        EntityName = 'LoanMerchandiseDevolution'
    UNION ALL
    SELECT
        DISTINCT '09' AS CONCEPTO,
        K.EntityCode AS CODIGO,
        'Dispensación Farmaceutica' AS DESCRIPCION,
        ISNULL(
            ISNULL(ALM2.WarehouseId, ALM1.WarehouseId),
            K.WarehouseId
        ) AS WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.Value,
        K.AverageCost,
        CAST((K.Quantity * K.Value) AS NUMERIC(18, 2)) AS Total,
        SO.AdmissionNumber AS INGRESO,
        '' AS [TIPO TRASLADO],
        K.MovementType,
        '' AS Code,
        '' AS Movimiento,
        BatchSerialId,
        SOD.PerformsFunctionalUnitId AS FunctionalUnitId,
        SOD.CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    FROM
        INDIGO036.Billing.ServiceOrder SO
        INNER JOIN INDIGO036.Billing.ServiceOrderDetail SOD ON SO.Id = SOD.ServiceOrderId
        AND SO.EntityName = 'PharmaceuticalDispensing'
        AND SOD.ServiceType = 0
        INNER JOIN [INDIGO036].[Inventory].[Kardex] K ON K.Id =(
            SELECT
                MAX(A.Id)
            FROM
                [INDIGO036].[Inventory].[Kardex] A
            WHERE
                SO.EntityId = A.EntityId
                AND SOD.ProductId = A.ProductId
                AND SOD.SupplyQuantity = A.Quantity
                AND A.EntityName = 'PharmaceuticalDispensing'
        )
        LEFT JOIN (
            SELECT
                A.Id,
                ROW_NUMBER () OVER (
                    PARTITION BY A.ProductId,
                    C.EntityId
                    order by
                        A.ProductId,
                        A.Id DESC
                ) AS NUMERO,
                B.WarehouseId
            FROM
                INDIGO036.Billing.ServiceOrder C
                INNER JOIN INDIGO036.Billing.ServiceOrderDetail A ON C.Id = A.ServiceOrderId
                INNER JOIN [INDIGO036].[Inventory].[Kardex] B ON C.EntityId = B.EntityId
                AND A.ProductId = B.ProductId
                AND A.SupplyQuantity = B.Quantity
                AND B.EntityName = 'PharmaceuticalDispensing'
        ) ALM1 ON SOD.Id = ALM1.Id
        AND ALM1.NUMERO = 1
        LEFT JOIN (
            SELECT
                A.Id,
                ROW_NUMBER () OVER (
                    PARTITION BY A.ProductId,
                    C.EntityId
                    order by
                        A.ProductId,
                        A.Id DESC
                ) AS NUMERO,
                B.WarehouseId
            FROM
                INDIGO036.Billing.ServiceOrder C
                INNER JOIN INDIGO036.Billing.ServiceOrderDetail A ON C.Id = A.ServiceOrderId
                INNER JOIN [INDIGO036].[Inventory].[Kardex] B ON C.EntityId = B.EntityId
                AND A.ProductId = B.ProductId
                AND A.SupplyQuantity = B.Quantity
                AND B.EntityName = 'PharmaceuticalDispensing'
        ) ALM2 ON SOD.Id = ALM2.Id
        AND ALM2.NUMERO = 4
    UNION ALL
    SELECT
        '10' AS CONCEPTO,
        K.EntityCode AS CODIGO,
        'Devolucion Dispensacion Farmaceutica' AS DESCRIPCION,
        PDD.WarehouseId,
        K.ProductId,
        PDD.DocumentDate,
        DEV.Quantity,
        K.Value,
        K.AverageCost,
        CONVERT(NUMERIC(18, 2), DEV.TOTAL) AS TOTAL,
        PDD.AdmissionNumber AS INGRESO,
        '' AS [TIPO TRASLADO],
        MovementType,
        '' AS Code,
        '' AS Movimiento,
        BatchSerialId,
        FUN.Id AS FunctionalUnitId,
        FUN.CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].PharmaceuticalDispensingDevolution PDD
        INNER JOIN (
            SELECT
                DEV.PharmaceuticalDispensingDevolutionId,
                SUM(DEV.Quantity) AS Quantity,
                SUM(DEV.TOTAL) AS TOTAL,
                DEV.FunctionalUnitId,
                DEV.ProductId
            FROM
                (
                    SELECT
                        PDDD.PharmaceuticalDispensingDevolutionId,
                        PDDD.Quantity,
                        PDDD.Quantity * DFD.AverageCost AS TOTAL,
                        DFD.FunctionalUnitId,
                        DFD.ProductId
                    FROM
                        [INDIGO036].[Inventory].[PharmaceuticalDispensingDevolutionDetail] PDDD
                        INNER JOIN [INDIGO036].[Inventory].[PharmaceuticalDispensingDetailBatchSerial] PDDBS ON PDDD.PharmaceuticalDispensingDetailBatchSerialId = PDDBS.Id
                        INNER JOIN [INDIGO036].[Inventory].[PharmaceuticalDispensingDetail] DFD ON PDDBS.PharmaceuticalDispensingDetailId = DFD.Id
                ) DEV
            GROUP BY
                DEV.PharmaceuticalDispensingDevolutionId,
                DEV.FunctionalUnitId,
                DEV.ProductId
        ) DEV ON PDD.Id = DEV.PharmaceuticalDispensingDevolutionId
        INNER JOIN INDIGO036.Payroll.FunctionalUnit FUN ON DEV.FunctionalUnitId = FUN.Id
        INNER JOIN [INDIGO036].[Inventory].[Kardex] K ON K.Id =(
            SELECT
                MAX(A.Id)
            FROM
                [INDIGO036].[Inventory].[Kardex] A
            WHERE
                PDD.Id = A.EntityId
                AND DEV.ProductId = A.ProductId
                AND A.EntityName = 'PharmaceuticalDispensingDevolution'
        )
    UNION ALL
    SELECT
        '11' AS CONCEPTO,
        EntityCode AS CODIGO,
        'Devolución de Remisiones' AS DESCRIPCION,
        K.WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.[Value],
        K.AverageCost,
        CONVERT(
            NUMERIC(18, 2),
            IIF(
                RED.UnitValue IS NOT NULL,
                IIF(
                    RED.IvaPercentage = 0,
                    RDD.Quantity * RED.UnitValue,
                    (RED.UnitValue +(RED.UnitValue * RED.IvaPercentage) / 100) * RDD.Quantity
                ),
                K.Value * RDD.Quantity
            )
        ) AS Total,
        '' AS INGRESO,
        CASE
            RD.DevolutionType
            WHEN 1 THEN 'Entrada'
            WHEN 2 THEN 'Salida'
            WHEN 3 THEN 'Inventario en consignación'
        END AS [TIPO TRASLADO],
        K.MovementType,
        '' AS Code,
        '' AS Movimiento,
        K.BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        RE.SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].[RemissionDevolutionDetail] RDD
        INNER JOIN [INDIGO036].[Inventory].[RemissionDevolution] RD ON RDD.RemissionDevolutionId = RD.Id
        LEFT JOIN [INDIGO036].[Inventory].[RemissionEntranceDetailBatchSerial] REDBS ON RDD.RemissionEntranceDetailBatchSerialId = REDBS.Id
        LEFT JOIN [INDIGO036].[Inventory].[ConsignmentInventoryRemissionDetailBatchSerial] CIRDB ON RDD.ConsignmentInventoryRemissionDetailBatchSerialId = CIRDB.Id
        LEFT JOIN [INDIGO036].[Inventory].[RemissionEntranceDetail] RED ON REDBS.RemissionEntranceDetailId = RED.Id
        LEFT JOIN [INDIGO036].[Inventory].[RemissionEntrance] RE ON RD.RemissionEntranceId = RE.Id
        LEFT JOIN [INDIGO036].[Inventory].[ConsignmentInventoryRemissionDetail] CIRD ON CIRDB.ConsignmentInventoryRemissionDetailId = CIRD.Id
        LEFT JOIN [INDIGO036].[Inventory].[Kardex] K ON K.Id =(
            SELECT
                MAX(A.Id)
            FROM
                [INDIGO036].[Inventory].[Kardex] A
            WHERE
                RDD.RemissionDevolutionId = A.EntityId
                AND RDD.ProductId = A.ProductId
                AND A.EntityName = 'RemissionDevolution'
        )
    UNION ALL
    SELECT
        '12' AS CONCEPTO,
        K.EntityCode AS CODIGO,
        'Remision de Entrada' AS DESCRIPCION,
        K.WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.[Value],
        K.AverageCost,
        CONVERT(
            NUMERIC(18, 2),
            IIF(
                RED.IvaPercentage = 0,
                RED.Quantity * RED.UnitValue,
                (RED.UnitValue +(RED.UnitValue * RED.IvaPercentage) / 100) * RED.Quantity
            )
        ) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        K.MovementType,
        '' AS Code,
        '' AS Movimiento,
        K.BatchSerialId,
        '' AS FunctionalUnitId,
        '' AS CostCenterId,
        RE.SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].[RemissionEntranceDetail] RED
        INNER JOIN [INDIGO036].[Inventory].[RemissionEntrance] RE ON RED.RemissionEntranceId = RE.Id
        INNER JOIN [INDIGO036].[Inventory].[Kardex] K ON K.Id =(
            SELECT
                MAX(A.Id)
            FROM
                [INDIGO036].[Inventory].[Kardex] A
            WHERE
                RED.RemissionEntranceId = A.EntityId
                AND RED.ProductId = A.ProductId
                AND RED.Quantity = A.Quantity
                AND EntityName = 'RemissionEntrance'
        )
    UNION ALL
    SELECT
        '13' AS CONCEPTO,
        EntityCode AS CODIGO,
        'Remision de Salida' AS DESCRIPCION,
        K.WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.Value,
        K.AverageCost,
        CONVERT(NUMERIC(18, 2),(K.Quantity * K.Value)) AS Total,
        '' AS INGRESO,
        '' AS [TIPO TRASLADO],
        K.MovementType,
        AC.Code,
        AC.Name AS Movimiento,
        BatchSerialId,
        OT.TargetFunctionalUnitId AS FunctionalUnitId,
        '' AS CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    FROM
        [INDIGO036].[Inventory].[Kardex] K
        INNER JOIN [INDIGO036].[Inventory].[TransferOrder] OT ON K.EntityId = OT.Id
        AND K.EntityName = 'RemissionOutput'
        LEFT JOIN [INDIGO036].[Inventory].[AdjustmentConcept] AC ON OT.AdjustmentConceptId = AC.Id
    UNION ALL
    select
        '14' AS CONCEPTO,
        EntityCode AS CODIGO,
        'Orden de Traslado' AS DESCRIPCION,
        K.WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.Value,
        K.AverageCost,
        CONVERT(NUMERIC(18, 2),(K.Quantity * K.Value)) AS Total,
        '' AS INGRESO,
        CASE
            OT.OrderType
            WHEN 1 THEN 'Traslado'
            WHEN 2 THEN 'Consumo'
            WHEN 3 THEN 'Traslado en transito'
        END AS [TIPO TRASLADO],
        K.MovementType,
        AC.Code,
        AC.Name AS Movimiento,
        BatchSerialId,
        OT.TargetFunctionalUnitId AS FunctionalUnitId,
        FU.CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    from
        [INDIGO036].[Inventory].[Kardex] K
        INNER JOIN [INDIGO036].[Inventory].[TransferOrder] OT ON K.EntityId = OT.Id
        AND K.EntityName = 'TransferOrder'
        LEFT JOIN [INDIGO036].[Inventory].[AdjustmentConcept] AC ON OT.AdjustmentConceptId = AC.Id
        LEFT JOIN INDIGO036.Payroll.FunctionalUnit FU ON OT.TargetFunctionalUnitId = FU.Id
    UNION ALL
    select
        '15' AS CONCEPTO,
        K.EntityCode AS CODIGO,
        'Devolucion Orden de Traslado' AS DESCRIPCION,
        K.WarehouseId,
        K.ProductId,
        K.DocumentDate,
        K.Quantity,
        K.[Value],
        K.AverageCost,
        CONVERT(NUMERIC(18, 2),(K.Quantity * K.[Value])) AS Total,
        '' AS INGRESO,
        CASE
            OT.OrderType
            WHEN 1 THEN 'Traslado'
            WHEN 2 THEN 'Consumo'
            WHEN 3 THEN 'Traslado en transito'
        END AS [TIPO TRASLADO],
        K.[MovementType],
        '' AS Code,
        '' AS Movimiento,
        K.BatchSerialId,
        OT.TargetFunctionalUnitId AS FunctionalUnitId,
        FUN.CostCenterId,
        NULL SupplierId,
        NULL AS [TIPO LEGALIZACION],
        NULL AS [CANTIDAD LEGALIZADO],
        NULL [CODIGO REMISION],
        NULL AS [FECHA REMISION],
        NULL AS [VALOR REMISION],
        NULL AS [CUENTA X PAGAR / NOTA]
    from
        [INDIGO036].[Inventory].[Kardex] K
        INNER JOIN [INDIGO036].[Inventory].[TransferOrderDevolution] TOD ON K.EntityId = TOD.Id
        AND K.EntityName = 'TransferOrderDevolution'
        INNER JOIN [INDIGO036].[Inventory].[TransferOrder] OT ON TOD.TransferOrderId = OT.Id
        LEFT JOIN INDIGO036.Payroll.FunctionalUnit FUN ON OT.TargetFunctionalUnitId = FUN.Id
)
SELECT
    CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
    CON.CODIGO,
    FUN.Code + ' - ' + FUN.Name AS [UNIDAD FUNCIONAL],
    PAC.IPCODPACI + ' - ' + PAC.IPNOMCOMP AS PACIENTE,
    ISNULL(ATC.Code, SUP.Code) AS [CODIGO MEDICAMENTO / INSUMO],
    ISNULL(ATC.Name, SUP.SupplieName) AS [MEDICAMENTO / INSUMO],
    P.Code AS [CODIGO PRODUCTO],
    P.Name AS [PRODUCTO],
    GRU.Name AS [GRUPO],
    SUB.Name AS [SUB GRUPO],
    LOT.BatchCode AS [LOTE/SERIAL],
    P.MinimumStock AS [STOK MINIMO],
    P.MaximumStock AS [STOK MAXIMO],
    AL.Code AS [CODIGO ALMACEN],
    AL.Name AS ALMACEN,
    CON.CONCEPTO AS CONCEPTO,
    CON.DESCRIPCION AS [DESCRIPCION CONCEPTO],
    CON.[TIPO TRASLADO],
    CASE
        CON.MovementType
        WHEN 1 THEN 'Entrada'
        WHEN 2 THEN 'Salida'
    end as [TIPO DE MOVIMIENTO],
    CON.Code AS [CODIGO MOVIMIENTO],
    CON.Movimiento,
    CON.Quantity AS CANTIDAD,
    IVA.Percentage AS [PORCENTAGE IVA],
    CON.Value AS [VALOR UNITARIO],
    CON.Total AS [VALOR TOTAL],
    CON.AverageCost AS [COSTO PROMEDIO],
    MA.Number + ' - ' + MA.Name AS [CUENTA CONTABLE],
    CO.Code + ' - ' + CO.Name AS [CENTRO DE COSTO],
    CON.DocumentDate AS [FECHA DOCUMENTO],
    TER.Nit,
    SU.Name AS PROVEEDOR,
    CON.[TIPO LEGALIZACION],
    CON.[CANTIDAD LEGALIZADO],
    CON.[CODIGO REMISION],
    CON.[FECHA REMISION],
    CAST(CON.[VALOR REMISION] AS NUMERIC(18, 2)) AS [VALOR REMISION],
    CON.[CUENTA X PAGAR / NOTA],
    CAST(CON.DocumentDate AS date) AS 'FECHA BUSQUEDA',
    YEAR(CON.DocumentDate) AS 'AÑO FECHA BUSQUEDA',
    MONTH(CON.DocumentDate) AS 'MES AÑO FECHA BUSQUEDA',
    CASE
        MONTH(CON.DocumentDate)
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
    END AS 'MES NOMBRE FECHA BUSQUEDA',
    FORMAT(DAY(CON.DocumentDate), '00') AS 'DIA FECHA BUSQUEDA',
    CONCAT(
        FORMAT(MONTH(CON.DocumentDate), '00'),
        ' - ',
        CASE
            MONTH(CON.DocumentDate)
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
        END
    ) MES_LABEL_INGRESO,
    CONVERT(
        DATETIME,
        GETDATE() AT TIME ZONE 'Pakistan Standard Time',
        1
    ) AS ULT_ACTUAL
FROM
    CTE_CONCEPTOS CON
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] P ON CON.ProductId = P.Id
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] AL ON CON.WarehouseId = AL.Id
    INNER JOIN [INDIGO036].[Inventory].[ProductGroup] GRU ON P.ProductGroupId = GRU.Id
    INNER JOIN [INDIGO036].[Inventory].[ProductSubGroup] SUB ON P.ProductSubGroupId = SUB.Id
    LEFT JOIN [INDIGO036].[Inventory].[EntranceVoucherDetail] CED ON P.Id = CED.ProductId
    AND CED.Id =(
        SELECT
            MAX(A.Id)
        FROM
            [INDIGO036].[Inventory].[EntranceVoucherDetail] A
        WHERE
            P.Id = A.ProductId
    )
    LEFT JOIN [INDIGO036].[Inventory].[ATC] ATC ON P.ATCId = ATC.Id
    LEFT JOIN [INDIGO036].[Inventory].[InventorySupplie] SUP ON P.SupplieId = SUP.Id
    LEFT JOIN [INDIGO036].[Inventory].[EntranceVoucher] CE ON CED.EntranceVoucherId = CE.Id
    LEFT JOIN INDIGO036.Common.Supplier SU ON CON.SupplierId = SU.Id
    LEFT JOIN INDIGO036.Common.ThirdParty TER ON SU.IdThirdParty = TER.Id
    LEFT JOIN [INDIGO036].[Inventory].[BatchSerial] LOT ON CON.BatchSerialId = LOT.Id
    LEFT JOIN [INDIGO036].[dbo].[ADINGRESO] ING ON CON.INGRESO = ING.NUMINGRES
    LEFT JOIN [INDIGO036].[dbo].[INPACIENT] PAC ON ING.IPCODPACI = PAC.IPCODPACI
    LEFT JOIN INDIGO036.Payroll.FunctionalUnit FUN ON CON.FunctionalUnitId = FUN.Id
    LEFT JOIN [INDIGO036].[Inventory].ProductGroupFunctionalUnit FU ON GRU.Id = FU.ProductGroupId
    AND CON.FunctionalUnitId = FU.FunctionalUnitId
    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA ON FU.CostAccountId = MA.Id
    LEFT JOIN INDIGO036.Payroll.CostCenter CO ON FU.FunctionalUnitId = CO.Id
    LEFT JOIN INDIGO036.GeneralLedger.GeneralLedgerIVA IVA ON P.IVAId = IVA.Id