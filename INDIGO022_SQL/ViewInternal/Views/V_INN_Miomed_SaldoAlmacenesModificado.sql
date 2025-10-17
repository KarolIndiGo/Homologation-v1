-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_Miomed_SaldoAlmacenesModificado
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[V_INN_Miomed_SaldoAlmacenesModificado]
AS

SELECT pr.Id AS IdProducto, 
            pr.Code AS Codigo, 
            pr.Name AS Producto, 
            tpr.name AS [Tipo Producto], 
            atc.code AS CodMedicamento, 
            atc.name AS Medicamento,
            CASE
                WHEN atc.code IS NOT NULL
                THEN atc.Code
                ELSE sp.code
            END AS [Codigo Agrupador],
            CASE
                WHEN atc.Name IS NOT NULL
                THEN atc.name
                ELSE sp.SupplieName
            END AS [Agrupador], 
            pr.CodeCUM AS [C.U.M], 
            pr.CodeAlternative AS [Codigo Alterno], 
            pr.CodeAlternativeTwo AS [Codigo Alterno 2], 
            sg.Name AS SubGrupo, 
            ue.Abbreviation AS Unidad, 
            gf.Name AS [Grupo Facturacion],
            CASE pr.ProductControl
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Si'
            END AS [Producto Control], 
            CONVERT(MONEY, pr.ProductCost, 101) AS CostoPromedio, 
            CONVERT(MONEY, pr.FinalProductCost, 101) AS Ultimocosto,
            CASE pr.STATUS
                WHEN '1'
                THEN 'Activo'
                WHEN '0'
                THEN 'Inactivo'
            END AS Estado, 
            inf.Quantity AS Cantidad, 
            l.BatchCode AS Lote, 
            L.ExpirationDate AS FechaVencimiento, 
            inf.Quantity * pr.ProductCost AS VrTotal, 
            al.Id, 
            al.Code AS CodigoAlmacen, 
            al.Name AS Almacen, 
            al.Prefix, 
            pr.Description AS Descripcion,
            CASE WarehouseConsignment
                WHEN 1
                THEN 'Si'
                ELSE 'No'
            END AS [Almacen en Consignacion],
            CASE pr.STATUS
                WHEN 1
                THEN 'Activo'
                WHEN 0
                THEN 'Inactivo'
            END AS EstadoProducto,
            CASE PR.PosProduct
                WHEN 1
                THEN 'POS'
                WHEN 0
                THEN 'NO POS'
            END AS POS,
            CASE PR.ProductWithPriceControl
                WHEN 1
                THEN 'Regulado'
                WHEN 0
                THEN 'Standard'
            END AS 'Precio Regulado',
            CASE ATC.HighCost
                WHEN 1
                THEN 'Alto Costo'
                WHEN 0
                THEN 'Standard'
            END AS AltoCosto, 
            case when pr.ProductCost = 0 then 0 else CONVERT(DECIMAL(15, 2), ((pr.FinalProductCost - pr.ProductCost) * 100) / pr.ProductCost) end AS VariacionCosto,
            --CASE WHEN CONVERT(DECIMAL(15, 2), ((pr.FinalProductCost - pr.ProductCost) * 100) / pr.ProductCost, 101) < 0 
            --    THEN 'Menor a 0'
            --    WHEN CONVERT(DECIMAL(15, 2), ((pr.FinalProductCost - pr.ProductCost) * 100) / pr.ProductCost, 101) BETWEEN '0' AND '10'
            --    THEN 'De 0 a 10'
            --    WHEN CONVERT(DECIMAL(15, 2), ((pr.FinalProductCost - pr.ProductCost) * 100) / pr.ProductCost, 101) BETWEEN '10' AND '20'
            --    THEN 'De 11 a 20'
            --    WHEN CONVERT(DECIMAL(15, 2), ((pr.FinalProductCost - pr.ProductCost) * 100) / pr.ProductCost, 101) > 20
            --    THEN 'Mayor a 20'
            --END RangoVariacion, 
            DCI.Name AS DCI, 
            G.Name AS Grupo,
			--CASE
			-- WHEN  DATEDIFF(MONTH, GETDATE(), L.ExpirationDate) <= 6 THEN 'ROJO'
			-- WHEN  DATEDIFF(MONTH, GETDATE(), L.ExpirationDate) BETWEEN 6 AND 12 THEN 'AMARILLO'
			-- WHEN  DATEDIFF(YEAR , GETDATE(), L.ExpirationDate) >= 1 THEN 'VERDE'
			--END as Semaforizacion_Vencimiento
			CASE
			 WHEN  DATEDIFF(MONTH, GETDATE(), L.ExpirationDate) <= 3 THEN 'ROJO'
			 WHEN  DATEDIFF(MONTH, GETDATE(), L.ExpirationDate) BETWEEN 3 AND 6 THEN 'AMARILLO'
			 WHEN  DATEDIFF(MONTH , GETDATE(), L.ExpirationDate) >= 7 THEN 'VERDE'
			END as Semaforizacion_Vencimiento
     FROM Inventory.InventoryProduct AS pr 
          LEFT OUTER JOIN Inventory.PhysicalInventory AS inf  ON inf.ProductId = pr.Id
          LEFT OUTER JOIN Inventory.Warehouse AS al  ON al.Id = inf.WarehouseId
          LEFT OUTER JOIN Inventory.ATC  ON atc.Id = pr.ATCId
          LEFT OUTER JOIN Inventory.ProductSubGroup AS sg  ON sg.Id = pr.ProductSubGroupId
          LEFT OUTER JOIN Inventory.PackagingUnit AS ue  ON ue.Id = pr.PackagingUnitId
          LEFT OUTER JOIN Billing.BillingGroup AS gf  ON gf.Id = pr.BillingGroupId
          LEFT OUTER JOIN [Inventory].[InventorySupplie] AS sp  ON sp.id = pr.SupplieId
          LEFT OUTER JOIN Inventory.ProductType tpr ON pr.productTypeId = tpr.id
          LEFT OUTER JOIN inventory.BatchSerial L ON INF.BatchSerialId = L.Id
          LEFT OUTER JOIN Inventory.DCI ON ATC.DCIId = DCI.Id
         LEFT OUTER JOIN Inventory.ProductGroup AS G ON G.Id = Pr.ProductGroupId
     WHERE(inf.Quantity <> '0') 
