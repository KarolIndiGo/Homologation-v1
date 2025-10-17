-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_INN_ProductosCalidad
-- Extracted by Fabric SQL Extractor SPN v3.9.0


--/****** Object:  View [dbo].[MM_INN_ProductosCalidad]    Script Date: 21/02/2022 8:36:39 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


create VIEW [ViewInternal].[MM_INN_ProductosCalidad]
AS
SELECT 
DISTINCT 
             AL.Name AS Almacen, CE.Code AS Comprobante, CE.DocumentDate AS Fecha_Recibido, P.Code AS Codigo, P.Name AS Descripción, F.Name AS Marca_Fabricante, UE.Name AS Presentacion_Comercial, BS.BatchCode AS lote, P.HealthRegistration AS Registro_Sanitario_Invima, 
             NR.Name AS Clasificacion_Riesto_Dispositivos_Medicos, BS.ExpirationDate AS Fecha_Vencimiento, CED.Quantity AS Cantidad_Recibida, PRO.Name AS Proveedor, CE.InvoiceNumber AS Factura, CED.SourceCode AS Orden_Compra, P.MinimumStock AS [Stock minimo], 
             P.MaximumStock AS [stock máximo], P.ProductCost AS [Costo promedio], P.FinalProductCost AS [Ultimo costo], P.SellingPrice AS [Precio Venta], CASE CE.Status WHEN 1 THEN 'registrado' WHEN 2 THEN 'confirmado' WHEN 3 THEN 'anulado' END AS ESTADO_COMPROBANTE, 
             inf.Quantity AS Cantidad_Almacen, sub.name as Subgrupo, 'No Aplica' as [VIDA UTIL]
FROM   Inventory.EntranceVoucher AS CE INNER JOIN
             Inventory.EntranceVoucherDetail AS CED ON CED.EntranceVoucherId = CE.Id INNER JOIN
             Inventory.EntranceVoucherDetailBatchSerial AS CEL ON CEL.EntranceVoucherDetailId = CED.Id LEFT OUTER JOIN
             Inventory.BatchSerial AS BS ON BS.Id = CEL.BatchSerialId INNER JOIN
             Inventory.InventoryProduct AS P ON P.Id = CED.ProductId LEFT OUTER JOIN
             Inventory.ATC AS M ON M.Id = P.ATCId INNER JOIN
             Common.Supplier AS PRO ON PRO.Id = CE.SupplierId INNER JOIN
             Inventory.PackagingUnit AS UE ON UE.Id = P.PackagingUnitId INNER JOIN
             Inventory.Manufacturer AS F ON F.Id = P.ManufacturerId LEFT OUTER JOIN
             Inventory.InventoryRiskLevel AS NR ON NR.Id = P.InventoryRiskLevelId  LEFT OUTER JOIN
             Inventory.PhysicalInventory AS inf ON inf.ProductId = P.Id AND inf.BatchSerialId = BS.Id AND inf.WarehouseId = CE.WarehouseId LEFT OUTER JOIN
             Inventory.Warehouse AS AL ON AL.Id = CE.WarehouseId LEFT OUTER JOIN
             Inventory.ProductSubGroup AS sub ON sub.Id = p.ProductSubGroupId
			-- where p.code='300102084'
GROUP BY AL.Name, CE.Code, CE.DocumentDate, P.Code, P.Name, F.Name, UE.Name, BS.BatchCode, P.HealthRegistration, NR.Name, BS.ExpirationDate, CED.Quantity, PRO.Name, CE.InvoiceNumber, CED.SourceCode, P.MinimumStock, P.MaximumStock, P.ProductCost, P.FinalProductCost, 
             P.SellingPrice, CE.Status, inf.Quantity, sub.name 
