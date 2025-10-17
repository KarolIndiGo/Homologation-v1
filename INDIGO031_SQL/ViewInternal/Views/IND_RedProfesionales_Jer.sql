-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_RedProfesionales_Jer
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_RedProfesionales_Jer]
AS
SELECT DISTINCT TOP (100) PERCENT E.CODESPECI, E.DESESPECI, 'Red Interna' AS Red
FROM   dbo.HCHISPACA AS H INNER JOIN
             dbo.INPROFSAL AS M ON H.CODPROSAL = H.CODPROSAL AND M.ESTADOMED = 1 INNER JOIN
             dbo.INESPECIA AS E ON M.CODESPEC1 = E.CODESPECI AND E.ESTADO = 1
WHERE (H.FECHISPAC >= '01/01/2023')
