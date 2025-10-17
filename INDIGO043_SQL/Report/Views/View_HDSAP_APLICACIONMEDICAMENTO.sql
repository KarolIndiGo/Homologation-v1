-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_APLICACIONMEDICAMENTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0






/*******************************************************************************************************************
Nombre: Aplicacion medicamentos Uci
Tipo:Vista
Observacion: Aplicacion medicamentos
Profesional: Milton Urbano Bolañoz
Fecha:23-07-2025
-----------------------------------------------------------------*/





CREATE VIEW [Report].[View_HDSAP_APLICACIONMEDICAMENTO]
AS


SELECT     
    CONCAT(pd.WarehouseCode, ' - ', pd.WarehouseName) AS 'Almacen',     
    pd.AdmissionNumber AS 'Numero Ingreso',     
    pd.DocumentDate AS 'Fecha Dispensación',
    CONCAT(pd.FunctionalUnitCode, ' - ', pd.FunctionalUnitName) AS 'Unidad Funcional',     
    pd.Nit AS 'Identificación',     
    pd.Name AS 'Nombre Paciente',     
    pd.ProductCode AS 'Codigo producto',     
    pd.ProductName AS 'Producto',     
    SUM(pd.Quantity) AS 'Cantidad Dispensada',     
    SUM(ISNULL(k.Aplicada, 0)) AS 'Cantidad Aplicada',     
    SUM(ISNULL(k.Devolutivo, 0)) AS 'Cantidad Devolutiva' 
FROM  
(
    SELECT         
        pd.AdmissionNumber,         
        pd.DocumentDate,
        fu.Code AS FunctionalUnitCode,         
        fu.Name AS FunctionalUnitName,         
        tp.Nit,         
        tp.Name,         
        w.Code AS WarehouseCode,         
        w.Name AS WarehouseName,         
        ip.Code AS ProductCode,         
        ip.Name AS ProductName,         
        atc.Code AS ATCCode,         
        SUM(pdd.Quantity) AS Quantity     
    FROM Inventory.PharmaceuticalDispensing pd         
        JOIN Inventory.PharmaceuticalDispensingDetail pdd ON pd.Id = pdd.PharmaceuticalDispensingId     
        JOIN Inventory.Warehouse w ON pdd.WarehouseId = w.Id AND w.VirtualStore = 1     
        JOIN Inventory.InventoryProduct ip ON pdd.ProductId = ip.Id     
        JOIN Payroll.FunctionalUnit fu ON pdd.FunctionalUnitId = fu.Id     
        JOIN dbo.ADINGRESO AD ON pd.AdmissionNumber = ad.NUMINGRES     
        JOIN Common.ThirdParty tp ON ad.IPCODPACI = tp.Nit     
        LEFT JOIN Inventory.ATC atc ON ip.ATCId = atc.Id    
    GROUP BY 
        pd.AdmissionNumber, 
        pd.DocumentDate,
        fu.Code, fu.Name, 
        tp.Nit, tp.Name, 
        ip.Code, w.Code, w.Name, 
        ip.Name, atc.Code 
) pd     
LEFT JOIN  
(
    SELECT         
        k.NUMINGRES,          
        k.UFUCODIGO,          
        k.CODPRODUC,          
        SUM(CASE WHEN k.TIPORIREG BETWEEN 11 AND 15 THEN k.CANPRODUCT ELSE 0 END) AS Aplicada,         
        SUM(CASE WHEN k.TIPORIREG = 18 THEN k.CANPRODUCT ELSE 0 END) AS Devolutivo     
    FROM dbo.HCKARDPAC k     
    GROUP BY k.NUMINGRES, k.UFUCODIGO, k.CODPRODUC 
) k  
ON pd.AdmissionNumber = k.NUMINGRES     
    AND pd.FunctionalUnitCode = k.UFUCODIGO     
    AND ISNULL(pd.ATCCode, pd.ProductCode) = k.CODPRODUC 
GROUP BY     
    pd.WarehouseCode, pd.WarehouseName,     
    pd.AdmissionNumber,     
    pd.DocumentDate,
    pd.FunctionalUnitCode, pd.FunctionalUnitName,     
    pd.Nit, pd.Name,     
    pd.ProductCode, pd.ProductName;



