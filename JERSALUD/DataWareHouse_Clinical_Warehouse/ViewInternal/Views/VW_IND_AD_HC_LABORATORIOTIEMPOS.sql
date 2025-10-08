-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AD_HC_LABORATORIOTIEMPOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AD_HC_LABORATORIOTIEMPOS
AS
SELECT DISTINCT 
    L.IPCODPACI AS DocPcte, 
    P.IPNOMCOMP AS NombrePcte,
    YEAR(GETDATE()) - YEAR(P.IPFECNACI) AS Edad,
    P.IPESTRATO AS Estrato,
    GE.DESGRUPET as GrupoEtnico,
    NE.NIVEDESCRI AS NivelEducativo,
    L.NUMINGRES AS Ingreso, 
    I.IFECHAING AS FechaIngreso, 
    L.UFUCODIGO AS CodUnidad, 
    U.UFUDESCRI AS UnidadFuncional, 
    L.CODPROSAL AS CodMedicoSolicita, 
    M.NOMMEDICO AS NombreMedicoSolicita, 
    L.FECORDMED AS FechaSolicitud, 
    L.CODSERIPS AS CodServicio, 
    S.DESSERIPS AS Servicio,
    CASE
        WHEN L.ESTSERIPS = '1'
        THEN 'Solicitado'
        WHEN L.ESTSERIPS = '2'
        THEN 'MuestraRecolectada'
        WHEN L.ESTSERIPS = '3'
        THEN 'ResultadoEntregado'
        WHEN L.ESTSERIPS = '4'
        THEN 'ExamenInterpretado'
        WHEN L.ESTSERIPS = '5'
        THEN 'Remitido'
        WHEN L.ESTSERIPS = '6'
        THEN 'Anulado'
        WHEN L.ESTSERIPS = '7'
        THEN 'Extramural'
        WHEN L.ESTSERIPS = '8'
        THEN 'MuestraRecolectadaParcialmente'
    END AS EstadoLaboratorio, 
    L.CODPROINT, 
    MI.NOMMEDICO AS MedicoInterpreta, 
    L.FECRECMUE AS FechaRecoleccionMuestra, 
    L.INTERPRET AS Interpretacion, 
    Z.FECGENERA AS FechaEntregaResultado, 
    DATEDIFF(MINUTE, L.FECORDMED, L.FECRECMUE) AS TiempoToma1, 
    DATEDIFF(MINUTE, L.FECRECMUE, Z.FECGENERA) AS TiempoResultado, 
    DATEDIFF(MINUTE, L.FECORDMED, Z.FECGENERA) AS TiempoTotal, 
    L.OBSSERIPS AS Observacion,
    CASE L.PRISERIPS
        WHEN 1
        THEN 'Urgente'
        WHEN 2
        THEN 'Rutina'
    END AS Prioridad, 
    caa.CODCENATE AS Codcc, 
    caa.NOMCENATE AS CentroAtencion, 
    'Intrahospitalario' AS Tipo
FROM [INDIGO031].[dbo].[HCORDLABO] AS L
    INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS I  ON L.NUMINGRES = I.NUMINGRES
    INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS P  ON L.IPCODPACI = P.IPCODPACI
    INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS U  ON L.UFUCODIGO = U.UFUCODIGO
    INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS M  ON L.CODPROSAL = M.CODPROSAL
    INNER JOIN [INDIGO031].[dbo].[INCUPSIPS] AS S  ON L.CODSERIPS = S.CODSERIPS
    LEFT OUTER JOIN [INDIGO031].[dbo].[INPROFSAL] AS MI  ON L.CODPROINT = MI.CODPROSAL
    LEFT OUTER JOIN [INDIGO031].[dbo].[INTERCTRL] AS Z  ON L.AUTO = Z.AUTOLABOR
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADCENATEN] AS caa  ON caa.CODCENATE = L.CODCENATE
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADNIVELED]  AS NE   on  P.NIVCODIGO = NE.NIVECODIGO 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADGRUETNI] AS GE    on  P.CODGRUPOE = GE.CODGRUPOE
WHERE (L.FECORDMED >= '01/01/2022')  and (I.IESTADOIN <> 'A')
UNION ALL
SELECT DISTINCT 
    L.IPCODPACI AS DocPcte, 
    P.IPNOMCOMP AS NombrePcte,
    YEAR(GETDATE()) - YEAR(P.IPFECNACI) AS Edad,
    P.IPESTRATO AS Estrato,
    GE.DESGRUPET as GrupoEtnico,
    NE.NIVEDESCRI AS NivelEducativo,
    L.NUMINGRES AS Ingreso, 
    I.IFECHAING AS FechaIngreso, 
    L.UFUCODIGO AS CodUnidad, 
    U.UFUDESCRI AS UnidadFuncional, 
    L.CODPROSAL AS CodMedicoSolicita, 
    M.NOMMEDICO AS NombreMedicoSolicita, 
    L.FECORDMED AS FechaSolicitud, 
    L.CODSERIPS AS CodServicio, 
    S.DESSERIPS AS Servicio,
    CASE
        WHEN L.ESTSERIPS = '1'
        THEN 'Solicitado'
        WHEN L.ESTSERIPS = '2'
        THEN 'MuestraRecolectada'
        WHEN L.ESTSERIPS = '3'
        THEN 'ResultadoEntregado'
        WHEN L.ESTSERIPS = '4'
        THEN 'ExamenInterpretado'
        WHEN L.ESTSERIPS = '5'
        THEN 'Remitido'
        WHEN L.ESTSERIPS = '6'
        THEN 'Anulado'
        WHEN L.ESTSERIPS = '7'
        THEN 'Extramural'
        WHEN L.ESTSERIPS = '8'
        THEN 'MuestraRecolectadaParcialmente'
    END AS EstadoLaboratorio, 
    '' AS CODPROINT, 
    '' AS MedicoInterpreta, 
    L.FECRECMUE AS FechaRecoleccionMuestra, 
    L.INTERPRET AS Interpretacion, 
    Z.FECGENERA AS FechaEntregaResultado, 
    DATEDIFF(MINUTE, L.FECORDMED, L.FECRECMUE) AS TiempoToma1, 
    DATEDIFF(MINUTE, L.FECRECMUE, Z.FECGENERA) AS TiempoResultado, 
    DATEDIFF(MINUTE, L.FECORDMED, Z.FECGENERA) AS TiempoTotal, 
    '' AS Observacion, 
    '' AS Prioridad, 
    caa.CODCENATE AS Codcc, 
    caa.NOMCENATE AS CentroAtencion, 
    'Ambulatorio' AS Tipo
FROM [INDIGO031].[dbo].[AMBORDLAB] AS L
    INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS I  ON L.NUMINGRES = I.NUMINGRES
    INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS P  ON L.IPCODPACI = P.IPCODPACI
    INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS U  ON L.UFUCODIGO = U.UFUCODIGO
    INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS M  ON L.CODPROSAL = M.CODPROSAL
    INNER JOIN [INDIGO031].[dbo].[INCUPSIPS] AS S  ON L.CODSERIPS = S.CODSERIPS
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADNIVELED]  AS NE on  P.NIVCODIGO = NE.NIVECODIGO 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADGRUETNI] AS GE on  P.CODGRUPOE = GE.CODGRUPOE
    LEFT OUTER JOIN [INDIGO031].[dbo].[INTERCTRL] AS Z  ON L.AUTO = Z.AUTOLABOR
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADCENATEN] AS caa  ON caa.CODCENATE = L.CODCENATE
WHERE (L.FECORDMED >= '01/01/2022') and (I.IESTADOIN <> 'A'); 