-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: DIM_SurgeryRoom
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [Report].[DIM_SurgeryRoom] as

SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 CONVERT(int, RTRIM(LTRIM(SAL.CODCONCEC))) [CODISALA],
 19 ID_TUNID_FUN,
 SAL.[DESCRIPSAL],
 convert(varchar,SAL.DISPHORINI,108) HORA_INI,
 convert(varchar,SAL.DISPHORFIN,108) HORA_FIN, 
 DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) [HORAS_DIARIAS],
 SAL.[LUN],
 SAL.[MAR],
 SAL.[MIE],
 SAL.[JUE],
 SAL.[VIE],
 SAL.[SAB],
 SAL.[DOM],
 ((DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) * SAL.[LUN]) +
  (DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) * SAL.[MAR]) +
  (DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) * SAL.[MIE]) +
  (DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) * SAL.[JUE]) +
  (DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) * SAL.[VIE]) +
  (DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) * SAL.[SAB]) +
  (DATEDIFF(HOUR, convert(varchar,SAL.DISPHORINI,108),convert(varchar,SAL.DISPHORFIN,108)) * SAL.[DOM])) * 4 [MIN_DISP_MENS],
  (YEAR(SAL.[DISPHORINI]) * 100) + MONTH(SAL.[DISPHORINI]) [ID_TIEMPO_INICIO],
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
 [dbo].[AGENSALAC] SAL
WHERE
 SAL.TIPOSALA = 'Q' AND
 SAL.ESTADO = 1
 UNION ALL
  SELECT
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
   0, 
   19 ID_TUNID_FUN,
   'NO APLICA',
   convert(varchar,GETDATE(),108),
   convert(varchar,GETDATE(),108),
   0, 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 'FALSE', 
   0 [MIN_DISP_MENS],
     (YEAR(GETDATE()) * 100)-10 + MONTH(GETDATE()-10) [ID_TIEMPO_INICIO],
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Report].[DIM_SurgeryRoom]') AND type in (N'U'))
--DROP EXTERNAL TABLE [Report].[DIM_SurgeryRoom]
--GO

--CREATE EXTERNAL TABLE [Report].[DIM_SurgeryRoom]
--(
--	[ID_COMPANY] [varchar](9) NULL,
--	[ID_TUNID_FUN] [int] NULL,
--	[CODISALA] [int] NULL,
--	[DESCRIPSAL] [varchar](100) NOT NULL,
--	[HORA_INI] [varchar](30) NULL,
--	[HORA_FIN] [varchar](30) NULL,
--	[HORAS_DIARIAS] [int] NULL,
--	[LUN] [bit] NOT NULL,
--	[MAR] [bit] NOT NULL,
--	[MIE] [bit] NOT NULL,
--	[JUE] [bit] NOT NULL,
--	[VIE] [bit] NOT NULL,
--	[SAB] [bit] NOT NULL,
--	[DOM] [bit] NOT NULL,
--	[MIN_DISP_MENS] [int] NULL,
--	[ID_TIEMPO_INICIO] [int] NULL,
--	[ULT_ACTUAL] [datetime] NULL
--)
--WITH (DATA_SOURCE = [INDIGO040],SCHEMA_NAME = N'Report',OBJECT_NAME = N'DIM_SurgeryRoom')
--GO

