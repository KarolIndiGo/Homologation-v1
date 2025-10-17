-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE12_AD_Inventory_ManualProductos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE12_AD_Inventory_ManualProductos]
AS
SELECT 
        dT.Id, T.Code AS Manual, T.Id AS IdManual, T.Name AS Descripción, 
		p.Code AS Código, p.Id AS IdProducto, 
CASE WHEN ATT.ID IS NULL THEN APP.CODE ELSE ATT.CODE END AS CodAgrupador,
CASE WHEN ATT.ID IS NULL THEN APP.SupplieName ELSE ATT.name END AS Agrupador,
                         p.CodeAlternative AS [ATC], p.CodeAlternativeTwo AS [Código Alterno], p.CodeCUM AS [Código CUM], p.Name AS Descripcion, G.Name AS Grupo, SG.Name AS Subgrupo, p.ProductControl AS [Medicamento de Control],
                          p.POSProduct AS POS, 
						  p.ProductCost AS [Costo Promedio], p.FinalProductCost AS [Ultimo costo],
                          p.LastSale AS [ultima compra], p.SellingPrice AS [Precio Venta], dT.InitialDate AS [Fecha Inicial], dT.EndDate AS [Fecha Final], dT.SalesValue AS [Vr Producto], 
                         
                         T.ModificationDate AS [Fecha Modificación Plantilla], sg.id as IdSubGrupo
FROM           Inventory.ProductRate AS T  INNER JOIN
                         Inventory.ProductRateDetail AS dT  ON T.Id = dT.ProductRateId INNER JOIN
                         Inventory.InventoryProduct AS p  ON p.Id = dT.ProductId LEFT OUTER JOIN
						 Inventory.ATC AS ATT  ON ATT.ID=P.ATCID LEFT OUTER JOIN
						 [Inventory].[InventorySupplie] AS APP  ON APP.ID=P.SupplieId LEFT OUTER JOIN
                         --VIESECURITY.Security.[User] AS u1  ON u1.UserCode = T.ModificationUser LEFT OUTER JOIN
                         --VIESECURITY.Security.Person AS p1  ON p1.Id = u1.IdPerson LEFT OUTER JOIN
                         Inventory.ProductGroup AS G  ON G.Id = p.ProductGroupId INNER JOIN
                        Inventory.ProductSubGroup AS SG  ON SG.Id = p.ProductSubGroupId LEFT OUTER JOIN
                         Billing.BillingGroup AS gf ON gf.Id = p.BillingGroupId INNER JOIN
                             (SELECT        ProductRateId, ProductId, MAX(EndDate) AS Max_Fecha
                               FROM           Inventory.ProductRateDetail
                               WHERE        (EndDate > '12/31/2015 23:59:59')
                               GROUP BY ProductRateId, ProductId) AS SC ON dT.ProductRateId = SC.ProductRateId AND dT.ProductId = SC.ProductId --AND SC.Max_Fecha = dT.EndDate
WHERE        (T.Status = 1) AND (p.Status = 1) and dt.EndDate > getdate() --''31-01-2020 23:59'' 
and dt.initialDate >= '08-01-2018' 
