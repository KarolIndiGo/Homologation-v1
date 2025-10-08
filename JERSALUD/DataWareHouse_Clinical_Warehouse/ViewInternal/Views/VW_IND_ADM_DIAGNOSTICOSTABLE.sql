-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_ADM_DIAGNOSTICOSTABLE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_ADM_DIAGNOSTICOSTABLE
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
FROM [INDIGO031].[dbo].[INDIAGNOS];
