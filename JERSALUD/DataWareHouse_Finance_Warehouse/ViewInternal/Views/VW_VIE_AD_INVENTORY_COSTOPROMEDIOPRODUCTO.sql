-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_COSTOPROMEDIOPRODUCTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_COSTOPROMEDIOPRODUCTO AS 
SELECT atc.Code, atc.Name, avg(p.ProductCost) as total
FROM INDIGO031.Inventory.InventoryProduct as p 
inner join INDIGO031.Inventory.ATC as atc on atc.Id=p.ATCId
where p.Status='1'
group by  atc.Code, atc.Name