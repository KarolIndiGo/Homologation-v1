-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INVENTORY_MEDICAMENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.IMO_AD_Inventory_Medicamentos
AS

SELECT	atc.Code as [Código], atc.Name as Nombre, 
		dci.Code as [Código DCI], dci.Name as [DCI],
		atce.Code as [Código ATC], atce.Name as ATC,
		pg.Code+'-' + pg.Name as [Grupo Farmacologico],
		atc.AbbreviationName as [Abreviación],
		ar.Code+'-'+ar.Name as [Vía de Administración],
		atc.Presentations as Presentación,
		case atc.ProductNPT when 0 then 'No' when 1 then 'Si' end as [Producto NPT],
		atc.Concentration as Concentración,
		rl.Code+'-'+rl.Name as [Nivel de Riesgo],
		atc.StabilityMinimumHours as [Horas minimas Estabilidad],
		atc.StabilityMaximumHours as [Horas maximas Estabilidad],
		
		case atc.POSProduct when 0 then 'No' when 1 then 'Si' end as [Producto POS],
		case atc.AllPOSPathologies when 0 then 'No' when 1 then 'Si' end as [Totas las Patologias],
		bg.Name as GrupoNoPos,
		case atc.FormulationType when 1 then 'Peso'
		when 2 then 'Volumen'
		when 3 then 'Peso - Volumen'
		when 4 then 'Unidad de administración' end as [Tipo Fórmula],
		atc.Weight as [Peso], mup.Name as [Unidad Peso],
		atc.Volume as [Volume], muv.Name as [Unidad Volumen],
		mua.Name as [Unidad Administración],
		forma.Name as [Forma Farmaceutica],
		case atc.AutomaticCalculation when 0 then 'No' when 1 then 'Si' end as [Cálculo Automatico],
		case atc.TransferSurplusProduct when 0 then 'No' when 1 then 'Si' end as[Real. Traslado Sobrante],
		case atc.DiluentProduct when 0 then 'No' when 1 then 'Si' end as [Funciona como Diluyente],
		case atc.JustificationForSpecialDrugs when 0 then 'No' when 1 then 'Si' end as [Justifica Medicamentos Especiales],
		case atc.JustificationOfInputs when 0 then 'No' when 1 then 'Si' end as [Justificacion insumos/dispositivos], --
		case atc.IndicatorDrug when 0 then 'No' when 1 then 'Si' end as [Medicamento Trazador],
		case atc.Status when 0 then 'Inactivo' when 1 then 'Activo' end as Estado, 
		atc.CreationUser +'-'+ p.Fullname as [Usuario Crea], atc.CreationDate as [Fecha Creación],
		atc.ModificationUser +'-'+ pm.Fullname as [Usuario Modifica], atc.ModificationDate as [Fecha Modificación], atc.Id as ID,
		case atc.Consumption when 1 then 'Si' when 0 then 'No' end as DeConsumo
FROM	[INDIGO035].[Inventory].[ATC] as atc
left outer join [INDIGO035].[Inventory].[DCI] as dci on dci.Id=atc.DCIId
left outer join [INDIGO035].[Inventory].[AdministrationRoute] as ar on ar.Id=atc.AdministrationRouteId
left outer join [INDIGO035].[Inventory].[PharmacologicalGroup] as pg on pg.Id=atc.PharmacologicalGroupId
left outer join [INDIGO035].[Inventory].[InventoryRiskLevel] as rl on rl.Id=atc.InventoryRiskLevelId
left outer join [INDIGO035].[Inventory].[InventoryMeasurementUnit] as mup on mup.Id=atc.WeightMeasureUnit
left outer join [INDIGO035].[Inventory].[InventoryMeasurementUnit] as muv on muv.Id=atc.VolumeMeasureUnit
left outer join [INDIGO035].[Inventory].[InventoryMeasurementUnit] as mua on mua.Id=atc.AdministrationUnitId
left outer join [INDIGO035].[Inventory].[ATCEntity] as atce on atce.Id=atc.ATCEntityId
left outer join [INDIGO035].[Billing].[BillingGroup] as bg on bg.Id=atc.BillingGroupNoPosId
left outer join [INDIGO035].[Security].[UserInt] as u on u.UserCode=atc.CreationUser
left outer join [INDIGO035].[Security].[PersonInt] as p on p.Id=u.IdPerson
left outer join [INDIGO035].[Security].[UserInt] as  um on um.UserCode=atc.ModificationUser
left outer join [INDIGO035].[Security].[PersonInt] as pm on pm.Id=um.IdPerson
left outer join [INDIGO035].[Inventory].[PharmaceuticalForm] as forma on forma.Id=atc.PharmaceuticalFormId



