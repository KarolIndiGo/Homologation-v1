-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Ordenes_de_Compra_Jersalud
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_Ordenes_de_Compra_Jersalud] AS

SELECT        uo.UnitName AS Sede, cr.Code AS OrdenCompra, cr.DocumentDate AS Fecha, PR.Code AS CodigoProveedor, PR.Name AS Proveedor, AL.Code AS CodigoAlmacen, AL.Name AS Almacen, 
                         cr.Description AS Descripcion_Orden_Bionexo, cr.Value AS Valor, cr.TotalValue AS VrTotal, CASE cr.Status WHEN '1' THEN 'registrado' WHEN '2' THEN 'confirmado' WHEN '3' THEN 'anulado' END AS Estado_Orden, 
                         pd.Code AS CodProducto, pd.Name AS Producto, DR.Quantity AS Cantidad, DR.OutstandingQuantity AS CanPenCruzar, DR.TotalValue AS Total, pd.ProductCost AS CostoPromedio, p.Fullname AS Usuario
FROM            Inventory.PurchaseOrder AS cr  INNER JOIN
                         Common.OperatingUnit AS uo  ON uo.Id = cr.OperatingUnitId INNER JOIN
                         Common.Supplier AS PR  ON PR.Id = cr.SupplierId INNER JOIN
                         Inventory.Warehouse AS AL  ON AL.Id = cr.WarehouseId INNER JOIN
                         Inventory.PurchaseOrderDetail AS DR  ON DR.PurchaseOrderId = cr.Id INNER JOIN
                         Inventory.InventoryProduct AS pd  ON pd.Id = DR.ProductId INNER JOIN
                         Security.[User] AS U  ON U.UserCode = cr.CreationUser INNER JOIN
                         Security.Person AS p  ON p.Id = U.IdPerson
WHERE        (cr.Status <> 3) and AL.Code in ('0037','0071','0072')


