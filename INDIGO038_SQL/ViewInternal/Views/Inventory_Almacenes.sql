-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Inventory_Almacenes
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Inventory_Almacenes] AS

select pr.Id AS IdProducto, pr.Code AS Código, pr.Name AS Producto, 
           tp.name  AS [Tipo Producto], 
		   atc.code as CodMedicamento, atc.name as Medicamento,
		   case when atc.code is not null 
		   then atc.Code else sp.code end  AS [Código Agrupador], 
		   
		   case when atc.Name  is not null 
		   then atc.name else sp.SupplieName end  AS [Agrupador], 
			   
		   pr.CodeCUM AS [C.U.M], pr.CodeAlternative AS [Código Alterno], 
           pr.CodeAlternativeTwo AS [Código Alterno 2], sg.Name AS SubGrupo, ue.Abbreviation AS Unidad, gf.Name AS [Grupo Facturación], CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Producto Control], pr.ProductCost AS CostoPromedio, pr.FinalProductCost AS Ultimocosto, 
           CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, inf.Quantity AS Cantidad, inf.Quantity * pr.ProductCost AS VrTotal, al.Id, al.Code AS CódigoAlmacén, al.Name AS Almacén, al.Prefix, pr.Description AS Descripcion, 
           CASE WarehouseConsignment WHEN 1 THEN 'Si' ELSE 'No' END AS [Almacen en Consignación], 
		   LOTE.BatchCode AS Lote, LOTE.ExpirationDate AS FechaVencimiento, pr.HealthRegistration AS RegistroSanitario --> Se agregan por solicitud en caso 216337
FROM   Inventory.InventoryProduct AS pr WITH (nolock) LEFT OUTER JOIN
Inventory.ProductType as tp with(nolock) on tp.id=pr.ProductTypeId left join 
           Inventory.PhysicalInventory AS inf WITH (nolock) ON inf.ProductId = pr.Id LEFT OUTER JOIN
           Inventory.Warehouse AS al WITH (nolock) ON al.Id = inf.WarehouseId LEFT OUTER JOIN
           Inventory.ATC AS atc WITH (nolock) ON atc.Id = pr.ATCId LEFT OUTER JOIN
           Inventory.ProductSubGroup AS sg WITH (nolock) ON sg.Id = pr.ProductSubGroupId LEFT OUTER JOIN
           Inventory.PackagingUnit AS ue WITH (nolock) ON ue.Id = pr.PackagingUnitId LEFT OUTER JOIN
           Billing.BillingGroup AS gf WITH (nolock) ON gf.Id = pr.BillingGroupId LEFT OUTER JOIN
		   [Inventory].[InventorySupplie] as sp with (nolock) on sp.id=pr.SupplieId LEFT OUTER JOIN 
		   Inventory.ProductType AS PT ON PT.ID=PR.ProductTypeId LEFT OUTER JOIN 
		   Inventory.BatchSerial AS LOTE ON LOTE.ProductId=inf.ProductId and lote.id=inf.BatchSerialId 
WHERE (inf.Quantity <> '0')


