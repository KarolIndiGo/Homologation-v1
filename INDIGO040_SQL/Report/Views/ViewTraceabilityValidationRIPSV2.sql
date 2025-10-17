-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewTraceabilityValidationRIPSV2
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[ViewTraceabilityValidationRIPS]
Tipo:Vista
Observacion:TRASAVILIDAD DE LOS RIPS ESTO SOLICITADO EN EL TICKET 2401
Profesional: Nilsson Galindo
Fecha: 31-01-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico:
Fecha:
Ovservaciones:
-----------------------------------------------------------------------------------------------------------------------------------------
Version 2
Persona que modifico:
Fecha:
Observacion:
***********************************************************************************************************************************/
CREATE view [Report].[ViewTraceabilityValidationRIPSV2] as 

WITH
CTE_ULTIMA_FECHA AS
(
SELECT
ERIPSD.ElectronicsRIPSId,
MAX(FORMAT(ERIPSD.CreationDate,'yyyy-MM-dd HH:mm')) AS [FECHA VALIDACION DETALLE]
FROM 
Billing.ElectronicsRIPSDetail ERIPSD
GROUP BY ERIPSD.ElectronicsRIPSId
),

CTE_ULTIMA_VALIDACION AS
(
SELECT
ERIPSD.Id
--ERIPSD.MessageCode AS CODIGO,
--ERIPSD.CreationDate AS [FECHA VALIDACION DETALLE]
FROM
CTE_ULTIMA_FECHA UF
INNER JOIN Billing.ElectronicsRIPSDetail ERIPSD ON UF.ElectronicsRIPSId=ERIPSD.ElectronicsRIPSId
WHERE (FORMAT(ERIPSD.CreationDate,'yyyy-MM-dd HH:mm') BETWEEN DATEADD(MINUTE, -1, UF.[FECHA VALIDACION DETALLE]) AND UF.[FECHA VALIDACION DETALLE])
--AND fac.InvoiceNumber IN ('HSJS275467')
)

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
'FACTURAS' AS [TIPO],
FAC.InvoiceValue AS [VALOR FACTURA],
FAC.InvoiceNumber AS [NUMERO FACTURA],
FAC.InvoiceDate AS [FECHA FACTURA],
TER.Nit+' - '+TER.Name AS [CLIENTE],
FAC.PatientCode AS PACIENTE,
--EP.CUV,
CASE EP.StatusRIPS WHEN 1 THEN 'ENVIADA'--'AMARILLO'
				   WHEN 2 THEN 'ACEPTADA'--'VERDE'
				   WHEN 3 THEN 'RECHAZADA' END AS [ESTADO FACTURA],
CASE ERIPSD.TypeMessage WHEN '' THEN 'EXEPCION INTERNA' ELSE ERIPSD.TypeMessage END AS [ESTADO RIPS],
--ED.ShippingDate AS [FECHA VALIDACION],
ERIPSD.MessageCode AS CODIGO,
--ERIPSD.[Path] AS RUTA,
--ERIPSD.[Message] AS MENSAJE,
ERIPSD.CreationDate AS [FECHA VALIDACION DETALLE],
GETDATE() AT TIME ZONE 'Central America Standard Time' AS [FECHA ACTUALIZACION]
FROM 
Billing.ElectronicsProperties EP
INNER JOIN Billing.Invoice FAC ON EP.EntityId=FAC.Id AND EP.EntityName='Invoice' AND FAC.Status=1
INNER JOIN Common.ThirdParty TER ON FAC.ThirdPartyId=TER.Id
INNER JOIN Billing.ElectronicsRIPS ERIPS ON EP.Id=ERIPS.ElectronicsPropertiesId
INNER JOIN Billing.ElectronicsRIPSDetail ERIPSD ON ERIPS.Id=ERIPSD.ElectronicsRIPSId
INNER JOIN CTE_ULTIMA_VALIDACION UV ON ERIPSD.Id=UV.Id
where ERIPSD.TypeMessage IS NOT NULL AND ERIPSD.MessageCode!='CFR003' --AND fac.InvoiceNumber IN ('HSJS275457')

UNION ALL

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
'NOTAS' AS [TIPO],
FAC.InvoiceValue AS [VALOR FACTURA],
FAC.InvoiceNumber AS [NUMERO FACTURA],
FAC.InvoiceDate AS [FECHA FACTURA],
TER.Nit+' - '+TER.Name AS [CLIENTE],
FAC.PatientCode AS PACIENTE,
--EP.CUV,
CASE EP.StatusRIPS WHEN 1 THEN 'ENVIADA'--'AMARILLO'
				   WHEN 2 THEN 'ACEPTADA'--'VERDE'
				   WHEN 3 THEN 'RECHAZADA' END AS [ESTADO FACTURA],
CASE ERIPSD.TypeMessage WHEN '' THEN 'EXEPCION INTERNA' ELSE ERIPSD.TypeMessage END AS [ESTADO RIPS],
--ED.ShippingDate AS [FECHA VALIDACION],
ERIPSD.MessageCode AS CODIGO,
--ERIPSD.[Path] AS RUTA,
--ERIPSD.[Message] AS MENSAJE,
ERIPSD.CreationDate AS [FECHA VALIDACION DETALLE],
GETDATE() AT TIME ZONE 'Central America Standard Time' AS [FECHA ACTUALIZACION]
FROM 
Billing.ElectronicsProperties EP
INNER JOIN Billing.BillingNote NOTE ON EP.EntityId=NOTE.Id AND EP.EntityName='BillingNote'
INNER JOIN Billing.Invoice FAC ON NOTE.EntityId=FAC.Id AND NOTE.EntityName='Invoice' --AND FAC.Status=1
INNER JOIN Common.ThirdParty TER ON FAC.ThirdPartyId=TER.Id
INNER JOIN Billing.ElectronicsRIPS ERIPS ON EP.Id=ERIPS.ElectronicsPropertiesId
INNER JOIN Billing.ElectronicsRIPSDetail ERIPSD ON ERIPS.Id=ERIPSD.ElectronicsRIPSId
INNER JOIN CTE_ULTIMA_VALIDACION UV ON ERIPSD.Id=UV.Id
--where ERIPSD.TypeMessage IS NOT NULL AND ERIPSD.MessageCode!='CFR003'


--SELECT EntityName FROM Billing.ElectronicsProperties GROUP BY EntityName

--SELECT * FROM Billing.BillingNote