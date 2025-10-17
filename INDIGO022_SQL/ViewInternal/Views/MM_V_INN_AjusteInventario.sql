-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_V_INN_AjusteInventario
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[MM_V_INN_AjusteInventario]
AS
--SELECT CASE A.OperatingUnitId WHEN 6 THEN 'Bogota' END AS Sede, A.DocumentDate AS Fecha, A.Code AS Documento, CASE A.AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS Tipo, B.Code AS CodAlm, B.Name AS Almacen, C.Code AS CodCon, 
--             C.Name AS Concepto, P.Code AS CodProducto, P.Name AS Producto, DA.Quantity AS Cant, DA.UnitValue AS ValorUnitario, DA.Quantity * DA.UnitValue AS VlrTotal, P.ProductCost AS CostoProm, A.Description AS Detalle
--FROM   Inventory.InventoryAdjustment AS A INNER JOIN
--             Inventory.InventoryAdjustmentDetail AS DA ON DA.InventoryAdjustmentId = A.Id AND A.Status = 2 INNER JOIN
--             Inventory.Warehouse AS B ON A.WarehouseId = B.Id INNER JOIN
--             Inventory.AdjustmentConcept AS C ON A.AdjustmentConceptId = C.Id INNER JOIN
--             Inventory.InventoryProduct AS P ON DA.ProductId = P.Id
--WHERE (CONVERT(nvarchar(10), A.DocumentDate, 20) > CONVERT(nvarchar(10), GETDATE() - 180, 20))

SELECT 
    CASE ma.OperatingUnitId 
        WHEN '6' THEN 'Bogota' 
        WHEN '4' THEN 'Tunja' 
        WHEN '8' THEN 'Neiva'
        WHEN '9' THEN 'Florencia' 
        WHEN '10' THEN 'Cali' 
        WHEN '23' THEN 'Facatativa'  
    END AS Sede,
    ma.DocumentDate AS Fecha,
    ma.Code AS Documento,
    CASE ma.AdjustmentType 
        WHEN 1 THEN 'Entrada' 
        WHEN 2 THEN 'Salida' 
    END AS Tipo,
    al.Code AS CodAlm,
    al.Name AS Almacen,
    con.Code AS CodCon,
    con.Name AS Concepto,
    p.Code AS CodProducto,
    p.Name AS Producto,
    dma.Quantity AS Cant,
    dma.UnitValue AS ValorUnitario,
    (dma.Quantity * dma.UnitValue) AS VlrTotal,
    dma.UnitValue AS CostoProm, -- Usando UnitValue como en consulta original
    ma.Description AS Detalle
FROM Inventory.InventoryAdjustment AS ma 
    INNER JOIN Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId 
    INNER JOIN Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId 
    INNER JOIN Inventory.Warehouse AS al ON al.Id = ma.WarehouseId 
    INNER JOIN Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId 
    INNER JOIN Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id 
    INNER JOIN Inventory.InventoryProduct AS p ON p.Id = dma.ProductId
WHERE (ma.Status <> '3') 
    AND ma.AdjustmentConceptId IS NOT NULL

UNION ALL

SELECT 
    CASE ma.OperatingUnitId 
        WHEN '6' THEN 'Bogota' 
        WHEN '4' THEN 'Tunja' 
        WHEN '8' THEN 'Neiva'
        WHEN '9' THEN 'Florencia' 
        WHEN '10' THEN 'Cali' 
        WHEN '23' THEN 'Facatativa'  
    END AS Sede,
    ma.DocumentDate AS Fecha,
    ma.Code AS Documento,
    CASE ma.AdjustmentType 
        WHEN 1 THEN 'Entrada' 
        WHEN 2 THEN 'Salida' 
    END AS Tipo,
    al.Code AS CodAlm,
    al.Name AS Almacen,
    con.Code AS CodCon,
    con.Name AS Concepto,
    p.Code AS CodProducto,
    p.Name AS Producto,
    dma.Quantity AS Cant,
    dma.UnitValue AS ValorUnitario,
    (dma.Quantity * dma.UnitValue) AS VlrTotal,
    dma.UnitValue AS CostoProm, -- Usando UnitValue como en consulta original
    ma.Description AS Detalle
FROM Inventory.InventoryAdjustment AS ma 
    INNER JOIN Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId 
    INNER JOIN Inventory.Warehouse AS al ON al.Id = ma.WarehouseId 
    INNER JOIN Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId 
    INNER JOIN Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id 
    INNER JOIN Inventory.AdjustmentConcept AS con ON con.Id = dma.AdjustmentConceptId 
    INNER JOIN Inventory.InventoryProduct AS p ON p.Id = dma.ProductId
WHERE (ma.Status <> '3') 
    AND ma.AdjustmentConceptId IS NULL;


