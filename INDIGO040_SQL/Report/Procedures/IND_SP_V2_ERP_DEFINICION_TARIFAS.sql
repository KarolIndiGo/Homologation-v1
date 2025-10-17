-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_DEFINICION_TARIFAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_DEFINICION_TARIFAS] 
AS

SELECT Code,Name FROM Contract .DefinitionRate
WHERE Status =1