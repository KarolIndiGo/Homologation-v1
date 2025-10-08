-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_COMPROBANTES_ENTRADAS_GENERALES
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_COMPROBANTES_ENTRADAS_GENERALES
AS
SELECT 
    CE.Code AS Comprobante, 
    CE.DocumentDate AS Fecha_Recibido, 
    P.Code AS Codigo, 
    P.Name AS Articulo_Descripcion, 
    P.Presentation AS Forma_Farmaceutica, 
    M.Concentration AS Concentracion, 
    BS.BatchCode AS lote, 
    BS.ExpirationDate AS Fecha_Vencimiento, 
    UE.Name AS Presentacion_Comercial, 
    P.HealthRegistration AS Registro_Sanitario_Invima, 
    CEL.Quantity AS Cantidad_Recibido, 
    PRO.Name AS Proveedor, 
    F.Name AS Marca_Fabricante, 
    NR.Name AS Clasificacion_Riesto_Dispositivos_Medicos, 
    CE.InvoiceNumber AS Factura, 
    CED.SourceCode AS Orden_Compra,
    CASE CE.Status
        WHEN 1 THEN 'registrado'
        WHEN 2 THEN 'confirmado'
        WHEN 3 THEN 'anulado'
    END AS ESTADO_COMPROBANTE, 
    ISNULL(M.Code, ins.Code) AS Cod_Medicamento_Insumo, 
    ISNULL(M.Name, ins.SupplieName) AS Medicamento_Insumo,
    CASE P.Status
        WHEN '1' THEN 'Activo'
        WHEN '0' THEN 'Inactivo'
    END AS Estado, 
    P.ProductCost AS CostoPromedioActual, 
    CED.UnitValue AS ValorUnitario, 
    CED.UnitValue * CEL.Quantity AS ValorTotal,
    CASE P.ProductControl
        WHEN '0' THEN 'No'
        WHEN '1' THEN 'Si'
    END AS [ProdControl],
    CASE ISNULL(M.HighCost, 0)
        WHEN 0 THEN 'NO'
        WHEN 1 THEN 'SI'
    END AS AltoCosto, 
    AL.Name AS Almacen, 
    G.Name AS Grupo, 
    TP.Name AS TipoProducto, 
    MONTH(CE.DocumentDate) AS Mes_Recibido, 
    YEAR(CE.DocumentDate) AS Año_Recibido, 
    PRO.Code AS CodigoProveedor,
    CASE P.POSProduct
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No'
    END AS ProductoPos,
    DEV.Code as Devolucion, 
    DEV.TotalValue as ValorDevolucion,
    case when DEV.TotalValue is null then CED.TotalValue else CED.TotalValue-CED.TotalValue end as TotalFinal
FROM [INDIGO031].[Inventory].[EntranceVoucher] AS CE
    INNER JOIN [INDIGO031].[Inventory].[EntranceVoucherDetail] AS CED ON CED.EntranceVoucherId = CE.Id
    INNER JOIN [INDIGO031].[Inventory].[EntranceVoucherDetailBatchSerial] CEL ON CEL.EntranceVoucherDetailId = CED.Id
    LEFT JOIN  [INDIGO031].[Inventory].[BatchSerial] AS BS ON BS.Id = CEL.BatchSerialId
    INNER JOIN [INDIGO031].[Inventory].[InventoryProduct] AS P ON P.Id = CED.ProductId
    INNER JOIN [INDIGO031].[Inventory].[ProductType] AS TP ON TP.Code = P.ProductTypeId
    LEFT JOIN  [INDIGO031].[Inventory].[ATC] AS M ON P.ATCId = M.Id
    LEFT JOIN  [INDIGO031].[Inventory].[PharmacologicalGroup] AS GF ON M.PharmacologicalGroupId = GF.Id
    LEFT JOIN  [INDIGO031].[Inventory].[InventorySupplie] AS ins ON ins.Id = P.SupplieId
    LEFT JOIN  [INDIGO031].[Inventory].[ProductGroup] AS G ON G.Id = P.ProductGroupId
    INNER JOIN [INDIGO031].[Inventory].[Warehouse] AS AL ON CE.WarehouseId = AL.Id
    INNER JOIN [INDIGO031].[Common].[Supplier] AS PRO ON PRO.Id = CE.SupplierId
    INNER JOIN [INDIGO031].[Inventory].[PackagingUnit] AS UE ON UE.Id = P.PackagingUnitId
    INNER JOIN [INDIGO031].[Inventory].[Manufacturer] AS F ON F.Id = P.ManufacturerId
    INNER JOIN [INDIGO031].[Inventory].[InventoryRiskLevel] AS NR ON NR.Id = P.InventoryRiskLevelId
    LEFT OUTER JOIN (
        SELECT
            p.Code AS CODPRO, 
            p.Name AS PRO, 
            max(e.Code) as Code, 
            sum(ed.TotalValue) as TotalValue
        FROM [INDIGO031].[Inventory].[EntranceVoucher] as e
            INNER JOIN [INDIGO031].[Inventory].[EntranceVoucherDetail] as ed ON ed.EntranceVoucherId = e.Id 
            INNER JOIN [INDIGO031].[Inventory].[EntranceVoucherDetailBatchSerial] as db ON db.EntranceVoucherDetailId = ed.Id
            LEFT OUTER JOIN [INDIGO031].[Inventory].[EntranceVoucherDevolutionDetail] as edd ON edd.EntranceVoucherDetailBatchSerialId = db.Id
            LEFT OUTER JOIN [INDIGO031].[Inventory].[EntranceVoucherDevolution] as de ON de.Id = edd.EntranceVoucherDevolutionId
            LEFT OUTER JOIN [INDIGO031].[Inventory].[InventoryProduct] as p ON p.Id = ed.ProductId
        WHERE edd.Quantity > 0
        GROUP BY p.Code, p.Name
    ) AS DEV ON DEV.CODPRO = P.Code AND DEV.Code = CE.Code
WHERE year(CE.DocumentDate) between '2023' and '2026'
