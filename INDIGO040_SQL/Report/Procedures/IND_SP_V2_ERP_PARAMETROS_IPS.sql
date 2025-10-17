-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PARAMETROS_IPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*******************************************************************************************************************
Nombre: [Report].[IND_SP_V2_ERP_PARAMETROS_IPS]
Tipo:Vista
Observacion:Parametrización de servicios IPS
Profesional: Nilsson Miguel Galindo Lopez
Fecha:02-02-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha: 
Ovservaciones:
-------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Observacion:
Fecha:
****************************************************************************************************************************/

CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PARAMETROS_IPS] 
AS


SELECT
IPS.Code AS [CODIGO IPS],
IPS.[Name] AS [NOMBRE SERVICIO IPS],
CASE IPS.ServiceManual WHEN 1 THEN 'ISS 2001'
					   WHEN 2 THEN 'ISS 2004'
					   WHEN 3 THEN 'SOAT' END AS [TIPO MANUAL],
CASE IPS.Presentation WHEN 1 THEN 'No quirurgico'
					  WHEN 2 THEN 'Quirurgico'
					  WHEN 3 THEN 'Paquete' END AS [PRESENTACIÓN],
CASE IPS.ServiceClass WHEN 1 THEN 'Ninguno'
					  WHEN 2 THEN 'Cirujano'
					  WHEN 3 THEN 'Anesteciologo'
					  WHEN 4 THEN 'Ayudante'
					  WHEN 5 THEN 'Derecho Sala'
					  WHEN 6 THEN 'Materiales Sutura'
					  WHEN 7 THEN 'Instrumentacion Quirurgica' END AS CLASE,
CF.Code AS [CODIGO CONCEPTO DE FACTURACIÓN],
CF.NAME AS [CONCEPTO DE FACTURACIÓN],
CASE IPS.ServiceType WHEN 1 THEN 'Ninguno'
					 WHEN 2 THEN 'Diagnostico'
					 WHEN 3 THEN 'Terapeutico'
					 WHEN 4 THEN 'Proteccion Especifica'
					 WHEN 5 THEN 'Deteccion temprana enfermedad general'
					 WHEN 6 THEN 'Deteccion temprana enfermedad profesional' END AS TIPO,
IPS.AuthorizationLevel AS NIVEL,
CASE IPS.SubattentionCode WHEN 1 THEN 'Ninguno'
						  WHEN 2 THEN 'Estancia Individual'
						  WHEN 3 THEN 'Habitacion compartida'
						  WHEN 4 THEN 'UCI Adultos'
						  WHEN 5 THEN 'UCI Neonatal'
						  WHEN 6 THEN 'UCI Cuidados Medianos'
						  WHEN 7 THEN 'Incubadora'
						  WHEN 8 THEN 'Consulta Medica General'
						  WHEN 9 THEN 'Consulta Especialista'
						  WHEN 10 THEN 'Interconsulta'
						  WHEN 11 THEN 'Visitas Hospitalarias'
						  WHEN 12 THEN 'Honorarios Cirujanos'
						  WHEN 13 THEN 'Honorarios Anestesia'
						  WHEN 14 THEN 'Honorarios Ayudantia'
						  WHEN 15 THEN 'Honorarios Instrumentacion'
						  WHEN 16 THEN 'Derechos Sala'
						  WHEN 17 THEN 'Derecho Anestesia'
						  WHEN 18 THEN 'Derecho Equipo'
						  WHEN 19 THEN 'Insumos Hospitalarios'
						  WHEN 20 THEN 'Material Quirurgico'
						  WHEN 21 THEN 'Medicamentos' 
						  WHEN 22 THEN 'Oxigeno'
						  WHEN 23 THEN 'Laboratorio'
						  WHEN 24 THEN 'Radiologia'
						  WHEN 25 THEN 'Tomografias'
						  WHEN 26 THEN 'Medicina Nuclear'
						  WHEN 27 THEN 'Resonancia Magnetica'
						  WHEN 28 THEN 'Examenes Complementarios'
						  WHEN 29 THEN 'Examenes Vasculares'
						  WHEN 30 THEN 'Hemodinamia'
						  WHEN 31 THEN 'Banco Sangre'
						  WHEN 32 THEN 'Terapias'
						  WHEN 33 THEN 'Ambulancia'
						  WHEN 34 THEN 'Factura Integral' END AS [CÓDIGO SUBATECIÓN],
IIF(IPS.IVAId IS NULL,'NO','SI') AS [PRODUCTO GRAVADO],
CASE IPS.[Procedure] WHEN 1 THEN 'Diagnostico'
					 WHEN 2 THEN 'Laboratorio'
					 WHEN 3 THEN 'Odontologia'
					 WHEN 4 THEN 'Consulta - Urgencias'
					 WHEN 5 THEN 'Hospitalizacion' END AS PROCEDIMIENTO,
IPS.ContributionsWeeks AS [SEMANAS COTIZADAS],
CASE IPS.InPatientRecoveryFeeType WHEN 1 THEN 'Ninguna'
								  WHEN 2 THEN 'Cuota Moderadora'
								  WHEN 3 THEN 'Copago'
								  WHEN 4 THEN 'Bono'
								  WHEN 5 THEN 'Franquicia'
								  WHEN 6 THEN 'Otra' END AS [LIQ. INGRESO AMBULATORIO],
CASE IPS.OutPatientRecoveryFeeType WHEN 1 THEN 'Ninguna'
								   WHEN 2 THEN 'Cuota Moderadora'
								   WHEN 3 THEN 'Copago'
								   WHEN 4 THEN 'Bono'
								   WHEN 5 THEN 'Franquicia'
								   WHEN 6 THEN 'Otra' END AS [LIQ. INGRESO HOSPITALARIO],
CASE IPS.PathologyService WHEN 0 THEN 'NO' ELSE 'SI' END AS PATOLOGÍA,
CASE IPS.PromotionAndPrevention WHEN 0 THEN 'NO' ELSE 'SI' END AS [PROMOCIÓN Y PREVENCIÓN],
IPS.PromotionAndPreventionActivities AS [ACTIVIDAD DEL SERVICIO],
CASE IPS.MinimunAgeUnit WHEN 1 THEN 'Años - '+CAST(IPS.MinimunAge AS VARCHAR(3))
						WHEN 2 THEN 'Meses - '+CAST(IPS.MinimunAge AS VARCHAR(3))
						WHEN 3 THEN 'Dias - '+CAST(IPS.MinimunAge AS VARCHAR(3)) END AS [EDAD MINIMA],
CASE IPS.MaximumAgeUnit WHEN 1 THEN 'Años - '+CAST(IPS.MaximumAge AS VARCHAR(3))
						WHEN 2 THEN 'Meses - '+CAST(IPS.MaximumAge AS VARCHAR(3))
						WHEN 3 THEN 'Dias - '+CAST(IPS.MaximumAge AS VARCHAR(3)) END AS [EDAD MAXIMA],
CASE IPS.InMale WHEN 1 THEN 'SI' ELSE 'NO' END AS [MASCULINO],
CASE IPS.InFemale WHEN 1 THEN 'SI' ELSE 'NO' END AS [FEMENINO],
CASE IPS.POS WHEN 1 THEN 'SI' ELSE 'NO' END AS PBS,
CASE IPS.ComplexityLevel WHEN 1 THEN 'Baja'
						 WHEN 2 THEN 'Media'
						 WHEN 3 THEN 'Alta' END AS COMPLEJIDAD,
CASE IPS.ChildbirthAbortion WHEN 1 THEN 'SI' ELSE 'NO' END AS [PARTO/ABORTO],
SPIPS.Code AS [CODIGO DEL SERVICIO PROCEDIMIENTO],
SPIPS.Name AS [SERVICIO PROCEDIMIENTO],
CUPS.Code AS [CODIGO CUPS HOMOLOGADO],
CUPS.Description AS [DESCRIPCION CUPS HOMOLOGADO]
FROM 
Contract.IPSService IPS
INNER JOIN Contract.CupsHomologation HCUP ON IPS.Id=HCUP.IPSServiceId
INNER JOIN Contract.CUPSEntity CUPS ON HCUP.CupsEntityId=CUPS.Id
LEFT JOIN Contract.SurgicalProcedureService SP ON IPS.Id=SP.IPSServiceParentId
LEFT JOIN Contract.IPSService SPIPS ON SP.IPSServiceId=SPIPS.Id
LEFT JOIN Billing.BillingConcept CF ON SPIPS.BillingConceptId=CF.Id


--SELECT * FROM Contract.IPSService where Code in ('413101','S41401')
--select * from Contract.SurgicalProcedureService where IPSServiceParentId=5017
--select * from Billing.BillingConcept where id=2
--SELECT * FROM Contract.CupsHomologation where Code='905702'