-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGral_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [ViewInternal].[IND_IndicadoresGral_PB]
AS
     SELECT 'Laboratorio' AS Tipo, 
            ca.NOMCENATE AS Sede,
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
     FROM dbo.HCORDLABO I 
          JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
     WHERE I.FECORDMED >= '01-01-2022' and  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
           AND I.ESTSERIPS <> '6' and   i.IPCODPACI<>'9999999' AND i.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM DBO.HCFOLANUL)
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              YEAR(I.FECORDMED)
     UNION ALL
     SELECT 'ImagenesDx' AS Tipo, 
            ca.NOMCENATE AS Sede,
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
     FROM dbo.HCORDIMAG I 
          JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
     WHERE I.FECORDMED >= '01-01-2022'  and  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
           AND I.ESTSERIPS <> '6'  and i.IPCODPACI<>'9999999' AND i.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM DBO.HCFOLANUL)
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              YEAR(I.FECORDMED)
     UNION ALL
     SELECT 'Interconsultas' AS Tipo, 
            ca.NOMCENATE AS Sede,
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
          JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
     WHERE I.FECORDMED >= '01-01-2022'
           AND I.ESTSERIPS <> '6'   and  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
           AND i.codserips NOT IN('890401', '890406', '90408', '890409', '890410') AND i.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM DBO.HCFOLANUL)
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              YEAR(I.FECORDMED)
     UNION ALL
     SELECT 'Medicamentos' AS Tipo, 
            ca.NOMCENATE AS Sede,
          CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(OM.FECINIDOS) AS Mes, 
            YEAR(OM.FECINIDOS) AS Mes, 
            COUNT(OM.CODPRODUC) AS Cant
     FROM dbo.HCPRESCRA OM 
          JOIN dbo.IHLISTPRO M  ON OM.CODPRODUC = M.CODPRODUC
          JOIN dbo.ADCENATEN CA  ON OM.CODCENATE = CA.CODCENATE
     WHERE M.TIPPRODUC = 1
           AND om.FECINIDOS >= '01-01-2022'  and om.IPCODPACI not in ('1234567', '12345678', '14141414','9999999') AND om.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM DBO.HCFOLANUL)
     GROUP BY CA.NOMCENATE, 
              CA.CODCENATE, 
              MONTH(OM.FECINIDOS), 
              M.TIPPRODUC, 
              YEAR(OM.FECINIDOS);
