-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Comprobante_entrada_devolucion_2021
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[FQ45_V_INN_Comprobante_entrada_devolucion_2021]
   AS
      SELECT pr.Code
                AS Nit,
             pr.Name
                AS Proveedor,
             cce.Code
                AS Comprobante,
             CASE cce.OperatingUnitId WHEN '3' THEN 'BOGOTA' END
                AS Sede,
             cce.DocumentDate
                AS Fecha,
             DATEPART (month, cce.DocumentDate)
                AS Mes,
             al.Code
                AS CodAlmacen,
             al.Name
                AS Almacen,
             cce.Description
                AS Observaciones,
             cce.IcaPercentage
                AS PorcICA,
             cce.WithholdingICA
                AS [Retencion Ica],
             cce.InvoiceNumber
                AS Factura,
             cce.InvoiceDate
                AS FechaFactura,
             CASE cce.Status
                WHEN '1' THEN 'Registrado'
                WHEN '2' THEN 'Confirmado'
                WHEN '3' THEN 'Anulado'
             END
                AS Estado,
             p.Code
                AS CodigoProducto,
             p.Name
                AS Producto,
             ATC.Code
                AS [Codigo Medicamento],
             ATC.[Name]
                AS [Nombre Medicamento],
             GF.Name
                AS GrupoFarmacológico,
             p.CodeCUM
                AS [Código CUM],
             p.CodeAlternative
                AS [Código alterno],
             p.CodeAlternativeTwo
                AS [Código alterno 2],
             gp.[Name]
                AS [Nombre Grupo],
             sg.Code
                AS [Código Subgrupo],
             sg.Name
                AS [Nombre subgrupo],
             gff.Name
                AS [Grupo facturación],
             CASE p.ProductWithPriceControl
                WHEN '0' THEN 'No'
                WHEN '1' THEN 'Control precios'
             END
                AS [Maneja control precios],
             CASE p.POSProduct WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END
                AS POS,
             CASE dce.EntranceSource
                WHEN '1' THEN 'Ninguna'
                WHEN '2' THEN 'OrdenCompra'
                WHEN '3' THEN 'ContratoFijo'
                WHEN '4' THEN 'Remision'
             END
                AS Origen,
             dce.SourceCode
                AS DocumentoGeneraEntrada,
             dce.Quantity
                AS Cantidad,
             dce.UnitValue
                AS VrUnitario,
             dce.SubTotalValue
                AS SubTotal,
             p.ProductCost
                AS CostoProm,
             dce.IvaPercentage
                AS PorcIva,
             dce.IvaValue
                AS IVA,
             dce.DiscountPercentage
                AS PorcDescto,
             dce.DiscountValue
                AS Descuento,
             dce.TotalValue
                AS Total,
             cce.TotalValue
                AS TotalComprobante,
             dce.RTFPercentage
                AS PorcRetefuente,
             dce.RTFValue
                AS Retefuente,
             per.Fullname
                AS Usuario,
             dev.Code
                AS [Cod Devolucion],
             dev.DocumentDate
                AS [Fecha Devolucion],
             dev.Description
                AS Detalle
      FROM Inventory.EntranceVoucher AS cce
           INNER JOIN Inventory.EntranceVoucherDetail AS dce
              ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2'
           INNER JOIN Common.Supplier AS pr ON pr.Id = cce.SupplierId
           INNER JOIN Security.[User] AS u ON u.UserCode = cce.CreationUser
           INNER JOIN Security.Person AS per ON per.Id = u.IdPerson
           INNER JOIN Inventory.Warehouse AS al ON al.Id = cce.WarehouseId
           INNER JOIN Inventory.InventoryProduct AS p ON p.Id = dce.ProductId
           LEFT OUTER JOIN Billing.BillingGroup AS gff
              ON gff.Id = p.BillingGroupId
           LEFT OUTER JOIN Inventory.ATC AS ATC ON ATC.Id = p.ATCId
           LEFT OUTER JOIN Inventory.PharmacologicalGroup AS GF
              ON GF.Id = ATC.PharmacologicalGroupId
           LEFT OUTER JOIN Inventory.ProductGroup AS gp
              ON gp.Id = p.ProductGroupId
           LEFT OUTER JOIN Inventory.ProductSubGroup AS sg
              ON sg.Id = p.ProductSubGroupId
           LEFT OUTER JOIN Inventory.EntranceVoucherDevolution AS dev
              ON dev.EntranceVoucherId = cce.Id
      WHERE (cce.Status = '2') AND year(cce.InvoiceDate)= '2021'
