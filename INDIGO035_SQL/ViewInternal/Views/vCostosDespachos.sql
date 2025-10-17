-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: vCostosDespachos
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE View [ViewInternal].[vCostosDespachos]
as
(
select 
tor.DocumentDate as FechaDocumento
,ip.Code as CodigoProducto
,ip.Name as Producto
,c.Code + ' - ' + c.Name as CentroCosto
,case pt.Class when 3 then 'Equipo Medico' else 'Varios' end as Tipo
,pg.Name as Grupo
,tod.Quantity as Cantidad
,ip.ProductCost as CostoPromedio
,ip.ProductCost * tod.Quantity as Total
from Inventory.TransferOrder tor
inner join Inventory.TransferOrderDetail tod on tod.TransferOrderId = tor.Id
inner join Inventory.InventoryProduct ip on ip.Id = tod.ProductId
inner join Inventory.ProductGroup pg on pg.Id = ip.ProductGroupId
inner join Inventory.ProductType pt on pt.Id = ip.ProductTypeId
inner join Payroll.FunctionalUnit fu on fu.Id = tor.TargetFunctionalUnitId
inner join Payroll.CostCenter as c on c.Id = fu.CostCenterId
where pt.Class in (3,4) and tor.Status = 2














)



