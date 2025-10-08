-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_LISTAPRECIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_LISTAPRECIOS AS

SELECT 
    P.Id, 
    P.Code AS Cod, 
    P.Name AS Producto, 
    ATC.Code AS ATC, 
    P.CodeAlternativeTwo AS CodigoAlterno, 
    SG.Name AS Subgrupo,
    CASE P.ProductWithPriceControl
        WHEN 0 THEN ''
        WHEN 1 THEN 'Regulado'
    END AS Precio, 
    P.ProductCost AS Costo, 
    P.FinalProductCost AS UltimoCosto,
    CASE P.ProductControl
        WHEN 0 THEN ''
        WHEN 1 THEN 'SI'
    END AS ProdControl,
    CASE P.POSProduct
        WHEN 0 THEN 'NO POS'
        WHEN 1 THEN 'POS'
    END AS POS, 
    E.Code AS Tarifa,
    E.Name AS Descripción,
    T.SalesValue AS Valor, 
    CASE 
        WHEN P.ProductCost = 0 THEN 0 
        ELSE CONVERT(NUMERIC, ROUND((T.SalesValue - P.ProductCost) / P.ProductCost * 100, 0), 100) 
    END AS [%Var],
    T.InitialDate AS [Fecha Inicial], 
    T.EndDate AS [Fecha Final]
FROM INDIGO031.Inventory.InventoryProduct AS P
    INNER JOIN INDIGO031.Inventory.ProductRateDetail AS T  
        ON T.ProductId = P.Id AND P.Status = 1
    INNER JOIN (
        SELECT MAX(Id) AS M
        FROM INDIGO031.Inventory.ProductRateDetail
        GROUP BY ProductRateId, ProductId
    ) AS T1 ON T.Id = T1.M
    INNER JOIN INDIGO031.Inventory.ProductRate AS E  
        ON T.ProductRateId = E.Id
    LEFT OUTER JOIN INDIGO031.Inventory.ProductSubGroup AS SG 
        ON P.ProductSubGroupId = SG.Id
    LEFT OUTER JOIN INDIGO031.Inventory.ATC AS Med 
        ON P.ATCId = Med.Id
    LEFT OUTER JOIN INDIGO031.Inventory.ATCEntity AS ATC 
        ON Med.ATCEntityId = ATC.Id
WHERE (T.EndDate > GETDATE())
    AND (E.Status = 1);