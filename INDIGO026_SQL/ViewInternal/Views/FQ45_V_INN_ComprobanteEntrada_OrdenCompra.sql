-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_ComprobanteEntrada_OrdenCompra
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [ViewInternal].[FQ45_V_INN_ComprobanteEntrada_OrdenCompra] as

SELECT CodigoProveedor as Nit, Proveedor, A.OrdenCompra, A.Fecha, CodigoAlmacen, A.Almacen, Detalle, Valor as VrUnitario, VrTotal, CostoPromedio, Estado_Orden, CodProducto, Producto, A.Cantidad, CanPenCruzar, Usuario,
Comprobante, comp.Fecha AS FechaComprobante, CodAlmacen as CodAlmacen_Compr, comp.Almacen as Almacen_Compr, Observaciones as Observaciones_Compr, Factura as Factura_Compr, FechaFactura as FechaFactura_Compr, 
comp.Cantidad as Cantidad_Compr, VrUnitario as VrUnitario_Compr, [Maneja control precios]
FROM (

SELECT uo.UnitName AS Sede,
       cr.Code AS OrdenCompra,
       cr.DocumentDate AS Fecha,
       PR.Code AS CodigoProveedor,
       PR.Name AS Proveedor,
       AL.Code AS CodigoAlmacen,
       AL.Name AS Almacen,
       cr.Description AS Descripcion_Orden_Bionexo,
       cr.Value AS Valor,
       cr.TotalValue AS VrTotal,
       CASE cr.Status
          WHEN '1' THEN 'registrado'
          WHEN '2' THEN 'confirmado'
          WHEN '3' THEN 'anulado'
       END AS Estado_Orden,
       pd.Code AS CodProducto,
       pd.Name AS Producto,
       DR.Quantity AS Cantidad,
       DR.OutstandingQuantity AS CanPenCruzar,
       DR.TotalValue AS Total,
       pd.ProductCost AS CostoPromedio,
       p.Fullname AS Usuario, cr.Description as Detalle
FROM Inventory.PurchaseOrder AS cr 
     INNER JOIN Common.OperatingUnit AS uo 
        ON uo.Id = cr.OperatingUnitId
     INNER JOIN Common.Supplier AS PR 
        ON PR.Id = cr.SupplierId
     INNER JOIN Inventory.Warehouse AS AL 
        ON AL.Id = cr.WarehouseId
     INNER JOIN Inventory.PurchaseOrderDetail AS DR 
        ON DR.PurchaseOrderId = cr.Id
     INNER JOIN Inventory.InventoryProduct AS pd 
        ON pd.Id = DR.ProductId
     INNER JOIN Security.[User] AS U 
        ON U.UserCode = cr.CreationUser
     INNER JOIN Security.Person AS p 
        ON p.Id = U.IdPerson
WHERE (cr.Status <> 3) and cr.DocumentDate >'01/01/2021 23:59:59' ) AS A INNER JOIN 

(SELECT Comprobante, Fecha, CodAlmacen, Almacen, Observaciones, Factura, FechaFactura, Cantidad, VrUnitario, [Maneja control precios], OrdenCompra, CodigoProducto
FROM (

SELECT pr.Code AS Nit,
       pr.Name AS Proveedor,
       cce.Code AS Comprobante,
       CASE cce.OperatingUnitId 
	   WHEN '4' THEN 'TUNJA'
	   WHEN '8' THEN 'NEIVA'
	   WHEN '9' THEN 'FLORENCIA'
	   WHEN '10' THEN 'CALI'
	   WHEN '13' THEN 'FACATATIVA'
	   WHEN '3' THEN 'BOGOTA' END AS Sede,
       cce.DocumentDate AS Fecha,
       DATEPART (month, cce.DocumentDate) AS Mes,
       al.Code AS CodAlmacen,
       al.Name AS Almacen,
       cce.Description AS Observaciones,
       cce.IcaPercentage AS PorcICA,
       cce.WithholdingICA AS [Retencion Ica],
       cce.InvoiceNumber AS Factura,
       cce.InvoiceDate AS FechaFactura,
       CASE cce.Status
          WHEN '1' THEN 'Registrado'
          WHEN '2' THEN 'Confirmado'
          WHEN '3' THEN 'Anulado'
       END AS Estado,
       p.Code AS CodigoProducto,
       p.Name AS Producto,
       ATC.Code AS CodigoATC,
       GF.Name AS GrupoFarmacológico,
       p.CodeCUM AS [Código CUM],
       p.CodeAlternative AS [Código alterno],
       p.CodeAlternativeTwo AS [Código alterno 2],
       sg.Code AS [Código Subgrupo],
       sg.Name AS [Nombre subgrupo],
       CASE dce.EntranceSource
          WHEN '1' THEN 'Ninguna'
          WHEN '2' THEN 'OrdenCompra'
          WHEN '3' THEN 'ContratoFijo'
          WHEN '4' THEN 'Remision'
       END AS Origen,
       dce.SourceCode AS DocumentoGeneraEntrada,
       dce.Quantity AS Cantidad,
       dce.UnitValue AS VrUnitario,
       dce.SubTotalValue AS SubTotal,
       p.ProductCost AS CostoProm,
       dce.IvaPercentage AS PorcIva,
       dce.IvaValue AS IVA,
       dce.DiscountPercentage AS PorcDescto,
       dce.DiscountValue AS Descuento,
       dce.TotalValue AS Total,
       cce.TotalValue AS TotalComprobante,
       dce.RTFPercentage AS PorcRetefuente,
       dce.RTFValue AS Retefuente,
	    tpr.Name AS [Tipo producto],
		 CASE p.ProductWithPriceControl WHEN '0' THEN 'No Regulado' WHEN '1' THEN 'Regulado' END AS [Maneja control precios]--,
		  ,deV.code as Devolucion, DEV.TotalValue as ValorDevolucion,
		   case when dev.TotalValue is null then dce.TotalValue else dce.TotalValue-dev.TotalValue end as TotalFinal,
		   dce.sourcecode as OrdenCompra, PC.ConfirmationDate AS Fecha_OrdenCompra
     --  per.Fullname AS Usuario
FROM Inventory.EntranceVoucher AS cce 
     INNER JOIN Inventory.EntranceVoucherDetail AS dce 
        ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2'
     INNER JOIN Common.Supplier AS pr 
        ON pr.Id = cce.SupplierId
     --INNER JOIN Security.[User] AS u 
     --   ON u.UserCode = cce.CreationUser
     --INNER JOIN Security.Person AS per 
     --   ON per.Id = u.IdPerson
     INNER JOIN Inventory.Warehouse AS al 
        ON al.Id = cce.WarehouseId
     INNER JOIN Inventory.InventoryProduct AS p 
        ON p.Id = dce.ProductId
     LEFT OUTER JOIN Inventory.ATC AS ATC 
        ON ATC.Id = p.ATCId
     LEFT OUTER JOIN Inventory.PharmacologicalGroup AS GF
        ON GF.Id = ATC.PharmacologicalGroupId
     LEFT OUTER JOIN Inventory.ProductGroup AS gp
        ON gp.Id = p.ProductGroupId
     LEFT OUTER JOIN Inventory.ProductSubGroup AS sg
        ON sg.Id = p.ProductSubGroupId
		left outer JOIN
           Inventory.ProductType AS tpr  ON tpr.Id = p.ProductTypeId 
		   left outer JOIN	 (SELECT p.code AS CODPRO, p.name AS PRO, max(e.code) as Code, sum(ed.TotalValue) as TotalValue
								FROM Inventory.EntranceVoucher as e 
								inner join Inventory.EntranceVoucherDetail as ed on ed.EntranceVoucherId=e.id 
								inner join Inventory.EntranceVoucherDetailBatchSerial as db on db.EntranceVoucherDetailId=ed.id
								left outer join Inventory.EntranceVoucherDevolutionDetail as edd on edd.EntranceVoucherDetailBatchSerialId=db.id
								left outer join Inventory.EntranceVoucherDevolution as de on de.id=edd.EntranceVoucherDevolutionId
								left outer join Inventory.InventoryProduct as p on p.id=ed.ProductId
								where  edd.Quantity>0
								group by p.code, p.name) AS DEV ON DEV.CODPRO=P.Code AND DEV.CODE=CCE.CODE
			LEFT OUTER JOIN Inventory.PurchaseOrder AS PC ON PC.CODE=dce.sourcecode
WHERE (cce.Status = '2') AND (cce.InvoiceDate >='01/01/2021 23:59:59') and EntranceSource='2' ) AS A) AS COMP ON COMP.OrdenCompra=a.OrdenCompra AND COMP.CodigoProducto=A.CodProducto

--WHERE A.OrdenCompra='0000019710'
