-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_MORTALIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_MORTALIDAD]
AS
SELECT        H.NUMINGRES AS Ingreso, 
                         CASE WHEN IPTIPOPAC = '1' THEN 'Contributivo' WHEN IPTIPOPAC = '2' THEN 'Subsidiado' WHEN IPTIPOPAC = '3' THEN 'Vinculado' WHEN IPTIPOPAC = '4' THEN 'Particular' WHEN IPTIPOPAC = '5' THEN 'Otro' WHEN
                          IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo' WHEN IPTIPOPAC = '7' THEN 'Desplazado reg Subsidiado' WHEN IPTIPOPAC = '8' THEN 'Desplazado no Asegurado' END AS TipoRegimen, 
                         H.IPCODPACI AS Identificacion, P.IPNOMCOMP AS Nombre, CASE WHEN P.IPSEXOPAC = 2 THEN 'Femenino' WHEN P.IPSEXOPAC = 1 THEN 'Masculino' END AS Sexo, G.DESGRUPET AS PertenenciaEtnica, 
                         P.IPFECNACI AS FechaNacimiento, DATEDIFF(YY, P.IPFECNACI, GETDATE()) AS Edad, S.NOMENTIDA AS Entidad, L.MUNNOMBRE AS MunicipioProcedencia, I.IFECHAING AS FechaIngresoInstitucion, 
                         E.FECMUEPAC AS FechaDeFallecimiento, C.DESCAUMUE AS CausaDeMuerte, E.NUMCERDEF AS NroCertificado, U.UFUDESCRI AS UnidadFallecio, PR.NOMMEDICO AS MedicoEgreso, 
                         I.CODDIAEGR AS CodCIE10Egreso, D2.NOMDIAGNO AS DiagnosticoEgreso, CASE WHEN DATEDIFF(HH, I.IFECHAING, E.FECMUEPAC) >= '48' THEN 'Mayor a 48' WHEN DATEDIFF(HH, I.IFECHAING, 
                         E.FECMUEPAC) < '48' THEN 'Menor a 48' END AS TasaMortalidad, '1' AS Canitidad
FROM            HCHISPACA AS H INNER JOIN
                         INPACIENT AS P ON P.IPCODPACI = H.IPCODPACI INNER JOIN
                         ADINGRESO AS I ON I.NUMINGRES = H.NUMINGRES INNER JOIN
                         INENTIDAD AS S ON S.CODENTIDA = I.CODENTIDA INNER JOIN
                         INUBICACI AS M ON M.AUUBICACI = P.AUUBICACI INNER JOIN
                         INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD INNER JOIN
                         HCREGEGRE AS E ON E.NUMINGRES = H.NUMINGRES AND E.IPCODPACI = H.IPCODPACI INNER JOIN
                         INUNIFUNC AS U ON U.UFUCODIGO = H.UFUCODIGO INNER JOIN
                         INPROFSAL AS PR ON PR.CODPROSAL = H.CODPROSAL INNER JOIN
                         INDIAGNOS AS D2 ON D2.CODDIAGNO = I.CODDIAEGR LEFT OUTER JOIN
                         INCAUMUER AS C ON C.CODCAUMUE = E.CODCAUMUE LEFT OUTER JOIN
                         ADGRUETNI AS G ON G.CODGRUPOE = P.CODGRUPOE
WHERE   (H.INDICAPAC = '11') 

