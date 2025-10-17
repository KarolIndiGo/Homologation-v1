-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Orden_Compra_2021_New
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_INN_Orden_Compra_2021_New]
AS
SELECT uo.UnitName
          AS Sede,
       cr.Code
          AS OrdenCompra,
       cr.DocumentDate
          AS Fecha,
       PR.Code
          AS CodigoProveedor,
       PR.Name
          AS Proveedor,
       AL.Code
          AS CodigoAlmacen,
       AL.Name
          AS Almacen,
       cr.Description
          AS Descripcion_Orden_Bionexo,
       cr.Value
          AS Valor,
       cr.TotalValue
          AS VrTotal,
       CASE cr.Status
          WHEN '1' THEN 'registrado'
          WHEN '2' THEN 'confirmado'
          WHEN '3' THEN 'anulado'
       END
          AS Estado_Orden,
       pd.Code
          AS CodProducto,
       pd.Name
          AS Producto,
       DR.Quantity
          AS Cantidad,
       DR.OutstandingQuantity
          AS CanPenCruzar,
       DR.TotalValue
          AS Total,
       pd.ProductCost
          AS CostoPromedio,
       (SELECT Inventory.EntranceVoucher.Code
        FROM Inventory.EntranceVoucher
        WHERE Inventory.EntranceVoucher.Id = evd.EntranceVoucherId)
          AS [Comprobante entrada],
       (SELECT Inventory.EntranceVoucher.DocumentDate
        FROM Inventory.EntranceVoucher
        WHERE Inventory.EntranceVoucher.Id = evd.EntranceVoucherId)
          AS [Fecha Comprobante entrada],
       (SELECT Inventory.EntranceVoucher.[Description]
        FROM Inventory.EntranceVoucher
        WHERE Inventory.EntranceVoucher.Id = evd.EntranceVoucherId)
          AS [Observacion Comprobante entrada],
       p.Fullname
          AS Usuario
FROM Inventory.PurchaseOrder AS cr 
     INNER JOIN Common.OperatingUnit AS uo 
        ON uo.Id = cr.OperatingUnitId
     INNER JOIN Common.Supplier AS PR 
        ON PR.Id = cr.SupplierId
     INNER JOIN Inventory.Warehouse AS AL 
        ON AL.Id = cr.WarehouseId
     INNER JOIN Inventory.PurchaseOrderDetail AS DR 
        ON DR.PurchaseOrderId = cr.Id
     INNER JOIN Inventory.InventoryProduct AS pd 
        ON pd.Id = DR.ProductId
     LEFT JOIN Inventory.EntranceVoucherDetail evd
        ON evd.SourceCode = cr.Code AND evd.EntranceSource = 2
     INNER JOIN Security.[User] AS U 
        ON U.UserCode = cr.CreationUser
     INNER JOIN Security.Person AS p 
        ON p.Id = U.IdPerson
WHERE (cr.Status <> 3) AND cr.DocumentDate > '31/12/2020 23:59:59'
