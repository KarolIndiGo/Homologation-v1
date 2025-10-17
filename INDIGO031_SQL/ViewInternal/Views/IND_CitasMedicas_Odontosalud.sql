-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_CitasMedicas_Odontosalud
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create view [ViewInternal].[IND_CitasMedicas_Odontosalud]
as
select * from[ViewInternal].[IND_CitasMedicas]
where Especialidad = 'ODONTOLOGIA GENERAL'      