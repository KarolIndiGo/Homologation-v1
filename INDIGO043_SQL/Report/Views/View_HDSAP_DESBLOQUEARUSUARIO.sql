-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_DESBLOQUEARUSUARIO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_DESBLOQUEARUSUARIO]
AS


select NUMDOCUME NumeroDocumentoPaciente,
       pac.IPNOMCOMP NombrePaciente,
       CODUSUARI CodigoUsuario,
	   p.Fullname NombreUsurio

from INDOCUMEN i
join Security.[user] us on us.UserCode = i.CODUSUARI
join Security.Person p on p.id = us.IdPerson
join INPACIENT pac on pac.IPCODPACI = i.NUMDOCUME


