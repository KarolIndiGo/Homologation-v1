-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VCOSTOSDESPACHOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VCOSTOSDESPACHOS AS
SELECT 
    tor.DocumentDate AS FechaDocumento,
    ip.Code AS CodigoProducto,
    ip.Name AS Producto,
    c.Code + ' - ' + c.Name AS CentroCosto,
    CASE pt.Class WHEN 3 THEN 'Equipo Medico' ELSE 'Varios' END AS Tipo,
    pg.Name AS Grupo,
    tod.Quantity AS Cantidad,
    ip.ProductCost AS CostoPromedio,
    ip.ProductCost * tod.Quantity AS Total
FROM INDIGO031.Inventory.TransferOrder tor
INNER JOIN INDIGO031.Inventory.TransferOrderDetail tod ON tod.TransferOrderId = tor.Id
INNER JOIN INDIGO031.Inventory.InventoryProduct ip ON ip.Id = tod.ProductId
INNER JOIN INDIGO031.Inventory.ProductGroup pg ON pg.Id = ip.ProductGroupId
INNER JOIN INDIGO031.Inventory.ProductType pt ON pt.Id = ip.ProductTypeId
INNER JOIN INDIGO031.Payroll.FunctionalUnit fu ON fu.Id = tor.TargetFunctionalUnitId
INNER JOIN INDIGO031.Payroll.CostCenter AS c ON c.Id = fu.CostCenterId
WHERE pt.Class IN (3,4) AND tor.Status = 2