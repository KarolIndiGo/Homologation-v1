-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_SaldoInventario
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_SaldoInventario]
AS
     SELECT *
     FROM
     (
         SELECT PR.Id AS IDPr, 
                pr.Code AS Código, 
                pr.Name AS Producto, 
                TP.Name AS [TipoProducto], 
                Med.Code AS [Cod Med], 
                Med.Name AS Medicamento, 
                ATC.Code AS ATC, 
                ATC.Name AS NombreATC, 
                pr.CodeCUM AS CUM, 
                pr.CodeAlternativeTwo AS [CódigoAlterno2], 
                sg.Name AS SubGrupo, 
                ue.Abbreviation AS Unidad, 
                gf.Name AS [GrupoFacturación],
                CASE pr.ProductControl
                    WHEN '0'
                    THEN 'No'
                    WHEN '1'
                    THEN 'Si'
                END AS [ProdControl], 
                pr.ProductCost AS CostoPromedio, 
                pr.FinalProductCost AS Ultimocosto,
                CASE pr.ProductWithPriceControl
                    WHEN 0
                    THEN ''
                    WHEN 1
                    THEN 'SI'
                END AS Regulado,
                CASE pr.STATUS
                    WHEN '1'
                    THEN 'Activo'
                    WHEN '0'
                    THEN 'Inactivo'
                END AS Estado, 
                inf.Quantity AS Cantidad, 
                al.Code AS CodAlmacen
         FROM Inventory.InventoryProduct AS pr
              LEFT OUTER JOIN Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id
              LEFT OUTER JOIN Inventory.Warehouse AS al ON al.Id = inf.WarehouseId
              LEFT OUTER JOIN Inventory.ATC AS Med ON Med.Id = pr.ATCId
              LEFT OUTER JOIN Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
              LEFT OUTER JOIN Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId
              LEFT OUTER JOIN Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId
              LEFT JOIN Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id
              JOIN Inventory.ProductType TP ON PR.ProductTypeId = TP.Id
         WHERE al.code IN('001', '002', '003', '004', '005', '006', '007', '008', '009', '010')
              AND INF.Quantity > 0
     ) source PIVOT(SUM(Cantidad) FOR source.CodAlmacen IN([001], 
                                                           [002], 
                                                           [003], 
                                                           [004], 
                                                           [005], 
                                                           [006], 
                                                           [007], 
                                                           [008], 
                                                           [009], 
                                                           [010])) AS pivotable;
