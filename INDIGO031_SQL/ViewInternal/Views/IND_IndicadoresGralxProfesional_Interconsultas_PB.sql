-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGralxProfesional_Interconsultas_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_IndicadoresGralxProfesional_Interconsultas_PB] as

	  SELECT 'Interconsultas' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion, ESPT.DESESPECI AS EspecialidadRemitida, 
			CASE WHEN ESPT.CODESPECI IN ('099','101','142','085','184','113','203','002','116','355') THEN 'Red Interna' else 'Red Externa' end as Red,
		 CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
            SUM(I.CANSERIPS) AS Cant
     FROM dbo.HCORDINTE I 
          JOIN dbo.ADCENATEN ca WITH (NOLOCK) ON I.CODCENATE = CA.CODCENATE
		  JOIN dbo.INPROFSAL prof WITH (NOLOCK) on I.CODPROSAL = prof.CODPROSAL
		  JOIN dbo.INESPECIA ESP WITH (NOLOCK) ON prof.CODESPEC1 = ESP.CODESPECI
		  JOIN dbo.INESPECIA ESPT WITH (NOLOCK) ON ESPT.CODESPECI=I.CODESPECI
     WHERE I.FECORDMED >= '01-01-2022'
           AND I.ESTSERIPS <> '6'   and  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999') AND i.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM DBO.HCFOLANUL)
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              YEAR(I.FECORDMED),
			  ESP.DESESPECI,
			  PROF.NOMMEDICO, prof.codprosal, ESPT.DESESPECI, ESPT.CODESPECI
