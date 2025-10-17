-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IN_RemisionesSinCruzar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IN_RemisionesSinCruzar] AS
SELECT  	
uo.UnitName AS Sede, 
cr.Code AS [Cod Remision], 
cr.RemissionDate AS [Fecha Remision],
pd.Code AS [Cod Producto], 
pd.Name AS Producto,   
dc.Name as [Principio Activo], 
catc.Weight as [Peso], 
mup.name as [Unidad Peso],
case when  catc.formulationtype=1 then mup.name when catc.formulationtype=2 then muv.name  when catc.formulationtype=3 then concat( mup.name, '/' , muv.name) when catc.formulationtype=4 then mua.name end as [Unidad de Medida],
pen.Quantity AS Cantidad, 
DR.TotalValue AS Total, 
Pen.OutstandingQuantity AS Pendiente_Cruzar, 
pd.ProductCost AS [Costo Promedio], 
pd.ProductCost*pen.Quantity AS ValorTotalProm, 
lote.ExpirationDate as	[Fecha de Vencimiento],
PR.Code AS [Codigo Proveedor], 
PR.Name AS NombreProveedor, AL.Code AS [Codigo Almacen], AL.Name AS Almacen, cr.RemissionNumber AS [Numero Remision], cr.Description AS Descripcion, cr.Value AS [Vr Remision], 
cr.IvaValue AS Iva, 
CASE cr.Status WHEN '1' THEN 'Registrada' WHEN '2' THEN 'Confirmada' WHEN '3' THEN 'Anulada' END AS Estado_Remision, 
CASE cr.ProductStatus WHEN '1' THEN 'Sin_Movimientos' WHEN '2' THEN 'Parcial' WHEN '3' THEN 'Total' END AS Estado_Productos, 
p.Fullname AS Usuario 

		--pd.Code as	[Codigo (Indigo)], catc.Concentration as Concentracion, 
		--when 2 then 'Volumen' when 3 then 'Peso - Volumen' when 4 then 'Unidad de administración' end as [Tipo Formula], case catc.formulationtype when 1 then 'Peso', catc.Weight as [Peso], mup.name as [Unidad Peso],
		--PR.Name as	Proveedor, '' as	Serie, lote.BatchCode as [Número de Lote],  lote.BatchCode AS Lote, pd.HealthRegistration as 	[Número de Registro Sanitario],pd.HealthRegistration AS RegistroSanitario,
		--f.Name  as Fabricante, f.Name as NombreFabricante, cr.RemissionNumber  as [Número de factura],
		--case when catc.code is not null then catc.Code else s.code end  AS [Codigo Agrupador], case when catc.Name  is not null then catc.name else s.SupplieName end  AS [Agrupador], 
		--forma.Name as	[Forma Farmacéutica], forma.Name as FormaFarmaceutica,  orden.code as	[Orden de Compra], orden.code as OrdenCompra, catc.volume as [Volume], muv.name as [Unidad Volumen],
		--mua.name as [Unidad Administracion], pk.Name as Unidada_Empaque, nr.Name  as [Clasificación por Riesgo], nr.Name as Nivel_Riesgo, pd.Presentation as	[Presentación Comercial], pd.Presentation as Presentación, 
		--cr.TotalValue AS [Vr Total], lote.ExpirationDate AS FechaVencimiento, '' as [Vida Útil], pd.Name as [Nombre o Descripción], 
FROM   Inventory.RemissionEntrance AS cr WITH (nolock) 
	   INNER JOIN Common.OperatingUnit AS uo WITH (nolock) ON uo.Id = cr.OperatingUnitId 
	   INNER JOIN Common.Supplier AS PR WITH (nolock) ON PR.Id = cr.SupplierId 
	   INNER JOIN Inventory.Warehouse AS AL WITH (nolock) ON AL.Id = cr.WarehouseId 
	   INNER JOIN Inventory.RemissionEntranceDetail AS DR WITH (nolock) ON DR.RemissionEntranceId = cr.Id 
	   INNER JOIN Inventory.InventoryProduct AS pd WITH (nolock) ON pd.Id = DR.ProductId 
	   INNER JOIN Inventory.PackagingUnit AS pk WITH (nolock) ON pd.PackagingUnitId = pk.Id
	   INNER JOIN Inventory.InventoryRiskLevel AS nr WITH (nolock) ON pd.InventoryRiskLevelId = nr.Id
	   INNER JOIN Security.[User] AS U  ON U.UserCode = cr.CreationUser 
	   INNER JOIN Security.Person AS p  ON p.Id = U.IdPerson 
	   LEFT OUTER JOIN Inventory.RemissionEntranceDetailBatchSerial AS Pen ON Pen.RemissionEntranceDetailId = DR.Id 
	   LEFT OUTER JOIN Inventory.ATC AS catc with (nolock) ON catc.Id = pd.ATCId
	  LEFT OUTER JOIN Inventory.DCI AS DC WITH (nolock) ON DC.Id = catc.DCIId
	   left outer join Inventory.InventoryMeasurementUnit as mup with (nolock) on mup.id=catc.WeightMeasureUnit
	   left outer join Inventory.InventoryMeasurementUnit as muv with (nolock) on muv.id=catc.VolumeMeasureUnit
	   left outer join Inventory.InventoryMeasurementUnit as mua with (nolock) on mua.id=catc.AdministrationUnitid
	   left outer join Inventory.InventorySupplie as s with (nolock) on s.id=pd.SupplieId 
	   LEFT OUTER JOIN Inventory.BatchSerial as lote WITH (NOLOCK) ON lote.id=pen.BatchSerialId
	   left outer join Inventory.PharmaceuticalForm as forma with (nolock) on forma.id=catc.PharmaceuticalFormId
	   LEFT OUTER JOIN Inventory.Manufacturer AS f WITH (nolock) ON f.Id = pd.ManufacturerId 
	   left outer join (select p.code, d.ProductId
							from Inventory.PurchaseOrder as p 
							inner join Inventory.PurchaseOrderDetail as d on d.PurchaseOrderId=p.id
							group by p.code, d.ProductId) as orden on orden.code=dr.SourceCode and orden.ProductId=dr.ProductId and dr.RemissionSource=2
WHERE (cr.Status <> '3') and Pen.OutstandingQuantity > '0'

/*(Pen.OutstandingQuantity > '0') AND*/ 

--and cr.code='VIN0000019'
-- and catc.code='00870'
--AND 


--SELECT * FROM Inventory.RemissionEntranceDetail
--WHERE RemissionEntranceId='15'
--SELECT * FROM   Inventory.RemissionEntrance
--WHERE CODE='DUI0000003'
