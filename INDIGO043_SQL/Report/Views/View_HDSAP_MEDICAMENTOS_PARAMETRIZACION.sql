-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_MEDICAMENTOS_PARAMETRIZACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_MEDICAMENTOS_PARAMETRIZACION]
AS


select a.code CodigoMedicamento,
       a.Name NombreMedicamento,
	   a.Presentations Presentación,
	   a.Concentration Concentración,
	   a.StabilityMinimumHours HorasMinimaEstabilidad,
	   a.StabilityMaximumHours HorasMaximaEstabilidad,
	   case	   a.FormulationType 
	   when 1
	   then 'Peso'
	   when 2
	   then 'Volumen'
	   when 3
	   then 'Peso-Volumen'
	   when 4
	   then 'Unidad de administracion'
	   end TipoFormulación,
	   r.Name ViaAdministracion

	   
from inventory.ATC a
join Inventory.AdministrationRoute r on r.id = a.AdministrationRouteId
WHERE A.Status = 1

