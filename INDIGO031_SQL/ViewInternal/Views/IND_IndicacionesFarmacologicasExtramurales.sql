-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicacionesFarmacologicasExtramurales
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_IndicacionesFarmacologicasExtramurales]
AS
     SELECT DISTINCT 
            O.FECHAORDE AS FechaOrden, 
            O.IPCODPACI AS Documento, 
            P.IPNOMCOMP AS Paciente, 
            O.NUMINGRES AS Ingreso, 
            O.INDFAREXT AS Medicamentos_Extramurales, 
            PR.CODPROSAL AS CodProf, 
            PR.NOMMEDICO AS Medico, 
            E.DESESPECI AS Especialidad, 
            C.NOMCENATE AS Sede, 
            P.IPDIRECCI, 
            P.IPTELEFON, 
            P.IPTELMOVI, 
            P.IPFECNACI, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS EDAD
     FROM dbo.HCPRESCRC AS O
          INNER JOIN dbo.INPACIENT AS P ON O.IPCODPACI = P.IPCODPACI
          INNER JOIN dbo.ADCENATEN AS C ON O.CODCENATE = C.CODCENATE
          INNER JOIN dbo.INPROFSAL AS PR ON O.CODPROSAL = PR.CODPROSAL
          INNER JOIN dbo.INESPECIA AS E ON PR.CODESPEC1 = E.CODESPECI
     WHERE O.INDFAREXT <> ''
           AND --O.IPCODPACI='20439282'
           --O.FECHAORDE BETWEEN '2020-01-30' AND '2020-02-01'
           O.FECHAORDE >= DATEADD(MONTH, -3, GETDATE());
