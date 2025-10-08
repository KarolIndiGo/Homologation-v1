-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_AJUSTEINVENTARIO_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Inventory_AjusteInventario_SinConfirmar]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code AS Codigo,
    i.DocumentDate AS [Fecha Documento],
    CASE AdjustmentType 
        WHEN 1 THEN 'Entrada' 
        WHEN 2 THEN 'Salida' 
        WHEN 3 THEN 'Inventario Fisico' 
    END AS [Tipo Inventario], 
    c.Name AS [Concepto Ajuste],
    o.Name AS Almacen,
    i.Description,
    CASE i.Status 
        WHEN 1 THEN 'Registrado' 
        WHEN 2 THEN 'Confirmado' 
        WHEN 3 THEN 'Anulado' 
    END AS Estado,
    i.CreationDate AS [Fecha Creacion]
FROM [INDIGO035].[Inventory].[InventoryAdjustment] AS i
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS o 
    ON o.Id = i.WarehouseId
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS u 
    ON u.Id = i.OperatingUnitId
INNER JOIN [INDIGO035].[Inventory].[AdjustmentConcept] AS c 
    ON c.Id = i.AdjustmentConceptId
WHERE (i.Status = '1');