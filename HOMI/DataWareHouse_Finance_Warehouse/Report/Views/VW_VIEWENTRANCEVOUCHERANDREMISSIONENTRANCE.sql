-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_VIEWENTRANCEVOUCHERANDREMISSIONENTRANCE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_VIEWENTRANCEVOUCHERANDREMISSIONENTRANCE] AS

WITH CTE_COMPROBANTE_DE_ENTRADA_VS_TEMISION_DE_ENTRADA AS (
    SELECT
        RE.Id,
        RE.Code,
        EV.Code AS ENTRADA
    FROM
        INDIGO036.Inventory.RemissionEntrance RE
        INNER JOIN INDIGO036.Inventory.RemissionEntranceDetail RED ON RE.Id = RED.RemissionEntranceId
            AND Status = 2
        INNER JOIN INDIGO036.Inventory.RemissionEntranceDetailBatchSerial RDB ON RED.Id = RDB.RemissionEntranceDetailId
        LEFT JOIN INDIGO036.Inventory.EntranceVoucherDetail EVD ON RDB.Id = EVD.ConsignmentInventoryRemissionDetailBatchSerialId
        LEFT JOIN INDIGO036.Inventory.EntranceVoucher EV ON EVD.EntranceVoucherId = EV.Id
            AND EV.Status = 2
)
SELECT
    'COMPROBANTE DE ENTRADA' AS [TIPO DE DOCUMENTO],
    CE.Code AS [CODIGO DEL DOCUMENTO],
    CAST(CE.ConfirmationDate AS DATE) AS [FECHA DEL DOCUMENTO],
    PRO.Code AS [CODIGO DEL PRODUCTO],
    PRO.Name AS [PRODUCTO],
    CED.Quantity AS CANTIDAD,
    TER.Nit + '-' + TER.DigitVerification AS [NIT TERCERO],
    TER.Name AS TERCERO,
    CED.UnitValue AS [VALOR UNIDAD],
    CED.IvaPercentage AS [PORCENTAJE IVA],
    CED.IvaValue AS [IVA],
    CED.TotalValue AS [TOTAL VALOR],
    ISNULL(RE.Code, '') AS [DOCUMENTO AFECTA],
    AP.Code AS [CUENTA X PAGAR],
    JV.Consecutive AS [CODIGO DOCUMENTO CRUCE],
    JVT.Code + '-' + JVT.Name AS [TIPO COMPROBANTE CONTABLE]
FROM
    INDIGO036.Inventory.EntranceVoucher CE
    INNER JOIN INDIGO036.Inventory.EntranceVoucherDetail CED ON CE.Id = CED.EntranceVoucherId
        AND CE.Status = 2
    INNER JOIN INDIGO036.Common.Supplier SUP ON CE.SupplierId = SUP.Id
    INNER JOIN INDIGO036.Common.ThirdParty TER ON SUP.IdThirdParty = TER.Id
    INNER JOIN INDIGO036.Inventory.InventoryProduct PRO ON CED.ProductId = PRO.Id
    LEFT JOIN INDIGO036.Inventory.RemissionEntranceDetailBatchSerial RDB ON CED.RemissionEntranceDetailBatchSerialId = RDB.Id
    LEFT JOIN INDIGO036.Inventory.RemissionEntranceDetail RED ON RDB.RemissionEntranceDetailId = RED.Id
    LEFT JOIN INDIGO036.Inventory.RemissionEntrance RE ON RED.RemissionEntranceId = RE.Id
    LEFT JOIN INDIGO036.Payments.AccountPayable AP ON CE.AccountPayableId = AP.Id
    LEFT JOIN INDIGO036.GeneralLedger.JournalVouchers JV ON AP.Id = JV.EntityId
        AND JV.EntityName = 'AccountPayable'
        AND JV.LegalBookId = 1
    LEFT JOIN INDIGO036.GeneralLedger.JournalVoucherTypes JVT ON JV.IdJournalVoucher = JVT.Id
UNION ALL
SELECT
    'REMISION DE ENTRADA' AS [TIPO DE DOCUMENTO],
    RE.Code AS [CODIGO DEL DOCUMENTO],
    CAST(RE.ConfirmationDate AS DATE) AS [FECHA DEL DOCUMENTO],
    PRO.Code AS [CODIGO DEL PRODUCTO],
    PRO.Name AS [PRODUCTO],
    RED.Quantity AS CANTIDAD,
    TER.Nit + '-' + TER.DigitVerification AS [NIT TERCERO],
    TER.Name AS TERCERO,
    RED.UnitValue AS [VALOR UNIDAD],
    RED.IvaPercentage AS [PORCENTAJE IVA],
    RED.IvaValue AS [IVA],
    RED.TotalValue AS [TOTAL VALOR],
    '' AS [DOCUMENTO AFECTA],
    '' AS [CUENTA X PAGAR],
    '' AS [CODIGO DOCUMENTO CRUCE],
    '' AS [TIPO COMPROBANTE CONTABLE]
FROM
    CTE_COMPROBANTE_DE_ENTRADA_VS_TEMISION_DE_ENTRADA CTE
    INNER JOIN INDIGO036.Inventory.RemissionEntrance RE ON CTE.Id = RE.Id
        AND CTE.ENTRADA IS NULL
        AND RE.Status = 2
    INNER JOIN INDIGO036.Inventory.RemissionEntranceDetail RED ON RE.Id = RED.RemissionEntranceId
    INNER JOIN INDIGO036.Inventory.InventoryProduct PRO ON RED.ProductId = PRO.Id
    INNER JOIN INDIGO036.Common.Supplier SUP ON RE.SupplierId = SUP.Id
    INNER JOIN INDIGO036.Common.ThirdParty TER ON SUP.IdThirdParty = TER.Id

UNION ALL
SELECT
    'DV COMPRA' AS [TIPO DE DOCUMENTO],
    EVD.Code AS [CODIGO DEL DOCUMENTO],
    CAST(EVD.ConfirmationDate AS DATE) AS [FECHA DEL DOCUMENTO],
    PRO.Code AS [CODIGO DEL PRODUCTO],
    PRO.Name AS [PRODUCTO],
    EVDD.Quantity AS CANTIDAD,
    TER.Nit + '-' + TER.DigitVerification AS [NIT TERCERO],
    TER.Name AS TERCERO,
    DEVD.UnitValue AS [VALOR UNIDAD],
    DEVD.IvaPercentage AS [PORCENTAJE IVA],
    -(
        CONVERT(
            INT,
            (
                (EVDD.Quantity * DEVD.UnitValue) * DEVD.IvaPercentage
            ) / 100
        )
    ) AS [IVA],
    -(
        (EVDD.Quantity * DEVD.UnitValue) + CONVERT(
            INT,
            (
                (EVDD.Quantity * DEVD.UnitValue) * DEVD.IvaPercentage
            ) / 100
        )
    ) AS [TOTAL VALOR],
    EV.Code AS [DOCUMENTO AFECTA],
    '' AS [CUENTA X PAGAR],
    '' AS [CODIGO DOCUMENTO CRUCE],
    '' AS [TIPO COMPROBANTE CONTABLE]
FROM
    INDIGO036.Inventory.EntranceVoucherDevolution AS EVD
    INNER JOIN INDIGO036.Inventory.EntranceVoucherDevolutionDetail EVDD ON EVD.Id = EVDD.EntranceVoucherDevolutionId
        AND EVD.Status = 2
    INNER JOIN INDIGO036.Inventory.EntranceVoucherDetailBatchSerial RDB ON EVDD.EntranceVoucherDetailBatchSerialId = RDB.Id
    INNER JOIN INDIGO036.Inventory.EntranceVoucherDetail DEVD ON RDB.EntranceVoucherDetailId = DEVD.Id
    INNER JOIN INDIGO036.Inventory.EntranceVoucher EV ON DEVD.EntranceVoucherId = EV.Id
    INNER JOIN INDIGO036.Inventory.InventoryProduct PRO ON DEVD.ProductId = PRO.Id
    INNER JOIN INDIGO036.Common.Supplier SUP ON EV.SupplierId = SUP.Id
    INNER JOIN INDIGO036.Common.ThirdParty TER ON SUP.IdThirdParty = TER.Id

UNION ALL
SELECT
    'DV REMISION' AS [TIPO DE DOCUMENTO],
    RD.Code AS [CODIGO DEL DOCUMENTO],
    CAST(RD.ConfirmationDate AS DATE) AS [FECHA DEL DOCUMENTO],
    PRO.Code AS [CODIGO DEL PRODUCTO],
    PRO.Name AS [PRODUCTO],
    RDD.Quantity AS CANTIDAD,
    TER.Nit + '-' + TER.DigitVerification AS [NIT TERCERO],
    TER.Name AS TERCERO,
    RED.UnitValue AS [VALOR UNIDAD],
    RED.IvaPercentage AS [PORCENTAJE IVA],
    -(
        CONVERT(
            INT,
            (
                (RDD.Quantity * RED.UnitValue) * RED.IvaPercentage
            ) / 100
        )
    ) AS [IVA],
    -(
        (RDD.Quantity * RED.UnitValue) + CONVERT(
            INT,
            (
                (RDD.Quantity * RED.UnitValue) * RED.IvaPercentage
            ) / 100
        )
    ) AS [TOTAL VALOR],
    RE.Code AS [DOCUMENTO AFECTA],
    '' AS [CUENTA X PAGAR],
    '' AS [CODIGO DOCUMENTO CRUCE],
    '' AS [TIPO COMPROBANTE CONTABLE]
FROM
    CTE_COMPROBANTE_DE_ENTRADA_VS_TEMISION_DE_ENTRADA CTE
    INNER JOIN INDIGO036.Inventory.RemissionDevolution RD ON CTE.Id = RD.RemissionEntranceId
        AND RD.Status = 2
    INNER JOIN INDIGO036.Inventory.RemissionDevolutionDetail RDD ON RD.Id = RDD.RemissionDevolutionId
    INNER JOIN INDIGO036.Inventory.RemissionEntrance RE ON CTE.Id = RE.Id
        AND CTE.ENTRADA IS NULL
    INNER JOIN INDIGO036.Inventory.RemissionEntranceDetail RED ON RE.Id = RED.RemissionEntranceId
    INNER JOIN INDIGO036.Inventory.InventoryProduct PRO ON RED.ProductId = PRO.Id
    INNER JOIN INDIGO036.Common.Supplier SUP ON RE.SupplierId = SUP.Id
    INNER JOIN INDIGO036.Common.ThirdParty TER ON SUP.IdThirdParty = TER.Id 
;