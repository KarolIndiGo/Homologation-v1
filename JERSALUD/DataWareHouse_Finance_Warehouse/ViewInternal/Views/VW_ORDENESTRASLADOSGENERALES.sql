-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_ORDENESTRASLADOSGENERALES
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_ORDENESTRASLADOSGENERALES]
AS
     SELECT T.Code AS OrdenTraslado, 
            T.DocumentDate AS FechaTraslado,
            CASE T.Status
                WHEN 1
                THEN 'registrado'
                WHEN 2
                THEN 'confirmado'
                WHEN 3
                THEN 'anulado'
            END AS EstadoTraslado, 
            ISNULL(M.Code, ins.Code) AS Cod_Medicamento_Insumo, 
            ISNULL(M.Name, ins.SupplieName) AS Medicamento_Insumo, 
            TP.Name AS TipoProducto,
            CASE P.Status
                WHEN '1'
                THEN 'Activo'
                WHEN '0'
                THEN 'Inactivo'
            END AS Estado, 
            P.Code AS Codigo, 
            P.Name AS Articulo_Descripcion, 
            P.Presentation AS Forma_Farmaceutica, 
            M.Concentration AS Concentracion, 
            UE.Name AS Presentacion_Comercial, 
            TD.Quantity AS CantidadTraslado, 
            F.Name AS Marca_Fabricante, 
            NR.Name AS Clasificacion_Riesto_Dispositivos_Medicos, 
            P.ProductCost AS CostoPromedioActual,
            CASE P.ProductControl
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Si'
            END AS [ProdControl],
            CASE ISNULL(M.HighCost, 0)
                WHEN 0
                THEN 'NO'
                WHEN 1
                THEN 'SI'
            END AS AltoCosto, 
            G.Name AS Grupo, 
            T.SourceWarehouseId, 
     (
         SELECT DISTINCT 
                AL.Name
         FROM INDIGO031.Inventory.Warehouse AS AL
         WHERE AL.Id = T.SourceWarehouseId
     ) AS AlmacenOrigen, 
            T.TargetWarehouseId, 
     (
         SELECT DISTINCT 
                AL.Name
         FROM INDIGO031.Inventory.Warehouse AS AL
         WHERE AL.Id = T.TargetWarehouseId
     ) AS AlmacenDestino, 
            MONTH(T.DocumentDate) AS MesTraslado, 
            YEAR(T.DocumentDate) AS AñoTraslado
     FROM INDIGO031.Inventory.TransferOrder AS T
          INNER JOIN INDIGO031.Inventory.TransferOrderDetail AS TD  ON TD.TransferOrderId = T.Id
          INNER JOIN INDIGO031.Inventory.InventoryProduct AS P  ON P.Id = TD.ProductId
          INNER JOIN INDIGO031.Inventory.ProductType AS TP ON TP.Code = P.ProductTypeId
          LEFT JOIN INDIGO031.Inventory.ATC AS M  ON P.ATCId = M.Id
          LEFT JOIN INDIGO031.Inventory.PharmacologicalGroup AS GF  ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN INDIGO031.Inventory.InventorySupplie AS ins ON ins.Id = P.SupplieId
          LEFT JOIN INDIGO031.Inventory.ProductGroup AS G ON G.Id = P.ProductGroupId
          INNER JOIN INDIGO031.Inventory.PackagingUnit AS UE  ON UE.Id = P.PackagingUnitId
          INNER JOIN INDIGO031.Inventory.Manufacturer AS F  ON F.Id = P.ManufacturerId
          INNER JOIN INDIGO031.Inventory.InventoryRiskLevel AS NR  ON NR.Id = P.InventoryRiskLevelId
     WHERE T.DocumentDate >= '2020-08-01';
