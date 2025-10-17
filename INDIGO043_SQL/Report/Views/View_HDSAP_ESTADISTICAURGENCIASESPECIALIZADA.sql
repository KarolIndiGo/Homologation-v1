-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ESTADISTICAURGENCIASESPECIALIZADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_ESTADISTICAURGENCIASESPECIALIZADA]
AS
SELECT   
CASE p.IPTIPODOC
                             WHEN '1'
                             THEN 'CC'
                             WHEN '2'
                             THEN 'CE '
                             WHEN '3'
                             THEN 'TI'
                             WHEN '4'
                             THEN 'RC'
                             WHEN '5'
                             THEN 'PA'
                             WHEN '6'
                             THEN 'AS'
                             WHEN '7'
                             THEN 'MS'
                             WHEN '8'
                             THEN 'NU'
							 WHEN '9'
                             THEN 'CN'
                             WHEN '11'
                             THEN 'SC'
                             WHEN '12'
                             THEN 'PE'
							 WHEN '13'
                             THEN 'PT'
                             WHEN '14'
                             THEN 'DE'
							  WHEN '15'
                             THEN 'SI'
                         END AS 'Tipo Documento',     
H.IPCODPACI AS Identificacion, 
P.IPNOMCOMP AS Nombre, 
H.NUMINGRES AS Ingreso, 
T.TRIAFECHA AS FechaTriage, 
T.TRIAFECHA AS HoraTriage, 
T.TRIAGEDAD AS Edad, 
                         T.TRIAGECLA AS Triage, U.UFUDESCRI AS Unidad, M.NOMMEDICO AS Medico, H.FECHISPAC AS FechaHistoria, E1.DESESPECI AS EspecialidadIngreso, 
                         E.DESESPECI AS EspecialidadMedico, C.NOMENTIDA AS Entidad, TR.TRIANOMCA AS DxSindromatico, H.CODDIAGNO AS CodigoDiagnostico, 
                         D.NOMDIAGNO AS NombreDiagnostico, G.IESTADOIN AS Estado, CASE WHEN P.IPSEXOPAC = 2 THEN 'Femenino' WHEN P.IPSEXOPAC = 1 THEN 'Masculino' END AS Sexo,
						  P.IPFECNACI AS FechaNacimiento,
						 DATEDIFF(YY, 
                         P.IPFECNACI, GETDATE()) AS Expr1, CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
                         (datediff(YY, IPFECNACI, getdate())) <= 4) THEN 'Entre 1 y 4' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 5 AND (datediff(YY, IPFECNACI, getdate())) <= 14) 
                         THEN 'Entre 5 y 14' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 15 AND (datediff(YY, IPFECNACI, getdate())) <= 44) THEN 'Entre 15 y 44' WHEN ((datediff(YY, 
                         IPFECNACI, getdate())) >= 45 AND (datediff(YY, IPFECNACI, getdate())) <= 59) THEN 'Entre 45 y 59' WHEN (datediff(YY, IPFECNACI, getdate())) 
                         >= 60 THEN 'Mayores de 60' END AS GrupoEtario1, CASE WHEN ((datediff(YY, IPFECNACI, getdate())) < 1) THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, 
                         getdate())) >= 1 AND (datediff(YY, IPFECNACI, getdate())) <= 4) THEN 'Entre 1 y 4' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 5 AND (datediff(YY, IPFECNACI, 
                         getdate())) <= 9) THEN 'Entre 5 y 9' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 10 AND (datediff(YY, IPFECNACI, getdate())) <= 14) 
                         THEN 'Entre 10 y 14' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 15 AND (datediff(YY, IPFECNACI, getdate())) <= 19) THEN 'Entre 15 y 19' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 20 AND (datediff(YY, IPFECNACI, getdate())) <= 24 THEN 'Entre 20 y 24' WHEN (datediff(YY, IPFECNACI, getdate())) >= 25 AND (datediff(YY, 
                         IPFECNACI, getdate())) <= 29 THEN 'Entre 25 y 29' WHEN (datediff(YY, IPFECNACI, getdate())) >= 30 AND (datediff(YY, IPFECNACI, getdate())) 
                         <= 34 THEN 'Entre 30 y 34' WHEN (datediff(YY, IPFECNACI, getdate())) >= 35 AND (datediff(YY, IPFECNACI, getdate())) <= 39 THEN 'Entre 35 y 39' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 40 AND (datediff(YY, IPFECNACI, getdate())) <= 44 THEN 'Entre 40 y 44' WHEN (datediff(YY, IPFECNACI, getdate())) >= 45 AND (datediff(YY, 
                         IPFECNACI, getdate())) <= 49 THEN 'Entre 45 y 49' WHEN (datediff(YY, IPFECNACI, getdate())) >= 50 AND (datediff(YY, IPFECNACI, getdate())) 
                         <= 54 THEN 'Entre 50 y 54' WHEN (datediff(YY, IPFECNACI, getdate())) >= 55 AND (datediff(YY, IPFECNACI, getdate())) <= 59 THEN 'Entre 55 y 59' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 60 AND (datediff(YY, IPFECNACI, getdate())) <= 64 THEN 'Entre 60 y 64' WHEN (datediff(YY, IPFECNACI, getdate())) >= 65 AND (datediff(YY, 
                         IPFECNACI, getdate())) <= 69 THEN 'Entre 65 y 69' WHEN (datediff(YY, IPFECNACI, getdate())) >= 70 AND (datediff(YY, IPFECNACI, getdate())) 
                         <= 74 THEN 'Entre 70 y 74' WHEN (datediff(YY, IPFECNACI, getdate())) >= 75 AND (datediff(YY, IPFECNACI, getdate())) <= 79 THEN 'Entre 75 y 79' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 80 THEN '80 y mas' END AS GrupoEtario2,                         
                         CASE WHEN IPTIPOPAC = '1' THEN 'Contributivo' WHEN IPTIPOPAC = '2' THEN 'Subsidiado' WHEN IPTIPOPAC = '3' THEN 'Vinculado' WHEN IPTIPOPAC = '4' THEN 'Particular'
                          WHEN IPTIPOPAC = '5' THEN 'Otro' WHEN IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo' WHEN IPTIPOPAC = '7' THEN 'Desplazado reg Subsidiado' WHEN IPTIPOPAC
                          = '8' THEN 'Desplazado no Asegurado' END AS TipoRegimen, '1' AS Cantidad, INMUNICIP.MUNNOMBRE AS [Remitido_de:], 
                         CASE WHEN T .TRIUNIEDA = 1 THEN 'Años' WHEN T .TRIUNIEDA = 2 THEN 'Meses' WHEN T .TRIUNIEDA = 3 THEN 'Días' END AS UnidadEdad, 
                         CASE WHEN TRIACAUIN = '1' THEN 'Heridos en combate' WHEN TRIACAUIN = '2' THEN 'Enfermedad profesional ' WHEN TRIACAUIN = '3' THEN 'Enfermedad general adulto '
                          WHEN TRIACAUIN = '4' THEN 'Enfermedad general pediatria ' WHEN TRIACAUIN = '5' THEN 'Odontología' WHEN TRIACAUIN = '6' THEN 'Accidente de transito' WHEN
                          TRIACAUIN = '7' THEN 'Catastrofe/Fisalud' WHEN TRIACAUIN = '8' THEN 'Quemados' WHEN TRIACAUIN = '9' THEN 'Maternidad' END AS CausaIngreso_Triage, 
                         INUBICACI.DEPMUNCOD AS MunicipioRes, INUBICACI.UBINOMBRE AS [Barrio/vereda], P.IPDIRECCI AS Direccion,adg.DESGRUPET as 'grupo étnico'

FROM            INPROFSAL AS M RIGHT OUTER JOIN
                             (SELECT        NUMINGRES, IESTADOIN, IPCODPACI, CODESPTRA, CODDIAING, CODDIAEGR, DEPMUNCOD
                               FROM     .ADINGRESO) AS G INNER JOIN
                         INMUNICIP ON G.DEPMUNCOD = INMUNICIP.DEPMUNCOD RIGHT OUTER JOIN
                         HCHISPACA AS H LEFT OUTER JOIN
                         ADTRIAGEU AS T ON H.IPCODPACI = T.IPCODPACI AND H.NUMINGRES = T.NUMINGRES INNER JOIN
                         INPACIENT AS P ON P.IPCODPACI = H.IPCODPACI LEFT OUTER JOIN
                         INUBICACI ON P.AUUBICACI = INUBICACI.AUUBICACI ON G.NUMINGRES = H.NUMINGRES AND G.IPCODPACI = H.IPCODPACI LEFT OUTER JOIN
                         INUNIFUNC AS U ON U.UFUCODIGO = H.UFUCODIGO ON M.CODPROSAL = H.CODPROSAL LEFT OUTER JOIN
                         INESPECIA AS E ON E.CODESPECI = M.CODESPEC1 LEFT OUTER JOIN
                         INESPECIA AS E1 ON E1.CODESPECI = G.CODESPTRA LEFT JOIN
                          ADINGRESO AS AD ON H.NUMINGRES=AD.NUMINGRES LEFT JOIN
                         INENTIDAD AS C ON C.CODENTIDA = AD.CODENTIDA LEFT OUTER JOIN
                         ADCATTRIU AS TR ON TR.TRIACATEG = T.TRIACATEG LEFT OUTER JOIN
                         INDIAGNOS AS D ON D.CODDIAGNO = H.CODDIAGNO left join
ADGRUETNI as adg on adg.CODGRUPOE=P.CODGRUPOE
WHERE        (H.TIPHISPAC = 'I') AND (H.IDETIPHIS = 'HCURGING1')
  

