-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: CESANTIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[CESANTIAS] AS
SELECT DISTINCT CAST(TP.Nit AS numeric) as Identificacion,
TP.Name as NombreEmpleado,
G.Code as CodigoGrupo,
G.Name as NombreGrupo,
POS.Name as Cargo,
C1.Name as Ciudad,
BO.Name as Sede,
FU.Name as UnidadFuncional,
CC.Name as CentroCosto,
BA.Name as Banco,
(SELECT MAX(FO.NAME) FROM Payroll.Fund FO inner join Payroll.FundContract FC ON FO.ID= FC.FundId AND FC.ContractId=L.ContractId AND FC.FundType=3) as Fondo,
CONT.BankAccountNumber as CuentaBancaria,
CONT.JobBondingDate as Fecha_Ingreso,
CAST(CONT.BasicSalary AS money) as SueldoActual,
L.UnemployedInitialDate AS Fecha_Inicio,
concat('31-12-',year(L.UnemployedInitialDate)) as Fecha_Fin,
L.WorkedTotalDays as DiasLaborados,
L.AverageMothNumber as Meses,
L.SanctionTotalDays as DiasSancion,
L.TotalUnemployed as Total_Cesantias,
L.UnemployedInterestTotal AS Total_Intereses,
L.UnemployedInterestTotal + L.TotalUnemployed AS Total_General,
L.UnemployedInitialDate AS Fecha_Inicio_Periodo_Cesantias,
L.UnemployedEndingDate AS Fecha_Fin_Periodo_Cesantias, 
L.UnemployedLiquidationDate AS Fecha_Liquidacion_Cesantias,
L.UnemployedPayDate AS Fecha_Pago_Cesantias,
L.UnemployedInterestPayDate AS Fecha_Pago_Intereses_Cesantias
FROM Payroll.UnemployedLiquidation L 
LEFT JOIN Payroll.Employee E  ON L.Employeeid=E.ID
LEFT JOIN Common.ThirdParty TP ON TP.ID=E.ThirdPartyId
LEFT JOIN Payroll.[Contract] CONT ON CONT.ID=L.ContractId
LEFT JOIN Payroll.Position POS ON POS.ID=CONT.PositionId
LEFT JOIN Payroll.FunctionalUnit FU ON FU.ID= CONT.FunctionalUnitId
LEFT JOIN Payroll.ContractType CT ON CT.ID= CONT.ContractTypeId
LEFT JOIN Payroll.[Group] G ON G.ID= CONT.GroupId
LEFT JOIN Payroll.CostCenter CC ON CC.ID= FU.CostCenterId
LEFT JOIN Payroll.UnemployedLiquidationDetail LD ON LD.UnemployedLiquidationId=L.ID
LEFT JOIN Payroll.BranchOffice BO ON BO.ID= FU.BranchOfficeId
LEFT JOIN Common.City C1 ON C1.ID=BO.CityId
LEFT JOIN Payroll.Bank BA ON BA.ID= CONT.BankId
LEFT JOIN Payroll.PayrollParameter PA ON PA.ID= G.PayrollParameterId
--WHERE Year(L.UnemployedLiquidationDate)='2021'
WHERE L.Year='2024'
AND (CONT.Status=1 OR CONT.Status=4)
--where YEAR(L.UnemployedInterestPayDate) BETWEEN '2021' AND '2021'
--AND  TP.Nit='7320627'
--ORDER BY Identificacion
