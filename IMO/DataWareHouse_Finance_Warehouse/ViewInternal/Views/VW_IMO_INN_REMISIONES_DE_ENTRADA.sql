-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_INN_REMISIONES_DE_ENTRADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_INN_Remisiones_de_entrada]
AS

SELECT 
    uo.UnitName AS Sede,
    cr.Code AS [Còd Remisión],
    cr.RemissionDate AS [Fecha Remisión],
    PR.Code AS [Còdigo Proveedor],
    PR.Name AS Proveedor,
    AL.Code AS [Còdigo Almacèn],
    AL.Name AS Almacèn,
    cr.RemissionNumber AS [Nùmero Remisiòn],
    cr.Description AS Descripciòn,
    cr.Value AS [Vr Remisiòn],
    cr.IvaValue AS Iva,
    cr.TotalValue AS [Vr Total],
    CASE cr.Status
        WHEN '1' THEN 'registrada'
        WHEN '2' THEN 'confirmada'
        WHEN '3' THEN 'anulada'
    END AS Estado_Remisiòn,
    CASE cr.ProductStatus
        WHEN '1' THEN 'Sin_Movmientos'
        WHEN '2' THEN 'Parcial'
        WHEN '3' THEN 'Total'
    END AS estado_productos,
    pd.Code AS [Còd Producto],
    pd.Name AS Producto,
    DR.Quantity AS Cantidad,
    DR.UnitValue AS VlrUnitario,
    DR.TotalValue AS Total,
    pd.ProductCost AS [Costo Promedio],
    Pen.OutstandingQuantity AS Pendiente_Cruzar,
    CASE DR.RemissionSource
        WHEN '1' THEN 'Ninguno'
        WHEN '2' THEN 'Orden de Compra'
    END AS [Origen],
    DR.SourceCode AS [Codigo Orden de Compra],
    p.Fullname AS Usuario,
    CASE WHEN DR.UnitValue * Pen.OutstandingQuantity = 0 
         THEN 0 
         ELSE DR.UnitValue * Pen.OutstandingQuantity 
    END AS VrPendiente
FROM [INDIGO035].[Inventory].[RemissionEntrance] AS cr
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS uo
    ON uo.Id = cr.OperatingUnitId
INNER JOIN [INDIGO035].[Common].[Supplier] AS PR
    ON PR.Id = cr.SupplierId
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS AL
    ON AL.Id = cr.WarehouseId
INNER JOIN [INDIGO035].[Inventory].[RemissionEntranceDetail] AS DR
    ON DR.RemissionEntranceId = cr.Id
INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS pd
    ON pd.Id = DR.ProductId
INNER JOIN [INDIGO035].[Security].[UserInt] AS U
    ON U.UserCode = cr.CreationUser
INNER JOIN [INDIGO035].[Security].[PersonInt] AS p
    ON p.Id = U.IdPerson
LEFT OUTER JOIN [INDIGO035].[Inventory].[RemissionEntranceDetailBatchSerial] AS Pen
    ON Pen.RemissionEntranceDetailId = DR.Id
LEFT OUTER JOIN [INDIGO035].[Inventory].[EntranceVoucherDetail] AS ce
    ON ce.RemissionEntranceDetailBatchSerialId = Pen.Id
   AND ce.EntranceSource = '4'
WHERE cr.Status <> '3' --AND cr.RemissionDate > '20201231'