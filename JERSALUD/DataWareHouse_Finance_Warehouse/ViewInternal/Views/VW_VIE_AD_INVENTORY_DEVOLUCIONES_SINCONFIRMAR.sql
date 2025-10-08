-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_DEVOLUCIONES_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_DEVOLUCIONES_SINCONFIRMAR
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], o.Name AS Almacen, i.AdmissionNumber AS Ingreso, i.Observation, 
                  CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM      INDIGO031.Inventory.PharmaceuticalDispensingDevolution AS i INNER JOIN
                   INDIGO031.Inventory.Warehouse AS o   ON o.Id = i.WarehouseId INNER JOIN
                   INDIGO031.Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId
WHERE  (i.Status = 1)