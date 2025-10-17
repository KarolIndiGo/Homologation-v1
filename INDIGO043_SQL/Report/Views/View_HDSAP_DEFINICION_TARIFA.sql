-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_DEFINICION_TARIFA
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_DEFINICION_TARIFA]
AS

select cups.Code CodigoCupsTarifa,
	   cups.[Description] NombreCupsTarifa,
	   dr.code CodigoTarifa,
       dr.name NombreTarifa,
	   dr.[Description] DescripcionTarifa,
	   cg.Code CodigoGrupo,
	   cg.name NombreGrupo,
	   cs.Code CodigoSubGrupo,
	   cs.Name NombreSubGrupo,
	   case drd.ruletype
	   when 1 
	   then 'Servicio IPS' 
	   when 2 
	   then 'CUPS'
	   when 3 
	   then 'SubGrupos CUPS'
	   when 4 
	   then 'Grupo CUPS'
	   when 5 
	   then 'General'
	   end 'Tipo Regla',
	   case drd.ConditionType
	   when 1 
	   then 'Horario' 
	   when 2 
	   then 'Especialidad'
	   when 3 
	   then 'Unidad Funcional'
	   when 4 
	   then 'Tipo de Unidad'
	   when 5 
	   then 'Ninguna'
	   end 'Tipo Condicion'


from Contract.CUPSEntity cups 
join Contract.DefinitionRateDetail drd on drd.CUPSEntityId = cups.id
join Contract.DefinitionRate dr on dr.id = drd.DefinitionRateId
left join Contract.CupsSubgroup  cs on cs.id = cups.CUPSSubGroupId
left join Contract.CupsGroup cg on cg.id = cs.CupsGroupId
where dr.Status = 1

  

