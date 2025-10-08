-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_REMISIONESDETALLADOPENDIENTESPORLEGALIZAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [ViewInternal].[VW_REMISIONESDETALLADOPENDIENTESPORLEGALIZAR]
as 
(
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
from INDIGO031.Inventory.RemissionEntrance re
inner join INDIGO031.Inventory.Warehouse w on w.Id = re.WarehouseId
inner join INDIGO031.Common.Supplier s on s.Id = re.SupplierId
inner join INDIGO031.Inventory.RemissionEntranceDetail red on red.RemissionEntranceId = re.Id
inner join INDIGO031.Inventory.RemissionEntranceDetailBatchSerial bs on bs.RemissionEntranceDetailId = red.Id
inner join INDIGO031.Inventory.InventoryProduct ip on ip.Id = red.ProductId
inner join INDIGO031.Inventory.ProductGroup pg on pg.Id = ip.ProductGroupId
inner join INDIGO031.Payments.AccountPayableConcepts apc on apc.Id = pg.InventoryAccountPayableConceptId
inner join INDIGO031.GeneralLedger.MainAccounts ma on ma.Id = apc.IdAccount
where re.Status = 2 and re.WarehouseId not in (select Id from INDIGO031.Inventory.Warehouse where Code in ('103','07','06'))
group by s.Code, s.Name, re.Code, re.CreationUser, ip.Code, ip.Name, re.RemissionDate, re.Description, w.Code, w.Name
having sum(bs.OutstandingQuantity) > 0
)
