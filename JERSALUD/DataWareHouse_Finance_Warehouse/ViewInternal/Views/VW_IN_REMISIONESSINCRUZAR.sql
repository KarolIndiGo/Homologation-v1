-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_IN_REMISIONESSINCRUZAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_IN_REMISIONESSINCRUZAR
AS
SELECT  
uo.UnitName AS Sede, 
cr.Code AS [Cod Remision], 
cr.RemissionDate AS [Fecha Remision],
pd.Code AS [Cod Producto], 
pd.Name AS Producto,   
DC.Name as [Principio Activo], 
catc.Weight as [Peso], 
mup.Name as [Unidad Peso],
case
    when catc.FormulationType=1 then mup.Name 
    when catc.FormulationType=2 then muv.Name  
    when catc.FormulationType=3 then concat( mup.Name, '/' , muv.Name) 
    when catc.FormulationType=4 then mua.Name 
    end as [Unidad de Medida],
Pen.Quantity AS Cantidad, 
DR.TotalValue AS Total, 
Pen.OutstandingQuantity AS Pendiente_Cruzar, 
pd.ProductCost AS [Costo Promedio], 
pd.ProductCost*Pen.Quantity AS ValorTotalProm, 
lote.ExpirationDate as	[Fecha de Vencimiento],
PR.Code AS [Codigo Proveedor], 
PR.Name AS NombreProveedor
, AL.Code AS [Codigo Almacen]
, AL.Name AS Almacen
, cr.RemissionNumber AS [Numero Remision]
, cr.Description AS Descripcion
, cr.Value AS [Vr Remision]
, cr.IvaValue AS Iva, 
CASE cr.Status 
    WHEN '1' THEN 'Registrada' 
    WHEN '2' THEN 'Confirmada' 
    WHEN '3' THEN 'Anulada' END AS Estado_Remision, 
CASE cr.ProductStatus 
    WHEN '1' THEN 'Sin_Movimientos' 
    WHEN '2' THEN 'Parcial' 
    WHEN '3' THEN 'Total' END AS Estado_Productos, 
p.Fullname AS Usuario 

FROM [INDIGO031].[Inventory].[RemissionEntrance] AS cr  
INNER JOIN [INDIGO031].[Common].[OperatingUnit] AS uo  ON uo.Id = cr.OperatingUnitId 
INNER JOIN [INDIGO031].[Common].[Supplier] AS PR  ON PR.Id = cr.SupplierId 
INNER JOIN [INDIGO031].[Inventory].[Warehouse] AS AL  ON AL.Id = cr.WarehouseId 
INNER JOIN [INDIGO031].[Inventory].[RemissionEntranceDetail] AS DR  ON DR.RemissionEntranceId = cr.Id 
INNER JOIN [INDIGO031].[Inventory].[InventoryProduct] AS pd  ON pd.Id = DR.ProductId 
INNER JOIN [INDIGO031].[Inventory].[PackagingUnit] AS pk  ON pd.PackagingUnitId = pk.Id
INNER JOIN [INDIGO031].[Inventory].[InventoryRiskLevel] AS nr  ON pd.InventoryRiskLevelId = nr.Id
INNER JOIN [INDIGO031].[Security].[UserInt] AS U  ON U.UserCode = cr.CreationUser 
INNER JOIN [INDIGO031].[Security].[PersonInt] AS p  ON p.Id = U.IdPerson 
LEFT OUTER JOIN [INDIGO031].[Inventory].[RemissionEntranceDetailBatchSerial] AS Pen ON Pen.RemissionEntranceDetailId = DR.Id 
LEFT OUTER JOIN [INDIGO031].[Inventory].[ATC] AS catc  ON catc.Id = pd.ATCId
LEFT OUTER JOIN [INDIGO031].[Inventory].[DCI] AS DC  ON DC.Id = catc.DCIId
left outer join [INDIGO031].[Inventory].[InventoryMeasurementUnit] as mup  on mup.Id=catc.WeightMeasureUnit
left outer join [INDIGO031].[Inventory].[InventoryMeasurementUnit] as muv  on muv.Id=catc.VolumeMeasureUnit
left outer join [INDIGO031].[Inventory].[InventoryMeasurementUnit] as mua  on mua.Id=catc.AdministrationUnitId
left outer join [INDIGO031].[Inventory].[InventorySupplie] as s  on s.Id=pd.SupplieId 
LEFT OUTER JOIN [INDIGO031].[Inventory].[BatchSerial] as lote  ON lote.Id=Pen.BatchSerialId
left outer join [INDIGO031].[Inventory].[PharmaceuticalForm] as forma  on forma.Id=catc.PharmaceuticalFormId
LEFT OUTER JOIN [INDIGO031].[Inventory].[Manufacturer] AS f  ON f.Id = pd.ManufacturerId
left outer join (select p.Code, d.ProductId
                    from [INDIGO031].[Inventory].[PurchaseOrder] as p 
                    inner join [INDIGO031].[Inventory].[PurchaseOrderDetail] as d on d.PurchaseOrderId=p.Id
                    group by p.Code, d.ProductId) as orden on orden.Code=DR.SourceCode and orden.ProductId=DR.ProductId and DR.RemissionSource=2
WHERE (cr.Status <> '3') and Pen.OutstandingQuantity > '0'

