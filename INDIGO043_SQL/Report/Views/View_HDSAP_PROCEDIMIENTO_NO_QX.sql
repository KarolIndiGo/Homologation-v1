-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PROCEDIMIENTO_NO_QX
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_PROCEDIMIENTO_NO_QX]
AS
select i.Code Codigo,
       i.Name Nombre,
       rd.SalesValue Valor,
	   rd.SalesValueWithSurcharge ValorConRecargo,
	   r.name NombreManualTarifario,
	   ce.Code CodigoCups,
                   ce.[Description] DescripcionCups

from Contract.IPSService i
join Contract.RateManualDetail rd on rd.IPSServiceId = i.Id
join Contract.RateManual r on r.Id = rd.RateManualId
join Contract.CupsHomologation cu on cu.IPSServiceId = i.Id
join Contract.CUPSEntity ce on ce.Id = cu.CupsEntityId
where r.Code in ('21','22','23')

