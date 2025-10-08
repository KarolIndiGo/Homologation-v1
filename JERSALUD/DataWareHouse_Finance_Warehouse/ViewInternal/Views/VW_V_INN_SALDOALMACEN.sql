-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_SALDOALMACEN
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_SALDOALMACEN AS

SELECT  
            pr.Id AS IdProducto, 
            pr.Code AS Codigo, 
            pr.Name AS Producto, 
            tpr.Name AS [Tipo Producto], 
            atc.Code AS CodMedicamento, 
            atc.Name AS Medicamento,
            CASE
                WHEN atc.Code IS NOT NULL
                THEN atc.Code
                ELSE sp.Code
            END AS [Codigo Agrupador],
            CASE
                WHEN atc.Name IS NOT NULL
                THEN atc.Name
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
            CAST(pr.ProductCost AS DECIMAL(18,2)) AS CostoPromedio, 
            CAST(pr.FinalProductCost AS DECIMAL(18,2)) AS Ultimocosto,
            CASE pr.Status
                WHEN '1'
                THEN 'Activo'
                WHEN '0'
                THEN 'Inactivo'
            END AS Estado, 
            inf.Quantity AS Cantidad, 
            L.BatchCode AS Lote, 
            L.ExpirationDate AS FechaVencimiento, 
            DATEDIFF(MONTH, GETDATE(), L.ExpirationDate) AS [VidaUtil (meses)],
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
            CASE pr.Status
                WHEN 1
                THEN 'Activo'
                WHEN 0
                THEN 'Inactivo'
            END AS EstadoProducto,
            CASE pr.POSProduct
                WHEN 1
                THEN 'POS'
                WHEN 0
                THEN 'NO POS'
            END AS POS,
            CASE pr.ProductWithPriceControl
                WHEN 1
                THEN 'Regulado'
                WHEN 0
                THEN 'Standard'
            END AS 'Precio Regulado',
            CASE atc.HighCost
                WHEN 1
                THEN 'Alto Costo'
                WHEN 0
                THEN 'Standard'
            END AS AltoCosto, 
            case when pr.ProductCost = 0 then 0 else CONVERT(DECIMAL(15, 2), ((pr.FinalProductCost - pr.ProductCost) * 100) / pr.ProductCost) end AS VariacionCosto,
            DCI.Name AS DCI, 
            G.Name AS Grupo,
            CASE
                WHEN  DATEDIFF(MONTH, GETDATE(), L.ExpirationDate) <= 6 THEN 'ROJO'
                WHEN  DATEDIFF(MONTH, GETDATE(), L.ExpirationDate) BETWEEN 6 AND 12 THEN 'AMARILLO'
                WHEN  DATEDIFF(YEAR , GETDATE(), L.ExpirationDate) >= 1 THEN 'VERDE'
            END as Semaforizacion_Vencimiento,
            pr.HealthRegistration AS RegistroSanitario,
            R.Name AS NivelRiesgo
     FROM INDIGO031.Inventory.InventoryProduct AS pr
          LEFT OUTER JOIN INDIGO031.Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id
          LEFT OUTER JOIN INDIGO031.Inventory.Warehouse AS al ON al.Id = inf.WarehouseId
          LEFT OUTER JOIN INDIGO031.Inventory.ATC AS atc ON atc.Id = pr.ATCId
          LEFT OUTER JOIN INDIGO031.Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
          LEFT OUTER JOIN INDIGO031.Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId
          LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId
          LEFT OUTER JOIN INDIGO031.Inventory.InventorySupplie AS sp ON sp.Id = pr.SupplieId
          LEFT OUTER JOIN INDIGO031.Inventory.ProductType AS tpr ON pr.ProductTypeId = tpr.Id
          LEFT OUTER JOIN INDIGO031.Inventory.BatchSerial AS L ON inf.BatchSerialId = L.Id
          LEFT OUTER JOIN INDIGO031.Inventory.DCI AS DCI ON atc.DCIId = DCI.Id
          LEFT OUTER JOIN INDIGO031.Inventory.ProductGroup AS G ON G.Id = pr.ProductGroupId
          LEFT OUTER JOIN INDIGO031.Inventory.InventoryRiskLevel AS R ON R.Id = pr.InventoryRiskLevelId
     WHERE(inf.Quantity <> '0') 