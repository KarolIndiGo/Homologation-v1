-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CONSULTAEXTERNAACTIVIDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_CONSULTAEXTERNAACTIVIDADES]
AS
SELECT      distinct  
		 CASE Pa.IPTIPODOC WHEN '1' THEN 'CC' 
					WHEN '2' THEN 'CE' 
					WHEN '3' THEN 'TI' 
					WHEN '4' THEN 'RC' 
					WHEN '5' THEN 'PA'
					WHEN '6' THEN 'AS' 
					WHEN '7' THEN 'MS' 
					WHEN '8' THEN 'NU' 
					WHEN '9' THEN 'CN' 
					WHEN '10' THEN 'CD'
					WHEN '11' THEN 'SC' 
					WHEN '12' THEN 'PE'
					WHEN '13' THEN 'PT'
					WHEN '14' THEN 'DE'
					WHEN '15' THEN 'SI'
					END AS [Tipo Documento] 
	  ,C.IPCODPACI AS Identificación
	  ,C.IPNOMCOMP AS Nombre
	  ,Pa.IPDIRECCI AS Dirección
	  ,Pa.IPTELMOVI AS [Telefono Movil]
	  ,CASE Pa.CODGRUPOE WHEN '001' THEN 'INDIGENA'
						 WHEN '002' THEN 'GITANO'
						 WHEN '003' THEN 'RAIZAL'
						 WHEN '004' THEN 'PALENQUERO'
						 WHEN '005' THEN 'NEGRO MULATO AFRODECENDIENTE'
						 WHEN '006' THEN 'OTROS'
						 END AS [Grupo Etnico]  
	  ,AGACTIMED.DESACTMED AS Actividad
	  ,C.IPFECHACO AS FechaConsulta
	  ,CASE WHEN C.CONESTADO = '1' THEN 'Sin Atender' 
			WHEN C.CONESTADO = '2' THEN 'Ausente Anulada' 
			WHEN C.CONESTADO = '3' THEN 'Atendido' 
			END AS Estado,
      A.NOMENTIDA AS Entidad, 
      CASE WHEN C.CODTIPCON = '1' THEN 'Primera Vez' 
	  WHEN C.CODTIPCON = '2' THEN 'Control' 
	  WHEN C.CODTIPCON = '3' THEN 'PostOperatorio' 
	  END AS 'Tipo', 
      C.CODPROSAL AS CodMedico
	  , P.NOMMEDICO AS NombreMedico
	  , E2.DESESPECI AS Especialidad
	  , C.NUMINGRES AS Ingreso, 
      CASE WHEN Pa.IPSEXOPAC = 2 THEN 'Femenino'
	  WHEN Pa.IPSEXOPAC = 1 THEN 'Masculino' 
	  END AS Sexo
	  , Pa.IPFECNACI AS FechaNacimiento
	  , DATEDIFF(YY, 
      Pa.IPFECNACI, C.IPFECHACO) AS Edad, CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
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
      CASE WHEN IPTIPOPAC = '1' THEN 'Contributivo' 
	  WHEN IPTIPOPAC = '2' THEN 'Subsidiado' 
	  WHEN IPTIPOPAC = '3' THEN 'Vinculado' 
	  WHEN IPTIPOPAC = '4' THEN 'Particular'
       WHEN IPTIPOPAC = '5' THEN 'Otro' 
	   WHEN IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo' 
	   WHEN IPTIPOPAC = '7' THEN 'Desplazado reg Subsidiado' 
	   WHEN IPTIPOPAC = '8' THEN 'Desplazado no Asegurado' 
	   END AS TipoRegimen
	   , L.MUNNOMBRE AS MunicipioProcedencia
	   , I.CODDIAING AS CodCIE10Ingreso, 
      D.NOMDIAGNO AS DiagnosticoIngreso
	  , I.CODDIAEGR AS CodCIE10Egreso
	  , D2.NOMDIAGNO AS DiagnosticoEgreso
	  , '1' AS Cantidad, 
      HCANTGINE.CANTPRENA AS CantControles
	  , HCANTGINE.NOMSEMGES AS SemanasGes, 
      CASE WHEN HCURGING1.TIPATEPAC = '1' THEN 'Ginecologica' 
	  WHEN HCURGING1.TIPATEPAC = '2' THEN 'Obstetrica' 
	  END AS 'TipoAtencionPaciente'
FROM                      dbo.ADCONCOEX AS C INNER JOIN
                         dbo.INPACIENT AS Pa ON Pa.IPCODPACI = C.IPCODPACI INNER JOIN
                         dbo.ADINGRESO AS I ON I.NUMINGRES = C.NUMINGRES INNER JOIN
                         dbo.INPROFSAL AS P ON P.CODPROSAL = C.CODPROSAL INNER JOIN
                         dbo.INESPECIA AS E ON E.CODESPECI = P.CODESPEC1 INNER JOIN
                         dbo.INENTIDAD AS A ON A.CODENTIDA = C.CODENTIDA INNER JOIN
                         dbo.INUBICACI AS M ON M.AUUBICACI = Pa.AUUBICACI INNER JOIN
                         dbo.INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD INNER JOIN
                         dbo.AGASICITA ON C.IPCODPACI = AGASICITA.IPCODPACI AND C.IPFECHCIT = AGASICITA.FECHORAIN AND C.CODPROSAL = AGASICITA.CODPROSAL INNER JOIN
                         dbo.AGACTIMED ON AGASICITA.CODACTMED = AGACTIMED.CODACTMED LEFT OUTER JOIN
                         dbo.HCURGING1 ON Pa.IPCODPACI = HCURGING1.IPCODPACI AND I.NUMINGRES = HCURGING1.NUMINGRES LEFT OUTER JOIN
                         dbo.HCANTGINE ON Pa.IPCODPACI = HCANTGINE.IPCODPACI AND I.NUMINGRES = HCANTGINE.NUMINGRES LEFT OUTER JOIN
					     dbo.HCHISPACA ON Pa.IPCODPACI = HCHISPACA.IPCODPACI AND I.NUMINGRES = HCHISPACA.NUMINGRES  LEFT OUTER JOIN
						 dbo.INESPECIA AS E2 ON E2.CODESPECI = C.CODESPECI LEFT OUTER JOIN
                         dbo.INDIAGNOS AS D ON D.CODDIAGNO = I.CODDIAING LEFT OUTER JOIN
                         dbo.INDIAGNOS AS D2 ON D2.CODDIAGNO = I.CODDIAEGR 




