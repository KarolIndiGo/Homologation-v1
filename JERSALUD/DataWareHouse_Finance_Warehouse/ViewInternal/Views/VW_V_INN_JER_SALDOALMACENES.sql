-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_JER_SALDOALMACENES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_JER_SALDOALMACENES AS

SELECT *
    FROM
    (
        SELECT PR.Id AS IDPr,
               CASE al.Id
                   WHEN '18' THEN 'TUNJA'
                   WHEN '19' THEN 'DUITAMA'
                   WHEN '20' THEN 'SOGAMOSO'
                   WHEN '21' THEN 'CHIQUINQUIRA'
                   WHEN '22' THEN 'GUATEQUE'
                   WHEN '23' THEN 'GARAGOA'
                   WHEN '24' THEN 'SOATA'
                   WHEN '25' THEN 'MONIQUIRA'
                   WHEN '26' THEN 'VILLAVICENCIO'
                   WHEN '27' THEN 'ACACIAS'
                   WHEN '28' THEN 'GRANADA'
                   WHEN '29' THEN 'PUERTO LOPEZ'
                   WHEN '30' THEN 'PUERTO GAITAN'
                   WHEN '31' THEN 'YOPAL'
                   WHEN '32' THEN 'TUNJA'
                   WHEN '34' THEN 'PUERTO BOYACA'
                   WHEN '35' THEN 'VILLAVICENCIO'
                   WHEN '36' THEN 'VILLAVICENCIO'
                   WHEN '37' THEN 'YOPAL'
                   WHEN '3'  THEN 'BOGOTA'
               END AS Sede,
               PR.Code AS Codigo,
               PR.Name AS Producto,
               TP.Name AS [TipoProducto],
               Med.Code AS [Cod Med],
               Med.Name AS Medicamento,
               ins.Code AS Cod_Insumo,
               ins.SupplieName AS Insumo,
               PR.Abbreviation AS Abreviatura,
               ATC.Code AS ATC,
               ATC.Name AS NombreATC,
               PR.CodeCUM AS CUM,
               PR.CodeAlternativeTwo AS [CodigoAlterno2],
               sg.Name AS SubGrupo,
               ue.Name AS UnidadEmpaque,
               ue.Abbreviation AS FactorConversion,
               gf.Name AS [GrupoFacturacion],
               CASE PR.ProductControl
                   WHEN '0' THEN 'No'
                   WHEN '1' THEN 'Si'
               END AS [ProdControl],
               PR.ProductCost AS CostoPromedio,
               PR.FinalProductCost AS Ultimocosto,
               CASE PR.ProductWithPriceControl
                   WHEN 0 THEN ''
                   WHEN 1 THEN 'SI'
               END AS Regulado,
               CASE PR.Status
                   WHEN '1' THEN 'Activo'
                   WHEN '0' THEN 'Inactivo'
               END AS Estado,
               INF.Quantity AS Cantidad,
               al.Code AS CodAlmacen,
               CASE Med.HighCost
                   WHEN 0 THEN 'NO'
                   WHEN 1 THEN 'SI'
               END AS AltoCosto,
               F.Name AS Fabricante
        FROM INDIGO031.Inventory.InventoryProduct AS PR
             LEFT OUTER JOIN INDIGO031.Inventory.PhysicalInventory AS INF ON INF.ProductId = PR.Id
             LEFT OUTER JOIN INDIGO031.Inventory.Warehouse AS al ON al.Id = INF.WarehouseId
             LEFT OUTER JOIN INDIGO031.Inventory.ATC AS Med ON Med.Id = PR.ATCId
             LEFT OUTER JOIN INDIGO031.Inventory.InventorySupplie AS ins ON ins.Id = PR.SupplieId
             LEFT JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = PR.ProductSubGroupId
             LEFT OUTER JOIN INDIGO031.Inventory.PackagingUnit AS ue ON ue.Id = PR.PackagingUnitId
             LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS gf ON gf.Id = PR.BillingGroupId
             LEFT JOIN INDIGO031.Inventory.ATCEntity AS ATC ON Med.ATCEntityId = ATC.Id
             JOIN INDIGO031.Inventory.ProductType AS TP ON PR.ProductTypeId = TP.Id
             INNER JOIN INDIGO031.Inventory.Manufacturer AS F ON F.Id = PR.ManufacturerId
        WHERE al.Code IN (
            'PTG001','CHQ001','YPL001','RME100','MRS001','MQR001','PTL001','GRG001','RCA100','STA001','ACB001','TJA001','VCO001','ACM001','VIN001','AGZ001','ACC001','SMT001','GTQ001',
            'GND001','DUI001','PDA001','PBY001','TJA100','ACA001','SOG001'
        )
        AND INF.Quantity > 0
    ) source
    PIVOT (
        SUM(Cantidad) FOR source.CodAlmacen IN (
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
        )
    ) AS pivotable;