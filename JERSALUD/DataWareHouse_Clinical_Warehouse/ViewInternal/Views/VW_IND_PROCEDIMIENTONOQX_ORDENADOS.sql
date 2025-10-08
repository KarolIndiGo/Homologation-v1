-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_PROCEDIMIENTONOQX_ORDENADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_IND_PROCEDIMIENTONOQX_ORDENADOS]
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
     FROM INDIGO031.dbo.HCORDPRON AS IC
          INNER JOIN INDIGO031.dbo.INCUPSIPS AS IPS ON IC.CODSERIPS = IPS.CODSERIPS
          INNER JOIN INDIGO031.dbo.ADCENATEN AS CA ON IC.CODCENATE = CA.CODCENATE
          INNER JOIN INDIGO031.dbo.INPROFSAL AS PROF ON IC.CODPROSAL = PROF.CODPROSAL
          INNER JOIN INDIGO031.dbo.INDIAGNOS AS DIAG ON IC.CODDIAGNO = DIAG.CODDIAGNO
          INNER JOIN INDIGO031.dbo.INPACIENT AS PACI ON IC.IPCODPACI = PACI.IPCODPACI
     WHERE(IC.CODCENATE IN('002', '003', '004', '005', '006', '007', '008', '009'));
