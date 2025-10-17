-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventarioSaldoAlmacenes
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE view [Report].[ViewInventarioSaldoAlmacenes] as

SELECT        
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
*,
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
(
SELECT
PR.Id AS IDPr, 
pr.Code AS Código, pr.Name AS Producto, TP.Name AS [TipoProducto], 
Med.Code AS [Cod Med], 
Med.Name AS Medicamento, ATC.Code AS ATC, ATC.Name AS NombreATC, pr.CodeCUM AS CUM, 
pr.CodeAlternativeTwo AS [CódigoAlterno2], sg.Name AS SubGrupo, ue.Abbreviation AS Unidad, gf.Name AS [GrupoFacturación], CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [ProdControl],
pr.ProductCost AS CostoPromedio, 
pr.FinalProductCost AS Ultimocosto, 
CASE pr.ProductWithPriceControl WHEN 0 THEN '' WHEN 1 THEN 'SI' END AS Regulado, 
CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, 
PR.MinimumStock AS [STOCK MINIMO],
PR.MaximumStock AS [STOCK MAXIMO],
inf.Quantity AS Cantidad,
al.Code AS CodAlmacen
FROM            
Inventory.InventoryProduct AS pr LEFT OUTER JOIN
Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id LEFT OUTER JOIN
Inventory.Warehouse AS al ON al.Id = inf.WarehouseId LEFT OUTER JOIN
Inventory.ATC AS Med ON Med.Id = pr.ATCId LEFT OUTER JOIN
Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId LEFT OUTER JOIN
Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId LEFT OUTER JOIN
Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId LEFT JOIN
Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id JOIN
Inventory.ProductType TP ON PR.ProductTypeId = TP.Id
WHERE
al.code IN ('0101','0102','02','0201','0202','0203','03','04','05','06','07','08','09','10','11','12','13') AND 
INF.Quantity > 0) source PIVOT (sum(Cantidad) FOR source.CodAlmacen IN ([0101],
[0102],[02],[0201],[0202],[0203],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13])) AS pivotable
--GO


--select * from Inventory.Warehouse