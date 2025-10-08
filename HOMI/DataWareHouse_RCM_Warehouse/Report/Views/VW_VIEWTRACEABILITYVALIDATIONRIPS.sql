-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: VW_VIEWTRACEABILITYVALIDATIONRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW Report.VW_VIEWTRACEABILITYVALIDATIONRIPS 
AS
SELECT DISTINCT
FAC.InvoiceNumber AS [NÚMERO FACTURA],
FAC.InvoiceDate AS [FECHA FACTURA],
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
[INDIGO036].[Billing].[ElectronicDocument] ED
INNER JOIN [INDIGO036].[Billing].[Invoice] FAC ON ED.EntityId=FAC.Id AND ED.EntityName='Invoice'
INNER JOIN [INDIGO036].[dbo].[INPACIENT] PAC ON FAC.PatientCode=PAC.IPCODPACI
LEFT JOIN [INDIGO036].[Billing].[ElectronicDocumentDetail] EDD ON ED.Id=EDD.ElectronicDocumentId
LEFT JOIN [INDIGO036].[Billing].[ElectronicsProperties] EP ON FAC.Id=EP.EntityId AND EP.EntityName='Invoice'
LEFT JOIN [INDIGO036].[Common].[ThirdParty] TER ON FAC.ThirdPartyId=TER.Id
LEFT JOIN [INDIGO036].[Billing].[ElectronicsRIPS] ERIPS ON EP.Id=ERIPS.ElectronicsPropertiesId
LEFT JOIN [INDIGO036].[Billing].[ElectronicsRIPSDetail] ERIPSD ON ERIPS.Id=ERIPSD.ElectronicsRIPSId
