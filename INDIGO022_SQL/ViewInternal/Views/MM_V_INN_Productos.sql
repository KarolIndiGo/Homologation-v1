-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_V_INN_Productos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[MM_V_INN_Productos]
AS
SELECT        
		pr.Id, 
		pr.Code AS Còdigo, 
		pr.Name AS Nombre, 
		tpr.Name AS [Tipo producto], 
		cuenta.Number AS Cuenta, 
		cuenta.Name AS CuentaIngreso, 
		catc.Code AS [Código ATC], 
		catc.Name AS [Nombre ATC], 
		pr.CodeCUM AS [Código CUM], 
        pr.CodeAlternative AS [Código alterno], pr.CodeAlternativeTwo AS [Código alterno 2], pr.Description AS Descripción, dci.Name AS DCI, gp.Name AS Grupo, sg.Code AS [Código Subgrupo], sg.Name AS [Nombre subgrupo], 
        ue.Name AS [Unidad de empaque], f.Name AS Fabricante, pr.Presentation, pr.ExpirationDate AS [Fecha vencimiento], gf.Name AS [Grupo facturación], 
        CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Control' END AS [Producto Control], CASE pr.ProductWithPriceControl WHEN '0' THEN 'No' WHEN '1' THEN 'Control precios' END AS [Maneja control precios], 
        CASE pr.POSProduct WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS POS, CASE pr.ControlOrderQuantity WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Control cantidad X orden], 
        pr.ProductOrderAmount AS [Cantidad producto x Orden], pr.LastPurchase AS [Ultima compra], pr.LastSale AS [Ultima Venta], CASE pr.ProductOrigin WHEN '1' THEN 'Nacional' WHEN '2' THEN 'Importado' END AS [Origen producto],
        pr.MinimumStock AS [Stock minimo], pr.MaximumStock AS [stock máximo], pr.ProductCost AS [Costo promedio], pr.FinalProductCost AS [Ultimo costo], pr.SellingPrice AS [Precio Venta], 
        CASE pr.AllPOSPathologies WHEN '1' THEN 'Si' WHEN '0' THEN 'No' END AS [Aplica todas patologías], CASE pr.Status WHEN '0' THEN 'Inactivo' WHEN '1' THEN 'Activo' END AS Estado,
		--sp.Fullname AS Usuario, 
        pr.CreationDate AS [Fecha creación], IVA.Name AS IVA, pr.HealthRegistration AS RegistroSanitario
FROM	INDIGO022.Inventory.InventoryProduct AS pr INNER JOIN
        INDIGO022.Inventory.ProductType AS tpr ON tpr.Id = pr.ProductTypeId INNER JOIN
        INDIGO022.Inventory.ProductGroup AS gp ON gp.Id = pr.ProductGroupId INNER JOIN
        INDIGO022.Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId INNER JOIN
        INDIGO022.GeneralLedger.MainAccounts AS cuenta ON cuenta.Id = gp.IncomeAccountId INNER JOIN
        INDIGO022.Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId INNER JOIN
        INDIGO022.Inventory.Manufacturer AS f ON f.Id = pr.ManufacturerId LEFT OUTER JOIN
        INDIGO022.Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId LEFT OUTER JOIN
        --GENESISSECURITY.Security.[User] AS s ON s.UserCode = pr.CreationUser LEFT OUTER JOIN
        --GENESISSECURITY.Security.Person AS sp ON sp.Id = s.IdPerson LEFT OUTER JOIN
        INDIGO022.GeneralLedger.GeneralLedgerIVA AS IVA ON IVA.Id = pr.IVAId LEFT OUTER JOIN
        INDIGO022.Inventory.ATC AS catc ON catc.Id = pr.ATCId LEFT OUTER JOIN
        INDIGO022.Inventory.DCI AS dci ON catc.DCIId = dci.Id