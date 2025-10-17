-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_AUTORIZACION_FOMAG
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_AUTORIZACION_FOMAG]
AS


WITH EspecialidadReciente AS (
    SELECT 
        h.NUMINGRES,
        ine.DESESPECI AS [EspecialidadRemitente],
        ROW_NUMBER() OVER (PARTITION BY h.NUMINGRES ORDER BY h.FECHISPAC DESC) AS rn
    FROM 
        HCHISPACA h
    JOIN INESPECIA ine ON ine.CODESPECI = h.CODESPTRA

)

SELECT    
    DISTINCT
    CONVERT(VARCHAR, SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'SA Pacific Standard Time', 120) AS 'Fecha de Orden',
    h.NUMINGRES AS [Nro. Orden],
    CASE pac.IPTIPODOC
        WHEN '1' THEN 'CC'
        WHEN '2' THEN 'CE'
        WHEN '3' THEN 'TI'
        WHEN '4' THEN 'RC'
        WHEN '5' THEN 'PA'
        WHEN '6' THEN 'AS'
        WHEN '7' THEN 'MS'
        WHEN '8' THEN 'NU'
        WHEN '9' THEN 'CN'
        WHEN '11' THEN 'SC'
        WHEN '12' THEN 'PE'
        WHEN '13' THEN 'PT'
        WHEN '14' THEN 'DE'
        WHEN '15' THEN 'SI'
    END AS [Tipo Identificación del Afiliado],
    h.IPCODPACI AS [Numero de Identificación del Afiliado], 
    pac.IPPRINOMB AS [Primer Nombre],
    pac.IPSEGNOMB AS [Segundo Nombre],
    pac.IPPRIAPEL AS [Primer Apellido],
    pac.IPSEGAPEL AS [Segundo Apellido],
    pac.IPTELMOVI AS [Teléfono Celular],
    '' AS [Dirección de Correo Electrónico],
    V.CODDIAGNO AS [Código Diagnostico],
    '891180134' AS [NIT Prestador],
    '415510047901' AS [Código Prestador],
    'Hospital Departamental San Antonio de Pitalito' AS [Nombre Prestador],
    'Cc' AS [Tipo Identificación Medico],
    pro.CODIGONIT AS [Nro. Identificación Medico],
    pro.NOMMEDICO AS [Nombre Medico],
    er.[EspecialidadRemitente] AS [Especialidad Remitente],
    '' AS 'Código CUPS',
    'Manejo Integral Hospitalario' AS 'Descripción CUPS',
    '' AS 'Cantidad',
    '' AS 'Código CUMS',
    '' AS 'Descripción CUMS',
    '' AS 'Cantidad-',
    '' AS 'Justificación Clínica',
    CAST(i.IFECHAING AS DATE) AS [Fecha Atencion], 
    CONVERT(VARCHAR, CAST(i.IFECHAING AS TIME), 108) AS [Hora Atencion],
    pro.CODIGONIT AS Medico,
    '891180134' AS [NIT Prestador-],
    '415510047901' AS [Código Prestador-],
    'Hospital Departamental San Antonio de Pitalito' AS [Nombre Prestador-]

FROM CHCAMASHO AS C
INNER JOIN ADCENATEN AS CA ON CA.CODCENATE = C.CODCENATE
INNER JOIN INUNIFUNC AS UF ON UF.UFUCODIGO = C.UFUCODIGO
INNER JOIN CHREGESTA AS E ON E.CODICAMAS = C.CODICAMAS AND E.REGESTADO = '1'
INNER JOIN CHTIPESTA AS TE ON TE.CODTIPEST = E.CODTIPEST
INNER JOIN INPACIENT pac ON pac.IPCODPACI = E.IPCODPACI
INNER JOIN INPROFSAL pro ON pro.CODPROSAL = E.CODPROSAL
INNER JOIN HCHISPACA H ON H.NUMINGRES = E.NUMINGRES
INNER JOIN ADINGRESO AS I ON I.NUMINGRES = E.NUMINGRES
INNER JOIN INESPECIA ine ON ine.CODESPECI = h.CODESPTRA
INNER JOIN INPACIENT AS P ON P.IPCODPACI = E.IPCODPACI
INNER JOIN INENTIDAD AS A ON A.CODENTIDA = I.CODENTIDA
LEFT OUTER JOIN INDIAGNOS AS V ON V.CODDIAGNO = I.CODDIAING
INNER JOIN SEGusuaru AS US ON US.CODUSUARI = E.REGUSUARI
INNER JOIN EspecialidadReciente er ON er.NUMINGRES = h.NUMINGRES AND er.rn = 1
WHERE C.CODCENATE = '001' 
AND   C.ESTADCAMA = '2' 
AND   i.CODENTIDA = 'EA0534'
