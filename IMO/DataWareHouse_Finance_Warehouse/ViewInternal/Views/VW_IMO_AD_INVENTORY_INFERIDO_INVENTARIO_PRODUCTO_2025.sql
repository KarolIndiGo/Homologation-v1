-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INVENTORY_INFERIDO_INVENTARIO_PRODUCTO_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_AD_INVENTORY_INFERIDO_INVENTARIO_PRODUCTO_2025
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
           
			SUM(Ene24) AS Ene24, 
            SUM(Feb24) AS Feb24, 
            SUM(Mar24) AS Mar24, 
            SUM(Abr24) AS Abr24, 
            SUM(May24) AS May24, 
            SUM(Jun24) AS Jun24, 
            SUM(Jul24) AS Jul24, 
            SUM(Ago24) AS Ago24, 
            SUM(Sep24) AS Sep24, 
            SUM(Oct24) AS Oct24, 
            SUM(Nov24) AS Nov24, 
            SUM(Dic24) AS Dic24,
			SUM(Ene25) AS Ene25,
			SUM(Feb25) AS Feb25, 
            SUM(Mar25) AS Mar25, 
            SUM(Abr25) AS Abr25, 
            SUM(May25) AS May25, 
            SUM(Jun25) AS Jun25, 
            SUM(Jul25) AS Jul25, 
            SUM(Ago25) AS Ago25, 
            SUM(Sep25) AS Sep25, 
            SUM(Oct25) AS Oct25, 
            SUM(Nov25) AS Nov25, 
            SUM(Dic25) AS Dic25--, 
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
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Ene24'
                    WHEN(MONTH(D.DocumentDate)) = '2'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Feb24'
                    WHEN(MONTH(D.DocumentDate)) = '3'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Mar24'
                    WHEN(MONTH(D.DocumentDate)) = '4'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Abr24'
                    WHEN(MONTH(D.DocumentDate)) = '5'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'May24'
                    WHEN(MONTH(D.DocumentDate)) = '6'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Jun24'
                    WHEN(MONTH(D.DocumentDate)) = '7'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Jul24'
                    WHEN(MONTH(D.DocumentDate)) = '8'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Ago24'
                    WHEN(MONTH(D.DocumentDate)) = '9'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Sep24'
                    WHEN(MONTH(D.DocumentDate)) = '10'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Oct24'
                    WHEN(MONTH(D.DocumentDate)) = '11'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Nov24'
                    WHEN(MONTH(D.DocumentDate)) = '12'
                        AND (YEAR(D.DocumentDate)) = '2024'
                    THEN 'Dic24'
					 WHEN(MONTH(D.DocumentDate)) = '1'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Ene25'
					WHEN(MONTH(D.DocumentDate)) = '2'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Feb25'
                    WHEN(MONTH(D.DocumentDate)) = '3'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Mar25'
                    WHEN(MONTH(D.DocumentDate)) = '4'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Abr25'
                    WHEN(MONTH(D.DocumentDate)) = '5'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'May25'
                    WHEN(MONTH(D.DocumentDate)) = '6'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Jun25'
                    WHEN(MONTH(D.DocumentDate)) = '7'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Jul25'
                    WHEN(MONTH(D.DocumentDate)) = '8'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Ago25'
                    WHEN(MONTH(D.DocumentDate)) = '9'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Sep25'
                    WHEN(MONTH(D.DocumentDate)) = '10'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Oct25'
                    WHEN(MONTH(D.DocumentDate)) = '11'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Nov25'
                    WHEN(MONTH(D.DocumentDate)) = '12'
                        AND (YEAR(D.DocumentDate)) = '2025'
                    THEN 'Dic25'
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
         WHERE(D.DocumentDate >= '01/01/2024 00:00:00')
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
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Ene24'
                    WHEN(MONTH(DO.DocumentDate)) = '2'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Feb24'
                    WHEN(MONTH(DO.DocumentDate)) = '3'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Mar24'
                    WHEN(MONTH(DO.DocumentDate)) = '4'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Abr24'
                    WHEN(MONTH(DO.DocumentDate)) = '5'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'May24'
                    WHEN(MONTH(DO.DocumentDate)) = '6'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Jun24'
                    WHEN(MONTH(DO.DocumentDate)) = '7'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Jul24'
                    WHEN(MONTH(DO.DocumentDate)) = '8'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Ago24'
                    WHEN(MONTH(DO.DocumentDate)) = '9'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Sep24'
                    WHEN(MONTH(DO.DocumentDate)) = '10'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Oct24'
                    WHEN(MONTH(DO.DocumentDate)) = '11'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Nov24'
                    WHEN(MONTH(DO.DocumentDate)) = '12'
                        AND (YEAR(DO.DocumentDate)) = '2024'
                    THEN 'Dic24'
					 WHEN(MONTH(DO.DocumentDate)) = '1'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Ene25'
					WHEN(MONTH(DO.DocumentDate)) = '2'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Feb25'
                    WHEN(MONTH(DO.DocumentDate)) = '3'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Mar25'
                    WHEN(MONTH(DO.DocumentDate)) = '4'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Abr25'
                    WHEN(MONTH(DO.DocumentDate)) = '5'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'May25'
                    WHEN(MONTH(DO.DocumentDate)) = '6'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Jun25'
                    WHEN(MONTH(DO.DocumentDate)) = '7'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Jul25'
                    WHEN(MONTH(DO.DocumentDate)) = '8'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Ago25'
                    WHEN(MONTH(DO.DocumentDate)) = '9'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Sep25'
                    WHEN(MONTH(DO.DocumentDate)) = '10'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Oct25'
                    WHEN(MONTH(DO.DocumentDate)) = '11'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Nov25'
                    WHEN(MONTH(DO.DocumentDate)) = '12'
                        AND (YEAR(DO.DocumentDate)) = '2025'
                    THEN 'Dic25'
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
              INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS UO  ON UO.Id = DO.OperatingUnitId
                                                             AND (N.OutstandingQuantity <> '0')
              LEFT OUTER JOIN ViewInternal.VW_IMO_AD_INVENTORY_ALMACENES AS infa  ON infa.Código = pr.Code
                                                                                           AND infa.CódigoAlmacén = a.Code
         WHERE(DO.DocumentDate >= '01/01/2024 00:00:00')
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
     ) source PIVOT(SUM(Cantidad) FOR Mes IN(
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
													Ene25,
													Feb25, 
                                                    Mar25, 
                                                    Abr25, 
                                                    May25, 
                                                    Jun25, 
                                                    Jul25, 
                                                    Ago25, 
                                                    Sep25, 
                                                    Oct25, 
                                                    Nov25, 
                                                    Dic25)) AS pivotable
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
													Ene25,
													Feb25, 
                                                    Mar25, 
                                                    Abr25, 
                                                    May25, 
                                                    Jun25, 
                                                    Jul25, 
                                                    Ago25, 
                                                    Sep25, 
                                                    Oct25, 
                                                    Nov25, 
                                                    Dic25;