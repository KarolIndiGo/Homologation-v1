-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewConsultaTamano
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [Report].[ViewConsultaTamano] as
SELECT CAST(DB_NAME() AS VARCHAR(16)) AS ID_COMPANY, 
       YEAR(GETDATE()) AS 'AÑO',
       CONCAT(FORMAT(MONTH(GETDATE()), '00') ,' - ', 
	   CASE MONTH(GETDATE()) 
	    WHEN 1 THEN 'ENERO'
   	    WHEN 2 THEN 'FEBRERO'
	    WHEN 3 THEN 'MARZO'
	    WHEN 4 THEN 'ABRIL'
	    WHEN 5 THEN 'MAYO'
	    WHEN 6 THEN 'JUNIO'
	    WHEN 7 THEN 'JULIO'
	    WHEN 8 THEN 'AGOSTO'
	    WHEN 9 THEN 'SEPTIEMBRE'
	    WHEN 10 THEN 'OCTUBRE'
	    WHEN 11 THEN 'NOVIEMBRE'
	    WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE',
	  --OBJECT_NAME(t.object_id) AS ObjectName,
       SUM(u.total_pages) * 8 AS Total_Reserved_kb,
       (SUM(u.total_pages) * 8) * 0.000001 AS Total_Reserved_GB,
       SUM(u.used_pages) * 8 AS Used_Space_kb,
       (SUM(u.used_pages) * 8) * 0.000001  AS Used_Space_GB,
       u.type_desc AS TypeDesc,
       MAX(p.rows) AS RowsCount
FROM 
 sys.allocation_units AS u
 JOIN sys.partitions AS p ON u.container_id = p.hobt_id
 JOIN sys.tables AS t ON p.object_id = t.object_id
GROUP BY u.type_desc--, OBJECT_NAME(t.object_id)
HAVING SUM(u.used_pages) * 8 <> 0
