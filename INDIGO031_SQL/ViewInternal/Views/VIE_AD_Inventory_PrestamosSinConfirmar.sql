-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_PrestamosSinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_PrestamosSinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], CASE i.loantype WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS TipoPrestamo, o.Name AS Almacen, t.Name AS Tercero, 
                  i.Observation AS Observacion, CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM     Inventory.LoanMerchandise AS i INNER JOIN
                  Inventory.Warehouse AS o   ON o.Id = i.WarehouseId INNER JOIN
                  Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId INNER JOIN
                  Common.ThirdParty AS t   ON t.Id = i.ThirdPartyId
WHERE  (i.Status = 1)
