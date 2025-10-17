-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_CXC_FACTURACION_RADICACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE PROCEDURE [Report].[SP_CXC_FACTURARCION_RADICACION]
AS
with CTE_FACTURACION_RADICACION
AS
(
  SELECT CASE ar.PortfolioStatus	WHEN 1 THEN 'SIN RADICAR'WHEN 2 THEN 'RADICADA SIN CONFIRMAR'ELSE 'RADICADA ENTIDAD' END [ESTADO CARTERA],tp.Nit NIT,tp.Name TERCERO,
  ISNULL(cg.Name,'SALDO INICIAL') [GRUPO ATENCION],
  CASE ar.AccountReceivableType WHEN 1 THEN 'Facturación Básica' WHEN 2 THEN  'Facturación Ley 100' WHEN 3 THEN 'Impuestos Industria y Comercio'
  WHEN 4 THEN 'Pagarés' WHEN  5 THEN 'Acuerdos de Pago' WHEN 6 THEN 'Documento de Pago a Cuota Moderadora' WHEN 7 THEN 'Factura de Producto'
  WHEN 8 THEN 'Impuesto Predial' END AS [TIPO DOCUMENTO],ar.InvoiceNumber [FACTURA],AR.Value [VALOR FACTURA],AR.Balance [SALDO FACTURA],CAST(ar.AccountReceivableDate AS DATE) [FECHA FACTURA],
  ar.InvoiceId ,CASE ar.Status	WHEN 3 THEN 'ANULADO'ELSE 'FACTURADO'END [ESTADO FACTURA],case ar.OpeningBalance when 1 then 'SI' ELSE 'NO' END AS [SALDO INICIAL],AR.AccountWithoutRadicateId 
  FROM Common.ThirdParty tp WITH (NOLOCK)
  INNER JOIN Portfolio.AccountReceivable ar WITH (NOLOCK) ON tp.Id = ar.ThirdPartyId 
  LEFT JOIN Contract.CareGroup cg WITH (NOLOCK) ON ar.CareGroupId = cg.Id
  LEFT JOIN GeneralLedger.MainAccounts AS mar WITH (NOLOCK) ON mar.Id = ar.AccountWithoutRadicateId 
  LEFT JOIN Portfolio.GetRegimes() pgr ON mar.Number = pgr.AccountNumber
  WHERE ar.Status<>3  -- AND CAST(ar.AccountReceivableDate  AS DATE) BETWEEN @FechaInicio AND @FechaFin
  and ar.AccountReceivableType=2
),

CTE_RADICACION
AS
(
   SELECT rid.InvoiceNumber, MIN(ri.Id) Id, MIN(rid.RadicatedNumber) RadicatedNumber
   FROM Portfolio.RadicateInvoiceC ri WITH (NOLOCK)
   INNER JOIN Portfolio.RadicateInvoiceD rid WITH (NOLOCK) ON ri.Id = rid.RadicateInvoiceCId
   INNER JOIN CTE_FACTURACION_RADICACION AS FAC ON FAC.FACTURA =RID.InvoiceNumber 
   GROUP BY rid.InvoiceNumber
),

CTE_GLOSAS
AS
(
  SELECT dev.InvoiceNumber,TER.ID tercero ,TER.Nit
  from Glosas .GlosaDevolutionsReceptionD dev 
  INNER JOIN Glosas.GlosaDevolutionsReceptionC AS cab  ON cab.Id =dev.GlosaDevolutionsReceptionCId
  INNER JOIN Common.Customer as cli on cli.Id =cab.CustomerId
  INNER JOIN Common.ThirdParty AS TER  ON TER.Id =CLI.ThirdPartyId  
  INNER JOIN CTE_FACTURACION_RADICACION AS RAD ON RAD.FACTURA =DEV.InvoiceNumber AND RAD.NIT =TER.Nit 
  where cab.State<>'4'
  group by dev.InvoiceNumber,TER.ID,TER.Nit

)

select 
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
FAC.[FECHA FACTURA],
cast(RI.CreationDate as date) [FECHA CREACION RADICADO],
cast(ri.DocumentDate as date) [FECHA OFICIO RADICADO], 
cast(ri.RadicatedDate as date) [FECHA RADICACION],
cast(ri.ConfirmDate as date) [FECHA CONFIRMACION RADICADO],
RI.RadicatedConsecutive [CONSECUTIVO RADICADO],
FAC.[ESTADO FACTURA] ,FAC.[SALDO INICIAL] ,
USU.NOMUSUARI  AS [USUARIO FACTURO],
USUR.NOMUSUARI AS 'USUARIO RADICO',
cat.Name [CATEGORIA],
1 as 'CANTIDAD',
CAST(FAC.[FECHA FACTURA] AS date) AS 'FECHA BUSQUEDA',
YEAR(FAC.[FECHA FACTURA]) AS 'AÑO FECHA BUSQUEDA',
MONTH(FAC.[FECHA FACTURA]) AS 'MES AÑO FECHA BUSQUEDA',
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
WHEN 12 THEN 'DICIEMBRE'
END AS 'MES NOMBRE FECHA BUSQUEDA',
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
			WHEN 12 THEN 'DICIEMBRE'
		END) MES_LABEL_BUSQUEDA,
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
from CTE_FACTURACION_RADICACION FAC
LEFT JOIN CTE_RADICACION AS RAD ON RAD.InvoiceNumber =FAC.FACTURA 
LEFT JOIN Portfolio.RadicateInvoiceC ri WITH (NOLOCK) ON RAD.Id = ri.Id
LEFT JOIN Billing.Invoice i WITH (NOLOCK) ON FAC.InvoiceId = i.Id
LEFT JOIN DBO.SEGusuaru AS USU ON USU.CODUSUARI =I.InvoicedUser 
LEFT JOIN DBO.SEGusuaru AS USUR WITH (NOLOCK) ON USUR.CODUSUARI =RI.CreationUser 
LEFT JOIN dbo.ADINGRESO a WITH(NOLOCK) ON i.AdmissionNumber = a.NUMINGRES
LEFT JOIN GeneralLedger.MainAccounts AS mar WITH (NOLOCK) ON mar.Id = FAC.AccountWithoutRadicateId 
LEFT JOIN Portfolio.GetRegimes() pgr ON mar.Number = pgr.AccountNumber
LEFT JOIN Billing.InvoiceCategories cat ON cat.id = i.InvoiceCategoryId
LEFT JOIN CTE_GLOSAS AS GLO ON GLO.InvoiceNumber =FAC.FACTURA AND GLO.Nit  =FAC.NIT
