-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_PQX_ORDENADOS_TRIMESTRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_IND_PQX_ORDENADOS_TRIMESTRAL]
AS

SELECT DISTINCT 
	PQ.FECORDMED AS FechaOrden, 
	PQ.IPCODPACI AS Documento, 
	P.IPNOMCOMP AS Paciente, 
	P.IPDIRECCI AS Direccion, 
	P.IPTELEFON AS Fijo, 
	P.IPTELMOVI AS Celular,
	--CONVERT(varchar(10), P.IPFECNACI, 101) AS FechaNacimient, 
	P.IPFECNACI AS FechaNacimient, 
	CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS int) AS EDAD, 
	PQ.NUMINGRES AS Ingreso, 
	CA.NOMCENATE AS CentroAtencion, 
	U.UFUDESCRI AS Unidad, 
	PQ.CODPROSAL AS CodProfesional, 
	PROF.NOMMEDICO AS Profesional, 
	PQ.CODSERIPS AS CUPS, 
	C.DESSERIPS AS Servicio, 
	PQ.CANSERIPS AS Cant, 
	PQ.CODDIAGNO AS Cie10, 
	Dx.NOMDIAGNO AS Diagnostico,
	PQ.OBSSERIPS AS Observaciones,
	CASE 
		when PQ.OBSSERIPS like '%transcripcion%' then 'Si'  
		when PQ.OBSSERIPS like '%red externa%' then 'Si'  
		when PQ.OBSSERIPS like '%reformulacion%' then 'Si'  
		when PQ.OBSSERIPS like '%especialista%' then 'Si'  
		else 'No' 
	END AS Red_Externa,

	CASE 
		when PQ.OBSSERIPS like '%Renova%' then 'Si'  
		when PQ.OBSSERIPS like '%transcrip%' then 'Si'  
		when PQ.OBSSERIPS like '%Cambio de orden%' then 'Si'  
		else 'No' 
	END AS Orden_Por_Transcripcion

FROM INDIGO031.dbo.HCORDPROQ AS PQ 
INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = PQ.IPCODPACI 
INNER JOIN INDIGO031.dbo.INCUPSIPS AS C ON C.CODSERIPS = PQ.CODSERIPS 
INNER JOIN INDIGO031.dbo.INPROFSAL AS PROF ON PQ.CODPROSAL = PROF.CODPROSAL 
INNER JOIN INDIGO031.dbo.ADCENATEN AS CA ON CA.CODCENATE = PQ.CODCENATE 
INNER JOIN INDIGO031.dbo.INUNIFUNC AS U ON U.UFUCODIGO = PQ.UFUCODIGO 
INNER JOIN INDIGO031.dbo.INDIAGNOS AS Dx ON PQ.CODDIAGNO = Dx.CODDIAGNO

WHERE PQ.FECORDMED >= DATEADD(MONTH, -3, GETDATE()) 
 
