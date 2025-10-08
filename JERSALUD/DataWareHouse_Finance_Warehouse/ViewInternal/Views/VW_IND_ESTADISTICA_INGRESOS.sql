-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_IND_ESTADISTICA_INGRESOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_ESTADISTICA_INGRESOS
AS
SELECT CASE
        WHEN MONTH(I.IFECHAING) = 1
        THEN 'Ene'
        WHEN MONTH(I.IFECHAING) = 2
        THEN 'Feb'
        WHEN MONTH(I.IFECHAING) = 3
        THEN 'Mar'
        WHEN MONTH(I.IFECHAING) = 4
        THEN 'Abr'
        WHEN MONTH(I.IFECHAING) = 5
        THEN 'May'
        WHEN MONTH(I.IFECHAING) = 6
        THEN 'Jun'
        WHEN MONTH(I.IFECHAING) = 7
        THEN 'Jul'
        WHEN MONTH(I.IFECHAING) = 8
        THEN 'Agos'
        WHEN MONTH(I.IFECHAING) = 9
        THEN 'Sept'
        WHEN MONTH(I.IFECHAING) = 10
        THEN 'Oct'
        WHEN MONTH(I.IFECHAING) = 11
        THEN 'Nov'
        WHEN MONTH(I.IFECHAING) = 12
        THEN 'Dic'
    END AS Fecha,
    CASE
        WHEN I.UFUCODIGO LIKE 'B0%'
        THEN 'Boyaca'
        WHEN I.UFUCODIGO LIKE 'Met%'
        THEN 'Meta'
        WHEN I.UFUCODIGO LIKE 'Yop%'
        THEN 'Casanare'
    END AS Regional,
    CASE I.IESTADOIN
        WHEN 'F'
        THEN 'Facturado'
        WHEN 'A'
        THEN 'Anulado'
        WHEN 'P'
        THEN 'Corte'
        WHEN ''
        THEN 'Abierto'
        WHEN 'c'
        THEN 'Cerrado'
    END AS Estado, 
    COUNT(NUMINGRES) AS Cant
FROM [INDIGO031].[dbo].[ADINGRESO] AS I
WHERE(YEAR(IFECHAING) = '2020')
GROUP BY MONTH(IFECHAING), IESTADOIN, UFUCODIGO;
