-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_SaldoInventarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[FQ45_V_INN_SaldoInventarios]
AS
SELECT *
FROM     (SELECT PR.Id AS IDPr, pr.Code AS Código, pr.Name AS Producto, TP.Name AS [TipoProducto], Med.Code AS [Cod Med], Med.Name AS Medicamento, /*ATC.Code AS ATC, ATC.Name AS NombreATC, */pr.CodeCUM AS CUM, 
                                    pr.CodeAlternativeTwo AS [CódigoAlterno2], sg.Name AS SubGrupo, ue.Abbreviation AS Unidad, gf.Name AS [GrupoFacturación], CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [ProdControl], 
                                    pr.ProductCost AS CostoPromedio, pr.FinalProductCost AS Ultimocosto, CASE pr.ProductWithPriceControl WHEN 0 THEN '' WHEN 1 THEN 'SI' END AS Regulado, 
                                    CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, inf.Quantity AS Cantidad, al.Code AS CodAlmacen
                  FROM      Inventory.InventoryProduct AS pr LEFT OUTER JOIN
                                    Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id LEFT OUTER JOIN
                                    Inventory.Warehouse AS al ON al.Id = inf.WarehouseId LEFT OUTER JOIN
                                    Inventory.ATC AS Med ON Med.Id = pr.ATCId LEFT OUTER JOIN
                                    Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId LEFT OUTER JOIN
                                    Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId LEFT OUTER JOIN
                                    Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId  JOIN
                                   /* Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id JOIN*/
                                    Inventory.ProductType TP ON PR.ProductTypeId = TP.Id
                  WHERE INF.Quantity > 0 ) 
				  source PIVOT (sum(Cantidad) FOR source.CodAlmacen IN ([0001], [0002], [0003], [0004], [0005],[0006], [0007], [0008], [0009],[0010],[0011],[0012],
				  [0013], [0014], [0015], [0016], [0017],[0018], [0019], [0020], [0021],[0022],[0023],[0024],
				  [0025], [0026], [0027], [0028], [0029],[0030], [0031], [0032], [0033],[0034])) AS pivotable
