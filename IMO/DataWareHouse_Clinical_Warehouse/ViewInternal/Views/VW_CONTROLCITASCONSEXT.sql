-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_CONTROLCITASCONSEXT
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[ControlCitasConsExt]
AS

SELECT
    CASE
        WHEN c.CODCENATE IN ('001') THEN 'Sucursal Neiva'
        WHEN c.CODCENATE IN ('002') THEN 'Sucursal Pitalito'
    END AS SEDE,
    c.CODCENATE,
    act.DESACTMED AS Actividad,
    ESP.DESESPECI AS Especialidad,
    PRO.NOMMEDICO AS Profesional,
    CASE c.CODTIPCIT
        WHEN 0 THEN 'Primera Vez'
        WHEN 1 THEN 'Control'
        WHEN 2 THEN 'Pos Operatorio'
        WHEN 3 THEN 'Cita Web'
    END AS TipoCita,
    c.FECHORAIN AS FechaInicial_Cita,
    c.FECHORAFI AS FechaFinal_Cita,
    Ing.IFECHAING AS FechaIngresO,
    CASE f.CONESTADO
        WHEN 1 THEN 'Sin Atender'
        WHEN 2 THEN 'Ausente/Anulada'
        WHEN 3 THEN 'Atendido'
        WHEN 4 THEN 'En Sala'
        WHEN 5 THEN 'En Consultorio'
    END AS Estado,
    f.FECENCONSULTORIO AS FechaEnConsultorio,
    f.FECCITACUMPLIDA AS FechaCumplidaCita,
    CASE WHEN DATEDIFF(minute, Ing.IFECHAING, c.FECHORAIN) < 0 THEN '0'
         ELSE DATEDIFF(minute, Ing.IFECHAING, c.FECHORAIN) END AS [Dif Fecha Ingreso - Fecha Inicial Cita (min)],
    CASE WHEN DATEDIFF(minute, c.FECHORAIN, f.FECENCONSULTORIO) < 0 THEN '0'
         ELSE DATEDIFF(minute, c.FECHORAIN, f.FECENCONSULTORIO) END AS [Dif Fecha Inicial Cita - Fecha Consultorio (min)],
    CASE WHEN DATEDIFF(minute, f.FECENCONSULTORIO, f.FECCITACUMPLIDA) < 0 THEN '0'
         ELSE DATEDIFF(minute, f.FECENCONSULTORIO, f.FECCITACUMPLIDA) END AS [Dif Fecha Consultorio - Fecha Cita Cumplida (min)],
    f.IPCODPACI AS Identificacion,
    Ing.NUMINGRES AS Ingreso,
    G.CODUSUARI AS CodUsuAsigna,
    LTRIM(RTRIM(G.NOMUSUARI)) AS Usuario_Asigna
FROM INDIGO035.dbo.AGASICITA AS c
INNER JOIN INDIGO035.dbo.ADCONCOEX AS f
    ON c.CODAUTONU = f.NUMCONCIT
INNER JOIN INDIGO035.dbo.AGACTIMED AS act
    ON c.CODACTMED = act.CODACTMED
INNER JOIN INDIGO035.dbo.HCHISPACA AS his
    ON his.ID = f.IDHCHISPACA
INNER JOIN INDIGO035.dbo.ADINGRESO AS Ing
    ON his.NUMINGRES = Ing.NUMINGRES
INNER JOIN INDIGO035.dbo.INESPECIA AS ESP
    ON ESP.CODESPECI = his.CODESPTRA
INNER JOIN INDIGO035.dbo.INPROFSAL AS PRO
    ON PRO.CODPROSAL = c.CODPROSAL
INNER JOIN INDIGO035.dbo.ADCENATEN AS CEN
    ON CEN.CODCENATE = c.CODCENATE
LEFT OUTER JOIN INDIGO035.dbo.SEGusuaru AS G
    ON G.CODUSUARI = c.CODUSUASI
WHERE c.CODESTCIT = 1
  AND his.ESTAFOLIO = 1
  AND his.GENCONEXT = 1
  AND YEAR(his.FECHISPAC) >= '2024';