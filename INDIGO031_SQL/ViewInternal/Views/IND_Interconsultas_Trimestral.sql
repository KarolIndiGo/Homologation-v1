-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Interconsultas_Trimestral
-- Extracted by Fabric SQL Extractor SPN v3.9.0



--ALTER VIEW [dbo].[IND_Interconsultas]
CREATE VIEW [ViewInternal].[IND_Interconsultas_Trimestral]
AS

SELECT IC.NUMINGRES AS Ingreso, 
            CA.NOMCENATE AS [Centro de Atencion], 
            IC.IPCODPACI AS [Documento Paciente], 
            PACI.IPNOMCOMP AS [Nombre Paciente], 
            IC.CODDIAGNO AS [Codigo Diagnostico], 
            DIAG.NOMDIAGNO AS [Nombre Diagnostico], 
            IC.CODPROSAL AS [Documento Profesional], 
            PROF.NOMMEDICO AS [Nombre Profesional], 
			 ESP1.DESESPECI AS [Especialidad Medico],
            IC.FECORDMED AS [Fecha Orden Medica], 
            IC.CODSERIPS AS CUPS, 
            IPS.DESSERIPS AS Remitido, 
            IC.CODESPECI AS [Codigo Especialidad], 
            ESP.DESESPECI AS [Nombre Especialidad],
			IC.OBSSERIPS AS Observaciones,
			case 
				when IC.OBSSERIPS like '%transcripcion%' then 'Si'  
				when IC.OBSSERIPS like '%red externa%' then 'Si'  
				when IC.OBSSERIPS like '%reformulacion%' then 'Si'  
				when IC.OBSSERIPS like '%especialista%' then 'Si'  
				else 'No' 
			end AS Red_Externa,

	 case 
		when IC.OBSSERIPS like '%Renova%' then 'Si'  
		when IC.OBSSERIPS like '%transcrip%' then 'Si'  
		when IC.OBSSERIPS like '%Cambio de orden%' then 'Si'  
		else 'No' 
	end AS Orden_Por_Transcripcion

     FROM dbo.HCORDINTE AS IC
          INNER JOIN dbo.INCUPSIPS AS IPS ON IC.CODSERIPS = IPS.CODSERIPS
          INNER JOIN dbo.ADCENATEN AS CA ON IC.CODCENATE = CA.CODCENATE
          INNER JOIN dbo.INPROFSAL AS PROF ON IC.CODPROSAL = PROF.CODPROSAL
          INNER JOIN dbo.INDIAGNOS AS DIAG ON IC.CODDIAGNO = DIAG.CODDIAGNO
          INNER JOIN dbo.INPACIENT AS PACI ON IC.IPCODPACI = PACI.IPCODPACI
          INNER JOIN dbo.INESPECIA AS ESP ON IC.CODESPECI = ESP.CODESPECI
		    INNER JOIN dbo.INESPECIA AS ESP1 ON prof.CODESPEC1 = ESP1.CODESPECI
WHERE IC.FECORDMED >= DATEADD(MONTH, -3, GETDATE()) 

