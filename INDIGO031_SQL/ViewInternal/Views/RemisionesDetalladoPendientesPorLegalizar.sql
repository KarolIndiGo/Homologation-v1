-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: RemisionesDetalladoPendientesPorLegalizar
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [ViewInternal].[RemisionesDetalladoPendientesPorLegalizar]
as (
select s.Code + ' - ' + s.Name as Proveedor
, re.Code as CodigoRemision
, re.RemissionDate as FechaRemision
, re.Description as Descripcion
, re.CreationUser
, w.Code + ' - ' + w.Name as Almacen
, ip.Code + ' - ' + ip.Name as Producto
, sum(bs.Quantity) as CantidadInicial
, sum(bs.Quantity * ip.ProductCost) as ValorInicial
, sum(bs.OutstandingQuantity) as CantidadPendiente
, sum(bs.OutstandingQuantity * ip.ProductCost) as ValorPendiente
from Inventory.RemissionEntrance re
inner join Inventory.Warehouse w on w.Id = re.WarehouseId
inner join Common.Supplier s on s.Id = re.SupplierId
inner join Inventory.RemissionEntranceDetail red on red.RemissionEntranceId = re.Id
inner join Inventory.RemissionEntranceDetailBatchSerial bs on bs.RemissionEntranceDetailId = red.Id
inner join Inventory.InventoryProduct ip on ip.Id = red.ProductId
inner join Inventory.ProductGroup pg on pg.Id = ip.ProductGroupId
inner join Payments.AccountPayableConcepts apc on apc.Id = pg.InventoryAccountPayableConceptId
inner join GeneralLedger.MainAccounts ma on ma.Id = apc.IdAccount
where re.Status = 2 and re.WarehouseId not in (select Id from Inventory.Warehouse where Code in ('103','07','06'))
group by s.Code, s.Name, re.Code, re.CreationUser, ip.Code, ip.Name, re.RemissionDate, re.Description, w.Code, w.Name
having sum(bs.OutstandingQuantity) > 0
)
