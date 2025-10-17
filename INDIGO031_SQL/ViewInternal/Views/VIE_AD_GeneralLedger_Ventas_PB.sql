-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_GeneralLedger_Ventas_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_GeneralLedger_Ventas_PB] as

SELECT v.VoucherDate as Fecha, ((SUM(vd.DebitValue) - SUM(vd.CreditValue))) * -1 AS Valor, 
	   ma.Number as NroCuenta, ma.Name as Cuenta, tp.nit as Nit, tp.name as Tercero, CC.CODE as CodigoCC, CC.NAME as CentroCosto,
	   'Capita Servicios' as Tipo, case when CC.CODE like 'MET%' then 'Meta' when CC.CODE  in ('CAS100','CAS001','CAS002','CAS003','CAS004','CAS005','YOP001','MYO001','CAS006') then 'Casanare' 
			 when CC.CODE like 'BOY%' then 'Boyaca' when CC.CODE like 'B0%' then 'Boyaca'  when CC.CODE  in ('MTU001','MTU101') then 'Boyaca'
			 when CC.CODE  in ('MVI001') then 'Meta' WHEN CC.CODE = 'BOG100' THEN 'Bogota' end as Regional
FROM GeneralLedger.JournalVouchers as v
inner join GeneralLedger.JournalVoucherDetails as vd on vd.IdAccounting=v.Id
inner join GeneralLedger.MainAccounts as ma on ma.id=vd.IdMainAccount
inner join Common.ThirdParty as tp on tp.id=vd.IdThirdParty
inner join Payroll.CostCenter AS CC ON CC.ID=VD.IdCostCenter
where VoucherDate>='01-01-2022' and v.LegalBookId=2 and ma.Number='4140050501' 
and v.Detail not in ('RECLASIFICACION DE DE CUENTA CAPITA A UNIDAD FUNCIONAL DE CONSULTA EXTERNA- validar',
'REMPLAZA ANULACION DE COMPROBANT CONTABLE 1459, RECLASIFICACION DE CUENTA CAPITA A UNIDAD FUCNIONAL DE CONSULTA EXTERNO ( CENTROS DE COSTO)',
'Cierre anual contable, Anulacion de cuentas de resultados')
group by v.VoucherDate,ma.Number, ma.Name, tp.nit, tp.name, CC.CODE, CC.NAME

union all
SELECT v.VoucherDate as Fecha, ((SUM(vd.DebitValue) - SUM(vd.CreditValue))) * -1 AS Valor, 
	   ma.Number as NroCuenta, 
	 case when ma.Number in ('4130010301','4130010201','4130010401','4110010114','4130010101','4110010134') then 'ATENCION DOMICILIARIA' ELSE  ma.Name END as Cuenta, 
	   tp.nit as Nit, tp.name as Tercero, CC.CODE as CodigoCC, CC.NAME as CentroCosto,
	   'Evento Servicios' as Tipo, case when CC.CODE like 'MET%' then 'Meta' when CC.CODE  in ('CAS100','CAS001','CAS002','CAS003','CAS004','CAS005','YOP001','MYO001','CAS006') then 'Casanare'  
			 when CC.CODE like 'BOY%' then 'Boyaca' when CC.CODE like 'B0%' then 'Boyaca'  when CC.CODE  in ('MTU001','MTU101') then 'Boyaca'
			 when CC.CODE  in ('MVI001') then 'Meta' WHEN CC.CODE = 'BOG100' THEN 'Bogota' end as Regional
FROM GeneralLedger.JournalVouchers as v
inner join GeneralLedger.JournalVoucherDetails as vd on vd.IdAccounting=v.Id
inner join GeneralLedger.MainAccounts as ma on ma.id=vd.IdMainAccount
inner join Common.ThirdParty as tp on tp.id=vd.IdThirdParty
inner join Payroll.CostCenter AS CC ON CC.ID=VD.IdCostCenter
where VoucherDate>='01-01-2022' and v.LegalBookId=2 and ma.Number in ('4110010107','4110010131','4110010132','4110010133',
'4110010136','4130010301','4130010201','4130010401','4110010114','4130010101','4110010134','4125010102','4110010137','4130050101',
'4110010108','4110010109','4110010115','4110010125','4110010145')-- se agregan # de cuentas por solicitud en caso glpi 154686
and v.Detail not in ('Cierre anual contable, Anulacion de cuentas de resultados')
group by v.VoucherDate,ma.Number, ma.Name, tp.nit, tp.name, CC.CODE, CC.NAME
union all

SELECT v.VoucherDate as Fecha, ((SUM(vd.DebitValue) - SUM(vd.CreditValue))) * -1 AS Valor, 
	   ma.Number as NroCuenta, ma.Name as Cuenta, tp.nit as Nit, tp.name as Tercero, CC.CODE as CodigoCC, CC.NAME as CentroCosto,
	   'Capita Medicamentos' as Tipo, case when CC.CODE like 'MET%' then 'Meta' when CC.CODE  in ('CAS100','CAS001','CAS002','CAS003','CAS004','CAS005','YOP001','MYO001','CAS006') then 'Casanare' 
			 when CC.CODE like 'BOY%' then 'Boyaca' when CC.CODE like 'B0%' then 'Boyaca'  when CC.CODE  in ('MTU001','MTU101') then 'Boyaca'
			 when CC.CODE  in ('MVI001') then 'Meta' WHEN CC.CODE = 'BOG100' THEN 'Bogota' end as Regional
FROM GeneralLedger.JournalVouchers as v
inner join GeneralLedger.JournalVoucherDetails as vd on vd.IdAccounting=v.Id
inner join GeneralLedger.MainAccounts as ma on ma.id=vd.IdMainAccount
inner join Common.ThirdParty as tp on tp.id=vd.IdThirdParty
inner join Payroll.CostCenter AS CC ON CC.ID=VD.IdCostCenter
where VoucherDate>='01-01-2022' and v.LegalBookId=2 and ma.Number in ('4140080801')
and v.Detail not in ('RECLASIFICACION DE DE CUENTA CAPITA A UNIDAD FUNCIONAL DE CONSULTA EXTERNA- validar',
'REMPLAZA ANULACION DE COMPROBANT CONTABLE 1459, RECLASIFICACION DE CUENTA CAPITA A UNIDAD FUCNIONAL DE CONSULTA EXTERNO ( CENTROS DE COSTO)')
group by v.VoucherDate,ma.Number, ma.Name, tp.nit, tp.name, CC.CODE, CC.NAME



