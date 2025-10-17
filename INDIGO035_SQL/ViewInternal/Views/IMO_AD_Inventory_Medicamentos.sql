-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_Inventory_Medicamentos
-- Extracted by Fabric SQL Extractor SPN v3.9.0





create VIEW [ViewInternal].[IMO_AD_Inventory_Medicamentos] as

SELECT	atc.code as [Código], atc.name as Nombre, 
		dci.code as [Código DCI], dci.name as [DCI],
		atce.code as [Código ATC], atce.name as ATC,
		pg.code+'-' + pg.name as [Grupo Farmacologico],
		atc.abbreviationname as [Abreviación],
		ar.code+'-'+ar.name as [Vía de Administración],
		atc.Presentations as Presentación,
		case atc.productNPT when 0 then 'No' when 1 then 'Si' end as [Producto NPT],
		atc.Concentration as Concentración,
		rl.code+'-'+rl.name as [Nivel de Riesgo],
		atc.StabilityMinimumHours as [Horas minimas Estabilidad],
		atc.StabilityMaximumHours as [Horas maximas Estabilidad],
		
		case atc.PosProduct when 0 then 'No' when 1 then 'Si' end as [Producto POS],
		case atc.AllPOSPathologies when 0 then 'No' when 1 then 'Si' end as [Totas las Patologias],
		bg.name as GrupoNoPos,
		case atc.formulationtype when 1 then 'Peso'
		when 2 then 'Volumen'
		when 3 then 'Peso - Volumen'
		when 4 then 'Unidad de administración' end as [Tipo Fórmula],
		atc.Weight as [Peso], mup.name as [Unidad Peso],
		atc.volume as [Volume], muv.name as [Unidad Volumen],
		mua.name as [Unidad Administración],
		forma.name as [Forma Farmaceutica],
		case automaticcalculation when 0 then 'No' when 1 then 'Si' end as [Cálculo Automatico],
		case TransferSurplusProduct when 0 then 'No' when 1 then 'Si' end as[Real. Traslado Sobrante],
		case DiluentProduct when 0 then 'No' when 1 then 'Si' end as [Funciona como Diluyente],
		case justificationforSpecialDrugs when 0 then 'No' when 1 then 'Si' end as [Justifica Medicamentos Especiales],
		case JustificationOfInputs when 0 then 'No' when 1 then 'Si' end as [Justificacion insumos/dispositivos],
		case IndicatorDrug when 0 then 'No' when 1 then 'Si' end as [Medicamento Trazador],
		case atc.status when 0 then 'Inactivo' when 1 then 'Activo' end as Estado, 
		atc.creationuser +'-'+ p.fullname as [Usuario Crea], atc.creationDate as [Fecha Creación],
		atc.modificationuser +'-'+ pm.fullname as [Usuario Modifica], atc.modificationdate as [Fecha Modificación], atc.id as ID,
		case atc.Consumption when 1 then 'Si' when 0 then 'No' end as DeConsumo
FROM	Inventory.ATC as atc
left outer join Inventory.DCI as dci on dci.id=atc.dciid
left outer join Inventory.AdministrationRoute as ar on ar.id=atc.AdministrationRouteid
left outer join Inventory.PharmacologicalGroup as pg on pg.id=atc.PharmacologicalGroupid
left outer join Inventory.InventoryRiskLevel as rl on rl.id=atc.InventoryRiskLevelid
left outer join Inventory.InventoryMeasurementUnit as mup on mup.id=atc.WeightMeasureUnit
left outer join Inventory.InventoryMeasurementUnit as muv on muv.id=atc.VolumeMeasureUnit
left outer join Inventory.InventoryMeasurementUnit as mua on mua.id=atc.AdministrationUnitid
left outer join Inventory.ATCEntity as atce on atce.id=atc.atcentityid
left outer join Billing.BillingGroup as bg on bg.id=atc.BillingGroupNoPosId
left outer join security.[User] as u on u.usercode=atc.creationuser
left outer join security.person as p on p.id=u.idperson
left outer join security.[User] as  um on um.usercode=atc.modificationuser
left outer join security.person as pm on pm.id=um.idperson
left outer join Inventory.PharmaceuticalForm as forma on forma.id=atc.PharmaceuticalFormId


