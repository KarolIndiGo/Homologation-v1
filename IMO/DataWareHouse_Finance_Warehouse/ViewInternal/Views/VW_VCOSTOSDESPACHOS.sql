-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VCOSTOSDESPACHOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[vCostosDespachos]
AS

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
FROM [INDIGO035].[Inventory].[TransferOrder] AS tor
INNER JOIN [INDIGO035].[Inventory].[TransferOrderDetail] AS tod
    ON tod.TransferOrderId = tor.Id
INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS ip
    ON ip.Id = tod.ProductId
INNER JOIN [INDIGO035].[Inventory].[ProductGroup] AS pg
    ON pg.Id = ip.ProductGroupId
INNER JOIN [INDIGO035].[Inventory].[ProductType] AS pt
    ON pt.Id = ip.ProductTypeId
INNER JOIN [INDIGO035].[Payroll].[FunctionalUnit] AS fu
    ON fu.Id = tor.TargetFunctionalUnitId
INNER JOIN [INDIGO035].[Payroll].[CostCenter] AS c
    ON c.Id = fu.CostCenterId
WHERE pt.Class IN (3, 4)
  AND tor.Status = 2;