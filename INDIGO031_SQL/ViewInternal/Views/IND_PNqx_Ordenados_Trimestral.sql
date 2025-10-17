-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_PNqx_Ordenados_Trimestral
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [ViewInternal].[IND_PNqx_Ordenados_Trimestral]
--ALTER VIEW [dbo].[IND_PNqx_Ordenados]
as

SELECT DISTINCT   
 PNQ.FECORDMED AS FechaOrden, PNQ.IPCODPACI AS Documento, P.IPNOMCOMP AS Paciente, P.IPDIRECCI AS Direccion, P.IPTELEFON AS Fijo, 
 P.IPTELMOVI AS Celular, 
 --CONVERT(varchar(10), P.IPFECNACI, 101) AS FechaNacimient,
 P.IPFECNACI AS FechaNacimient,
 CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS int) AS EDAD, PNQ.NUMINGRES AS Ingreso, 
 CA.NOMCENATE AS CentroAtencion, U.UFUDESCRI AS Unidad, PNQ.CODPROSAL AS CodProfesional,   
 PROF.NOMMEDICO AS Profesional, PNQ.CODSERIPS AS CUPS, C.DESSERIPS AS Servicio, PNQ.CANSERIPS AS Cant, PNQ.CODDIAGNO AS Cie10, Dx.NOMDIAGNO AS Diagnostico,
 PNQ.OBSSERIPS AS Observación,
  case 
	when PNQ.OBSSERIPS like '%transcripcion%' then 'Si'  
	when PNQ.OBSSERIPS like '%red externa%' then 'Si'  
	when PNQ.OBSSERIPS like '%reformulacion%' then 'Si'  
	when PNQ.OBSSERIPS like '%especialista%' then 'Si'  
	else 'No'
 end AS Red_Externa,

 case 
		when PNQ.OBSSERIPS like '%Renova%' then 'Si'  
		when PNQ.OBSSERIPS like '%transcrip%' then 'Si'  
		when PNQ.OBSSERIPS like '%Cambio de orden%' then 'Si'  
		else 'No' 
	end AS Orden_Por_Transcripcion

FROM dbo.HCORDPRON AS PNQ INNER JOIN  
  dbo.INPACIENT AS P ON P.IPCODPACI = PNQ.IPCODPACI INNER JOIN  
  dbo.INCUPSIPS AS C ON C.CODSERIPS = PNQ.CODSERIPS INNER JOIN  
  dbo.INPROFSAL AS PROF ON PNQ.CODPROSAL = PROF.CODPROSAL INNER JOIN  
  dbo.ADCENATEN AS CA ON CA.CODCENATE = PNQ.CODCENATE INNER JOIN  
  dbo.INUNIFUNC AS U ON U.UFUCODIGO = PNQ.UFUCODIGO INNER JOIN  
  dbo.INDIAGNOS AS Dx ON PNQ.CODDIAGNO = Dx.CODDIAGNO  
WHERE PNQ.FECORDMED >= DATEADD(MONTH, -3, GETDATE())   
  
