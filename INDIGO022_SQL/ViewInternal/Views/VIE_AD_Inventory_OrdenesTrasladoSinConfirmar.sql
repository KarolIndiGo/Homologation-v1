-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_OrdenesTrasladoSinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create VIEW [ViewInternal].[VIE_AD_Inventory_OrdenesTrasladoSinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.OperatingUnitId, i.DocumentDate AS [Fecha Documento], CASE OrderType WHEN 1 THEN 'Traslado' WHEN '2' THEN 'Consumo' END AS [Tipo Orden], 
                  CASE DispatchTo WHEN 1 THEN 'Almacen' WHEN 2 THEN 'Unidad Funcional' END AS [Despachar a], o.Name AS [Almacen Origen], d.Name AS [Almacen Destino], i.Description AS Descripcion, 
                  CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, i.CreationDate AS [Fecha Creacion]
FROM     Inventory.TransferOrder AS i INNER JOIN
                  Inventory.Warehouse AS o   ON o.Id = i.SourceWarehouseId INNER JOIN
                  Inventory.Warehouse AS d   ON d.Id = i.TargetWarehouseId INNER JOIN
                  Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId
WHERE  (i.Status = 1)
