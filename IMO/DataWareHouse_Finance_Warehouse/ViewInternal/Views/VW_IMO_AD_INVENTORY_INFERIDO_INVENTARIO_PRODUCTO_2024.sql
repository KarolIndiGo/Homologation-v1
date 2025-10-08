-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INVENTORY_INFERIDO_INVENTARIO_PRODUCTO_2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_AD_INVENTORY_INFERIDO_INVENTARIO_PRODUCTO_2024
AS 

SELECT 
    Sucursal, 
    Cod_Producto, 
    Producto, 
    CodMedicamento, 
    Cod_Insumo,
    Insumo,
    [Código Agrupador], 
    [Agrupador],
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
    SUM(Dic24) AS Dic24
FROM
(
    SELECT 
        UO.UnitName AS Sucursal,
        CASE
            WHEN (MONTH(D.DocumentDate)) = '1' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Ene23'
            WHEN (MONTH(D.DocumentDate)) = '2' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Feb23'
            WHEN (MONTH(D.DocumentDate)) = '3' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Mar23'
            WHEN (MONTH(D.DocumentDate)) = '4' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Abr23'
            WHEN (MONTH(D.DocumentDate)) = '5' AND (YEAR(D.DocumentDate)) = '2023' THEN 'May23'
            WHEN (MONTH(D.DocumentDate)) = '6' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Jun23'
            WHEN (MONTH(D.DocumentDate)) = '7' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Jul23'
            WHEN (MONTH(D.DocumentDate)) = '8' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Ago23'
            WHEN (MONTH(D.DocumentDate)) = '9' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Sep23'
            WHEN (MONTH(D.DocumentDate)) = '10' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Oct23'
            WHEN (MONTH(D.DocumentDate)) = '11' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Nov23'
            WHEN (MONTH(D.DocumentDate)) = '12' AND (YEAR(D.DocumentDate)) = '2023' THEN 'Dic23'
            WHEN (MONTH(D.DocumentDate)) = '1' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Ene24'
            WHEN (MONTH(D.DocumentDate)) = '2' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Feb24'
            WHEN (MONTH(D.DocumentDate)) = '3' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Mar24'
            WHEN (MONTH(D.DocumentDate)) = '4' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Abr24'
            WHEN (MONTH(D.DocumentDate)) = '5' AND (YEAR(D.DocumentDate)) = '2024' THEN 'May24'
            WHEN (MONTH(D.DocumentDate)) = '6' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Jun24'
            WHEN (MONTH(D.DocumentDate)) = '7' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Jul24'
            WHEN (MONTH(D.DocumentDate)) = '8' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Ago24'
            WHEN (MONTH(D.DocumentDate)) = '9' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Sep24'
            WHEN (MONTH(D.DocumentDate)) = '10' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Oct24'
            WHEN (MONTH(D.DocumentDate)) = '11' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Nov24'
            WHEN (MONTH(D.DocumentDate)) = '12' AND (YEAR(D.DocumentDate)) = '2024' THEN 'Dic24'
        END AS Mes, 
        pr.Code AS Cod_Producto, 
        pr.Name AS Producto, 
        catc.Code AS [CodMedicamento], 
        s.Code AS Cod_Insumo,
        s.SupplieName AS Insumo,
        SUM(DI.Quantity - DI.ReturnedQuantity) AS Cantidad,
        CASE WHEN catc.Code IS NOT NULL THEN catc.Code ELSE s.Code END AS [Código Agrupador], 
        CASE WHEN catc.Name IS NOT NULL THEN catc.Name ELSE s.SupplieName END AS [Agrupador]
    FROM 
        [INDIGO035].[Inventory].[PharmaceuticalDispensing] AS D
        INNER JOIN [INDIGO035].[Inventory].[PharmaceuticalDispensingDetail] AS DI ON DI.PharmaceuticalDispensingId = D.Id
        INNER JOIN [INDIGO035].[Payroll].[FunctionalUnit] AS un ON un.Id = DI.FunctionalUnitId
        INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS pr ON pr.Id = DI.ProductId
        INNER JOIN [INDIGO035].[Inventory].[ProductSubGroup] AS sg ON sg.Id = pr.ProductSubGroupId
            AND sg.Code <> 'OSTEO001'
            AND sg.Code <> 'PROTE001'
        LEFT OUTER JOIN [INDIGO035].[Inventory].[ATC] AS catc ON catc.Id = pr.ATCId
        LEFT OUTER JOIN [INDIGO035].[Inventory].[InventorySupplie] AS s ON s.Id = pr.SupplieId
        INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS I ON I.NUMINGRES = D.AdmissionNumber
        INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = I.IPCODPACI
        INNER JOIN [INDIGO035].[Billing].[ServiceOrder] AS O ON O.EntityCode = D.Code
        INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS UO ON UO.Id = D.OperatingUnitId
    WHERE 
        (D.DocumentDate >= '01/01/2023 00:00:00')
        AND (D.Status = '2')
        AND DI.WarehouseId <> '159'
        AND (DI.Quantity - DI.ReturnedQuantity <> '0')
        AND pr.Code NOT LIKE('800-%')
    GROUP BY 
        UO.UnitName, 
        (MONTH(D.DocumentDate)), 
        pr.Code, 
        pr.Name, 
        catc.Code, 
        s.Code,
        s.SupplieName,
        sg.Code + ' - ' + sg.Name, 
        YEAR(D.DocumentDate),
        catc.Name

    UNION ALL

    SELECT 
        UO.UnitName AS Sucursal,
        CASE
            WHEN (MONTH(DO.DocumentDate)) = '1' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Ene23'
            WHEN (MONTH(DO.DocumentDate)) = '2' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Feb23'
            WHEN (MONTH(DO.DocumentDate)) = '3' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Mar23'
            WHEN (MONTH(DO.DocumentDate)) = '4' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Abr23'
            WHEN (MONTH(DO.DocumentDate)) = '5' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'May23'
            WHEN (MONTH(DO.DocumentDate)) = '6' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Jun23'
            WHEN (MONTH(DO.DocumentDate)) = '7' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Jul23'
            WHEN (MONTH(DO.DocumentDate)) = '8' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Ago23'
            WHEN (MONTH(DO.DocumentDate)) = '9' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Sep23'
            WHEN (MONTH(DO.DocumentDate)) = '10' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Oct23'
            WHEN (MONTH(DO.DocumentDate)) = '11' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Nov23'
            WHEN (MONTH(DO.DocumentDate)) = '12' AND (YEAR(DO.DocumentDate)) = '2023' THEN 'Dic23'
            WHEN (MONTH(DO.DocumentDate)) = '1' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Ene24'
            WHEN (MONTH(DO.DocumentDate)) = '2' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Feb24'
            WHEN (MONTH(DO.DocumentDate)) = '3' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Mar24'
            WHEN (MONTH(DO.DocumentDate)) = '4' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Abr24'
            WHEN (MONTH(DO.DocumentDate)) = '5' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'May24'
            WHEN (MONTH(DO.DocumentDate)) = '6' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Jun24'
            WHEN (MONTH(DO.DocumentDate)) = '7' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Jul24'
            WHEN (MONTH(DO.DocumentDate)) = '8' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Ago24'
            WHEN (MONTH(DO.DocumentDate)) = '9' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Sep24'
            WHEN (MONTH(DO.DocumentDate)) = '10' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Oct24'
            WHEN (MONTH(DO.DocumentDate)) = '11' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Nov24'
            WHEN (MONTH(DO.DocumentDate)) = '12' AND (YEAR(DO.DocumentDate)) = '2024' THEN 'Dic24'
        END AS Mes, 
        pr.Code AS Cod_Producto, 
        pr.Name AS Producto, 
        catc.Code AS [CodMedicamento], 
        s.Code AS Cod_Insumo,
        s.SupplieName AS Insumo,
        SUM(N.OutstandingQuantity) AS Cantidad,
        CASE WHEN catc.Code IS NOT NULL THEN catc.Code ELSE s.Code END AS [Código Agrupador], 
        CASE WHEN catc.Name IS NOT NULL THEN catc.Name ELSE s.SupplieName END AS [Agrupador]
    FROM 
        [INDIGO035].[Inventory].TransferOrder AS DO
        INNER JOIN [INDIGO035].[Inventory].[TransferOrderDetail] AS DI ON DI.TransferOrderId = DO.Id
        INNER JOIN [INDIGO035].[Inventory].[TransferOrderDetailBatchSerial] AS N ON N.TransferOrderDetailId = DI.Id
        INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS pr ON pr.Id = DI.ProductId
        INNER JOIN [INDIGO035].[Inventory].[ProductSubGroup] AS sg ON sg.Id = pr.ProductSubGroupId
            AND sg.Code <> 'OSTEO001'
            AND sg.Code <> 'PROTE001'
        LEFT OUTER JOIN [INDIGO035].[Inventory].[ATC] AS catc ON catc.Id = pr.ATCId
        LEFT OUTER JOIN [INDIGO035].[Inventory].[InventorySupplie] AS s ON s.Id = pr.SupplieId
        INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS a ON a.Id = DO.SourceWarehouseId
        INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS UO ON UO.Id = DO.OperatingUnitId
            AND (N.OutstandingQuantity <> '0')
        LEFT OUTER JOIN [DataWareHouse_Finance].[ViewInternal].[VW_IMO_AD_INVENTORY_ALMACENES] AS infa ON infa.Código = pr.Code AND infa.CódigoAlmacén = a.Code
    WHERE 
        (DO.DocumentDate >= '01/01/2023 00:00:00')
        AND (DO.Status = '2')
        AND DO.OrderType = '2'
        AND DO.SourceWarehouseId <> '159'
        AND pr.Code NOT LIKE('800-%')
    GROUP BY 
        UO.UnitName, 
        (MONTH(DO.DocumentDate)), 
        pr.Code, 
        pr.Name, 
        catc.Code, 
        s.Code,
        s.SupplieName,
        sg.Code + ' - ' + sg.Name, 
        YEAR(DO.DocumentDate), 
        infa.CostoPromedio, 
        infa.Ultimocosto, 
        infa.Cantidad, 
        catc.Name
) source
PIVOT (
    SUM(Cantidad) FOR source.Mes IN (
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
        Dic24
    )
) AS pivotable
GROUP BY 
    pivotable.Sucursal, 
    pivotable.Cod_Producto, 
    pivotable.Producto, 
    pivotable.CodMedicamento,
    pivotable.Cod_Insumo,
    pivotable.Insumo, 
    pivotable.[Código Agrupador], 
    pivotable.[Agrupador],
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