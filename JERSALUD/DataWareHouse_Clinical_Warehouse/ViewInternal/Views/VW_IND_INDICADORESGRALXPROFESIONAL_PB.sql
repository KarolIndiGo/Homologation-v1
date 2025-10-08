-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INDICADORESGRALXPROFESIONAL_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_INDICADORESGRALXPROFESIONAL_PB 
AS

SELECT 'Laboratorio' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.CODPROSAL, prof.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
           CASE
                WHEN ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
            SUM(I.CANSERIPS) AS Cant, '' AS Red--, I.Numefolio
     FROM [INDIGO031].[dbo].[HCORDLABO] I 
          JOIN [INDIGO031].[dbo].[ADCENATEN] ca   ON I.CODCENATE = ca.CODCENATE
		  JOIN [INDIGO031].[dbo].[INPROFSAL] prof  ON I.CODPROSAL = prof.CODPROSAL 
          join [INDIGO031].[dbo].[INESPECIA] ESP   ON ESP.CODESPECI=prof.CODESPEC1
		  WHERE I.FECORDMED >= '01-01-2023'
           AND I.ESTSERIPS <> '6' and I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999') --and I.CODPROSAL='1056798618'
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE,
              ca.CODCENATE,
              YEAR(I.FECORDMED),
			  DESESPECI,
			  prof.NOMMEDICO, prof.CODPROSAL--, I.Numefolio
    
     UNION ALL

 SELECT 'ImagenesDx' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.CODPROSAL, prof.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
             CASE
                 WHEN ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
            SUM(I.CANSERIPS) AS Cant, '' AS Red--, I.Numefolio
     FROM [INDIGO031].[dbo].[HCORDIMAG] I 
          JOIN [INDIGO031].[dbo].[ADCENATEN] ca   ON I.CODCENATE = ca.CODCENATE
		  JOIN [INDIGO031].[dbo].[INPROFSAL] prof   ON I.CODPROSAL = prof.CODPROSAL 
          JOIN [INDIGO031].[dbo].[INESPECIA] ESP   ON ESP.CODESPECI=prof.CODESPEC1
     WHERE I.FECORDMED >= '01-01-2023'
           AND I.ESTSERIPS <> '6'and I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.CODCENATE, 
              YEAR(I.FECORDMED),
			  ESP.DESESPECI,
			  prof.NOMMEDICO, prof.CODPROSAL--, I.Numefolio
    
     
     UNION ALL

	  SELECT 'Interconsultas' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.CODPROSAL, prof.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                 WHEN ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
            SUM(I.CANSERIPS) AS Cant,
			CASE WHEN I.CODESPECI IN ('099','101','142','085','184','113','203','002') THEN 'Red Interna' else 'Red Externa' end as Red--, I.Numefolio
     FROM [INDIGO031].[dbo].[HCORDINTE] I 
          JOIN [INDIGO031].[dbo].[ADCENATEN] ca   ON I.CODCENATE = ca.CODCENATE
		  JOIN [INDIGO031].[dbo].[INPROFSAL] prof   ON I.CODPROSAL = prof.CODPROSAL
		  JOIN [INDIGO031].[dbo].[INESPECIA] ESP   ON ESP.CODESPECI=prof.CODESPEC1
     WHERE I.FECORDMED >= '01-01-2023'
           AND I.ESTSERIPS <> '6' and I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.CODCENATE, 
              YEAR(I.FECORDMED),
			  ESP.DESESPECI,
			  prof.NOMMEDICO, prof.CODPROSAL, I.CODESPECI--, I.Numefolio
   
    UNION ALL
     SELECT 'Medicamentos' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.CODPROSAL, prof.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
             CASE
                 WHEN ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(OM.FECINIDOS) AS Mes, 
            YEAR(OM.FECINIDOS) AS Año, 
            COUNT(OM.CODPRODUC) AS Cant, '' AS Red--,OM.Numefolio
     FROM [INDIGO031].[dbo].[HCPRESCRA] OM 
        JOIN [INDIGO031].[dbo].[IHLISTPRO] M   ON OM.CODPRODUC = M.CODPRODUC
        JOIN [INDIGO031].[dbo].[ADCENATEN] ca   ON OM.CODCENATE = ca.CODCENATE
		JOIN [INDIGO031].[dbo].[INPROFSAL] prof   ON OM.CODPROSAL = prof.CODPROSAL
		JOIN [INDIGO031].[dbo].[INESPECIA] ESP   ON ESP.CODESPECI=prof.CODESPEC1
     WHERE M.TIPPRODUC = 1
           AND OM.FECINIDOS >= '01-01-2023' and OM.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY ca.NOMCENATE, 
              ca.CODCENATE,
              MONTH(OM.FECINIDOS), 
              M.TIPPRODUC, 
              YEAR(OM.FECINIDOS),
			   ESP.DESESPECI,
			  prof.NOMMEDICO, prof.CODPROSAL--, OM.Numefolio;
