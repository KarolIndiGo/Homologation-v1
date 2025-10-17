-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Estado_Ingresos_trimestral
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Estado_Ingresos_trimestral]
as
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
			ga.Code AS [Grupo Atención Ingreso],   
			ga.Name AS [Grupo Atención],   

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
     FROM dbo.ADINGRESO AS I INNER JOIN  
	   Contract.CareGroup AS ga  ON ga.Id = i.GENCAREGROUP 
     ------WHERE(YEAR(IFECHAING) = '2022') and MONTH(IFECHAING) >='9' 
     WHERE i.IFECHAING >= DATEADD(MONTH, -3, GETDATE())
     GROUP BY(IFECHAING),     
             IESTADOIN,     
             UFUCODIGO,     
             I.NUMINGRES,     
             I.IPCODPACI, 
			 ga.Code,
			 ga.Name;
