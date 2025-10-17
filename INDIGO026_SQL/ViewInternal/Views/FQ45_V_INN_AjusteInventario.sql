-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_AjusteInventario
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_AjusteInventario]
AS
--SELECT CASE A.OperatingUnitId WHEN 3 THEN 'Bogota' END
--          AS Sede,
--       A.DocumentDate
--          AS Fecha,
--       A.Code
--          AS Documento,
--       CASE A.AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END
--          AS Tipo,
--       B.Code
--          AS CodAlm,
--       B.Name
--          AS Almacen,
--       C.Code
--          AS CodCon,
--       C.Name
--          AS Concepto,
--       P.Code
--          AS CodProducto,
--       P.Name
--          AS Producto,
--       DA.Quantity
--          AS Cant,
--       DA.UnitValue
--          AS ValorUnitario,
--       DA.Quantity * DA.UnitValue
--          AS VlrTotal,
--       P.ProductCost
--          AS CostoProm,
--       A.Description
--          AS Detalle      -- U.UserCode AS CodUser, U1.Fullname AS UsuarioCrea
--FROM Inventory.InventoryAdjustment AS A
--     INNER JOIN Inventory.InventoryAdjustmentDetail AS DA
--        ON DA.InventoryAdjustmentId = A.Id AND A.Status = 2
--     INNER JOIN Inventory.Warehouse AS B ON A.WarehouseId = B.Id
--     INNER JOIN Inventory.AdjustmentConcept AS C
--        ON A.AdjustmentConceptId = C.Id
--     INNER JOIN Inventory.InventoryProduct AS P ON DA.ProductId = P.Id
----WHERE (CONVERT (NVARCHAR (10), A.DocumentDate, 20) >
----       CONVERT (NVARCHAR (10), GETDATE () - 180, 20))
--WHERE        (a.Status <> '3') and A.DocumentDate>='01-01-2020' 

--select top 20 * FROM Inventory.InventoryAdjustment 
--order by DocumentDate desc


SELECT     ma.OperatingUnitId,   ma.Code AS Codigo, case when ma.OperatingUnitId = '3' then 'Bogota' when ma.OperatingUnitId = '4' THEN 'Tunja' when ma.OperatingUnitId = '8' then 'Neiva'
when ma.OperatingUnitId = '9' then 'Florencia' when ma.OperatingUnitId = '10' then 'Cali' when ma.OperatingUnitId = '13' then 'Facatativa'  end AS Sede, ma.DocumentDate AS Fecha, 
CASE mA.AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS Tipo, 
RTRIM(con.Code) 
                         + ' - ' + RTRIM(con.Name) AS [Concepto Ajuste],/* hca.ConceptoHomologo,*/ RTRIM(al.Code) + ' - ' + RTRIM(al.Name) AS Almacen, RTRIM(T.Nit) + ' - ' + RTRIM(T.Name) AS Tercero, ma.Description, 
                         CASE ma.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dma.Quantity AS Cantidad, DMA.UnitValue AS ValorUnitario, (dma.Quantity * dma.UnitValue) as VrTotal, dma.UnitValue AS CostoPromedio, p.Code AS CodProducto, p.Name AS Producto, 
                         --CASE WHEN ma.AdjustmentType = '1' THEN (dma.Quantity * dma.UnitValue) WHEN ma.AdjustmentType = '2' THEN - (dma.Quantity * dma.UnitValue) END AS VrTotal,-- per.Fullname AS UsuarioCrea, RTRIM(conmov.Cuenta) 
                         --+ ' - ' + RTRIM(conmov.CuentaContable) AS CuentaContable, conmov.CentroCosto, 
						 ma.description as Descripcion
FROM            Inventory.InventoryAdjustment AS ma INNER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId INNER JOIN
                         Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId INNER JOIN
                         Inventory.Warehouse AS al ON al.Id = ma.WarehouseId INNER JOIN
                         Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId INNER JOIN
                         Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id INNER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dma.ProductId --INNER JOIN
                         --VIESECURITY.Security.[User] AS U ON U.UserCode = ma.CreationUser INNER JOIN
                         --VIESECURITY.Security.Person AS per ON per.Id = U.IdPerson INNER JOIN
                         --[IN].[Inventory_ConceptosMovimiento] AS conmov ON conmov.Codigo = con.Code LEFT OUTER JOIN
                         --dbo.HomologosConceptoAjusteInv1 AS hca ON hca.CodeAdjustment = con.Code
WHERE        (ma.Status <> '3') AND ma.AdjustmentConceptId IS NOT NULL

UNION ALL

SELECT    ma.OperatingUnitId,     ma.Code AS Codigo, case when ma.OperatingUnitId = '3' then 'Bogota' when ma.OperatingUnitId = '4' THEN 'Tunja' when ma.OperatingUnitId = '8' then 'Neiva'
when ma.OperatingUnitId = '9' then 'Florencia' when ma.OperatingUnitId = '10' then 'Cali' when ma.OperatingUnitId = '13' then 'Facatativa'  end AS Sede, ma.DocumentDate AS Fecha, 
CASE mA.AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS Tipo,
RTRIM(con.Code) 
                         + ' - ' + RTRIM(con.Name) AS [Concepto Ajuste], /*hca.ConceptoHomologo,*/ RTRIM(al.Code) + ' - ' + RTRIM(al.Name) AS Almacen, RTRIM(T.Nit) + ' - ' + RTRIM(T.Name) AS Tercero, ma.Description, 
                         CASE ma.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, dma.Quantity AS Cantidad, DMA.UnitValue AS ValorUnitario, (dma.Quantity * dma.UnitValue) as VrTotal, dma.UnitValue AS CostoPromedio, p.Code AS CodProducto, p.Name AS Producto, 
                         --CASE WHEN ma.AdjustmentType = '1' THEN (dma.Quantity * dma.UnitValue) WHEN ma.AdjustmentType = '2' THEN - (dma.Quantity * dma.UnitValue) END AS VrTotal, --per.Fullname AS UsuarioCrea, RTRIM(conmov.Cuenta) 
                         --+ ' - ' + RTRIM(conmov.CuentaContable) AS CuentaContable, conmov.CentroCosto,
						 ma.description as Descripcion
FROM            Inventory.InventoryAdjustment AS ma INNER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = ma.OperatingUnitId INNER JOIN
                         --Inventory.AdjustmentConcept AS con ON con.Id = ma.AdjustmentConceptId INNER JOIN
                         Inventory.Warehouse AS al ON al.Id = ma.WarehouseId INNER JOIN
                         Common.ThirdParty AS T ON T.Id = ma.ThirdPartyId INNER JOIN
                         Inventory.InventoryAdjustmentDetail AS dma ON dma.InventoryAdjustmentId = ma.Id INNER JOIN
						 Inventory.AdjustmentConcept AS con ON con.Id = dma.AdjustmentConceptId INNER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dma.ProductId --INNER JOIN
                         --VIESECURITY.Security.[User] AS U ON U.UserCode = ma.CreationUser INNER JOIN
                         --VIESECURITY.Security.Person AS per ON per.Id = U.IdPerson LEFT JOIN
                         --[IN].[Inventory_ConceptosMovimiento] AS conmov ON conmov.ID = dma.AdjustmentConceptId LEFT OUTER JOIN
                         --dbo.HomologosConceptoAjusteInv1 AS hca ON hca.CodeAdjustment = con.Code
WHERE        (ma.Status <> '3') AND ma.AdjustmentConceptId IS NULL
