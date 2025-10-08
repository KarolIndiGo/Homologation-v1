-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INVENTORY_INFERIDO_INVENTARIO_PRODUCTO_2022
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE   VIEW  ViewInternal.VW_IMO_AD_INVENTORY_INFERIDO_INVENTARIO_PRODUCTO_2022
AS

SELECT Sucursal, 
            Cod_Producto, 
            Producto, 
            --ATC, 
            --CodAlterno, 
            --CodSubgrupo, 
            CodMedicamento, 
			Cod_Insumo,
			Insumo,
			[Código Agrupador], 
			 [Agrupador],
            --CodigoCUM, 
            --TipoProducto, 
            --Homólgo, 
            --NombreHomólogo, 
           
			SUM(Ene22) AS Ene22, 
            SUM(Feb22) AS Feb22, 
            SUM(Mar22) AS Mar22, 
            SUM(Abr22) AS Abr22, 
            SUM(May22) AS May22, 
            SUM(Jun22) AS Jun22, 
            SUM(Jul22) AS Jul22, 
            SUM(Ago22) AS Ago22, 
            SUM(Sep22) AS Sep22, 
            SUM(Oct22) AS Oct22, 
            SUM(Nov22) AS Nov22, 
            SUM(Dic22) AS Dic22,
			SUM(Ene23) AS Ene23,
			SUM(Feb23) AS Feb23, 
            SUM(Mar23) AS Mar23, 
            SUM(Abr23) AS Abr23, 
            SUM(May23) AS May23, 
            SUM(Jun23) AS Jun23, 
            SUM(Jul23) AS Jul23, 
            SUM(Ago23) AS Ago23, 
            SUM(Sep23) AS Sep23, 
            SUM(Oct23) AS Oct23, 
            SUM(Nov23) AS Nov23, 
            SUM(Dic23) AS Dic23--, 
            --CASE MONTH(GETDATE())
            --    WHEN '1'
            --    THEN((ISNULL(Jul19, 0)) + (ISNULL(Ago19, 0)) + (ISNULL(Sep19, 0)) + (ISNULL(Oct19, 0)) + (ISNULL(Nov19, 0)) + (ISNULL(Dic19, 0))) / 6
            --    WHEN '2'
            --    THEN((ISNULL(Ene21, 0)) + (ISNULL(Ago19, 0)) + (ISNULL(Sep19, 0)) + (ISNULL(Oct19, 0)) + (ISNULL(Nov19, 0)) + (ISNULL(Dic19, 0))) / 6
            --    WHEN '3'
            --    THEN((ISNULL(Ene21, 0)) + (ISNULL(Dic19, 0)) + (ISNULL(Sep19, 0)) + (ISNULL(Oct19, 0)) + (ISNULL(Nov19, 0)) + (ISNULL(Feb21, 0))) / 6
            --    WHEN '4'
            --    THEN((ISNULL(Ene21, 0)) + (ISNULL(Dic19, 0)) + (ISNULL(Mar21, 0)) + (ISNULL(Oct19, 0)) + (ISNULL(Nov19, 0)) + (ISNULL(Feb21, 0))) / 6
            --    WHEN '5'
            --    THEN((ISNULL(Ene21, 0)) + (ISNULL(Dic19, 0)) + (ISNULL(Mar21, 0)) + (ISNULL(Abr21, 0)) + (ISNULL(Nov19, 0)) + (ISNULL(Feb21, 0))) / 6
            --    WHEN '6'
            --    THEN((ISNULL(Ene21, 0)) + (ISNULL(Dic19, 0)) + (ISNULL(Mar21, 0)) + (ISNULL(Abr21, 0)) + (ISNULL(May21, 0)) + (ISNULL(Feb21, 0))) / 6
            --    WHEN '7'
            --    THEN((ISNULL(Jun21, 0)) + (ISNULL(Ene21, 0)) + (ISNULL(Mar21, 0)) + (ISNULL(Abr21, 0)) + (ISNULL(May21, 0)) + (ISNULL(Feb21, 0))) / 6
            --    WHEN '8'
            --    THEN((ISNULL(Jul21, 0)) + (ISNULL(Jun21, 0)) + (ISNULL(Mar21, 0)) + (ISNULL(Abr21, 0)) + (ISNULL(May21, 0)) + (ISNULL(Feb21, 0))) / 6
            --    WHEN '9'
            --    THEN((ISNULL(Jul21, 0)) + (ISNULL(Ago21, 0)) + (ISNULL(Mar21, 0)) + (ISNULL(Abr21, 0)) + (ISNULL(May21, 0)) + (ISNULL(Jun21, 0))) / 6
            --    WHEN '10'
            --    THEN((ISNULL(Sep21, 0)) + (ISNULL(Ago21, 0)) + (ISNULL(Jun21, 0)) + (ISNULL(Abr21, 0)) + (ISNULL(May21, 0)) + (ISNULL(Jul21, 0))) / 6
            --    WHEN '11'
            --    THEN((ISNULL(Sep21, 0)) + (ISNULL(Ago21, 0)) + (ISNULL(Jun21, 0)) + (ISNULL(Oct21, 0)) + (ISNULL(May21, 0)) + (ISNULL(Jul21, 0))) / 6
            --    WHEN '12'
            --    THEN((ISNULL(Sep21, 0)) + (ISNULL(Ago21, 0)) + (ISNULL(Jun21, 0)) + (ISNULL(Oct21, 0)) + (ISNULL(Nov21, 0)) + (ISNULL(Jul21, 0))) / 6
            --END AS [Prom_Ulti_Semestre]
     FROM
     (
            
         --, 
         --            d.code
         SELECT UO.UnitName AS Sucursal,
                CASE
                  
                    WHEN(MONTH(D.DocumentDate)) = '1'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Ene22'
                    WHEN(MONTH(D.DocumentDate)) = '2'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Feb22'
                    WHEN(MONTH(D.DocumentDate)) = '3'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Mar22'
                    WHEN(MONTH(D.DocumentDate)) = '4'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Abr22'
                    WHEN(MONTH(D.DocumentDate)) = '5'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'May22'
                    WHEN(MONTH(D.DocumentDate)) = '6'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Jun22'
                    WHEN(MONTH(D.DocumentDate)) = '7'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Jul22'
                    WHEN(MONTH(D.DocumentDate)) = '8'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Ago22'
                    WHEN(MONTH(D.DocumentDate)) = '9'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Sep22'
                    WHEN(MONTH(D.DocumentDate)) = '10'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Oct22'
                    WHEN(MONTH(D.DocumentDate)) = '11'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Nov22'
                    WHEN(MONTH(D.DocumentDate)) = '12'
                        AND (YEAR(D.DocumentDate)) = '2022'
                    THEN 'Dic22'
					 WHEN(MONTH(D.DocumentDate)) = '1'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Ene23'
					WHEN(MONTH(D.DocumentDate)) = '2'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Feb23'
                    WHEN(MONTH(D.DocumentDate)) = '3'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Mar23'
                    WHEN(MONTH(D.DocumentDate)) = '4'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Abr23'
                    WHEN(MONTH(D.DocumentDate)) = '5'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'May23'
                    WHEN(MONTH(D.DocumentDate)) = '6'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Jun23'
                    WHEN(MONTH(D.DocumentDate)) = '7'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Jul23'
                    WHEN(MONTH(D.DocumentDate)) = '8'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Ago23'
                    WHEN(MONTH(D.DocumentDate)) = '9'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Sep23'
                    WHEN(MONTH(D.DocumentDate)) = '10'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Oct23'
                    WHEN(MONTH(D.DocumentDate)) = '11'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Nov23'
                    WHEN(MONTH(D.DocumentDate)) = '12'
                        AND (YEAR(D.DocumentDate)) = '2023'
                    THEN 'Dic23'
                END AS Mes, 
                pr.Code AS Cod_Producto, 
                pr.Name AS Producto, 
                --pr.CodeAlternative AS [ATC], 
                --pr.CodeAlternativeTwo AS [CodAlterno], 
                --sg.Code + ' - ' + sg.Name AS [CodSubgrupo], 
                catc.Code AS [CodMedicamento], 
				s.Code as Cod_Insumo,
				s.SupplieName as Insumo,
                --pr.CodeCUM AS [CodigoCUM],
                --CASE
                --    WHEN pr.POSProduct = '1'
                --    THEN 'POS'
                --    WHEN pr.POSProduct = '0'
                --    THEN 'No_POS'
                --END AS TipoProducto, 
                SUM(DI.Quantity - DI.ReturnedQuantity) AS Cantidad--, 
                --H.CodeAlternativeTwo AS Homólgo, 
                --H.name AS NombreHomólogo
				,  case when catc.Code is not null 
		   then catc.Code else s.Code end  AS [Código Agrupador], 
		   
		   case when catc.Name  is not null 
		   then catc.Name else s.SupplieName end  AS [Agrupador]
         FROM [INDIGO035].[Inventory].[PharmaceuticalDispensing] AS D
              INNER JOIN [INDIGO035].[Inventory].[PharmaceuticalDispensingDetail] AS DI
              INNER JOIN [INDIGO035].[Payroll].[FunctionalUnit] AS un  ON un.Id = DI.FunctionalUnitId
              INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS pr
              INNER JOIN [INDIGO035].[Inventory].[ProductSubGroup] AS sg  ON sg.Id = pr.ProductSubGroupId
                                                                  AND sg.Code <> 'OSTEO001'
                                                                  AND sg.Code <> 'PROTE001'
              LEFT OUTER JOIN [INDIGO035].[Inventory].[ATC] AS catc  ON catc.Id = pr.ATCId
			  left outer join [INDIGO035].[Inventory].[InventorySupplie] as s  on s.Id=pr.SupplieId
              --LEFT OUTER JOIN [ReportesMedi].dbo.HomólogosDiferidoInv AS H  ON H.CodeAlternativeTwo = pr.CodeAlternativeTwo
                                                                              --AND pr.Code = h.Code 
																			  ON pr.Id = DI.ProductId
                                                                                                      AND pr.Code NOT LIKE('800-%') ON DI.PharmaceuticalDispensingId = D.Id
                                                                                                                                       AND DI.WarehouseId <> '159'
                                                                                                                                       AND (DI.Quantity - DI.ReturnedQuantity <> '0')
              INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS I
              INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P  ON P.IPCODPACI = I.IPCODPACI ON I.NUMINGRES = D.AdmissionNumber
              INNER JOIN [INDIGO035].[Billing].[ServiceOrder] AS O  ON O.EntityCode = D.Code
              INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS UO  ON UO.Id = D.OperatingUnitId
         WHERE(D.DocumentDate >= '01/01/2022 00:00:00')
              AND (D.Status = '2')
             -- AND (D.OperatingUnitId = '1') and sg.code not in (select code from reportesmedi.dbo.ExcluidoInferido)
         GROUP BY UO.UnitName, 
                  (MONTH(D.DocumentDate)), 
                  pr.Code, 
                  pr.Name, 
                  --pr.CodeAlternative, 
                  --pr.CodeAlternativeTwo, 
                  --sg.Code, 
                  catc.Code, 
				  s.Code,
				  s.SupplieName,
                  --CodeCUM, 
                  --pr.POSProduct, 
                  sg.Code + ' - ' + sg.Name, 
                  YEAR(D.DocumentDate)--, 
                  --H.name, 
                  --H.CodeAlternativeTwo
         --, 
         --            d.code
		 ,catc.Name
         UNION ALL
                  SELECT UO.UnitName AS Sucursal,
                CASE
                   
                    WHEN(MONTH(DO.DocumentDate)) = '1'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Ene22'
                    WHEN(MONTH(DO.DocumentDate)) = '2'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Feb22'
                    WHEN(MONTH(DO.DocumentDate)) = '3'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Mar22'
                    WHEN(MONTH(DO.DocumentDate)) = '4'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Abr22'
                    WHEN(MONTH(DO.DocumentDate)) = '5'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'May22'
                    WHEN(MONTH(DO.DocumentDate)) = '6'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Jun22'
                    WHEN(MONTH(DO.DocumentDate)) = '7'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Jul22'
                    WHEN(MONTH(DO.DocumentDate)) = '8'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Ago22'
                    WHEN(MONTH(DO.DocumentDate)) = '9'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Sep22'
                    WHEN(MONTH(DO.DocumentDate)) = '10'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Oct22'
                    WHEN(MONTH(DO.DocumentDate)) = '11'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Nov22'
                    WHEN(MONTH(DO.DocumentDate)) = '12'
                        AND (YEAR(DO.DocumentDate)) = '2022'
                    THEN 'Dic22'
					 WHEN(MONTH(DO.DocumentDate)) = '1'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Ene23'
					WHEN(MONTH(DO.DocumentDate)) = '2'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Feb23'
                    WHEN(MONTH(DO.DocumentDate)) = '3'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Mar23'
                    WHEN(MONTH(DO.DocumentDate)) = '4'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Abr23'
                    WHEN(MONTH(DO.DocumentDate)) = '5'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'May23'
                    WHEN(MONTH(DO.DocumentDate)) = '6'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Jun23'
                    WHEN(MONTH(DO.DocumentDate)) = '7'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Jul23'
                    WHEN(MONTH(DO.DocumentDate)) = '8'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Ago23'
                    WHEN(MONTH(DO.DocumentDate)) = '9'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Sep23'
                    WHEN(MONTH(DO.DocumentDate)) = '10'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Oct23'
                    WHEN(MONTH(DO.DocumentDate)) = '11'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Nov23'
                    WHEN(MONTH(DO.DocumentDate)) = '12'
                        AND (YEAR(DO.DocumentDate)) = '2023'
                    THEN 'Dic23'
                END AS Mes, 
                pr.Code AS Cod_Producto, 
                pr.Name AS Producto, 
                --pr.CodeAlternative AS [ATC], 
                --pr.CodeAlternativeTwo AS [CodAlterno], 
                --sg.Code + ' - ' + sg.Name AS [CodSubgrupo], 
                catc.Code AS [CodMedicamento], 
				s.Code as Cod_Insumo,
				s.SupplieName as Insumo,
                --pr.CodeCUM AS [CodigoCUM],
                --CASE
                --    WHEN pr.POSProduct = '1'
                --    THEN 'POS'
                --    WHEN pr.POSProduct = '0'
                --    THEN 'No_POS'
                --END AS TipoProducto, 
                SUM(N.OutstandingQuantity) AS Cantidad--, 
                --H.CodeAlternativeTwo AS Homólgo, 
                --H.name AS NombreHomólogo
				,  case when catc.Code is not null 
		   then catc.Code else s.Code end  AS [Código Agrupador], 
		   
		   case when catc.Name  is not null 
		   then catc.Name else s.SupplieName end  AS [Agrupador]
         FROM [INDIGO035].[Inventory].[TransferOrder] AS DO
              INNER JOIN [INDIGO035].[Inventory].[TransferOrderDetail] AS DI
              INNER JOIN [INDIGO035].[Inventory].[TransferOrderDetailBatchSerial] AS N  ON N.TransferOrderDetailId = DI.Id ON DI.TransferOrderId = DO.Id
              INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS pr
              INNER JOIN [INDIGO035].[Inventory].[ProductSubGroup] AS sg  ON sg.Id = pr.ProductSubGroupId
                                                                  AND sg.Code <> 'OSTEO001'
                                                                  AND sg.Code <> 'PROTE001'
              --LEFT OUTER JOIN [ReportesMedi].dbo.HomólogosDiferidoInv AS H  ON H.CodeAlternativeTwo = pr.CodeAlternativeTwo
              --                                                                AND pr.Code = h.Code
              LEFT OUTER JOIN [INDIGO035].[Inventory].[ATC] AS catc  ON catc.Id = pr.ATCId ON pr.Id = DI.ProductId
                                                                                   AND pr.Code NOT LIKE('800-%')
			  
			  left outer join [INDIGO035].[Inventory].[InventorySupplie] as s  on s.Id=pr.SupplieId 

              INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS a  ON a.Id = DO.SourceWarehouseId
              INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS UO  ON UO.Id = DO.OperatingUnitId AND (N.OutstandingQuantity <> '0')
              LEFT OUTER JOIN [DataWareHouse_Finance].[ViewInternal].[VW_IMO_AD_INVENTORY_ALMACENES] AS infa  ON infa.Código = pr.Code
                                                                                           AND infa.CódigoAlmacén = a.Code
         WHERE(DO.DocumentDate >= '01/01/2022 00:00:00')
              AND (DO.Status = '2')
            --  AND (DO.OperatingUnitId = '1')
              AND DO.OrderType = '2'
              AND DO.SourceWarehouseId <> '159' --and sg.code not in (select code from reportesmedi.dbo.ExcluidoInferido)
         GROUP BY UO.UnitName, 
                  (MONTH(DO.DocumentDate)), 
                  pr.Code, 
                  pr.Name, 
                  --pr.CodeAlternative, 
                  --pr.CodeAlternativeTwo, 
                  --sg.Code, 
                  catc.Code, 
				  s.Code,
				  s.SupplieName,
                  --PR.CodeCUM, 
                  --pr.POSProduct, 
                  sg.Code + ' - ' + sg.Name, 
                  YEAR(DO.DocumentDate), 
                  infa.CostoPromedio, 
                  infa.Ultimocosto, 
                  infa.Cantidad, 
                  --infa.Unidad--, 
                  --H.name, 
                  --H.CodeAlternativeTwo
				  catc.Name
     ) source PIVOT(SUM(Cantidad) FOR source.Mes IN(
                                                   Ene22,
													Feb22, 
                                                    Mar22, 
                                                    Abr22, 
                                                    May22, 
                                                    Jun22, 
                                                    Jul22, 
                                                    Ago22, 
                                                    Sep22, 
                                                    Oct22, 
                                                    Nov22, 
                                                    Dic22,
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
                                                    Dic23)) AS pivotable
     GROUP BY pivotable.Sucursal, 
              pivotable.Cod_Producto, 
              pivotable.Producto, 
              --pivotable.ATC, 
              --pivotable.CodAlterno, 
              --pivotable.CodSubgrupo, 
              pivotable.CodMedicamento,
			  pivotable.Cod_Insumo,
			  pivotable.Insumo, 
			  			pivotable.[Código Agrupador], 
						pivotable.[Agrupador],
              --pivotable.CodigoCUM, 
              --pivotable.TipoProducto, 
              --pivotable.Homólgo, 
              --pivotable.NombreHomólogo, 
             
			
                Ene22,
                Feb22, 
                Mar22, 
                Abr22, 
                May22, 
                Jun22, 
                Jul22, 
                Ago22, 
                Sep22, 
                Oct22, 
                Nov22, 
                Dic22,
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
                Dic23;



