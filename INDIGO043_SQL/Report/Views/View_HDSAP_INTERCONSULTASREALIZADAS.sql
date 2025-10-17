-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INTERCONSULTASREALIZADAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_INTERCONSULTASREALIZADAS]
AS

SELECT     H.NUMINGRES AS Ingreso, 
                         CASE WHEN IPTIPOPAC = '1' THEN 'Contributivo' WHEN IPTIPOPAC = '2' THEN 'Subsidiado' WHEN IPTIPOPAC = '3' THEN 'Vinculado' WHEN IPTIPOPAC = '4' THEN 'Particular'
                          WHEN IPTIPOPAC = '5' THEN 'Otro' WHEN IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo' WHEN IPTIPOPAC = '7' THEN 'Desplazado reg Subsidiado' WHEN IPTIPOPAC
                          = '8' THEN 'Desplazado no Asegurado' END AS TipoRegimen,CASE WHEN P.IPSEXOPAC = 2 THEN 'Femenino' WHEN P.IPSEXOPAC = 1 THEN 'Masculino' END AS Sexo,
						  DATEDIFF(YY, 
                         P.IPFECNACI, GETDATE()) AS Edades, CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
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
						   CASE P.IPTIPODOC
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
                         (datediff (year,p.IPFECNACI, getdate ())) EDAD, 
                         I.IFECHAING AS FechaIngresoInstitucion, S.NOMENTIDA AS Entidad, L.MUNNOMBRE AS MunicipioProcedencia, U.UFUDESCRI AS UnidadDeEgreso, 
                         H.FECHISPAC AS FechaEgreso, PR.NOMMEDICO AS NombreMedico, EM.DESESPECI AS EspecialidadEgreso, I.CODDIAING AS CodCIE10Ingreso, 
                         D.NOMDIAGNO AS DiagnosticoIngreso, I.CODDIAEGR AS CodCIE10Egreso, D2.NOMDIAGNO AS DiagnosticoEgreso, T3.Fecha AS FechaIngresoHospitalizacion, 
                         T1.Fecha AS FechaEgresohospitalizacion,IM.FECORDMED as FechaSolicInterconsl, V.FechaInt AS FechaInterConsulta,DATEDIFF(MINUTE,IM.FECORDMED,V.FechaInt) as TiempoRespuestaInterconsultaEnMinutos, EM2.DESESPECI AS EspecialidadInterconsultante, 
                         PR2.NOMMEDICO AS MedicoInterconsultante, '1' AS Cantidad
FROM            dbo.HCHISPACA AS H INNER JOIN
                             (SELECT        IPCODPACI, NUMINGRES, MAX(FECHISPAC) AS fechaMa
                               FROM            HCHISPACA
                               WHERE        (INDICAPAC IN ('10', '11', '12'))
                               GROUP BY IPCODPACI, NUMINGRES) AS N1 ON N1.IPCODPACI = H.IPCODPACI AND N1.NUMINGRES = H.NUMINGRES AND 
                         N1.fechaMa = H.FECHISPAC INNER JOIN
                         dbo.ADINGRESO AS I ON I.NUMINGRES = H.NUMINGRES AND I.IPCODPACI = H.IPCODPACI INNER JOIN
                         dbo.INPACIENT AS P ON P.IPCODPACI = H.IPCODPACI INNER JOIN
                         dbo.INENTIDAD AS S ON S.CODENTIDA = I.CODENTIDA INNER JOIN
                         dbo.INUBICACI AS M ON M.AUUBICACI = P.AUUBICACI INNER JOIN
                         dbo.INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD INNER JOIN
                         dbo.INUNIFUNC AS U ON U.UFUCODIGO = H.UFUCODIGO INNER JOIN
                         dbo.INPROFSAL AS PR ON PR.CODPROSAL = H.CODPROSAL INNER JOIN
                         dbo.INESPECIA AS EM ON EM.CODESPECI = PR.CODESPEC1 AND PR.CODPROSAL = H.CODPROSAL LEFT OUTER JOIN
                         dbo.CHREGEGRE AS HE ON HE.IPCODPACI = H.IPCODPACI AND HE.NUMINGRES = H.NUMINGRES LEFT OUTER JOIN
                             (SELECT        IPCODPACI, NUMINGRES, MIN(FECINIEST) AS Fecha
                               FROM            CHREGESTA AS t
                               GROUP BY IPCODPACI, NUMINGRES) AS T3 ON T3.NUMINGRES = HE.NUMINGRES AND T3.IPCODPACI = HE.IPCODPACI LEFT OUTER JOIN
                         dbo.HCREGEGRE AS E ON E.NUMINGRES = HE.NUMINGRES AND E.IPCODPACI = HE.IPCODPACI LEFT OUTER JOIN
                         dbo.INDIAGNOS AS D ON D.CODDIAGNO = I.CODDIAING LEFT OUTER JOIN
                         dbo.INDIAGNOS AS D2 ON D2.CODDIAGNO = I.CODDIAEGR LEFT OUTER JOIN
                             (SELECT        IPCODPACI, NUMINGRES, MAX(FECFINEST) AS Fecha
                               FROM            dbo.CHREGESTA AS t
                               GROUP BY IPCODPACI, NUMINGRES) AS T1 ON T1.NUMINGRES = HE.NUMINGRES AND T1.IPCODPACI = HE.IPCODPACI LEFT OUTER JOIN
                         dbo.CHREGESTA AS t2 ON t2.NUMINGRES = T1.NUMINGRES AND t2.FECFINEST = T1.Fecha LEFT OUTER JOIN
                         dbo.HCORDINTE AS IM ON IM.IPCODPACI = H.IPCODPACI AND IM.NUMINGRES = H.NUMINGRES LEFT OUTER JOIN
                             (SELECT        IDETIPHIS, IPCODPACI, NUMINGRES, CAST(FECHISPAC AS datetime) AS FechaInt, NUMEFOLIO
                               FROM            dbo.HCHISPACA AS PA) AS V ON V.NUMINGRES = IM.NUMINGRES AND V.IPCODPACI = IM.IPCODPACI AND 
                         V.NUMEFOLIO = IM.NUMFOLINT LEFT OUTER JOIN
                         dbo.INESPECIA AS EM2 ON EM2.CODESPECI = IM.CODESPECI LEFT OUTER JOIN
                         dbo.INPROFSAL AS PR2 ON PR2.CODPROSAL = IM.CODPROINT
					
WHERE        (H.INDICAPAC IN ('10', '11', '12')) AND (IM.ESTSERIPS = '3') 
  

