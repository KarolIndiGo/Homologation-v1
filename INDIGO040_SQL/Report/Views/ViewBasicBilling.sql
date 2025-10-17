-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewBasicBilling
-- Extracted by Fabric SQL Extractor SPN v3.9.0






    /*******************************************************************************************************************
Nombre: [Report].[ViewBasicBilling]
Tipo:Vista
Observacion: Facturación basica
Profesional: Armando Alfonso
			 Nilsson Miguel Galindo Lopez
Fecha:22-08-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:22-09-2023
Observaciones: Se agregan los campos de sub total, %iva, iva y descuentos esto solicitado en el ticket 12650 para la intitución de ciegos y sordos
--------------------------------------
Version 3
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha: 21-02-2023
Observaciones:Se cran los campos de tipo de identificación del cliente, y datos de confirmación de la factura basica.
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewBasicBilling] AS

WITH

CTE_OBSEQUIOS AS
(
SELECT 
ROW_NUMBER ( )   
OVER (PARTITION BY GIF.BasicBillingId  order by GIF.BasicBillingId DESC) 'NUMERO',
GIF.BasicBillingId,
PRO.Name,
GIF.Quantity
FROM 
Billing.BasicBillingGifts GIF INNER JOIN
Inventory.InventoryProduct PRO ON GIF.ProductId=PRO.Id
)


SELECT TOP 100 PERCENT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
OU.UnitName AS [CENTRO DE ATENCIÓN], 
FU.Code AS [CODIGO UNIDAD FUNCIONAL], 
FU.Name AS [UNIDAD FUNCIONAL], 
CC.Code AS [CODIGO CENTRO DE COSTOS], 
CC.Name AS [CENTRO DE COSTOS], 
BB.DocumentDate AS [FECHA DE FACTURA], 
BB.Code AS [CODIGO FACTURA BASICA], 
I.InvoiceNumber AS FACTURA,
CASE PER.IdentificationType WHEN 0 THEN 'Cédula de Ciudadanía'
							WHEN 1 THEN 'Cédula de Extranjería'
							WHEN 2 THEN 'Tarjeta de Identidad'
							WHEN 3 THEN 'Registro Civil'
							WHEN 4 THEN 'Pasaporte'
							WHEN 5 THEN 'Adulto Sin Identificación'
							WHEN 6 THEN 'Menor Sin Identificación'
							WHEN 7 THEN 'Nit'
							WHEN 8 THEN 'Número único de identificación personal'
							WHEN 9 THEN 'Cetrigicado Nacido Vivo'
							WHEN 10 THEN 'Carnet Diplomático'
							WHEN 11 THEN 'Salvoconducto'
							WHEN 12 THEN 'Permiso especial de Permanencia'
							WHEN 13 THEN 'Permiso por Protección Temporal'
							WHEN 14 THEN 'Documento extranjero'
							WHEN 15 THEN 'Sin identificacion' END AS [TIPO IDENTIFICACIÓN CLIENTE],
T.Nit AS [NIT CLIENTE], 
T.Name AS CLIENTE, 
F.Name AS TARIFA, 
IIF(P.Code IS NULL,'SERVICIO','PRODUCTO') AS TIPO,
P.Code AS [CODIGO DE PRODUCTO], 
P.Name AS [PRODUCTO], 
W.Code AS [CODIGO ALMACEN], 
W.Name AS ALMACEN, 
P.ProductCost AS [COSTO PROMEDIO], 
P.FinalProductCost AS [ULTIMO COSTO], 
BC.Code AS [CODIGO SERVICIO PADRE], 
BC.Name AS [SERVICO PADRE], 
BC1.Code AS [CODIGO SERVICIO HIJO], 
BC1.Name AS [SERVICIO HIJO], 
S.Name AS PROVEEDOR,  
T2.name AS [EJECUTIVO DE VENTAS], 
BBD.Quantity AS CANTIDAD, 
BBD.Price AS [VALOR UNITARIO], 
BBD.Value AS [VALOR SUB TOTAL],
CAST (BBD.PercentageIVA as int) AS [% IVA],
CAST((((BBD.Value-BBD.ValueDiscount)*BBD.PercentageIVA)/100) as int) AS IVA,--Se aplica al iva despues de aplicar el descuento
BBD.ValueDiscount AS DESCUENTOS,
CAST (((BBD.Value-BBD.ValueDiscount) + ((BBD.Value-BBD.ValueDiscount)*BBD.PercentageIVA)/100) as numeric) AS [VALOR TOTAL],
OB1.Name AS [PRODUCTO OBSEQUIO 1],
OB1.Quantity AS [CANTIDAD OBSEQUIO 1],
OB2.Name AS [PRODUCTO OBSEQUIO 2],
OB2.Quantity AS [CANTIDAD OBSEQUIO 2],
PERS.Identification AS [IDENTIFICACIÓN USUARIO CONFIRMACIÓN],
PERS.Fullname AS [USUARIO CONFIMACIÓN],
CAST(BB.DocumentDate AS date) AS 'FECHA BUSQUEDA',
YEAR(BB.DocumentDate) AS 'AÑO BUSQUEDA',
MONTH(BB.DocumentDate) AS 'MES BUSQUEDA',
CONCAT(FORMAT(MONTH(BB.DocumentDate), '00') ,' - ', 
	   CASE MONTH(BB.DocumentDate) 
	    WHEN 1 THEN 'ENERO'
   	    WHEN 2 THEN 'FEBRERO'
	    WHEN 3 THEN 'MARZO'
	    WHEN 4 THEN 'ABRIL'
	    WHEN 5 THEN 'MAYO'
	    WHEN 6 THEN 'JUNIO'
	    WHEN 7 THEN 'JULIO'
	    WHEN 8 THEN 'AGOSTO'
	    WHEN 9 THEN 'SEPTIEMBRE'
	    WHEN 10 THEN 'OCTUBRE'
	    WHEN 11 THEN 'NOVIEMBRE'
	    WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE BUSQUEDA',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM 
Billing.BasicBillingDetail BBD 
INNER JOIN Billing.BasicBilling BB ON BBD.BasicBillingId=BB.Id AND BB.Status = '2' AND BBD.DetailType IN (1, 2) 
INNER JOIN Billing.Invoice I ON BB.InvoiceId=I.Id 
INNER JOIN Common.OperatingUnit OU ON I.OperatingUnitId=OU.Id 
INNER JOIN Common.ThirdParty T ON T.Id=I.ThirdPartyId 
INNER JOIN Common.Person PER ON T.PersonId=PER.Id
INNER JOIN Payroll.FunctionalUnit FU on BBD.FunctionalUnitId=FU.Id 
INNER JOIN Payroll.CostCenter CC on FU.CostCenterId=CC.Id 
LEFT JOIN Billing.BillingConcept BC ON BBD.BillingConceptId=BC.Id 
LEFT JOIN Billing.BillingConcept BC1 ON BBD.ServicesProvidedId=BC1.Id 
LEFT JOIN Inventory.InventoryProduct P ON BBD.ProductId=P.Id 
LEFT JOIN Billing.ProductAndServiceFee F ON BBD.FeeId=F.Id 
LEFT JOIN Inventory.Warehouse W ON BBD.WarehouseId=W.Id 
LEFT JOIN Common.Supplier S ON BBD.SupplierId=S.Id 
LEFT JOIN Billing.SalesExecutive SE ON BBD.SalesExecutiveId=SE.Id 
LEFT JOIN Common.ThirdParty T2 on SE.ThirdPartyId=T2.Id 
LEFT JOIN CTE_OBSEQUIOS OB1 ON BB.Id=OB1.BasicBillingId AND OB1.NUMERO=1
LEFT JOIN CTE_OBSEQUIOS OB2 ON BB.Id=OB2.BasicBillingId AND OB2.NUMERO=2
LEFT JOIN [Security].[User] US ON BB.ConfirmationUser=US.Id
LEFT JOIN [Security].Person PERS ON US.IdPerson=PERS.Id
--WHERE bb.Code='00222'
order by BB.DocumentDate asc


--select * from Billing.BasicBillingDetail
--select * from Billing.BasicBilling
--select * from [Security].Person
--select * from [Security].[User]
