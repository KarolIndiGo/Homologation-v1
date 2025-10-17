-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: OrdenesTrasladosGenerales
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[OrdenesTrasladosGenerales]
AS
     SELECT T.Code AS OrdenTraslado, 
            T.DocumentDate AS FechaTraslado,
            CASE T.STATUS
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
            CASE P.STATUS
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
         FROM Inventory.Warehouse AS AL
         WHERE AL.Id = T.SourceWarehouseId
     ) AS AlmacenOrigen, 
            T.TargetWarehouseId, 
     (
         SELECT DISTINCT 
                AL.Name
         FROM Inventory.Warehouse AS AL
         WHERE AL.Id = T.TargetWarehouseId
     ) AS AlmacenDestino, 
            MONTH(T.DocumentDate) AS MesTraslado, 
            YEAR(T.DocumentDate) AS AñoTraslado
     FROM Inventory.TransferOrder AS T
          INNER JOIN Inventory.TransferOrderDetail AS TD  ON TD.TransferOrderid = T.Id
          INNER JOIN Inventory.InventoryProduct AS P  ON P.Id = Td.ProductId
          INNER JOIN Inventory.ProductType AS TP ON TP.Code = P.ProductTypeId
          LEFT JOIN Inventory.ATC AS M  ON P.ATCId = M.Id
          LEFT JOIN Inventory.PharmacologicalGroup AS GF  ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN inventory.InventorySupplie AS ins ON ins.Id = P.SupplieId
          LEFT JOIN Inventory.ProductGroup AS G ON G.Id = P.ProductGroupId
          INNER JOIN Inventory.PackagingUnit AS UE  ON UE.Id = P.PackagingUnitId
          INNER JOIN Inventory.Manufacturer AS F  ON F.Id = P.ManufacturerId
          INNER JOIN Inventory.InventoryRiskLevel AS NR  ON NR.Id = P.InventoryRiskLevelId
     WHERE T.DocumentDate >= '2020-08-01';
