-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Inventory_AjustesInventario
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[IMO_Inventory_AjustesInventario]    Script Date: 29/04/2025 9:38:55 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE VIEW [ViewInternal].[IMO_Inventory_AjustesInventario] AS
SELECT        ma.Code AS Codigo, uo.UnitName AS Sede, ma.DocumentDate AS Fecha, 
CASE when ma.code='07900001414' then 'Entrada' when ma.code <>'07900001414' and ma.AdjustmentType= '1' THEN 'Entrada' 
											   when ma.code <>'07900001414' and ma.AdjustmentType= '2' THEN 'Salida' 
											   when ma.code <>'07900001414' and ma.AdjustmentType= '3' THEN 'Inventario_Fisico' END AS Tipo, 
RTRIM(con.Code) 
                         + ' - ' + RTRIM(con.Name) AS [Concepto Ajuste]/*, hca.ConceptoHomologo*/, RTRIM(al.Code) + ' - ' + RTRIM(al.Name) AS Almacen, RTRIM(T.Nit) + ' - ' + RTRIM(T.Name) AS Tercero, ma.Description, 
                         CASE ma.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dma.Quantity AS Cantidad, dma.UnitValue AS CostoPromedio, p.Code AS CodProducto, p.Name AS Producto, 
                         CASE WHEN ma.AdjustmentType = '1' THEN (dma.Quantity * dma.UnitValue) WHEN ma.AdjustmentType = '2' THEN - (dma.Quantity * dma.UnitValue) END AS VrTotal, per.Fullname AS UsuarioCrea, 
						/* RTRIM(conmov.Cuenta) + ' - ' + RTRIM(conmov.CuentaContable) AS CuentaContable, conmov.CentroCosto,*/ ma.description as Descripcion, p.ExpirationDate as [Fecha Vencimiento]
FROM            Inventory.InventoryAdjustment AS ma INNER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId LEFT JOIN
                         Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId INNER JOIN
                         Inventory.Warehouse AS al ON al.Id = ma.WarehouseId INNER JOIN
                         Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId INNER JOIN
                         Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id INNER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dma.ProductId INNER JOIN
                         Security.[User] AS U ON U.UserCode = ma.CreationUser INNER JOIN
                         Security.Person AS per ON per.Id = U.IdPerson --INNER JOIN
                         --[IN].[Inventory_ConceptosMovimiento] AS conmov ON conmov.Codigo = con.Code LEFT OUTER JOIN
                        -- dbo.HomologosConceptoAjusteInv1 AS hca ON hca.CodeAdjustment = con.Code
WHERE        (ma.Status <> '3') AND ma.AdjustmentConceptId IS NOT NULL

UNION ALL

SELECT        ma.Code AS Codigo, uo.UnitName AS Sede, ma.DocumentDate AS Fecha, 
CASE when ma.code='07900001414' then 'Entrada' when ma.code <>'07900001414' and ma.AdjustmentType= '1' THEN 'Entrada' 
											   when ma.code <>'07900001414' and ma.AdjustmentType= '2' THEN 'Salida' 
											   when ma.code <>'07900001414' and ma.AdjustmentType= '3' THEN 'Inventario_Fisico' END AS Tipo, 
RTRIM(con.Code) 
                         + ' - ' + RTRIM(con.Name) AS [Concepto Ajuste], --hca.ConceptoHomologo, 
						 RTRIM(al.Code) + ' - ' + RTRIM(al.Name) AS Almacen, RTRIM(T.Nit) + ' - ' + RTRIM(T.Name) AS Tercero, ma.Description, 
                         CASE ma.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dma.Quantity AS Cantidad, dma.UnitValue AS CostoPromedio, p.Code AS CodProducto, p.Name AS Producto, 
                         CASE WHEN ma.AdjustmentType = '1' THEN (dma.Quantity * dma.UnitValue) WHEN ma.AdjustmentType = '2' THEN - (dma.Quantity * dma.UnitValue) END AS VrTotal, per.Fullname AS UsuarioCrea, --RTRIM(conmov.Cuenta) ,
                         --+ ' - ' + RTRIM(conmov.CuentaContable) AS CuentaContable, conmov.CentroCosto, 
						 ma.description as Descripcion, p.ExpirationDate as [Fecha Vencimiento]
FROM            Inventory.InventoryAdjustment AS ma INNER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId INNER JOIN
                         --Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId INNER JOIN
                         Inventory.Warehouse AS al ON al.Id = ma.WarehouseId INNER JOIN
                         Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId INNER JOIN
                         Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id INNER JOIN
						 Inventory.AdjustmentConcept AS con ON con.Id = dma.AdjustmentConceptId INNER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dma.ProductId INNER JOIN
                         Security.[User] AS U ON U.UserCode = ma.CreationUser INNER JOIN
                         Security.Person AS per ON per.Id = U.IdPerson --LEFT JOIN
						 
                         --[IN].[Inventory_ConceptosMovimiento] AS conmov ON conmov.ID = dma.AdjustmentConceptId LEFT OUTER JOIN
                         --dbo.HomologosConceptoAjusteInv1 AS hca ON hca.CodeAdjustment = con.Code
WHERE        (ma.Status <> '3') AND ma.AdjustmentConceptId IS NULL
