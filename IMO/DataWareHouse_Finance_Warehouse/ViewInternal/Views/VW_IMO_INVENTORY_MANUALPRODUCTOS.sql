-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_INVENTORY_MANUALPRODUCTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_Inventory_ManualProductos
AS

SELECT        dT.Id, T.Code AS Manual, T.Id AS IdManual, T.Name AS Descripción, CASE T .Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS [Estado Manual], p.Code AS Código, p.Id AS IdProducto, 
                         p.CodeAlternative AS [ATC], p.CodeAlternativeTwo AS [Código Alterno], p.CodeCUM AS [Código CUM], p.Name AS Descripcion, G.Name AS Grupo, SG.Name AS Subgrupo, p.ProductControl AS [Medicamento de Control],
                          p.POSProduct AS POS, gf.Code + ' - ' + gf.Name AS [Grupo Facturación], p.ProductCost AS [Costo Promedio], p.FinalProductCost AS [Ultimo costo], CASE p.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado,
                          p.LastSale AS [ultima compra], p.SellingPrice AS [Precio Venta], dT.InitialDate AS [Fecha Inicial], dT.EndDate AS [Fecha Final], dT.SalesValue AS [Vr Producto], 
                         CASE p.ProductWithPriceControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Maneja control precios], RTRIM(u1.UserCode) + '-' + p1.Fullname AS [Usuario Modifica Plantilla], 
                         T.ModificationDate AS [Fecha Modificación Plantilla], SG.Id as IdSubGrupo,
						case Contracted when 1 then 'Si' when 0 then 'No' end as Contratado, 
						case Quoted when 1 then 'Si' when 0 then 'No' end as Cotizado
FROM            [INDIGO035].[Inventory].[ProductRate] AS T INNER JOIN
                         [INDIGO035].[Inventory].[ProductRateDetail] AS dT ON T.Id = dT.ProductRateId INNER JOIN
                         [INDIGO035].[Inventory].[InventoryProduct] AS p ON p.Id = dT.ProductId LEFT OUTER JOIN
                         [INDIGO035].[Security].[UserInt] AS u1 ON u1.UserCode = T.ModificationUser LEFT OUTER JOIN
                         [INDIGO035].[Security].[PersonInt] AS p1  ON p1.Id = u1.IdPerson LEFT OUTER JOIN
                         [INDIGO035].[Inventory].[ProductGroup] AS G ON G.Id = p.ProductGroupId INNER JOIN
                         [INDIGO035].[Inventory].[ProductSubGroup] AS SG ON SG.Id = p.ProductSubGroupId LEFT OUTER JOIN
                         [INDIGO035].[Billing].[BillingGroup] AS gf ON gf.Id = p.BillingGroupId INNER JOIN
                             (SELECT        ProductRateId, ProductId, MAX(EndDate) AS Max_Fecha
                               FROM            [INDIGO035].[Inventory].[ProductRateDetail]
                               WHERE        (EndDate > '2015/12/31 23:59:59')
                               GROUP BY ProductRateId, ProductId) AS SC ON dT.ProductRateId = SC.ProductRateId AND dT.ProductId = SC.ProductId --AND SC.Max_Fecha = dT.EndDate
WHERE        (T.Status = '1') AND (p.Status = '1') and dT.EndDate > getdate() --'31-01-2020 23:59' 
and dT.InitialDate >= '2018-08-01'