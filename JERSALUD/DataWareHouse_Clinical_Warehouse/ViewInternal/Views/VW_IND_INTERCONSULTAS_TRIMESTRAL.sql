-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INTERCONSULTAS_TRIMESTRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_INTERCONSULTAS_TRIMESTRAL
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

FROM [INDIGO031].[dbo].[HCORDINTE] AS IC
INNER JOIN [INDIGO031].[dbo].[INCUPSIPS] AS IPS ON IC.CODSERIPS = IPS.CODSERIPS
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON IC.CODCENATE = CA.CODCENATE
INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PROF ON IC.CODPROSAL = PROF.CODPROSAL
INNER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS DIAG ON IC.CODDIAGNO = DIAG.CODDIAGNO
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS PACI ON IC.IPCODPACI = PACI.IPCODPACI
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS ESP ON IC.CODESPECI = ESP.CODESPECI
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS ESP1 ON PROF.CODESPEC1 = ESP1.CODESPECI
WHERE IC.FECORDMED >= DATEADD(MONTH, -3, GETDATE())