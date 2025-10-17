-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_CostoPromedioProducto
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Inventory_CostoPromedioProducto] as 
SELECT atc.code, atc.name, avg(p.productcost) as total
FROM Inventory.InventoryProduct as p 
inner join Inventory.ATC as atc on atc.Id=p.atcid
where p.status='1'
group by  atc.code, atc.name
