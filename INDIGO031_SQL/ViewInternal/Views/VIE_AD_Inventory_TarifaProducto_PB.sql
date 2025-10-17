-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_TarifaProducto_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_TarifaProducto_PB] as

SELECT CodAgrupador, Agrupador, min([Vr Producto]) as VrProducto
FROM [ViewInternal].[VIE12_AD_Inventory_ManualProductos]
--where CodAgrupador='00002'
GROUP BY CodAgrupador, Agrupador
