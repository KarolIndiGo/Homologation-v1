-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Payroll_LiquidaciónIncapacidades
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[Payroll_LiquidaciónIncapacidades]    Script Date: 9/04/2025 10:32:24 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO




CREATE view [ViewInternal].[Payroll_LiquidaciónIncapacidades] as

select *
from (

select 
TPS.NIT as Nit, TPS.NAME AS Cliente, lq.id as Factura, '7' as Estado, '11' as Categoria, lq.RealDate as FechaInicial,  lq.Enddate as FechaFinal,
'NOVEDAD' +' ' + CASE WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2021 THEN 'NOVIEMBRE 2021'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2021 THEN 'DICIEMBRE 2021'
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2022 THEN 'ENERO 2022'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2022 THEN 'FEBRERO 2022'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2022 THEN 'MARZO 2022'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2022 THEN 'ABRIL 2022'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2022 THEN 'MAYO 2022'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2022 THEN 'JUNIO 2022'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2022 THEN 'JULIO 2022'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2022 THEN 'AGOSTO 2022'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2022 THEN 'SEPTIEMBRE 2022'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2022 THEN 'OCTUBRE 2022'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2022 THEN 'NOVIEMBRE 2022'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2022 THEN 'DICIEMBRE 2022'
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2023 THEN 'ENERO 2023'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2023 THEN 'FEBRERO 2023'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2023 THEN 'MARZO 2023'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2023 THEN 'ABRIL 2023'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2023 THEN 'MAYO 2023'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2023 THEN 'JUNIO 2023'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2023 THEN 'JULIO 2023'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2023 THEN 'AGOSTO 2023'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2023 THEN 'SEPTIEMBRE 2023'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2023 THEN 'OCTUBRE 2023'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2023 THEN 'NOVIEMBRE 2023'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2023 THEN 'DICIEMBRE 2023'
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2024 THEN 'ENERO 2024'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2024 THEN 'FEBRERO 2024'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2024 THEN 'MARZO 2024'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2024 THEN 'ABRIL 2024'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2024 THEN 'MAYO 2024'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2024 THEN 'JUNIO 2024'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2024 THEN 'JULIO 2024'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2024 THEN 'AGOSTO 2024'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2024 THEN 'SEPTIEMBRE 2024'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2024 THEN 'OCTUBRE 2024'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2024 THEN 'NOVIEMBRE 2024'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2024 THEN 'DICIEMBRE 2024' 
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2025 THEN 'ENERO 2025'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2025 THEN 'FEBRERO 2025'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2025 THEN 'MARZO 2025'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2025 THEN 'ABRIL 2025'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2025 THEN 'MAYO 2025'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2025 THEN 'JUNIO 2025'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2025 THEN 'JULIO 2025'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2025 THEN 'AGOSTO 2025'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2025 THEN 'SEPTIEMBRE 2025'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2025 THEN 'OCTUBRE 2025'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2025 THEN 'NOVIEMBRE 2025'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2025 THEN 'DICIEMBRE 2025'end as MesNovedad,

lq.Days as [Plazo (DiasINC)], '1' as [No. Cuotas],
'108' as CuentaContable, 
cc.id as CentroCosto, 'NOMINA' +' ' + 
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
					  WHEN MONTH(linc.PayrollDateLiquidated)= 12 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN 'DICIEMBRE 2024'  
					  WHEN MONTH(linc.PayrollDateLiquidated)= 1 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'ENERO 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 2 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'FEBRERO 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 3 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'MARZO 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 4 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'ABRIL 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 5 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'MAYO 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 6 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'JUNIO 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 7 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'JULIO 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 8 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'AGOSTO 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 9 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'SEPTIEMBRE 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 10 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'OCTUBRE 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 11 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'NOVIEMBRE 2025'
					  WHEN MONTH(linc.PayrollDateLiquidated)= 12 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN 'DICIEMBRE 2025'end as Observacion,
																									 (LQ.EPSRecognizeValue) AS ValorEPS, 
(lq.EPSRecognizeValue) as Saldo,

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
	  WHEN MONTH(linc.PayrollDateLiquidated) = 12 AND YEAR(linc.PayrollDateLiquidated)= 2024 THEN '31-12-2024' 
	  WHEN MONTH(linc.PayrollDateLiquidated) = 1 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '31-01-2025'
      WHEN MONTH(linc.PayrollDateLiquidated) = 2 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '28-02-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 3 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '31-03-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 4 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '30-04-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 5 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '31-05-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 6 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '30-06-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 7 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '31-07-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 8 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '31-08-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 9 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '30-09-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 10 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '31-10-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 11 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '30-11-2025'
	  WHEN MONTH(linc.PayrollDateLiquidated) = 12 AND YEAR(linc.PayrollDateLiquidated)= 2025 THEN '31-12-2025'END as FechaLiquidacion,
	  MONTH(linc.PayrollDateLiquidated) AS MesLiquida,

lq.value as VrLiquidado,

linc.MaternityLeaveValue + LINC.AccumulatedOtherAccrued as VrSubir,

cc.id as CentroCostoGlosas, '108' as CuentaContable_SinRadicar,  '108' as CuentaContable_Radicada,
'108' as CuentaContable_GlosaSubsanable, '108' as CuentaContable_Conciliacion, '108' as CuentaContable_CobroJuridico, '' as CuentaContable_OrdenGlosa, '' as CuentaContable_AcrededorGlosa,
TP.NIT AS DocumentoUsuario, tp.name as Usuario, ltrim(rtrim(TP.NIT)) +'-'+ ltrim(rtrim(tp.name)) as CompletoUsuario ,case lq.InabilityClass when 1 then 'Ambulatoria' when 2 then 'Hospitalaria' 
		   when 3 then 'Maternidad' when 4 then 'Enfermedad Profesional'  when 5 then 'Paternidad'  end as TipoIncapacidad, e.id
FROM	(select max(lq.id) as id, max(realdate) as realdate,max(EndDate) as Enddate, sum(days) as Days, sum(EPSRecognizeValue) as EPSRecognizeValue, EmployeeId, AutorizationNumber, InabilityClass, TypeNovelty, sum(value) as value
			FROM	Payroll.Novelty AS LQ 
				group by EmployeeId,  AutorizationNumber, InabilityClass, TypeNovelty) as lq  left outer join
		Payroll.Employee AS E on e. id=lq.employeeid left outer  JOIN
           Common.ThirdParty AS TP WITH (NOLOCK) ON TP.Id = E.ThirdPartyId INNER JOIN
           (SELECT max(ID) as ID, EMPLOYEEID, MAX(ContractInitialDate) as ContractInitialDate
				FROM Payroll.Contract
				--where employeeid='7836'
				GROUP BY  EMPLOYEEID) AS co  ON co.EmployeeId = E.Id LEFT OUTER JOIN
				Payroll.Contract AS coo WITH (NOLOCK) ON coo.ID = co.Id LEFT OUTER JOIN
		   Payroll.FundContract AS fc WITH (NOLOCK) ON fc.ContractId = coo.Id AND fc.FundType = '1' AND fc.State = '1' LEFT OUTER JOIN
           Payroll.Fund AS salud WITH (NOLOCK) ON salud.Id = fc.FundId left outer  JOIN
           Common.ThirdParty AS TPS WITH (NOLOCK) ON TPS.Id = salud.ThirdPartyId LEFT OUTER JOIN
           Payroll.FunctionalUnit AS fu WITH (NOLOCK) ON fu.Id = coo.FunctionalUnitId LEFT OUTER JOIN
           Payroll.CostCenter AS cc WITH (NOLOCK) ON fu.CostCenterId = cc.Id LEFT OUTER JOIN 
		   Payroll.Liquidation AS linc with (nolock) on linc.EmployeeId=lq.EmployeeId and linc.MaternityLeaveAutorizationNumber=lq.AutorizationNumber --LEFT OUTER JOIN 
		   --Payroll.Liquidation AS lmat with (nolock) on lmat.EmployeeId=lq.EmployeeId and lmat.MaternityLeaveAutorizationNumber=lq.AutorizationNumber 
where  (lq.RealDate)>='01-01-2022' and lq.TypeNovelty in ('1')   and lq.InabilityClass=3 

union all 


select 
TPS.NIT as Nit, TPS.NAME AS Cliente, lq.id as Factura, '7' as Estado, '11' as Categoria, lq.RealDate as FechaInicial, lq.EndDate as FechaFinal, 
'NOVEDAD' +' ' + CASE WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2021 THEN 'NOVIEMBRE 2021'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2021 THEN 'DICIEMBRE 2021'
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2022 THEN 'ENERO 2022'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2022 THEN 'FEBRERO 2022'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2022 THEN 'MARZO 2022'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2022 THEN 'ABRIL 2022'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2022 THEN 'MAYO 2022'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2022 THEN 'JUNIO 2022'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2022 THEN 'JULIO 2022'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2022 THEN 'AGOSTO 2022'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2022 THEN 'SEPTIEMBRE 2022'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2022 THEN 'OCTUBRE 2022'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2022 THEN 'NOVIEMBRE 2022'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2022 THEN 'DICIEMBRE 2022'
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2023 THEN 'ENERO 2023'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2023 THEN 'FEBRERO 2023'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2023 THEN 'MARZO 2023'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2023 THEN 'ABRIL 2023'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2023 THEN 'MAYO 2023'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2023 THEN 'JUNIO 2023'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2023 THEN 'JULIO 2023'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2023 THEN 'AGOSTO 2023'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2023 THEN 'SEPTIEMBRE 2023'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2023 THEN 'OCTUBRE 2023'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2023 THEN 'NOVIEMBRE 2023'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2023 THEN 'DICIEMBRE 2023'
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2024 THEN 'ENERO 2024'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2024 THEN 'FEBRERO 2024'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2024 THEN 'MARZO 2024'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2024 THEN 'ABRIL 2024'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2024 THEN 'MAYO 2024'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2024 THEN 'JUNIO 2024'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2024 THEN 'JULIO 2024'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2024 THEN 'AGOSTO 2024'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2024 THEN 'SEPTIEMBRE 2024'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2024 THEN 'OCTUBRE 2024'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2024 THEN 'NOVIEMBRE 2024'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2024 THEN 'DICIEMBRE 2024'
					  WHEN MONTH(lq.RealDate)= 1 AND YEAR(lq.RealDate)= 2025 THEN 'ENERO 2025'
					  WHEN MONTH(lq.RealDate)= 2 AND YEAR(lq.RealDate)= 2025 THEN 'FEBRERO 2025'
					  WHEN MONTH(lq.RealDate)= 3 AND YEAR(lq.RealDate)= 2025 THEN 'MARZO 2025'
					  WHEN MONTH(lq.RealDate)= 4 AND YEAR(lq.RealDate)= 2025 THEN 'ABRIL 2025'
					  WHEN MONTH(lq.RealDate)= 5 AND YEAR(lq.RealDate)= 2025 THEN 'MAYO 2025'
					  WHEN MONTH(lq.RealDate)= 6 AND YEAR(lq.RealDate)= 2025 THEN 'JUNIO 2025'
					  WHEN MONTH(lq.RealDate)= 7 AND YEAR(lq.RealDate)= 2025 THEN 'JULIO 2025'
					  WHEN MONTH(lq.RealDate)= 8 AND YEAR(lq.RealDate)= 2025 THEN 'AGOSTO 2025'
					  WHEN MONTH(lq.RealDate)= 9 AND YEAR(lq.RealDate)= 2025 THEN 'SEPTIEMBRE 2025'
					  WHEN MONTH(lq.RealDate)= 10 AND YEAR(lq.RealDate)= 2025 THEN 'OCTUBRE 2025'
					  WHEN MONTH(lq.RealDate)= 11 AND YEAR(lq.RealDate)= 2025 THEN 'NOVIEMBRE 2025'
					  WHEN MONTH(lq.RealDate)= 12 AND YEAR(lq.RealDate)= 2025 THEN 'DICIEMBRE 2025' end as MesNovedad,
lq.Days as [Plazo (DiasINC)], '1' as [No. Cuotas],
'108' as CuentaContable, 
cc.id as CentroCosto, 'NOMINA' +' ' + 
CASE				  WHEN MONTH(lq.CreationDate)= 11 AND YEAR(lq.CreationDate)= 2021 THEN 'NOVIEMBRE 2021'
					  WHEN MONTH(lq.CreationDate)= 12 AND YEAR(lq.CreationDate)= 2021 THEN 'DICIEMBRE 2021'
					  WHEN MONTH(lq.CreationDate)= 1 AND YEAR(lq.CreationDate)= 2022 THEN 'ENERO 2022'
					  WHEN MONTH(lq.CreationDate)= 2 AND YEAR(lq.CreationDate)= 2022 THEN 'FEBRERO 2022'
					  WHEN MONTH(lq.CreationDate)= 3 AND YEAR(lq.CreationDate)= 2022 THEN 'MARZO 2022'
					  WHEN MONTH(lq.CreationDate)= 4 AND YEAR(lq.CreationDate)= 2022 THEN 'ABRIL 2022'
					  WHEN MONTH(lq.CreationDate)= 5 AND YEAR(lq.CreationDate)= 2022 THEN 'MAYO 2022'
					  WHEN MONTH(lq.CreationDate)= 6 AND YEAR(lq.CreationDate)= 2022 THEN 'JUNIO 2022'
					  WHEN MONTH(lq.CreationDate)= 7 AND YEAR(lq.CreationDate)= 2022 THEN 'JULIO 2022'
					  WHEN MONTH(lq.CreationDate)= 8 AND YEAR(lq.CreationDate)= 2022 THEN 'AGOSTO 2022'
					  WHEN MONTH(lq.CreationDate)= 9 AND YEAR(lq.CreationDate)= 2022 THEN 'SEPTIEMBRE 2022'
					  WHEN MONTH(lq.CreationDate)= 10 AND YEAR(lq.CreationDate)= 2022 THEN 'OCTUBRE 2022'
					  WHEN MONTH(lq.CreationDate)= 11 AND YEAR(lq.CreationDate)= 2022 THEN 'NOVIEMBRE 2022'
					  WHEN MONTH(lq.CreationDate)= 12 AND YEAR(lq.CreationDate)= 2022 THEN 'DICIEMBRE 2022'
					  WHEN MONTH(lq.CreationDate)= 1 AND YEAR(lq.CreationDate)= 2023 THEN 'ENERO 2023'
					  WHEN MONTH(lq.CreationDate)= 2 AND YEAR(lq.CreationDate)= 2023 THEN 'FEBRERO 2023'
					  WHEN MONTH(lq.CreationDate)= 3 AND YEAR(lq.CreationDate)= 2023 THEN 'MARZO 2023'
					  WHEN MONTH(lq.CreationDate)= 4 AND YEAR(lq.CreationDate)= 2023 THEN 'ABRIL 2023'
					  WHEN MONTH(lq.CreationDate)= 5 AND YEAR(lq.CreationDate)= 2023 THEN 'MAYO 2023'
					  WHEN MONTH(lq.CreationDate)= 6 AND YEAR(lq.CreationDate)= 2023 THEN 'JUNIO 2023'
					  WHEN MONTH(lq.CreationDate)= 7 AND YEAR(lq.CreationDate)= 2023 THEN 'JULIO 2023'
					  WHEN MONTH(lq.CreationDate)= 8 AND YEAR(lq.CreationDate)= 2023 THEN 'AGOSTO 2023'
					  WHEN MONTH(lq.CreationDate)= 9 AND YEAR(lq.CreationDate)= 2023 THEN 'SEPTIEMBRE 2023'
					  WHEN MONTH(lq.CreationDate)= 10 AND YEAR(lq.CreationDate)= 2023 THEN 'OCTUBRE 2023'
					  WHEN MONTH(lq.CreationDate)= 11 AND YEAR(lq.CreationDate)= 2023 THEN 'NOVIEMBRE 2023'
					  WHEN MONTH(lq.CreationDate)= 12 AND YEAR(lq.CreationDate)= 2023 THEN 'DICIEMBRE 2023'
					  WHEN MONTH(lq.CreationDate)= 1 AND YEAR(lq.CreationDate)= 2024 THEN 'ENERO 2024'
					  WHEN MONTH(lq.CreationDate)= 2 AND YEAR(lq.CreationDate)= 2024 THEN 'FEBRERO 2024'
					  WHEN MONTH(lq.CreationDate)= 3 AND YEAR(lq.CreationDate)= 2024 THEN 'MARZO 2024'
					  WHEN MONTH(lq.CreationDate)= 4 AND YEAR(lq.CreationDate)= 2024 THEN 'ABRIL 2024'
					  WHEN MONTH(lq.CreationDate)= 5 AND YEAR(lq.CreationDate)= 2024 THEN 'MAYO 2024'
					  WHEN MONTH(lq.CreationDate)= 6 AND YEAR(lq.CreationDate)= 2024 THEN 'JUNIO 2024'
					  WHEN MONTH(lq.CreationDate)= 7 AND YEAR(lq.CreationDate)= 2024 THEN 'JULIO 2024'
					  WHEN MONTH(lq.CreationDate)= 8 AND YEAR(lq.CreationDate)= 2024 THEN 'AGOSTO 2024'
					  WHEN MONTH(lq.CreationDate)= 9 AND YEAR(lq.CreationDate)= 2024 THEN 'SEPTIEMBRE 2024'
					  WHEN MONTH(lq.CreationDate)= 10 AND YEAR(lq.CreationDate)= 2024 THEN 'OCTUBRE 2024'
					  WHEN MONTH(lq.CreationDate)= 11 AND YEAR(lq.CreationDate)= 2024 THEN 'NOVIEMBRE 2024'
					  WHEN MONTH(lq.CreationDate)= 12 AND YEAR(lq.CreationDate)= 2024 THEN 'DICIEMBRE 2024'
					  WHEN MONTH(lq.CreationDate)= 1 AND YEAR(lq.CreationDate)= 2025 THEN 'ENERO 2025'
					  WHEN MONTH(lq.CreationDate)= 2 AND YEAR(lq.CreationDate)= 2025 THEN 'FEBRERO 2025'
					  WHEN MONTH(lq.CreationDate)= 3 AND YEAR(lq.CreationDate)= 2025 THEN 'MARZO 2025'
					  WHEN MONTH(lq.CreationDate)= 4 AND YEAR(lq.CreationDate)= 2025 THEN 'ABRIL 2025'
					  WHEN MONTH(lq.CreationDate)= 5 AND YEAR(lq.CreationDate)= 2025 THEN 'MAYO 2025'
					  WHEN MONTH(lq.CreationDate)= 6 AND YEAR(lq.CreationDate)= 2025 THEN 'JUNIO 2025'
					  WHEN MONTH(lq.CreationDate)= 7 AND YEAR(lq.CreationDate)= 2025 THEN 'JULIO 2025'
					  WHEN MONTH(lq.CreationDate)= 8 AND YEAR(lq.CreationDate)= 2025 THEN 'AGOSTO 2025'
					  WHEN MONTH(lq.CreationDate)= 9 AND YEAR(lq.CreationDate)= 2025 THEN 'SEPTIEMBRE 2025'
					  WHEN MONTH(lq.CreationDate)= 10 AND YEAR(lq.CreationDate)= 2025 THEN 'OCTUBRE 2025'
					  WHEN MONTH(lq.CreationDate)= 11 AND YEAR(lq.CreationDate)= 2025 THEN 'NOVIEMBRE 2025'
					  WHEN MONTH(lq.CreationDate)= 12 AND YEAR(lq.CreationDate)= 2025 THEN 'DICIEMBRE 2025'end as Observacion,
																									 (LQ.EPSRecognizeValue) AS ValorEPS, 
(lq.EPSRecognizeValue) as Saldo,

 CASE WHEN MONTH(lq.CreationDate) = 11 AND YEAR(lq.CreationDate)= 2021 THEN '30-11-2021' 
	  WHEN MONTH(lq.CreationDate) = 12 AND YEAR(lq.CreationDate)= 2021 THEN '31-12-2021'
	  WHEN MONTH(lq.CreationDate) = 1 AND YEAR(lq.CreationDate)= 2022 THEN '31-01-2022'
      WHEN MONTH(lq.CreationDate) = 2 AND YEAR(lq.CreationDate)= 2022 THEN '28-02-2022'
	  WHEN MONTH(lq.CreationDate) = 3 AND YEAR(lq.CreationDate)= 2022 THEN '31-03-2022'
	  WHEN MONTH(lq.CreationDate) = 4 AND YEAR(lq.CreationDate)= 2022 THEN '30-04-2022'
	  WHEN MONTH(lq.CreationDate) = 5 AND YEAR(lq.CreationDate)= 2022 THEN '31-05-2022'
	  WHEN MONTH(lq.CreationDate) = 6 AND YEAR(lq.CreationDate)= 2022 THEN '30-06-2022'
	  WHEN MONTH(lq.CreationDate) = 7 AND YEAR(lq.CreationDate)= 2022 THEN '31-07-2022'
	  WHEN MONTH(lq.CreationDate) = 8 AND YEAR(lq.CreationDate)= 2022 THEN '31-08-2022'
	  WHEN MONTH(lq.CreationDate) = 9 AND YEAR(lq.CreationDate)= 2022 THEN '30-09-2022'
	  WHEN MONTH(lq.CreationDate) = 10 AND YEAR(lq.CreationDate)= 2022 THEN '31-10-2022'
	  WHEN MONTH(lq.CreationDate) = 11 AND YEAR(lq.CreationDate)= 2022 THEN '30-11-2022'
	  WHEN MONTH(lq.CreationDate)= 12 AND YEAR(lq.CreationDate)= 2022 THEN '31-12-2022'	  
	  WHEN MONTH(lq.CreationDate) = 1 AND YEAR(lq.CreationDate)= 2023 THEN '31-01-2023'
      WHEN MONTH(lq.CreationDate) = 2 AND YEAR(lq.CreationDate)= 2023 THEN '28-02-2023'
	  WHEN MONTH(lq.CreationDate) = 3 AND YEAR(lq.CreationDate)= 2023 THEN '31-03-2023'
	  WHEN MONTH(lq.CreationDate) = 4 AND YEAR(lq.CreationDate)= 2023 THEN '30-04-2023'
	  WHEN MONTH(lq.CreationDate) = 5 AND YEAR(lq.CreationDate)= 2023 THEN '31-05-2023'
	  WHEN MONTH(lq.CreationDate) = 6 AND YEAR(lq.CreationDate)= 2023 THEN '30-06-2023'
	  WHEN MONTH(lq.CreationDate) = 7 AND YEAR(lq.CreationDate)= 2023 THEN '31-07-2023'
	  WHEN MONTH(lq.CreationDate) = 8 AND YEAR(lq.CreationDate)= 2023 THEN '31-08-2023'
	  WHEN MONTH(lq.CreationDate) = 9 AND YEAR(lq.CreationDate)= 2023 THEN '30-09-2023'
	  WHEN MONTH(lq.CreationDate) = 10 AND YEAR(lq.CreationDate)= 2023 THEN '31-10-2023'
	  WHEN MONTH(lq.CreationDate) = 11 AND YEAR(lq.CreationDate)= 2023 THEN '30-11-2023'
	  WHEN MONTH(lq.CreationDate)= 12 AND YEAR(lq.CreationDate)= 2023 THEN '31-12-2023'
	  WHEN MONTH(lq.CreationDate) = 1 AND YEAR(lq.CreationDate)= 2024 THEN '31-01-2024'
      WHEN MONTH(lq.CreationDate) = 2 AND YEAR(lq.CreationDate)= 2024 THEN '29-02-2024'
	  WHEN MONTH(lq.CreationDate) = 3 AND YEAR(lq.CreationDate)= 2024 THEN '31-03-2024'
	  WHEN MONTH(lq.CreationDate) = 4 AND YEAR(lq.CreationDate)= 2024 THEN '30-04-2024'
	  WHEN MONTH(lq.CreationDate) = 5 AND YEAR(lq.CreationDate)= 2024 THEN '31-05-2024'
	  WHEN MONTH(lq.CreationDate) = 6 AND YEAR(lq.CreationDate)= 2024 THEN '30-06-2024'
	  WHEN MONTH(lq.CreationDate) = 7 AND YEAR(lq.CreationDate)= 2024 THEN '31-07-2024'
	  WHEN MONTH(lq.CreationDate) = 8 AND YEAR(lq.CreationDate)= 2024 THEN '31-08-2024'
	  WHEN MONTH(lq.CreationDate) = 9 AND YEAR(lq.CreationDate)= 2024 THEN '30-09-2024'
	  WHEN MONTH(lq.CreationDate) = 10 AND YEAR(lq.CreationDate)= 2024 THEN '31-10-2024'
	  WHEN MONTH(lq.CreationDate) = 11 AND YEAR(lq.CreationDate)= 2024 THEN '30-11-2024'
	  WHEN MONTH(lq.CreationDate) = 12 AND YEAR(lq.CreationDate)= 2024 THEN '31-12-2024' 
	  WHEN MONTH(lq.CreationDate) = 1 AND YEAR(lq.CreationDate)= 2025 THEN '31-01-2025'
      WHEN MONTH(lq.CreationDate) = 2 AND YEAR(lq.CreationDate)= 2025 THEN '28-02-2025'
	  WHEN MONTH(lq.CreationDate) = 3 AND YEAR(lq.CreationDate)= 2025 THEN '31-03-2025'
	  WHEN MONTH(lq.CreationDate) = 4 AND YEAR(lq.CreationDate)= 2025 THEN '30-04-2025'
	  WHEN MONTH(lq.CreationDate) = 5 AND YEAR(lq.CreationDate)= 2025 THEN '31-05-2025'
	  WHEN MONTH(lq.CreationDate) = 6 AND YEAR(lq.CreationDate)= 2025 THEN '30-06-2025'
	  WHEN MONTH(lq.CreationDate) = 7 AND YEAR(lq.CreationDate)= 2025 THEN '31-07-2025'
	  WHEN MONTH(lq.CreationDate) = 8 AND YEAR(lq.CreationDate)= 2025 THEN '31-08-2025'
	  WHEN MONTH(lq.CreationDate) = 9 AND YEAR(lq.CreationDate)= 2025 THEN '30-09-2025'
	  WHEN MONTH(lq.CreationDate) = 10 AND YEAR(lq.CreationDate)= 2025 THEN '31-10-2025'
	  WHEN MONTH(lq.CreationDate) = 11 AND YEAR(lq.CreationDate)= 2025 THEN '30-11-2025'
	  WHEN MONTH(lq.CreationDate) = 12 AND YEAR(lq.CreationDate)= 2025 THEN '31-12-2025' END as FechaLiquidacion,
	   MONTH(lq.CreationDate) AS MesLiquida,
lq.value as VrLiquidado,
case when lq.InabilityClass in ('1','2','5') and co.name like '%incapacidad%' then 0
    when lq.InabilityClass in ('1','2','5') and co.name not like '%incapacidad%' then lq.EPSRecognizeValue
	 when lq.InabilityClass in ('3') then lq.LiquidationBase
	 when  lq.InabilityClass in ('4') and month(RealDate)<>month(EndDate) and EPSDays=1 then lq.EPSRecognizeValue
	 when  lq.InabilityClass in ('4') and month(RealDate)=month(EndDate) and EPSDays=1 then lq.PaidPayrollValue
	 when  lq.InabilityClass in ('4') and month(RealDate)<>month(EndDate) and  EPSDays>1 then lq.PaidPayrollValue
	 when  lq.InabilityClass in ('4') and EPSDays>27  and lq.PaidEmployerValue<1 then lq.LiquidationBase
	 	when  lq.InabilityClass in ('4') and EPSDays=1 and EmployerDays=1 then lq.PaidPayrollValue
		when  lq.InabilityClass in ('4') and EPSDays=1 then lq.EPSRecognizeValue
	 when lq.InabilityClass in ('4') and EPSDays<27   then lq.PaidPayrollValue end as VrSubir,

cc.id as CentroCostoGlosas, '108' as CuentaContable_SinRadicar,  '108' as CuentaContable_Radicada,
'108' as CuentaContable_GlosaSubsanable, '108' as CuentaContable_Conciliacion, '108' as CuentaContable_CobroJuridico, '' as CuentaContable_OrdenGlosa, '' as CuentaContable_AcrededorGlosa,
TP.NIT AS DocumentoUsuario, tp.name as Usuario,  ltrim(rtrim(TP.NIT)) +'-'+ ltrim(rtrim(tp.name)) as CompletoUsuario ,case lq.InabilityClass when 1 then 'Ambulatoria' when 2 then 'Hospitalaria' 
		   when 3 then 'Maternidad' when 4 then 'Enfermedad Profesional'  when 5 then 'Paternidad'  end as TipoIncapacidad, e.id
FROM	Payroll.Novelty AS LQ  left outer join
		Payroll.Employee AS E on e. id=lq.employeeid left outer  JOIN
           Common.ThirdParty AS TP WITH (NOLOCK) ON TP.Id = E.ThirdPartyId INNER JOIN
           (SELECT max(co.ID) as ID, EMPLOYEEID, MAX(ContractInitialDate) as ContractInitialDate, g.name
				FROM Payroll.Contract as co inner join
				Payroll.[Group] AS g  ON co.GroupId = g.Id 
				--where --co.Status=1
				--where employeeid='7836'
				GROUP BY  EMPLOYEEID, g.name) AS co  ON co.EmployeeId = E.Id LEFT OUTER JOIN
				Payroll.Contract AS coo WITH (NOLOCK) ON coo.ID = co.Id LEFT OUTER JOIN
		   Payroll.FundContract AS fc WITH (NOLOCK) ON fc.ContractId = coo.Id AND fc.FundType = '1' AND fc.State = '1' LEFT OUTER JOIN
           Payroll.Fund AS salud WITH (NOLOCK) ON salud.Id = fc.FundId left outer  JOIN
           Common.ThirdParty AS TPS WITH (NOLOCK) ON TPS.Id = salud.ThirdPartyId LEFT OUTER JOIN
           Payroll.FunctionalUnit AS fu WITH (NOLOCK) ON fu.Id = coo.FunctionalUnitId LEFT OUTER JOIN
           Payroll.CostCenter AS cc WITH (NOLOCK) ON fu.CostCenterId = cc.Id --LEFT OUTER JOIN 
		   --Payroll.Liquidation AS linc with (nolock) on linc.EmployeeId=lq.EmployeeId and linc.AmbulatoryDisabilityAuthorizationNumber=lq.AutorizationNumber LEFT OUTER JOIN 
		   --Payroll.Liquidation AS lmat with (nolock) on lmat.EmployeeId=lq.EmployeeId and lmat.MaternityLeaveAutorizationNumber=lq.AutorizationNumber 
where  (lq.RealDate)>='01-01-2022'  and lq.TypeNovelty in ('1')   and lq.InabilityClass not in ('3') and lq.Status<>'2'

) as liq 

--WHERE    liq.DocumentoUsuario='1075294719' 
--order by liq.FechaNovedad

--WHERE --DocumentoUsuario='1010148971'   
--MesLiquida= 6
--GO


