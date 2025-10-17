-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Payroll_Rev_NominaElect
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Payroll_Rev_NominaElect] as

SELECT TP.Nit as Documento, TP.Name as Empleado, CONC.Name as Concepto, CONC.Code as CodConcepto, 
CASE ld.ConceptClass
	WHEN '031' THEN 'PROVISIONES'
	WHEN '033' THEN 'PROVISIONES'
	WHEN '034' THEN 'PROVISIONES'
	WHEN '008' THEN 'PROVISIONES'

	WHEN '035' THEN 'PRESTACIONES SOCIALES'
	WHEN '036' THEN 'PRESTACIONES SOCIALES'
	WHEN '037' THEN 'PRESTACIONES SOCIALES'
	WHEN '018' THEN 'PRESTACIONES SOCIALES'
	WHEN '009' THEN 'PRESTACIONES SOCIALES'
	WHEN '015' THEN 'PRESTACIONES SOCIALES'
	ELSE 'NOMINA'
END AS TipoConcepto, 
'2025-09-01' as FechaInicio, 
'2025-09-30' as FechaFin, LD.ConceptTotalValue as Valor, 'F' as TipoSalario, 'N' AS TipoNomina, 
12 as PeriodoAcumulado, 12 as MesAcumulado, L.PayrollDays as NumeroDiasPeriodo,
L.DaysWorked as DiasTrabajados, CC.Code as CentroCosto, CC.Name as DescripcionCentroCosto, G.Name as Grupo
FROM Payroll.Employee E, Payroll.Liquidation L, 
Payroll.LiquidationDetail LD, Payroll.Concept CONC, 
Common.ThirdParty TP, Payroll.CostCenter CC, 
Payroll.[Group] G, Payroll.Contract PC
WHERE E.Id = L.EmployeeId and L.Id  =LD.PayrollId and LD.ConceptId = CONC.Id AND L.PayrollDateLiquidated = '2025-09-30' AND TP.Id = E.ThirdPartyId AND CC.Id = E.CostCenterId 
AND G.Id = L.GroupId and pc.EmployeeId=e.Id and pc.id=l.ContractId
