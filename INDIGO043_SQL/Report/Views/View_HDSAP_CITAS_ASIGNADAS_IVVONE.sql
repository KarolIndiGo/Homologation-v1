-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CITAS_ASIGNADAS_IVVONE
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_CITAS_ASIGNADAS_IVVONE]
AS
select a.FECHORAIN FechaCita,
       pac.IPCODPACI DocumentoPaciente,
	   pac.IPNOMCOMP NombrePaciente,
	   case a.CODESTCIT
	   when 0
	   then 'Asignada'
	   when 1
	   then 'Cumplida'
	   when 2
	   then 'Incumplida'
	   when 3
	   then 'PreAsignada'
	   when 4
	   then 'Cita cancelada'
	   End EstadoCita,
	   case a.CODTIPCIT
	   when 0
	   then 'Primera Vez'
	   when 1
	   then 'Control'
	   when 2
	   then 'Pos Operatorio'
	   end TipoCita,
	   case a.CitaExtra
	   when 1
	   then 'Si'
	   when 0
	   then 'No'
	   End CitaExtra,
	   ine.NOMENTIDA Entidad,
	   inp.NOMMEDICO Medico


from AGASICITA a
join INPACIENT pac on pac.IPCODPACI = a.IPCODPACI
join INPROFSAL inp on inp.CODPROSAL = a.CODPROSAL
join INENTIDAD ine on ine.CODENTIDA = pac.CODENTIDA
where inp.CODPROSAL = 'me207'

