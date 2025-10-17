-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_DIM_CAMAS_UNIDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [Report].[View_DIM_CAMAS_UNIDADES] as

SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 CAM.CODICAMAS,
 CAM.DESCCAMAS,
 CAM.UFUCODIGO [ID_UFUN]
FROM
 dbo.CHCAMASHO CAM 
