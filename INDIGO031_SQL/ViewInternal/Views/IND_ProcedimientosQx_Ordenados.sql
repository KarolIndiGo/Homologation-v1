-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_ProcedimientosQx_Ordenados
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_ProcedimientosQx_Ordenados]
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
            IPS.DESSERIPS AS Remitido
     FROM dbo.HCORDPROQ AS IC
          INNER JOIN dbo.INCUPSIPS AS IPS ON IC.CODSERIPS = IPS.CODSERIPS
          INNER JOIN dbo.ADCENATEN AS CA ON IC.CODCENATE = CA.CODCENATE
          INNER JOIN dbo.INPROFSAL AS PROF ON IC.CODPROSAL = PROF.CODPROSAL
          INNER JOIN dbo.INDIAGNOS AS DIAG ON IC.CODDIAGNO = DIAG.CODDIAGNO
          INNER JOIN dbo.INPACIENT AS PACI ON IC.IPCODPACI = PACI.IPCODPACI
     WHERE(IC.CODCENATE IN('002', '003', '004', '005', '006', '007', '008', '009'));
