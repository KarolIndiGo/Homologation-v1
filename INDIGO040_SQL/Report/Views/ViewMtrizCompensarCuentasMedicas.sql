-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewMtrizCompensarCuentasMedicas
-- Extracted by Fabric SQL Extractor SPN v3.9.0







/*******************************************************************************************************************
Nombre:[Report].[ViewMtrizCompensarCuentasMedicas] 
Tipo:Vista
Observacion: Se crea informe MATRIZ FACTURAS COMPENSAR CUENTAS MEDICA solicitado por Samuel Darío Lancheros por medio de correo electronico,
			  y autorizado por Adriana Parra
Profesional: Nilsson Miguel Galindo Lopez
Fecha:27-10-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:23-08-2024
Ovservaciones:Se adiciono los anticipos(abonos) para que restara el saldo de factura, esto solicitado en el ticket 19984
--------------------------------------
Version 3
Persona que modifico:
Fecha:
Ovservaciones:
***********************************************************************************************************************************/
CREATE view [Report].[ViewMtrizCompensarCuentasMedicas] as


WITH

CTE_NOTAS AS 
(
SELECT
ND.InvoiceId,
SUM(ND.AdjusmentValue) AS AdjusmentValue,
N.Nature
FROM 
Billing.BillingNote N 
INNER JOIN Billing.BillingNoteDetail ND ON  N.ID=ND.BillingNoteId
GROUP BY ND.InvoiceId,N.Nature
),

CTE_ANTICIPOS AS 
(
SELECT DISTINCT PA.ID,PTD.[VALUE],AR.InvoiceId FROM 
Portfolio.PortfolioAdvance PA
INNER JOIN Portfolio.PortfolioTransfer PT ON PA.Id=PT.PortfolioAdvanceId
INNER JOIN Portfolio.PortfolioTransferDetail PTD ON PT.Id=PTD.PortfolioTrasferId
INNER JOIN Portfolio.AccountReceivable AR ON PTD.AccountReceivableId=AR.Id AND AR.AccountReceivableType!=6
)


SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
CAT.Name AS [Fuente Documento],
FAC.InvoiceNumber AS [Número Documento],
CAT.Code AS [Fuente del Documento Origen],
CAST(FAC.InvoiceDate AS DATE) AS [Fecha Documento],
FAC.AdmissionNumber AS [Número de Historia],
FAC.AdmissionNumber AS [Número de Ingreso],
TIP.SIGLA AS [Tipo de Identificación],
FAC.PatientCode AS [Identificación Paciente],
PAC.IPNOMCOMP AS Nombre,
PAC.IPFECNACI AS [Fecha de Nacimiento],
ING.IAUTORIZA AS [Nro Autorización],
FAC.ThirdPartySalesValue AS [Valor Documento],
(FAC.ThirdPartySalesValue-ISNULL(NC.AdjusmentValue,0)-ISNULL(CRU.[Value],0))+ISNULL(ND.AdjusmentValue,0) AS [Saldo Factura],
CRU.[Value] AS Abonos,
0 AS Recibos,
ISNULL(ND.AdjusmentValue,0) AS [Nota Débito],
ISNULL(NC.AdjusmentValue,0) AS [Nota credito],
JT.Code AS [Código del Centro de Costos],
JT.[Description] AS [Nombre del Centro de Costos],
CAST(ING.IFECHAING AS DATE) AS [Fecha de Ingreso],
CAST(ISNULL(ING.FECHEGRESO,ALT.FECALTPAC) AS DATE) AS [Fecha Egreso Paciente],
FAC.TotalPatientSalesPrice AS [Valor Copago],
DIA.CODDIAGNO AS [Diagnostico principal al egresar],
DIA.NOMDIAGNO AS [Nombre del Diagnóstico],
CASE GRU.EntityType WHEN 1 THEN 'C'
					WHEN 2 THEN 'S' 
					WHEN 6 THEN 'MP' END [Tipo de usuario],
CASE ING.TIPOINGRE WHEN 1 THEN 'Ambulatorio'
				   WHEN 2 THEN 'Hospitalario' END AS [Tipo Ingreso],
FUN.UFUDESCRI AS [UNIDAD FUNCIONAL EGRESO],
1 as 'CANTIDAD',
CAST(FAC.InvoiceDate AS date) AS 'FECHA BUSQUEDA',
YEAR(FAC.InvoiceDate) AS 'AÑO BUSQUEDA',
MONTH(FAC.InvoiceDate) AS 'MES BUSQUEDA',
CONCAT(FORMAT(MONTH(FAC.InvoiceDate), '00') ,' - ', 
	CASE MONTH(FAC.InvoiceDate) WHEN 1 THEN 'ENERO'
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
Billing.Invoice FAC 
INNER JOIN dbo.INPACIENT PAC ON FAC.PatientCode=PAC.IPCODPACI AND FAC.Status=1
INNER JOIN dbo.ADTIPOIDENTIFICA TIP ON PAC.IPTIPODOC=TIP.CODIGO
INNER JOIN dbo.ADINGRESO ING ON FAC.AdmissionNumber=ING.NUMINGRES
INNER JOIN Contract.CareGroup GRU ON FAC.CareGroupId=GRU.Id
INNER JOIN CONTRACT.HEALTHADMINISTRATOR COM ON FAC.HealthAdministratorId=COM.Id AND COM.Name LIKE '%COMPENSAR%'
LEFT JOIN GeneralLedger.JournalVouchers JV ON FAC.Id=JV.EntityId AND JV.EntityName='Invoice'
LEFT JOIN GeneralLedger.JournalVoucherTypes JT ON JV.IdJournalVoucher=JT.Id
LEFT JOIN Billing.InvoiceCategories CAT ON FAC.InvoiceCategoryId=CAT.Id 
LEFT JOIN CTE_NOTAS ND ON FAC.Id=ND.InvoiceId AND ND.Nature=1
LEFT JOIN CTE_NOTAS NC ON FAC.Id=NC.InvoiceId AND NC.Nature=2
LEFT JOIN dbo.INDIAGNOP DX ON FAC.AdmissionNumber=DX.NUMINGRES AND DX.CODDIAPRI=1
LEFT JOIN dbo.INDIAGNOS DIA ON ISNULL(ING.CODDIAEGR,DX.CODDIAGNO)=DIA.CODDIAGNO
LEFT JOIN dbo.HCREGEGRE ALT ON FAC.AdmissionNumber=ALT.NUMINGRES
LEFT JOIN dbo.INUNIFUNC FUN ON ISNULL(ING.UFUEGRMED,ALT.UFUCODIGO)=FUN.UFUCODIGO
LEFT JOIN CTE_ANTICIPOS CRU ON FAC.ID=CRU.InvoiceId
--where FAC.InvoiceNumber IN ('HSJS158852')

--where cast(fac.InvoiceDate as date) between '2024-07-01' and '2024-07-31'
--WHERE CRU.[Value] IS NOT NULL AND YEAR(fac.InvoiceDate) = '2024'

--select * from Billing.Invoice where InvoiceNumber='HSJS49203'
--select * from  Billing.ServiceOrderDetail
--SELECT * FROM Portfolio.AccountReceivable where InvoiceId='190418'
--SELECT * FROM Portfolio.PortfolioTransferDetail WHERE AccountReceivableId=375119
--select * from Portfolio.PortfolioTransfer WHERE Id=38674
--select * from Portfolio.PortfolioAdvance where ID=65573
--select * from Portfolio.AccountReceivableAccounting where AccountReceivableId=375119

