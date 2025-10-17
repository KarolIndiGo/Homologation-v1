-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_HISTORIABAC
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_HISTORIABAC]
   
AS
    select 
	inp.CODPROSAL [Codigo Profesional],
       inp.NOMMEDICO [Nombre Bacteriologo],
	   inp.CODIGONIT [Documento Bacteriologo],
	   hca.FECHCONSU FechaConsulta,
	   hca.CODPACQCON [Documento Paciente]

from dbo.HCAUDITORIA HCA
right join dbo.INPROFSAL inp on inp.CODPROSAL = hca.CODUSUCONS
where CODESPEC1 = '185' and not CODPROSAL = '888' 


