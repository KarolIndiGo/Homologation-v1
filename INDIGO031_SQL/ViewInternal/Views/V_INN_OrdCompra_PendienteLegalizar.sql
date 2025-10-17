-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_OrdCompra_PendienteLegalizar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_OrdCompra_PendienteLegalizar]
AS
     SELECT AL.Name AS Almacen, 
            AL.Code AS CodigoAlmacen, 
            uo.UnitName AS [Unidad Operativa], 
            cr.Code AS OrdenCompra, 
            cr.DocumentDate AS Fecha, 
            PR.Code AS CodigoProveedor, 
            PR.Name AS Proveedor, 
            cr.Description AS Descripcion_Orden_Bionexo, 
            CONVERT(MONEY, cr.TotalValue, 101) AS VlrOrden,
            CASE cr.STATUS
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
            CONVERT(MONEY, dr.value, 101) AS VlrUnitario, 
            CONVERT(MONEY, DR.TotalValue, 101) AS Total, 
            CONVERT(MONEY, pd.ProductCost, 101) AS CostoPromedio, 
            p.Fullname AS Usuario
     FROM Inventory.PurchaseOrder AS cr 
          INNER JOIN Common.OperatingUnit AS uo  ON uo.Id = cr.OperatingUnitId
          INNER JOIN Common.Supplier AS PR  ON PR.Id = cr.SupplierId
          INNER JOIN Inventory.Warehouse AS AL  ON AL.Id = cr.WarehouseId
          INNER JOIN Inventory.PurchaseOrderDetail AS DR  ON DR.PurchaseOrderId = cr.Id
          INNER JOIN Inventory.InventoryProduct AS pd  ON pd.Id = DR.ProductId
          INNER JOIN [Security].[User] AS U ON U.UserCode = cr.CreationUser
          INNER JOIN [Security].Person AS p ON p.Id = U.IdPerson
     WHERE(cr.STATUS <> '3')
          AND (DR.OutstandingQuantity > '0')
          AND cr.DocumentDate > '20200801';
