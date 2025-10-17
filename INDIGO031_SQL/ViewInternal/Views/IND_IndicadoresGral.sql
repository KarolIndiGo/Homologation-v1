-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGral
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_IndicadoresGral]
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
          JOIN Contract.CUPSEntity C ON I.CODSERIPS = C.Code
                                                          AND YEAR(I.FECORDMED) = '2020'
          JOIN dbo.ADCENATEN ca ON I.CODCENATE = CA.CODCENATE
		  where  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              C.ServiceType
     UNION
     SELECT ca.NOMCENATE AS Sede,
            CASE
                WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009)
                THEN 'Boyaca'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014)
                THEN 'Meta'
                WHEN ca.codcenate = 15
                THEN 'Yopal'
            END AS Regional,
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
          JOIN Contract.CUPSEntity C ON I.CODSERIPS = C.Code
                                                          AND YEAR(I.FECORDMED) = '2020'
          JOIN dbo.ADCENATEN ca ON I.CODCENATE = CA.CODCENATE
		  where  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              C.ServiceType
     UNION
     SELECT ca.NOMCENATE AS Sede,
            CASE
                WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009)
                THEN 'Boyaca'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014)
                THEN 'Meta'
                WHEN ca.codcenate = 15
                THEN 'Yopal'
            END AS Regional,
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
          JOIN Contract.CUPSEntity C ON I.CODSERIPS = C.Code
                                                          AND YEAR(I.FECORDMED) = '2020'
          JOIN dbo.ADCENATEN ca ON I.CODCENATE = CA.CODCENATE
     WHERE c.code NOT IN('890401', '890406', '90408', '890409', '890410') and  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY MONTH(I.FECORDMED), 
              ca.NOMCENATE, 
              ca.codcenate, 
              C.ServiceType
     UNION
     SELECT ca.NOMCENATE AS Sede,
            CASE
                WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009)
                THEN 'Boyaca'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014)
                THEN 'Meta'
                WHEN ca.codcenate = 15
                THEN 'Yopal'
            END AS Regional,
            CASE M.TIPPRODUC
                WHEN 1
                THEN 'Medicamentos'
            END AS Tipo,
            CASE
                WHEN MONTH(OM.FECINIDOS) = '1'
                THEN 'Ene'
                WHEN MONTH(OM.FECINIDOS) = '2'
                THEN 'Feb'
                WHEN MONTH(OM.FECINIDOS) = '3'
                THEN 'Mar'
                WHEN MONTH(OM.FECINIDOS) = '4'
                THEN 'Abr'
                WHEN MONTH(OM.FECINIDOS) = '5'
                THEN 'May'
                WHEN MONTH(OM.FECINIDOS) = '6'
                THEN 'Jun'
                WHEN MONTH(OM.FECINIDOS) = '7'
                THEN 'Jul'
                WHEN MONTH(OM.FECINIDOS) = '8'
                THEN 'Ago'
                WHEN MONTH(OM.FECINIDOS) = '9'
                THEN 'Sep'
                WHEN MONTH(OM.FECINIDOS) = '10'
                THEN 'Oct'
                WHEN MONTH(OM.FECINIDOS) = '11'
                THEN 'Nov'
                WHEN MONTH(OM.FECINIDOS) = '12'
                THEN 'Dic'
            END AS Mes, 
            COUNT(OM.CODPRODUC) AS Cant
     FROM dbo.HCPRESCRA OM
          JOIN dbo.IHLISTPRO M ON OM.CODPRODUC = M.CODPRODUC
                                                    AND YEAR(OM.FECINIDOS) = '2020'
          JOIN dbo.ADCENATEN CA ON OM.CODCENATE = CA.CODCENATE
     WHERE M.TIPPRODUC = 1 and  om.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
     GROUP BY CA.NOMCENATE, 
              CA.CODCENATE, 
              MONTH(OM.FECINIDOS), 
              M.TIPPRODUC;
