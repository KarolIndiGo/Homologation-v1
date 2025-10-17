-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_ADM_DiagnosticosTable
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_ADM_DiagnosticosTable]
AS
     SELECT CODDIAGNO, 
            NOMDIAGNO,
            CASE UNIEDADMI
                WHEN 1
                THEN 'Años'
                WHEN 2
                THEN 'Meses'
                WHEN 3
                THEN 'Dias'
            END AS UnidadMin, 
            EDADMINIM,
            CASE UNIEDADMA
                WHEN 1
                THEN 'Años'
                WHEN 2
                THEN 'Meses'
                WHEN 3
                THEN 'Dias'
            END AS UnidadMax, 
            EDADMAXIM,
            CASE APLICAMAS
                WHEN 0
                THEN 'No'
                WHEN 1
                THEN 'Si'
            END AS AplicaHombre,
            CASE APLICAFEM
                WHEN 0
                THEN 'No'
                WHEN 1
                THEN 'Si'
            END AS AplicaMujer,
            CASE EXIGENOTI
                WHEN 0
                THEN 'No'
                WHEN 1
                THEN 'Si'
            END AS ExigeNotificacion,
            CASE EGREDIAGNO
                WHEN 1
                THEN 'No'
                WHEN 0
                THEN 'Si'
            END AS PermiteEgreso_Como_DxPrincipal
     FROM dbo.INDIAGNOS;
