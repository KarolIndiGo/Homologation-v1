-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_DevolucionesRemisionSinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Inventory_DevolucionesRemisionSinConfirmar]
AS
SELECT o.UnitName AS Sucursal, r.Code AS Codigo, r.RemissionDate AS [Fecha Remision], CASE DevolutionType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS [Tipo Devolucion], a.Name AS Almacen, r.Description, 
                  CASE r.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM     Inventory.RemissionDevolution AS r INNER JOIN
                  Common.OperatingUnit AS o ON o.Id = r.OperatingUnitId INNER JOIN
                  Inventory.Warehouse AS a ON a.Id = r.WarehouseId
WHERE  (r.Status = 1)

