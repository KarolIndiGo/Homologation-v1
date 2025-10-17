-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Pqx_Ordenados_Trimestral
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Pqx_Ordenados_Trimestral]
AS

SELECT DISTINCT 
	PQ.FECORDMED AS FechaOrden, PQ.IPCODPACI AS Documento, P.IPNOMCOMP AS Paciente, P.IPDIRECCI AS Direccion, P.IPTELEFON AS Fijo, P.IPTELMOVI AS Celular,
	--CONVERT(varchar(10), P.IPFECNACI, 101) AS FechaNacimient, 
	P.IPFECNACI AS FechaNacimient, 
	CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS int) AS EDAD, PQ.NUMINGRES AS Ingreso, CA.NOMCENATE AS CentroAtencion, U.UFUDESCRI AS Unidad, PQ.CODPROSAL AS CodProfesional, 
	PROF.NOMMEDICO AS Profesional, PQ.CODSERIPS AS CUPS, C.DESSERIPS AS Servicio, PQ.CANSERIPS AS Cant, PQ.CODDIAGNO AS Cie10, Dx.NOMDIAGNO AS Diagnostico,
	PQ.OBSSERIPS AS Observaciones,
	case 
		when PQ.OBSSERIPS like '%transcripcion%' then 'Si'  
		when PQ.OBSSERIPS like '%red externa%' then 'Si'  
		when PQ.OBSSERIPS like '%reformulacion%' then 'Si'  
		when PQ.OBSSERIPS like '%especialista%' then 'Si'  
		else 'No' 
	end AS Red_Externa,

	 case 
		when PQ.OBSSERIPS like '%Renova%' then 'Si'  
		when PQ.OBSSERIPS like '%transcrip%' then 'Si'  
		when PQ.OBSSERIPS like '%Cambio de orden%' then 'Si'  
		else 'No' 
	end AS Orden_Por_Transcripcion

FROM dbo.HCORDPROQ AS PQ INNER JOIN
	 dbo.INPACIENT AS P ON P.IPCODPACI = PQ.IPCODPACI INNER JOIN
	 dbo.INCUPSIPS AS C ON C.CODSERIPS = PQ.CODSERIPS INNER JOIN
	 dbo.INPROFSAL AS PROF ON PQ.CODPROSAL = PROF.CODPROSAL INNER JOIN
	 dbo.ADCENATEN AS CA ON CA.CODCENATE = PQ.CODCENATE INNER JOIN
	 dbo.INUNIFUNC AS U ON U.UFUCODIGO = PQ.UFUCODIGO INNER JOIN
	 dbo.INDIAGNOS AS Dx ON PQ.CODDIAGNO = Dx.CODDIAGNO
WHERE PQ.FECORDMED >= DATEADD(MONTH, -3, GETDATE()) 
 
