-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_INVENTORY_REMISIONESSINCRUZAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_INVENTORY_REMISIONESSINCRUZAR] AS
SELECT pd.Code as	[Codigo (Indigo)], 	pd.Name as [Nombre o Descipción], DC.Name as	[Principio Activo], forma.Name as	[Forma Farmacéutica], 
pd.Presentation as	[Presentación Comercial],
case when  catc.FormulationType=1 then mup.Name when catc.FormulationType=2 then muv.Name  when catc.FormulationType=3 then concat( mup.Name, '/' , muv.Name) when catc.FormulationType=4 then mua.Name end as [Unidad de Medida],
'' as	Serie,	lote.BatchCode as [Número de Lote], pd.HealthRegistration as 	[Número de Registro Sanitario],	nr.Name  as [Clasificación por Riesgo], '' as [Vida Útil], lote.ExpirationDate as	[Fecha de Vencimiento],
Pen.Quantity as [Cantidad de Recibido], PR.Name as	Proveedor,	f.Name  as Fabricante, 	cr.RemissionNumber  as [Número de factura], orden.Code as	[Orden de Compra],

uo.UnitName AS Sede, cr.Code AS [Cod Remision], cr.RemissionDate AS [Fecha Remision], PR.Code AS [Codigo Proveedor], PR.Name AS NombreProveedor, AL.Code AS [Codigo Almacen], AL.Name AS Almacen, cr.RemissionNumber AS [Numero Remision], cr.Description AS Descripcion, cr.Value AS [Vr Remision], 
           cr.IvaValue AS Iva, --cr.TotalValue AS [Vr Total], 
		   CASE cr.Status WHEN '1' THEN 'registrada' WHEN '2' THEN 'confirmada' WHEN '3' THEN 'anulada' END AS Estado_Remision, CASE cr.ProductStatus
		   WHEN '1' THEN 'Sin_Movmientos' WHEN '2' THEN 'Parcial' WHEN '3' THEN 'Total' END AS estado_productos, pd.Code AS [Cod Producto], 
           pd.Name AS Producto, 
		     case when catc.Code is not null 
		   then catc.Code else s.Code end  AS [Codigo Agrupador], 
		   case when catc.Name  is not null 
		   then catc.Name else s.SupplieName end  AS [Agrupador], 
		   Pen.Quantity AS Cantidad, DR.TotalValue AS Total, pd.ProductCost AS [Costo Promedio], Pen.OutstandingQuantity AS Pendiente_Cruzar, pd.ProductCost*Pen.Quantity AS ValorTotalProm, p.Fullname AS Usuario,
		    lote.BatchCode AS Lote, lote.ExpirationDate AS FechaVencimiento, forma.Name as FormaFarmaceutica, catc.Concentration as Concentracion, pd.HealthRegistration AS RegistroSanitario,
			f.Name as NombreFabricante, orden.Code as OrdenCompra,
			case catc.FormulationType when 1 then 'Peso'
		when 2 then 'Volumen'
		when 3 then 'Peso - Volumen'
		when 4 then 'Unidad de administración' end as [Tipo Formula],
		catc.Weight as [Peso], mup.Name as [Unidad Peso],
		catc.Volume as [Volume], muv.Name as [Unidad Volumen],
		mua.Name as [Unidad Administracion],
		pk.Name as Unidada_Empaque, 
		nr.Name as Nivel_Riesgo, 
		pd.Presentation as Presentación
FROM   INDIGO031.Inventory.RemissionEntrance AS cr  
	   INNER JOIN INDIGO031.Common.OperatingUnit AS uo  ON uo.Id = cr.OperatingUnitId 
	   INNER JOIN INDIGO031.Common.Supplier AS PR  ON PR.Id = cr.SupplierId 
	   INNER JOIN INDIGO031.Inventory.Warehouse AS AL  ON AL.Id = cr.WarehouseId 
	   INNER JOIN INDIGO031.Inventory.RemissionEntranceDetail AS DR  ON DR.RemissionEntranceId = cr.Id 
	   INNER JOIN INDIGO031.Inventory.InventoryProduct AS pd  ON pd.Id = DR.ProductId 
	   
	   INNER JOIN INDIGO031.Inventory.PackagingUnit AS pk  ON pd.PackagingUnitId = pk.Id
	   INNER JOIN INDIGO031.Inventory.InventoryRiskLevel AS nr  ON pd.InventoryRiskLevelId = nr.Id
	   INNER JOIN INDIGO031.Security.[UserInt] AS U  ON U.UserCode = cr.CreationUser 
	   INNER JOIN INDIGO031.Security.PersonInt AS p  ON p.Id = U.IdPerson 
	   LEFT OUTER JOIN INDIGO031.Inventory.RemissionEntranceDetailBatchSerial AS Pen ON Pen.RemissionEntranceDetailId = DR.Id 
	   LEFT OUTER JOIN INDIGO031.Inventory.ATC AS catc  ON catc.Id = pd.ATCId
	  LEFT OUTER JOIN INDIGO031.Inventory.DCI AS DC  ON DC.Id = catc.DCIId
	   left outer join INDIGO031.Inventory.InventoryMeasurementUnit as mup  on mup.Id=catc.WeightMeasureUnit
	   left outer join INDIGO031.Inventory.InventoryMeasurementUnit as muv  on muv.Id=catc.VolumeMeasureUnit
	   left outer join INDIGO031.Inventory.InventoryMeasurementUnit as mua  on mua.Id=catc.AdministrationUnitId
	   left outer join INDIGO031.Inventory.InventorySupplie as s  on s.Id=pd.SupplieId 
	   LEFT OUTER JOIN INDIGO031.Inventory.BatchSerial as lote  ON lote.Id=Pen.BatchSerialId
	   left outer join INDIGO031.Inventory.PharmaceuticalForm as forma  on forma.Id=catc.PharmaceuticalFormId
	   LEFT OUTER JOIN INDIGO031.Inventory.Manufacturer AS f  ON f.Id = pd.ManufacturerId 
	   left outer join (select p.Code, d.ProductId
							from INDIGO031.Inventory.PurchaseOrder as p 
							inner join INDIGO031.Inventory.PurchaseOrderDetail as d on d.PurchaseOrderId=p.Id
							group by p.Code, d.ProductId) as orden on orden.Code=DR.SourceCode and orden.ProductId=DR.ProductId and DR.RemissionSource=2
WHERE (cr.Status <> '3') 

/*(Pen.OutstandingQuantity > '0') AND*/ 

--and cr.code='TJA0000339'-- and catc.code='00870'
--AND 


--SELECT * FROM Inventory.RemissionEntranceDetail
--WHERE RemissionEntranceId='15'
--SELECT * FROM   Inventory.RemissionEntrance
--WHERE CODE='DUI0000003'
