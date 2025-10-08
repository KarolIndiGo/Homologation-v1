-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INVENTORY_ALMACENES_LOTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_Inventory_Almacenes_Lote
AS

SELECT  pr.Id AS IdProducto, pr.Code AS Código, pr.Name AS Producto, 
           PT.Name AS [Tipo Producto], 
		   atc.Code as CodMedicamento, atc.Name as Medicamento,
		   case when atc.Code is not null 
		   then atc.Code else sp.Code end  AS [Código Agrupador], 
		   
		   case when atc.Name  is not null 
		   then atc.Name else sp.SupplieName end  AS [Agrupador], 

				   
		   pr.CodeCUM AS [C.U.M], pr.CodeAlternative AS [Código Alterno], 
           pr.CodeAlternativeTwo AS [Código Alterno 2], sg.Name AS SubGrupo, ue.Abbreviation AS Unidad, gf.Name AS [Grupo Facturación], CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Producto Control], pr.ProductCost AS CostoPromedio, pr.FinalProductCost AS Ultimocosto, 
           CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, inf.Quantity AS Cantidad, inf.Quantity * pr.ProductCost AS VrTotal, al.Id, al.Code AS CódigoAlmacén, al.Name AS Almacén, al.Prefix, pr.Description AS Descripcion, 
           CASE WarehouseConsignment WHEN 1 THEN 'Si' ELSE 'No' END AS [Almacen en Consignación], LOTE.BatchCode AS Lote, LOTE.ExpirationDate AS FechaVencimiento
FROM   [INDIGO035].[Inventory].[InventoryProduct] AS pr  LEFT OUTER JOIN
           [INDIGO035].[Inventory].[PhysicalInventory] AS inf  ON inf.ProductId = pr.Id LEFT OUTER JOIN
           [INDIGO035].[Inventory].[Warehouse] AS al  ON al.Id = inf.WarehouseId LEFT OUTER JOIN
           [INDIGO035].[Inventory].[ATC] AS atc  ON atc.Id = pr.ATCId LEFT OUTER JOIN
           [INDIGO035].[Inventory].[ProductSubGroup] AS sg  ON sg.Id = pr.ProductSubGroupId LEFT OUTER JOIN
           [INDIGO035].[Inventory].[PackagingUnit] AS ue  ON ue.Id = pr.PackagingUnitId LEFT OUTER JOIN
           [INDIGO035].[Billing].[BillingGroup] AS gf  ON gf.Id = pr.BillingGroupId LEFT OUTER JOIN
		   [INDIGO035].[Inventory].[InventorySupplie] as sp  on sp.Id=pr.SupplieId LEFT OUTER JOIN 
		   [INDIGO035].[Inventory].[ProductType] AS PT ON PT.Id=pr.ProductTypeId LEFT OUTER JOIN 
		   [INDIGO035].[Inventory].[BatchSerial] AS LOTE ON LOTE.ProductId=inf.ProductId and LOTE.Id=inf.BatchSerialId 
WHERE (inf.Quantity <> '0') 