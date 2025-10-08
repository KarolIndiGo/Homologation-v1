-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_PAYROLL_LIQUIDACIÓNINCAPACIDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_Payroll_LiquidaciónIncapacidades
AS 

select *
from (

select 
TPS.Nit as Nit, TPS.Name AS Cliente, LQ.id as Factura, '7' as Estado, '3' as Categoria, LQ.realdate as FechaInicial,  LQ.Enddate as FechaFinal,
'NOVEDAD' +' ' + CASE WHEN MONTH(LQ.realdate)= 11 AND YEAR(LQ.realdate)= 2021 THEN 'NOVIEMBRE 2021'
					  WHEN MONTH(LQ.realdate)= 12 AND YEAR(LQ.realdate)= 2021 THEN 'DICIEMBRE 2021'
					  WHEN MONTH(LQ.realdate)= 1 AND YEAR(LQ.realdate)= 2022 THEN 'ENERO 2022'
					  WHEN MONTH(LQ.realdate)= 2 AND YEAR(LQ.realdate)= 2022 THEN 'FEBRERO 2022'
					  WHEN MONTH(LQ.realdate)= 3 AND YEAR(LQ.realdate)= 2022 THEN 'MARZO 2022'
					  WHEN MONTH(LQ.realdate)= 4 AND YEAR(LQ.realdate)= 2022 THEN 'ABRIL 2022'
					  WHEN MONTH(LQ.realdate)= 5 AND YEAR(LQ.realdate)= 2022 THEN 'MAYO 2022'
					  WHEN MONTH(LQ.realdate)= 6 AND YEAR(LQ.realdate)= 2022 THEN 'JUNIO 2022'
					  WHEN MONTH(LQ.realdate)= 7 AND YEAR(LQ.realdate)= 2022 THEN 'JULIO 2022'
					  WHEN MONTH(LQ.realdate)= 8 AND YEAR(LQ.realdate)= 2022 THEN 'AGOSTO 2022'
					  WHEN MONTH(LQ.realdate)= 9 AND YEAR(LQ.realdate)= 2022 THEN 'SEPTIEMBRE 2022'
					  WHEN MONTH(LQ.realdate)= 10 AND YEAR(LQ.realdate)= 2022 THEN 'OCTUBRE 2022'
					  WHEN MONTH(LQ.realdate)= 11 AND YEAR(LQ.realdate)= 2022 THEN 'NOVIEMBRE 2022'
					  WHEN MONTH(LQ.realdate)= 12 AND YEAR(LQ.realdate)= 2022 THEN 'DICIEMBRE 2022'
					  WHEN MONTH(LQ.realdate)= 1 AND YEAR(LQ.realdate)= 2023 THEN 'ENERO 2023'
					  WHEN MONTH(LQ.realdate)= 2 AND YEAR(LQ.realdate)= 2023 THEN 'FEBRERO 2023'
					  WHEN MONTH(LQ.realdate)= 3 AND YEAR(LQ.realdate)= 2023 THEN 'MARZO 2023'
					  WHEN MONTH(LQ.realdate)= 4 AND YEAR(LQ.realdate)= 2023 THEN 'ABRIL 2023'
					  WHEN MONTH(LQ.realdate)= 5 AND YEAR(LQ.realdate)= 2023 THEN 'MAYO 2023'
					  WHEN MONTH(LQ.realdate)= 6 AND YEAR(LQ.realdate)= 2023 THEN 'JUNIO 2023'
					  WHEN MONTH(LQ.realdate)= 7 AND YEAR(LQ.realdate)= 2023 THEN 'JULIO 2023'
					  WHEN MONTH(LQ.realdate)= 8 AND YEAR(LQ.realdate)= 2023 THEN 'AGOSTO 2023'
					  WHEN MONTH(LQ.realdate)= 9 AND YEAR(LQ.realdate)= 2023 THEN 'SEPTIEMBRE 2023'
					  WHEN MONTH(LQ.realdate)= 10 AND YEAR(LQ.realdate)= 2023 THEN 'OCTUBRE 2023'
					  WHEN MONTH(LQ.realdate)= 11 AND YEAR(LQ.realdate)= 2023 THEN 'NOVIEMBRE 2023'
					  WHEN MONTH(LQ.realdate)= 12 AND YEAR(LQ.realdate)= 2023 THEN 'DICIEMBRE 2023'
					  WHEN MONTH(LQ.realdate)= 1 AND YEAR(LQ.realdate)= 2024 THEN 'ENERO 2024'
					  WHEN MONTH(LQ.realdate)= 2 AND YEAR(LQ.realdate)= 2024 THEN 'FEBRERO 2024'
					  WHEN MONTH(LQ.realdate)= 3 AND YEAR(LQ.realdate)= 2024 THEN 'MARZO 2024'
					  WHEN MONTH(LQ.realdate)= 4 AND YEAR(LQ.realdate)= 2024 THEN 'ABRIL 2024'
					  WHEN MONTH(LQ.realdate)= 5 AND YEAR(LQ.realdate)= 2024 THEN 'MAYO 2024'
					  WHEN MONTH(LQ.realdate)= 6 AND YEAR(LQ.realdate)= 2024 THEN 'JUNIO 2024'
					  WHEN MONTH(LQ.realdate)= 7 AND YEAR(LQ.realdate)= 2024 THEN 'JULIO 2024'
					  WHEN MONTH(LQ.realdate)= 8 AND YEAR(LQ.realdate)= 2024 THEN 'AGOSTO 2024'
					  WHEN MONTH(LQ.realdate)= 9 AND YEAR(LQ.realdate)= 2024 THEN 'SEPTIEMBRE 2024'
					  WHEN MONTH(LQ.realdate)= 10 AND YEAR(LQ.realdate)= 2024 THEN 'OCTUBRE 2024'
					  WHEN MONTH(LQ.realdate)= 11 AND YEAR(LQ.realdate)= 2024 THEN 'NOVIEMBRE 2024'
					  WHEN MONTH(LQ.realdate)= 21 AND YEAR(LQ.realdate)= 2024 THEN 'DICIEMBRE 2024' end as MesNovedad,

LQ.Days as [Plazo (DiasINC)], '1' as [No. Cuotas],
'355' as CuentaContable, 
cc.Id as CentroCosto, 'NOMINA' +' ' + 
CASE				  WHEN MONTH(linc.PayrollDateLiquidated)= 11 AND YEAR(linc.PayrollDateLiquidated)= 2021 THEN 'NOVIEMBRE 2021'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 12 AND YEAR(linc.PayrollDateLiquidated)= 2021 THEN 'DICIEMBRE 2021'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 1 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'ENERO 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 2 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'FEBRERO 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 3 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'MARZO 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 4 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'ABRIL 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 5 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'MAYO 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 6 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'JUNIO 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 7 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'JULIO 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 8 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'AGOSTO 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 9 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'SEPTIEMBRE 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 10 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'OCTUBRE 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 11 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'NOVIEMBRE 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 12 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN 'DICIEMBRE 2022'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 1 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'ENERO 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 2 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'FEBRERO 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 3 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'MARZO 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 4 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'ABRIL 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 5 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'MAYO 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 6 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'JUNIO 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 7 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'JULIO 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 8 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'AGOSTO 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 9 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'SEPTIEMBRE 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 10 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'OCTUBRE 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 11 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'NOVIEMBRE 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 12 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN 'DICIEMBRE 2023'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 1 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'ENERO 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 2 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'FEBRERO 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 3 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'MARZO 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 4 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'ABRIL 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 5 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'MAYO 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 6 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'JUNIO 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 7 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'JULIO 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 8 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'AGOSTO 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 9 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'SEPTIEMBRE 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 10 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'OCTUBRE 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 11 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'NOVIEMBRE 2024'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 21 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'DICIEMBRE 2024'  end as Observacion,
																									 (LQ.EPSRecognizeValue) AS ValorEPS, 
(LQ.EPSRecognizeValue) as Saldo,

 CASE WHEN MONTH(linc.PayrollDateLiquidated) = 11 AND YEAR(linc.PayrollDateLiquidated)= 2021 THEN '30-11-2021' 
	  WHEN MONTH(linc.PayrollDateLiquidated) = 12 AND YEAR(linc.PayrollDateLiquidated)= 2021 THEN '31-12-2021' 
	  WHEN MONTH(linc.PayrollDateLiquidated) = 1 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '31-01-2022'
      WHEN MONTH(linc.PayrollDateLiquidated) = 2 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '28-02-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 3 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '31-03-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 4 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '30-04-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 5 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '31-05-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 6 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '30-06-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 7 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '31-07-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 8 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '31-08-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 9 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '30-09-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 10 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '31-10-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 11 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '30-11-2022'
	  WHEN MONTH(linc.PayrollDateLiquidated)= 12 AND YEAR(linc.PayrollDateLiquidated)= 2022 THEN '31-12-2022'	 
	  WHEN MONTH(linc.PayrollDateLiquidated) = 1 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '31-01-2023'
      WHEN MONTH(linc.PayrollDateLiquidated) = 2 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '28-02-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 3 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '31-03-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 4 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '30-04-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 5 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '31-05-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 6 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '30-06-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 7 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '31-07-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 8 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '31-08-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 9 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '30-09-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 10 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '31-10-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 11 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '30-11-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated)= 12 AND YEAR(linc.PayrollDateLiquidated)= 2023 THEN '31-12-2023'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 1 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-01-2024'
      WHEN MONTH(linc.PayrollDateLiquidated) = 2 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '29-02-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 3 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-03-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 4 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '30-04-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 5 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-05-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 6 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '30-06-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 7 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-07-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 8 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-08-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 9 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '30-09-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 10 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-10-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 11 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '30-11-2024'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 12 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-12-2024' END as FechaLiquidacion,
	  MONTH(linc.PayrollDateLiquidated) AS MesLiquida,

LQ.value as VrLiquidado,

linc.MaternityLeaveValue + linc.AccumulatedOtherAccrued as VrSubir,

cc.Id as CentroCostoGlosas, '355' as CuentaContable_SinRadicar,  '355' as CuentaContable_Radicada,
'355' as CuentaContable_GlosaSubsanable, '355' as CuentaContable_Conciliacion, '355' as CuentaContable_CobroJuridico, '' as CuentaContable_OrdenGlosa, '' as CuentaContable_AcrededorGlosa,
TP.Nit AS DocumentoUsuario, TP.Name as Usuario, ltrim(rtrim(TP.Nit)) +'-'+ ltrim(rtrim(TP.Name)) as CompletoUsuario ,case LQ.InabilityClass when 1 then 'Ambulatoria' when 2 then 'Hospitalaria' 
		   when 3 then 'Maternidad' when 4 then 'Enfermedad Profesional'  when 5 then 'Paternidad'  end as TipoIncapacidad, E.Id
FROM	(select max(LQ.Id) as id, max(RealDate) as realdate, max(EndDate) as Enddate, sum(Days) as Days, sum(EPSRecognizeValue) as EPSRecognizeValue, EmployeeId, AutorizationNumber, InabilityClass, TypeNovelty, sum(Value) as value
			FROM	[INDIGO035].[Payroll].[Novelty] AS LQ 
				group by EmployeeId,  AutorizationNumber, InabilityClass, TypeNovelty) as LQ  left outer join
		[INDIGO035].[Payroll].[Employee] AS E on E.Id=LQ.EmployeeId left outer  JOIN
           [INDIGO035].[Common].[ThirdParty] AS TP  ON TP.Id = E.ThirdPartyId INNER JOIN
           (SELECT max(Id) as ID, EmployeeId, MAX(ContractInitialDate) as ContractInitialDate
				FROM [INDIGO035].[Payroll].[Contract]
				--where employeeid='7836'
				GROUP BY  EmployeeId) AS co  ON co.EmployeeId = E.Id LEFT OUTER JOIN
				[INDIGO035].[Payroll].[Contract] AS coo  ON coo.Id = co.ID LEFT OUTER JOIN
		   [INDIGO035].[Payroll].[FundContract] AS fc  ON fc.ContractId = coo.Id AND fc.FundType = '1' AND fc.State = '1' LEFT OUTER JOIN
           [INDIGO035].[Payroll].[Fund] AS salud  ON salud.Id = fc.FundId left outer  JOIN
           [INDIGO035].[Common].[ThirdParty] AS TPS  ON TPS.Id = salud.ThirdPartyId LEFT OUTER JOIN
           [INDIGO035].[Payroll].[FunctionalUnit] AS fu  ON fu.Id = coo.FunctionalUnitId LEFT OUTER JOIN
           [INDIGO035].[Payroll].[CostCenter] AS cc  ON fu.CostCenterId = cc.Id LEFT OUTER JOIN 
		   [INDIGO035].[Payroll].[Liquidation] AS linc  on linc.EmployeeId=LQ.EmployeeId and linc.MaternityLeaveAutorizationNumber=LQ.AutorizationNumber --LEFT OUTER JOIN 
		   --Payroll.Liquidation AS lmat  on lmat.EmployeeId=lq.EmployeeId and lmat.MaternityLeaveAutorizationNumber=lq.AutorizationNumber 
where  (LQ.realdate)>='01-01-2022' and LQ.TypeNovelty in ('1')   and LQ.InabilityClass=3 

union all 


select 
TPS.Nit as Nit, TPS.Name AS Cliente, LQ.Id as Factura, '7' as Estado, '3' as Categoria, LQ.RealDate as FechaInicial, LQ.EndDate as FechaFinal, 
'NOVEDAD' +' ' + CASE WHEN MONTH(LQ.RealDate)= 11 AND YEAR(LQ.RealDate)= 2021 THEN 'NOVIEMBRE 2021'
					  WHEN MONTH(LQ.RealDate)= 12 AND YEAR(LQ.RealDate)= 2021 THEN 'DICIEMBRE 2021'
					  WHEN MONTH(LQ.RealDate)= 1 AND YEAR(LQ.RealDate)= 2022 THEN 'ENERO 2022'
					  WHEN MONTH(LQ.RealDate)= 2 AND YEAR(LQ.RealDate)= 2022 THEN 'FEBRERO 2022'
					  WHEN MONTH(LQ.RealDate)= 3 AND YEAR(LQ.RealDate)= 2022 THEN 'MARZO 2022'
					  WHEN MONTH(LQ.RealDate)= 4 AND YEAR(LQ.RealDate)= 2022 THEN 'ABRIL 2022'
					  WHEN MONTH(LQ.RealDate)= 5 AND YEAR(LQ.RealDate)= 2022 THEN 'MAYO 2022'
					  WHEN MONTH(LQ.RealDate)= 6 AND YEAR(LQ.RealDate)= 2022 THEN 'JUNIO 2022'
					  WHEN MONTH(LQ.RealDate)= 7 AND YEAR(LQ.RealDate)= 2022 THEN 'JULIO 2022'
					  WHEN MONTH(LQ.RealDate)= 8 AND YEAR(LQ.RealDate)= 2022 THEN 'AGOSTO 2022'
					  WHEN MONTH(LQ.RealDate)= 9 AND YEAR(LQ.RealDate)= 2022 THEN 'SEPTIEMBRE 2022'
					  WHEN MONTH(LQ.RealDate)= 10 AND YEAR(LQ.RealDate)= 2022 THEN 'OCTUBRE 2022'
					  WHEN MONTH(LQ.RealDate)= 11 AND YEAR(LQ.RealDate)= 2022 THEN 'NOVIEMBRE 2022'
					  WHEN MONTH(LQ.RealDate)= 12 AND YEAR(LQ.RealDate)= 2022 THEN 'DICIEMBRE 2022'
					  WHEN MONTH(LQ.RealDate)= 1 AND YEAR(LQ.RealDate)= 2023 THEN 'ENERO 2023'
					  WHEN MONTH(LQ.RealDate)= 2 AND YEAR(LQ.RealDate)= 2023 THEN 'FEBRERO 2023'
					  WHEN MONTH(LQ.RealDate)= 3 AND YEAR(LQ.RealDate)= 2023 THEN 'MARZO 2023'
					  WHEN MONTH(LQ.RealDate)= 4 AND YEAR(LQ.RealDate)= 2023 THEN 'ABRIL 2023'
					  WHEN MONTH(LQ.RealDate)= 5 AND YEAR(LQ.RealDate)= 2023 THEN 'MAYO 2023'
					  WHEN MONTH(LQ.RealDate)= 6 AND YEAR(LQ.RealDate)= 2023 THEN 'JUNIO 2023'
					  WHEN MONTH(LQ.RealDate)= 7 AND YEAR(LQ.RealDate)= 2023 THEN 'JULIO 2023'
					  WHEN MONTH(LQ.RealDate)= 8 AND YEAR(LQ.RealDate)= 2023 THEN 'AGOSTO 2023'
					  WHEN MONTH(LQ.RealDate)= 9 AND YEAR(LQ.RealDate)= 2023 THEN 'SEPTIEMBRE 2023'
					  WHEN MONTH(LQ.RealDate)= 10 AND YEAR(LQ.RealDate)= 2023 THEN 'OCTUBRE 2023'
					  WHEN MONTH(LQ.RealDate)= 11 AND YEAR(LQ.RealDate)= 2023 THEN 'NOVIEMBRE 2023'
					  WHEN MONTH(LQ.RealDate)= 12 AND YEAR(LQ.RealDate)= 2023 THEN 'DICIEMBRE 2023'
					  WHEN MONTH(LQ.RealDate)= 1 AND YEAR(LQ.RealDate)= 2024 THEN 'ENERO 2024'
					  WHEN MONTH(LQ.RealDate)= 2 AND YEAR(LQ.RealDate)= 2024 THEN 'FEBRERO 2024'
					  WHEN MONTH(LQ.RealDate)= 3 AND YEAR(LQ.RealDate)= 2024 THEN 'MARZO 2024'
					  WHEN MONTH(LQ.RealDate)= 4 AND YEAR(LQ.RealDate)= 2024 THEN 'ABRIL 2024'
					  WHEN MONTH(LQ.RealDate)= 5 AND YEAR(LQ.RealDate)= 2024 THEN 'MAYO 2024'
					  WHEN MONTH(LQ.RealDate)= 6 AND YEAR(LQ.RealDate)= 2024 THEN 'JUNIO 2024'
					  WHEN MONTH(LQ.RealDate)= 7 AND YEAR(LQ.RealDate)= 2024 THEN 'JULIO 2024'
					  WHEN MONTH(LQ.RealDate)= 8 AND YEAR(LQ.RealDate)= 2024 THEN 'AGOSTO 2024'
					  WHEN MONTH(LQ.RealDate)= 9 AND YEAR(LQ.RealDate)= 2024 THEN 'SEPTIEMBRE 2024'
					  WHEN MONTH(LQ.RealDate)= 10 AND YEAR(LQ.RealDate)= 2024 THEN 'OCTUBRE 2024'
					  WHEN MONTH(LQ.RealDate)= 11 AND YEAR(LQ.RealDate)= 2024 THEN 'NOVIEMBRE 2024'
					  WHEN MONTH(LQ.RealDate)= 21 AND YEAR(LQ.RealDate)= 2024 THEN 'DICIEMBRE 2024' end as MesNovedad,
LQ.Days as [Plazo (DiasINC)], '1' as [No. Cuotas],
'355' as CuentaContable, 
cc.Id as CentroCosto, 'NOMINA' +' ' + 
CASE				  WHEN MONTH(LQ.CreationDate)= 11 AND YEAR(LQ.CreationDate)= 2021 THEN 'NOVIEMBRE 2021'
					  WHEN MONTH(LQ.CreationDate)= 12 AND YEAR(LQ.CreationDate)= 2021 THEN 'DICIEMBRE 2021'
					  WHEN MONTH(LQ.CreationDate)= 1 AND YEAR(LQ.CreationDate)= 2022 THEN 'ENERO 2022'
					  WHEN MONTH(LQ.CreationDate)= 2 AND YEAR(LQ.CreationDate)= 2022 THEN 'FEBRERO 2022'
					  WHEN MONTH(LQ.CreationDate)= 3 AND YEAR(LQ.CreationDate)= 2022 THEN 'MARZO 2022'
					  WHEN MONTH(LQ.CreationDate)= 4 AND YEAR(LQ.CreationDate)= 2022 THEN 'ABRIL 2022'
					  WHEN MONTH(LQ.CreationDate)= 5 AND YEAR(LQ.CreationDate)= 2022 THEN 'MAYO 2022'
					  WHEN MONTH(LQ.CreationDate)= 6 AND YEAR(LQ.CreationDate)= 2022 THEN 'JUNIO 2022'
					  WHEN MONTH(LQ.CreationDate)= 7 AND YEAR(LQ.CreationDate)= 2022 THEN 'JULIO 2022'
					  WHEN MONTH(LQ.CreationDate)= 8 AND YEAR(LQ.CreationDate)= 2022 THEN 'AGOSTO 2022'
					  WHEN MONTH(LQ.CreationDate)= 9 AND YEAR(LQ.CreationDate)= 2022 THEN 'SEPTIEMBRE 2022'
					  WHEN MONTH(LQ.CreationDate)= 10 AND YEAR(LQ.CreationDate)= 2022 THEN 'OCTUBRE 2022'
					  WHEN MONTH(LQ.CreationDate)= 11 AND YEAR(LQ.CreationDate)= 2022 THEN 'NOVIEMBRE 2022'
					  WHEN MONTH(LQ.CreationDate)= 12 AND YEAR(LQ.CreationDate)= 2022 THEN 'DICIEMBRE 2022'
					  WHEN MONTH(LQ.CreationDate)= 1 AND YEAR(LQ.CreationDate)= 2023 THEN 'ENERO 2023'
					  WHEN MONTH(LQ.CreationDate)= 2 AND YEAR(LQ.CreationDate)= 2023 THEN 'FEBRERO 2023'
					  WHEN MONTH(LQ.CreationDate)= 3 AND YEAR(LQ.CreationDate)= 2023 THEN 'MARZO 2023'
					  WHEN MONTH(LQ.CreationDate)= 4 AND YEAR(LQ.CreationDate)= 2023 THEN 'ABRIL 2023'
					  WHEN MONTH(LQ.CreationDate)= 5 AND YEAR(LQ.CreationDate)= 2023 THEN 'MAYO 2023'
					  WHEN MONTH(LQ.CreationDate)= 6 AND YEAR(LQ.CreationDate)= 2023 THEN 'JUNIO 2023'
					  WHEN MONTH(LQ.CreationDate)= 7 AND YEAR(LQ.CreationDate)= 2023 THEN 'JULIO 2023'
					  WHEN MONTH(LQ.CreationDate)= 8 AND YEAR(LQ.CreationDate)= 2023 THEN 'AGOSTO 2023'
					  WHEN MONTH(LQ.CreationDate)= 9 AND YEAR(LQ.CreationDate)= 2023 THEN 'SEPTIEMBRE 2023'
					  WHEN MONTH(LQ.CreationDate)= 10 AND YEAR(LQ.CreationDate)= 2023 THEN 'OCTUBRE 2023'
					  WHEN MONTH(LQ.CreationDate)= 11 AND YEAR(LQ.CreationDate)= 2023 THEN 'NOVIEMBRE 2023'
					  WHEN MONTH(LQ.CreationDate)= 12 AND YEAR(LQ.CreationDate)= 2023 THEN 'DICIEMBRE 2023'
					  WHEN MONTH(LQ.CreationDate)= 1 AND YEAR(LQ.CreationDate)= 2024 THEN 'ENERO 2024'
					  WHEN MONTH(LQ.CreationDate)= 2 AND YEAR(LQ.CreationDate)= 2024 THEN 'FEBRERO 2024'
					  WHEN MONTH(LQ.CreationDate)= 3 AND YEAR(LQ.CreationDate)= 2024 THEN 'MARZO 2024'
					  WHEN MONTH(LQ.CreationDate)= 4 AND YEAR(LQ.CreationDate)= 2024 THEN 'ABRIL 2024'
					  WHEN MONTH(LQ.CreationDate)= 5 AND YEAR(LQ.CreationDate)= 2024 THEN 'MAYO 2024'
					  WHEN MONTH(LQ.CreationDate)= 6 AND YEAR(LQ.CreationDate)= 2024 THEN 'JUNIO 2024'
					  WHEN MONTH(LQ.CreationDate)= 7 AND YEAR(LQ.CreationDate)= 2024 THEN 'JULIO 2024'
					  WHEN MONTH(LQ.CreationDate)= 8 AND YEAR(LQ.CreationDate)= 2024 THEN 'AGOSTO 2024'
					  WHEN MONTH(LQ.CreationDate)= 9 AND YEAR(LQ.CreationDate)= 2024 THEN 'SEPTIEMBRE 2024'
					  WHEN MONTH(LQ.CreationDate)= 10 AND YEAR(LQ.CreationDate)= 2024 THEN 'OCTUBRE 2024'
					  WHEN MONTH(LQ.CreationDate)= 11 AND YEAR(LQ.CreationDate)= 2024 THEN 'NOVIEMBRE 2024'
					  WHEN MONTH(LQ.CreationDate)= 21 AND YEAR(LQ.CreationDate)= 2024 THEN 'DICIEMBRE 2024'  end as Observacion,
																									 (LQ.EPSRecognizeValue) AS ValorEPS, 
(LQ.EPSRecognizeValue) as Saldo,

 CASE WHEN MONTH(LQ.CreationDate) = 11 AND YEAR(LQ.CreationDate)= 2021 THEN '30-11-2021' 
	  WHEN MONTH(LQ.CreationDate) = 12 AND YEAR(LQ.CreationDate)= 2021 THEN '31-12-2021'
	  WHEN MONTH(LQ.CreationDate) = 1 AND YEAR(LQ.CreationDate)= 2022 THEN '31-01-2022'
      WHEN MONTH(LQ.CreationDate) = 2 AND YEAR(LQ.CreationDate)= 2022 THEN '28-02-2022'
	  WHEN MONTH(LQ.CreationDate) = 3 AND YEAR(LQ.CreationDate)= 2022 THEN '31-03-2022'
	  WHEN MONTH(LQ.CreationDate) = 4 AND YEAR(LQ.CreationDate)= 2022 THEN '30-04-2022'
	  WHEN MONTH(LQ.CreationDate) = 5 AND YEAR(LQ.CreationDate)= 2022 THEN '31-05-2022'
	  WHEN MONTH(LQ.CreationDate) = 6 AND YEAR(LQ.CreationDate)= 2022 THEN '30-06-2022'
	  WHEN MONTH(LQ.CreationDate) = 7 AND YEAR(LQ.CreationDate)= 2022 THEN '31-07-2022'
	  WHEN MONTH(LQ.CreationDate) = 8 AND YEAR(LQ.CreationDate)= 2022 THEN '31-08-2022'
	  WHEN MONTH(LQ.CreationDate) = 9 AND YEAR(LQ.CreationDate)= 2022 THEN '30-09-2022'
	  WHEN MONTH(LQ.CreationDate) = 10 AND YEAR(LQ.CreationDate)= 2022 THEN '31-10-2022'
	  WHEN MONTH(LQ.CreationDate) = 11 AND YEAR(LQ.CreationDate)= 2022 THEN '30-11-2022'
	  WHEN MONTH(LQ.CreationDate)= 12 AND YEAR(LQ.CreationDate)= 2022 THEN '31-12-2022'	  
	  WHEN MONTH(LQ.CreationDate) = 1 AND YEAR(LQ.CreationDate)= 2023 THEN '31-01-2023'
      WHEN MONTH(LQ.CreationDate) = 2 AND YEAR(LQ.CreationDate)= 2023 THEN '28-02-2023'
	  WHEN MONTH(LQ.CreationDate) = 3 AND YEAR(LQ.CreationDate)= 2023 THEN '31-03-2023'
	  WHEN MONTH(LQ.CreationDate) = 4 AND YEAR(LQ.CreationDate)= 2023 THEN '30-04-2023'
	  WHEN MONTH(LQ.CreationDate) = 5 AND YEAR(LQ.CreationDate)= 2023 THEN '31-05-2023'
	  WHEN MONTH(LQ.CreationDate) = 6 AND YEAR(LQ.CreationDate)= 2023 THEN '30-06-2023'
	  WHEN MONTH(LQ.CreationDate) = 7 AND YEAR(LQ.CreationDate)= 2023 THEN '31-07-2023'
	  WHEN MONTH(LQ.CreationDate) = 8 AND YEAR(LQ.CreationDate)= 2023 THEN '31-08-2023'
	  WHEN MONTH(LQ.CreationDate) = 9 AND YEAR(LQ.CreationDate)= 2023 THEN '30-09-2023'
	  WHEN MONTH(LQ.CreationDate) = 10 AND YEAR(LQ.CreationDate)= 2023 THEN '31-10-2023'
	  WHEN MONTH(LQ.CreationDate) = 11 AND YEAR(LQ.CreationDate)= 2023 THEN '30-11-2023'
	  WHEN MONTH(LQ.CreationDate)= 12 AND YEAR(LQ.CreationDate)= 2023 THEN '31-12-2023'
	  WHEN MONTH(LQ.CreationDate) = 1 AND YEAR(LQ.CreationDate)= 2024 THEN '31-01-2024'
      WHEN MONTH(LQ.CreationDate) = 2 AND YEAR(LQ.CreationDate)= 2024 THEN '29-02-2024'
	  WHEN MONTH(LQ.CreationDate) = 3 AND YEAR(LQ.CreationDate)= 2024 THEN '31-03-2024'
	  WHEN MONTH(LQ.CreationDate) = 4 AND YEAR(LQ.CreationDate)= 2024 THEN '30-04-2024'
	  WHEN MONTH(LQ.CreationDate) = 5 AND YEAR(LQ.CreationDate)= 2024 THEN '31-05-2024'
	  WHEN MONTH(LQ.CreationDate) = 6 AND YEAR(LQ.CreationDate)= 2024 THEN '30-06-2024'
	  WHEN MONTH(LQ.CreationDate) = 7 AND YEAR(LQ.CreationDate)= 2024 THEN '31-07-2024'
	  WHEN MONTH(LQ.CreationDate) = 8 AND YEAR(LQ.CreationDate)= 2024 THEN '31-08-2024'
	  WHEN MONTH(LQ.CreationDate) = 9 AND YEAR(LQ.CreationDate)= 2024 THEN '30-09-2024'
	  WHEN MONTH(LQ.CreationDate) = 10 AND YEAR(LQ.CreationDate)= 2024 THEN '31-10-2024'
	  WHEN MONTH(LQ.CreationDate) = 11 AND YEAR(LQ.CreationDate)= 2024 THEN '30-11-2024'
	  WHEN MONTH(LQ.CreationDate) = 12 AND YEAR(LQ.CreationDate)= 2024 THEN '31-12-2024' END as FechaLiquidacion,
	   MONTH(LQ.CreationDate) AS MesLiquida,
LQ.Value as VrLiquidado,
case when LQ.InabilityClass in ('1','2','5') and co.Name like '%incapacidad%' then 0
    when LQ.InabilityClass in ('1','2','5') and co.Name not like '%incapacidad%' then LQ.EPSRecognizeValue
	 when LQ.InabilityClass in ('3') then LQ.LiquidationBase
	 when  LQ.InabilityClass in ('4') and month(RealDate)<>month(EndDate) and EPSDays=1 then LQ.EPSRecognizeValue
	 when  LQ.InabilityClass in ('4') and month(RealDate)=month(EndDate) and EPSDays=1 then LQ.PaidPayrollValue
	 when  LQ.InabilityClass in ('4') and month(RealDate)<>month(EndDate) and  EPSDays>1 then LQ.PaidPayrollValue
	 when  LQ.InabilityClass in ('4') and EPSDays>27  and LQ.PaidEmployerValue<1 then LQ.LiquidationBase
	 	when  LQ.InabilityClass in ('4') and EPSDays=1 and EmployerDays=1 then LQ.PaidPayrollValue
		when  LQ.InabilityClass in ('4') and EPSDays=1 then LQ.EPSRecognizeValue
	 when LQ.InabilityClass in ('4') and EPSDays<27   then LQ.PaidPayrollValue end as VrSubir,

cc.Id as CentroCostoGlosas, '355' as CuentaContable_SinRadicar,  '355' as CuentaContable_Radicada,
'355' as CuentaContable_GlosaSubsanable, '355' as CuentaContable_Conciliacion, '355' as CuentaContable_CobroJuridico, '' as CuentaContable_OrdenGlosa, '' as CuentaContable_AcrededorGlosa,
TP.Nit AS DocumentoUsuario, TP.Name as Usuario,  ltrim(rtrim(TP.Nit)) +'-'+ ltrim(rtrim(TP.Name)) as CompletoUsuario ,case LQ.InabilityClass when 1 then 'Ambulatoria' when 2 then 'Hospitalaria' 
		   when 3 then 'Maternidad' when 4 then 'Enfermedad Profesional'  when 5 then 'Paternidad'  end as TipoIncapacidad, E.Id
FROM	[INDIGO035].[Payroll].[Novelty] AS LQ  left outer join
		[INDIGO035].[Payroll].[Employee] AS E on E.Id=LQ.EmployeeId left outer  JOIN
           [INDIGO035].[Common].[ThirdParty] AS TP  ON TP.Id = E.ThirdPartyId INNER JOIN
           (SELECT max(co.Id) as ID, EmployeeId, MAX(ContractInitialDate) as ContractInitialDate, g.Name
				FROM [INDIGO035].[Payroll].[Contract] as co inner join
				[INDIGO035].[Payroll].[Group] AS g  ON co.GroupId = g.Id 
				--where --co.Status=1
				--where employeeid='7836'
				GROUP BY  EmployeeId, g.Name) AS co  ON co.EmployeeId = E.Id LEFT OUTER JOIN
				[INDIGO035].[Payroll].[Contract] AS coo  ON coo.Id = co.ID LEFT OUTER JOIN
		   [INDIGO035].[Payroll].[FundContract] AS fc  ON fc.ContractId = coo.Id AND fc.FundType = '1' AND fc.State = '1' LEFT OUTER JOIN
           [INDIGO035].[Payroll].[Fund] AS salud  ON salud.Id = fc.FundId left outer  JOIN
           [INDIGO035].[Common].[ThirdParty] AS TPS  ON TPS.Id = salud.ThirdPartyId LEFT OUTER JOIN
           [INDIGO035].[Payroll].[FunctionalUnit] AS fu  ON fu.Id = coo.FunctionalUnitId LEFT OUTER JOIN
           [INDIGO035].[Payroll].[CostCenter] AS cc  ON fu.CostCenterId = cc.Id --LEFT OUTER JOIN 
		   --Payroll.Liquidation AS linc  on linc.EmployeeId=lq.EmployeeId and linc.AmbulatoryDisabilityAuthorizationNumber=lq.AutorizationNumber LEFT OUTER JOIN 
		   --Payroll.Liquidation AS lmat  on lmat.EmployeeId=lq.EmployeeId and lmat.MaternityLeaveAutorizationNumber=lq.AutorizationNumber 
where  (LQ.RealDate)>='01-01-2022'  and LQ.TypeNovelty in ('1')   and LQ.InabilityClass not in ('3') and LQ.Status<>'2'

) as liq 
