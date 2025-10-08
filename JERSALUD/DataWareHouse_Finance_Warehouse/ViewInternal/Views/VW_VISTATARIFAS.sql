-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VISTATARIFAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view ViewInternal.VW_VISTATARIFAS
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
from INDIGO031.Contract.CareGroup cg
inner join INDIGO031.Contract.CareGroupDefinitionRate cdr on cg.Id = cdr.CareGroupId
inner join INDIGO031.Contract.DefinitionRate dr on dr.Id = cdr.DefinitionRateId
inner join INDIGO031.Contract.DefinitionRateDetail drd on drd.DefinitionRateId = dr.Id
left join INDIGO031.Contract.DefinitionRateDetailCondition drdc on drdc.DefinitionRateDetailId = drd.Id
left join INDIGO031.Contract.RateManual rm on rm.Id = drd.RateManualId
left join INDIGO031.Contract.RateManual rmd on rmd.Id = drdc.RateManualId
)