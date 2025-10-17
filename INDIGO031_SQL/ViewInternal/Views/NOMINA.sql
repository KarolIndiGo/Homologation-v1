-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: NOMINA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[NOMINA] AS
SELECT DISTINCT TP.Nit as Identificacion,
TP.Name as NombreEmpleado, 
G.Code as CodigoGrupo,
G.Name as NombreGrupo,
POS.Name as Cargo, 
C1.Name as Ciudad,
BO.Name as Sede,
FU.Name as UnidadFuncional, 
CC.Name as CentroCosto, 
PR.Name as RiesgosProfesionales,
CASE WHEN CT.SalaryType = 1 THEN 'FIJO' WHEN CT.SalaryType = 2 THEN 'INTEGRAL' ELSE 'VARIABLE' END AS TipoSalario, 
'S' as Exoneracion,
'1' as TipoCotizante,
BA.Name as Banco,
L.BankAccountNumber as CuentaBancaria,
'NOMINA' as Tipo,
CAST(CONT.BasicSalary AS money) as SueldoActual,
POS.MaxHourAmount as Horas,
CONT.JobBondingDate as Nov_Ingreso,
E.VacationLastDateLiquidation as UltimasVacaciones,
ISNULL((SELECT ISNULL(SUM(PendingDays),0) FROM Payroll.VacationPeriod WHERE EmployeeId = L.EmployeeId GROUP BY EmployeeId),0) as DiasPendientesDisfrutar, 
CASE WHEN L.VacationDays > '0' THEN L.VacationInitialDate ELSE  NULL END AS VacacionesDesde,
CASE WHEN L.VacationDays > 0 THEN L.VacationEndDate ELSE NULL END AS VacacionesHasta,
L.VacationValueEnjoy as ValorVacaciones,
L.DaysWorked as DiasLaborados,
--CASE WHEN YEAR(CONT.JobBondingDate) = YEAR('2021-12-31') AND MONTH(CONT.JobBondingDate) = MONTH('2021-12-31') THEN 'X' ELSE '' END AS ING, 
--CASE WHEN YEAR(CONT.RetirementDate) = YEAR('2021-12-31') AND MONTH(CONT.RetirementDate) = MONTH('2021-12-31') THEN 'X' ELSE '' END AS RET, 
--'' AS TDE,
--'' AS TAE,
--'' AS TDP,
--'' AS TAP,
--'' AS VSP,
--'' AS VTE,
--'' AS VST,
CASE WHEN L.SanctionDays > 0 THEN 'X' ELSE '' END AS SAN,
CASE WHEN L.UnpaidLicenseDays > 0 THEN 'X' ELSE '' END AS LIC,
CASE WHEN L.AmbulatoryDisabilityDays > 0 THEN 'X' ELSE '' END AS INCAMB,
CASE WHEN L.DisabilityHospitalDays > 0 THEN 'X' ELSE '' END AS INCHOSP,
CASE WHEN L.MaternityLeaveDays > 0 THEN 'X' ELSE '' END AS LMA,
CASE WHEN L.VacationDays <> 0 THEN 'X' ELSE '' END AS VAC,
CASE WHEN L.VoluntaryContributionPensionValue > 0 THEN 'X' ELSE '' END AS AVP,
--'' AS VCT,
CASE WHEN L.OccupationalRisksDisabilityInitialDate <> '0001-01-01' THEN 'X' ELSE '' END AS IRP,
CONT.BasicSalary as SueldoBasico,
(SELECT sum(AccruedValue) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptCode = '001') as SueldoPagado, 
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('042') ) as RNN, 
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('043') ) as RND, 
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('051') ) as RDD, 
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('052') ) as RDF, 
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('042','043','051','052')) as ValorRecargos, 
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('001') ) as HEOD, 
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('012') ) as HEON,
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('013') ) as HEDD,
(SELECT ISNULL(sum(TotalNumberHours),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('050') ) as HEDN,
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('001','012','013','050') ) as ValorHE,
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('010') and ConceptCode <> '037' ) as OtrosDevengados, 
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('022','027','021') ) as Incapacidades, 
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass in('023') ) as Maternidad, 
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptCode = '037') as BonificacionSalarial, 
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '004') as BonificacionNoSalarial, 
--0 as InteresesCesantias,
(SELECT ISNULL(sum(AccruedValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '006') as AuxilioTransporte, 
L.TotalAccrued as TotalDevengado,
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '020') as RetencionFuente, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '038') as FSP, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '017') as Salud, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '014') as Pension, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '041' AND ConceptCode <> '506' and ConceptCode <> '402') as Libranzas, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptCode = '106') as AFC, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptCode in ('101','506', '402')) as MedicinaPrepagada, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '011' and ConceptCode not in ('104','108')) as OtrosDescuentos, 
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptCode = '108') as EmbargosJudiciales,
L.TotalDeducted as TotalDeducibles,
L.TotalPaid as NetoPagar,
L.ProvisionIncentive AS ProvisionPrimas, 
L.UnemploymentAccumulated AS ProvisionCesantias, 
L.ProvisionInterestsUnemployment as  ProvisionIntCesantias, 
L.ProvisionVacation as  ProvisionVacaciones, 
(SELECT TOP 1 F.MinistryCode FROM Payroll.Fund F, Payroll.FundContract FC WHERE F.Id = FC.FundId and FC.ContractId = L.ContractId and FC.FundType = 2 AND fc.[State] = 1) as CodigoAFP,
L.PensionJCB as IBCPension,
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '015') as PensionPatrono, 
(SELECT TOP 1 F.MinistryCode FROM Payroll.Fund F, Payroll.FundContract FC WHERE F.Id = FC.FundId and FC.ContractId = L.ContractId and FC.FundType = 1 AND fc.[State] = 1) as CodigoEPS,
L.HealthJCB as IBCSalud,
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '018') as SaludPatrono, 
L.IBCOccupationalRisks as IBCARL,
E.ProfessionalRiskPercentage as PorcentajeARL,
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '009') as ARL,
(SELECT F.MinistryCode FROM Payroll.Fund F, Payroll.FundContract FC WHERE F.Id = FC.FundId and FC.ContractId = L.ContractId and FC.FundType = 5 AND fc.[State] = 1) as CodigoCCF,
(SELECT F.Name FROM Payroll.Fund F, Payroll.FundContract FC WHERE F.Id = FC.FundId and FC.ContractId = L.ContractId and FC.FundType = 5 AND fc.[State] = 1) as NombreCCF,
L.IBCCompensationFund as IBCCCF,
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '036') as CCF,
L.IBCSENA AS IBCICBFSENA,
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '037') as ICBF,
(SELECT ISNULL(sum(ConceptTotalValue),0) FROM Payroll.LiquidationDetail where PayrollId = L.Id and ConceptClass = '035') as SENA,
L.TotalAccrued + (L.OccupationalRisksContributionValue + L.EmployerPensionContributionValue + L.EmployerHealthContributionValue) + L.ParafiscalContribution + L.ProvisionsValue  as TotalNomina,
L.PayrollDateLiquidated AS FechaNominaLiquidada--, L.RegisterStatus
FROM Payroll.Liquidation L, 
Payroll.Employee E, 
Common.ThirdParty TP, 
Payroll.[Contract] CONT, 
Payroll.Position POS, 
Payroll.FunctionalUnit FU, 
Payroll.ContractType CT, 
Payroll.[Group] G, 
Payroll.CostCenter CC,
Payroll.LiquidationDetail LD,
Payroll.BranchOffice BO,
Common.City C1,
Payroll.ProfessionalRisk PR,
Payroll.Bank BA
WHERE L.EmployeeId = E.Id
AND E.ThirdPartyId = TP.Id
AND CONT.EmployeeId = e.Id
AND CONT.Id = L.ContractId
AND CONT.PositionId = POS.Id
AND FU.Id = CONT.FunctionalUnitId
AND CONT.ContractTypeId = CT.Id
AND L.GroupId = G.Id
AND FU.CostCenterId = CC.Id
AND L.Id = LD.PayrollId
AND BO.Id = FU.BranchOfficeId
AND BO.CityId = C1.Id
AND PR.Id = POS.ProfessionalRiskLevelId
AND BA.Id = L.BankId
AND L.RegisterStatus = ''
--AND CONT.Valid = 1 --Se agrega validación por Caso 343149
--AND TP.Nit IN ('1053512709')
--AND L.PayrollDateLiquidated  = '2025-01-31'
--order by L.PayrollDateLiquidated desc
