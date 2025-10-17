-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_AjusteInventario_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_AjusteInventario_PB] AS 
SELECT        ma.Code AS Codigo,  uo.unitname  AS Sede, ma.DocumentDate AS Fecha, 
CASE ma.AdjustmentType WHEN '1' THEN 'Entrada' WHEN '2' THEN 'Salida' WHEN '3' THEN 'Inventario_Fisico' END AS Tipo,
RTRIM(con.Code) 
                         + ' - ' + RTRIM(con.Name) AS [Concepto Ajuste], hca.Homologo as ConceptoHomologo, RTRIM(al.Code) + ' - ' + RTRIM(al.Name) AS Almacen, RTRIM(T.Nit) + ' - ' + RTRIM(T.Name) AS Tercero, ma.Description, 
                         CASE ma.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dma.Quantity AS Cantidad, dma.UnitValue AS CostoPromedio, p.Code AS CodProducto, p.Name AS Producto, 
                         CASE WHEN ma.AdjustmentType = '1' THEN (dma.Quantity * dma.UnitValue) WHEN ma.AdjustmentType = '2' THEN - (dma.Quantity * dma.UnitValue) END AS VlrTotal, per.Fullname AS UsuarioCrea, RTRIM(conmov.Cuenta) 
                         + ' - ' + RTRIM(conmov.CuentaContable) AS CuentaContable, conmov.CentroCosto, ma.description as Descripcion
FROM            Inventory.InventoryAdjustment AS ma INNER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId INNER JOIN
                         Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId INNER JOIN
                         Inventory.Warehouse AS al ON al.Id = ma.WarehouseId INNER JOIN
                         Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId INNER JOIN
                         Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id INNER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dma.ProductId INNER JOIN
                         Security.[User] AS U ON U.UserCode = ma.CreationUser INNER JOIN
                         Security.Person AS per ON per.Id = U.IdPerson INNER JOIN
                         ViewInternal.VIE_AD_Inventory_ConceptosMovimiento_PB AS conmov ON conmov.Codigo = con.Code LEFT OUTER JOIN
                         ViewInternal.ConceptosAjustesHomologo AS hca ON hca.id = con.id
WHERE        (ma.Status <> '3') AND ma.AdjustmentConceptId IS NOT NULL


UNION ALL

SELECT       ma.Code AS Codigo,  uo.unitname  AS Sede, ma.DocumentDate AS Fecha, 
CASE ma.AdjustmentType WHEN '1' THEN 'Entrada' WHEN '2' THEN 'Salida' WHEN '3' THEN 'Inventario_Fisico' END AS Tipo,
RTRIM(con.Code)+ ' - ' + RTRIM(con.Name) AS [Concepto Ajuste], hca.Homologo as ConceptoHomologo, RTRIM(al.Code) + ' - ' + RTRIM(al.Name) AS Almacen, RTRIM(T.Nit) + ' - ' + RTRIM(T.Name) AS Tercero, ma.Description, 
                         CASE ma.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dma.Quantity AS Cantidad, dma.UnitValue AS CostoPromedio, p.Code AS CodProducto, p.Name AS Producto, 
                         CASE WHEN ma.AdjustmentType = '1' THEN (dma.Quantity * dma.UnitValue) WHEN ma.AdjustmentType = '2' THEN - (dma.Quantity * dma.UnitValue) END AS VlrTotal, per.Fullname AS UsuarioCrea, RTRIM(conmov.Cuenta) 
                         + ' - ' + RTRIM(conmov.CuentaContable) AS CuentaContable, conmov.CentroCosto, ma.description as Descripcion
FROM            Inventory.InventoryAdjustment AS ma INNER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId INNER JOIN
                         --Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId INNER JOIN
                         Inventory.Warehouse AS al ON al.Id = ma.WarehouseId INNER JOIN
                         Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId INNER JOIN
                         Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id INNER JOIN
						 Inventory.AdjustmentConcept AS con ON con.Id = dma.AdjustmentConceptId INNER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dma.ProductId INNER JOIN
                         Security.[User] AS U ON U.UserCode = ma.CreationUser INNER JOIN
                         Security.Person AS per ON per.Id = U.IdPerson INNER JOIN
                         ViewInternal.VIE_AD_Inventory_ConceptosMovimiento_PB AS conmov ON conmov.Codigo = con.Code LEFT OUTER JOIN
                         ViewInternal.ConceptosAjustesHomologo AS hca ON hca.id = con.id
WHERE        (ma.Status <> '3') AND ma.AdjustmentConceptId IS NULL

--select * from ViewInternal.ConceptosAjustesHomologo
