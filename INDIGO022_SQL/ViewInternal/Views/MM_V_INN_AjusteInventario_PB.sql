-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_V_INN_AjusteInventario_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create VIEW [ViewInternal].[MM_V_INN_AjusteInventario_PB]
AS
SELECT CASE A.OperatingUnitId WHEN 6 THEN 'Bogota' END AS Sede, A.DocumentDate AS Fecha, A.Code AS Documento, CASE A.AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS Tipo, B.Code AS CodAlm, B.Name AS Almacen, C.Code AS CodCon, 
             C.Name AS Concepto, P.Code AS CodProducto, P.Name AS Producto, DA.Quantity AS Cant, DA.UnitValue AS ValorUnitario, DA.Quantity * DA.UnitValue AS VlrTotal, P.ProductCost AS CostoProm, A.Description AS Detalle
FROM   Inventory.InventoryAdjustment AS A INNER JOIN
             Inventory.InventoryAdjustmentDetail AS DA ON DA.InventoryAdjustmentId = A.Id AND A.Status = 2 INNER JOIN
             Inventory.Warehouse AS B ON A.WarehouseId = B.Id INNER JOIN
             Inventory.AdjustmentConcept AS C ON A.AdjustmentConceptId = C.Id INNER JOIN
             Inventory.InventoryProduct AS P ON DA.ProductId = P.Id 
WHERE YEAR(A.DocumentDate)>=2020 
