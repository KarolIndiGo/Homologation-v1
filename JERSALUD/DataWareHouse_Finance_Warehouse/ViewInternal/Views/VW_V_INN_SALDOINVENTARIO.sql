-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_SALDOINVENTARIO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_SALDOINVENTARIO AS

SELECT *
    FROM
    (
        SELECT PR.Id AS IDPr, 
               PR.Code AS Código, 
               PR.Name AS Producto, 
               TP.Name AS [TipoProducto], 
               Med.Code AS [Cod Med], 
               Med.Name AS Medicamento, 
               ATC.Code AS ATC, 
               ATC.Name AS NombreATC, 
               PR.CodeCUM AS CUM, 
               PR.CodeAlternativeTwo AS [CódigoAlterno2], 
               SG.Name AS SubGrupo, 
               UE.Abbreviation AS Unidad, 
               GF.Name AS [GrupoFacturación],
               CASE PR.ProductControl
                   WHEN '0'
                   THEN 'No'
                   WHEN '1'
                   THEN 'Si'
               END AS [ProdControl], 
               PR.ProductCost AS CostoPromedio, 
               PR.FinalProductCost AS Ultimocosto,
               CASE PR.ProductWithPriceControl
                   WHEN 0
                   THEN ''
                   WHEN 1
                   THEN 'SI'
               END AS Regulado,
               CASE PR.Status
                   WHEN '1'
                   THEN 'Activo'
                   WHEN '0'
                   THEN 'Inactivo'
               END AS Estado, 
               INF.Quantity AS Cantidad, 
               AL.Code AS CodAlmacen
        FROM INDIGO031.Inventory.InventoryProduct AS PR
             LEFT OUTER JOIN INDIGO031.Inventory.PhysicalInventory AS INF ON INF.ProductId = PR.Id
             LEFT OUTER JOIN INDIGO031.Inventory.Warehouse AS AL ON AL.Id = INF.WarehouseId
             LEFT OUTER JOIN INDIGO031.Inventory.ATC AS Med ON Med.Id = PR.ATCId
             LEFT OUTER JOIN INDIGO031.Inventory.ProductSubGroup AS SG ON SG.Id = PR.ProductSubGroupId
             LEFT OUTER JOIN INDIGO031.Inventory.PackagingUnit AS UE ON UE.Id = PR.PackagingUnitId
             LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS GF ON GF.Id = PR.BillingGroupId
             LEFT JOIN INDIGO031.Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id
             JOIN INDIGO031.Inventory.ProductType TP ON PR.ProductTypeId = TP.Id
        WHERE AL.Code IN('001', '002', '003', '004', '005', '006', '007', '008', '009', '010')
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