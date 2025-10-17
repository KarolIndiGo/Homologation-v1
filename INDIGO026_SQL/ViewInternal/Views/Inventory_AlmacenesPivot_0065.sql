-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Inventory_AlmacenesPivot_0065
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Inventory_AlmacenesPivot_0065] AS

 SELECT pivotable.Código, 
            pivotable.Producto, 
            pivotable.TipoProducto, 
            pivotable.CódigoMedicamento, 
			pivotable.[CódigoInsumo], 
			pivotable.[Insumo],
            pivotable.CUM, 
            pivotable.ATC, 
            pivotable.CódigoAlterno, 
            pivotable.SubGrupo, 
            pivotable.Unidad, 
            pivotable.GrupoFacturación, 
            pivotable.ProdControl, 
            pivotable.CostoPromedio, 
            pivotable.Ultimocosto, 
            pivotable.Estado, 
			pivotable.[Código Agrupador],
			pivotable.[Agrupador],  pivotable.BillingGroupId,
           
            pivotable.[0065]
     FROM
     (
         SELECT PR.Code AS Código, 
                PR.Name AS Producto,
                CASE PR.ProductTypeId
                    WHEN '2'
                    THEN 'MEDICAMENTO'
                    WHEN '3'
                    THEN 'DISPOSITIVO MÉDICO'
                    WHEN '4'
                    THEN 'ELEMENTOS DE CONSUMO'
                    WHEN '5'
                    THEN 'ALIMENTACION ESPECIAL'
                    ELSE '-'
                END AS [TipoProducto], 
                ATC.Code AS [CódigoMedicamento], 
				s.Code AS [CódigoInsumo], 
				s.suppliename as [Insumo],
                PR.CodeCUM AS [CUM], 
                PR.CodeAlternative AS [ATC], 
                PR.CodeAlternativeTwo AS [CódigoAlterno], 
                SG.Name AS SubGrupo, 
                PU.Abbreviation AS Unidad, 
                GF.Name AS [GrupoFacturación],
                CASE PR.ProductControl
                    WHEN '0'
                    THEN 'No'
                    WHEN '1'
                    THEN 'Si'
                    ELSE '-'
                END AS [ProdControl], 
                PR.ProductCost AS CostoPromedio, 
                PR.FinalProductCost AS Ultimocosto,
                CASE PR.STATUS
                    WHEN '1'
                    THEN 'Activo'
                    WHEN '0'
                    THEN 'Inactivo'
                    ELSE '-'
                END AS Estado, 
                INF.Quantity AS Cantidad, 
                AL.Code AS CodAlmacen ,
				
				 case when atc.code is not null 
		   then atc.Code else s.code end  AS [Código Agrupador],
		   
		   case when atc.Name  is not null 
		   then atc.name else s.SupplieName end  AS [Agrupador], PR.BillingGroupId
         FROM Inventory.InventoryProduct AS PR
              left JOIN Billing.BillingGroup AS GF with (nolock) ON GF.Id = PR.BillingGroupId
              LEFT OUTER JOIN Inventory.PhysicalInventory AS INF with (nolock) ON INF.ProductId = PR.Id
              LEFT OUTER JOIN Inventory.Warehouse AS AL with (nolock) ON AL.Id = INF.WarehouseId  --select * from inventory.warehouse where code='0065'
              LEFT OUTER JOIN Inventory.ATC AS ATC with (nolock) ON ATC.Id = PR.ATCId
			  left outer join [Inventory].[InventorySupplie] as s with (nolock) on s.id=pr.SupplieId
              LEFT OUTER JOIN Inventory.ProductSubGroup AS SG with (nolock) ON SG.Id = PR.ProductSubGroupId
              LEFT OUTER JOIN Inventory.PackagingUnit AS PU with (nolock) ON PU.Id = PR.PackagingUnitId
              LEFT OUTER JOIN [ViewInternal].HomólogosDiferidoInv AS H with (nolock) ON H.CodeAlternativeTwo = PR.CodeAlternativeTwo
                                                                              AND H.Code = PR.Code
         WHERE 
			   --PR.BillingGroupId <> '1'
      --         AND 
	  --PR.STATUS <> '0' 			   and 
			   al.code='0065'
     ) SOURCE PIVOT(SUM(Cantidad) FOR source.CodAlmacen IN([0065] 
                                                          )) AS pivotable
--where pivotable.Código='20055558-08'
--where pivotable.[Código Agrupador]='00041'
--select * from Billing.BillingGroup
