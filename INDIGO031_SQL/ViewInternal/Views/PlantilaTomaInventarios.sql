-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: PlantilaTomaInventarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[PlantilaTomaInventarios]
AS
     SELECT al.Code AS CodAlmacen, 
            al.Name AS Almacen, 
            pr.Id, 
            pr.Code AS CodigoProducto, 
            pr.Name AS Producto, 
            pr.CodeCUM AS CUM,
            CASE pr.STATUS
                WHEN 1
                THEN 'Activo'
                WHEN 0
                THEN 'Inactivo'
            END AS Estado, 
            pr.ProductCost AS CostoPromedio,
            CASE pr.ProductTypeId
                WHEN '1'
                THEN 'Medicamento'
                WHEN '2'
                THEN 'DispositivoMedico'
                WHEN '3'
                THEN 'Elemento Consumo'
                WHEN '4'
                THEN 'Nutricion Especial'
                WHEN '5'
                THEN 'Equipo Biomedico'
                WHEN '6'
                THEN 'Insumo Laboratorio'
                WHEN '7'
                THEN 'Med VitalNO Disponible'
            END AS TipoProducto, 
            sg.Code AS CodSuubGrupo, 
            sg.Name AS SubGrupo, 
            inf.Quantity AS Cantidad, 
            inf.BatchSerialId, 
            bs.ProductId AS IdProductoLote, 
            bs.BatchCode AS Lote, 
            bs.ExpirationDate AS FechaVencimiento, 
            '' AS Conteo1, 
            '' AS Conteo2, 
            '' AS Conteo3
     FROM Inventory.InventoryProduct AS PR
          INNER JOIN Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id
          INNER JOIN Inventory.Warehouse AS al ON al.Id = inf.WarehouseId
          INNER JOIN Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
          LEFT JOIN Inventory.BatchSerial AS bs ON bs.Id = inf.BatchSerialId;
--WHERE	al.Code='VI01'
--order by inf.Quantity desc
--SELECT * FROM Inventory.BatchSerial 
