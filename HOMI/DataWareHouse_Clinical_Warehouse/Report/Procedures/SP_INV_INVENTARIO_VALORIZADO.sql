-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: SP_INV_INVENTARIO_VALORIZADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.SP_INV_INVENTARIO_VALORIZADO
    @year INT,
    @month INT,
    @day INT
AS
BEGIN
    DECLARE @dateFilter DATE = DATEFROMPARTS(@year, @month, @day);
    SET @dateFilter = DATEADD(DAY, -1, DATEADD(MONTH, 1, @dateFilter));
    DECLARE @Valorization INT = 1;

    WITH tmpPhysical AS (
        SELECT
            K.WarehouseId,
            K.ProductId,
            K.BatchSerialId,
            SUM(IIF(K.MovementType = 1, K.Quantity, K.Quantity * -1)) AS Quantity,
            MAX(K.Id) AS LastIdKardex
        FROM [INDIGO036].[Inventory].[Kardex] K
        WHERE CAST(K.CreationDate AS DATE) <= @dateFilter
            AND K.AffectInventory = 1
        GROUP BY
            K.WarehouseId,
            K.ProductId,
            K.BatchSerialId
    ),
    CTE_Kardex AS (
        SELECT
            K.Id,
            K.AverageCost,
            SUM(IIF(K.AffectInventory = 1, K.Quantity, 0)) AS Quantity,
            K.[Value] AS PrecioUnitario,
            SUM(
                IIF(
                    K.Quantity = 0 AND K.EntityName = 'JournalVouchers',
                    1,
                    K.Quantity
                ) * K.Value
            ) AS Value
        FROM [INDIGO036].[Inventory].[Kardex] K
        WHERE YEAR(K.DocumentDate) <= @year
        GROUP BY
            K.Id,
            K.AffectInventory,
            K.EntityName,
            K.[Value],
            K.AverageCost
    )

    SELECT
        w.Code AS [CODIGO ALMACEN],
        w.Name AS [ALMACEN],
        ip.Code AS [CODIGO PRODUCTO],
        ip.Name AS [NOMBRE PRODUCTO],
        ISNULL(a.Concentration, '') AS [CONCENTRACION],
        CASE @Valorization
            WHEN 1 THEN 'Costo promedio'
            WHEN 2 THEN 'costo final'
            ELSE 'precio venta'
        END AS [VALORIZACION],
        IIF(
            @Valorization = 1,
            k.AverageCost,
            IIF(
                @Valorization = 2,
                ip.FinalProductCost,
                ip.SellingPrice
            )
        ) AS [COSTO PROMEDIO],
        ISNULL(CAST(b.ExpirationDate AS VARCHAR), '') AS [FECHA EXPIRACION],
        _pi.Quantity AS [CANTIDAD],
        k.PrecioUnitario AS [COSTO UNIDAD],
        k.[Value] AS [VALOR TOTAL],
        PG.Code AS [GRUPO_ID],
        PG.Name AS [GRUPO],
        MA.Number AS [CUENTA CONTABLE]
    FROM tmpPhysical _pi
    INNER JOIN [INDIGO036].[Inventory].[Warehouse] w ON _pi.WarehouseId = w.Id
    INNER JOIN [INDIGO036].[Inventory].[InventoryProduct] ip ON _pi.ProductId = ip.Id
    INNER JOIN [INDIGO036].[Inventory].[ProductGroup] PG ON ip.ProductGroupId = PG.Id
    INNER JOIN INDIGO036.Payments.AccountPayableConcepts APC ON PG.InventoryAccountPayableConceptId = APC.Id
    INNER JOIN INDIGO036.GeneralLedger.MainAccounts MA ON APC.IdAccount = MA.Id
    INNER JOIN CTE_Kardex k ON k.Id = _pi.LastIdKardex
    LEFT JOIN [INDIGO036].[Inventory].[ATC] a ON ip.ATCId = a.Id
    LEFT JOIN [INDIGO036].[Inventory].[BatchSerial] b ON _pi.BatchSerialId = b.Id
    WHERE _pi.Quantity <> 0
    ORDER BY w.Code;
END;
