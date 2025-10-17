-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ORDENTRASLADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_ORDENTRASLADO]
AS


SELECT ot.Code AS Codigo, 
       pg.Code CodigoGrupo,
	   pg.Name NombreGrupo,
	   t.Name TipoProducto,
       pro.Code CodigoProducto, 
       pro.Name +' ------ '+ pu.Name AS NombreProducto, 
	   mu.Name UnidadMedida,
	   pro.ProductCost ValorProducto,
       otd.Quantity AS CantidadSolicitada, 
       otd.InventoryQuantity AS Existencia, 
       uf.Name AS UnidadFuncional, 
       tp.Name AS Responsable,
	   ot.DocumentDate as Fecha
FROM Inventory.TransferOrder AS ot
     INNER JOIN Inventory.TransferOrderDetail otd ON ot.Id = otd.TransferOrderId
     INNER JOIN Inventory.InventoryProduct AS pro ON otd.ProductId = pro.Id
	 INNER JOIN INVENTORY.ProductGroup PG ON PG.Id = PRO.ProductGroupId
	 INNER JOIN inventory.ProductType t on t.Id = pro.ProductTypeId
	 INNER JOIN inventory.InventoryMeasurementUnit mu on mu.Id = pro.MeasurementUnitId
     INNER JOIN Payroll.FunctionalUnit AS uf ON ot.TargetFunctionalUnitId = uf.Id
     INNER JOIN Common.ThirdParty AS tp ON ot.ThirdPartyId = tp.Id
     INNER JOIN Inventory.PackagingUnit AS pu ON pro.PackagingUnitId = pu.Id

