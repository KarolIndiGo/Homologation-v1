-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_Almacenes_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [ViewInternal].[VIE_AD_Inventory_Almacenes_PB]
AS

SELECT  pr.Id AS IdProducto, pr.Code AS Código, pr.Name AS Producto, 
           CASE pr.ProductTypeId
          WHEN 1 THEN 'MEDICAMENTO'
          WHEN 2 THEN 'DISPOSITIVO MÉDICO'
          WHEN 3 THEN 'ELEMENTO DE CONSUMO'
          WHEN 4 THEN 'ALIMENTACION ESPECIAL'
          WHEN 5 THEN 'LABORATORIO CLINICO'
          WHEN 6 THEN 'MATERIAL DE OSTEOSINTESIS'
          WHEN 7 THEN 'LITOGRAFIA'
          WHEN 9 THEN 'EQUIPO BIOMEDICO'
          WHEN 10 THEN 'SERVICIO CONECTIVIDAD' end as [Tipo Producto], 
		   atc.code as CodMedicamento, atc.name as Medicamento,
		   case when atc.code is not null 
		   then atc.Code else sp.code end  AS [Código Agrupador], 
		   
		   case when atc.Name  is not null 
		   then atc.name else sp.SupplieName end  AS [Agrupador], 

				   
		   pr.CodeCUM AS [C.U.M], pr.CodeAlternative AS [Código Alterno], 
           pr.CodeAlternativeTwo AS [Código Alterno 2], sg.Name AS SubGrupo, ue.Abbreviation AS Unidad, gf.Name AS [Grupo Facturación], CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Producto Control], pr.ProductCost AS CostoPromedio, pr.FinalProductCost AS Ultimocosto, 
           CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, inf.Quantity AS Cantidad, inf.Quantity * pr.ProductCost AS VrTotal, al.Id, al.Code AS CódigoAlmacén, al.Name AS Almacén, al.Prefix, pr.Description AS Descripcion, 
           CASE WarehouseConsignment WHEN 1 THEN 'Si' ELSE 'No' END AS [Almacen en Consignación]
FROM   Inventory.InventoryProduct AS pr  LEFT OUTER JOIN
           Inventory.PhysicalInventory AS inf  ON inf.ProductId = pr.Id LEFT OUTER JOIN
           Inventory.Warehouse AS al  ON al.Id = inf.WarehouseId LEFT OUTER JOIN
           Inventory.ATC AS atc  ON atc.Id = pr.ATCId LEFT OUTER JOIN
           Inventory.ProductSubGroup AS sg  ON sg.Id = pr.ProductSubGroupId LEFT OUTER JOIN
           Inventory.PackagingUnit AS ue  ON ue.Id = pr.PackagingUnitId LEFT OUTER JOIN
           Billing.BillingGroup AS gf  ON gf.Id = pr.BillingGroupId LEFT OUTER JOIN
		   [Inventory].[InventorySupplie] as sp  on sp.id=pr.SupplieId
WHERE (inf.Quantity <> '0')

