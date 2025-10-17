-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_AjusteInventario_SinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[VIE_AD_Inventory_AjusteInventario_SinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], CASE AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' WHEN 3 THEN 'Inventario Fisico' END AS [Tipo Inventario], 
                  c.Name AS [Concepto Ajuste], o.Name AS Almacen, i.Description, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, i.CreationDate AS [Fecha Creacion]
FROM    Inventory.InventoryAdjustment AS i INNER JOIN
                 Inventory.Warehouse AS o ON o.Id = i.WarehouseId INNER JOIN
                 Common.OperatingUnit AS u ON u.Id = i.OperatingUnitId INNER JOIN
                 Inventory.AdjustmentConcept AS c ON c.Id = i.AdjustmentConceptId
WHERE  (i.Status = '1')
