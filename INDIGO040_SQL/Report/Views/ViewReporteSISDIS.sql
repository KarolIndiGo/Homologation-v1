-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewReporteSISDIS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: View [Report].[ViewReporteSISDIS] 
Tipo: Vista
Observacion:Reporte de Dispositivos Médicos
Profesional: Nilsson Miguel Galindo Lopez
Fecha: 21/02/2024
----------------------------------------------------------------------------------------------------------------------------
Modificaciones
________________________________________________________________________________________________________________________________
Version 2
Persona que modifico: Amira Gil Meneses
Fecha:21/02/2024
Observaciones: Se adicionan dispositivos con base a la Circular 015 del 2023 para el reporte normativo.
------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/



CREATE view [Report].[ViewReporteSISDIS] as
 
 WITH CTE_PRODUCTOS as

 (
SELECT Id AS ID from Inventory.InventorySupplie 
where SupplieName LIKE '%PRESER%' OR SupplieName LIKE '%MICRONIZADO%'OR SupplieName LIKE '%INTRAUTERINO%' 
OR SupplieName LIKE '%DIU%' OR SupplieName LIKE '%CONDONES%'OR SupplieName LIKE '%T DE COBRE%'
OR SupplieName LIKE '%STENT%' OR SupplieName LIKE '%DESFIBRILADOR%' OR SupplieName LIKE '%CORNEA%'
OR SupplieName LIKE '%MARCAPASOS%' OR SupplieName LIKE '%BRADIARRITMIA%'OR SupplieName LIKE '%MULTI-LINK%' 
OR SupplieName LIKE '%SISTEMA DE STENT%' OR SupplieName LIKE '%SCAFFOLD%' OR SupplieName LIKE '%IMPLANTES AUDITIVO%'
OR SupplieName LIKE '%COCHLEAR%' OR SupplieName LIKE '%COCLEAR%' OR SupplieName LIKE '%CORNEAL%'
OR SupplieName LIKE '%CONDICION OSEA%' 
),
 
CTE_IP as (
 SELECT 
  ise.SupplieName,
  ip.CodeAlternative,
  ip.Id InventoryProductId,
  i.Id InvoiceId,
  i.InvoiceDate,
  sod.SubTotalSalesPrice UnitValue,
  sod.InvoicedQuantity Quantity,
  sod.GrandTotalSalesPrice Subtotalvalue,
  ise.Id suplieId
 FROM 
  Billing.Invoice i     
  INNER JOIN Billing.InvoiceDetail id  ON i.Id = id.InvoiceId
  INNER JOIN Billing.ServiceOrderDetail sod  ON id.ServiceOrderDetailId = sod.Id AND sod.GrandTotalSalesPrice > 0
  INNER JOIN Inventory.InventoryProduct ip  ON sod.ProductId = ip.Id
  INNER JOIN Inventory.InventorySupplie ise  ON ip.SupplieId = ise.Id
  INNER JOIN Inventory.ProductType pt  ON pt.Id = ip.ProductTypeId  AND pt.Class = 3
  INNER JOIN CTE_PRODUCTOS ptt on ise.Id =ptt.Id AND ptt.Id IS NOT NULL
 WHERE 
  i.Status = 1 
 ),
 
CTE_TMP as
 (
  SELECT  
   2 TypeRegister,
   ip.SupplieName,
   RIGHT('0'+CAST(MONTH(ip.InvoiceDate) AS VARCHAR(2)),2) MonthReport,
   YEAR(ip.InvoiceDate) YearReport,
   'INS' AS Channel,
   ip.CodeAlternative AS IDM,
   MIN(ip.UnitValue) UnitPriceMinimunSale,
   MAX(ip.UnitValue) UnitPriceMaximumSale,
   SUM(ip.Subtotalvalue) TotalSales,
   SUM(ip.Quantity) TotalUnitsSold,
   Inventory.InvoiceSISMED(1, YEAR(ip.InvoiceDate), MONTH(ip.InvoiceDate), ip.InventoryProductId, MIN(ip.UnitValue))  MinInvoice,
   'NI' TypeEntityMinInvoice,
   Inventory.InvoiceSISMED(1, YEAR(ip.InvoiceDate), MONTH(ip.InvoiceDate), ip.InventoryProductId, MAX(ip.UnitValue)) MaxInovice,
   'NI' TypeEntityMaxInvoice,
   ip.suplieId
  FROM
   CTE_IP ip
  GROUP BY 
   YEAR(ip.InvoiceDate), 
   MONTH(ip.InvoiceDate),
   ip.InventoryProductId,
   ip.CodeAlternative,
   ip.suplieId,
   ip.SupplieName
 ),

CTE_MIN AS (
 SELECT 
  iseA.Id,
  ICA.InvoiceNumber,
  thA.Nit AS IdNumberMinInvoice,
  sum(IDA.InvoicedQuantity) AS TotalUnitsRegisterMin
 FROM 
  Billing.Invoice ICA 
  LEFT JOIN Common.ThirdParty thA ON ICA.ThirdPartyId = thA.Id
  LEFT JOIN Billing.InvoiceDetail IDA  ON ICA.Id=IDA.InvoiceId
  JOIN Billing.ServiceOrderDetail sodA   ON IDA.ServiceOrderDetailId = sodA.Id AND sodA.GrandTotalSalesPrice > 0
  JOIN Inventory.InventoryProduct ipA  ON sodA.ProductId = ipA.Id
  JOIN Inventory.InventorySupplie iseA  ON ipA.SupplieId = iseA.Id 
  JOIN Inventory.ProductType ptA  ON ptA.Id = ipA.ProductTypeId  AND ptA.Class = 3
 GROUP BY 
  iseA.Id, InvoiceNumber, thA.Nit
 ),

CTE_MAX as (
 SELECT 
  iseB.Id ,
  ICB.InvoiceNumber,
  thB.Nit AS IdNumberMaxInvoice,
  sum(IDB.InvoicedQuantity) AS TotalUnitsRegisterMax
 FROM 
  Billing.Invoice ICB 
  LEFT JOIN Common.ThirdParty thB  ON ICB.ThirdPartyId = thB.Id
  LEFT JOIN Billing.InvoiceDetail IDB  ON ICB.Id=IDB.InvoiceId
  JOIN Billing.ServiceOrderDetail sodB   ON IDB.ServiceOrderDetailId = sodB.Id AND sodB.GrandTotalSalesPrice > 0
  JOIN Inventory.InventoryProduct ipB  ON sodB.ProductId = ipB.Id
  JOIN Inventory.InventorySupplie iseB  ON ipB.SupplieId = iseB.Id 
  JOIN Inventory.ProductType ptB  ON ptB.Id = ipB.ProductTypeId  AND ptB.Class = 3
 GROUP BY 
  iseB.Id, 
  InvoiceNumber, 
  thB.Nit
 )

SELECT  
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 tmp.YearReport 'Año del reporte',
 tmp.SupplieName 'Nombre Metodo',
 tmp.TypeRegister 'Tipo de Registro',
 ROW_NUMBER() OVER(ORDER BY tmp.MonthReport, tmp.IDM) as Consecutivo, 
 tmp.MonthReport 'Mes del reporte',
 tmp.Channel 'Canal',
 tmp.IDM 'Identificacion del Dispositivo Medico',
 tmp.UnitPriceMinimunSale 'Precio Unitario Minimo de Venta',
 tmp.UnitPriceMaximumSale 'Precio Unitario Máximo de Venta',
 tmp.TotalSales 'Total de Ventas Netas',
 tmp.TotalUnitsSold 'Total de Unidades Vendidas',
 tmp.MinInvoice '#Factura del Precio Mínimo de Venta del Dispositivo',
 tmp.TypeEntityMinInvoice 'Tipo Identificación de la Entidad Compradora en la Factura del Precio Mínimo de Venta',
 minInvo.IdNumberMinInvoice '#Identificación de la Entidad Compradora en la Factura del Precio Mínimo de Venta',
 minInvo.TotalUnitsRegisterMin 'Total de Unidades Registradas del Dispositivo en la Factura del Precio Mínimo de Venta',
 tmp.MaxInovice '#Factura del Precio Máximo de Venta del Dispositivo',
 tmp.TypeEntityMaxInvoice 'Tipo de Identificación de la Entidad Compradora en la Factura del Precio Máximo de Venta',
 maxInvo.IdNumberMaxInvoice '#Identificación de la Entidad Compradora en la Factura del Precio Máximo de Venta',
 maxInvo.TotalUnitsRegisterMax 'Total de Unidades Registradas del Dispositivo en la Factura del Precio Máximo de Venta',
 CASE WHEN tmp.MonthReport BETWEEN 1 AND 3 THEN CONCAT ('1 - Primer Trimestre ', tmp.YearReport) 
	  WHEN tmp.MonthReport BETWEEN 4 AND 6 THEN CONCAT ('2 - Segundo Trimestre ', tmp.YearReport) 
	  WHEN tmp.MonthReport BETWEEN 7 AND 9 THEN CONCAT ('3 - Tercero Trimestre ', tmp.YearReport) 
	  WHEN tmp.MonthReport BETWEEN 10 AND 12 THEN CONCAT ('4 - Cuarto Trimestre ', tmp.YearReport) END as TRIMESTRE,
 1 as 'CANTIDAD',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
 CTE_TMP tmp
 LEFT JOIN CTE_MIN minInvo ON minInvo.InvoiceNumber = tmp.MinInvoice AND minInvo.Id = tmp.suplieId
 LEFT JOIN CTE_MAX maxInvo ON maxInvo.InvoiceNumber = tmp.MaxInovice AND maxInvo.Id = tmp.suplieId
