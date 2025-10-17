-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HDSAP_COSTOSTRASLADOCONSUMO
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE PROCEDURE [Report].[HDSAP_COSTOSTRASLADOCONSUMO]  
	@fechaInicial AS datetime,
	@fechaFinal As datetime
AS
SELECT 
    ito.Code AS NumTraslado, 
    ito.DocumentDate AS FechaDocumento, 
    ip.Code AS CodigoProducto, 
    ip.Name AS Producto, 
    c.Code + ' - ' + c.Name AS CentroCosto, 
    pt.Name AS TipoProducto, 
    pg.Name AS Grupo, 
    tod.Quantity AS Cantidad, 
    CAST(ip.ProductCost AS Numeric(12,0)) AS CostoPromedio, 
    CAST((ip.ProductCost * tod.Quantity) AS Numeric(12,0)) AS Total, 
    CAST(ip.FinalProductCost AS Numeric(12,0)) AS CostoUltim,
    CAST(
        SUM(ip.ProductCost * tod.Quantity) 
        OVER(PARTITION BY c.Code, DATENAME(MONTH, ito.DocumentDate)) 
        AS Numeric(12,0)
    ) AS TotalMesCentroCosto,
    CASE ito.OrderType 
        WHEN 1 THEN 'Traslado' 
        WHEN 2 THEN 'consumo' 
    END AS TipoTrasaldo, 
    CASE ito.DispatchTo 
        WHEN 1 THEN 'Almacen' 
        WHEN 2 THEN 'Unidad Funcional' 
    END AS TrasladoA, 
    Inventory.Warehouse.Code, 
    Inventory.Warehouse.Name, 
    ito.SourceWarehouseId, 
    ito.Description, 
    Security.Person.Fullname AS Usuario, 
    DATENAME(MONTH, ito.DocumentDate) AS MesDocumento
FROM 
    Inventory.TransferOrder AS ito 
    INNER JOIN Inventory.TransferOrderDetail AS tod ON tod.TransferOrderId = ito.Id 
    INNER JOIN Inventory.InventoryProduct AS ip ON ip.Id = tod.ProductId 
    INNER JOIN Inventory.ProductGroup AS pg ON pg.Id = ip.ProductGroupId 
    INNER JOIN Inventory.ProductType AS pt ON pt.Id = ip.ProductTypeId 
    INNER JOIN Inventory.Warehouse ON ito.SourceWarehouseId = Inventory.Warehouse.Id 
    INNER JOIN Payroll.FunctionalUnit AS fu ON fu.Id = ito.TargetFunctionalUnitId 
    LEFT JOIN Payroll.CostCenter AS c ON c.Id = fu.CostCenterId 
    LEFT JOIN Security.[User] ON ito.ConfirmationUser = Security.[User].UserCode 
    LEFT JOIN Security.Person ON Security.[User].IdPerson = Security.Person.Id
WHERE 
    ito.Status = 2 
    AND ito.DocumentDate BETWEEN @fechaInicial AND @fechaFinal;


