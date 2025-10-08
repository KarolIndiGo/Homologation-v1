-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INDICADORESGRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_INDICADORESGRAL
AS
SELECT CA.NOMCENATE AS Sede,
    CASE
        WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
        THEN 'BOYACA'
        WHEN CA.CODCENATE IN(010, 011, 012, 013, 014,018)
        THEN 'META'
        WHEN CA.CODCENATE IN (015,016,019,020)
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
FROM [INDIGO031].[dbo].[HCORDLABO] I
JOIN [INDIGO031].[Contract].[CUPSEntity] C ON I.CODSERIPS = C.Code
                                                    AND YEAR(I.FECORDMED) = '2020'
JOIN [INDIGO031].[dbo].[ADCENATEN] CA ON I.CODCENATE = CA.CODCENATE
where  I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
GROUP BY MONTH(I.FECORDMED), 
        CA.NOMCENATE, 
        CA.CODCENATE, 
        C.ServiceType
UNION
SELECT CA.NOMCENATE AS Sede,
    CASE
        WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
        THEN 'Boyaca'
        WHEN CA.CODCENATE IN(010, 011, 012, 013, 014)
        THEN 'Meta'
        WHEN CA.CODCENATE = 15
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
FROM [INDIGO031].[dbo].[HCORDIMAG] I
    JOIN [INDIGO031].[Contract].[CUPSEntity] C ON I.CODSERIPS = C.Code
                                                    AND YEAR(I.FECORDMED) = '2020'
    JOIN [INDIGO031].[dbo].[ADCENATEN] CA ON I.CODCENATE = CA.CODCENATE
    where  I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
GROUP BY MONTH(I.FECORDMED), 
        CA.NOMCENATE, 
        CA.CODCENATE, 
        C.ServiceType
UNION
SELECT CA.NOMCENATE AS Sede,
    CASE
        WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
        THEN 'Boyaca'
        WHEN CA.CODCENATE IN(010, 011, 012, 013, 014)
        THEN 'Meta'
        WHEN CA.CODCENATE = 15
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
FROM [INDIGO031].[dbo].[HCORDINTE] I
    JOIN [INDIGO031].[Contract].[CUPSEntity] C ON I.CODSERIPS = C.Code
                                                    AND YEAR(I.FECORDMED) = '2020'
    JOIN [INDIGO031].[dbo].[ADCENATEN] CA ON I.CODCENATE = CA.CODCENATE
WHERE C.Code NOT IN('890401', '890406', '90408', '890409', '890410') and  I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
GROUP BY MONTH(I.FECORDMED), 
        CA.NOMCENATE, 
        CA.CODCENATE, 
        C.ServiceType
UNION
SELECT CA.NOMCENATE AS Sede,
    CASE
        WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
        THEN 'Boyaca'
        WHEN CA.CODCENATE IN(010, 011, 012, 013, 014)
        THEN 'Meta'
        WHEN CA.CODCENATE = 15
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
FROM [INDIGO031].[dbo].[HCPRESCRA] OM
    JOIN [INDIGO031].[dbo].[IHLISTPRO] M ON OM.CODPRODUC = M.CODPRODUC
                                            AND YEAR(OM.FECINIDOS) = '2020'
    JOIN [INDIGO031].[dbo].[ADCENATEN] CA ON OM.CODCENATE = CA.CODCENATE
WHERE M.TIPPRODUC = 1 and  OM.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
GROUP BY CA.NOMCENATE,
        CA.CODCENATE, 
        MONTH(OM.FECINIDOS),
        M.TIPPRODUC;
