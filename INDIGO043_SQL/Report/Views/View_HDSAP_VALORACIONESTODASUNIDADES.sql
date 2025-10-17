-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_VALORACIONESTODASUNIDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_VALORACIONESTODASUNIDADES]
AS


SELECT H.IPCODPACI AS Identificación, 
       PT.IPNOMCOMP AS Paciente, 
       H.NUMINGRES AS Ingreso, 
       H.FECHISPAC AS Fecha, 
       H.FECHISPAC AS Hora, 
       H.CODPROSAL AS Código, 
       H.NUMEFOLIO AS Folio, 
       P.NOMMEDICO AS Médico,
       CASE
           WHEN H.TIPHISPAC = 'I'
           THEN 'Ingreso'
           WHEN H.TIPHISPAC = 'E'
           THEN 'Evolución'
           WHEN H.TIPHISPAC = 'N'
           THEN 'Nota'
		   WHEN H.TIPHISPAC = 'P'
           THEN 'Atencion Inicial del Parto'
		   WHEN H.TIPHISPAC = 'B'
           THEN 'Atencion del Recien Nacido'
		   WHEN H.TIPHISPAC = 'S'
           THEN 'Notas Servicios de Apoyo'
		   WHEN H.TIPHISPAC = 'T'
           THEN 'Notas Ingreso a UCI'
		   WHEN H.TIPHISPAC = 'V'
           THEN 'Notas Valoracion de Recien Nacido'
       END AS TipoHC, 
       H.UFUCODIGO AS UnidadF, 
       UF.UFUDESCRI AS UnidadFuncional, 
       H.CODDIAGNO AS CodDx, 
       V.NOMDIAGNO AS Dx, 
       INESPECIA.DESESPECI AS Esp_tratante, 
       E.DESESPECI AS Esp1, 
       INESPECIA_1.DESESPECI AS Esp2, 
       UF.UFUDESCRI AS [Unidad Responde]
FROM dbo.HCHISPACA AS H
     INNER JOIN dbo.INUNIFUNC AS UF ON H.UFUCODIGO = UF.UFUCODIGO
     INNER JOIN dbo.INPROFSAL AS P ON H.CODPROSAL = P.CODPROSAL
     INNER JOIN dbo.INESPECIA AS E ON P.CODESPEC1 = E.CODESPECI
     INNER JOIN dbo.INDIAGNOS AS V ON V.CODDIAGNO = H.CODDIAGNO
     INNER JOIN dbo.INESPECIA ON H.CODESPTRA = INESPECIA.CODESPECI
     INNER JOIN dbo.INPACIENT AS PT ON H.IPCODPACI = PT.IPCODPACI
     LEFT OUTER JOIN dbo.INESPECIA AS INESPECIA_1 ON P.CODESPEC2 = INESPECIA_1.CODESPECI

