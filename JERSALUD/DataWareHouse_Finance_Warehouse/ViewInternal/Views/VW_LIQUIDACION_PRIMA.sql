-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_LIQUIDACION_PRIMA
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_LIQUIDACION_PRIMA] AS

SELECT DISTINCT  CAST(TP.Nit AS numeric) as Identificacion, --e.id as a,
TP.Name as NombreEmpleado, 
G.Code as CodigoGrupo,
G.Name as NombreGrupo,
POS.Name as Cargo, 
C1.Name as Ciudad,
BO.Name as Sede,
FU.Name as UnidadFuncional, 
CC.Name as CentroCosto, 
CASE WHEN CT.SalaryType = 1 THEN 'FIJO' WHEN CT.SalaryType = 2 THEN 'INTEGRAL' ELSE 'VARIABLE' END AS TipoSalario, 
BA.Name as Banco,
CONT.BankAccountNumber as CuentaBancaria,
CONT.JobBondingDate as Nov_Ingreso,
(PA.LegalSalaryMinimum) AS Salario_Minimo,
CAST(CONT.BasicSalary AS DECIMAL(19,4)) as SueldoActual,
CASE WHEN cast((PA.LegalSalaryMinimum * 2) as DECIMAL(19,4)) <= cast(CONT.BasicSalary as DECIMAL(19,4)) THEN 0 ELSE PA.TransportHelpValue END Auxilio_Transporte,
L.WorkingDays as DiasLaborados,
L.SanctionDays as DiasSancion,
--(SELECT SUM(CASE WHEN DD.ConceptClass IN ('042','043','051','052') THEN ISNULL(DD.AccruedValue,0) ELSE 0 END)  --select * from Payroll.Liquidation
--	FROM Payroll.Liquidation LI LEFT JOIN Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id 
--	WHERE LI.InitialContractNumber=CONT.Id AND LI.EmployeeId=E.ID AND LI.PayrollDateLiquidated between '2025-01-01' and '2025-06-30') as Valor_Recargos,
(SELECT  SUM(ConceptTotalValue)
	FROM INDIGO031.Payroll.Liquidation as LI
	LEFT JOIN INDIGO031.Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id
	WHERE   LI.EmployeeId=E.Id and LI.PayrollDateLiquidated  between '2025-01-01' and '2025-06-30' and DD.ConceptClass IN ('042','043','051','052') and LI.InitialContractNumber=CONT.InitialContractNumber) as Valor_Recargos,

--(SELECT SUM(CASE WHEN DD.ConceptClass IN ('001','012','013','050') THEN ISNULL(DD.AccruedValue,0) ELSE 0 END) 
--	FROM Payroll.Liquidation LI LEFT JOIN Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id 
--	WHERE LI.InitialContractNumber=CONT.Id AND LI.EmployeeId=E.ID AND LI.PayrollDateLiquidated between '2025-01-01' and '2025-06-30') as Valor_HorasExtras,
--(SELECT  SUM(ConceptTotalValue) 
--	FROM Payroll.Liquidation as LI 
--	LEFT JOIN Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id
--	WHERE   --LI.EmployeeId=E.ID and 
--	LI.PayrollDateLiquidated  between '2025-01-01' and '2025-06-30' and DD.ConceptClass IN (/*'001',*/'012','013','050') /*and li.EmployeeId=1982*/) as Valor_HorasExtras,

	(SELECT  SUM(ConceptTotalValue) 
	FROM INDIGO031.Payroll.Liquidation as LI 
	LEFT JOIN INDIGO031.Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id
	WHERE   LI.EmployeeId=E.Id and LI.PayrollDateLiquidated  between '2025-01-01' and '2025-06-30' and DD.ConceptClass IN ('001','012','013','050') and LI.InitialContractNumber=CONT.InitialContractNumber) as Valor_HorasExtras,

--(SELECT SUM(CASE WHEN DD.ConceptClass IN ('010') THEN ISNULL(DD.AccruedValue,0) ELSE 0 END) 
--	FROM Payroll.Liquidation LI LEFT JOIN Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id 
--	WHERE LI.InitialContractNumber=CONT.Id AND LI.EmployeeId=E.ID AND LI.PayrollDateLiquidated between '2025-01-01' and '2025-06-30') as Valor_OtrosDevengados,
(SELECT  SUM(ConceptTotalValue) 
	FROM INDIGO031.Payroll.Liquidation as LI 
	LEFT JOIN INDIGO031.Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id
	WHERE   LI.EmployeeId=E.Id and LI.PayrollDateLiquidated  between '2025-01-01' and '2025-06-30' and DD.ConceptClass IN ('010') and LI.InitialContractNumber=CONT.InitialContractNumber) as Valor_OtrosDevengados,
--((SELECT SUM(CASE WHEN DD.ConceptClass IN ('042','043','051','052','001','012','013','050') THEN ISNULL(DD.AccruedValue,0) ELSE 0 END) 
--	FROM Payroll.Liquidation LI LEFT JOIN Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id 
--	WHERE LI.InitialContractNumber=CONT.Id AND LI.EmployeeId=E.ID AND LI.PayrollDateLiquidated between '2025-01-01' and '2025-06-30')/L.WorkingDays)*30  as Valor_Promedio,
((SELECT  SUM(ConceptTotalValue) 
	FROM INDIGO031.Payroll.Liquidation as LI 
	LEFT JOIN INDIGO031.Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id
	WHERE   LI.EmployeeId=E.Id and LI.PayrollDateLiquidated  between '2025-01-01' and '2025-06-30' and DD.ConceptClass IN ('042','043','051','052') and LI.InitialContractNumber=CONT.InitialContractNumber)/L.WorkingDays)*30  as Valor_Promedio, 
	L.WorkingDays,
L.TotalAccrued as TotalDevengado,
L.TotalDeducted as TotalDeducibles,
L.PaidValue as NetoPagar
FROM INDIGO031.Payroll.IncentivePayment L, 
INDIGO031.Payroll.Employee E, 
INDIGO031.Common.ThirdParty TP, 
INDIGO031.Payroll.[Contract] CONT, 
INDIGO031.Payroll.Position POS, 
INDIGO031.Payroll.FunctionalUnit FU, 
INDIGO031.Payroll.ContractType CT, 
INDIGO031.Payroll.[Group] G, 
INDIGO031.Payroll.CostCenter CC,
INDIGO031.Payroll.IncentivePaymentDetail LD,
INDIGO031.Payroll.BranchOffice BO,
INDIGO031.Common.City C1,
INDIGO031.Payroll.Bank BA,
INDIGO031.Payroll.PayrollParameter PA
WHERE L.ContractId = CONT.Id
AND E.ThirdPartyId = TP.Id
AND CONT.EmployeeId = E.Id
AND CONT.Id = L.ContractId
AND CONT.PositionId = POS.Id
AND FU.Id = CONT.FunctionalUnitId
AND CONT.ContractTypeId = CT.Id
AND L.GroupId = G.Id
AND FU.CostCenterId = CC.Id
AND L.Id = LD.IncentivePaymentId
AND BO.Id = FU.BranchOfficeId
AND BO.CityId = C1.Id
AND BA.Id = CONT.BankId
AND PA.Id = G.PayrollParameterId
AND (CONT.Status=1 OR CONT.Status=4)
AND L.RegisterStatus=1
--AND L.PeriodInitialDate= '2025-01-01'
AND E.Id IN (SELECT EmployeeId FROM INDIGO031.Payroll.Contract CONTR where CONTR.Status=1)
AND CONT.Status = '1'
--and TP.Nit='1121862640'
--305
--and tp.Nit='1082806294'

--and TP.Nit='7702023'

--SELECT  SUM(ConceptTotalValue) 
--	FROM Payroll.Liquidation as LI 
--	LEFT JOIN Payroll.LiquidationDetail DD ON DD.PayrollId = LI.Id
--	WHERE  LI.PayrollDateLiquidated  between '2025-01-01' and '2025-06-30'
--	and li.EmployeeId='1901' and DD.ConceptClass IN ('042','043','051','052')

--select * from 	Common.ThirdParty
--where nit='1076621023'

--select * from Payroll.[Contract]

--select * from payroll.Employee
--where ThirdPartyId=77396  --Id 1901

--Id	PersonId	Nit
