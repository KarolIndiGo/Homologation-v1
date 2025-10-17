-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Ruta_MaternoPerinatal_Denominador
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[Ruta_MaternoPerinatal_Denominador] AS
 
	 SELECT   
            i.NUMINGRES AS Ingreso, 
            ga.Code AS [Grupo Atención Ingreso], 
            ga.Name AS [Grupo Atención], 
            ea.Name AS Entidad, 
            i.IPCODPACI AS [Identificación Paciente], 
			CASE p.IPTIPODOC 
				WHEN 1 THEN 'CC' 
				WHEN 2 THEN 'CE' 
				WHEN 3 THEN 'TI' 
				WHEN 4 THEN 'RC' 
				WHEN 5 THEN 'PA' 
				WHEN 6 THEN 'AS' 
				WHEN 7 THEN 'MS' 
				WHEN 8 THEN 'NU' 
				WHEN 9 THEN 'CN' 
				WHEN 10 THEN 'CD' 
				WHEN 11 THEN 'SC' 
				WHEN 12 THEN 'PE' 
			END AS TIPODOCUMENTO,
			CASE p.IPSEXOPAC 
				WHEN 1 THEN 'H' 
				WHEN 2 THEN 'M' 
			END AS SEXO,
			p.IPPRINOMB AS [PRIMER NOMBRE],
			P.IPSEGNOMB AS [SEGUNDO NOMBRE],
			P.IPPRIAPEL AS [PRIMER APELLIDO],
			P.IPSEGAPEL AS [SEGUNDO APELLIDO],
            --CONVERT(varchar,p.IPFECNACI,21) AS FechaNacimiento,
			p.IPFECNACI AS FechaNacimiento,
            DATEDIFF(year, p.IPFECNACI, i.IFECHAING) AS EdadEnAtencion, 
            M.MUNNOMBRE AS Municipio, 
            DP.nomdepart AS Dpto, 
            CAST(p.GENEXPEDITIONCITY AS VARCHAR(20)) + ' - ' + ISNULL(ci.Name, '') AS [Lugar expedición Vie], 
            i.IFECHAING AS Fecha_Ingreso, 
            i.IESTADOIN AS EstadoIngreso, 
            uf.UFUDESCRI AS Unidad_Funcional, 
            HCU.ENFACTUAL AS Enfermedad_Actual, 
            em.FECALTPAC AS [Fecha alta Médica], 
            HC.CODDIAGNO AS CIE_10, 
            CIE10.NOMDIAGNO AS Diagnóstico, 
            PROF.NOMMEDICO AS Medico, 
            ESP.DESESPECI AS Especialidad, 
            i.IOBSERVAC AS Observaciones,
            CASE i.TIPOINGRE
                WHEN 1
                THEN 'Ambulatorio'
                WHEN 2
                THEN 'Hospitalario'
            END AS TipoIngreso, 
            1 AS Cantidad, 
            EXF.TALLAPACI AS [Talla (cm)], 
            CONVERT(INT, ROUND(EXF.PESOPACIE / 1000, 0), 0) AS [Peso (kg)], 
            CONVERT(VARCHAR, EXF.TENARTSIS, 100) + '/' + CONVERT(VARCHAR, EXF.TENARTDIA, 100) AS TA, 
            EXF.NEOPERCEF AS PC, 
            EXF.NEOPERABD AS PA, 
            MHC.DESCRIPCION AS Modelo,
         CASE
                 WHEN I.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN I.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN I.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
			CE.NOMCENATE AS CENTRO,
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS Telefono, 
            P.IPTELMOVI AS Celular, 
            EXF.NEOPERCEF AS 'Solo para Neonatos - Perimetro Cefalico', 
            EXF.NEOPERTOR AS 'Solo para Neonatos - Perimetro Toraxico', 
            EXF.NEOPERABD AS 'Solo para Neonatos - Perimetro Abdominal', 
            EXF.TEMPERPAC AS 'Temperatura', 
            EXF.FRECARPAC AS 'Frecuencia Cardiaca', 
            EXF.FRERESPAC AS 'Frecuencia Respiratoria', 
            EXF.REGSO2PAC AS 'Saturacion de Oxigeno', 
            EXF.PB AS 'perímetro braquial', 
            EXF.DOLOR, --DOLOR (0-1-2-3-4-5-6-7-8-9-10)
            EXF.INTERPESOPARATALLA AS 'Interpretacion de la grafica peso para la talla', 
            EXF.INTERINDICEMASACO AS 'interpretacion de la grafica indice masa corporal', 
            EXF.INTERPESOPARAEDAD AS 'interpretacion de la grafica peso para la edad', 
            EXF.INTERPERIMETROCEFA AS 'interpretacion de la grafica perimetro cefalico', 
            EXF.INTERTALLAPARAEDAD AS 'interpretacion de la grafica talla para la edad', 
            EXF.INTERALTURAUTERINA AS 'interpretacion de la grafica altura uterina', 
            EXF.INTERIMCPARALAEDAD AS 'interpretacion de la grafica IMC para la edad', 
            ANTG.NOMSEMGES AS SEMANAS_GESTACIONALES, 
            DXS.DIAGNOSTICOS, 
            DXS.NOMBRE_DIAGNOSTICOS, us.UserCode+'-'+ pus.Fullname UsuarioCrea, usm.UserCode +'-'+ pusm.Fullname UsuarioModifica
		,
		--pg.nombre as 'Riesgo del programa'
		'' as 'Riesgo del programa',
		DATEDIFF(DAY, p.IPFECNACI, i.IFECHAING) AS EdadEnAtencionDias
     FROM dbo.ADINGRESO AS i  WITH (NOLOCK)
	 INNER JOIN DBO.ADCENATEN AS CE WITH (NOLOCK) ON CE.CODCENATE=I.CODCENATE
          INNER JOIN dbo.INUNIFUNC AS uf WITH (NOLOCK) ON uf.UFUCODIGO = i.UFUCODIGO
          INNER JOIN Contract.CareGroup AS ga WITH (NOLOCK) ON ga.Id = i.GENCAREGROUP
          INNER JOIN dbo.INPACIENT AS p WITH (NOLOCK) ON p.IPCODPACI = i.IPCODPACI
          LEFT OUTER JOIN Contract.HealthAdministrator AS ea WITH (NOLOCK) ON ea.Id = i.GENCONENTITY
          LEFT OUTER JOIN Common.City AS ci WITH (NOLOCK) ON ci.Id = p.GENEXPEDITIONCITY
          LEFT OUTER JOIN Security.[User] as us  on us.UserCode=i.CODUSUCRE
		  LEFT OUTER JOIN Security.[Person] as pus  on pus.Id=us.IdPerson
		  LEFT OUTER JOIN Security.[User] as usm  on usm.UserCode=i.CODUSUMOD
		  LEFT OUTER JOIN Security.[Person] as pusm  on pusm.Id=usm.IdPerson
		  --LEFT OUTER JOIN dbo.SEGusuaru AS uu  ON uu.CODUSUARI = i.CODUSUMOD select * from dbo.HCHISPACA
          LEFT OUTER JOIN dbo.HCHISPACA AS HC WITH (NOLOCK) ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i'
		  --left outer join ViewInternal.HC_VariableRiesgoPrograma as pg on pg.IDHCHISPACA=hc.ID
          LEFT OUTER JOIN dbo.HCURGING1 AS HCU WITH (NOLOCK) ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO
          LEFT OUTER JOIN
     (SELECT IPCODPACI, NUMINGRES, MAX(NUMEFOLIO) AS Folio
         FROM dbo.INDIAGNOP  WITH (NOLOCK)
         WHERE(CODDIAPRI = 'True')
         GROUP BY NUMINGRES, IPCODPACI
     ) AS DX ON DX.IPCODPACI = HCU.IPCODPACI
                AND DX.NUMINGRES = HCU.NUMINGRES
                AND DX.Folio = HC.NUMEFOLIO
          LEFT OUTER JOIN dbo.INDIAGNOS AS CIE10 WITH (NOLOCK)  ON CIE10.CODDIAGNO = HC.CODDIAGNO
          LEFT OUTER JOIN dbo.HCURGEVO1 AS HCU1 WITH (NOLOCK) ON HCU.NUMINGRES = HC.NUMINGRES
                                                                                  AND HCU1.IPCODPACI = HC.IPCODPACI
                                                                                  AND HCU1.NUMEFOLIO = HC.NUMEFOLIO
          --LEFT OUTER JOIN dbo.ADINGRESO AS I2  ON I2.NUMINGRES = i.NUMINGRES
          --LEFT OUTER JOIN dbo.INUNIFUNC AS D  ON I2.UFUAACTHOS = D.UFUCODIGO
          LEFT OUTER JOIN dbo.HCREGEGRE AS em WITH (NOLOCK) ON em.IPCODPACI = HC.IPCODPACI
                                                                                AND em.NUMINGRES = HC.NUMINGRES
          --LEFT OUTER JOIN dbo.SEGusuaru AS u  ON u.CODUSUARI = i.CODUSUCRE
          INNER JOIN dbo.INUBICACI AS UB WITH (NOLOCK) ON p.AUUBICACI = UB.AUUBICACI
          INNER JOIN dbo.INMUNICIP AS M WITH (NOLOCK) ON UB.DEPMUNCOD = M.DEPMUNCOD
          INNER JOIN dbo.INDEPARTA AS DP WITH (NOLOCK) ON M.DEPCODIGO = DP.depcodigo
          INNER JOIN dbo.INPROFSAL AS PROF WITH (NOLOCK) ON HC.CODPROSAL = PROF.CODPROSAL
          INNER JOIN dbo.INESPECIA AS ESP WITH (NOLOCK) ON HC.CODESPTRA = ESP.CODESPECI --PROF.CODESPEC1 = ESP.CODESPECI
          LEFT JOIN dbo.HCEXFISIC AS EXF WITH (NOLOCK) ON i.IPCODPACI = EXF.IPCODPACI
                                                                           AND i.NUMINGRES = EXF.NUMINGRES
          LEFT OUTER JOIN dbo.PRMODELOHC AS MHC WITH (NOLOCK) ON HC.IDMODELOHC = MHC.ID
          LEFT OUTER JOIN dbo.HCANTGINE AS ANTG WITH (NOLOCK) ON ANTG.NUMINGRES = HC.NUMINGRES
                                                                                  AND ANTG.NUMEFOLIO = HC.NUMEFOLIO
          INNER JOIN (  
			SELECT t2.NUMEFOLIO, t2.NUMINGRES, t2.IPCODPACI, 
					DIAGNOSTICOS = STUFF(
							 (
								 SELECT ', ' + CODDIAGNO
								 FROM dbo.INDIAGNOP t1 
								 WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')
							 ), 1, 1, ''), 
					NOMBRE_DIAGNOSTICOS = STUFF(
							 (
								 SELECT ', ' + LTRIM(RTRIM(NOMDIAGNO))
								 FROM dbo.INDIAGNOP AS T1 
									  INNER JOIN dbo.INDIAGNOS AS B  ON B.CODDIAGNO = T1.CODDIAGNO
								 WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')
							 ), 1, 1, '')

			FROM dbo.INDIAGNOP t2 
			WHERE --t2.FECDIAGNO >= DATEADD(MONTH, -6, GETDATE())
				  year(t2.FECDIAGNO) >= '2025'
			GROUP BY t2.NUMEFOLIO, t2.NUMINGRES, t2.IPCODPACI ) AS DXS ON DXS.NUMINGRES = HC.NUMINGRES AND DXS.NUMEFOLIO = HC.NUMEFOLIO
     WHERE --i.IFECHAING>='01-01-2022'
	 --i.IFECHAING >= DATEADD(MONTH, -3, GETDATE())
	 year(i.IFECHAING) >= '2025'  and HC.CODDIAGNO in ('Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z762','Z321',
'Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z762')
	 --AND  em.FECALTPAC >='01-11-2024 00:00:00'
	 --AND PROF.NOMMEDICO LIKE '%BUSTAMANTE%'
	-- and  ESP.DESESPECI  like '%gineco%'

