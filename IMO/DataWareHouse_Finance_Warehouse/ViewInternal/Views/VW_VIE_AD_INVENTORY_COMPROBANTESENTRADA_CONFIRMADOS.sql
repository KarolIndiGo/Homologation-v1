-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_COMPROBANTESENTRADA_CONFIRMADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_ComprobantesEntrada_Confirmados]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code AS Codigo,
    i.DocumentDate AS [Fecha Documento],
    s.Name AS Proveedor,
    o.Name AS Almacen,
    i.Description,
    i.InvoiceNumber AS [Numero Factura],
    i.InvoiceDate AS [Fecha Factura],
    i.DayPeriod,
    i.Value,
    i.ValueDiscount,
    i.TotalValue,
    CASE i.Status 
        WHEN 1 THEN 'Registrado' 
        WHEN 2 THEN 'Confirmado' 
        WHEN 3 THEN 'Anulado' 
    END AS Estado
FROM [INDIGO035].[Inventory].[EntranceVoucher] AS i
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS o 
    ON o.Id = i.WarehouseId
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS u 
    ON u.Id = i.OperatingUnitId
INNER JOIN [INDIGO035].[Common].[Supplier] AS s 
    ON s.Id = i.SupplierId
WHERE i.Status = 2;