-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_IMGDX_ORDENADAS_TRIMESTRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_IMGDX_ORDENADAS_TRIMESTRAL
AS

SELECT DISTINCT   
    IMG.FECORDMED AS FechaOrden
    , IMG.IPCODPACI AS Documento
    , P.IPNOMCOMP AS Paciente
    , P.IPDIRECCI AS Direccion
    , P.IPTELEFON AS Fijo
    , P.IPTELMOVI AS Celular
    , P.IPFECNACI AS FechaNacimient
    , CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS int) AS EDAD
    , IMG.NUMINGRES AS Ingreso
    , CA.NOMCENATE AS CentroAtencion
    , U.UFUDESCRI AS Unidad
    , IMG.CODPROSAL AS CodProfesional
    , PROF.NOMMEDICO AS Profesional
    , E.DESESPECI AS Especialidad
    , IMG.CODSERIPS AS CUPS
    , C.DESSERIPS AS Servicio
    , IMG.CANSERIPS AS Cant
    , IMG.CODDIAGNO AS Cie10
    , Dx.NOMDIAGNO AS Diagnostico
    , IMG.OBSSERIPS AS Observaciones
    , case 
        when IMG.OBSSERIPS like '%transcripcion%' then 'Si'  
        when IMG.OBSSERIPS like '%red externa%' then 'Si'  
        when IMG.OBSSERIPS like '%reformulacion%' then 'Si'  
        when IMG.OBSSERIPS like '%especialista%' then 'Si'  
        else 'No' 
    end AS Red_Externa
    , case 
		when IMG.OBSSERIPS like '%Renova%' then 'Si'  
		when IMG.OBSSERIPS like '%transcrip%' then 'Si'  
		when IMG.OBSSERIPS like '%Cambio de orden%' then 'Si'  
		else 'No' 
	end AS Orden_Por_Transcripcion
FROM [INDIGO031].[dbo].[HCORDIMAG] AS IMG 
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS P ON P.IPCODPACI = IMG.IPCODPACI
INNER JOIN [INDIGO031].[dbo].[INCUPSIPS] AS C ON C.CODSERIPS = IMG.CODSERIPS
INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PROF ON IMG.CODPROSAL = PROF.CODPROSAL
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS E ON PROF.CODESPEC1 = E.CODESPECI
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON CA.CODCENATE = IMG.CODCENATE
INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS U ON U.UFUCODIGO = IMG.UFUCODIGO
INNER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS Dx ON IMG.CODDIAGNO = Dx.CODDIAGNO
  
WHERE IMG.FECORDMED >= DATEADD(MONTH, -3, GETDATE())   