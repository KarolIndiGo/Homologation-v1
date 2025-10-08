-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AD_AG_OPORTUNIDADAGENDA_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AD_AG_OPORTUNIDADAGENDA_PB 
AS

SELECT TOP (100) PERCENT Id_Agenda
    , Sede
    , Estado_Agenda
    , FechaIni_Agenda
    , FechaFin_Agenda
    , CodEsp
    , Especialidad
    , DuracionActividad
    , Cantidad_Paciente
    , Total_Citas
    , TotalAgenda_Min
    , TotalCita_Min
    , minutos_disponibles
    , Oportunidad
    , Regional
FROM (
    SELECT Id_Agenda
        , NOMCENATE AS Sede
        , CASE 
            WHEN TURNOBLOQ = '1' THEN 'Bloqueado' 
            ELSE 'Activa' END AS Estado_Agenda
        , FechaIni_Agenda
        , FechaFin_Agenda
        , CodEsp
        , Especialidad
        , DuracionActividad
        , DATEDIFF(HOUR, FechaIni_Agenda, FechaFin_Agenda) * 60 / DuracionActividad AS Cantidad_Paciente
        , INDIGO031.ViewInternal.Cita_Paciente(Id_Agenda, FechaIni_Agenda, FechaFin_Agenda) AS Total_Citas
        , SUM(DISTINCT TIMEAGENDA_minutos) AS TotalAgenda_Min
        , SUM(TIMECITA) AS TotalCita_Min
        , SUM(DISTINCT TIMEAGENDA_minutos) - SUM(TIMECITA) AS minutos_disponibles
        , CASE 
            WHEN ((SUM(TIMECITA) >= SUM(DISTINCT TIMEAGENDA_minutos))) THEN 'No_Disponible' 
            ELSE 'Disponible' END AS Oportunidad
        , Regional
            FROM (
                SELECT Id_Agenda
                    , FechaIni_Agenda
                    , FechaFin_Agenda
                    , TIMEAGENDA_hora
                    , TIMEAGENDA_minutos
                    , TURNOBLOQ
                    , CODCENATE
                    , NOMCENATE
                    , CODIGOCON
                    , CodEsp
                    , Especialidad
                    , IDCITA
                    , IPCODPACI
                    , FECHORAIN
                    , FECHORAFI
                    , TIMECITA
                    , CODACTMED
                    , CODESTCIT
                    , ESTADOACT
                    , DESACTMED
                    , DuracionActividad
                    , Regional
                           FROM   (select DISTINCT A.CODAUTONU AS Id_Agenda, A.FECHORAIN AS FechaIni_Agenda, A.FECHORAFI AS FechaFin_Agenda,
DATEDIFF( hour , A.FECHORAIN, A.FECHORAFI) AS TIMEAGENDA_hora,
DATEDIFF( minute , A.FECHORAIN, A.FECHORAFI) as TIMEAGENDA_minutos,
A.TURNOBLOQ, A.CODCENATE,CA.NOMCENATE, A.CODIGOCON, E.CODESPECI as CodEsp ,E.DESESPECI AS Especialidad,
C.CODAUTONU AS IDCITA, C.IPCODPACI, C.FECHORAIN, C.FECHORAFI,
DATEDIFF( minute , C.FECHORAIN, C.FECHORAFI) AS TIMECITA,
C.CODACTMED, C.CODESTCIT,
ACT.ESTADOACT, ACT.DESACTMED, ACT.DURAACTIV as DuracionActividad,
CASE
    WHEN A.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
    THEN 'BOYACA'
    WHEN A.CODCENATE IN(010, 011, 012, 013, 014,018)
    THEN 'META'
    WHEN A.CODCENATE IN (015,016,019,020)
    THEN 'CASANARE'
END AS Regional
     
from [INDIGO031].[dbo].[AGAGEMEDC] AS A 
INNER JOIN (select distinct CODAUTONU, CODESPECI
            from  [INDIGO031].[dbo].[AGAGEMEDD]) AS AD ON AD.CODAUTONU=A.CODAUTONU
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA  ON CA.CODCENATE=A.CODCENATE
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS E  ON E.CODESPECI=AD.CODESPECI
LEFT OUTER JOIN [INDIGO031].[dbo].[AGASICITA] AS C  ON C.IDAGENDA=A.CODAUTONU AND C.CODESTCIT IN ('0','1')
LEFT OUTER JOIN [INDIGO031].[dbo].[AGACTIMED] AS ACT  ON ACT.CODACTMED=C.CODACTMED
WHERE --ad.CODAUTONU='6352' and 
CONVERT(DATE,A.FECHORAIN)>=CONVERT(DATE,GETDATE()) )
                                          AS derivedtbl_1) AS SUB_QUERY
             WHERE  (CONVERT(DATE, FechaIni_Agenda) >= CONVERT(DATE, GETDATE()))
             GROUP BY Id_Agenda, TURNOBLOQ, FechaIni_Agenda, FechaFin_Agenda, NOMCENATE, CodEsp, Especialidad, DuracionActividad, Regional) AS a
WHERE (Estado_Agenda = 'Activa') 
ORDER BY FechaIni_Agenda