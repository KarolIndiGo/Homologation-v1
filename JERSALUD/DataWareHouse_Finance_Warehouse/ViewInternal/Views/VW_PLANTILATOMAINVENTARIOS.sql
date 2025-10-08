-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_PLANTILATOMAINVENTARIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_PLANTILATOMAINVENTARIOS]
AS
     SELECT al.Code AS CodAlmacen, 
            al.Name AS Almacen, 
            pr.Id, 
            pr.Code AS CodigoProducto, 
            pr.Name AS Producto, 
            pr.CodeCUM AS CUM,
            CASE pr.Status
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
     FROM INDIGO031.Inventory.InventoryProduct AS pr
          INNER JOIN INDIGO031.Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id
          INNER JOIN INDIGO031.Inventory.Warehouse AS al ON al.Id = inf.WarehouseId
          INNER JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
          LEFT JOIN INDIGO031.Inventory.BatchSerial AS bs ON bs.Id = inf.BatchSerialId;
--WHERE	al.Code='VI01'
--order by inf.Quantity desc
--SELECT * FROM Inventory.BatchSerial 
