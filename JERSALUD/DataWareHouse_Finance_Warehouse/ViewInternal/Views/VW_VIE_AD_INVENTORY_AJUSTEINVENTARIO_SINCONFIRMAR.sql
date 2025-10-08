-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_AJUSTEINVENTARIO_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_AJUSTEINVENTARIO_SINCONFIRMAR AS

SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], CASE AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' WHEN 3 THEN 'Inventario Fisico' END AS [Tipo Inventario], 
                  c.Name AS [Concepto Ajuste], o.Name AS Almacen, i.Description, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, i.CreationDate AS [Fecha Creacion]
FROM    INDIGO031.Inventory.InventoryAdjustment AS i 
INNER JOIN INDIGO031.Inventory.Warehouse AS o ON o.Id = i.WarehouseId 
INNER JOIN INDIGO031.Common.OperatingUnit AS u ON u.Id = i.OperatingUnitId 
INNER JOIN INDIGO031.Inventory.AdjustmentConcept AS c ON c.Id = i.AdjustmentConceptId
WHERE  (i.Status = '1')