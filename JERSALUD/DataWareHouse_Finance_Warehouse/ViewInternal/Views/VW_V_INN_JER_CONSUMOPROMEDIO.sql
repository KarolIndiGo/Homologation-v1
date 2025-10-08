-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_JER_CONSUMOPROMEDIO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_JER_CONSUMOPROMEDIO AS

SELECT 
    Sede, 
    Cod_Producto, 
    Producto, 
    Cod_Med, 
    Medicamento, 
    Cod_Insumo, 
    Insumo, 
    CodSubgrupo, 
    CodATC, 
    ATC, 
    CodigoCUM, 
    TipoProducto, 
    GrupoFacturacion, 
    ProdControl,
    UnIdadEmpaque, 
    FactorConversion, 
    Abreviatura, 
    AltoCosto, 
    Fabricante,
    Ene_A, 
    Feb_A, 
    Mar_A, 
    Abr_A, 
    May_A, 
    Jun_A, 
    Jul_A, 
    Ago_A, 
    Sep_A, 
    Oct_A, 
    Nov_A, 
    Dic_A, 
    Ene_V, 
    Feb_V, 
    Mar_V, 
    Abr_V, 
    May_V, 
    Jun_V, 
    Jul_V, 
    Ago_V, 
    Sep_V, 
    Oct_V, 
    Nov_V, 
    Dic_V, 
    CASE month(getdate()) 
        WHEN '1' THEN ((ISNULL(Jul_A, 0) + ISNULL(Ago_A, 0) + ISNULL(Sep_A, 0) + ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0))) / 6
        WHEN '2' THEN ((ISNULL(Ago_A, 0) + ISNULL(Sep_A, 0) + ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0))) / 6
        WHEN '3' THEN ((ISNULL(Sep_A, 0) + ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0))) / 6
        WHEN '4' THEN ((ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0))) / 6
        WHEN '5' THEN ((ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0))) / 6
        WHEN '6' THEN ((ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0))) / 6
        WHEN '7' THEN ((ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0))) / 6
        WHEN '8' THEN ((ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0))) / 6
        WHEN '9' THEN ((ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0))) / 6
        WHEN '10' THEN ((ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0) + ISNULL(Sep_V, 0))) / 6
        WHEN '11' THEN ((ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0) + ISNULL(Sep_V, 0) + ISNULL(Oct_V, 0))) / 6
        WHEN '12' THEN ((ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0) + ISNULL(Sep_V, 0) + ISNULL(Oct_V, 0) + ISNULL(Nov_V, 0))) / 6
    END AS [Prom_Ulti_Semestre],
    Estado, 
    CostoPromedio,  
    Grupo
FROM   
(
    SELECT DISTINCT 
        UO.UnitName AS Sede, 
        CASE 
            WHEN (MONTH(D.DocumentDate)) = '1' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Ene_A' 
            WHEN (MONTH(D.DocumentDate)) = '2' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Feb_A' 
            WHEN (MONTH(D.DocumentDate)) = '3' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Mar_A' 
            WHEN (MONTH(D.DocumentDate)) = '4' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Abr_A' 
            WHEN (MONTH(D.DocumentDate)) = '5' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'May_A' 
            WHEN (MONTH(D.DocumentDate)) = '6' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Jun_A' 
            WHEN (MONTH(D.DocumentDate)) = '7' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Jul_A' 
            WHEN (MONTH(D.DocumentDate)) = '8' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Ago_A' 
            WHEN (MONTH(D.DocumentDate)) = '9' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Sep_A' 
            WHEN (MONTH(D.DocumentDate)) = '10' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Oct_A' 
            WHEN (MONTH(D.DocumentDate)) = '11' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Nov_A' 
            WHEN (MONTH(D.DocumentDate)) = '12' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Dic_A' 
            WHEN (MONTH(D.DocumentDate)) = '1' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Ene_V' 
            WHEN (MONTH(D.DocumentDate)) = '2' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Feb_V' 
            WHEN (MONTH(D.DocumentDate)) = '3' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Mar_V' 
            WHEN (MONTH(D.DocumentDate)) = '4' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Abr_V' 
            WHEN (MONTH(D.DocumentDate)) = '5' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'May_V' 
            WHEN (MONTH(D.DocumentDate)) = '6' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Jun_V' 
            WHEN (MONTH(D.DocumentDate)) = '7' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Jul_V' 
            WHEN (MONTH(D.DocumentDate)) = '8' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Ago_V' 
            WHEN (MONTH(D.DocumentDate)) = '9' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Sep_V' 
            WHEN (MONTH(D.DocumentDate)) = '10' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Oct_V' 
            WHEN (MONTH(D.DocumentDate)) = '11' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Nov_V' 
            WHEN (MONTH(D.DocumentDate)) = '12' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Dic_V' 
        END AS Mes, 
        pr.Code AS Cod_Producto, 
        pr.Name AS Producto, 
        sg.Code + ' - ' + sg.Name AS [CodSubgrupo],
        Med.Code AS Cod_Med, 
        Med.Name AS Medicamento, 
        ins.Code AS Cod_Insumo, 
        ins.SupplieName AS Insumo, 
        ATC.Code AS [CodATC], 
        ATC.Name AS ATC, 
        pr.CodeCUM AS [CodigoCUM], 
        TP.Name AS TipoProducto, 
        sum(DI.Quantity - DI.ReturnedQuantity) AS CantIdad, 
        CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, 
        pr.ProductCost AS CostoPromedio, 
        gf.Name AS [GrupoFacturacion],
        CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [ProdControl],
        ue.Name AS UnIdadEmpaque, 
        ue.Abbreviation AS FactorConversion, 
        pr.Abbreviation AS Abreviatura,
        CASE Med.HighCost WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END AS AltoCosto, 
        F.Name AS Fabricante,
        'Dispensacion' as Proceso, 
        gr.Name as Grupo
    FROM   
        INDIGO031.Inventory.PharmaceuticalDispensing AS D 
        INNER JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail AS DI ON DI.PharmaceuticalDispensingId = D.Id
        INNER JOIN INDIGO031.dbo.ADINGRESO AS I ON I.NUMINGRES = D.AdmissionNumber
        INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = I.IPCODPACI
        INNER JOIN INDIGO031.Inventory.InventoryProduct AS pr ON pr.Id = DI.ProductId
        INNER JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
        INNER JOIN INDIGO031.Inventory.ProductGroup as gr on gr.Id=pr.ProductGroupId
        INNER JOIN INDIGO031.Payroll.FunctionalUnit AS un ON un.Id = DI.FunctionalUnitId
        INNER JOIN INDIGO031.Billing.ServiceOrder AS O ON O.EntityCode = D.Code
        INNER JOIN INDIGO031.Common.OperatingUnit AS UO ON UO.Id = D.OperatingUnitId
        LEFT OUTER JOIN INDIGO031.Inventory.ATC AS Med ON Med.Id = pr.ATCId
        LEFT OUTER JOIN INDIGO031.Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id
        LEFT OUTER JOIN INDIGO031.Inventory.InventorySupplie AS ins ON ins.Id=pr.SupplieId
        LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId
        LEFT OUTER JOIN INDIGO031.Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId
        INNER JOIN INDIGO031.Inventory.Manufacturer AS F ON F.Id = pr.ManufacturerId
        INNER JOIN INDIGO031.Inventory.ProductType AS TP ON TP.Code = pr.ProductTypeId
    WHERE  
        CONVERT(NVARCHAR(10), D.DocumentDate, 20) > CONVERT(VARCHAR(10), GETDATE() - 367, 20) 
        AND D.Status = '2' 
        AND DI.Quantity <> DI.ReturnedQuantity 
        AND sg.Code <> 'OSTEO001' 
        AND sg.Code <> 'PROTE001'
    GROUP BY 
        UO.UnitName, 
        (MONTH(D.DocumentDate)), 
        YEAR(D.DocumentDate), 
        pr.Code, 
        pr.Name, 
        sg.Code + ' - ' + sg.Name, 
        ATC.Code, 
        ATC.Name, 
        pr.CodeCUM, 
        pr.Status, 
        pr.ProductCost, 
        Med.Code, 
        Med.Name, 
        ins.Code, 
        ins.SupplieName, 
        gf.Name, 
        pr.ProductControl,
        ue.Name, 
        ue.Abbreviation, 
        pr.Abbreviation, 
        Med.HighCost, 
        F.Name, 
        TP.Name, 
        gr.Name
    UNION ALL
    SELECT 
        UO.UnitName AS Sede, 
        CASE 
            WHEN (MONTH(DO.DocumentDate)) = '1' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Ene_A' 
            WHEN (MONTH(DO.DocumentDate)) = '2' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Feb_A' 
            WHEN (MONTH(DO.DocumentDate)) = '3' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Mar_A' 
            WHEN (MONTH(DO.DocumentDate)) = '4' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Abr_A' 
            WHEN (MONTH(DO.DocumentDate)) = '5' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'May_A' 
            WHEN (MONTH(DO.DocumentDate)) = '6' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Jun_A' 
            WHEN (MONTH(DO.DocumentDate)) = '7' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Jul_A' 
            WHEN (MONTH(DO.DocumentDate)) = '8' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Ago_A' 
            WHEN (MONTH(DO.DocumentDate)) = '9' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Sep_A' 
            WHEN (MONTH(DO.DocumentDate)) = '10' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Oct_A' 
            WHEN (MONTH(DO.DocumentDate)) = '11' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Nov_A' 
            WHEN (MONTH(DO.DocumentDate)) = '12' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Dic_A' 
            WHEN (MONTH(DO.DocumentDate)) = '1' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Ene_V' 
            WHEN (MONTH(DO.DocumentDate)) = '2' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Feb_V' 
            WHEN (MONTH(DO.DocumentDate)) = '3' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Mar_V' 
            WHEN (MONTH(DO.DocumentDate)) = '4' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Abr_V' 
            WHEN (MONTH(DO.DocumentDate)) = '5' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'May_V' 
            WHEN (MONTH(DO.DocumentDate)) = '6' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Jun_V' 
            WHEN (MONTH(DO.DocumentDate)) = '7' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Jul_V' 
            WHEN (MONTH(DO.DocumentDate)) = '8' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Ago_V' 
            WHEN (MONTH(DO.DocumentDate)) = '9' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Sep_V' 
            WHEN (MONTH(DO.DocumentDate)) = '10' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Oct_V' 
            WHEN (MONTH(DO.DocumentDate)) = '11' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Nov_V' 
            WHEN (MONTH(DO.DocumentDate)) = '12' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Dic_V' 
        END AS Mes, 
        pr.Code AS Cod_Producto, 
        pr.Name AS Producto, 
        sg.Code + ' - ' + sg.Name AS [CodSubgrupo],
        Med.Code AS Cod_Med, 
        Med.Code + ' - ' + Med.Name AS Medicamento, 
        ins.Code AS Cod_Insumo, 
        ins.SupplieName AS Insumo, 
        ATC.Code AS CodATC, 
        ATC.Name AS ATC, 
        pr.CodeCUM AS [CodigoCUM], 
        TP.Name AS TipoProducto, 
        sum(N.OutstandingQuantity) AS CantIdad, 
        CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, 
        pr.ProductCost AS CostoPromedio,
        gf.Name AS [GrupoFacturacion],
        CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [ProdControl],
        ue.Name AS UnIdadEmpaque, 
        ue.Abbreviation AS FactorConversion, 
        pr.Abbreviation AS Abreviatura,
        CASE Med.HighCost WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END AS AltoCosto, 
        F.Name AS Fabricante,
        'Traslados' as Proceso, 
        gr.Name as Grupo
    FROM    
        INDIGO031.Inventory.TransferOrder AS DO 
        INNER JOIN INDIGO031.Inventory.TransferOrderDetail AS DI ON DI.TransferOrderId = DO.Id
        INNER JOIN INDIGO031.Inventory.InventoryProduct AS pr ON pr.Id = DI.ProductId
        INNER JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
        INNER JOIN INDIGO031.Inventory.ProductGroup as gr on gr.Id=pr.ProductGroupId
        INNER JOIN INDIGO031.Inventory.Warehouse AS a ON a.Id = DO.SourceWarehouseId
        INNER JOIN INDIGO031.Common.OperatingUnit AS UO ON UO.Id = DO.OperatingUnitId
        INNER JOIN INDIGO031.Inventory.TransferOrderDetailBatchSerial AS N ON N.TransferOrderDetailId = DI.Id
        LEFT OUTER JOIN INDIGO031.Inventory.ATC AS Med ON Med.Id = pr.ATCId
        LEFT OUTER JOIN INDIGO031.Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id
        LEFT OUTER JOIN INDIGO031.Inventory.InventorySupplie AS ins ON ins.Id=pr.SupplieId
        LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId
        LEFT OUTER JOIN INDIGO031.Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId
        INNER JOIN INDIGO031.Inventory.Manufacturer AS F ON F.Id = pr.ManufacturerId
        INNER JOIN INDIGO031.Inventory.ProductType AS TP ON TP.Code = pr.ProductTypeId
    WHERE 
        DO.DocumentDate >= '01-01-2024'
        AND DO.Status = '2' 
        AND N.OutstandingQuantity <> '0' 
        AND DO.OrderType = '2' 
        AND sg.Code <> 'OSTEO001' 
        AND sg.Code <> 'PROTE001' 
        AND DO.OrderType = '2'
    GROUP BY 
        UO.UnitName, 
        a.Id,
        (MONTH(DO.DocumentDate)),
        pr.Code, 
        pr.Name, 
        pr.CodeAlternative, 
        pr.CodeAlternativeTwo, 
        sg.Code, 
        Med.Code + ' - ' + Med.Name, 
        ATC.Code, 
        ATC.Name,
        Med.Code, 
        Med.Name, 
        ins.Code, 
        ins.SupplieName,
        pr.CodeCUM, 
        pr.ProductTypeId,
        sg.Code + ' - ' + sg.Name, 
        pr.Status, 
        YEAR(DocumentDate),
        pr.ProductCost,
        gf.Name, 
        pr.ProductControl,
        ue.Name, 
        ue.Abbreviation, 
        pr.Abbreviation, 
        Med.HighCost, 
        F.Name, 
        TP.Name, 
        gr.Name
) source 
PIVOT 
(
    SUM(CantIdad) 
    FOR source.Mes IN (
        Ene_V, Feb_V, Mar_V, Abr_V, May_V, Jun_V, Jul_V, Ago_V, Sep_V, Oct_V, 
        Nov_V, Dic_V, Ene_A, Feb_A, Mar_A, Abr_A, May_A, Jun_A, Jul_A, Ago_A, Sep_A, Oct_A, Nov_A, Dic_A
    )
) AS pivotable