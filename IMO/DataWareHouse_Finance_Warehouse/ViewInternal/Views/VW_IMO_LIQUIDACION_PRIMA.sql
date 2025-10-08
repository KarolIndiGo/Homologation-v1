-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_LIQUIDACION_PRIMA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_LIQUIDACION_PRIMA
AS 

SELECT DISTINCT CAST(TP.Nit AS numeric) as Identificacion, 
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
(SELECT SUM(CASE WHEN DD.ConceptClass IN ('042','043','051','052','016') THEN ISNULL(DD.AccruedValue,0) ELSE 0 END) FROM [INDIGO035].[Payroll].[Liquidation] LI LEFT JOIN [INDIGO035].[Payroll].[LiquidationDetail] DD ON DD.PayrollId = LI.Id WHERE LI.EmployeeId=E.Id AND LI.PayrollDateLiquidated between '2022-01-01' and '2022-12-31') as Valor_Recargos,
(SELECT SUM(CASE WHEN DD.ConceptClass IN ('001','012','013','050') THEN ISNULL(DD.AccruedValue,0) ELSE 0 END) FROM [INDIGO035].[Payroll].[Liquidation] LI LEFT JOIN [INDIGO035].[Payroll].[LiquidationDetail] DD ON DD.PayrollId = LI.Id WHERE LI.EmployeeId=E.Id AND LI.PayrollDateLiquidated between '2022-01-01' and '2022-12-31') as Valor_HorasExtras,
(SELECT SUM(CASE WHEN DD.ConceptClass IN ('010') THEN ISNULL(DD.AccruedValue,0) ELSE 0 END) FROM [INDIGO035].[Payroll].[Liquidation] LI LEFT JOIN [INDIGO035].[Payroll].[LiquidationDetail] DD ON DD.PayrollId = LI.Id WHERE LI.EmployeeId=E.Id AND LI.PayrollDateLiquidated between '2022-01-01' and '2022-12-31') as Valor_OtrosDevengados,
((SELECT SUM(CASE WHEN DD.ConceptClass IN ('042','043','051','052','001','012','013','050','016')  THEN ISNULL(DD.AccruedValue,0) ELSE 0 END) FROM [INDIGO035].[Payroll].[Liquidation] LI LEFT JOIN [INDIGO035].[Payroll].[LiquidationDetail] DD ON DD.PayrollId = LI.Id WHERE LI.EmployeeId=E.Id AND LI.PayrollDateLiquidated between '2022-01-01' and '2022-12-31')/L.WorkingDays)*30  as Valor_Promedio,
L.TotalAccrued as TotalDevengado,
L.TotalDeducted as TotalDeducibles,
L.PaidValue as NetoPagar
FROM [INDIGO035].[Payroll].[IncentivePayment] L, 
[INDIGO035].[Payroll].[Employee] E, 
[INDIGO035].[Common].[ThirdParty] TP, 
[INDIGO035].[Payroll].[Contract] CONT, 
[INDIGO035].[Payroll].[Position] POS, 
[INDIGO035].[Payroll].[FunctionalUnit] FU, 
[INDIGO035].[Payroll].[ContractType] CT, 
[INDIGO035].[Payroll].[Group] G, 
[INDIGO035].[Payroll].[CostCenter] CC,
[INDIGO035].[Payroll].[IncentivePaymentDetail] LD,
[INDIGO035].[Payroll].[BranchOffice] BO,
[INDIGO035].[Common].[City] C1,
[INDIGO035].[Payroll].[Bank] BA,
[INDIGO035].[Payroll].[PayrollParameter] PA
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
--AND L.PeriodInitialDate= '2022-01-01'
AND E.Id IN (SELECT EmployeeId FROM [INDIGO035].[Payroll].Contract CONTR where CONTR.Status=1)

