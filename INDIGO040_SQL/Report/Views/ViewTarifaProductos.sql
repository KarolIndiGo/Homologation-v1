-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewTarifaProductos
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[ViewTarifaProductos] as 

select 
IPR.ID as 'ID ProductRate',
IPRD.ID AS 'ID ProductRateDetail',
IPR.Code+'-'+IPR.Name AS [Tarifa Producto], 
IIP.ID, 
IIP.Code AS 'Código Producto', 
IIP.CodeCUM AS 'C.U.M', 
IIP.CODEALTERNATIVE AS 'Código Alterno',
IIP.[Name] AS [Nombre Producto],
IIP.MeasurementUnitId AS 'Forma Farmaceutica',
IIP.Presentation AS 'Presentación',
IIP.HealthRegistration AS 'Registro Sanitario',
(IPT.CODE +'-'+ipt.Name) AS 'Tipo Producto',
(IPG.CODE + '-' + IPG.NAME) AS 'Grupo', (IPS.CODE + '-' + IPS.NAME) AS 'SubGrupo',
CASE iprd.liquidationtype   when 0 then 'No aplica'
                            when 1 then 'Tarifa'
   when 2 then 'Servicio'
   when 3 then 'Tarifa - Servicio'
   end AS 'Tipo Liquidación',
CASE iprd.RateType          when 0 then 'N/A'
                            when 1 then 'Tarifa Fija'
   when 2 then 'Basado en porcentaje'
   end AS 'Tipo Tarifa',
CASE iprd.Percentagebasedon when 0 then 'N/A'
                            when 1 then 'Costo promedio ponderado'
   when 2 then 'Ultimo costo'
   end AS 'Tipo Porcentaje',
IPRD.CUPSID AS 'CUPS',
IPRD.ContractDescriptionId AS 'Descripcion Relacionada',
IPRD.InitialDate AS 'Fecha Inicial',
IPRD.EndDate AS 'Fecha Final',
iif (IPRD.EndDate <= GETDATE(), 'Caduco', 'Vigente') AS 'Alerta de Vigencia',
IPRD.PERCENTAGE AS 'Porcentaje',
IPRD.SalesValue AS 'Precio de Venta',
IPRD.SalesValueWithSurcharge as 'Precio con Recargo',
IIP.productcost AS 'Costo promedio',
IIP.FinalProductCost AS 'Ultimo Costo',
CASE IIP.TaxedProduct       when 0 then 'No Grabado'
                            when 1 then 'Grabado'
							END AS 'IVA',
CASE iprd.Contracted        when 0 then 'No'
                            when 1 then 'Si'
end AS 'Contratado',
CASE iprd.quoted            when 0 then 'No'
                            when 1 then 'Si'
end AS 'Al Cotizar',
iprd.observations as 'Observaciones',
iprd.Status
from Inventory.ProductRate IPR
INNER JOIN Inventory.ProductRateDetail IPRD ON IPR.Id = IPRD.ProductRateId
INNER JOIN Inventory.InventoryProduct IIP ON IPRD.ProductId = IIP.ID
INNER JOIN inventory.ProductType IPT ON IIP.ProductTypeId =  IPT.ID
INNER JOIN inventory.ProductGroup IPG ON IIP.ProductGroupId = IPG.Id
INNER JOIN Inventory.ProductSubGroup IPS ON IIP.ProductSubGroupId = IPs.Id
--where ipr.code = '009'
--select * from Inventory.ProductRateDetail 

