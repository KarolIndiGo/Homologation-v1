-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_TARIFAPRODUCTO_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_TARIFAPRODUCTO_PB as

SELECT CodAgrupador, Agrupador, min([Vr Producto]) as VrProducto
FROM ViewInternal.VW_VIE12_AD_INVENTORY_MANUALPRODUCTOS
--where CodAgrupador='00002'
GROUP BY CodAgrupador, Agrupador