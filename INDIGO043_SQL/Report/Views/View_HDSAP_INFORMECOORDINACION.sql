-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INFORMECOORDINACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0










CREATE VIEW [Report].[View_HDSAP_INFORMECOORDINACION]
AS

select 
      i.IPCODPACI Identificacion,
	  i.IPNOMCOMP Nombre, 
      d.NUMINGRES Ingreso,
	  d.CODUSUCRE Cod_Usuario_Crea,
	  s.NOMUSUARI Nombre_Crea_Ingreso,
	  Su.NOMUSUARI Nombre_Modifica_Ingreso,
	  CASE IESTADOIN
	  WHEN ''
	  THEN 'ABIERTO'
	  WHEN 'P'
	  THEN 'PARCIAL'
	  WHEN 'F'
	  THEN 'FACTURADO'
	  END 'ESTADO INGRESO',
	  d.ifechaing FechaIngreso,
	  a.TRIAFECHA FechaTriage,
	  a.TRIAGECLA Triage,
	  n.ufucodigo,
	  n.UFUDESCRI UnidadIngreso,
	  case   	when cg.EntityType ='1' then 'EPS Contributivo' 
				when cg.EntityType = '2' then  'EPS Subsidiado' 
				when cg.EntityType = '3' then 'ET Vinculados Municipios'
				when cg.EntityType = '4' then 'ET Vinculados Departamentos' 
				when cg.EntityType = '5'  then 'ARL Riesgos Laborales' 
				when cg.EntityType = '6' then 'MP Medicina Prepagada' 
				when cg.EntityType = '7'  then 'IPS Privada' 
				when cg.EntityType = '8'  then 'IPS Publica' 
				when cg.EntityType = '9'  then 'Regimen Especial' 
				when cg.EntityType = '10'  then 'Accidentes de transito' 
				when cg.EntityType = '11'  then 'Fosyga' 
				when cg.EntityType = '12'  then 'Otros' 
				when cg.EntityType = '13'  then 'Aseguradoras' 
				when cg.EntityType = '99'  then 'Particulares'
				end as Regimen,
				ine.NOMENTIDA Entidad,
			d.IOBSERVAC ObservacionIngreso


from ADINGRESO d
LEFT join INPACIENT i on i.IPCODPACI = d.IPCODPACI
LEFT join INENTIDAD ine on ine.CODENTIDA = d.CODENTIDA
left join ADTRIAGEU a on d.NUMINGRES = a.NUMINGRES
LEFT join INUNIFUNC n on n.UFUCODIGO = d.UFUCODIGO
LEFT JOIN Contract.CareGroup CG ON CG.ID = d.GENCAREGROUP
LEFT JOIN Segusuaru S on S.codusuari = d.Codusucre
LEFT JOIN Segusuaru Su on Su.Codusuari = d.codusumod

--where d.numingres = '0000699185'



