-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INDICADOR_CONSULTAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_IND_INDICADOR_CONSULTAS
AS
SELECT CA.NOMCENATE AS Sede,
    CASE
        WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009)
        THEN 'Boyaca'
        WHEN CA.CODCENATE IN(010, 011, 012, 013, 014)
        THEN 'Meta'
        WHEN CA.CODCENATE = 15
        THEN 'Yopal'
    END AS Regional, 
    'Consultas' AS Tipo,
    CASE
        WHEN MONTH(H.FECHISPAC) = '1'
        THEN 'Ene'
        WHEN MONTH(H.FECHISPAC) = '2'
        THEN 'Feb'
        WHEN MONTH(H.FECHISPAC) = '3'
        THEN 'Mar'
        WHEN MONTH(H.FECHISPAC) = '4'
        THEN 'Abr'
        WHEN MONTH(H.FECHISPAC) = '5'
        THEN 'May'
        WHEN MONTH(H.FECHISPAC) = '6'
        THEN 'Jun'
        WHEN MONTH(H.FECHISPAC) = '7'
        THEN 'Jul'
        WHEN MONTH(H.FECHISPAC) = '8'
        THEN 'Ago'
        WHEN MONTH(H.FECHISPAC) = '9'
        THEN 'Sep'
        WHEN MONTH(H.FECHISPAC) = '10'
        THEN 'Oct'
        WHEN MONTH(H.FECHISPAC) = '11'
        THEN 'Nov'
        WHEN MONTH(H.FECHISPAC) = '12'
        THEN 'Dic'
    END AS Mes, 
    COUNT(H.NUMINGRES) AS Cant
FROM [INDIGO031].[dbo].[HCHISPACA] AS H
    INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON H.CODCENATE = CA.CODCENATE
                                                        AND YEAR(H.FECHISPAC) = '2020'
WHERE(H.TIPHISPAC = 'I') and H.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
GROUP BY CA.CODCENATE, 
        CA.NOMCENATE, 
        MONTH(H.FECHISPAC);
