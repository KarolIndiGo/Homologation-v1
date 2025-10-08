-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_AD_INVENTORY_CTAGRUPOSPRODUCTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_AD_INVENTORY_CTAGRUPOSPRODUCTOS AS
SELECT 
    g.Code AS CodGrupo, 
    g.Name AS Grupo, 
    un.Code AS CodUF, 
    un.Name AS UnidadFuncional, 
    m.Number AS NumeroCtaCosto, 
    m.Name AS CuentaCosto, 
    m1.Number AS NumeroCtaVenta, 
    m1.Name AS CuentaVenta
FROM INDIGO031.Inventory.ProductGroup AS g
INNER JOIN INDIGO031.Inventory.ProductGroupFunctionalUnit AS u ON u.ProductGroupId = g.Id
INNER JOIN [INDIGO031].[GeneralLedger].[MainAccounts] AS m ON m.Id = u.CostAccountId
INNER JOIN [INDIGO031].[GeneralLedger].[MainAccounts] AS m1 ON m1.Id = u.SalesAccountId
INNER JOIN INDIGO031.Payroll.FunctionalUnit AS un ON un.Id = u.FunctionalUnitId