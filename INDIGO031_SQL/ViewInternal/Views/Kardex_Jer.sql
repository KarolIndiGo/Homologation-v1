-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Kardex_Jer
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Kardex_Jer]
AS
     SELECT PRO.Code AS [Codigo del Producto], 
            PRO.Name AS Producto, 
            ALM.Name AS Almacen, 
            KAR.Quantity AS Existencias, 
            PRO.HealthRegistration AS [Registro Invima], 
            BSE.ExpirationDate AS [Fecha de Vencimiento], 
            BSE.BatchCode AS Lote, 
            PRO.MinimumStock AS Minimo, 
            PRO.MaximumStock AS Maximo
     FROM Inventory.InventoryProduct AS PRO
          INNER JOIN Inventory.Kardex AS KAR ON KAR.ProductId = PRO.Id
          INNER JOIN Inventory.Warehouse AS ALM ON KAR.WarehouseId = ALM.Id
          LEFT OUTER JOIN Inventory.BatchSerial AS BSE ON KAR.BatchSerialId = BSE.Id;
