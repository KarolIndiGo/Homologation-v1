-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VariablesNotaAdministrativaGrupo2
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VariablesNotaAdministrativaGrupo2]
as
select vari.id as VariID, variable, CASE WHEN  vard.NOMBRE IS NOT NULL THEN vard.NOMBRE ELSE d.valor END AS Valor , D.IDNTNOTASADMINISTRATIVASC
	from [Dbo].[NTNOTASADMINISTRATIVASD] AS D WITH (NOLOCK)
	inner join [Dbo].NTVARIABLES as vari WITH (NOLOCK) on vari.id=d.IDNTVARIABLE
	left outer join [Dbo].NTVARIABLESL as vard WITH (NOLOCK) on vard.id=d.iditemlista
	WHERE D.IDGRUPO=2
