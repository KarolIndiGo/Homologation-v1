-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_KARDEX_JER
-- Extracted by Fabric SQL Extractor SPN v3.9.0


--SELECT COUNT(*) FROM [ViewInternal].[VW_KARDEX_JER]
CREATE VIEW [ViewInternal].[VW_KARDEX_JER] AS
     SELECT PRO.Code AS [Codigo del Producto], 
            PRO.Name AS Producto, 
            ALM.Name AS Almacen, 
            KAR.Quantity AS Existencias, 
            PRO.HealthRegistration AS [Registro Invima], 
            BSE.ExpirationDate AS [Fecha de Vencimiento], 
            BSE.BatchCode AS Lote, 
            PRO.MinimumStock AS Minimo, 
            PRO.MaximumStock AS Maximo
     FROM INDIGO031.Inventory.InventoryProduct AS PRO
          INNER JOIN INDIGO031.Inventory.Kardex AS KAR ON KAR.ProductId = PRO.Id
          INNER JOIN INDIGO031.Inventory.Warehouse AS ALM ON KAR.WarehouseId = ALM.Id
          LEFT OUTER JOIN INDIGO031.Inventory.BatchSerial AS BSE ON KAR.BatchSerialId = BSE.Id;
