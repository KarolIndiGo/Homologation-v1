-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_IMO_INVENTORY_AJUSTESINVENTARIO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_IMO_INVENTORY_AJUSTESINVENTARIO
AS
SELECT        
    ma.Code AS Codigo
    ,ma.DocumentDate AS Fecha, 
CASE 
    when ma.Code='07900001414' then 'Entrada' 
    when ma.Code <>'07900001414' and ma.AdjustmentType= '1' THEN 'Entrada' 
	when ma.Code <>'07900001414' and ma.AdjustmentType= '2' THEN 'Salida' 
	when ma.Code <>'07900001414' and ma.AdjustmentType= '3' THEN 'Inventario_Fisico' END AS Tipo, 
RTRIM(con.Code) + ' - ' + RTRIM(con.Name) AS [Concepto Ajuste]
, RTRIM(al.Code) + ' - ' + RTRIM(al.Name) AS Almacen
, RTRIM(T.Nit) + ' - ' + RTRIM(T.Name) AS Tercero, ma.Description, 
CASE ma.Status 
    WHEN '1' THEN 'Registrado' 
    WHEN '2' THEN 'Confirmado' 
    WHEN '3' THEN 'Anulado' END AS Estado
, dma.Quantity AS Cantidad
, dma.UnitValue AS CostoPromedio
, p.Code AS CodProducto
, p.Name AS Producto,
CASE 
    WHEN ma.AdjustmentType = '1' THEN (dma.Quantity * dma.UnitValue) 
    WHEN ma.AdjustmentType = '2' THEN - (dma.Quantity * dma.UnitValue) END AS VrTotal
, per.Fullname AS UsuarioCrea
, ma.Description as Descripcion
, p.ExpirationDate as [Fecha Vencimiento]
, p.LastSale as [Ultimo Costo]

FROM INDIGO031.Inventory.InventoryAdjustment AS ma 
INNER JOIN INDIGO031.Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId 
INNER JOIN INDIGO031.Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId 
INNER JOIN INDIGO031.Inventory.Warehouse AS al ON al.Id = ma.WarehouseId 
INNER JOIN INDIGO031.Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId 
INNER JOIN INDIGO031.Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id 
INNER JOIN INDIGO031.Inventory.InventoryProduct AS p ON p.Id = dma.ProductId 
INNER JOIN INDIGO031.Security.UserInt AS U ON U.UserCode = ma.CreationUser 
INNER JOIN INDIGO031.Security.PersonInt AS per ON per.Id = U.IdPerson
WHERE (ma.Status <> '3') AND ma.AdjustmentConceptId IS NOT NULL

