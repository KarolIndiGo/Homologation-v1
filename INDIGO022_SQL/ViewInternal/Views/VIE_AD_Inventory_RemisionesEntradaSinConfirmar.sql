-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_RemisionesEntradaSinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create VIEW [ViewInternal].[VIE_AD_Inventory_RemisionesEntradaSinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.RemissionDate AS [Fecha Remision], s.Name AS Proveedor, o.Name AS Almacen, i.RemissionNumber AS [No Remision], i.Description, i.Value, i.IvaValue, i.TotalValue, 
                  CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, i.ProductStatus, i.CreationDate AS [Fecha Creacion]
FROM      Inventory.RemissionEntrance AS i INNER JOIN
                   Inventory.Warehouse AS o ON o.Id = i.WarehouseId INNER JOIN
                   Common.OperatingUnit AS u ON u.Id = i.OperatingUnitId INNER JOIN
                   Common.Supplier AS s ON s.Id = i.SupplierId
WHERE  (i.Status = 1)
