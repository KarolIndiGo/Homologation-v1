-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Comprobantes_Entradas_Generales
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[Comprobantes_Entradas_Generales]
AS
SELECT CE.Code AS Comprobante,CE.DocumentDate AS Fecha_Recibido, P.Code AS Codigo, P.Name AS Articulo_Descripcion,
P.Presentation AS Forma_Farmaceutica,
M.Concentration AS Concentracion,
BS.BatchCode AS lote,
BS.ExpirationDate AS Fecha_Vencimiento,
UE.Name AS Presentacion_Comercial,
P.HealthRegistration AS Registro_Sanitario_Invima,
CED.Quantity AS Cantidad_Recibido,
PRO.Name AS Proveedor,
F.Name AS Marca_Fabricante,
NR.Name AS Clasificacion_Riesto_Dispositivos_Medicos,
CE.InvoiceNumber AS Factura,
CED.SourceCode AS Orden_Compra,
CASE CE.Status WHEN 1 THEN 'registrado' WHEN 2 THEN 'confirmado' WHEN 3 THEN 'anulado' END AS ESTADO_COMPROBANTE,
AL.Name AS Almacen
FROM Inventory.EntranceVoucher AS CE
INNER JOIN Inventory.EntranceVoucherDetail AS CED  ON CED.EntranceVoucherId=CE.Id
INNER JOIN Inventory.EntranceVoucherDetailBatchSerial CEL  ON CEL.EntranceVoucherDetailId=CED.Id
LEFT JOIN Inventory.BatchSerial AS BS  ON BS.Id=CEL.BatchSerialId
INNER JOIN Inventory.InventoryProduct AS P  ON P.Id=CED.ProductId
LEFT JOIN Inventory.ATC AS M  ON M.Id=P.ATCId
INNER JOIN Common.Supplier AS PRO  ON PRO.Id=CE.SupplierId
INNER JOIN Inventory.PackagingUnit AS UE  ON UE.Id=P.PackagingUnitId
INNER JOIN Inventory.Manufacturer AS F  ON F.Id=P.ManufacturerId
INNER JOIN Inventory.InventoryRiskLevel AS NR  ON NR.Id=P.InventoryRiskLevelId
INNER JOIN Inventory.Warehouse AS AL ON AL.Id=CE.WarehouseId
