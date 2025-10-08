-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_DISPENSACIONFACTURACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_DISPENSACIONFACTURACION AS

SELECT 
    UO.UnitName AS Sede,
    D.Code AS Documento,
    'Dispensacion' AS [Tipo documento],
    D.DocumentDate AS Fecha,
    CASE 
        WHEN (MONTH(D.DocumentDate)) = '1' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Ene25'
        WHEN (MONTH(D.DocumentDate)) = '2' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Feb25'
        WHEN (MONTH(D.DocumentDate)) = '3' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Mar25'
        WHEN (MONTH(D.DocumentDate)) = '4' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Abr25'
        WHEN (MONTH(D.DocumentDate)) = '5' AND (YEAR(D.DocumentDate)) = '2025' THEN 'May25'
        WHEN (MONTH(D.DocumentDate)) = '6' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Jun25'
        WHEN (MONTH(D.DocumentDate)) = '7' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Jul25'
        WHEN (MONTH(D.DocumentDate)) = '8' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Ago25'
        WHEN (MONTH(D.DocumentDate)) = '9' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Sep25'
        WHEN (MONTH(D.DocumentDate)) = '10' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Oct25'
        WHEN (MONTH(D.DocumentDate)) = '11' THEN 'Nov25'
        WHEN (MONTH(D.DocumentDate)) = '12' AND (YEAR(D.DocumentDate)) = '2025' THEN 'Dic25'
    END AS Mes,
    P.IPCODPACI AS Identificacion,
    P.IPNOMCOMP AS Paciente,
    pr.Code AS Cod_Producto,
    pr.Name AS Producto,
    pr.CodeAlternative AS [Código alterno],
    pr.CodeAlternativeTwo AS [Código alterno 2],
    sg.Code + ' - ' + sg.Name AS [Código Subgrupo],
    catc.Code AS [Código ATC],
    pr.CodeCUM AS [Código CUM],
    a.Code AS CodAlmacen,
    a.Name AS AlmacenDespacho,
    CASE 
        WHEN pr.POSProduct = '1' THEN 'POS'
        WHEN pr.POSProduct = '0' THEN 'No_POS'
    END AS TipoProducto,
    DI.Quantity AS CantidadSolicitada,
    DI.ReturnedQuantity AS CantidadDevuelta,
    DI.Quantity - DI.ReturnedQuantity AS Cantidad,
    un.Name AS Unidad_Destino,
    pr.Presentation AS Presentacion,
    CC.NOMCENATE AS CentroAtencion,
    DI.AverageCost AS CostoPromedio,
    pr.FinalProductCost AS UltimoCosto,
    pr.SellingPrice AS ValorVenta,
    lote.BatchCode AS Lote,
    lote.ExpirationDate AS FechaVencimiento
FROM 
    INDIGO031.Inventory.PharmaceuticalDispensing AS D
    INNER JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail AS DI ON DI.PharmaceuticalDispensingId = D.Id AND D.Status = '2'
    INNER JOIN INDIGO031.dbo.ADINGRESO AS I ON I.NUMINGRES = D.AdmissionNumber
    INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = I.IPCODPACI
    LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS DX ON DX.CODDIAGNO = I.CODDIAING
    LEFT JOIN INDIGO031.dbo.INPROFSAL AS PF ON PF.CODPROSAL = DI.OrderedHealthProfessionalCode
    LEFT JOIN INDIGO031.dbo.INESPECIA AS ES ON ES.CODESPECI = DI.OrderedProfessionalSpecialty
    LEFT JOIN INDIGO031.Inventory.InventoryProduct AS pr ON pr.Id = DI.ProductId
    LEFT JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
    LEFT JOIN INDIGO031.Payroll.FunctionalUnit AS un ON un.Id = DI.FunctionalUnitId
    LEFT JOIN INDIGO031.Inventory.Warehouse AS a ON a.Id = DI.WarehouseId
    LEFT JOIN INDIGO031.Billing.ServiceOrder AS O ON O.EntityCode = D.Code
    LEFT JOIN INDIGO031.Common.OperatingUnit AS UO ON UO.Id = D.OperatingUnitId
    LEFT OUTER JOIN INDIGO031.Inventory.ATC AS catc ON catc.Id = pr.ATCId
    LEFT JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetailBatchSerial AS bs ON bs.PharmaceuticalDispensingDetailId = DI.Id
    LEFT OUTER JOIN INDIGO031.Inventory.PharmaceuticalDispensingDevolutionDetail AS devd ON devd.PharmaceuticalDispensingDetailBatchSerialId = bs.Id
    LEFT OUTER JOIN INDIGO031.Inventory.PharmaceuticalDispensingDevolution AS dev ON dev.Id = devd.PharmaceuticalDispensingDevolutionId
    LEFT OUTER JOIN INDIGO031.dbo.ADCENATEN AS CC ON CC.CODCENATE = I.CODCENATE
    LEFT OUTER JOIN INDIGO031.Inventory.PhysicalInventory AS ph ON ph.Id = bs.PhysicalInventoryId
    LEFT OUTER JOIN INDIGO031.Inventory.BatchSerial AS lote ON lote.Id = ph.BatchSerialId
WHERE 
    (D.DocumentDate >= '01/01/2025 00:00:00')
    AND (D.Status = '2')
    AND (DI.Quantity - DI.ReturnedQuantity <> '0')