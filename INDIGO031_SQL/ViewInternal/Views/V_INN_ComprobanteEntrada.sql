-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_ComprobanteEntrada
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[V_INN_ComprobanteEntrada]
AS
     SELECT pr.Code AS Nit, 
            pr.Name AS Proveedor, 
            cce.Code AS Comprobante, 
            UO.UnitName AS Sede, 
            cce.DocumentDate AS Fecha, 
            DATEPART(month, cce.DocumentDate) AS Mes, 
            al.Code AS CodAlmacen, 
            al.Name AS Almacen, 
            cce.Description AS Observaciones, 
            cce.IcaPercentage AS PorcICA, 
            cce.InvoiceNumber AS Factura, 
            cce.InvoiceDate AS FechaFactura,
            CASE cce.STATUS
                WHEN '1'
                THEN 'Registrado'
                WHEN '2'
                THEN 'Confirmado'
                WHEN '3'
                THEN 'Anulado'
            END AS Estado, 
            p.Code AS CodigoProducto, 
            p.Name AS Producto, 
            tpr.name AS [Tipo Producto], 
            ATC.Code AS CodMedicamento, 
            ATC.Name AS Medicamento, 
            GF.Name AS GrupoFarmacológico, 
            p.CodeCUM AS [Código CUM], 
            p.CodeAlternative AS [Código alterno], 
            p.CodeAlternativeTwo AS [Código alterno 2], 
            sg.Code AS [Código Subgrupo], 
            sg.Name AS [Nombre subgrupo],
            CASE dce.EntranceSource
                WHEN '1'
                THEN 'Ninguna'
                WHEN '2'
                THEN 'OrdenCompra'
                WHEN '3'
                THEN 'ContratoFijo'
                WHEN '4'
                THEN 'Remision'
            END AS Origen, 
            dce.SourceCode AS DocumentoGeneraEntrada, 
            dce.Quantity AS Cantidad, 
            CONVERT(MONEY, dce.UnitValue, 101) AS VrUnitario, 
            CONVERT(MONEY, dce.SubTotalValue, 101) AS SubTotal, 
            CONVERT(MONEY, p.ProductCosT, 101) AS CostoProm, 
            dce.IvaPercentage AS PorcIva, 
            dce.IvaValue AS IVA, 
            dce.DiscountPercentage AS PorcDescto, 
            dce.DiscountValue AS Descuento, 
            CONVERT(MONEY, dce.TotalValue, 101) AS Total, 
            CONVERT(MONEY, cce.TotalValue, 101) AS TotalComprobante, 
            dce.RTFPercentage AS PorcRetefuente, 
            dce.RTFValue AS Retefuente, 
            per.Fullname AS Usuario, 
            atc.AbbreviationName AS Abreviatura,
            CASE P.PosProduct
                WHEN 1
                THEN 'POS'
                WHEN 0
                THEN 'NO POS'
            END AS POS,
            CASE P.ProductWithPriceControl
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
            END AS AltoCosto
     FROM Inventory.EntranceVoucher AS cce 
          INNER JOIN Inventory.EntranceVoucherDetail AS dce  ON dce.EntranceVoucherId = cce.Id
                                                                                              AND cce.STATUS = '2'
          INNER JOIN Common.Supplier AS pr  ON pr.Id = cce.SupplierId
          INNER JOIN [Security].[User] AS u ON u.UserCode = cce.CreationUser
          INNER JOIN [Security].Person AS per ON per.Id = u.IdPerson
          INNER JOIN Inventory.Warehouse AS al  ON al.Id = cce.WarehouseId
          INNER JOIN Inventory.InventoryProduct AS p  ON p.Id = dce.ProductId
          LEFT OUTER JOIN Inventory.ATC  ON ATC.Id = p.ATCId
          LEFT OUTER JOIN Inventory.PharmacologicalGroup AS GF ON GF.Id = ATC.PharmacologicalGroupId
          LEFT OUTER JOIN Inventory.ProductGroup AS gp ON gp.Id = p.ProductGroupId
          LEFT OUTER JOIN Inventory.ProductSubGroup AS sg ON sg.Id = p.ProductSubGroupId
          JOIN Common.OperatingUnit UO ON CCE.OperatingUnitId = UO.Id
          JOIN Inventory.ProductType tpr ON p.productTypeId = tpr.id
     WHERE(cce.STATUS = '2')
          AND (cce.InvoiceDate >= '20200701');
