-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: VW_VIEWCARTERACRUCEANTICIPOVSCXC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.VW_VIEWCARTERACRUCEANTICIPOVSCXC
AS

SELECT  
RC.Code AS 'RECIBO DE CAJA',
pa.Code AS ANTICIPOS,
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
END AS 'MES CRUCE',
CA.Code AS 'CODIGO CRUCE', 
CAST(CA.DocumentDate AS DATE) AS 'FECHA CRUCE', 
C.Nit + ' - ' + C.Name AS 'CLIENTE', 
T.Nit AS 'NIT', 
T.Name AS 'TERCERO', 
CASE CA.TransferType WHEN '1' THEN 'MismoCliente' 
					 WHEN '2' THEN 'DiferenteCliente' END AS 'TIPO TRASLADO', 
cuenta.Number AS 'CUENTA CONTABLE', 
CASE CA.Status WHEN '1' THEN 'Registrado' 
			   WHEN '2' THEN 'Confirmado' 
			   WHEN '3' THEN 'Anulado' 
			   WHEN '4' THEN 'Reversado' END AS 'ESTADO CRUCE', 
CA.Observations AS 'OBSERVACION',
CAR.InvoiceNumber AS 'FACTURA', 
pa.AdmissionNumber AS 'INGRESO', 
CAST(CAR.AccountReceivableDate AS DATE) AS 'FECHA FACTURA', 
DT.Value AS 'VR CRUCE', 
CAR.Balance AS 'SALDO FACTURA', 
CA.CreationUser + '_' + RTRIM(U.NOMUSUARI)  AS 'USUARIO GENERO', 
CAR.Value  AS 'VR FACTURA',
CAST(CA.DocumentDate   AS date) AS 'FECHA BUSQUEDA'
FROM            
    INDIGO036.Portfolio.PortfolioTransfer AS CA  LEFT OUTER JOIN
    INDIGO036.Common.Customer AS C  ON C.Id = CA.CustomerId LEFT OUTER JOIN
    INDIGO036.GeneralLedger.MainAccounts AS cuenta  ON cuenta.Id = CA.MainAccountId INNER JOIN
    INDIGO036.Portfolio.PortfolioTransferDetail AS DT  ON DT.PortfolioTrasferId = CA.Id INNER JOIN
    INDIGO036.Portfolio.AccountReceivable AS CAR ON CAR.Id = DT.AccountReceivableId INNER JOIN
    INDIGO036.Common.ThirdParty AS T  ON T.Id = CAR.ThirdPartyId INNER JOIN
    INDIGO036.Portfolio.PortfolioAdvance AS pa ON pa.Id = CA.PortfolioAdvanceId INNER JOIN
    [INDIGO036].[dbo].[SEGusuaru] AS U  ON U.CODUSUARI =CA.CreationUser  LEFT OUTER JOIN
    INDIGO036.Billing.Invoice AS F  ON F.Id = CAR.InvoiceId LEFT OUTER JOIN
    INDIGO036.Common.OperatingUnit AS UO  ON UO.Id = F.OperatingUnitId LEFT OUTER JOIN
    INDIGO036.Treasury.CashReceipts AS RC  ON RC.Id = pa.CashReceiptId
WHERE (cuenta.LegalBookId = 1)