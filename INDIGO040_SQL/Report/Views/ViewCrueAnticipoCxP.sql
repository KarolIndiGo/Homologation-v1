-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCrueAnticipoCxP
-- Extracted by Fabric SQL Extractor SPN v3.9.0




    /*******************************************************************************************************************
Nombre: [Report].[ViewCrueAnticipoCxP]
Tipo:vista
Observacion: Cuce de anticipos cuentas por cobrar
Profesional: Nilsson Galindo
Fecha:12-10-2012
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
-------------------------------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/
CREATE VIEW [Report].[ViewCrueAnticipoCxP]
as
WITH

CTE_SUMA_NOTAS AS
(
SELECT 
CP.Id,
IIF(N.Nature=1,ISNULL(SUM(APA.AdjusmentValue),0),0) AS [AJUSTE DEBITO],
IIF(N.Nature=2,ISNULL(SUM(APA.AdjusmentValue),0),0) AS [AJUSTE CREDITO]
FROM 
Payments.PaymentNotes N 
INNER JOIN Payments.PaymentNotesAccountPayableAdvance APA ON N.ID=APA.PaymentNoteId
INNER JOIN Payments.AccountPayable CP ON APA.AccountPayableId=CP.Id
GROUP BY CP.Id,N.Nature
),
CTE_NOTAS AS 
(
SELECT
ID,
SUM([AJUSTE DEBITO]) AS [AJUSTE DEBITO],
SUM([AJUSTE CREDITO]) AS [AJUSTE CREDITO]
FROM
CTE_SUMA_NOTAS
GROUP BY ID
)


SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
UO.UnitName AS [UNIDAD OPERATIVA],
CP.Code AS [CODIGO CUENTA POR PAGAR],
CAST(CP.DocumentDate AS DATE) AS [FECHA DOCUMENTO],
CAST(CP.ConfirmationDate AS DATE) AS [FECHA RADICACION],
TER.Nit+'-'+TER.DigitVerification AS NIT,
TER.Name AS PROVEEDOR,
CP.BillNumber AS FACTURA,
CP.Value AS [VALOR FACTURA],
NOTA.[AJUSTE CREDITO],
NOTA.[AJUSTE DEBITO],
CP.Balance AS [SALDO FACTURA],
1 as 'CANTIDAD',
CAST(CP.DocumentDate AS date) AS 'FECHA BUSQUEDA',
YEAR(CP.DocumentDate) AS 'AÑO FECHA BUSQUEDA',
MONTH(CP.DocumentDate) AS 'MES AÑO FECHA BUSQUEDA',
CASE MONTH(CP.DocumentDate) WHEN 1 THEN 'ENERO'
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
Payments.AccountPayable CP
INNER JOIN Common.ThirdParty TER ON CP.IdThirdParty=TER.Id AND CP.Status=2
INNER JOIN Common.OperatingUnit UO ON CP.IdOperatingUnit=UO.Id
LEFT JOIN CTE_NOTAS NOTA ON CP.Id=NOTA.Id
WHERE cp.Balance!=0
