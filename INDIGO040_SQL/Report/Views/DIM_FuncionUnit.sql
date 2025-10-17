-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: DIM_FuncionUnit
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[DIM_FuncionUnit] as
SELECT 
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
  CONVERT(int, LTRIM(RTRIM(UNI.Code))) [ID_UFUN],
  UNI.Name [NOM_UFUN],
  CASE 
   WHEN UNI.UnitType=25 THEN 30
   ELSE UNI.UnitType
  END [ID_TUNID_FUN],
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL 
FROM
 Payroll.FunctionalUnit UNI
UNION ALL
 SELECT
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
  999999, 'CAPITA', 30,
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL 

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Report].[DIM_FuncionUnit]') AND type in (N'U'))
--DROP EXTERNAL TABLE [Report].[DIM_FuncionUnit]
--GO

--CREATE EXTERNAL TABLE [Report].[DIM_FuncionUnit]
--(
--	[ID_COMPANY] [varchar](9) NULL,
--	[ID_UFUN] [int] NULL,
--	[NOM_UFUN] [char](60) NOT NULL,
--	[ID_TUNID_FUN] [int] NULL,
--	[ULT_ACTUAL] [datetime] NULL
--)
--WITH (DATA_SOURCE = [INDIGO040],SCHEMA_NAME = N'Report',OBJECT_NAME = N'DIM_FuncionUnit')
--GO

