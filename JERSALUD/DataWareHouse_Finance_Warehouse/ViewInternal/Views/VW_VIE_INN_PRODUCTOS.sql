-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_INN_PRODUCTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_INN_PRODUCTOS AS
     SELECT DISTINCT 
			pr.Id, 
            pr.Code AS Còdigo, 
            pr.Name AS Nombre, 
            tpr.Name AS [Tipo producto], 
            cuenta.Number AS Cuenta, 
            cuenta.Name AS CuentaIngreso, 
            ATC.Code AS CodATC, 
            ATC.Name AS ATC, 
			CASE tpr.Class
				WHEN 1 THEN 'Grupo'
				WHEN 2 THEN 'Medicamento'
				WHEN 3 THEN 'Insumo'
				WHEN 4 THEN 'Otro'
				WHEN 5 THEN 'Producción'
			END ClaseProducto,
			CASE tpr.Class
				WHEN 2 THEN catc.Code
				WHEN 3 THEN ins.Code
			END AS [Cod Medicamento],
			CASE tpr.Class
				WHEN 2 THEN catc.Name
				WHEN 3 THEN ins.SupplieName
			END AS [Nombre Medicamento],
            pr.CodeCUM AS [Código CUM], 
			pr.IUM,
            pr.CodeAlternative AS [Código Alterno], 
            pr.CodeAlternativeTwo AS [Código alterno 2], 
            pr.Description AS Descripción, 
            dci.Code AS [Codigo DCI], 
            dci.Name AS DCI, 
            gp.Name AS Grupo, 
            sg.Code AS [Código Subgrupo], 
            sg.Name AS [Nombre subgrupo], 
            ue.Name AS [Unidad de empaque], 
            f.Name AS Fabricante, 
            pr.Presentation, 
            pr.ExpirationDate AS [Fecha vencimiento], 
            pr.HealthRegistration AS RegistroSanitario, 
            gf.Name AS [Grupo facturación],
			CASE pr.ProductControl
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Control'
            END AS [Producto Control],
            CASE pr.ProductWithPriceControl
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Control precios'
            END AS [Maneja control precios],
            CASE pr.POSProduct
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Si'
            END AS POS,
            CASE pr.ControlOrderQuantity
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Si'
            END AS [Control cantidad X orden], 
            pr.ProductOrderAmount AS [Cantidad producto x Orden], 
            pr.LastPurchase AS [Ultima compra], 
            pr.LastSale AS [Ultima Venta],
            CASE pr.ProductOrigin
                WHEN '1'
                THEN 'Nacional'
                WHEN '2'
                THEN 'Importado'
            END AS [Origen producto], 
            pr.MinimumStock AS [Stock minimo], 
            pr.MaximumStock AS [stock máximo], 
            pr.ControlCostPercentage AS [% Vr Costo], 
            pr.ProductCost AS [Costo promedio], 
            pr.FinalProductCost AS [Ultimo costo], 
            pr.SellingPrice AS [Precio Venta],
            CASE pr.AllPOSPathologies
                WHEN '1'
                THEN 'Si'
                WHEN '0'
                THEN 'No'
            END AS [Aplica todas patologías],
            CASE pr.Status
                WHEN '0'
                THEN 'Inactivo'
                WHEN '1'
                THEN 'Activo'
            END AS Estado, 
            IVA.Name AS IVA, 
            sp.Fullname AS UsuarioCreaProducto, 
            pr.CreationDate AS [Fecha creación], 
            sp3.Fullname AS UsuarioModificaProducto, 
            pr.ModificationDate AS FecModificaProd, 
            sp1.Fullname AS UsuarioCreaMedicamento, 
            sp2.Fullname AS UsuarioModificaMedicamento, 
            catc.ModificationDate AS FechaModificacionMedicamento
     FROM INDIGO031.Inventory.InventoryProduct AS pr 
          INNER JOIN INDIGO031.Inventory.ProductType AS tpr  ON tpr.Id = pr.ProductTypeId AND pr.Status = 1
          INNER JOIN INDIGO031.Inventory.ProductGroup AS gp  ON gp.Id = pr.ProductGroupId
          INNER JOIN INDIGO031.Inventory.ProductSubGroup AS sg  ON sg.Id = pr.ProductSubGroupId
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS cuenta  ON cuenta.Id = gp.IncomeAccountId
          INNER JOIN INDIGO031.Inventory.PackagingUnit AS ue  ON ue.Id = pr.PackagingUnitId
          INNER JOIN INDIGO031.Inventory.Manufacturer AS f  ON f.Id = pr.ManufacturerId
          LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS gf  ON gf.Id = pr.BillingGroupId
          LEFT OUTER JOIN INDIGO031.[Security].[UserInt] AS s ON s.UserCode = pr.CreationUser
          LEFT OUTER JOIN INDIGO031.[Security].PersonInt AS sp ON sp.Id = s.IdPerson
          LEFT OUTER JOIN INDIGO031.GeneralLedger.GeneralLedgerIVA AS IVA ON IVA.Id = pr.IVAId
          LEFT OUTER JOIN INDIGO031.Inventory.ATC AS catc  ON catc.Id = pr.ATCId AND catc.Status = 1
		  LEFT OUTER JOIN INDIGO031.Inventory.DCI AS dci  ON catc.DCIId = dci.Id AND dci.Status = 1
		  LEFT OUTER JOIN INDIGO031.Inventory.InventorySupplie AS ins  ON ins.Id = pr.SupplieId 
          LEFT OUTER JOIN INDIGO031.Inventory.ATCEntity AS ATC ON catc.ATCEntityId = ATC.Id
          LEFT OUTER JOIN INDIGO031.[Security].[UserInt] AS s1 ON s1.UserCode = catc.CreationUser
          LEFT OUTER JOIN INDIGO031.[Security].PersonInt AS sp1 ON sp1.Id = s1.IdPerson
          LEFT OUTER JOIN INDIGO031.[Security].[UserInt] AS s2 ON s2.UserCode = catc.ModificationUser
          LEFT OUTER JOIN INDIGO031.[Security].PersonInt AS sp2 ON sp2.Id = s2.IdPerson
          LEFT OUTER JOIN INDIGO031.[Security].UserInt AS s3 ON s3.UserCode = pr.ModificationUser
          LEFT OUTER JOIN INDIGO031.[Security].PersonInt AS sp3 ON sp3.Id = s3.IdPerson