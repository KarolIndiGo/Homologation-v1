-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_ListaPrecios
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[FQ45_V_INN_ListaPrecios]
AS
SELECT        P.Id, P.Code AS Cod, P.Name AS Producto, ATC.Code AS ATC, P.CodeAlternativeTwo AS CodigoAlterno, SG.Name AS Subgrupo, CASE P.ProductWithPriceControl WHEN 0 THEN '' WHEN 1 THEN 'Regulado' END AS Precio, 
                         P.ProductCost AS Costo, P.FinalProductCost AS UltimoCosto, CASE P.ProductControl WHEN 0 THEN '' WHEN 1 THEN 'SI' END AS ProdControl, CASE P.POSProduct WHEN 0 THEN 'NO POS' WHEN 1 THEN 'POS' END AS POS, 
                         E.Code AS Tarifa, T.SalesValue AS Valor, CONVERT(numeric, ROUND((T.SalesValue - P.ProductCost) / P.ProductCost * 100, 0), 100) AS [%Var]
FROM            Inventory.InventoryProduct AS P  INNER JOIN
                         Inventory.ProductRateDetail AS T  ON T.ProductId = P.Id AND P.Status = 1 INNER JOIN
                             (SELECT        MAX(Id) AS M
                               FROM            Inventory.ProductRateDetail
                               GROUP BY ProductRateId, ProductId) AS T1 ON T.Id = T1.M INNER JOIN
                         Inventory.ProductRate AS E  ON T.ProductRateId = E.Id LEFT OUTER JOIN
                         Inventory.ProductSubGroup AS SG ON P.ProductSubGroupId = SG.Id LEFT OUTER JOIN
                         Inventory.ATC AS Med ON P.ATCId = Med.Id LEFT OUTER JOIN
                         Inventory.ATCEntity AS ATC ON Med.ATCEntityId = ATC.Id
WHERE        (T.EndDate > GETDATE()) AND (E.Status = 1)
