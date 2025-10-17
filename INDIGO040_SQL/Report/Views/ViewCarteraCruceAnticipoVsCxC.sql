-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCarteraCruceAnticipoVsCxC
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[ViewCarteraCruceAnticipoVsCxC] AS

SELECT  
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
RC.Code AS 'RECIBO DE CAJA',
CA.Code AS 'CODIGO CRUCE', 
CAST(CA.DocumentDate AS DATE) AS 'FECHA CRUCE', 
C.Nit + ' - ' + C.Name AS 'CLIENTE', 
T.Nit 'NIT', T.Name AS 'TERCERO', 
CASE CA.TransferType WHEN '1' THEN 'MismoCliente' 
					 WHEN '2' THEN 'DiferenteCliente' END AS 'TIPO TRASLADO', 
cuenta.Number AS 'CUENTA CONTABLE', 
CASE CA.Status WHEN '1' THEN 'Registrado' 
			   WHEN '2' THEN 'Confirmado' 
			   WHEN '3' THEN 'Anulado' 
			   WHEN '4' THEN 'Reversado' END AS 'ESTADO CRUCE', 
ca.observations AS 'OBSERVACION',
CAR.InvoiceNumber AS 'FACTURA', 
pa.AdmissionNumber AS 'INGRESO', 
CAST(CAR.AccountReceivableDate AS DATE) AS 'FECHA FACTURA', 
DT.Value AS 'VR CRUCE', 
CAR.Balance AS 'SALDO FACTURA', 
CA.CreationUser + '_' + RTRIM(U.NOMUSUARI)  AS 'USUARIO GENERO', 
F.TotalInvoice AS 'VR FACTURA',
1 as 'CANTIDAD',
CAST(CA.DocumentDate AS date) AS 'FECHA BUSQUEDA',
YEAR(CA.DocumentDate) AS 'AÑO FECHA BUSQUEDA',
MONTH(CA.DocumentDate) AS 'MES AÑO FECHA BUSQUEDA',
CASE MONTH(CA.DocumentDate)
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
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM            
Portfolio.PortfolioTransfer AS CA WITH (nolock) LEFT OUTER JOIN
Common.Customer AS C WITH (nolock) ON C.Id = CA.CustomerId LEFT OUTER JOIN
GeneralLedger.MainAccounts AS cuenta WITH (nolock) ON cuenta.Id = CA.MainAccountId INNER JOIN
Portfolio.PortfolioTransferDetail AS DT WITH (nolock) ON DT.PortfolioTrasferId = CA.Id INNER JOIN
Portfolio.AccountReceivable AS CAR ON CAR.Id = DT.AccountReceivableId INNER JOIN
Common.ThirdParty AS T WITH (nolock) ON T.Id = CAR.ThirdPartyId INNER JOIN
Portfolio.PortfolioAdvance AS pa ON pa.Id = CA.PortfolioAdvanceId INNER JOIN
DBO.SEGusuaru AS U WITH (nolock) ON U.CODUSUARI =CA.CreationUser  LEFT OUTER JOIN
Billing.Invoice AS F WITH (nolock) ON F.Id = CAR.InvoiceId LEFT OUTER JOIN
Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = F.OperatingUnitId LEFT OUTER JOIN
Treasury.CashReceipts AS RC WITH (nolock) ON RC.Id = pa.CashReceiptId
WHERE (cuenta.LegalBookId = 1)
