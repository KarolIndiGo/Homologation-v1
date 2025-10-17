-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewTraceabilityValidationRIPS
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
CREATE view [Report].[ViewTraceabilityValidationRIPS] as 

SELECT DISTINCT
FAC.InvoiceNumber AS [NÚMERO FACTURA],
fac.InvoiceDate AS [FECHA FACTURA],
TER.Nit+' - '+TER.Name AS [CLIENTE],
PAC.IPCODPACI+' - '+PAC.IPNOMCOMP AS PACIENTE,
EP.CUV,
CASE EP.StatusRIPS WHEN 1 THEN 'AMARILLO'
				   WHEN 2 THEN 'VERDE'
				   WHEN 3 THEN 'ROJO' END AS ESTADO,
ED.ShippingDate AS [FECHA VALIDACION],
ERIPSD.MessageCode AS CODIGO,
ERIPSD.[Path] AS RUTA,
ERIPSD.[Message] AS MENSAJE,
ERIPSD.CreationDate AS [FECHA VALIDACION DETALLE]
from 
Billing.ElectronicDocument ED
INNER JOIN Billing.Invoice FAC ON ED.EntityId=FAC.Id AND ED.EntityName='Invoice'
INNER JOIN dbo.INPACIENT PAC ON FAC.PatientCode=PAC.IPCODPACI
LEFT JOIN Billing.ElectronicDocumentDetail EDD ON ED.Id=EDD.ElectronicDocumentId
LEFT JOIN Billing.ElectronicsProperties EP ON FAC.Id=EP.EntityId AND EP.EntityName='Invoice'
LEFT JOIN Common.ThirdParty TER ON FAC.ThirdPartyId=TER.Id
LEFT JOIN Billing.ElectronicsRIPS ERIPS ON EP.Id=ERIPS.ElectronicsPropertiesId
LEFT JOIN Billing.ElectronicsRIPSDetail ERIPSD ON ERIPS.Id=ERIPSD.ElectronicsRIPSId
--where fac.InvoiceNumber IN ('HSJS275147')

