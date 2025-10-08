-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INVENTORY_ALMACENESPIVOT
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_Inventory_AlmacenesPivot
AS

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
       --pivotable.Unidad,
       pivotable.GrupoFacturación,
       pivotable.ProdControl,
       pivotable.CostoPromedio,
       pivotable.Ultimocosto,
       pivotable.Estado,
       pivotable.[Código Agrupador],
       pivotable.[Agrupador],
       pivotable.[200],
      pivotable.[001],
      pivotable.[002],
      pivotable.[100],
      pivotable.[101],
      pivotable.[003],
      pivotable.[102],
      pivotable.[203],
      pivotable.[103],
      pivotable.[104],
      pivotable.[105],
      pivotable.[106],
      pivotable.[107],
      pivotable.[108],
      pivotable.[109]
FROM (SELECT PR.Code
                AS Código,
             PR.Name
                AS Producto,
             CASE PR.ProductTypeId
                WHEN '1' then 'MEDICAMENTO'
				WHEN '2' then 	'DISPOSITIVO MÉDICO'
                WHEN '3' then 'ELEMENTO DE CONSUMO'
                WHEN '4' then 'ALIMENTACION ESPECIAL'
                WHEN '5' then 'EQUIPO BIOMEDICO'
                WHEN '6' then 'ELEMENTOS DE PROTECCION PERSONAL'
                WHEN '7' then 'ACTIVO' 

             END
                AS [TipoProducto],
             ATC.Code
                AS [CódigoMedicamento],
             s.Code
                AS [CódigoInsumo],
             s.SupplieName
                AS [Insumo],
             PR.CodeCUM
                AS [CUM],
             PR.CodeAlternative
                AS [ATC],
             PR.CodeAlternativeTwo
                AS [CódigoAlterno],
             SG.Name
                AS SubGrupo,
             --PU.Abbreviation AS Unidad,
             GF.Name
                AS [GrupoFacturación],
             CASE PR.ProductControl
                WHEN '0' THEN 'No'
                WHEN '1' THEN 'Si'
                ELSE '-'
             END
                AS [ProdControl],
             PR.ProductCost
                AS CostoPromedio,
             PR.FinalProductCost
                AS Ultimocosto,
             CASE PR.Status
                WHEN '1' THEN 'Activo'
                WHEN '0' THEN 'Inactivo'
                ELSE '-'
             END
                AS Estado,
             INF.Quantity
                AS Cantidad,
             AL.Code
                AS CodAlmacen,
             CASE WHEN ATC.Code IS NOT NULL THEN ATC.Code ELSE s.Code END
                AS [Código Agrupador],
             CASE
                WHEN ATC.Name IS NOT NULL THEN ATC.Name
                ELSE s.SupplieName
             END
                AS [Agrupador]
      FROM [INDIGO035].[Inventory].[InventoryProduct] AS PR
           INNER JOIN [INDIGO035].[Billing].[BillingGroup] AS GF
              ON GF.Id = PR.BillingGroupId
           LEFT OUTER JOIN
           [INDIGO035].[Inventory].[PhysicalInventory] AS INF
              ON INF.ProductId = PR.Id
           LEFT OUTER JOIN [INDIGO035].[Inventory].[Warehouse] AS AL
              ON AL.Id = INF.WarehouseId
           LEFT OUTER JOIN [INDIGO035].[Inventory].[ATC] AS ATC
              ON ATC.Id = PR.ATCId
           LEFT OUTER JOIN
           [INDIGO035].[Inventory].[InventorySupplie] AS s
              ON s.Id = PR.SupplieId
           LEFT OUTER JOIN
           [INDIGO035].[Inventory].[ProductSubGroup] AS SG
              ON SG.Id = PR.ProductSubGroupId
           --LEFT OUTER JOIN Inventory.PackagingUnit AS PU ON PU.Id = PR.PackagingUnitId
          -- LEFT OUTER JOIN
           --[ReportesMedi].dbo.HomólogosDiferidoInv AS H
           --   ON     H.CodeAlternativeTwo = PR.CodeAlternativeTwo
           --      AND H.Code = PR.Code
      WHERE     
	  --NOT EXISTS
   --                (SELECT Code
   --                 FROM [ReportesMedi].[dbo].[ExcluidoInferido] EI
   --                 WHERE EI.Code = SG.Code)
            /*SG.code <> 'OSTEO001' AND SG.code <> 'PROTE001'*/

            -- PR.BillingGroupId <> '1'
             PR.Code NOT LIKE ('800-%')
            --AND PR.STATUS <> '0'
            --AND al.code <> '006'--AND GF.Name IS NOT NULL
                                ) SOURCE
     PIVOT (SUM (Cantidad)
           FOR SOURCE.CodAlmacen
           IN ([200],[001],[002],[100],[101],[003],[102],[203],[103],[104],[105],[106],[107],[108],[109])
        ) AS pivotable
