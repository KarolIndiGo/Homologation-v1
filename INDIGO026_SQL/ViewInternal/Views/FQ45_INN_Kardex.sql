-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_INN_Kardex
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_INN_Kardex]
AS
SELECT KAR.Id AS Id,
       KAR.DocumentDate AS Fecha,
       PRO.Code AS [Codigo del Producto],
       PRO.Name AS Producto,
       ALM.Id AS [id Almacen] ,
       ALM.Code + ' ' + ALM.Name AS Almacen,
       KAR.EntityName AS [Nombre del Documento],
       KAR.EntityCode AS Documento,
       CASE KAR.MovementType WHEN 1 THEN KAR.Quantity END AS Entrada,
       CASE KAR.MovementType WHEN 2 THEN KAR.Quantity END AS Salida,
       KAR.Value AS Valor,
       KAR.PreviousCost AS [Costo Anterior],
       KAR.AverageCost AS [Costo Promedio],
       KAR.Quantity AS Existencias,
       KAR.Quantity * KAR.Value AS [Costo Total]
FROM Inventory.Kardex KAR
     INNER JOIN Inventory.InventoryProduct PRO
        ON KAR.ProductId = PRO.Id
     INNER JOIN Inventory.Warehouse AS ALM ON KAR.WarehouseId = ALM.Id
	 where kar.DocumentDate>='01-01-2022'