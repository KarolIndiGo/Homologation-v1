-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: dbo
-- Object: VIE_AD_Inventory_DispensacionesFarmaceuticasVrFacturacion_Jun_2017_Kta
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [dbo].[VIE_AD_Inventory_DispensacionesFarmaceuticasVrFacturacion_Jun_2017_Kta]
AS

SELECT        UO.UnitName AS Sede, I.NUMINGRES AS Ingreso, i.iestadoin AS EstadoIng, D .Code AS Dispensacion, O.Code AS Orden, DI.ServiceDate AS Fecha, CASE WHEN (MONTH(D .DocumentDate)) = '1' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Ene2017' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Feb2017' WHEN (MONTH(D .DocumentDate)) = '3' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Mar2017' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Abr2017' WHEN (MONTH(D .DocumentDate)) = '5' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'May2017' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Jun2017' WHEN (MONTH(D .DocumentDate)) = '7' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Jul2017' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Ago2017' WHEN (MONTH(D .DocumentDate)) = '9' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Sep2017' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Oct2017' WHEN (MONTH(D .DocumentDate)) = '11' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Nov2017' WHEN (MONTH(D .DocumentDate)) = '12' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Dic2017' WHEN (MONTH(D .DocumentDate)) = '1' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Ene2016' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Feb2016' WHEN (MONTH(D .DocumentDate)) = '3' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Mar2016' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Abr2016' WHEN (MONTH(D .DocumentDate)) = '5' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'May2016' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Jun2016' WHEN (MONTH(D .DocumentDate)) = '7' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Jul2016' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Ago2016' WHEN (MONTH(D .DocumentDate)) = '9' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Sep2016' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Oct2016' WHEN (MONTH(D .DocumentDate)) = '11' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Nov2016' WHEN (MONTH(D .DocumentDate)) = '12' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Dic2016' WHEN (MONTH(D .DocumentDate)) = '1' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Ene2015' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Feb2015' WHEN (MONTH(D .DocumentDate)) = '3' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Mar2015' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Abr2015' WHEN (MONTH(D .DocumentDate)) = '5' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'May2015' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Jun2015' WHEN (MONTH(D .DocumentDate)) = '7' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Jul2015' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Ago2015' WHEN (MONTH(D .DocumentDate)) = '9' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Sep2015' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Oct2015' WHEN (MONTH(D .DocumentDate)) = '11' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Nov2015' WHEN (MONTH(D .DocumentDate)) = '12' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Dic2015' END AS MesCosto, 
                         CASE d .status WHEN '1' THEN 'Registrada' WHEN '2' THEN 'Confirmada' END AS Estado, F.InvoiceNumber AS Factura, F.InvoiceDate AS FechaFactura, CASE WHEN (MONTH(f.invoicedate)) = '1' AND 
                         (YEAR(f.invoicedate)) = '2017' THEN 'Ene2017' WHEN (MONTH(f.invoicedate)) = '2' AND (YEAR(f.invoicedate)) = '2017' THEN 'Feb2017' WHEN (MONTH(f.invoicedate)) = '3' AND (YEAR(f.invoicedate)) 
                         = '2017' THEN 'Mar2017' WHEN (MONTH(f.invoicedate)) = '4' AND (YEAR(f.invoicedate)) = '2017' THEN 'Abr2017' WHEN (MONTH(f.invoicedate)) = '5' AND (YEAR(f.invoicedate)) 
                         = '2017' THEN 'May2017' WHEN (MONTH(f.invoicedate)) = '6' AND (YEAR(f.invoicedate)) = '2017' THEN 'Jun2017' WHEN (MONTH(f.invoicedate)) = '7' AND (YEAR(f.invoicedate)) 
                         = '2017' THEN 'Jul2017' WHEN (MONTH(f.invoicedate)) = '8' AND (YEAR(f.invoicedate)) = '2017' THEN 'Ago2017' WHEN (MONTH(f.invoicedate)) = '9' AND (YEAR(f.invoicedate)) 
                         = '2017' THEN 'Sep2017' WHEN (MONTH(f.invoicedate)) = '10' AND (YEAR(f.invoicedate)) = '2017' THEN 'Oct2017' WHEN (MONTH(f.invoicedate)) = '11' AND (YEAR(f.invoicedate)) 
                         = '2017' THEN 'Nov2017' WHEN (MONTH(f.invoicedate)) = '12' AND (YEAR(f.invoicedate)) = '2017' THEN 'Dic2017' WHEN (MONTH(f.invoicedate)) = '1' AND (YEAR(f.invoicedate)) 
                         = '2016' THEN 'Ene2016' WHEN (MONTH(f.invoicedate)) = '2' AND (YEAR(f.invoicedate)) = '2016' THEN 'Feb2016' WHEN (MONTH(f.invoicedate)) = '3' AND (YEAR(f.invoicedate)) 
                         = '2016' THEN 'Mar2016' WHEN (MONTH(f.invoicedate)) = '4' AND (YEAR(f.invoicedate)) = '2016' THEN 'Abr2016' WHEN (MONTH(f.invoicedate)) = '5' AND (YEAR(f.invoicedate)) 
                         = '2016' THEN 'May2016' WHEN (MONTH(f.invoicedate)) = '6' AND (YEAR(f.invoicedate)) = '2016' THEN 'Jun2016' WHEN (MONTH(f.invoicedate)) = '7' AND (YEAR(f.invoicedate)) 
                         = '2016' THEN 'Jul2016' WHEN (MONTH(f.invoicedate)) = '8' AND (YEAR(f.invoicedate)) = '2016' THEN 'Ago2016' WHEN (MONTH(f.invoicedate)) = '9' AND (YEAR(f.invoicedate)) 
                         = '2016' THEN 'Sep2016' WHEN (MONTH(f.invoicedate)) = '10' AND (YEAR(f.invoicedate)) = '2016' THEN 'Oct2016' WHEN (MONTH(f.invoicedate)) = '11' AND (YEAR(f.invoicedate)) 
                         = '2016' THEN 'Nov2016' WHEN (MONTH(f.invoicedate)) = '12' AND (YEAR(f.invoicedate)) = '2016' THEN 'Dic2016' END AS MesFactura, pr.Code AS Cod_Producto, pr.Name AS Producto, 
                         pr.CodeAlternativeTwo AS [Código alterno 2], sg.Code + ' - ' + sg.Name AS Subgrupo, a.Name AS AlmacenDespacho, 
                         CASE WHEN pr.POSProduct = '1' THEN 'POS' WHEN pr.POSProduct = '0' THEN 'No_POS' END AS TipoProducto, DI.Quantity AS CantSolicitada, DI.ReturnedQuantity AS CantDevuelta, 
                         DI.Quantity - DI.ReturnedQuantity AS Cantidad, dev.Code AS Devolucion, un.Name AS Unidad_Destino, DI.AverageCost AS CostoPromedio, (DI.Quantity - DI.ReturnedQuantity) * DI.AverageCost AS CostoTotal,
dev.documentdate as FechaDevolucion

FROM            Inventory.PharmaceuticalDispensing AS D WITH (nolock) INNER JOIN
                         Inventory.PharmaceuticalDispensingDetail AS DI WITH (nolock) ON DI.PharmaceuticalDispensingId = D .Id AND D .Status <> '3' INNER JOIN
                         dbo.ADINGRESO AS I WITH (nolock) ON I.NUMINGRES = D .AdmissionNumber INNER JOIN
                         Inventory.InventoryProduct AS pr WITH (nolock) ON pr.Id = DI.ProductId INNER JOIN
                         Inventory.ProductSubGroup AS sg WITH (nolock) ON sg.Id = pr.ProductSubGroupId INNER JOIN
                         Payroll.FunctionalUnit AS un WITH (nolock) ON un.Id = DI.FunctionalUnitId INNER JOIN
                         Inventory.Warehouse AS a WITH (nolock) ON a.Id = DI.WarehouseId AND a.Code <> '220' INNER JOIN
                         Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = D .OperatingUnitId INNER JOIN
                         Billing.ServiceOrder AS O WITH (nolock) ON O.EntityCode = D .Code AND O.EntityId = D .Id AND O.EntityName = 'PharmaceuticalDispensing' INNER JOIN
                         Billing.ServiceOrderDetail AS bsod WITH (nolock) ON bsod.ServiceOrderId = O.Id AND bsod.ProductId = pr.Id LEFT OUTER JOIN
                         Inventory.ATC AS catc WITH (nolock) ON catc.Id = pr.ATCId INNER JOIN
                         Inventory.PharmaceuticalDispensingDetailBatchSerial AS bs WITH (nolock) ON bs.PharmaceuticalDispensingDetailId = DI.Id LEFT OUTER JOIN
                         Inventory.PharmaceuticalDispensingDevolutionDetail AS devd WITH (nolock) ON devd.PharmaceuticalDispensingDetailBatchSerialId = bs.Id LEFT OUTER JOIN
                         Inventory.PharmaceuticalDispensingDevolution AS dev WITH (nolock) ON dev.Id = devd.PharmaceuticalDispensingDevolutionId AND dev.AdmissionNumber = I.NUMINGRES LEFT OUTER JOIN
                         Billing.Invoice AS F WITH (nolock) ON F.AdmissionNumber = D .AdmissionNumber AND F.Status <> '2' INNER JOIN
                         Billing.InvoiceDetail AS bid WITH (nolock) ON bid.InvoiceId = F.Id AND bid.ServiceOrderDetailId = bsod.Id
WHERE        (D .Status <> '3')  AND (D .DocumentDate BETWEEN '06/01/2017 00:00:00' AND '06/30/2017 23:59:59')
UNION ALL
SELECT        UO.UnitName AS Sede, d .AdmissionNumber, i.iestadoin AS EstadoIng, D .Code AS Dispensacion, O.Code AS Orden, DI.ServiceDate AS Fecha, CASE WHEN (MONTH(D .DocumentDate)) = '1' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Ene2017' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Feb2017' WHEN (MONTH(D .DocumentDate)) = '3' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Mar2017' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Abr2017' WHEN (MONTH(D .DocumentDate)) = '5' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'May2017' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Jun2017' WHEN (MONTH(D .DocumentDate)) = '7' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Jul2017' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Ago2017' WHEN (MONTH(D .DocumentDate)) = '9' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Sep2017' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Oct2017' WHEN (MONTH(D .DocumentDate)) = '11' AND 
                         (YEAR(D .DocumentDate)) = '2017' THEN 'Nov2017' WHEN (MONTH(D .DocumentDate)) = '12' AND (YEAR(D .DocumentDate)) = '2017' THEN 'Dic2017' WHEN (MONTH(D .DocumentDate)) = '1' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Ene2016' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Feb2016' WHEN (MONTH(D .DocumentDate)) = '3' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Mar2016' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Abr2016' WHEN (MONTH(D .DocumentDate)) = '5' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'May2016' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Jun2016' WHEN (MONTH(D .DocumentDate)) = '7' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Jul2016' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Ago2016' WHEN (MONTH(D .DocumentDate)) = '9' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Sep2016' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Oct2016' WHEN (MONTH(D .DocumentDate)) = '11' AND 
                         (YEAR(D .DocumentDate)) = '2016' THEN 'Nov2016' WHEN (MONTH(D .DocumentDate)) = '12' AND (YEAR(D .DocumentDate)) = '2016' THEN 'Dic2016' WHEN (MONTH(D .DocumentDate)) = '1' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Ene2015' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Feb2015' WHEN (MONTH(D .DocumentDate)) = '3' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Mar2015' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Abr2015' WHEN (MONTH(D .DocumentDate)) = '5' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'May2015' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Jun2015' WHEN (MONTH(D .DocumentDate)) = '7' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Jul2015' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Ago2015' WHEN (MONTH(D .DocumentDate)) = '9' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Sep2015' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Oct2015' WHEN (MONTH(D .DocumentDate)) = '11' AND 
                         (YEAR(D .DocumentDate)) = '2015' THEN 'Nov2015' WHEN (MONTH(D .DocumentDate)) = '12' AND (YEAR(D .DocumentDate)) = '2015' THEN 'Dic2015' END AS MesCosto, 
                         CASE d .status WHEN '1' THEN 'Registrada' WHEN '2' THEN 'Confirmada' END AS Estado, 'Sin facturar' AS Factura, '01/01/1900' AS FechaFactura, 'NA' AS MesFactura, pr.Code AS Cod_Producto, 
                         pr.Name AS Producto, pr.CodeAlternativeTwo AS [Código alterno 2], sg.Code + ' - ' + sg.Name AS Subgrupo, a.Name AS AlmacenDespacho, 
                         CASE WHEN pr.POSProduct = '1' THEN 'POS' WHEN pr.POSProduct = '0' THEN 'No_POS' END AS TipoProducto, DI.Quantity AS CantSolicitada, bsod.DevolutionQuantity AS CantDevuelta, 
                         bsod.InvoicedQuantity AS Cantidad, dev.Code AS Devolucion, un.Name AS Unidad_Destino, DI.AverageCost AS CostoPromedio, (DI.Quantity - bsod.DevolutionQuantity) * DI.AverageCost AS CostoTotal,
dev.documentdate as FechaDevolucion
FROM            Inventory.PharmaceuticalDispensing AS D WITH (nolock) INNER JOIN
                         Inventory.PharmaceuticalDispensingDetail AS DI WITH (nolock) ON DI.PharmaceuticalDispensingId = d .Id AND d .Status <> 3 INNER JOIN
                         dbo.ADINGRESO AS I WITH (nolock) ON I.NUMINGRES = D .AdmissionNumber AND i.iestadoin <> 'A' AND i.iestadoin <> 'F' INNER JOIN
                         Billing.ServiceOrder AS O WITH (nolock) ON O.EntityId = D .Id AND O.EntityCode = D .Code AND o.Status <> 3 AND O.EntityName = 'PharmaceuticalDispensing' INNER JOIN
                         Billing.ServiceOrderDetail AS bsod ON bsod.ServiceOrderId = O.Id AND DI.ProductId = bsod.ProductId INNER JOIN
                         Inventory.InventoryProduct AS pr WITH (nolock) ON pr.Id = DI.ProductId INNER JOIN
                         Inventory.ProductSubGroup AS sg WITH (nolock) ON sg.Id = pr.ProductSubGroupId INNER JOIN
                         Payroll.FunctionalUnit AS un WITH (nolock) ON un.Id = DI.FunctionalUnitId INNER JOIN
                         Inventory.Warehouse AS a WITH (nolock) ON a.Id = DI.WarehouseId AND a.Code <> '220' INNER JOIN
                         Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = D .OperatingUnitId LEFT OUTER JOIN
                         Inventory.ATC AS catc WITH (nolock) ON catc.Id = pr.ATCId INNER JOIN
                         Inventory.PharmaceuticalDispensingDetailBatchSerial AS bs WITH (nolock) ON bs.PharmaceuticalDispensingDetailId = DI.Id LEFT OUTER JOIN
                         Inventory.PharmaceuticalDispensingDevolutionDetail AS devd WITH (nolock) ON devd.PharmaceuticalDispensingDetailBatchSerialId = bs.Id LEFT OUTER JOIN
                         Inventory.PharmaceuticalDispensingDevolution AS dev WITH (nolock) ON dev.Id = devd.PharmaceuticalDispensingDevolutionId AND dev.AdmissionNumber = D .AdmissionNumber
WHERE        d .DocumentDate BETWEEN '06/01/2017 00:00:00' AND '06/30/2017 23:59:59' AND DI.Quantity - bsod.DevolutionQuantity <> 0 AND bsod.Id NOT IN
                             (SELECT        ServiceOrderDetailId
                               FROM            Billing.InvoiceDetail) AND bsod.Packaging <> 1

