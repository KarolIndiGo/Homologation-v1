-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Indicador_Interconsultas
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IND_Indicador_Interconsultas]
AS
     SELECT ca.NOMCENATE AS Sede,
            CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional, 
            E.DESESPECI AS MedicOrdena,
            CASE C.ServiceType
                WHEN 1
                THEN 'Laboratorios'
                WHEN 2
                THEN 'Patologias'
                WHEN 3
                THEN 'Imagenes Diagnosticas'
                WHEN 4
                THEN 'Procedimeintos no Qx'
                WHEN 5
                THEN 'Procedimientos Qx'
                WHEN 6
                THEN 'Interconsultas'
                WHEN 7
                THEN 'Ninguno'
                WHEN 8
                THEN 'Consulta Externa'
            END AS Tipo,
            CASE
                WHEN C.Code = '890408'
                THEN SUBSTRING(C.DESCRIPTION, 19, 10)
                WHEN C.Code = '890402'
                THEN SUBSTRING(C.DESCRIPTION, 19, 28)
                WHEN C.CODE NOT IN('890408', '890402')
                THEN SUBSTRING(C.DESCRIPTION, 35, 25)
            END AS Interconsulta,
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
            SUM(I.CANSERIPS) AS Cant,
            CASE
                WHEN red.Red IS NULL
                THEN 'Red Externa'
                WHEN red.Red IS NOT NULL
                THEN red.red
            END AS Red
FROM HCORDINTE AS I
          INNER JOIN Contract.CUPSEntity AS C ON I.CODSERIPS = C.Code
                                                                   AND YEAR(I.FECORDMED) = '2020'
          INNER JOIN dbo.ADCENATEN AS ca ON I.CODCENATE = ca.CODCENATE
          INNER JOIN dbo.INPROFSAL AS M ON I.CODPROSAL = M.CODPROSAL
          INNER JOIN dbo.INESPECIA AS E ON M.CODESPEC1 = E.CODESPECI
          LEFT OUTER JOIN ViewInternal.IND_RedProfesionales_Jer AS Red ON I.CODESPECI = Red.CODESPECI
     WHERE(C.Code NOT IN('890401', '890406', '90408', '890409', '890410')) AND I.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM INDIGO031.dbo.HCFOLANUL) and  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.CODCENATE, 
              C.ServiceType, 
              E.DESESPECI, 
              C.Description, 
              C.Code, 
              Red.Red;
