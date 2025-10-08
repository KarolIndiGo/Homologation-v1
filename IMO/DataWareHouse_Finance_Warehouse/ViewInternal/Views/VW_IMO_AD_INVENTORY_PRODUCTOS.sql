-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INVENTORY_PRODUCTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_Inventory_Productos
AS

SELECT 
pr.Id, pr.Code AS Còdigo, pr.Name AS Nombre, tpr.Name AS [Tipo producto], cuenta.Number AS Cuenta, cuenta.Name AS CuentaIngreso, 

case when catc.Code is not null then catc.Code else ins.Code end AS [Código Agrupador], 
case when catc.Name is not null then catc.Name else ins.SupplieName end AS [Agrupador], 

pr.CodeCUM AS [Código CUM], pr.CodeAlternative AS [ATC], pr.CodeAlternativeTwo AS [Código alterno], 
           pr.Description AS Descripción, gp.Name AS Grupo, sg.Code AS [Código Subgrupo], sg.Name AS [Nombre subgrupo], ue.Name AS [Unidad de empaque], f.Id as IdFab,f.Name AS Fabricante, pr.Presentation, pr.ExpirationDate AS [Fecha vencimiento], gf.Name AS [Grupo facturación], 
           CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Producto Control], CASE pr.ProductWithPriceControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Maneja control precios], CASE pr.POSProduct WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS POS, 
           CASE  WHEN pr.ControlOrderQuantity='0' and tpr.Name ='DISPOSITIVO MEDICO' OR tpr.Name ='ELEMENTOS DE CONSUMO' THEN 'No' 
				 WHEN pr.ControlOrderQuantity='1' and tpr.Name ='DISPOSITIVO MEDICO' OR tpr.Name ='ELEMENTOS DE CONSUMO' THEN 'Si' ELSE '' END AS [Control cantidad X orden],
		   CASE WHEN  tpr.Name ='DISPOSITIVO MEDICO' OR tpr.Name ='ELEMENTOS DE CONSUMO' THEN pr.ProductOrderAmount ELSE '' END AS [Cantidad producto x Orden], 
			pr.LastPurchase AS [Ultima compra], pr.LastSale AS [Ultima Venta], 
           CASE pr.ProductOrigin WHEN '1' THEN 'Nacional' WHEN '2' THEN 'Importado' END AS [Origen producto], pr.MinimumStock AS [Stock minimo], pr.MaximumStock AS [stock máximo], pr.ProductCost AS [Costo promedio], pr.FinalProductCost AS [Ultimo costo], pr.SellingPrice AS [Precio Venta], 
           --CASE pr.AllPOSPathologies WHEN '1' THEN 'Si' WHEN '0' THEN 'No' END AS [Aplica todas patologías], 
		   CASE pr.Status WHEN '0' THEN 'Inactivo' WHEN '1' THEN 'Activo' END AS Estado, sp.Fullname AS Usuario, pr.CreationDate AS [Fecha creación], pr.HealthRegistration AS RegistroSanitario,
		   ControlCostPercentage as [% Var Costo Prom.], 
		   case WHEN  tpr.Name ='DISPOSITIVO MEDICO' OR tpr.Name ='ELEMENTOS DE CONSUMO' 
		   and pr.JustificationSuppliesDispositives=1 then 'Si' 
		   when  tpr.Name ='DISPOSITIVO MEDICO' OR tpr.Name ='ELEMENTOS DE CONSUMO' 
		   and pr.JustificationSuppliesDispositives=0 then 'No' else '' end as [Justificacion Ins/Disp],
		   case SanitaryRegistration when 1 then 'Vigente' 
									 when 2 then 'En Tramite Renov' 
									 when 3 then 'Vencido' 
									 when 4 then 'Abandono' 
									 when 5 then 'Cancelado' 
									 when 6 then 'Negado' 
									 when 7 then 'Perdida Fuerza Ejec'
									 when 8 then 'Revocado'
									 when 9 then 'Suspendido'
									 when 10 then 'Inactivo' end as [Estado R. Sanitario],	 pr.ExpirationDate as FechaVencimiento, pr.Abbreviation as Abreviacion, IUM, 
									 case when pr.OsteosynthesisMaterial=1 then 'Si' when pr.OsteosynthesisMaterial=0 then 'No' end as MAOS--, 
									 --CASE PR.TaxedProduct WHEN 1 THEN 'Si' when 0 then 'No' end as 'Producto Gravado', iva.code+'-'+IVA.Name AS CodigoIVA, 
									 -- CASE PR.LiquidateSalesTaxes WHEN 1 THEN 'Si' when 0 then 'No' end as 'Gravado Venta Salud'
								
FROM   [INDIGO035].[Inventory].[InventoryProduct] AS pr  INNER JOIN
           [INDIGO035].[Inventory].[ProductType] AS tpr  ON tpr.Id = pr.ProductTypeId INNER JOIN
           [INDIGO035].[Inventory].[ProductGroup] AS gp  ON gp.Id = pr.ProductGroupId INNER JOIN
           [INDIGO035].[Inventory].[ProductSubGroup] AS sg  ON sg.Id = pr.ProductSubGroupId INNER JOIN
           [INDIGO035].[GeneralLedger].[MainAccounts] AS cuenta  ON cuenta.Id = gp.IncomeAccountId  INNER JOIN
           [INDIGO035].[Inventory].[PackagingUnit] AS ue  ON ue.Id = pr.PackagingUnitId left outer join --INNER JOIN
           [INDIGO035].[Inventory].[Manufacturer] AS f  ON f.Id = pr.ManufacturerId LEFT OUTER JOIN
           [INDIGO035].[Billing].[BillingGroup] AS gf  ON gf.Id = pr.BillingGroupId LEFT OUTER JOIN
           [INDIGO035].[Security].[UserInt] AS s  ON s.UserCode = pr.CreationUser LEFT OUTER JOIN
           [INDIGO035].[Security].[PersonInt] AS sp  ON sp.Id = s.IdPerson LEFT OUTER JOIN
           [INDIGO035].[Inventory].[ATC] AS catc  ON catc.Id = pr.ATCId left outer join
		   [INDIGO035].[Inventory].[InventorySupplie] as ins on ins.Id=pr.SupplieId left outer join 
		   [INDIGO035].[GeneralLedger].[GeneralLedgerIVA] AS IVA ON IVA.Id=pr.IVAId
--WHERE (pr.Code NOT LIKE '800-%') --and pr.Status='1'-- and pr.code='25351-01'

