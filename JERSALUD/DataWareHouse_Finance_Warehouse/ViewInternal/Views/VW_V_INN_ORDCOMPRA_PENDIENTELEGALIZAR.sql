-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_ORDCOMPRA_PENDIENTELEGALIZAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_ORDCOMPRA_PENDIENTELEGALIZAR AS
SELECT AL.Name AS Almacen, 
            AL.Code AS CodigoAlmacen, 
            uo.UnitName AS [Unidad Operativa], 
            cr.Code AS OrdenCompra, 
            cr.DocumentDate AS Fecha, 
            PR.Code AS CodigoProveedor, 
            PR.Name AS Proveedor, 
            cr.Description AS Descripcion_Orden_Bionexo, 
            CAST(cr.TotalValue AS DECIMAL(18,2)) AS VlrOrden,
            CASE cr.Status
                WHEN '1'
                THEN 'registrado'
                WHEN '2'
                THEN 'confirmado'
                WHEN '3'
                THEN 'anulado'
            END AS Estado_Orden, 
            pd.Code AS CodProducto, 
            pd.Name AS Producto, 
            DR.Quantity AS Cantidad, 
            DR.OutstandingQuantity AS CanPenCruzar, 
            CAST(DR.Value AS DECIMAL(18,2)) AS VlrUnitario, 
            CAST(DR.TotalValue AS DECIMAL(18,2)) AS Total, 
            CAST(pd.ProductCost AS DECIMAL(18,2)) AS CostoPromedio, 
            p.Fullname AS Usuario
     FROM INDIGO031.Inventory.PurchaseOrder AS cr 
          INNER JOIN INDIGO031.Common.OperatingUnit AS uo  ON uo.Id = cr.OperatingUnitId
          INNER JOIN INDIGO031.Common.Supplier AS PR  ON PR.Id = cr.SupplierId
          INNER JOIN INDIGO031.Inventory.Warehouse AS AL  ON AL.Id = cr.WarehouseId
          INNER JOIN INDIGO031.Inventory.PurchaseOrderDetail AS DR  ON DR.PurchaseOrderId = cr.Id
          INNER JOIN INDIGO031.Inventory.InventoryProduct AS pd  ON pd.Id = DR.ProductId
          INNER JOIN INDIGO031.Security.UserInt AS U ON U.UserCode = cr.CreationUser
          INNER JOIN INDIGO031.Security.PersonInt AS p ON p.Id = U.IdPerson
     WHERE (cr.Status <> '3')
          AND (DR.OutstandingQuantity > '0')
          AND cr.DocumentDate > '20200801';