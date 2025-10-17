-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_GRUPO_ATENCION_TARIFA
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_GRUPO_ATENCION_TARIFA]
AS



select c.code CodigoGrupo,
       c.name NombreGrupo, 
	   pr.name Tarifa,
	   CASE C.Status
	   WHEN 1
	   THEN 'Activo'
	   when 0
	   then 'Inactivo'
	   end EstadoGrupo

from Contract.CareGroup c
join Inventory.ProductRate pr on pr.id = c.ProductRateId


