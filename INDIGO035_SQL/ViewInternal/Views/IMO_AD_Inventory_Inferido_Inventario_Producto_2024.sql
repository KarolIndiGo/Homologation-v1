-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_Inventory_Inferido_Inventario_Producto_2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0


     create VIEW [ViewInternal].[IMO_AD_Inventory_Inferido_Inventario_Producto_2024]
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
            SUM(Dic23) AS Dic23,
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
            SUM(Dic24) AS Dic24--, 
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
                END AS Mes, 
                pr.Code AS Cod_Producto, 
                pr.Name AS Producto, 
                --pr.CodeAlternative AS [ATC], 
                --pr.CodeAlternativeTwo AS [CodAlterno], 
                --sg.Code + ' - ' + sg.Name AS [CodSubgrupo], 
                catc.Code AS [CodMedicamento], 
				s.code as Cod_Insumo,
				s.suppliename as Insumo,
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
				,  case when catc.code is not null 
		   then catc.Code else s.code end  AS [Código Agrupador], 
		   
		   case when catc.Name  is not null 
		   then catc.name else s.SupplieName end  AS [Agrupador]
         FROM Inventory.PharmaceuticalDispensing AS D
              INNER JOIN Inventory.PharmaceuticalDispensingDetail AS DI
              INNER JOIN Payroll.FunctionalUnit AS un  ON un.Id = DI.FunctionalUnitId
              INNER JOIN Inventory.InventoryProduct AS pr
              INNER JOIN Inventory.ProductSubGroup AS sg  ON sg.Id = pr.ProductSubGroupId
                                                                  AND sg.code <> 'OSTEO001'
                                                                  AND sg.code <> 'PROTE001'
              LEFT OUTER JOIN Inventory.ATC AS catc  ON catc.Id = pr.ATCId
			  left outer join Inventory.InventorySupplie as s  on s.id=pr.SupplieId
              --LEFT OUTER JOIN [ReportesMedi].dbo.HomólogosDiferidoInv AS H  ON H.CodeAlternativeTwo = pr.CodeAlternativeTwo
                                                                              --AND pr.Code = h.Code 
																			  ON pr.Id = DI.ProductId
                                                                                                      AND pr.Code NOT LIKE('800-%') ON DI.PharmaceuticalDispensingId = D.Id
                                                                                                                                       AND DI.WarehouseId <> '159'
                                                                                                                                       AND (DI.Quantity - DI.ReturnedQuantity <> '0')
              INNER JOIN dbo.ADINGRESO AS I
              INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = I.IPCODPACI ON I.NUMINGRES = D.AdmissionNumber
              INNER JOIN Billing.ServiceOrder AS O  ON O.EntityCode = D.Code
              INNER JOIN Common.OperatingUnit AS UO  ON UO.Id = D.OperatingUnitId
         WHERE(D.DocumentDate >= '01/01/2023 00:00:00')
              AND (D.STATUS = '2')
             -- AND (D.OperatingUnitId = '1') and sg.code not in (select code from reportesmedi.dbo.ExcluidoInferido)
         GROUP BY UO.UnitName, 
                  (MONTH(D.DocumentDate)), 
                  pr.Code, 
                  pr.Name, 
                  --pr.CodeAlternative, 
                  --pr.CodeAlternativeTwo, 
                  --sg.Code, 
                  catc.Code, 
				  s.code,
				  s.suppliename,
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
                END AS Mes, 
                pr.Code AS Cod_Producto, 
                pr.Name AS Producto, 
                --pr.CodeAlternative AS [ATC], 
                --pr.CodeAlternativeTwo AS [CodAlterno], 
                --sg.Code + ' - ' + sg.Name AS [CodSubgrupo], 
                catc.Code AS [CodMedicamento], 
				s.code as Cod_Insumo,
				s.suppliename as Insumo,
                --pr.CodeCUM AS [CodigoCUM],
                --CASE
                --    WHEN pr.POSProduct = '1'
                --    THEN 'POS'
                --    WHEN pr.POSProduct = '0'
                --    THEN 'No_POS'
                --END AS TipoProducto, 
                SUM(n.OutstandingQuantity) AS Cantidad--, 
                --H.CodeAlternativeTwo AS Homólgo, 
                --H.name AS NombreHomólogo
				,  case when catc.code is not null 
		   then catc.Code else s.code end  AS [Código Agrupador], 
		   
		   case when catc.Name  is not null 
		   then catc.name else s.SupplieName end  AS [Agrupador]
         FROM Inventory.TransferOrder AS DO
              INNER JOIN Inventory.TransferOrderDetail AS DI
              INNER JOIN Inventory.TransferOrderDetailBatchSerial AS N  ON N.TransferOrderDetailId = DI.ID ON DI.TransferOrderId = DO.Id
              INNER JOIN Inventory.InventoryProduct AS pr
              INNER JOIN Inventory.ProductSubGroup AS sg  ON sg.Id = pr.ProductSubGroupId
                                                                  AND sg.code <> 'OSTEO001'
                                                                  AND sg.code <> 'PROTE001'
              --LEFT OUTER JOIN [ReportesMedi].dbo.HomólogosDiferidoInv AS H  ON H.CodeAlternativeTwo = pr.CodeAlternativeTwo
              --                                                                AND pr.Code = h.Code
              LEFT OUTER JOIN Inventory.ATC AS catc  ON catc.Id = pr.ATCId ON pr.Id = DI.ProductId
                                                                                   AND pr.Code NOT LIKE('800-%')
			  
			  left outer join Inventory.InventorySupplie as s  on s.id=pr.SupplieId 

              INNER JOIN Inventory.Warehouse AS a  ON a.Id = DO.SourceWarehouseId
              INNER JOIN Common.OperatingUnit AS UO  ON UO.Id = DO.OperatingUnitId
                                                             AND (n.OutstandingQuantity <> '0')
              LEFT OUTER JOIN ViewInternal.IMO_AD_Inventory_Almacenes AS infa  ON infa.Código = pr.Code
                                                                                           AND infa.CódigoAlmacén = a.Code
         WHERE(DO.DocumentDate >= '01/01/2023 00:00:00')
              AND (DO.STATUS = '2')
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
				  s.code,
				  s.suppliename,
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
     ) source PIVOT(SUM(Cantidad) FOR SOURCE.Mes IN(
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
                                                    Dic24)) AS pivotable
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
                                                    Dic24;