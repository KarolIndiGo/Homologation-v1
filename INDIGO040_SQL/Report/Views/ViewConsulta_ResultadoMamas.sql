-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewConsulta_ResultadoMamas
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[ViewConsulta_ResultadoMamas]
AS
     select * from [Report].[fnResultadoMamas](1)
