-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_SOLICITUDES_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_SOLICITUDES_SINCONFIRMAR
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], CASE i.RequestType WHEN 1 THEN 'Unidad Funcional' WHEN 2 THEN 'Almacen' END AS TipoSolicitud, 
                  CASE i.MovementType WHEN 1 THEN 'Consumo' WHEN 2 THEN 'Traslado' END AS Tipo, o.Name AS AlmacenOrigen, o1.Name AS AlmacenDestino, i.Observation AS Observacion, 
                  CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM      INDIGO031.Inventory.InventoryRequest AS i LEFT OUTER JOIN
                   INDIGO031.Inventory.Warehouse AS o   ON o.Id = i.SourceWarehouseId LEFT OUTER JOIN
                   INDIGO031.Inventory.Warehouse AS o1   ON o.Id = i.TargetWarehouseId LEFT OUTER JOIN
                   INDIGO031.Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId
WHERE  (i.Status = 1)