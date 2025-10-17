-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaTarifas
-- Extracted by Fabric SQL Extractor SPN v3.9.0




create view [ViewInternal].[VistaTarifas]
as
(
select
cg.Code as CodigoGrupoAtencion,
cg.Name as NombreGrupoAtencion,
cdr.InitialDate as FechaInicial,
cdr.EndDate as FechaFinal,
dr.Code as CodigoTarifa,
dr.Name as NombreTarifa,
dr.Description as DescripcionTarifa,
case drd.RuleType when 1 then 'Servicio IPS' when 2 then 'CUPS' when 3 then 'SubGrupos' when 4 then 'Grupos' when 5 then 'General' end as Regla,
case drd.ConditionType when 1 then 'Horario' when 2 then 'Especialidad' when 3 then 'Unidad Funcional' when 4 then 'Tipo Unidad' when 5 then 'Ninguna' end as Condicion,
case drd.ConditionType when 5 then rm.Name else rmd.Name end as ManualTarifario,
case drd.ConditionType when 5 then drd.RateVariation else drdc.RateVariation end as Variacion,
case drd.ConditionType when 5 then drd.SalesValue else drdc.SalesValue end as ValorFijo
from Contract.CareGroup cg
inner join Contract.CareGroupDefinitionRate cdr on cg.Id = cdr.CareGroupId
inner join Contract.DefinitionRate dr on dr.Id = cdr.DefinitionRateId
inner join Contract.DefinitionRateDetail drd on drd.DefinitionRateId = dr.Id
left join Contract.DefinitionRateDetailCondition drdc on drdc.DefinitionRateDetailId = drd.Id
left join Contract.RateManual rm on rm.Id = drd.RateManualId
left join Contract.RateManual rmd on rmd.Id = drdc.RateManualId
)






