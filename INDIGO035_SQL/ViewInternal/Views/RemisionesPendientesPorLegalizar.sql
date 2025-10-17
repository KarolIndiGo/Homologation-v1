-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: RemisionesPendientesPorLegalizar
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE view [ViewInternal].[RemisionesPendientesPorLegalizar]
as (
select MONTH(re.RemissionDate) as Mes
, YEAR(re.RemissionDate) as Anio
,ma.Number
, ma.Name
, sum(bs.Quantity) as CantidadInicial
, sum(bs.Quantity * ip.ProductCost) as ValorInicial
, sum(bs.OutstandingQuantity) as Cantidad
, sum(bs.OutstandingQuantity * ip.ProductCost) as Valor
from Inventory.RemissionEntrance re
inner join Inventory.RemissionEntranceDetail red on red.RemissionEntranceId = re.Id
inner join Inventory.RemissionEntranceDetailBatchSerial bs on bs.RemissionEntranceDetailId = red.Id
inner join Inventory.InventoryProduct ip on ip.Id = red.ProductId
inner join Inventory.ProductGroup pg on pg.Id = ip.ProductGroupId
inner join Payments.AccountPayableConcepts apc on apc.Id = pg.InventoryAccountPayableConceptId
inner join GeneralLedger.MainAccounts ma on ma.Id = apc.IdAccount
where re.Status = 2 and re.WarehouseId not in (select Id from Inventory.Warehouse where Code in ('103','07','06'))
group by ma.Number, ma.Name, MONTH(re.RemissionDate), YEAR(re.RemissionDate)
)


