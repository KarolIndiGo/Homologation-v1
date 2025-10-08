-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_INVENTARIO_ALMACENES
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_INVENTARIO_ALMACENES] AS
     SELECT *
     FROM
     (
         SELECT pr.Id AS IDPr, 
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
                CASE pr.Status
                    WHEN '1'
                    THEN 'Activo'
                    WHEN '0'
                    THEN 'Inactivo'
                END AS Estado, 
                inf.Quantity AS Cantidad, 
                al.Code AS CodAlmacen
         FROM INDIGO031.Inventory.InventoryProduct AS pr
              LEFT OUTER JOIN INDIGO031.Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id
              LEFT OUTER JOIN INDIGO031.Inventory.Warehouse AS al ON al.Id = inf.WarehouseId
              LEFT OUTER JOIN INDIGO031.Inventory.ATC AS Med ON Med.Id = pr.ATCId
              LEFT OUTER JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
              LEFT OUTER JOIN INDIGO031.Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId
              LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId
              LEFT JOIN INDIGO031.Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id
              JOIN INDIGO031.Inventory.ProductType TP ON pr.ProductTypeId = TP.Id
          WHERE al.Code IN (
'PTG001',
'CHQ001',
'YPL001',
'RME100',
'MRS001',
'MQR001',
'PTL001',
'GRG001',
'RCA100',
'STA001',
'ACB001',
'TJA001',
'VCO001',
'ACM001',
'VIN001',
'AGZ001',
'ACC001',
'SMT001',
'GTQ001',
'GND001',
'DUI001',
'PDA001',
'PBY001',
'TJA100',
'ACA001',
'SOG001'
)
              AND inf.Quantity > 0
     ) source PIVOT(SUM(Cantidad) FOR source.CodAlmacen IN(
[PTG001],
[CHQ001],
[YPL001],
[RME100],
[MRS001],
[MQR001],
[PTL001],
[GRG001],
[RCA100],
[STA001],
[ACB001],
[TJA001],
[VCO001],
[ACM001],
[VIN001],
[AGZ001],
[ACC001],
[SMT001],
[GTQ001],
[GND001],
[DUI001],
[PDA001],
[PBY001],
[TJA100],
[ACA001],
[SOG001]
)) AS pivotable;



