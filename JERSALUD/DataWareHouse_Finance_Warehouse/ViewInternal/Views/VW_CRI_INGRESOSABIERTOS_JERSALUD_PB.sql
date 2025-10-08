-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_CRI_INGRESOSABIERTOS_JERSALUD_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_CRI_INGRESOSABIERTOS_JERSALUD_PB 
AS

SELECT DISTINCT
    i.CODCENATE,
    CASE i.CODCENATE
        WHEN '001' THEN 'BOGOTA'
        WHEN '002' THEN 'TUNJA'
        WHEN '003' THEN 'DUITAMA'
        WHEN '004' THEN 'SOGAMOSO'
        WHEN '005' THEN 'CHIQUINQUIRA'
        WHEN '006' THEN 'GARAGOA'
        WHEN '007' THEN 'GUATEQUE'
        WHEN '008' THEN 'SOATA'
        WHEN '009' THEN 'MONIQUIRA'
        WHEN '010' THEN 'VILLAVICENCIO'
        WHEN '011' THEN 'ACACIAS'
        WHEN '012' THEN 'GRANADA'
        WHEN '013' THEN 'PUERTO LOPEZ'
        WHEN '014' THEN 'PUERTO GAITAN'
        WHEN '015' THEN 'YOPAL'
        WHEN '016' THEN 'VILLANUEVA                                                                                 '
        WHEN '017' THEN 'PUERTO BOYACA'
        WHEN '018' THEN 'SAN MARTIN'
        WHEN '019' THEN 'PAZ DE ARIPORO'
        WHEN '020' THEN 'AGUAZUL'
        WHEN '021' THEN 'MIRAFLORES'
    END AS Sede,
    i.NUMINGRES AS Ingreso,
    ga.Code AS [Grupo Atención Ingreso],
    ga.Name AS [Grupo Atención],
    t.Nit,
    t.Name AS Entidad,
    i.IPCODPACI AS [Identificación Paciente],
    p.IPNOMCOMP AS [Nombre Paciente],
    p.IPEXPEDIC AS [Lugar Expedición antes Vie],
    CAST(p.GENEXPEDITIONCITY AS varchar(20)) + ' - ' + ISNULL(ci.Name, '') AS [Lugar expedición Vie],
    i.IFECHAING AS Fecha_Ingreso,
    i.IESTADOIN AS Estado,
    i.UFUCODIGO AS CodUF,
    uf.UFUDESCRI AS Unidad_Funcional,
    em.FECALTPAC AS [Fecha alta Médica],
    HC.CODDIAGNO AS CIE_10,
    CIE10.NOMDIAGNO AS Diagnóstico,
    u.NOMUSUARI AS Usuario,
    uu.NOMUSUARI AS UsuarioModifico,
    D.UFUDESCRI AS UnidadActual,
    i.IOBSERVAC AS Observaciones,
    CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END AS TipoIngreso,
    CASE WHEN em.FECALTPAC IS NULL THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso
FROM
    [INDIGO031].[dbo].[ADINGRESO] AS i
    INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS uf ON uf.UFUCODIGO = i.UFUCODIGO
    LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS u ON u.CODUSUARI = i.CODUSUCRE
    LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS ea ON ea.Id = i.GENCONENTITY
    LEFT OUTER JOIN INDIGO031.Common.ThirdParty AS t ON t.Id = ea.ThirdPartyId
    LEFT OUTER JOIN [INDIGO031].[dbo].[INPACIENT] AS p ON p.IPCODPACI = i.IPCODPACI
    LEFT OUTER JOIN INDIGO031.Contract.CareGroup AS ga ON ga.Id = i.GENCAREGROUP
    LEFT OUTER JOIN INDIGO031.Common.City AS ci ON ci.Id = p.GENEXPEDITIONCITY
    LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS uu ON uu.CODUSUARI = i.CODUSUMOD
    LEFT OUTER JOIN [INDIGO031].[dbo].[HCHISPACA] AS HC ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i'
    LEFT OUTER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS CIE10 ON CIE10.CODDIAGNO = HC.CODDIAGNO
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADINGRESO] AS I2 ON I2.NUMINGRES = i.NUMINGRES
    LEFT OUTER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS D ON I2.UFUAACTHOS = D.UFUCODIGO
    LEFT OUTER JOIN [INDIGO031].[dbo].[HCREGEGRE] AS em ON em.IPCODPACI = i.IPCODPACI AND em.NUMINGRES = i.NUMINGRES
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CE ON CE.CODCENATE = i.CODCENATE
WHERE
    (i.IESTADOIN <> 'F')
    AND (i.IESTADOIN <> 'A')
    AND (i.IESTADOIN <> 'C')
    AND i.IPCODPACI <> '9999999'