-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_GENERALLEDGER_VENTAS_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_GENERALLEDGER_VENTAS_PB as

SELECT v.VoucherDate as Fecha, ((SUM(vd.DebitValue) - SUM(vd.CreditValue))) * -1 AS Valor, 
	   ma.Number as NroCuenta, ma.Name as Cuenta, tp.Nit as Nit, tp.Name as Tercero, CC.Code as CodigoCC, CC.Name as CentroCosto,
	   'Capita Servicios' as Tipo, case when CC.Code like 'MET%' then 'Meta' when CC.Code  in ('CAS100','CAS001','CAS002','CAS003','CAS004','CAS005','YOP001','MYO001','CAS006') then 'Casanare' 
			 when CC.Code like 'BOY%' then 'Boyaca' when CC.Code like 'B0%' then 'Boyaca'  when CC.Code  in ('MTU001','MTU101') then 'Boyaca'
			 when CC.Code  in ('MVI001') then 'Meta' WHEN CC.Code = 'BOG100' THEN 'Bogota' end as Regional
FROM INDIGO031.GeneralLedger.JournalVouchers as v
inner join INDIGO031.GeneralLedger.JournalVoucherDetails as vd on vd.IdAccounting=v.Id
inner join INDIGO031.GeneralLedger.MainAccounts as ma on ma.Id=vd.IdMainAccount
inner join INDIGO031.Common.ThirdParty as tp on tp.Id=vd.IdThirdParty
inner join INDIGO031.Payroll.CostCenter AS CC ON CC.Id=vd.IdCostCenter
where VoucherDate>='01-01-2022' and v.LegalBookId=2 and ma.Number='4140050501' 
and v.Detail not in ('RECLASIFICACION DE DE CUENTA CAPITA A UNIDAD FUNCIONAL DE CONSULTA EXTERNA- validar',
'REMPLAZA ANULACION DE COMPROBANT CONTABLE 1459, RECLASIFICACION DE CUENTA CAPITA A UNIDAD FUCNIONAL DE CONSULTA EXTERNO ( CENTROS DE COSTO)',
'Cierre anual contable, Anulacion de cuentas de resultados')
group by v.VoucherDate,ma.Number, ma.Name, tp.Nit, tp.Name, CC.Code, CC.Name

union all
SELECT v.VoucherDate as Fecha, ((SUM(vd.DebitValue) - SUM(vd.CreditValue))) * -1 AS Valor, 
	   ma.Number as NroCuenta, 
	 case when ma.Number in ('4130010301','4130010201','4130010401','4110010114','4130010101','4110010134') then 'ATENCION DOMICILIARIA' ELSE  ma.Name END as Cuenta, 
	   tp.Nit as Nit, tp.Name as Tercero, CC.Code as CodigoCC, CC.Name as CentroCosto,
	   'Evento Servicios' as Tipo, case when CC.Code like 'MET%' then 'Meta' when CC.Code  in ('CAS100','CAS001','CAS002','CAS003','CAS004','CAS005','YOP001','MYO001','CAS006') then 'Casanare'  
			 when CC.Code like 'BOY%' then 'Boyaca' when CC.Code like 'B0%' then 'Boyaca'  when CC.Code  in ('MTU001','MTU101') then 'Boyaca'
			 when CC.Code  in ('MVI001') then 'Meta' WHEN CC.Code = 'BOG100' THEN 'Bogota' end as Regional
FROM INDIGO031.GeneralLedger.JournalVouchers as v
inner join INDIGO031.GeneralLedger.JournalVoucherDetails as vd on vd.IdAccounting=v.Id
inner join INDIGO031.GeneralLedger.MainAccounts as ma on ma.Id=vd.IdMainAccount
inner join INDIGO031.Common.ThirdParty as tp on tp.Id=vd.IdThirdParty
inner join INDIGO031.Payroll.CostCenter AS CC ON CC.Id=vd.IdCostCenter
where VoucherDate>='01-01-2022' and v.LegalBookId=2 and ma.Number in ('4110010107','4110010131','4110010132','4110010133',
'4110010136','4130010301','4130010201','4130010401','4110010114','4130010101','4110010134','4125010102','4110010137','4130050101',
'4110010108','4110010109','4110010115','4110010125','4110010145')-- se agregan # de cuentas por solicitud en caso glpi 154686
and v.Detail not in ('Cierre anual contable, Anulacion de cuentas de resultados')
group by v.VoucherDate,ma.Number, ma.Name, tp.Nit, tp.Name, CC.Code, CC.Name
union all

SELECT v.VoucherDate as Fecha, ((SUM(vd.DebitValue) - SUM(vd.CreditValue))) * -1 AS Valor, 
	   ma.Number as NroCuenta, ma.Name as Cuenta, tp.Nit as Nit, tp.Name as Tercero, CC.Code as CodigoCC, CC.Name as CentroCosto,
	   'Capita Medicamentos' as Tipo, case when CC.Code like 'MET%' then 'Meta' when CC.Code  in ('CAS100','CAS001','CAS002','CAS003','CAS004','CAS005','YOP001','MYO001','CAS006') then 'Casanare' 
			 when CC.Code like 'BOY%' then 'Boyaca' when CC.Code like 'B0%' then 'Boyaca'  when CC.Code  in ('MTU001','MTU101') then 'Boyaca'
			 when CC.Code  in ('MVI001') then 'Meta' WHEN CC.Code = 'BOG100' THEN 'Bogota' end as Regional
FROM INDIGO031.GeneralLedger.JournalVouchers as v
inner join INDIGO031.GeneralLedger.JournalVoucherDetails as vd on vd.IdAccounting=v.Id
inner join INDIGO031.GeneralLedger.MainAccounts as ma on ma.Id=vd.IdMainAccount
inner join INDIGO031.Common.ThirdParty as tp on tp.Id=vd.IdThirdParty
inner join INDIGO031.Payroll.CostCenter AS CC ON CC.Id=vd.IdCostCenter
where VoucherDate>='01-01-2022' and v.LegalBookId=2 and ma.Number in ('4140080801')
and v.Detail not in ('RECLASIFICACION DE DE CUENTA CAPITA A UNIDAD FUNCIONAL DE CONSULTA EXTERNA- validar',
'REMPLAZA ANULACION DE COMPROBANT CONTABLE 1459, RECLASIFICACION DE CUENTA CAPITA A UNIDAD FUCNIONAL DE CONSULTA EXTERNO ( CENTROS DE COSTO)')
group by v.VoucherDate,ma.Number, ma.Name, tp.Nit, tp.Name, CC.Code, CC.Name