-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_REMISIONESPENDIENTESPORLEGALIZAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[RemisionesPendientesPorLegalizar]
AS

SELECT
    MONTH(re.RemissionDate) AS Mes,
    YEAR(re.RemissionDate) AS Anio,
    ma.Number,
    ma.Name,
    SUM(bs.Quantity) AS CantidadInicial,
    SUM(bs.Quantity * ip.ProductCost) AS ValorInicial,
    SUM(bs.OutstandingQuantity) AS Cantidad,
    SUM(bs.OutstandingQuantity * ip.ProductCost) AS Valor
FROM [INDIGO035].[Inventory].[RemissionEntrance] AS re
INNER JOIN [INDIGO035].[Inventory].[RemissionEntranceDetail] AS red
    ON red.RemissionEntranceId = re.Id
INNER JOIN [INDIGO035].[Inventory].[RemissionEntranceDetailBatchSerial] AS bs
    ON bs.RemissionEntranceDetailId = red.Id
INNER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS ip
    ON ip.Id = red.ProductId
INNER JOIN [INDIGO035].[Inventory].[ProductGroup] AS pg
    ON pg.Id = ip.ProductGroupId
INNER JOIN [INDIGO035].[Payments].[AccountPayableConcepts] AS apc
    ON apc.Id = pg.InventoryAccountPayableConceptId
INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
    ON ma.Id = apc.IdAccount
WHERE re.Status = 2
  AND re.WarehouseId NOT IN (
        SELECT Id
        FROM [INDIGO035].[Inventory].[Warehouse]
        WHERE Code IN ('103','07','06')
  )
GROUP BY
    ma.Number,
    ma.Name,
    MONTH(re.RemissionDate),
    YEAR(re.RemissionDate);