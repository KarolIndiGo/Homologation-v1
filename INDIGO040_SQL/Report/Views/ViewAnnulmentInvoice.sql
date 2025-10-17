-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewAnnulmentInvoice
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[ViewAnnulmentInvoice]
Tipo:Procedimiento Vista
Observacion:Facturas anuladas
Profesional:Nilsson Miguel Galindo Lopez
Fecha:11-03-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
--------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones: 
***********************************************************************************************************************************/
CREATE VIEW [Report].[ViewAnnulmentInvoice] AS


WITH
CTE_USUARIOS AS
(
SELECT
US.UserCode,
PER.Identification,
PER.Fullname
FROM 
[Security].[User] US
INNER JOIN [Security].[Person] PER ON US.IdPerson=PER.Id
--WHERE US.Position='AUXILIAR ADMINISTRATIVO'
)

SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
UOP.UnitName AS [UNIDAD OPERATIVA],
CASE FAC.DocumentType WHEN 1 THEN 'Factura EAPB con Contrato'
					  WHEN 2 THEN 'Factura EAPB Sin Contrato'
					  WHEN 3 THEN 'Factura Particular'
					  WHEN 4 THEN 'Factura Capitada'
					  WHEN 5 THEN 'Control de Capitacion'
					  WHEN 6 THEN 'Factura Basica'
					  WHEN 7 THEN 'Factura de Venta de Productos' END AS [TIPO DE FACTURA],
FAC.InvoiceNumber AS [NUMERO FACTURA],
FAC.AdmissionNumber AS [NUMERO INGRESO],
TER.Nit AS [NIT TERCERO],
TER.Name AS [TERCERO],
TDOC.SIGLA AS [TIPO DOCUMENTO PACIENTE],
PAC.IPCODPACI AS [DOCUMENTO PACIENTE],
PAC.IPNOMCOMP AS [NOMBRE PACIENTE],
CAST(FAC.InvoiceDate AS DATE) AS [FECHA FACTURA],
FAC.TotalInvoice AS [TOTAL FACTURA],
US.Identification AS [IDENTIFICACIÓN USUARIO QUE FACTURA],
US.Fullname AS [USUARIO QUE FACTURA],
USA.Identification AS [IDENTIFICACIÓN USUARIO QUE ANULA],
USA.Fullname AS [USUARIO QUE ANULA],
FAC.AnnulmentDate AS [FECHA DE ANULACIÓN],
ANU.Code+' - '+ANU.Name AS [MOTIVO ANULACIÓN],
FAC.DescriptionReversal AS [OBSERVACIÓN ANULACIÓN],
 1 as 'CANTIDAD',
 CAST(FAC.InvoiceDate AS date) AS 'FECHA BUSQUEDA',
 YEAR(FAC.InvoiceDate) AS 'AÑO BUSQUEDA',
 MONTH(FAC.InvoiceDate) AS 'MES BUSQUEDA',
 CONCAT(FORMAT(MONTH(FAC.InvoiceDate), '00') ,' - ', 
	   CASE MONTH(FAC.InvoiceDate) 
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
Billing.Invoice FAC
INNER JOIN Common.OperatingUnit UOP ON FAC.OperatingUnitId=UOP.ID AND FAC.Status=2
INNER JOIN Common.ThirdParty TER ON FAC.ThirdPartyId=TER.Id
INNER JOIN Billing.BillingReversalReason ANU ON FAC.ReversalReasonId=ANU.Id
LEFT JOIN CTE_USUARIOS US ON FAC.InvoicedUser=US.UserCode
LEFT JOIN CTE_USUARIOS USA ON FAC.AnnulmentUser=USA.UserCode
LEFT JOIN dbo.INPACIENT PAC ON FAC.PatientCode=PAC.IPCODPACI
LEFT JOIN dbo.ADTIPOIDENTIFICA TDOC ON PAC.IPTIPODOC=TDOC.CODIGO
