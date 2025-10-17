-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Atencion_HC_CE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Atencion_HC_CE] AS
SELECT 
    i.NUMINGRES AS Ingreso, 
    ga.Code AS [Grupo Atención Ingreso], 
    ga.Name AS [Grupo Atención], 
    ea.Name AS Entidad, 
    p.IPCODPACI AS [Identificación Paciente],  -- << usa p.
    CASE p.IPTIPODOC 
        WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC'
        WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU'
        WHEN 9 THEN 'CN' WHEN 10 THEN 'CD' WHEN 11 THEN 'SC' WHEN 12 THEN 'PE'
    END AS TIPODOCUMENTO,
    CASE p.IPSEXOPAC WHEN 1 THEN 'H' WHEN 2 THEN 'M' END AS SEXO,
    p.IPPRINOMB AS [PRIMER NOMBRE],
    p.IPSEGNOMB AS [SEGUNDO NOMBRE],
    p.IPPRIAPEL AS [PRIMER APELLIDO],
    p.IPSEGAPEL AS [SEGUNDO APELLIDO],
    p.IPFECNACI AS FechaNacimiento,
    DATEDIFF(YEAR, p.IPFECNACI, i.IFECHAING) AS EdadEnAtencion, 
    M.MUNNOMBRE AS Municipio, 
    DP.nomdepart AS Dpto, 
    CAST(p.GENEXPEDITIONCITY AS VARCHAR(20)) + ' - ' + ISNULL(ci.Name, '') AS [Lugar expedición Vie], 
    i.IFECHAING AS Fecha_Ingreso, 
    i.IESTADOIN AS EstadoIngreso, 
    uf.UFUDESCRI AS Unidad_Funcional, 
    HCU.ENFACTUAL AS Enfermedad_Actual, 
    em.FECALTPAC AS [Fecha alta Médica], 
    HC.CODDIAGNO AS CIE_10, 
    CIE10.NOMDIAGNO AS Diagnóstico, 
    PROF.NOMMEDICO AS Medico, 
    ESP.DESESPECI AS Especialidad, 
    i.IOBSERVAC AS Observaciones,
    CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END AS TipoIngreso, 
    1 AS Cantidad, 
    EXF.TALLAPACI AS [Talla (cm)], 
    CONVERT(INT, ROUND(EXF.PESOPACIE / 1000, 0), 0) AS [Peso (kg)], 
    CONVERT(VARCHAR, EXF.TENARTSIS, 100) + '/' + CONVERT(VARCHAR, EXF.TENARTDIA, 100) AS TA, 
    EXF.NEOPERCEF AS PC, 
    EXF.NEOPERABD AS PA, 
    MHC.DESCRIPCION AS Modelo,
    CASE
        WHEN i.UFUCODIGO IN('B00001','B00002','B00003','B00004','B00005','B00006','B00007','B00008','B00017') THEN 'Boyaca'
        WHEN i.UFUCODIGO IN('MET001','MET002','MET003','MET004','MET005') THEN 'Meta'
        WHEN i.UFUCODIGO IN('YOP002') THEN 'Yopal'
    END AS Regional, 
    p.IPDIRECCI AS Direccion, 
    p.IPTELEFON AS Telefono, 
    p.IPTELMOVI AS Celular, 
    EXF.NEOPERCEF AS 'Solo para Neonatos - Perimetro Cefalico', 
    EXF.NEOPERTOR AS 'Solo para Neonatos - Perimetro Toraxico', 
    EXF.NEOPERABD AS 'Solo para Neonatos - Perimetro Abdominal', 
    EXF.TEMPERPAC AS 'Temperatura', 
    EXF.FRECARPAC AS 'Frecuencia Cardiaca', 
    EXF.FRERESPAC AS 'Frecuencia Respiratoria', 
    EXF.REGSO2PAC AS 'Saturacion de Oxigeno', 
    EXF.PB AS 'perímetro braquial', 
    EXF.DOLOR, 
    EXF.INTERPESOPARATALLA AS 'Interpretacion de la grafica peso para la talla', 
    EXF.INTERINDICEMASACO AS 'interpretacion de la grafica indice masa corporal', 
    EXF.INTERPESOPARAEDAD AS 'interpretacion de la grafica peso para la edad', 
    EXF.INTERPERIMETROCEFA AS 'interpretacion de la grafica perimetro cefalico', 
    EXF.INTERTALLAPARAEDAD AS 'interpretacion de la grafica talla para la edad', 
    EXF.INTERALTURAUTERINA AS 'interpretacion de la grafica altura uterina', 
    EXF.INTERIMCPARALAEDAD AS 'interpretacion de la grafica IMC para la edad', 
    ANTG.NOMSEMGES AS SEMANAS_GESTACIONALES, 
    DXS.DIAGNOSTICOS, 
    DXS.NOMBRE_DIAGNOSTICOS, 
    us.UserCode + '-' + pus.Fullname AS UsuarioCrea, 
    usm.UserCode + '-' + pusm.Fullname AS UsuarioModifica,
    pg.nombre AS 'Riesgo del programa',
    GE.GrupoEspecial AS [Grupos Poblacionales Especiales]
FROM dbo.ADINGRESO AS i WITH (NOLOCK)
INNER JOIN dbo.INUNIFUNC AS uf WITH (NOLOCK)        ON uf.UFUCODIGO = i.UFUCODIGO
INNER JOIN Contract.CareGroup AS ga WITH (NOLOCK)   ON ga.Id = i.GENCAREGROUP
INNER JOIN dbo.INPACIENT AS p WITH (NOLOCK)         ON p.IPCODPACI = i.IPCODPACI

-- Grupos especiales (preagregado por documento)
LEFT JOIN (
    SELECT
        x.IPCODPACI,
        GrupoEspecial = STUFF((
            SELECT DISTINCT ', ' + RTRIM(P.DESCRIPCION)
            FROM INDIGO031.dbo.ADPOBESPEPAC AS PE WITH (NOLOCK)
            INNER JOIN INDIGO031.dbo.ADPOBESPE    AS P  WITH (NOLOCK)
                ON P.ID = PE.IDADPOBESPE
            WHERE PE.ESTADO = '1'
              AND PE.IPCODPACI = x.IPCODPACI
            FOR XML PATH(''), TYPE
        ).value('.','nvarchar(max)'), 1, 2, '')
    FROM INDIGO031.dbo.ADPOBESPEPAC AS x WITH (NOLOCK)
    WHERE x.ESTADO = '1'
    GROUP BY x.IPCODPACI
) AS GE
    ON GE.IPCODPACI = p.IPCODPACI

LEFT  JOIN Contract.HealthAdministrator AS ea WITH (NOLOCK) ON ea.Id = i.GENCONENTITY
LEFT  JOIN Common.City AS ci WITH (NOLOCK)                  ON ci.Id = p.GENEXPEDITIONCITY
LEFT  JOIN Security.[User]   AS us   ON us.UserCode = i.CODUSUCRE
LEFT  JOIN Security.[Person] AS pus  ON pus.Id     = us.IdPerson
LEFT  JOIN Security.[User]   AS usm  ON usm.UserCode = i.CODUSUMOD
LEFT  JOIN Security.[Person] AS pusm ON pusm.Id    = usm.IdPerson

LEFT  JOIN dbo.HCHISPACA AS HC WITH (NOLOCK)
       ON HC.NUMINGRES = i.NUMINGRES 
      AND HC.IPCODPACI = p.IPCODPACI       -- << usa p.
      AND HC.TIPHISPAC = 'i'

LEFT  JOIN (
    SELECT d.IDHCHISPACA, e.VARIABLE, l.NOMBRE
    FROM dbo.EXAVALORES AS d 
    INNER JOIN dbo.EXAVARIABLESL AS l ON l.IDEXAVARIABLE = d.IDEXAVARIABLE AND l.ID = d.IDITEMLISTA
    INNER JOIN dbo.EXAVARIABLES  AS e ON e.id = d.IDEXAVARIABLE
    WHERE d.IDEXAGRUPO = '11' AND d.IDEXAVARIABLE = '142'
) AS pg
    ON pg.IDHCHISPACA = HC.ID

LEFT  JOIN dbo.HCURGING1 AS HCU  WITH (NOLOCK)
       ON HCU.NUMINGRES = HC.NUMINGRES 
      AND HCU.IPCODPACI = HC.IPCODPACI 
      AND HCU.NUMEFOLIO = HC.NUMEFOLIO

LEFT  JOIN dbo.INDIAGNOS AS CIE10 WITH (NOLOCK)
       ON CIE10.CODDIAGNO = HC.CODDIAGNO

LEFT  JOIN dbo.HCURGEVO1 AS HCU1 WITH (NOLOCK)
       ON HCU1.NUMINGRES = HC.NUMINGRES
      AND HCU1.IPCODPACI = HC.IPCODPACI
      AND HCU1.NUMEFOLIO = HC.NUMEFOLIO

LEFT  JOIN dbo.HCREGEGRE AS em WITH (NOLOCK)
       ON em.IPCODPACI = HC.IPCODPACI
      AND em.NUMINGRES = HC.NUMINGRES

INNER JOIN dbo.INUBICACI AS UB WITH (NOLOCK) ON p.AUUBICACI = UB.AUUBICACI
INNER JOIN dbo.INMUNICIP AS M WITH (NOLOCK)  ON UB.DEPMUNCOD = M.DEPMUNCOD
INNER JOIN dbo.INDEPARTA AS DP WITH (NOLOCK) ON M.DEPCODIGO = DP.depcodigo

INNER JOIN dbo.INPROFSAL AS PROF WITH (NOLOCK) ON HC.CODPROSAL = PROF.CODPROSAL
INNER JOIN dbo.INESPECIA AS ESP WITH (NOLOCK)  ON HC.CODESPTRA = ESP.CODESPECI

LEFT  JOIN dbo.HCEXFISIC AS EXF WITH (NOLOCK)
       ON EXF.IPCODPACI = p.IPCODPACI       -- << usa p.
      AND EXF.NUMINGRES = i.NUMINGRES

LEFT  JOIN dbo.PRMODELOHC AS MHC WITH (NOLOCK) ON HC.IDMODELOHC = MHC.ID
LEFT  JOIN dbo.HCANTGINE  AS ANTG WITH (NOLOCK)
       ON ANTG.NUMINGRES = HC.NUMINGRES
      AND ANTG.NUMEFOLIO = HC.NUMEFOLIO

INNER JOIN (
    SELECT t2.NUMEFOLIO, t2.NUMINGRES, t2.IPCODPACI, 
           DIAGNOSTICOS = STUFF((
                SELECT ', ' + CODDIAGNO
                FROM dbo.INDIAGNOP t1 
                WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')
           ), 1, 1, ''), 
           NOMBRE_DIAGNOSTICOS = STUFF((
                SELECT ', ' + LTRIM(RTRIM(NOMDIAGNO))
                FROM dbo.INDIAGNOP AS T1 
                INNER JOIN dbo.INDIAGNOS AS B ON B.CODDIAGNO = T1.CODDIAGNO
                WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')
           ), 1, 1, '')
    FROM dbo.INDIAGNOP t2 
    WHERE YEAR(t2.FECDIAGNO) >= 2023
    GROUP BY t2.NUMEFOLIO, t2.NUMINGRES, t2.IPCODPACI
) AS DXS 
    ON DXS.NUMINGRES = HC.NUMINGRES 
   AND DXS.NUMEFOLIO = HC.NUMEFOLIO

WHERE YEAR(i.IFECHAING) >= 2023;
