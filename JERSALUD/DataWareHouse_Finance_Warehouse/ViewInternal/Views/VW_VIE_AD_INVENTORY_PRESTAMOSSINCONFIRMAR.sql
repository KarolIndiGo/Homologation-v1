-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_PRESTAMOSSINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_PRESTAMOSSINCONFIRMAR
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], CASE i.LoanType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS TipoPrestamo, o.Name AS Almacen, t.Name AS Tercero, 
                  i.Observation AS Observacion, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM     INDIGO031.Inventory.LoanMerchandise AS i INNER JOIN
                  INDIGO031.Inventory.Warehouse AS o   ON o.Id = i.WarehouseId INNER JOIN
                  INDIGO031.Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId INNER JOIN
                  INDIGO031.Common.ThirdParty AS t   ON t.Id = i.ThirdPartyId
WHERE  (i.Status = 1)