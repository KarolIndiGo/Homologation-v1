-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_TABLEROCONTROL_ORDMEDICA2
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_IND_TABLEROCONTROL_ORDMEDICA2] AS
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
                ca.NOMCENATE AS CentroAtencion, 
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
         FROM INDIGO031.dbo.HCORDLABO I
              JOIN INDIGO031.Contract.CUPSEntity C ON I.CODSERIPS = C.Code
                                                              AND YEAR(I.FECORDMED) = '2020'
              JOIN INDIGO031.dbo.INPROFSAL M ON I.CODPROSAL = M.CODPROSAL
              JOIN INDIGO031.Billing.BillingConcept CF ON C.BillingConceptId = CF.Id
              JOIN INDIGO031.dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
              JOIN INDIGO031.dbo.SEGusuaru u ON M.CODUSUARI = u.CODUSUARI
              JOIN INDIGO031.dbo.ADCENATEN ca ON I.CODCENATE = ca.CODCENATE
         WHERE ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
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
                ca.NOMCENATE AS CentroAtencion, 
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
         FROM INDIGO031.dbo.HCORDIMAG I
              JOIN INDIGO031.Contract.CUPSEntity C ON I.CODSERIPS = C.Code
                                                              AND YEAR(I.FECORDMED) = '2020'
              JOIN INDIGO031.dbo.INPROFSAL M ON I.CODPROSAL = M.CODPROSAL
              JOIN INDIGO031.Billing.BillingConcept CF ON C.BillingConceptId = CF.Id
              JOIN INDIGO031.dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
              JOIN INDIGO031.dbo.SEGusuaru u ON M.CODUSUARI = u.CODUSUARI
              JOIN INDIGO031.dbo.ADCENATEN ca ON I.CODCENATE = ca.CODCENATE
         WHERE ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
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
                ca.NOMCENATE AS CentroAtencion, 
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
         FROM INDIGO031.dbo.HCORDPRON I
              JOIN INDIGO031.Contract.CUPSEntity C ON I.CODSERIPS = C.Code
                                                              AND YEAR(I.FECORDMED) = '2020'
              JOIN INDIGO031.dbo.INPROFSAL M ON I.CODPROSAL = M.CODPROSAL
              JOIN INDIGO031.Billing.BillingConcept CF ON C.BillingConceptId = CF.Id
              JOIN INDIGO031.dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
              JOIN INDIGO031.dbo.SEGusuaru u ON M.CODUSUARI = u.CODUSUARI
              JOIN INDIGO031.dbo.ADCENATEN ca ON I.CODCENATE = ca.CODCENATE
         WHERE ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
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
                ca.NOMCENATE AS CentroAtencion, 
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
         FROM INDIGO031.dbo.HCORDPROQ I
              JOIN INDIGO031.Contract.CUPSEntity C ON I.CODSERIPS = C.Code
                                                              AND YEAR(I.FECORDMED) = '2020'
              JOIN INDIGO031.dbo.INPROFSAL M ON I.CODPROSAL = M.CODPROSAL
              JOIN INDIGO031.Billing.BillingConcept CF ON C.BillingConceptId = CF.Id
              JOIN INDIGO031.dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
              JOIN INDIGO031.dbo.SEGusuaru u ON M.CODUSUARI = u.CODUSUARI
              JOIN INDIGO031.dbo.ADCENATEN ca ON I.CODCENATE = ca.CODCENATE
         WHERE ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
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
                ca.NOMCENATE AS CentroAtencion, 
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
         FROM INDIGO031.dbo.HCORDINTE I 
              JOIN INDIGO031.Contract.CUPSEntity C  ON I.CODSERIPS = C.Code
                                                                           AND YEAR(I.FECORDMED) = '2020'
              JOIN INDIGO031.dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
              JOIN INDIGO031.dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN INDIGO031.dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN INDIGO031.dbo.ADCENATEN ca  ON I.CODCENATE = ca.CODCENATE
         WHERE ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
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
                ca.NOMCENATE AS CentroAtencion,
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
         FROM INDIGO031.dbo.HCHISPACA I 
              JOIN INDIGO031.dbo.INPROFSAL M  ON I.CODPROSAL = M.CODPROSAL
                                                                     AND YEAR(I.FECHISPAC) = '2020'
              JOIN INDIGO031.dbo.INESPECIA E  ON M.CODESPEC1 = E.CODESPECI
              JOIN INDIGO031.dbo.SEGusuaru u  ON M.CODUSUARI = u.CODUSUARI
              JOIN INDIGO031.dbo.ADCENATEN ca  ON I.CODCENATE = ca.CODCENATE
         WHERE ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
         GROUP BY MONTH(I.FECHISPAC), 
                  M.CODPROSAL, 
                  M.NOMMEDICO, 
                  E.DESESPECI, 
                  I.CODUSUARI, 
                  ca.NOMCENATE
     ) Source PIVOT(SUM(Cant) FOR Mes IN(Ene, 
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
