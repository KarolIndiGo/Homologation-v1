-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_VIEWTRANSFERORDER
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_VIEWTRANSFERORDER] AS
                SELECT
    DISTINCT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
    MA.Number AS [CUENTA CONTABLE],
    MA.Name AS [NOMBRE CUENTA CONTABLE],
    CASE
        MA.Nature
        WHEN 1 THEN 'Debito'
        ELSE 'Credito'
    END AS [NATURALEZA CUENTA CONTABLE],
    '899999123' AS [NIT TERCERO],
    'FUNDACION HOSPITAL DE LA MISERICORDIA' AS [NOMBRE TERCERO],
    JV.VoucherDate AS [FECHA DEL DOCUMENTO],
    JV.Consecutive AS [CODIGO DEL COMPROBANTE],
    JVT.Name AS [TIPO DE COMPROBANTE],
    JV.EntityCode AS [CODIGO DOCUMENTO FUENTE],
    'Orden de Traslado' AS [NOMBRE DOCUMENTO FUENTE],
    CASE
        OT.OrderType
        WHEN 1 THEN 'Traslado'
        WHEN 2 THEN 'Consumo'
        WHEN 3 THEN 'Traslado en Transito'
    END AS [TIPO ORDEN TRASLADO],
    CASE
        OT.Status
        WHEN 1 THEN 'Registrado'
        WHEN 2 THEN 'Confirmado/Entregado'
        WHEN 3 THEN 'Anulado'
        WHEN 4 THEN 'En Transito'
    END AS [ESTADO ORDEN TRASLADO],
    OT.Description AS [DETALLE ORDEN TRASLADO],
    C.Name AS MONEDA,
    WO.Code + ' - ' + WO.Name AS [ALMACEN DE ORIGEN],
    FU.Code + ' - ' + FU.Name AS [UNIDAD FUNSIONAL DESTINO],
    PRO.Code AS [CODIGO DE PRODUCTO],
    PRO.Name AS [PRODUCTO],
    OTD.Quantity AS [CANTIDADES UNIDADES DESPACHADAS],
    OTD.Value AS [VALOR UNITARIO],
    OTD.Quantity * OTD.Value AS [VALOR TOTAL],
    CAST(JV.VoucherDate AS date) AS 'FECHA BUSQUEDA',
    YEAR(JV.VoucherDate) AS 'AÑO FECHA BUSQUEDA',
    MONTH(JV.VoucherDate) AS 'MES AÑO FECHA BUSQUEDA',
    CASE
        MONTH(JV.VoucherDate)
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
    FORMAT(DAY(JV.VoucherDate), '00') AS 'DIA FECHA BUSQUEDA',
    CONCAT(
        FORMAT(MONTH(JV.VoucherDate), '00'),
        ' - ',
        CASE
            MONTH(JV.VoucherDate)
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
    INDIGO036.Inventory.TransferOrder OT
    INNER JOIN INDIGO036.Inventory.TransferOrderDetail OTD ON OT.Id = OTD.TransferOrderId
    INNER JOIN INDIGO036.GeneralLedger.JournalVouchers JV ON OT.Id = JV.EntityId
        AND JV.EntityName = 'TransferOrder'
        AND JV.LegalBookId = 1
    INNER JOIN (
        SELECT
            SUM(J.DebitValue) AS DebitValue,
            J.IdAccounting
        FROM
            INDIGO036.GeneralLedger.JournalVoucherDetails J
        WHERE
            J.DebitValue != '0.00'
            AND IdRetention IS NULL
        GROUP BY
            J.IdAccounting
    ) AS JVD ON JV.Id = JVD.IdAccounting
    INNER JOIN INDIGO036.Inventory.InventoryProduct PRO ON OTD.ProductId = PRO.Id
    INNER JOIN INDIGO036.Inventory.ProductGroup GRUP ON PRO.ProductGroupId = GRUP.Id
    INNER JOIN INDIGO036.Inventory.ProductGroupFunctionalUnit FUN ON GRUP.Id = FUN.ProductGroupId
        AND FUN.FunctionalUnitId = OT.TargetFunctionalUnitId
    INNER JOIN INDIGO036.GeneralLedger.MainAccounts MA ON FUN.CostAccountId = MA.Id
    INNER JOIN INDIGO036.GeneralLedger.JournalVoucherTypes JVT ON JV.IdJournalVoucher = JVT.Id
    INNER JOIN INDIGO036.GeneralLedger.LegalBook LB ON JV.LegalBookId = LB.Id
    INNER JOIN INDIGO036.Common.Currency C ON LB.OfficialCurrencyId = C.Id
    INNER JOIN INDIGO036.Inventory.Warehouse WO ON OT.SourceWarehouseId = WO.Id
    INNER JOIN INDIGO036.Payroll.FunctionalUnit FU ON FUN.FunctionalUnitId = FU.Id

UNION
ALL
SELECT
    DISTINCT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
    MA.Number AS [CUENTA CONTABLE],
    MA.Name AS [NOMBRE CUENTA CONTABLE],
    CASE
        MA.Nature
        WHEN 1 THEN 'Debito'
        ELSE 'Credito'
    END AS [NATURALEZA CUENTA CONTABLE],
    '899999123' AS [NIT TERCERO],
    'FUNDACION HOSPITAL DE LA MISERICORDIA' AS [NOMBRE TERCERO],
    JV.VoucherDate AS [FECHA DEL DOCUMENTO],
    JV.Consecutive AS [CODIGO DEL COMPROBANTE],
    JVT.Name AS [TIPO DE COMPROBANTE],
    OTD.Code AS [CODIGO DOCUMENTO FUENTE],
    'Devolución Orden de Traslado' AS [NOMBRE DOCUMENTO FUENTE],
    CASE
        OT.OrderType
        WHEN 1 THEN 'Traslado'
        WHEN 2 THEN 'Consumo'
        WHEN 3 THEN 'Traslado en Transito'
    END AS [TIPO ORDEN TRASLADO],
    CASE
        OTD.Status
        WHEN 1 THEN 'Registrado'
        WHEN 2 THEN 'Confirmado'
        WHEN 3 THEN 'Anulado'
    END AS [ESTADO ORDEN TRASLADO],
    OTD.Description AS [DETALLE ORDEN TRASLADO],
    C.Name AS MONEDA,
    WO.Code + ' - ' + WO.Name AS [ALMACEN DE ORIGEN],
    FU.Code + ' - ' + FU.Name AS [UNIDAD FUNSIONAL DESTINO],
    PRO.Code AS [CODIGO DE PRODUCTO],
    PRO.Name AS [PRODUCTO],
    OTDD.Quantity AS [CANTIDADES UNIDADES DESPACHADAS],
    -(TOD.Value) AS [VALOR UNITARIO],
    -(OTDD.Quantity * TOD.Value) AS [VALOR TOTAL],
    CAST(JV.VoucherDate AS date) AS 'FECHA BUSQUEDA',
    YEAR(JV.VoucherDate) AS 'AÑO FECHA BUSQUEDA',
    MONTH(JV.VoucherDate) AS 'MES AÑO FECHA BUSQUEDA',
    CASE
        MONTH(JV.VoucherDate)
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
    FORMAT(DAY(JV.VoucherDate), '00') AS 'DIA FECHA BUSQUEDA',
    CONCAT(
        FORMAT(MONTH(JV.VoucherDate), '00'),
        ' - ',
        CASE
            MONTH(JV.VoucherDate)
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
    INDIGO036.Inventory.TransferOrderDevolution OTD
    INNER JOIN INDIGO036.Inventory.TransferOrderDevolutionDetail OTDD ON OTD.Id = OTDD.TransferOrderDevolutionId
    INNER JOIN INDIGO036.GeneralLedger.JournalVouchers JV ON OTD.Id = JV.EntityId
        AND JV.EntityName = 'TransferOrderDevolution'
        AND JV.LegalBookId = 1
    INNER JOIN (
        SELECT
            SUM(J.DebitValue) AS DebitValue,
            J.IdAccounting
        FROM
            INDIGO036.GeneralLedger.JournalVoucherDetails J
        WHERE
            J.DebitValue != '0.00'
            AND IdRetention IS NULL
        GROUP BY
            J.IdAccounting
    ) AS JVD ON JV.Id = JVD.IdAccounting
    INNER JOIN INDIGO036.Inventory.TransferOrderDetailBatchSerial TODB ON OTDD.TransferOrderDetailBatchSerialId = TODB.Id
    INNER JOIN INDIGO036.Inventory.TransferOrder OT ON OTD.TransferOrderId = OT.Id
    INNER JOIN INDIGO036.Inventory.TransferOrderDetail TOD ON TODB.TransferOrderDetailId = TOD.Id
    INNER JOIN INDIGO036.Inventory.InventoryProduct PRO ON TOD.ProductId = PRO.Id
    INNER JOIN INDIGO036.Inventory.ProductGroup GRUP ON PRO.ProductGroupId = GRUP.Id
    INNER JOIN INDIGO036.GeneralLedger.JournalVoucherTypes JVT ON JV.IdJournalVoucher = JVT.Id
    INNER JOIN INDIGO036.GeneralLedger.LegalBook LB ON JV.LegalBookId = LB.Id
    INNER JOIN INDIGO036.Common.Currency C ON LB.OfficialCurrencyId = C.Id
    INNER JOIN INDIGO036.Inventory.Warehouse WO ON OT.SourceWarehouseId = WO.Id
    LEFT JOIN INDIGO036.Inventory.ProductGroupFunctionalUnit FUN ON GRUP.Id = FUN.ProductGroupId
        AND FUN.FunctionalUnitId = OT.TargetFunctionalUnitId
    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA ON FUN.CostAccountId = MA.Id
    LEFT JOIN INDIGO036.Payroll.FunctionalUnit FU ON FUN.FunctionalUnitId = FU.Id