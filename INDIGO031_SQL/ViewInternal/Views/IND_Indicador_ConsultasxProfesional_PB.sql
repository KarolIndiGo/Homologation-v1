-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Indicador_ConsultasxProfesional_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_Indicador_ConsultasxProfesional_PB]
AS
	 SELECT CA.NOMCENATE AS Sede,
            CASE
                     WHEN Ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN Ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN Ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,prof.codprosal, PROF.NOMMEDICO AS Profesional, E.DESESPECI AS Especialidad,
            'Consultas' AS Tipo, 
            MONTH(H.FECHISPAC) AS Mes, 
            YEAR(H.FECHISPAC) AS Año, 
            COUNT(H.NUMINGRES) AS Cant
     FROM dbo.HCHISPACA AS H 
          INNER JOIN dbo.ADCENATEN AS CA  ON H.CODCENATE = CA.CODCENATE
		  JOIN dbo.INPROFSAL prof   on h.CODPROSAL = prof.CODPROSAL
		  JOIN dbo.INESPECIA E   on prof.CODESPEC1 = E.CODESPECI
     WHERE(H.TIPHISPAC = 'I')
          AND H.FECHISPAC >= '01-01-2022'  and h.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY CA.CODCENATE, 
              CA.NOMCENATE, 
              MONTH(H.FECHISPAC), 
              YEAR(H.FECHISPAC), 
			  prof.nommedico,
			  e.desespeci,
			  prof.codprosal;
