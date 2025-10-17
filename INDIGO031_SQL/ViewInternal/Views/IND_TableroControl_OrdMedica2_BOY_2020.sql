-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_TableroControl_OrdMedica2_BOY_2020
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_TableroControl_OrdMedica2_BOY_2020]
AS
     SELECT CodProf, 
            Profesional, 
            Especialidad, 
            CentroAtencion, 
            Grupo, 
            Ene, 
            Feb, 
            Mar, 
            Abr, 
            May, 
            Jun, 
            Jul, 
            Ago, 
            Sep, 
            Oct, 
            Nov, 
            Dic
     FROM
     (
         SELECT M.CODPROSAL AS CodProf, 
                M.NOMMEDICO AS Profesional, 
                E.DESESPECI AS Especialidad, 
                CA.NOMCENATE AS CentroAtencion, 
                CF.Name AS Grupo,
                CASE
                    WHEN MONTH(I.FECORDMED) = '1'
                    THEN 'Ene'
                    WHEN MONTH(I.FECORDMED) = '2'
                    THEN 'Feb'
                    WHEN MONTH(I.FECORDMED) = '3'
                    THEN 'Mar'
                    WHEN MONTH(I.FECORDMED) = '4'
                    THEN 'Abr'
                    WHEN MONTH(I.FECORDMED) = '5'
                    THEN 'May'
                    WHEN MONTH(I.FECORDMED) = '6'
                    THEN 'Jun'
                    WHEN MONTH(I.FECORDMED) = '7'
                    THEN 'Jul'
                    WHEN MONTH(I.FECORDMED) = '8'
                    THEN 'Ago'
                    WHEN MONTH(I.FECORDMED) = '9'
                    THEN 'Sep'
                    WHEN MONTH(I.FECORDMED) = '10'
                    THEN 'Oct'
                    WHEN MONTH(I.FECORDMED) = '11'
                    THEN 'Nov'
                    WHEN MONTH(I.FECORDMED) = '12'
                    THEN 'Dic'
                END AS Mes, 
                SUM(I.CANSERIPS) AS Cant
         FROM dbo.HCORDLABO I 
              JOIN Contract.CUPSEntity C  ON I.CODSERIPS = C.Code
                                                                           AND YEAR(I.FECORDMED) = '2020'
              JOIN dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
              JOIN Billing.BillingConcept CF  ON C.BillingConceptId = CF.Id
              JOIN dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
         WHERE CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
         GROUP BY MONTH(I.FECORDMED), 
                  M.CODPROSAL, 
                  M.NOMMEDICO, 
                  CF.Name, 
                  E.DESESPECI, 
                  ca.NOMCENATE
         UNION
         SELECT M.CODPROSAL AS CodProf, 
                M.NOMMEDICO AS Profesional, 
                E.DESESPECI AS Especialidad, 
                CA.NOMCENATE AS CentroAtencion, 
                CF.Name AS Grupo,
                CASE
                    WHEN MONTH(I.FECORDMED) = '1'
                    THEN 'Ene'
                    WHEN MONTH(I.FECORDMED) = '2'
                    THEN 'Feb'
                    WHEN MONTH(I.FECORDMED) = '3'
                    THEN 'Mar'
                    WHEN MONTH(I.FECORDMED) = '4'
                    THEN 'Abr'
                    WHEN MONTH(I.FECORDMED) = '5'
                    THEN 'May'
                    WHEN MONTH(I.FECORDMED) = '6'
                    THEN 'Jun'
                    WHEN MONTH(I.FECORDMED) = '7'
                    THEN 'Jul'
                    WHEN MONTH(I.FECORDMED) = '8'
                    THEN 'Ago'
                    WHEN MONTH(I.FECORDMED) = '9'
                    THEN 'Sep'
                    WHEN MONTH(I.FECORDMED) = '10'
                    THEN 'Oct'
                    WHEN MONTH(I.FECORDMED) = '11'
                    THEN 'Nov'
                    WHEN MONTH(I.FECORDMED) = '12'
                    THEN 'Dic'
                END AS Mes, 
                SUM(I.CANSERIPS) AS Cant
         FROM dbo.HCORDIMAG I 
              JOIN Contract.CUPSEntity C  ON I.CODSERIPS = C.Code
                                                                           AND YEAR(I.FECORDMED) = '2020'
              JOIN dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
              JOIN Billing.BillingConcept CF  ON C.BillingConceptId = CF.Id
              JOIN dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
         WHERE CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
         GROUP BY MONTH(I.FECORDMED), 
                  M.CODPROSAL, 
                  M.NOMMEDICO, 
                  CF.Name, 
                  E.DESESPECI, 
                  ca.NOMCENATE
         UNION
         SELECT M.CODPROSAL AS CodProf, 
                M.NOMMEDICO AS Profesional, 
                E.DESESPECI AS Especialidad, 
                CA.NOMCENATE AS CentroAtencion, 
                CF.Name AS Grupo,
                CASE
                    WHEN MONTH(I.FECORDMED) = '1'
                    THEN 'Ene'
                    WHEN MONTH(I.FECORDMED) = '2'
                    THEN 'Feb'
                    WHEN MONTH(I.FECORDMED) = '3'
                    THEN 'Mar'
                    WHEN MONTH(I.FECORDMED) = '4'
                    THEN 'Abr'
                    WHEN MONTH(I.FECORDMED) = '5'
                    THEN 'May'
                    WHEN MONTH(I.FECORDMED) = '6'
                    THEN 'Jun'
                    WHEN MONTH(I.FECORDMED) = '7'
                    THEN 'Jul'
                    WHEN MONTH(I.FECORDMED) = '8'
                    THEN 'Ago'
                    WHEN MONTH(I.FECORDMED) = '9'
                    THEN 'Sep'
                    WHEN MONTH(I.FECORDMED) = '10'
                    THEN 'Oct'
                    WHEN MONTH(I.FECORDMED) = '11'
                    THEN 'Nov'
                    WHEN MONTH(I.FECORDMED) = '12'
                    THEN 'Dic'
                END AS Mes, 
                SUM(I.CANSERIPS) AS Cant
         FROM dbo.HCORDPRON I 
              JOIN Contract.CUPSEntity C  ON I.CODSERIPS = C.Code
                                                                           AND YEAR(I.FECORDMED) = '2020'
              JOIN dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
              JOIN Billing.BillingConcept CF  ON C.BillingConceptId = CF.Id
              JOIN dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
         WHERE CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
         GROUP BY MONTH(I.FECORDMED), 
                  M.CODPROSAL, 
                  M.NOMMEDICO, 
                  CF.Name, 
                  E.DESESPECI, 
                  ca.NOMCENATE
         UNION
         SELECT M.CODPROSAL AS CodProf, 
                M.NOMMEDICO AS Profesional, 
                E.DESESPECI AS Especialidad, 
                CA.NOMCENATE AS CentroAtencion, 
                CF.Name AS Grupo,
                CASE
                    WHEN MONTH(I.FECORDMED) = '1'
                    THEN 'Ene'
                    WHEN MONTH(I.FECORDMED) = '2'
                    THEN 'Feb'
                    WHEN MONTH(I.FECORDMED) = '3'
                    THEN 'Mar'
                    WHEN MONTH(I.FECORDMED) = '4'
                    THEN 'Abr'
                    WHEN MONTH(I.FECORDMED) = '5'
                    THEN 'May'
                    WHEN MONTH(I.FECORDMED) = '6'
                    THEN 'Jun'
                    WHEN MONTH(I.FECORDMED) = '7'
                    THEN 'Jul'
                    WHEN MONTH(I.FECORDMED) = '8'
                    THEN 'Ago'
                    WHEN MONTH(I.FECORDMED) = '9'
                    THEN 'Sep'
                    WHEN MONTH(I.FECORDMED) = '10'
                    THEN 'Oct'
                    WHEN MONTH(I.FECORDMED) = '11'
                    THEN 'Nov'
                    WHEN MONTH(I.FECORDMED) = '12'
                    THEN 'Dic'
                END AS Mes, 
                SUM(I.CANSERIPS) AS Cant
         FROM dbo.HCORDPROQ I 
              JOIN Contract.CUPSEntity C  ON I.CODSERIPS = C.Code
                                                                           AND YEAR(I.FECORDMED) = '2020'
              JOIN dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
              JOIN Billing.BillingConcept CF  ON C.BillingConceptId = CF.Id
              JOIN dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
         WHERE CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
         GROUP BY MONTH(I.FECORDMED), 
                  M.CODPROSAL, 
                  M.NOMMEDICO, 
                  CF.Name, 
                  E.DESESPECI, 
                  ca.NOMCENATE
         UNION
         SELECT M.CODPROSAL AS CodProf, 
                M.NOMMEDICO AS Profesional, 
                E.DESESPECI AS Especialidad, 
                CA.NOMCENATE AS CentroAtencion, 
                C.Description AS Grupo,
                CASE
                    WHEN MONTH(I.FECORDMED) = '1'
                    THEN 'Ene'
                    WHEN MONTH(I.FECORDMED) = '2'
                    THEN 'Feb'
                    WHEN MONTH(I.FECORDMED) = '3'
                    THEN 'Mar'
                    WHEN MONTH(I.FECORDMED) = '4'
                    THEN 'Abr'
                    WHEN MONTH(I.FECORDMED) = '5'
                    THEN 'May'
                    WHEN MONTH(I.FECORDMED) = '6'
                    THEN 'Jun'
                    WHEN MONTH(I.FECORDMED) = '7'
                    THEN 'Jul'
                    WHEN MONTH(I.FECORDMED) = '8'
                    THEN 'Ago'
                    WHEN MONTH(I.FECORDMED) = '9'
                    THEN 'Sep'
                    WHEN MONTH(I.FECORDMED) = '10'
                    THEN 'Oct'
                    WHEN MONTH(I.FECORDMED) = '11'
                    THEN 'Nov'
                    WHEN MONTH(I.FECORDMED) = '12'
                    THEN 'Dic'
                END AS Mes, 
                SUM(I.CANSERIPS) AS Cant
         FROM dbo.HCORDINTE I 
              JOIN Contract.CUPSEntity C  ON I.CODSERIPS = C.Code
                                                                           AND YEAR(I.FECORDMED) = '2020'
              JOIN dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
              JOIN dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
         WHERE CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
         GROUP BY MONTH(I.FECORDMED), 
                  M.CODPROSAL, 
                  M.NOMMEDICO, 
                  C.Description, 
                  E.DESESPECI, 
                  ca.NOMCENATE
         UNION
         SELECT M.CODPROSAL AS CodProf, 
                M.NOMMEDICO AS Profesional, 
                E.DESESPECI AS Especialidad, 
                CA.NOMCENATE AS CentroAtencion,
                CASE
                    WHEN I.CODUSUARI IS NULL
                    THEN 'ConsultaRealizada'
                END AS Grupo,
                CASE
                    WHEN MONTH(I.FECHISPAC) = '1'
                    THEN 'Ene'
                    WHEN MONTH(I.FECHISPAC) = '2'
                    THEN 'Feb'
                    WHEN MONTH(I.FECHISPAC) = '3'
                    THEN 'Mar'
                    WHEN MONTH(I.FECHISPAC) = '4'
                    THEN 'Abr'
                    WHEN MONTH(I.FECHISPAC) = '5'
                    THEN 'May'
                    WHEN MONTH(I.FECHISPAC) = '6'
                    THEN 'Jun'
                    WHEN MONTH(I.FECHISPAC) = '7'
                    THEN 'Jul'
                    WHEN MONTH(I.FECHISPAC) = '8'
                    THEN 'Ago'
                    WHEN MONTH(I.FECHISPAC) = '9'
                    THEN 'Sep'
                    WHEN MONTH(I.FECHISPAC) = '10'
                    THEN 'Oct'
                    WHEN MONTH(I.FECHISPAC) = '11'
                    THEN 'Nov'
                    WHEN MONTH(I.FECHISPAC) = '12'
                    THEN 'Dic'
                END AS Mes, 
                COUNT(I.CODPROSAL) AS Cant
         FROM dbo.HCHISPACA I 
              JOIN dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
                                                                     AND YEAR(I.FECHISPAC) = '2020'
              JOIN dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN dbo.ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
         WHERE CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
         GROUP BY MONTH(I.FECHISPAC), 
                  M.CODPROSAL, 
                  M.NOMMEDICO, 
                  E.DESESPECI, 
                  I.CODUSUARI, 
                  CA.NOMCENATE
     ) Source PIVOT(SUM(Cant) FOR source.Mes IN(Ene, 
                                                Feb, 
                                                Mar, 
                                                Abr, 
                                                May, 
                                                Jun, 
                                                Jul, 
                                                Ago, 
                                                Sep, 
                                                Oct, 
                                                Nov, 
                                                Dic)) AS pivotable;  
