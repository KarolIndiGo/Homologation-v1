-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_LIBROSINTOMATICOSRESPIRATORIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_LIBROSINTOMATICOSRESPIRATORIOS
AS
SELECT l.NUMINGRES AS Ingreso, 
    I.IFECHAING AS FechaIngreso, 
    U.UFUDESCRI AS Sede, 
    p.IPPRINOMB AS PrimerNombre, 
    p.IPSEGNOMB AS SegNombre, 
    p.IPPRIAPEL AS PrimerApellido, 
    p.IPSEGAPEL AS SegApellido, 
    RTRIM(LTRIM(p.IPPRINOMB)) + ' ' + RTRIM(LTRIM(p.IPSEGNOMB)) + ' ' + RTRIM(LTRIM(p.IPPRIAPEL)) + ' ' + p.IPSEGAPEL AS Paciente,
    CASE p.IPSEXOPAC
        WHEN 1
        THEN 'Masculino'
        WHEN 2
        THEN 'Femenino'
    END AS Sexo, 
    CONVERT(VARCHAR(10), p.IPFECNACI, 103) AS FechaNaciemiento, 
    2018 - YEAR(p.IPFECNACI) AS EdadAños,
    CASE IPTIPODOC
        WHEN 1
        THEN 'Cedula'
        WHEN 2
        THEN 'CedExtranjera'
        WHEN 3
        THEN 'TarjetaIdentidad'
        WHEN 4
        THEN 'RegistroCivil'
    END AS TipoDocumento, 
    l.IPCODPACI AS Cedula, 
    p.IPDIRECCI AS direccion, 
    p.IPTELMOVI AS movil, 
    s.CODSERIPS, 
    s.DESSERIPS AS Laboratorio, 
    l.FECORDMED AS FechaOrden, 
    dp.CODDIAGNO AS diagno, 
    dp.NOMDIAGNO AS Diagnostico
FROM [INDIGO031].[dbo].[HCORDLABO] AS l
    INNER JOIN [INDIGO031].[dbo].[INCUPSIPS] AS s ON l.CODSERIPS = s.CODSERIPS
    INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS p ON l.IPCODPACI = p.IPCODPACI
    INNER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS dp ON l.CODDIAGNO = dp.CODDIAGNO
    INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS I ON l.NUMINGRES = I.NUMINGRES
    INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS U ON l.UFUCODIGO = U.UFUCODIGO;
