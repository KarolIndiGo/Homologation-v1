-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewConsultaSQL
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE view [Report].[ViewConsultaSQL] as
WITH CTE_CONSULTAS AS
 (
  SELECT 
   DB_NAME (req.database_id) BD,
   USER_NAME (user_id) usuario,
   req.session_id, 
   CONVERT(DATETIME,req.start_time AT TIME ZONE 'Pakistan Standard Time',1) AS 'start_time',
   cpu_time 'cpu_time_ms',
   object_name(st.objectid,st.dbid) 'ObjectName', 
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(substring
    (REPLACE
	 (REPLACE
	  (SUBSTRING
	   (ST.text,
	    (req.statement_start_offset/2) + 1, 
		 ((CASE statement_end_offset
		    WHEN -1 THEN DATALENGTH(ST.text)  
			ELSE req.statement_end_offset END - req.statement_start_offset)/2) + 1), CHAR(10), ' '), CHAR(13), ' '), 1, 20000)),']',''),'[',''),'.',''),'(',''),')',''),CHAR(9),''),'  ',' '),'  ',' '),'   ',' '), 'STAGINGPUBLIC_V3','') AS statement_text,
   substring
      (REPLACE
        (REPLACE
          (SUBSTRING
            (ST.text
            , (req.statement_start_offset/2) + 1
            , (
               (CASE statement_end_offset
                  WHEN -1
                  THEN DATALENGTH(ST.text)  
                  ELSE req.statement_end_offset
                  END
                    - req.statement_start_offset)/2) + 1)
       , CHAR(10), ' '), CHAR(13), ' '), 1, 20000)  AS statement_text_org,
   CASE req.lock_timeout 
    WHEN -1 THEN 'NO'
	ELSE 'SI' END TIME_OUT,
   req.blocking_session_id sesion_bloqueo
  FROM 
   sys.dm_exec_requests AS req  
   CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) as ST
 )


SELECT
 ISNULL(BD,CAST(DB_NAME() AS VARCHAR(16))) BD,
 usuario,
 session_id,
 start_time,
 [cpu_time_ms] [cpu_time_ms],
 [cpu_time_ms]/60000 [cpu_time_min],
 ISNULL(ObjectName,'NO TIENE') ObjectName,
 IIF(CHARINDEX('[$Table]',[statement_text_org],1) <> 0 OR CHARINDEX('[_].',[statement_text_org],1) <> 0,'SI','NO') SYNC,
 SUBSTRING(statement_text, 
           CHARINDEX('FROM REPORT', statement_text) + 11, 
		   ABS((CHARINDEX (' ', statement_text, CHARINDEX('FROM REPORT', statement_text) +11)) - (CHARINDEX('FROM REPORT', statement_text) + 11))) VISTA,
 statement_text_org statement_text,
 TIME_OUT,
 sesion_bloqueo,
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
 CTE_CONSULTAS
WHERE
  SUBSTRING(statement_text, 
           CHARINDEX('FROM REPORT', statement_text) + 11, 
		   ABS(CHARINDEX (' ', statement_text, CHARINDEX('FROM REPORT', statement_text) +11) - CHARINDEX('FROM REPORT', statement_text) + 11)) NOT IN ('CONSULTASQL')
