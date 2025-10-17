-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCups
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre:[Report].[ViewCups] 
Tipo:Vista
Observacion:Parametros de CUPS con su descripciones relacionadas, esto solicitado por Monica Valderrama y Mauricio Ducon para San Jose
Profesional:Nilsson Migeul Galindo Lopez
Fecha:19-09-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Ovservaciones:
--------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones: 
***********************************************************************************************************************************/
CREATE VIEW [Report].[ViewCups] as
SELECT
CUPS.Code AS [CODIGO CUPS],
CUPS.[Description] AS [DESCRIPCION CUPS],
CD.CODE AS [CODIGO CUPS RELACIONADO],
CD.[NAME] AS [DESCRIPCION RELACIONADO],
SGRU.Code+'-'+SGRU.Name AS [SUB GRUPO CUPS],
GRUF.Code+'-'+GRUF.Name AS [GRUPO DE FACTURACION],
C.CODE+'-'+C.Name AS [CONCEPTO FACTURACION],
CASE CUPS.ServiceType WHEN 1 THEN 'Laboratorios'
					  WHEN 2 THEN 'Patologias'
					  WHEN 3 THEN 'Imagenes Diagnosticas'
					  WHEN 4 THEN 'Procedimeintos no Qx'
					  WHEN 5 THEN 'Procedimientos Qx'
					  WHEN 6 THEN 'Interconsultas'
					  WHEN 7 THEN 'Ninguno'
					  WHEN 8 THEN 'Consulta Externa' END AS [TPO SERVICIO],
CASE CUPS.ShowServiceMedicalOrder WHEN 1 THEN 'Laboratorios'
								  WHEN 2 THEN 'Patologias'
								  WHEN 3 THEN 'Imagenes Diagnosticas'
								  WHEN 4 THEN 'Procedimeintos no Qx'
								  WHEN 5 THEN 'Procedimientos Qx'
								  WHEN 6 THEN 'Interconsultas'
								  WHEN 7 THEN 'Ninguno'
								  WHEN 8 THEN 'Consulta Externa Este campo se agrgo para RIAS de Crystal' END AS [LISTA ORDENES MEDICAS],
CASE ShowDashboardOf WHEN 1 THEN 'Laboratorios'
					 WHEN 2 THEN 'Patologias'
					 WHEN 3 THEN 'Imagenes Diagnosticas'
					 WHEN 4 THEN 'Consulta Externa'
					 WHEN 5 THEN 'Quimioterapias'
					 WHEN 6 THEN 'Radioterapias'
					 WHEN 7 THEN 'Diálisis'
					 WHEN 8 THEN 'Ninguno'
					 WHEN 9 THEN 'Procedimiento no Qx'
					 WHEN 10 THEN 'Procedimiento Qx'
					 WHEN 11 THEN 'Interconsultas'
					 WHEN 12 THEN 'Otros Procedimientos'
					 WHEN 13 THEN 'Braquiterapia Este campo se agrgo para RIAS de Crystal' END AS [DASHBOARD HOSPITALARIO],
CASE ShowDashboardOfAmbulatory WHEN 1 THEN 'Laboratorios'
							   WHEN 2 THEN 'Patologias'
							   WHEN 3 THEN 'Imagenes Diagnosticas'
							   WHEN 4 THEN 'Consulta Externa'
							   WHEN 5 THEN 'Quimioterapias'
							   WHEN 6 THEN 'Radioterapias'
							   WHEN 7 THEN 'Diálisis'
							   WHEN 8 THEN 'Ninguno'
							   WHEN 9 THEN 'Procedimiento no Qx'
							   WHEN 10 THEN 'Procedimiento Qx'
							   WHEN 11 THEN 'Interconsultas'
							   WHEN 12 THEN 'Otros Procedimientos'
							   WHEN 13 THEN 'Braquiterapia Este campo se agrgo para RIAS de Crystal' END AS [DASHBOARD AMBULATORIO]
FROM 
Contract.CUPSEntity CUPS
LEFT JOIN Contract.CUPSEntityContractDescriptions DCUPS ON CUPS.ID=DCUPS.CUPSEntityId
LEFT JOIN Contract.ContractDescriptions CD ON DCUPS.ContractDescriptionId=CD.Id 
LEFT JOIN Contract.CupsSubgroup SGRU ON CUPS.CUPSSubGroupId=SGRU.Id
LEFT JOIN Billing.BillingGroup GRUF ON CUPS.BillingGroupId=GRUF.Id
LEFT JOIN Billing.BillingConcept C ON CUPS.BillingConceptId=C.Id
