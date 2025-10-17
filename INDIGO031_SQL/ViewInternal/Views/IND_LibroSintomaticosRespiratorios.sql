-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_LibroSintomaticosRespiratorios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_LibroSintomaticosRespiratorios]
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
     FROM dbo.HCORDLABO AS l
          INNER JOIN dbo.INCUPSIPS AS s ON l.CODSERIPS = s.CODSERIPS
          INNER JOIN dbo.INPACIENT AS p ON l.IPCODPACI = p.IPCODPACI
          INNER JOIN dbo.INDIAGNOS AS dp ON l.CODDIAGNO = dp.CODDIAGNO
          INNER JOIN dbo.ADINGRESO AS I ON l.NUMINGRES = I.NUMINGRES
          INNER JOIN dbo.INUNIFUNC AS U ON l.UFUCODIGO = U.UFUCODIGO;
