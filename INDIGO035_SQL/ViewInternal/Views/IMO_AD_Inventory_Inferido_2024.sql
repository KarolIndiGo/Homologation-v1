-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_Inventory_Inferido_2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0




create VIEW [ViewInternal].[IMO_AD_Inventory_Inferido_2024]
AS
SELECT Sucursal,
       Cod_Producto,
       Producto,
       Hijos,
       CASE WHEN Cod_Producto LIKE '0%' THEN 'Medicamento' ELSE 'Insumo' END
          AS Tipo,
       CostoPromedio,
       Ene23,
       Feb23,
       Mar23,
       Abr23,
       May23,
       Jun23,
       Jul23,
       Ago23,
       Sep23,
       Oct23,
       Nov23,
       Dic23,
       Ene24,
       Feb24,
       Mar24,
       Abr24,
       May24,
       Jun24,
       Jul24,
       Ago24,
       Sep24,
       Oct24,
       Nov24,
       Dic24,
       Promedio
          AS ConsumoPromedio,
      [200], [001],[002],[100],[101],
			[003],[102],[203],[103],[104],[105],[106],[107],
[108],[109],

       InventarioFisico,
       ceiling (Promedio * 1.55)
          AS Punto_Pedido,
       CASE
          WHEN Promedio = 0 AND InventarioFisico > 0
          THEN
             0
          WHEN (InventarioFisico - (ceiling (Promedio * 1.55))) > 0
          THEN
             (InventarioFisico - (ceiling (Promedio * 1.55)))
       END
          AS Superavit,
       CASE
          WHEN Promedio = 0 AND InventarioFisico > 0
          THEN
             0
          WHEN (InventarioFisico - (ceiling (Promedio * 1.55))) < 0
          THEN
             abs (InventarioFisico - (ceiling (Promedio * 1.55)))
       END
          AS Deficit,
       CASE
          WHEN Promedio = 0 AND InventarioFisico > 0 THEN InventarioFisico
          ELSE ''
       END
          AS Ocioso,
       CASE
          WHEN CONVERT (DOUBLE PRECISION, Promedio) = 0
          THEN
             ROUND
             ((CONVERT (DOUBLE PRECISION, InventarioFisico) / 1) * 30, 0)
          ELSE
             ROUND
             (
                  (  CONVERT (DOUBLE PRECISION, InventarioFisico)
                   / CONVERT (DOUBLE PRECISION, Promedio))
                * 30,
                0)
       END
          AS DiasInventario,
       round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0)
          AS [Q.Min (PromX10d)],
         round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
       + round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0)
          AS [Q.Max (PromX45d)+Q.Min],
       CASE
          WHEN   (  round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                  + round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
               - InventarioFisico <
               0
          THEN
             0
          ELSE
               (  round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                + round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
             - InventarioFisico
       END
          AS [Q. Sugerido],
       CASE Rotacion
          WHEN 0 THEN 'Nula'
          WHEN 1 THEN 'Baja'
          WHEN 2 THEN 'Baja'
          WHEN 3 THEN 'Media'
          WHEN 4 THEN 'Media'
          WHEN 5 THEN 'Alta'
          WHEN 6 THEN 'Alta'
       END
          AS TipoRotacion,
       CASE
          WHEN   (  round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                  + round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
               - InventarioFisico <
               0
          THEN
             0
          WHEN Rotacion = 1
          THEN
             CEILING
             (
                  (  (  round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                      + round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
                   - InventarioFisico)
                * 0.2)
          WHEN Rotacion = 2
          THEN
             CEILING
             (
                  (  (  round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                      + round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
                   - InventarioFisico)
                * 0.4)
          WHEN Rotacion = 3
          THEN
             CEILING
             (
                  (  (  round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                      + round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
                   - InventarioFisico)
                * 0.6)
          WHEN Rotacion = 4
          THEN
             CEILING
             (
                  (  (  round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                      + round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
                   - InventarioFisico)
                * 0.8)
          WHEN Rotacion = 5
          THEN
             CEILING
             (
                  (  (  round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                      + round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
                   - InventarioFisico)
                * 0.9)
          WHEN Rotacion = 6
          THEN
             CEILING
             (
                  (  (  round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                      + round
                        (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
                   - InventarioFisico)
                * 1.0)
          ELSE
             0
       END
          AS [Q. Pedido Final],
       CASE
          WHEN   (  round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45, 0)
                  + round (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10, 0))
               - InventarioFisico <
               0
          THEN
             0
          WHEN Rotacion = 1
          THEN
             CEILING
             (
                  CEILING
                  (
                       (  (  round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45,
                              0)
                           + round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10,
                              0))
                        - InventarioFisico)
                     * 0.2)
                * CostoPromedio)
          WHEN Rotacion = 2
          THEN
             CEILING
             (
                  CEILING
                  (
                       (  (  round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45,
                              0)
                           + round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10,
                              0))
                        - InventarioFisico)
                     * 0.4)
                * CostoPromedio)
          WHEN Rotacion = 3
          THEN
             CEILING
             (
                  CEILING
                  (
                       (  (  round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45,
                              0)
                           + round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10,
                              0))
                        - InventarioFisico)
                     * 0.6)
                * CostoPromedio)
          WHEN Rotacion = 4
          THEN
             CEILING
             (
                  CEILING
                  (
                       (  (  round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45,
                              0)
                           + round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10,
                              0))
                        - InventarioFisico)
                     * 0.8)
                * CostoPromedio)
          WHEN Rotacion = 5
          THEN
             CEILING
             (
                  CEILING
                  (
                       (  (  round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45,
                              0)
                           + round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10,
                              0))
                        - InventarioFisico)
                     * 0.9)
                * CostoPromedio)
          WHEN Rotacion = 6
          THEN
             CEILING
             (
                  CEILING
                  (
                       (  (  round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 45,
                              0)
                           + round
                             (CONVERT (DOUBLE PRECISION, Promedio) / 30 * 10,
                              0))
                        - InventarioFisico)
                     * 1.0)
                * CostoPromedio)
          ELSE
             0
       END
          AS [Vr Pedido]
FROM (SELECT PROD.Sucursal,
             PROD.[Código Agrupador] AS Cod_Producto,
             [Agrupador] AS Producto,
             isnull (sum (PROD.Ene23), 0) AS Ene23,
             isnull (sum (PROD.Feb23), 0) AS Feb23,
             isnull (sum (PROD.Mar23), 0) AS Mar23,
             isnull (sum (PROD.Abr23), 0) AS Abr23,
             isnull (sum (PROD.May23), 0) AS May23,
             isnull (sum (PROD.Jun23), 0) AS Jun23,
             isnull (sum (PROD.Jul23), 0) AS Jul23,
             isnull (sum (PROD.Ago23), 0) AS Ago23,
             isnull (sum (PROD.Sep23), 0) AS Sep23,
             isnull (sum (PROD.Oct23), 0) AS Oct23,
             isnull (sum (PROD.Nov23), 0) AS Nov23,
             isnull (sum (PROD.Dic23), 0) AS Dic23,
             isnull (sum (PROD.Ene24), 0) AS Ene24,
             isnull (sum (PROD.Feb24), 0) AS Feb24,
             isnull (sum (PROD.Mar24), 0) AS Mar24,
             isnull (sum (PROD.Abr24), 0) AS Abr24,
             isnull (sum (PROD.May24), 0) AS May24,
             isnull (sum (PROD.Jun24), 0) AS Jun24,
             isnull (sum (PROD.Jul24), 0) AS Jul24,
             isnull (sum (PROD.Ago24), 0) AS Ago24,
             isnull (sum (PROD.Sep24), 0) AS Sep24,
             isnull (sum (PROD.Oct24), 0) AS Oct24,
             isnull (sum (PROD.Nov24), 0) AS Nov24,
             isnull (sum (PROD.Dic24), 0) AS Dic24,
             --Promedio
             CASE
                WHEN month (getdate ()) = 1 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Jul23), 0))
                      + (isnull (sum (PROD.Ago23), 0))
                      + (isnull (sum (PROD.Sep23), 0))
                      + (isnull (sum (PROD.Oct23), 0))
                      + (isnull (sum (PROD.Nov23), 0))
                      + (isnull (sum (PROD.Dic23), 0)))
                   / 6
                WHEN month (getdate ()) = 2 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Ago23), 0))
                      + (isnull (sum (PROD.Sep23), 0))
                      + (isnull (sum (PROD.Oct23), 0))
                      + (isnull (sum (PROD.Nov23), 0))
                      + (isnull (sum (PROD.Dic23), 0))
                      + (isnull (sum (PROD.Ene24), 0)))
                   / 6
                WHEN month (getdate ()) = 3 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Sep23), 0))
                      + (isnull (sum (PROD.Oct23), 0))
                      + (isnull (sum (PROD.Nov23), 0))
                      + (isnull (sum (PROD.Dic23), 0))
                      + (isnull (sum (PROD.Ene24), 0))
                      + (isnull (sum (PROD.Feb24), 0)))
                   / 6
                WHEN month (getdate ()) = 4 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Oct23), 0))
                      + (isnull (sum (PROD.Nov23), 0))
                      + (isnull (sum (PROD.Dic23), 0))
                      + (isnull (sum (PROD.Ene24), 0))
                      + (isnull (sum (PROD.Feb24), 0))
                      + (isnull (sum (PROD.Mar24), 0)))
                --   / 6
                WHEN month (getdate ()) = 5 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Nov23), 0))
                      + (isnull (sum (PROD.Dic23), 0))
                      + (isnull (sum (PROD.Ene24), 0))
                      + (isnull (sum (PROD.Feb24), 0))
                      + (isnull (sum (PROD.Mar24), 0))
                      + (isnull (sum (PROD.Abr24), 0)))
                   / 6
                WHEN month (getdate ()) = 6 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Dic23), 0))
                      + (isnull (sum (PROD.Ene24), 0))
                      + (isnull (sum (PROD.Feb24), 0))
                      + (isnull (sum (PROD.Mar24), 0))
                      + (isnull (sum (PROD.Abr24), 0))
                      + (isnull (sum (PROD.May24), 0)))
                   / 6
                WHEN month (getdate ()) = 7 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Ene24), 0))
                      + (isnull (sum (PROD.Feb24), 0))
                      + (isnull (sum (PROD.Mar24), 0))
                      + (isnull (sum (PROD.Abr24), 0))
                      + (isnull (sum (PROD.May24), 0))
                      + (isnull (sum (PROD.Jun24), 0)))
                   / 6
                WHEN month (getdate ()) = 8 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Feb24), 0))
                      + (isnull (sum (PROD.Mar24), 0))
                      + (isnull (sum (PROD.Abr24), 0))
                      + (isnull (sum (PROD.May24), 0))
                      + (isnull (sum (PROD.Jun24), 0))
                      + (isnull (sum (PROD.Jul24), 0)))
                   / 6
                WHEN month (getdate ()) = 9 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Mar24), 0))
                      + (isnull (sum (PROD.Abr24), 0))
                      + (isnull (sum (PROD.May24), 0))
                      + (isnull (sum (PROD.Jun24), 0))
                      + (isnull (sum (PROD.Jul24), 0))
                      + (isnull (sum (PROD.Ago24), 0)))
                   / 6
                WHEN month (getdate ()) = 10 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Abr24), 0))
                      + (isnull (sum (PROD.May24), 0))
                      + (isnull (sum (PROD.Jun24), 0))
                      + (isnull (sum (PROD.Jul24), 0))
                      + (isnull (sum (PROD.Ago24), 0))
                      + (isnull (sum (PROD.Sep24), 0)))
                   / 6
                WHEN month (getdate ()) = 11 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.May24), 0))
                      + (isnull (sum (PROD.Jun24), 0))
                      + (isnull (sum (PROD.Jul24), 0))
                      + (isnull (sum (PROD.Ago24), 0))
                      + (isnull (sum (PROD.Sep24), 0))
                      + (isnull (sum (PROD.Oct24), 0)))
                   / 6
                WHEN month (getdate ()) = 12 AND year (getdate ()) = 2024
                THEN
                     (  (isnull (sum (PROD.Jun24), 0))
                      + (isnull (sum (PROD.Jul24), 0))
                      + (isnull (sum (PROD.Ago24), 0))
                      + (isnull (sum (PROD.Sep24), 0))
                      + (isnull (sum (PROD.Oct24), 0))
                      + (isnull (sum (PROD.Nov24), 0)))
                   / 6
             /*(month(getdate())-1)*/
             END AS Promedio,
             isnull (sum (ALMA.[200]), 0) AS [200],
             isnull (sum (ALMA.[001]), 0) AS [001],
             isnull (sum (ALMA.[002]), 0) AS [002],
             isnull (sum (ALMA.[100]), 0) AS [100],
             isnull (sum (ALMA.[101]), 0) AS [101],
             isnull (sum (ALMA.[003]), 0) AS [003],
			isnull (sum (ALMA.[102]), 0) AS [102],
			isnull (sum (ALMA.[203]), 0) AS [203],
			isnull (sum (ALMA.[103]), 0) AS [103],
			isnull (sum (ALMA.[104]), 0) AS [104],
			isnull (sum (ALMA.[105]), 0) AS [105],
			isnull (sum (ALMA.[106]), 0) AS [106],
			isnull (sum (ALMA.[107]), 0) AS [107],
			isnull (sum (ALMA.[108]), 0) AS [108],
			isnull (sum (ALMA.[109]), 0) AS [109],
             --Inventario fisico
             (  isnull (sum (ALMA.[200]), 0)   
              + isnull (sum (ALMA.[001]), 0)
              + isnull (sum (ALMA.[002]), 0)
              + isnull (sum (ALMA.[100]), 0)
              + isnull (sum (ALMA.[101]), 0)
			  + isnull (sum (ALMA.[003]), 0) 
			+isnull (sum (ALMA.[102]), 0) 
			+isnull (sum (ALMA.[203]), 0) 
			+isnull (sum (ALMA.[103]), 0) 
			+isnull (sum (ALMA.[104]), 0) 
			+isnull (sum (ALMA.[105]), 0) 
			+isnull (sum (ALMA.[106]), 0) 
			+isnull (sum (ALMA.[107]), 0) 
			+isnull (sum (ALMA.[108]), 0) 
			+isnull (sum (ALMA.[109]), 0) 
              ) AS InventarioFisico,
             --case when [CodMedicamento] is not null then 'Medicamento'
             --     else 'Insumo' end as Tipo,
             avg (ALMA.CostoPromedio) AS CostoPromedio,
               --count(Cod_Producto) as Hijos,
               --Case when SUM(Prod.Jun21)>0 then 1 else 0 end+
               CASE WHEN SUM (Prod.Feb24) > 0 THEN 1 ELSE 0 END
             + CASE WHEN SUM (Prod.Mar24) > 0 THEN 1 ELSE 0 END
             + CASE WHEN SUM (Prod.Abr24) > 0 THEN 1 ELSE 0 END
             + CASE WHEN SUM (Prod.May24) > 0 THEN 1 ELSE 0 END
             + CASE WHEN SUM (Prod.Jun24) > 0 THEN 1 ELSE 0 END
             + CASE WHEN SUM (Prod.Jul24) > 0 THEN 1 ELSE 0 END AS Rotacion --+
                                                                           --Case when @Jul>0 then 1 else 0  end,
                                                                           ,
             Hijos
      FROM (SELECT 
                    isnull (sum (PROD.Ene23), 0) AS Ene23,
                   isnull (sum (PROD.Feb23), 0) AS Feb23,
                   isnull (sum (PROD.Mar23), 0) AS Mar23,
                   isnull (sum (PROD.Abr23), 0) AS Abr23,
                   isnull (sum (PROD.May23), 0) AS May23,
                   isnull (sum (PROD.Jun23), 0) AS Jun23,
                   isnull (sum (PROD.Jul23), 0) AS Jul23,
                   isnull (sum (PROD.Ago23), 0) AS Ago23,
                   isnull (sum (PROD.Sep23), 0) AS Sep23,
                   isnull (sum (PROD.Oct23), 0) AS Oct23,
                   isnull (sum (PROD.Nov23), 0) AS Nov23,
                   isnull (sum (PROD.Dic23), 0) AS Dic23,
                   
				   isnull (sum (PROD.Ene24), 0) AS Ene24,
                   isnull (sum (PROD.Feb24), 0) AS Feb24,
                   isnull (sum (PROD.Mar24), 0) AS Mar24,
                   isnull (sum (PROD.Abr24), 0) AS Abr24,
                   isnull (sum (PROD.May24), 0) AS May24,
                   isnull (sum (PROD.Jun24), 0) AS Jun24,
                   isnull (sum (PROD.Jul24), 0) AS Jul24,
                   isnull (sum (PROD.Ago24), 0) AS Ago24,
                   isnull (sum (PROD.Sep24), 0) AS Sep24,
                   isnull (sum (PROD.Oct24), 0) AS Oct24,
                   isnull (sum (PROD.Nov24), 0) AS Nov24,
                   isnull (sum (PROD.Dic24), 0) AS Dic24,
                   Sucursal,
                   Insumo,
                   [Código Agrupador],
                   [Agrupador],
                   count (distinct Cod_Producto) AS Hijos
            FROM (SELECT Ene23,
                         Feb23,
                         Mar23,
                         Abr23,
                         May23,
                         Jun23,
                         Jul23,
                         Ago23,
                         Sep23,
                         Oct23,
                         Nov23,
                         Dic23,
						 Ene24,
                         Feb24,
                         Mar24,
                         Abr24,
                         May24,
                         Jun24,
                         Jul24,
                         Ago24,
                         Sep24,
                         Oct24,
                         Nov24,
                         Dic24,
                         Sucursal,
                         Insumo,
                         Cod_Producto,
                         [Código Agrupador],
                         [Agrupador]
                  FROM [ViewInternal].[IMO_AD_Inventory_Inferido_Inventario_Producto_2024]
                       AS PROD) AS PROD
            --WHERE [Código Agrupador]='01090'
            GROUP BY Sucursal,
                     Insumo,
                     [Código Agrupador],
                     [Agrupador]) AS PROD
           LEFT OUTER JOIN
           (SELECT isnull (sum ([200]), 0) AS [200],
                   isnull (sum ([001]), 0) AS [001],
                   isnull (sum ([002]), 0) AS [002],
                   isnull (sum ([100]), 0) AS [100],
				   isnull (sum ([101]), 0) AS [101],
				   isnull (sum ([003]), 0) AS [003],
				   isnull (sum ([102]), 0) AS [102],
				   isnull (sum ([203]), 0) AS [203],
				   isnull (sum ([103]), 0) AS [103],
				   isnull (sum ([104]), 0) AS [104],
				   isnull (sum ([105]), 0) AS [105],
				   isnull (sum ([106]), 0) AS [106],
				   isnull (sum ([107]), 0) AS [107],
				   isnull (sum ([108]), 0) AS [108],
				   isnull (sum ([109]), 0) AS [109],
                   
                   AVG (alma.costopromedio) AS CostoPromedio,
                   [Código Agrupador]
            FROM (SELECT [200], [001],[002],[100],[101],
			[003],[102],[203],[103],[104],[105],[106],[107],
[108],[109],
                         CostoPromedio,
                         [Código Agrupador]
                  FROM [ViewInternal].[IMO_AD_Inventory_AlmacenesPivot]
                       AS ALMA) AS ALMA --ON ALMA.[Código Agrupador] = PROD.[Código Agrupador]
            --WHERE ALMA.[Código Agrupador]='01090'
            GROUP BY [Código Agrupador]) AS ALMA
              ON ALMA.[Código Agrupador] = PROD.[Código Agrupador]
      --left outer join vie12.Inventory.ATC as atc on atc.code=prod.[CodMedicamento]
      -- WHERE PROD.[Código Agrupador]='01090'
      GROUP BY PROD.Sucursal,
               PROD.[Código Agrupador],
               [Agrupador],
               Hijos) AS A
WHERE Producto IS NOT NULL
