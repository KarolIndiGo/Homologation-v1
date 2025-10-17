-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_INN_RemisionesXLegalizar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[MM_INN_RemisionesXLegalizar]
AS
SELECT  CASE WHEN AL.Name LIKE 'CAS%' THEN 'Bogota' WHEN AL.Name LIKE 'TUN%' THEN 'Tunja' END AS Sede, cr.Code AS [Còd Remisión], cr.RemissionDate AS [Fecha Remisión], PR.Code AS [Còdigo Proveedor], PR.Name AS Proveedor, AL.Code AS [Còdigo Almacèn], 
		AL.Name AS Almacèn, cr.RemissionNumber AS [Nùmero Remisiòn], cr.Description AS Descripciòn, cr.Value AS [Vr Remisiòn], cr.IvaValue AS Iva, cr.TotalValue AS [Vr Total], 
		CASE cr.Status WHEN '1' THEN 'registrada' WHEN '2' THEN 'confirmada' WHEN '3' THEN 'anulada' END AS Estado_Remisiòn, CASE cr.ProductStatus WHEN '1' THEN 'Sin_Movmientos' WHEN '2' THEN 'Parcial' WHEN '3' THEN 'Total' END AS estado_productos, 
		pd.Code AS [Còd Producto], pd.Name AS Producto, DR.Quantity AS Cantidad, DR.TotalValue AS Total, pd.ProductCost AS [Costo Promedio], Pen.OutstandingQuantity AS Pendiente_Cruzar
FROM    Inventory.RemissionEntrance AS cr INNER JOIN
		Common.OperatingUnit AS uo ON uo.Id = cr.OperatingUnitId INNER JOIN
		Common.Supplier AS PR ON PR.Id = cr.SupplierId INNER JOIN
		Inventory.Warehouse AS AL ON AL.Id = cr.WarehouseId INNER JOIN
		Inventory.RemissionEntranceDetail AS DR ON DR.RemissionEntranceId = cr.Id INNER JOIN
		Inventory.InventoryProduct AS pd ON pd.Id = DR.ProductId INNER JOIN
		Inventory.RemissionEntranceDetailBatchSerial AS Pen ON Pen.RemissionEntranceDetailId = DR.Id
WHERE (Pen.OutstandingQuantity > '0') AND (cr.Status <> '3') AND (cr.RemissionDate >= '20180101')
