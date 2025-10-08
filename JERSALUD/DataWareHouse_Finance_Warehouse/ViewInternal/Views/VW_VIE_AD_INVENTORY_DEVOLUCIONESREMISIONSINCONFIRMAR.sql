-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_DEVOLUCIONESREMISIONSINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_DEVOLUCIONESREMISIONSINCONFIRMAR AS

SELECT o.UnitName AS Sucursal, r.Code AS Codigo, r.RemissionDate AS [Fecha Remision], CASE DevolutionType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS [Tipo Devolucion], a.Name AS Almacen, r.Description, 
                  CASE r.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM     INDIGO031.Inventory.RemissionDevolution AS r 
INNER JOIN INDIGO031.Common.OperatingUnit AS o ON o.Id = r.OperatingUnitId 
INNER JOIN INDIGO031.Inventory.Warehouse AS a ON a.Id = r.WarehouseId
WHERE  (r.Status = 1)