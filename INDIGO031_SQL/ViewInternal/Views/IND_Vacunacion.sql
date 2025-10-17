-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Vacunacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_Vacunacion]
AS
     SELECT VAC.IPCODPACI AS Identificacion, 
            P.IPNOMCOMP AS Paciente, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS EdadActual, 
            DATEDIFF(year, P.IPFECNACI, VAC.FECAPLVAC) AS EdadEnAtencion, 
            VAC.IDPLAVACU AS CodigoVacuna, 
            INVAC.TIPVACUNA AS Vacuna, 
            INVAC.NUMDOSISV AS Dosis, 
            INVAC.EDAREGVAC AS RangoEdadVacuna, 
            VAC.FECAPLVAC AS FechaAplicacion, 
            VAC.OBSVACUNA AS Observaciones, 
            VAC.LOTEDOSIS AS LoteDosis, 
            VAC.LOTEJERINGA AS LoteJeringa, 
            INVAC.ESTPLAVAC AS EstadoVacuna, 
            CA.NOMCENATE AS CentroAtencion, 
            VAC.USUREGISTRA AS UsuarioRegistra,
            CASE VAC.APLICADA
                WHEN 0
                THEN 'No Aplicada'
                WHEN 1
                THEN 'Aplicada'
            END AS VacunaAplicada, 
            VAC.NUMINGRES AS Ingreso, 
            'Esquema Vacunacion' AS Modulo
     FROM dbo.HCPLANVAC AS VAC 
          INNER JOIN dbo.INPLANVAC AS INVAC  ON INVAC.IDPLAVACU = VAC.IDPLAVACU
          LEFT JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = VAC.CODCENATE
          INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = VAC.IPCODPACI
     UNION
     SELECT VACAD.IPCODPACI AS Identificacion, 
            P.IPNOMCOMP AS Paciente, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS EdadActual, 
            DATEDIFF(year, P.IPFECNACI, VACAD.FECHAPLICAVAC) AS EdadEnAtencion, 
            VACAD.IDVACUNA AS CodigoVacunacion, 
            INVACAD.NOMBRE AS Vacuna, 
            VACAD.DOSIS AS Dosis, 
            INVACAD.EDADAPLICA_A AS RangoEdadVacuna, 
            VACAD.FECHAPLICAVAC AS FechaAplicacion, 
            VACAD.OBSVACUNA AS Observaciones, 
            VACAD.LOTEDOSIS AS LoteDosis, 
            VACAD.LOTEJERINGA AS LoteJeringa,
            CASE INVACAD.ESTADO
                WHEN 1
                THEN 'Activa'
                WHEN 2
                THEN 'Inactiva'
            END AS EstadoVacuna, 
            CA.NOMCENATE AS CentroAtencion, 
            '' AS UsuarioRegistra,
            CASE VACAD.APLICADA
                WHEN 0
                THEN 'No Aplicada'
                WHEN 1
                THEN 'Aplicada'
            END AS VacunaAplicada, 
            VACAD.NUMINGRES AS Ingreso, 
            'Esquema Vacunacion Adicional' AS Modulo
     FROM dbo.HCVACADIPAC AS VACAD 
          INNER JOIN dbo.HCVACUADI AS INVACAD  ON INVACAD.ID = VACAD.IDVACUNA
          LEFT JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = VACAD.CODCENATE
          INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = VACAD.IPCODPACI
 
