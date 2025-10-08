-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_CITASMEDICAS_ODONTOSALUD
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_CITASMEDICAS_ODONTOSALUD
as
select * from [DataWareHouse_Clinical].[ViewInternal].[VW_IND_CITASMEDICAS]
where Especialidad = 'ODONTOLOGIA GENERAL'      