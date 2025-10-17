-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_DocumentosSinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_DocumentosSinConfirmar]
AS
     --Consultamos las ordenes de compra que esten sin confirmar
     SELECT AL.NAME AS Sede, 
            D.Code AS Documento, 
            'Orden de Compra' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.PurchaseOrder D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las remisiones de entrada que esten sin confirmar
     SELECT AL.NAME AS Sede, 
            D.Code AS Documento, 
            'Remisión de Entrada' AS NameProcess, 
            RemissionDate AS Fecha
     FROM Inventory.RemissionEntrance D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos los ajustes de inventario que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Ajustes de Inventario' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.InventoryAdjustment D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las solicitudes que esten sin confirmar
     SELECT UO.UnitName AS Sede, 
            D.Code AS Documento, 
            'Solicitud' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.InventoryRequest D
          JOIN Common.OperatingUnit UO ON D.OperatingUnitId = UO.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las dispensaciones farmaceuticas que esten sin confirmar
     SELECT UO.UnitName AS Sede, 
            D.Code AS Documento, 
            'Dispensación Farmaceutica' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.PharmaceuticalDispensing D
          JOIN Common.OperatingUnit UO ON D.OperatingUnitId = UO.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las remisiones de salida que esten sin confirmar
     SELECT AL.NAME AS Sede, 
            D.Code AS Documento, 
            'Remisión de Salida' AS NameProcess, 
            RemissionDate AS Fecha
     FROM Inventory.RemissionOutput D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las devoluciones de remision que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Devolución de Remisiones' AS NameProcess, 
            RemissionDate AS Fecha
     FROM Inventory.RemissionDevolution D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las devoluciones de orden de traslado que esten sin confirmar
     SELECT UO.UnitName AS Sede, 
            D.Code AS Documento, 
            'Devolución de Orden de Traslado' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.TransferOrderDevolution D
          JOIN Common.OperatingUnit UO ON D.OperatingUnitId = UO.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos los Comprobantes de entrada que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Comprobantede Entrada' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.EntranceVoucher D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las devoluciones de compra que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Devolución de Compra' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.EntranceVoucherDevolution D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos los prestamos de mercancia que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Prestamo de Mercancia' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.LoanMerchandise D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las devoluciones de dispensacion farmaceutica que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Devolucion de Dispensación Farmaceutica' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.PharmaceuticalDispensingDevolution D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las devoluciones de prestamo que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Devolucion de Préstamo' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.LoanMerchandiseDevolution D
          JOIN Inventory.Warehouse al ON D.WarehouseId = al.Id
     WHERE d.STATUS = 1
     UNION ALL
     --Consultamos las Ordenes de Traslado que esten sin confirmar
     SELECT AL.Name AS Sede, 
            D.Code AS Documento, 
            'Orden de Traslado' AS NameProcess, 
            DocumentDate AS Fecha
     FROM Inventory.TransferOrder D
          JOIN Inventory.Warehouse al ON D.SourceWarehouseId = al.Id
     WHERE d.STATUS = 1;
