-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_DOCUMENTOSSINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_DOCUMENTOSSINCONFIRMAR AS
 
 --Consultamos las ordenes de compra que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Orden de Compra' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.PurchaseOrder D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las remisiones de entrada que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Remisión de Entrada' AS NameProcess, 
       RemissionDate AS Fecha
FROM INDIGO031.Inventory.RemissionEntrance D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos los ajustes de inventario que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Ajustes de Inventario' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.InventoryAdjustment D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las solicitudes que esten sin confirmar
SELECT UO.UnitName AS Sede, 
       D.Code AS Documento, 
       'Solicitud' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.InventoryRequest D
     JOIN INDIGO031.Common.OperatingUnit UO ON D.OperatingUnitId = UO.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las dispensaciones farmaceuticas que esten sin confirmar
SELECT UO.UnitName AS Sede, 
       D.Code AS Documento, 
       'Dispensación Farmaceutica' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.PharmaceuticalDispensing D
     JOIN INDIGO031.Common.OperatingUnit UO ON D.OperatingUnitId = UO.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las remisiones de salida que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Remisión de Salida' AS NameProcess, 
       RemissionDate AS Fecha
FROM INDIGO031.Inventory.RemissionOutput D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las devoluciones de remision que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Devolución de Remisiones' AS NameProcess, 
       RemissionDate AS Fecha
FROM INDIGO031.Inventory.RemissionDevolution D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las devoluciones de orden de traslado que esten sin confirmar
SELECT UO.UnitName AS Sede, 
       D.Code AS Documento, 
       'Devolución de Orden de Traslado' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.TransferOrderDevolution D
     JOIN INDIGO031.Common.OperatingUnit UO ON D.OperatingUnitId = UO.Id
WHERE D.Status = 1
UNION ALL
--Consultamos los Comprobantes de entrada que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Comprobantede Entrada' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.EntranceVoucher D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las devoluciones de compra que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Devolución de Compra' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.EntranceVoucherDevolution D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos los prestamos de mercancia que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Prestamo de Mercancia' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.LoanMerchandise D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las devoluciones de dispensacion farmaceutica que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Devolucion de Dispensación Farmaceutica' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.PharmaceuticalDispensingDevolution D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las devoluciones de prestamo que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Devolucion de Préstamo' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.LoanMerchandiseDevolution D
     JOIN INDIGO031.Inventory.Warehouse al ON D.WarehouseId = al.Id
WHERE D.Status = 1
UNION ALL
--Consultamos las Ordenes de Traslado que esten sin confirmar
SELECT al.Name AS Sede, 
       D.Code AS Documento, 
       'Orden de Traslado' AS NameProcess, 
       DocumentDate AS Fecha
FROM INDIGO031.Inventory.TransferOrder D
     JOIN INDIGO031.Inventory.Warehouse al ON D.SourceWarehouseId = al.Id
WHERE D.Status = 1;