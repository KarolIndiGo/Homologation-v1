-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IN_ComprobantesEntrada
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view viewinternal.IN_ComprobantesEntrada as
SELECT pr.Code AS Nit, pr.Name AS Proveedor, tp.Code + ' - ' + tp.Name AS [Tipo Proveedor], l.Code + ' - ' + l.Name AS [Línea Distribución],
cce.Code AS Comprobante, up.UnitName AS Sede, 
             cast(  cce.DocumentDate as datetime) AS Fecha, DATEPART(month, cce.DocumentDate) AS Mes, al.Code AS CodAlmacen, al.Name AS Almacen, cce.Description AS Observaciones, cce.IcaPercentage AS PorcICA, cce.InvoiceNumber AS Factura, cce.InvoiceDate AS FechaFactura, 
           CASE cce.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, p.Code AS CodigoProducto, p.Name AS Producto, ATC.Code AS CodigoMedicamento, atc.name as Medicamento, sp.code as CodInsumo, sp.suppliename as Insumo, 
		   GF.Name AS GrupoFarmacológico, p.CodeCUM AS [Código CUM], p.CodeAlternative AS [Código alterno], 
           p.CodeAlternativeTwo AS [Código alterno 2], gp.code as [Código Grupo], gp.name as [Nombre Grupo] ,sg.Code AS [Código Subgrupo], sg.Name AS [Nombre subgrupo], 
		   CASE dce.EntranceSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'ContratoFijo' WHEN '4' THEN 'Remision' when '5' then 'Remision de inventario en consignación' END AS Origen, dce.SourceCode AS DocumentoGeneraEntrada, 
		    case dce.EntranceSource when 2 then po.documentdate when 4 then re.RemissionDate end as FechaDocumento,
           dce.Quantity AS Cantidad, dce.UnitValue AS VrUnitario, dce.SubTotalValue AS SubTotal, dce.IvaPercentage AS PorcIva, dce.IvaValue AS IVA, dce.DiscountPercentage AS PorcDescto, dce.DiscountValue AS Descuento, dce.TotalValue AS Total, cce.TotalValue AS TotalComprobante, dce.RTFPercentage AS PorcRetefuente, 
           dce.RTFValue AS Retefuente, per.Fullname AS Usuario,  cce.WithholdingTax as ReteIva, tpr.Name AS [Tipo producto], 
		   CASE p.ProductWithPriceControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Maneja control precios]
		   ,deV.code as Devolucion, DEV.TotalValue as ValorDevolucion,
		   case when dev.TotalValue is null then dce.TotalValue else dce.TotalValue-dev.TotalValue end as TotalFinal, pg.Code as CuentaXPagar, bh.BatchCode AS Lote, 
		   bh.ExpirationDate AS FechaVencimiento, case dce.EntranceSource when 1 then 'Ninguna' when 2 then 'Orden de compra'
		   when 3 then 'Contrato (Fijo)' when 4 then 'Remision de entrada' when  5 then 'Remision de inventario en consignación' end as Ingreso, SourceCode as CodigoIngreso
FROM   Inventory.EntranceVoucher AS cce WITH (nolock) INNER JOIN
common.OperatingUnit as up with (nolock) on up.id=cce.OperatingUnitId inner join
           Inventory.EntranceVoucherDetail AS dce WITH (nolock) ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2' INNER JOIN
           Common.Supplier AS pr WITH (nolock) ON pr.Id = cce.SupplierId INNER JOIN
           Common.SuppliersDistributionLines AS dl WITH (nolock) ON dl.IdSupplier = pr.Id and dl.id=cce.SupplierDistributionLineId INNER JOIN
           Common.DistributionLines AS l WITH (nolock) ON l.Id = dl.IdDistributionLine  INNER JOIN
		   Common.SupplierType AS tp ON tp.Id = cce.SupplierTypeId LEFT OUTER JOIN
           Security.[User] AS u  ON u.UserCode = cce.CreationUser INNER JOIN
           Security.Person AS per  ON per.Id = u.IdPerson INNER JOIN
           Inventory.Warehouse AS al  WITH (nolock) ON al.Id = cce.WarehouseId INNER JOIN
           Inventory.InventoryProduct AS p  WITH (nolock) ON p.Id = dce.ProductId LEFT OUTER JOIN
           Inventory.ATC AS ATC WITH (nolock) ON ATC.Id = p.ATCId LEFT OUTER JOIN
           Inventory.PharmacologicalGroup AS GF WITH (nolock) ON GF.Id = ATC.PharmacologicalGroupId LEFT OUTER JOIN
           Inventory.ProductGroup AS gp  WITH (nolock) ON gp.Id = p.ProductGroupId LEFT OUTER JOIN
           Inventory.ProductSubGroup AS sg  WITH (nolock) ON sg.Id = p.ProductSubGroupId LEFT OUTER JOIN
		   Inventory.RemissionEntrance as re  WITH (nolock) on re.Code=dce.SourceCode LEFT OUTER JOIN
		   Inventory.PurchaseOrder as po  WITH (nolock)on po.code=dce.SourceCode left outer join
		[Inventory].[InventorySupplie] as sp on sp.id=p.supplieid left outer JOIN
           Inventory.ProductType AS tpr WITH (nolock) ON tpr.Id = p.ProductTypeId 
		   left outer JOIN	 (SELECT p.code AS CODPRO, p.name AS PRO, max(e.code) as Code, sum(ed.TotalValue) as TotalValue
								FROM Inventory.EntranceVoucher as e 
								inner join Inventory.EntranceVoucherDetail as ed on ed.EntranceVoucherId=e.id 
								inner join Inventory.EntranceVoucherDetailBatchSerial as db on db.EntranceVoucherDetailId=ed.id
								left outer join Inventory.EntranceVoucherDevolutionDetail as edd on edd.EntranceVoucherDetailBatchSerialId=db.id
								left outer join Inventory.EntranceVoucherDevolution as de on de.id=edd.EntranceVoucherDevolutionId
								left outer join Inventory.InventoryProduct as p on p.id=ed.ProductId
								where  edd.Quantity>0
								group by p.code, p.name) AS DEV ON DEV.CODPRO=P.Code AND DEV.CODE=CCE.CODE
		 
		 
		 
		  left outer JOIN	Inventory.EntranceVoucherDetailBatchSerial as edbc on edbc.EntranceVoucherDetailId=dce.id and edbc.Quantity=dce.Quantity --and edbc.BatchSerialId
		  left outer join Inventory.BatchSerial as bh on bh.ProductId=p.id and bh.id=edbc.BatchSerialId and type=1
LEFT JOIN Payments.AccountPayable as pg on pg.EntityId=cce.Id and pg.EntityName='EntranceVoucher'
WHERE (cce.Status = '2') and cce.DocumentDate>='01-01-2020' --and cce.code='10000006722'