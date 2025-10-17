-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_IMAGENOLOGIA_AMBULATORIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_IMAGENOLOGIA_AMBULATORIA]
AS

SELECT     I.IPCODPACI AS Cedula, P.IPNOMCOMP AS Nombre, I.NUMINGRES AS Ingreso, U.UFUDESCRI AS UnidadSolicita, I.FECORDMED AS FechaOrden, 
                      I.CODSERIPS AS CodigoServicio, C.DESSERIPS AS DescripciónServicio, I.CANSERIPS AS CantidadSolicitada, SG.DESSUBIPS AS TipoExamen, 
                      CASE WHEN ESTSERIPS = '1' THEN 'Solicitado' WHEN ESTSERIPS = '2' THEN 'Muestra Recolectada' WHEN ESTSERIPS = '3' THEN 'Examen Tomado' WHEN ESTSERIPS
                       = '4' THEN 'Examen Interpretado' WHEN ESTSERIPS = '5' THEN 'Remitido' WHEN ESTSERIPS = '6' THEN 'Anulado' WHEN ESTSERIPS = '7' THEN 'Extramural' END AS
                       EstadoExamen, CASE WHEN SERTRANSC = 0 THEN 'Sin Lectura' WHEN SERTRANSC = 1 THEN 'Con Lectura' END AS LecturaRadiologo, 
                      CASE WHEN SERVALMED = 0 THEN 'TranscripcionSinValidad' WHEN SERVALMED = 1 THEN 'TranscripcionValidada' END AS ValidaciónTrascripción, 
                      I.CODUSUTRA AS UsuarioTrascribio, I.FECTRASER AS FechaTrascripción,
					  P.IPFECNACI AS FechaNacimiento, datediff(YY,P.IPFECNACI,I.FECORDMED) as edad,
					  CASE WHEN P.IPSEXOPAC = 2 THEN 'Femenino' WHEN P.IPSEXOPAC = 1 THEN 'Masculino' END AS Genero,
					  MU.MUNNOMBRE AS MunicipioRes, MU.DEPMUNCOD AS CodMunicipio,
					  ha.name as Entidad,
					  	CASE WHEN ha.EntityType =1 then 'Contributivo' 
						 WHEN ha.EntityType =2 then 'Subsidiado' 
						 WHEN ha.EntityType =3 then 'Vinculado municipio'
						 WHEN ha.EntityType =4 then 'Vinculado depto'
						 WHEN ha.EntityType =5 then 'ARL'
						 WHEN ha.EntityType =6 then 'M Prepagada'
						 WHEN ha.EntityType =7 then 'IPS privada'
						 WHEN ha.EntityType =8 then 'IPS publca'
						 WHEN ha.EntityType =9 then 'R Especial'
						 WHEN ha.EntityType =10 then 'Acciedente de transito'
						 WHEN ha.EntityType =11 then 'Fosyga'
						 WHEN ha.EntityType =12 then 'otro'
						 END as Régimen
FROM         AMBORDIMA AS I INNER JOIN
                      INPACIENT AS P ON P.IPCODPACI = I.IPCODPACI INNER JOIN
					  INUBICACI AS ub ON P.AUUBICACI = UB.AUUBICACI INNER JOIN
					  INMUNICIP AS MU ON UB.DEPMUNCOD = MU.DEPMUNCOD INNER JOIN
					  ADINGRESO AS ING ON I.NUMINGRES = ING.NUMINGRES INNER JOIN
					  contract.HealthAdministrator AS ha ON ING.GENCONENTITY =ha.Id INNER JOIN
                      INUNIFUNC AS U ON U.UFUCODIGO = I.UFUCODIGO INNER JOIN
                      INCUPSIPS AS C ON C.CODSERIPS = I.CODSERIPS INNER JOIN
                      INCUPSSUB AS SG ON SG.CODGRUSUB = C.CODGRUSUB
--WHERE     (I.FECORDMED BETWEEN ? AND ?)

