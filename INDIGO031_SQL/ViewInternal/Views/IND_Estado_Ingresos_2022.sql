-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Estado_Ingresos_2022
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Estado_Ingresos_2022]  
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
            I.IFECHAING AS FECHA_GRAL,   
            I.NUMINGRES AS INGRES,   
            I.IPCODPACI AS DOCUMENTO,  
            CASE  
                WHEN i.UFUCODIGO LIKE 'B0%'  
                THEN 'Boyaca'  
                WHEN i.UFUCODIGO LIKE 'Met%'  
                THEN 'Meta'  
                WHEN i.UFUCODIGO LIKE 'Yop%'  
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
     FROM dbo.ADINGRESO AS I  
     WHERE(YEAR(IFECHAING) = '2022')  
          --------OR (YEAR(IFECHAING) = '2020')  
     GROUP BY(IFECHAING),   
             IESTADOIN,   
             UFUCODIGO,   
             I.NUMINGRES,   
             I.IPCODPACI;  
