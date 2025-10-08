-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_ORDENESTRASLADOSINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_ORDENESTRASLADOSINCONFIRMAR
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.OperatingUnitId, i.DocumentDate AS [Fecha Documento], CASE OrderType WHEN 1 THEN 'Traslado' WHEN '2' THEN 'Consumo' END AS [Tipo Orden], 
                  CASE DispatchTo WHEN 1 THEN 'Almacen' WHEN 2 THEN 'Unidad Funcional' END AS [Despachar a], o.Name AS [Almacen Origen], d.Name AS [Almacen Destino], i.Description AS Descripcion, 
                  CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, i.CreationDate AS [Fecha Creacion]
FROM     INDIGO031.Inventory.TransferOrder AS i INNER JOIN
                  INDIGO031.Inventory.Warehouse AS o   ON o.Id = i.SourceWarehouseId INNER JOIN
                  INDIGO031.Inventory.Warehouse AS d   ON d.Id = i.TargetWarehouseId INNER JOIN
                  INDIGO031.Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId
WHERE  (i.Status = 1)