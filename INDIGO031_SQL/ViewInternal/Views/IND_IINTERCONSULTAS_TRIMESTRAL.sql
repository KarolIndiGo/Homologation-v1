-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IINTERCONSULTAS_TRIMESTRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_IINTERCONSULTAS_TRIMESTRAL]
AS
     SELECT IC.NUMINGRES AS Ingreso, 
            CA.NOMCENATE AS [Centro de Atencion], 
            IC.IPCODPACI AS [Documento Paciente], 
            PACI.IPNOMCOMP AS [Nombre Paciente], 
            IC.CODDIAGNO AS [Codigo Diagnostico], 
            DIAG.NOMDIAGNO AS [Nombre Diagnostico], 
            IC.CODPROSAL AS [Documento Profesional], 
            PROF.NOMMEDICO AS [Nombre Profesional], 
            IC.FECORDMED AS [Fecha Orden Medica], 
            IC.CODSERIPS AS CUPS, 
            IPS.DESSERIPS AS Remitido, 
            IC.CODESPECI AS [Codigo Especialidad], 
            ESP.DESESPECI AS [Nombre Especialidad]
     FROM dbo.HCORDINTE AS IC
          INNER JOIN dbo.INCUPSIPS AS IPS ON IC.CODSERIPS = IPS.CODSERIPS
          INNER JOIN dbo.ADCENATEN AS CA ON IC.CODCENATE = CA.CODCENATE
          INNER JOIN dbo.INPROFSAL AS PROF ON IC.CODPROSAL = PROF.CODPROSAL
          INNER JOIN dbo.INDIAGNOS AS DIAG ON IC.CODDIAGNO = DIAG.CODDIAGNO
          INNER JOIN dbo.INPACIENT AS PACI ON IC.IPCODPACI = PACI.IPCODPACI
          INNER JOIN dbo.INESPECIA AS ESP ON IC.CODESPECI = ESP.CODESPECI
     WHERE IC.FECORDMED >= DATEADD(MONTH, -3, GETDATE());
