-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGralxProfesional_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_IndicadoresGralxProfesional_PB] AS

SELECT 'Laboratorio' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
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
            SUM(I.CANSERIPS) AS Cant, '' AS Red--, i.NUMEFOLIO
     FROM dbo.HCORDLABO I 
          JOIN dbo.ADCENATEN ca  WITH (NOLOCK) ON I.CODCENATE = CA.CODCENATE
		  JOIN dbo.INPROFSAL prof  WITH (NOLOCK) ON I.CODPROSAL = prof.CODPROSAL join
		  dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=prof.CODESPEC1
		  --(select H.CODPROSAL,ESP.DESESPECI, numefolio
		  --from dbo.HCHISPACA AS H 
		  --JOIN dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=H.CODESPTRA
		  --WHERE H.FECHISPAC >= '01-01-2023') as esp WITH (NOLOCK) ON esp.CODPROSAL=i.CODPROSAL and esp.NUMEFOLIO=i.NUMEFOLIO
		  WHERE I.FECORDMED >= '01-01-2023'
           AND I.ESTSERIPS <> '6' and i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999') --and i.CODPROSAL='1056798618'
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              YEAR(I.FECORDMED),
			  DESESPECI,
			  PROF.NOMMEDICO, prof.codprosal--, i.NUMEFOLIO
    
     UNION ALL

 SELECT 'ImagenesDx' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
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
            SUM(I.CANSERIPS) AS Cant, '' AS Red--, i.NUMEFOLIO
     FROM dbo.HCORDIMAG I 
          JOIN dbo.ADCENATEN ca  WITH (NOLOCK) ON I.CODCENATE = CA.CODCENATE
		  JOIN dbo.INPROFSAL prof  WITH (NOLOCK) ON I.CODPROSAL = prof.CODPROSAL JOIN
		   dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=prof.CODESPEC1
		  --(select H.CODPROSAL,ESP.DESESPECI, numefolio
		  --from dbo.HCHISPACA AS H 
		  --JOIN dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=H.CODESPTRA
		  --WHERE H.FECHISPAC >= '01-01-2023') as esp WITH (NOLOCK) ON esp.CODPROSAL=i.CODPROSAL and esp.NUMEFOLIO=i.NUMEFOLIO
     WHERE I.FECORDMED >= '01-01-2023'
           AND I.ESTSERIPS <> '6'and i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              YEAR(I.FECORDMED),
			  ESP.DESESPECI,
			  PROF.NOMMEDICO, prof.codprosal--, i.NUMEFOLIO
    
     
     UNION ALL

	  SELECT 'Interconsultas' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
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
            SUM(I.CANSERIPS) AS Cant,
			CASE WHEN I.CODESPECI IN ('099','101','142','085','184','113','203','002') THEN 'Red Interna' else 'Red Externa' end as Red--, i.NUMEFOLIO
     FROM dbo.HCORDINTE I 
          JOIN dbo.ADCENATEN ca  WITH (NOLOCK) ON I.CODCENATE = CA.CODCENATE
		  JOIN dbo.INPROFSAL prof  WITH (NOLOCK) ON I.CODPROSAL = prof.CODPROSAL
		  JOIN  dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=prof.CODESPEC1
		  --(select H.CODPROSAL,ESP.DESESPECI, numefolio
		  --from dbo.HCHISPACA AS H 
		  --JOIN dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=H.CODESPTRA
		  --WHERE H.FECHISPAC >= '01-01-2023') as esp WITH (NOLOCK) ON esp.CODPROSAL=i.CODPROSAL and esp.NUMEFOLIO=i.NUMEFOLIO
     WHERE I.FECORDMED >= '01-01-2023'
           AND I.ESTSERIPS <> '6' and i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              YEAR(I.FECORDMED),
			  ESP.DESESPECI,
			  PROF.NOMMEDICO, prof.codprosal, I.CODESPECI--, i.NUMEFOLIO
   
    UNION ALL
     SELECT 'Medicamentos' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
             CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(OM.FECINIDOS) AS Mes, 
            YEAR(OM.FECINIDOS) AS Año, 
            COUNT(OM.CODPRODUC) AS Cant, '' AS Red--,OM.NUMEFOLIO
     FROM dbo.HCPRESCRA OM 
          JOIN dbo.IHLISTPRO M  WITH (NOLOCK) ON OM.CODPRODUC = M.CODPRODUC
          JOIN dbo.ADCENATEN CA  WITH (NOLOCK) ON OM.CODCENATE = CA.CODCENATE
		  		  JOIN dbo.INPROFSAL prof  WITH (NOLOCK) ON OM.CODPROSAL = prof.CODPROSAL
		 JOIN  dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=prof.CODESPEC1
		  --(select H.CODPROSAL,ESP.DESESPECI, numefolio
		  --from dbo.HCHISPACA AS H 
		  --JOIN dbo.INESPECIA ESP  WITH (NOLOCK) ON ESP.CODESPECI=H.CODESPTRA
		  --WHERE H.FECHISPAC >= '01-01-2023') as esp WITH (NOLOCK) ON esp.CODPROSAL=OM.CODPROSAL and esp.NUMEFOLIO=OM.NUMEFOLIO
     WHERE M.TIPPRODUC = 1
           AND om.FECINIDOS >= '01-01-2023' and om.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY CA.NOMCENATE, 
              CA.CODCENATE, 
              MONTH(OM.FECINIDOS), 
              M.TIPPRODUC, 
              YEAR(OM.FECINIDOS),
			   ESP.DESESPECI,
			  PROF.NOMMEDICO, prof.codprosal--, OM.NUMEFOLIO;
