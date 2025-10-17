-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_DevolucionPrestamos_SinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[VIE_AD_Inventory_DevolucionPrestamos_SinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.DocumentDate AS [Fecha Documento], o.Name AS Almacen, i.Observation AS Observacion, 
                  CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM     Inventory.LoanMerchandiseDevolution AS i INNER JOIN
                  Inventory.Warehouse AS o   ON o.Id = i.WarehouseId INNER JOIN
                  Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId
WHERE  (i.Status = 1)
