-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_LABORATORIOS_ORDENADOS_TRIMESTRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_LABORATORIOS_ORDENADOS_TRIMESTRAL
AS 

SELECT DISTINCT 
	O.FECORDMED AS FechaOrden, O.IPCODPACI AS Documento, P.IPNOMCOMP AS Paciente, P.IPDIRECCI AS Direccion, P.IPTELEFON AS Fijo, P.IPTELMOVI AS Celular, 
	--CONVERT(varchar(10), P.IPFECNACI, 101) AS FechaNacimient, 
	P.IPFECNACI AS FechaNacimient, 
	CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS int) AS EDADATENCION, O.NUMINGRES AS Ingreso, CA.NOMCENATE AS CentroAtencion, U.UFUDESCRI AS Unidad, O.CODPROSAL AS CodProfesional, 
	PROF.NOMMEDICO AS Profesional, O.CODSERIPS AS CUPS, C.DESSERIPS AS Servicio, O.CANSERIPS AS Cant, O.CODDIAGNO AS Cie10, Dx.NOMDIAGNO AS Diagnostico,
	O.OBSSERIPS AS Observaciones,
	case
		when O.OBSSERIPS like '%transcripcion%' then 'Si'     
		when O.OBSSERIPS like '%red externa%' then 'Si'  
		when O.OBSSERIPS like '%reformulacion%' then 'Si'  
		when O.OBSSERIPS like '%especialista%' then 'Si'  
		else 'No' 
	end AS Red_Externa,

	case 
		when O.OBSSERIPS like '%Renova%' then 'Si'  
		when O.OBSSERIPS like '%transcrip%' then 'Si'  
		when O.OBSSERIPS like '%Cambio de orden%' then 'Si'  
		else 'No' 
	end AS Orden_Por_Transcripcion
		
	FROM [INDIGO031].[dbo].[HCORDLABO] AS O 
    INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS P ON P.IPCODPACI = O.IPCODPACI 
    INNER JOIN [INDIGO031].[dbo].[INCUPSIPS] AS C ON C.CODSERIPS = O.CODSERIPS 
    INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PROF ON O.CODPROSAL = PROF.CODPROSAL 
    INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON CA.CODCENATE = O.CODCENATE 
    INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS U ON U.UFUCODIGO = O.UFUCODIGO 
    INNER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS Dx ON O.CODDIAGNO = Dx.CODDIAGNO
WHERE O.FECORDMED >= DATEADD(MONTH, -3, GETDATE())
