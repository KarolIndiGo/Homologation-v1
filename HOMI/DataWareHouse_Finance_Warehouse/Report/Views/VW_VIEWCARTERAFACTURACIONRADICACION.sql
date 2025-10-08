-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_VIEWCARTERAFACTURACIONRADICACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.VW_VIEWCARTERAFACTURACIONRADICACION 
AS

WITH CTE_FACTURACION_RADICACION AS
 (
  SELECT 
   CASE ar.PortfolioStatus	
    WHEN 1 THEN 'SIN RADICAR'
	WHEN 2 THEN 'RADICADA POR RECIBIR ENTIDAD' 
	WHEN 3 THEN 'RADICADA RECIBIDO ENTIDAD'
	WHEN 4 THEN 'OBJETADA O GLOSADA'
	WHEN 7 THEN 'CERTIFICADA PARCIAL'
	WHEN 8 THEN 'CERTIFICADA TOTAL' 
	WHEN 14 THEN 'DEVOLUCION FACTURA'
	WHEN 15 THEN 'CUENTA DIFICL RECAUDO'
	WHEN 16 THEN 'COBRO JURIDICO' 
   END [ESTADO CARTERA],
  tp.Nit NIT,
  tp.Name TERCERO,
  ISNULL(cg.Name,'SALDO INICIAL') [GRUPO ATENCION],
  CASE ar.AccountReceivableType WHEN 1 THEN 'Facturación Básica' 
								WHEN 2 THEN  'Facturación Ley 100' 
								WHEN 3 THEN 'Impuestos Industria y Comercio'
								WHEN 4 THEN 'Pagarés' 
								WHEN 5 THEN 'Acuerdos de Pago' 
								WHEN 6 THEN 'Documento de Pago a Cuota Moderadora' 
								WHEN 7 THEN 'Factura de Producto'
								WHEN 8 THEN 'Impuesto Predial' END AS [TIPO DOCUMENTO],
  ar.InvoiceNumber [FACTURA],
  ar.Value [VALOR FACTURA],
  ar.Balance [SALDO FACTURA],
  ar.AccountReceivableDate AS [FECHA FACTURA],
  ar.InvoiceId,
  CASE ar.Status WHEN 3 THEN 'ANULADO'ELSE 'FACTURADO'END [ESTADO FACTURA],
  case ar.OpeningBalance when 1 then 'SI' ELSE 'NO' END AS [SALDO INICIAL],
  ar.AccountWithoutRadicateId 
 FROM 
  INDIGO036.Common.ThirdParty tp 
  INNER JOIN INDIGO036.Portfolio.AccountReceivable ar  ON tp.Id = ar.ThirdPartyId 
  LEFT JOIN INDIGO036.Contract.CareGroup cg  ON ar.CareGroupId = cg.Id
  LEFT JOIN INDIGO036.GeneralLedger.MainAccounts AS mar  ON mar.Id = ar.AccountWithoutRadicateId 
  LEFT JOIN INDIGO036.Portfolio.GetRegimes() pgr ON mar.Number = pgr.AccountNumber
 WHERE 
  ar.Status<>3 AND 
  ar.AccountReceivableType=2 AND 
  ar.Balance>0
),

CTE_RADICACION AS
 (
  SELECT 
   rid.InvoiceNumber, 
   MIN(ri.Id) Id, 
   MIN(rid.RadicatedNumber) RadicatedNumber
  FROM 
   INDIGO036.Portfolio.RadicateInvoiceC ri 
   INNER JOIN INDIGO036.Portfolio.RadicateInvoiceD rid  ON ri.Id = rid.RadicateInvoiceCId
   INNER JOIN CTE_FACTURACION_RADICACION AS FAC ON FAC.FACTURA =rid.InvoiceNumber 
  WHERE
   rid.State <>'4'
  GROUP BY 
   rid.InvoiceNumber
 ),

CTE_GLOSAS AS
 (
  SELECT 
   dev.InvoiceNumber,
   dev.State  
  FROM 
   INDIGO036.Glosas.GlosaDevolutionsReceptionD dev 
   INNER JOIN INDIGO036.Glosas.GlosaDevolutionsReceptionC AS cab  ON cab.Id = dev.GlosaDevolutionsReceptionCId
   INNER JOIN INDIGO036.Common.Customer as cli on cli.Id = cab.CustomerId
   INNER JOIN INDIGO036.Common.ThirdParty AS TER  ON TER.Id = cli.ThirdPartyId  
   INNER JOIN CTE_FACTURACION_RADICACION AS RAD ON RAD.FACTURA = dev.InvoiceNumber AND RAD.NIT =TER.Nit 
  WHERE 
   cab.State<>'4'
  GROUP BY
   dev.InvoiceNumber,
   dev.State  
 )

SELECT
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
 FAC.[ESTADO CARTERA],
 iif(GLO.InvoiceNumber is null,'NO','SI') 'DEVOLUCION',
 FAC.NIT ,
 FAC.TERCERO,
 FAC.[GRUPO ATENCION],
 FAC.[TIPO DOCUMENTO],
 FAC.FACTURA ,
 FAC.[VALOR FACTURA],
 FAC.[SALDO FACTURA],
 CAST(FAC.[FECHA FACTURA] AS DATE) AS [FECHA FACTURA],
 CAST(FAC.[FECHA FACTURA] AS TIME) AS [HORA FACTURA],
 CAST(ri.CreationDate as date) [FECHA CREACION RADICADO],
 CAST(ri.CreationDate AS TIME) [HORA CREACION RADICADO],
 CAST(ri.DocumentDate as date) [FECHA OFICIO RADICADO], 
 CAST(ri.DocumentDate AS TIME ) [HORA OFICIO RADICADO], 
 CAST(ri.RadicatedDate as date) [FECHA RADICACION],
 CAST(ri.RadicatedDate AS TIME) [HORA RADICACION],
 CAST(ri.ConfirmDate as date) [FECHA CONFIRMACION RADICADO],
 CAST(ri.ConfirmDate AS TIME) [HORA CONFIRMACION RADICADO],
 ri.RadicatedConsecutive [CONSECUTIVO RADICADO],
 FAC.[ESTADO FACTURA],
 FAC.[SALDO INICIAL],
 USU.NOMUSUARI  AS [USUARIO FACTURO],
 USUR.NOMUSUARI AS 'USUARIO RADICO',
 cat.Name [CATEGORIA],
 1 as 'CANTIDAD',
 CAST(FAC.[FECHA FACTURA] AS date) AS 'FECHA BUSQUEDA',
 YEAR(FAC.[FECHA FACTURA]) AS 'AÑO BUSQUEDA',
  MONTH(FAC.[FECHA FACTURA]) AS 'MES BUSQUEDA',
  CONCAT(FORMAT(MONTH(FAC.[FECHA FACTURA]), '00') ,' - ', 
	   CASE MONTH(FAC.[FECHA FACTURA]) 
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
 CTE_FACTURACION_RADICACION FAC 
 LEFT JOIN CTE_GLOSAS AS GLO ON GLO.InvoiceNumber = FAC.FACTURA 
 LEFT JOIN CTE_RADICACION AS RAD ON RAD.InvoiceNumber = FAC.FACTURA
 LEFT JOIN INDIGO036.Portfolio.RadicateInvoiceC ri  ON RAD.Id = ri.Id
 LEFT JOIN INDIGO036.Billing.Invoice AS i  ON FAC.InvoiceId = i.Id
 LEFT JOIN [INDIGO036].[dbo].[SEGusuaru] AS USU ON USU.CODUSUARI =i.InvoicedUser 
 LEFT JOIN [INDIGO036].[dbo].[SEGusuaru] AS USUR  ON USUR.CODUSUARI =ri.CreationUser
 LEFT JOIN [INDIGO036].[dbo].[ADINGRESO] AS a ON i.AdmissionNumber = a.NUMINGRES
 LEFT JOIN INDIGO036.GeneralLedger.MainAccounts AS mar  ON mar.Id = FAC.AccountWithoutRadicateId 
 LEFT JOIN INDIGO036.Portfolio.GetRegimes() pgr ON mar.Number = pgr.AccountNumber
 LEFT JOIN INDIGO036.Billing.InvoiceCategories cat ON cat.Id = i.InvoiceCategoryId
