-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Laboratorios_Ordenados_General
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Laboratorios_Ordenados_General]
AS
     SELECT DISTINCT 
            O.FECORDMED AS FechaOrden, 
            O.IPCODPACI AS Documento, 
            P.IPNOMCOMP AS Paciente, 
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS Fijo, 
            P.IPTELMOVI AS Celular, 
            CONVERT(VARCHAR(10), P.IPFECNACI, 101) AS FechaNacimient, 
            CAST(DATEDIFF(dd, P.IPFECNACI, O.FECORDMED) / 365.25 AS INT) AS EDADATENCION, 
            O.NUMINGRES AS Ingreso, 
            CA.NOMCENATE AS CentroAtencion, 
            U.UFUDESCRI AS Unidad, 
            O.CODPROSAL AS CodProfesional, 
            PROF.NOMMEDICO AS Profesional, 
            O.CODSERIPS AS CUPS, 
            C.DESSERIPS AS Servicio, 
            O.CANSERIPS AS Cant, 
            O.CODDIAGNO AS Cie10, 
            Dx.NOMDIAGNO AS Diagnostico
     FROM dbo.HCORDLABO AS O
          INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = O.IPCODPACI
          INNER JOIN dbo.INCUPSIPS AS C ON C.CODSERIPS = O.CODSERIPS
          INNER JOIN dbo.INPROFSAL AS PROF ON O.CODPROSAL = PROF.CODPROSAL
          INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = O.CODCENATE
          INNER JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = O.UFUCODIGO
          INNER JOIN dbo.INDIAGNOS AS Dx ON O.CODDIAGNO = Dx.CODDIAGNO;  
