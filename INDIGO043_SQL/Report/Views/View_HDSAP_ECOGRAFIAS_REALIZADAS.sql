-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ECOGRAFIAS_REALIZADAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0










CREATE VIEW [Report].[View_HDSAP_ECOGRAFIAS_REALIZADAS]
AS

SELECT I.IPCODPACI AS Cedula, 
       P.IPNOMCOMP AS Nombre, 
	   DATEDIFF(YY, P.IPFECNACI, I.FECORDMED) AS Edad,
	   P.IPFECNACI AS FechaNacimiento, 
       CASE
           WHEN P.IPSEXOPAC = 2
           THEN 'Femenino'
           WHEN P.IPSEXOPAC = 1
           THEN 'Masculino'
       END AS Genero, 
       I.NUMINGRES AS Ingreso, 
       U.UFUDESCRI AS UnidadSolicita, 
       I.FECORDMED AS FechaOrden,
	   I.FECTRASER AS FechaTrascripción, 
	   DATEDIFF(HOUR, I.FECORDMED, I.FECTRASER)  AS FechaOrdenVsFechaTranscripcion, 
	   PRO.NOMMEDICO AS MedicoSolicita,
       I.CODSERIPS AS CodigoServicio, 
       C.DESSERIPS AS DescripciónServicio, 
       I.CANSERIPS AS CantidadSolicitada, 
	   SG.CODSUBIPS AS CodigoTipoExamen,
       SG.DESSUBIPS AS TipoExamen,
       CASE
           WHEN ESTSERIPS = 1
           THEN 'Solicitado'
           WHEN ESTSERIPS = 2
           THEN 'Muestra Recolectada'
           WHEN ESTSERIPS = 3
           THEN 'Examen Tomado'
           WHEN ESTSERIPS = 4
           THEN 'Examen Interpretado'
           WHEN ESTSERIPS = 5
           THEN 'Remitido'
           WHEN ESTSERIPS = 6
           THEN 'Anulado'
           WHEN ESTSERIPS = 7
           THEN 'Extramural'
       END AS EstadoExamen,
       CASE
           WHEN SERTRANSC = 0
           THEN 'Sin Lectura'
           WHEN SERTRANSC = 1
           THEN 'Con Lectura'
       END AS LecturaRadiologo,
       CASE
           WHEN SERVALMED = 0
           THEN 'TranscripcionSinValidar'
           WHEN SERVALMED = 1
           THEN 'TranscripcionValidada'
       END AS ValidaciónTrascripción, 
       PRO2.NOMMEDICO AS UsuarioTrascribio, 
       MU.MUNNOMBRE AS MunicipioRes, 
       MU.DEPMUNCOD AS CodMunicipio, 
       ha.name AS Entidad,
       CASE
           WHEN ha.EntityType = 1
           THEN 'Contributivo'
           WHEN ha.EntityType = 2
           THEN 'Subsidiado'
           WHEN ha.EntityType = 3
           THEN 'Vinculado municipio'
           WHEN ha.EntityType = 4
           THEN 'Vinculado depto'
           WHEN ha.EntityType = 5
           THEN 'ARL'
           WHEN ha.EntityType = 6
           THEN 'M Prepagada'
           WHEN ha.EntityType = 7
           THEN 'IPS privada'
           WHEN ha.EntityType = 8
           THEN 'IPS publica'
           WHEN ha.EntityType = 9
           THEN 'R Especial'
           WHEN ha.EntityType = 10
           THEN 'Acciedente de transito'
           WHEN ha.EntityType = 11
           THEN 'Fosyga'
           WHEN ha.EntityType = 12
           THEN 'otro'
       END AS Régimen,
	   'Ambulatorio' as TipoIngreso
FROM dbo.AMBORDIMA AS I
     INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = I.IPCODPACI
     INNER JOIN dbo.INUBICACI AS ub ON P.AUUBICACI = UB.AUUBICACI
     INNER JOIN dbo.INMUNICIP AS MU ON UB.DEPMUNCOD = MU.DEPMUNCOD
     INNER JOIN dbo.ADINGRESO AS ING ON I.NUMINGRES = ING.NUMINGRES
     INNER JOIN Contract.HealthAdministrator AS ha ON ING.GENCONENTITY = ha.Id
     INNER JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = I.UFUCODIGO
     INNER JOIN dbo.INCUPSIPS AS C ON C.CODSERIPS = I.CODSERIPS
     INNER JOIN dbo.INCUPSSUB AS SG ON SG.CODGRUSUB = C.CODGRUSUB
	 LEFT JOIN dbo.INPROFSAL AS PRO ON I.CODPROSAL=PRO.CODPROSAL
	 LEFT JOIN dbo.INPROFSAL AS PRO2 ON I.CODUSUTRA=PRO2.CODPROSAL
--WHERE SG.CODSUBIPS IN (2,7)


union 

SELECT I.IPCODPACI AS Cedula, 
       P.IPNOMCOMP AS Nombre, 
	   DATEDIFF(YY, P.IPFECNACI, I.FECORDMED) AS Edad,
	   P.IPFECNACI AS FechaNacimiento, 
       CASE
           WHEN P.IPSEXOPAC = 2
           THEN 'Femenino'
           WHEN P.IPSEXOPAC = 1
           THEN 'Masculino'
       END AS Genero, 
       I.NUMINGRES AS Ingreso, 
       U.UFUDESCRI AS UnidadSolicita, 
       I.FECORDMED AS FechaOrden,
	   I.FECTRASER AS FechaTrascripción,
	   DATEDIFF(HOUR, I.FECORDMED, I.FECTRASER)  AS TiempoTomavsLecturahoras,  
	   PRO.NOMMEDICO AS MedicoSolicita,
       I.CODSERIPS AS CodigoServicio, 
       C.DESSERIPS AS DescripciónServicio, 
       I.CANSERIPS AS CantidadSolicitada, 
	   SG.CODSUBIPS AS CodigoTipoExamen,
       SG.DESSUBIPS AS TipoExamen,
       CASE
           WHEN ESTSERIPS = 1
           THEN 'Solicitado'
           WHEN ESTSERIPS = 2
           THEN 'Muestra Recolectada'
           WHEN ESTSERIPS = 3
           THEN 'Examen Tomado'
           WHEN ESTSERIPS = 4
           THEN 'Examen Interpretado'
           WHEN ESTSERIPS = 5
           THEN 'Remitido'
           WHEN ESTSERIPS = 6
           THEN 'Anulado'
           WHEN ESTSERIPS = 7
           THEN 'Extramural'
       END AS EstadoExamen,
       CASE
           WHEN SERTRANSC = 0
           THEN 'Sin Lectura'
           WHEN SERTRANSC = 1
           THEN 'Con Lectura'
       END AS LecturaRadiologo,
       CASE
           WHEN SERVALMED = 0
           THEN 'TranscripcionSinValidar'
           WHEN SERVALMED = 1
           THEN 'TranscripcionValidada'
       END AS ValidaciónTrascripción, 
       PRO2.NOMMEDICO AS UsuarioTrascribio, 
       MU.MUNNOMBRE AS MunicipioRes, 
       MU.DEPMUNCOD AS CodMunicipio, 
       ha.name AS Entidad,
       CASE
           WHEN ha.EntityType = 1
           THEN 'Contributivo'
           WHEN ha.EntityType = 2
           THEN 'Subsidiado'
           WHEN ha.EntityType = 3
           THEN 'Vinculado municipio'
           WHEN ha.EntityType = 4
           THEN 'Vinculado depto'
           WHEN ha.EntityType = 5
           THEN 'ARL'
           WHEN ha.EntityType = 6
           THEN 'M Prepagada'
           WHEN ha.EntityType = 7
           THEN 'IPS privada'
           WHEN ha.EntityType = 8
           THEN 'IPS publica'
           WHEN ha.EntityType = 9
           THEN 'R Especial'
           WHEN ha.EntityType = 10
           THEN 'Acciedente de transito'
           WHEN ha.EntityType = 11
           THEN 'Fosyga'
           WHEN ha.EntityType = 12
           THEN 'otro'
       END AS Régimen,
	   'Hospitalario' as TipoIngreso
FROM dbo.HCORDIMAG AS I
     INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = I.IPCODPACI
     INNER JOIN dbo.INUBICACI AS ub ON P.AUUBICACI = UB.AUUBICACI
     INNER JOIN dbo.INMUNICIP AS MU ON UB.DEPMUNCOD = MU.DEPMUNCOD
     INNER JOIN dbo.ADINGRESO AS ING ON I.NUMINGRES = ING.NUMINGRES
     INNER JOIN Contract.HealthAdministrator AS ha ON ING.GENCONENTITY = ha.Id
     INNER JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = I.UFUCODIGO
     INNER JOIN dbo.INCUPSIPS AS C ON C.CODSERIPS = I.CODSERIPS
     INNER JOIN dbo.INCUPSSUB AS SG ON SG.CODGRUSUB = C.CODGRUSUB
	 INNER JOIN dbo.INPROFSAL AS PRO ON I.CODPROSAL=PRO.CODPROSAL
	 LEFT JOIN dbo.INPROFSAL AS PRO2 ON I.CODUSUTRA=PRO2.CODPROSAL
  

