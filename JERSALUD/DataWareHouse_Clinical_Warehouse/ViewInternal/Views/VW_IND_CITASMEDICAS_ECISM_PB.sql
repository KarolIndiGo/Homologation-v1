-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_CITASMEDICAS_ECISM_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_CITASMEDICAS_ECISM_PB 
AS

SELECT *
FROM (
SELECT               
    C.IPCODPACI AS IDENTIFICACION,
    CA.NOMCENATE AS sede, 
    CASE
        WHEN C.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021) THEN 'BOYACA'
        WHEN C.CODCENATE IN(010, 011, 012, 013, 014,018) THEN 'META'
        WHEN C.CODCENATE IN (015,016,019,020) THEN 'CASANARE'
    END AS Regional,
    P.CODPROSAL AS CodMed, 
    P.NOMMEDICO AS MEDICO, 
    rtrim(E.DESESPECI) AS ESPECIALIDAD, 
    C.FECHORAIN AS [FECHA DE CITA], 
    
    CASE C.CODESTCIT
        WHEN '0'
        THEN 'Asignada'
        WHEN '1'
        THEN 'Cumplida'
        WHEN '2'
        THEN 'Incumplida'
        WHEN '3'
        THEN 'Preasignada'
        WHEN 4
        THEN 'Cancelada'
    END AS ESTADO,

    
    IIF(H.NUMEFOLIO IS NULL, 'SIN HC', 'CON HC') AS Tiene_HC, 
    IIF(H.NUMEFOLIO IS NULL, IIF(C.CODESTCIT = '0' AND C.FECHORAIN < DATEADD(DAY, -1, GETDATE()), 'Incumplida',
        CASE C.CODESTCIT
            WHEN '0'
            THEN 'Asignada'
            WHEN '1'
            THEN 'Cumplida'
            WHEN '2'
            THEN 'Incumplida'
            WHEN '3'
            THEN 'Preasignada'
            WHEN 4
            THEN 'Cancelada'
        END), 'Cumplida') AS Estado_Real_Cita
        , 'https://forms.office.com/r/LPJ0SyLy6v' as [Link Cancelacion],
case 
when H.CODDIAGNO= 'I10x' then 'Hipertensión Arterial'   --Pertenece a Programa
when H.CODDIAGNO between 'I150' and 'I159' then 'Hipertensión Arterial'  --Pertenece a Programa
when H.CODDIAGNO between 'E100' and 'E149' then 'Diabetes Mellitus'  --Pertenece a Programa
when H.CODDIAGNO between 'E780' and 'E785' then 'Hipetrigliceridemia - Hipercolesterolemia'  --Pertenece a Programa
when H.CODDIAGNO in ('E660','E668','E669') then 'Obesidad'   --Pertenece a Programa
when H.CODDIAGNO in ('Z001', 'Z000', 'Z002','Z003', 'Z008', 'Z121', 'Z123', 'Z124', 'Z125','Z136', 'Z761','Z762','Z316','Z318', 'Z319','Z309','Z310','Z311','Z312','Z313','Z314','Z315','Z316','Z317','Z318',
'Z319','Z320','Z321','Z322','Z323','Z324','Z325','Z326','Z327','Z328','Z329','Z330','Z331','Z332','Z333','Z334','Z335','Z336','Z337','Z338','Z339','Z340','Z341','Z342','Z343','Z344',
'Z345','Z346','Z347','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z391', 'Z392', 'Z718', 'Z719') then 'RPYM'  --se agrega RPYM  --Pertenece a RPYMM
 else 'Morbilidad' end as 'GruposRiesgo', A.CODACTMED as CodActividad, A.DESACTMED as Actividad
        
FROM [INDIGO031].[dbo].[AGASICITA] AS C 
    INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS PA  ON PA.IPCODPACI = C.IPCODPACI
    INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS P   ON P.CODPROSAL = C.CODPROSAL
    INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS E   ON C.CODESPECI = E.CODESPECI
    INNER JOIN [INDIGO031].[dbo].[AGACTIMED] AS A   ON A.CODACTMED = C.CODACTMED
    INNER JOIN [INDIGO031].[dbo].[SEGusuaru] AS US  ON US.CODUSUARI = C.CODUSUASI
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADCONCOEX] AS ce on C.IPCODPACI=ce.IPCODPACI and    C.CODAUTONU = ce.NUMCONCIT
    LEFT OUTER JOIN [INDIGO031].[Contract].[HealthAdministrator] AS EA   ON PA.GENCONENTITY = EA.Id
    INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA   ON C.CODCENATE = CA.CODCENATE
    LEFT JOIN [INDIGO031].[dbo].[HCHISPACA] AS H   ON H.NUMINGRES = ce.NUMINGRES and H.ID=ce.IDHCHISPACA

WHERE year(C.FECHORAIN)>=2023 and C.CODESPECI in('365','366','367')
) AS A 
WHERE  IDENTIFICACION<>'9999999' 
