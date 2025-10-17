-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Payroll_LiquidacionNomina
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [ViewInternal].[VIE_AD_Payroll_LiquidacionNomina] AS
SELECT DISTINCT 
                         CAST(TP.Nit AS numeric) AS Identificacion, TP.Name AS NombreEmpleado, G.Code AS CodigoGrupo, G.Name AS NombreGrupo, POS.Name AS Cargo, C1.Name AS Ciudad, BO.Name AS Sede, FU.Name AS UnidadFuncional, 
                         CC.Name AS CentroCosto, PR.Name AS RiesgosProfesionales, CASE WHEN CT.SalaryType = 1 THEN 'FIJO' WHEN CT.SalaryType = 2 THEN 'INTEGRAL' ELSE 'VARIABLE' END AS TipoSalario, 'S' AS Exoneracion, 
                         '1' AS TipoCotizante, BA.Name AS Banco, L.BankAccountNumber AS CuentaBancaria, 'NOMINA' AS Tipo, CAST(CONT.BasicSalary AS money) AS SueldoActual, POS.MaxHourAmount AS Horas, 
                         CONT.JobBondingDate AS Nov_Ingreso, E.VacationLastDateLiquidation AS UltimasVacaciones, ISNULL
                             ((SELECT        ISNULL(SUM(PendingDays), 0) AS Expr1
                                 FROM            Payroll.VacationPeriod
                                 WHERE        (EmployeeId = L.EmployeeId)
                                 GROUP BY EmployeeId), 0) AS DiasPendientesDisfrutar, L.VacationInitialDate AS VacacionesDesde, L.VacationEndDate AS VacacionesHasta, L.VacationValueEnjoy AS ValorVacaciones, L.DaysWorked AS DiasLaborados, 
                         CASE WHEN YEAR(CONT.JobBondingDate) = YEAR('01/31/2025') AND MONTH(CONT.JobBondingDate) = MONTH('12/31/2018') THEN 'X' ELSE '' END AS ING, CASE WHEN YEAR(CONT.RetirementDate) = YEAR('01/31/2025') AND 
                         MONTH(CONT.RetirementDate) = MONTH('01/31/2025') THEN 'X' ELSE '' END AS RET, '' AS TDE, '' AS TAE, '' AS TDP, '' AS TAP, '' AS VSP, '' AS VTE, '' AS VST, CASE WHEN L.SanctionDays > 0 THEN 'X' ELSE '' END AS SAN, 
                         CASE WHEN L.UnpaidLicenseDays > 0 THEN 'X' ELSE '' END AS LIC, CASE WHEN L.AmbulatoryDisabilityDays > 0 THEN 'X' ELSE '' END AS INCAMB, 
                         CASE WHEN L.DisabilityHospitalDays > 0 THEN 'X' ELSE '' END AS INCHOSP, CASE WHEN L.MaternityLeaveDays > 0 THEN 'X' ELSE '' END AS LMA, CASE WHEN L.MaternityLeaveDays > 0 THEN 'X' ELSE '' END AS LMA1, 
                         CASE WHEN L.VacationInitialDate <> '0001-01-01' THEN 'X' ELSE '' END AS VAC, CASE WHEN L.VoluntaryContributionPensionValue > 0 THEN 'X' ELSE '' END AS AVP, '' AS VCT, 
                         CASE WHEN L.OccupationalRisksDisabilityInitialDate <> '0001-01-01' THEN 'X' ELSE '' END AS IRP, CONT.BasicSalary AS SueldoBasico,
                             (SELECT        SUM(AccruedValue) AS Expr1
                               FROM            Payroll.LiquidationDetail
                               WHERE        (PayrollId = L.Id) AND (ConceptCode = '001')) AS SueldoPagado,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_31
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('042'))) AS RNN,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_30
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('043'))) AS RNDF,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_29
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('051'))) AS RDF,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_28
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('052'))) AS RDD,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_27
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('042', '043', '051', '052'))) AS ValorRecargos,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_26
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('001'))) AS HEOD,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_25
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('012'))) AS HEON,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_24
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('013'))) AS HEDD,
                             (SELECT        ISNULL(SUM(TotalNumberHours), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_23
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('050'))) AS HEDN,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_22
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('001', '012', '013', '050'))) AS ValorHE,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_21
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('010')) AND (ConceptCode <> '037')) AS OtrosDevengados,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_20
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('022', '027', '021'))) AS Incapacidades,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_19
                               WHERE        (PayrollId = L.Id) AND (ConceptClass IN ('023'))) AS Maternidad,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_18
                               WHERE        (PayrollId = L.Id) AND (ConceptCode = '037')) AS BonificacionSalarial,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_17
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '004')) AS BonificacionNoSalarial, 0 AS InteresesCesantias,
                             (SELECT        ISNULL(SUM(AccruedValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_16
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '006')) AS AuxilioTransporte, L.TotalAccrued AS TotalDevengado,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_15
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '020')) AS RetencionFuente,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_14
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '038')) AS FSP,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_13
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '017')) AS Salud,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_12
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '014')) AS Pension,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_11
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '041') AND (ConceptCode <> '506') AND (ConceptCode <> '402')) AS Libranzas,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_10
                               WHERE        (PayrollId = L.Id) AND (ConceptCode = '106')) AS AFC,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_9
                               WHERE        (PayrollId = L.Id) AND (ConceptCode IN ('101', '506', '402'))) AS MedicinaPrepagada,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_8
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '011') AND (ConceptCode NOT IN ('104', '108'))) AS OtrosDescuentos,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_7
                               WHERE        (PayrollId = L.Id) AND (ConceptCode = '108')) AS EmbargosJudiciales, L.TotalDeducted AS TotalDeducibles, L.TotalPaid AS NetoPagar, L.ProvisionIncentive AS ProvisionPrimas, 
                         L.UnemploymentAccumulated AS ProvisionCesantias, L.ProvisionInterestsUnemployment AS ProvisionIntCesantias, L.ProvisionVacation AS ProvisionVacaciones,
                             (SELECT        TOP (1) F.MinistryCode
                               FROM            Payroll.Fund AS F INNER JOIN
                                                         Payroll.FundContract AS FC ON F.Id = FC.FundId
                               WHERE        (FC.ContractId = L.ContractId) AND (FC.FundType = 2) AND (FC.State = 1)) AS CodigoAFP, L.PensionJCB AS IBCPension,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_6
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '015')) AS PensionPatrono,
                             (SELECT        TOP (1) F.MinistryCode
                               FROM            Payroll.Fund AS F INNER JOIN
                                                         Payroll.FundContract AS FC ON F.Id = FC.FundId
                               WHERE        (FC.ContractId = L.ContractId) AND (FC.FundType = 1) AND (FC.State = 1)) AS CodigoEPS, L.HealthJCB AS IBCSalud,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_5
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '018')) AS SaludPatrono, L.IBCOccupationalRisks AS IBCARL, E.ProfessionalRiskPercentage AS PorcentajeARL,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_4
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '009')) AS ARL, L.IBCCompensationFund AS IBCCCF,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_3
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '036')) AS CCF, L.IBCSENA AS IBCICBFSENA,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_2
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '037')) AS ICBF,
                             (SELECT        ISNULL(SUM(ConceptTotalValue), 0) AS Expr1
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_1
                               WHERE        (PayrollId = L.Id) AND (ConceptClass = '035')) AS SENA, L.TotalAccrued + (L.OccupationalRisksContributionValue + L.EmployerPensionContributionValue + L.EmployerHealthContributionValue) 
                         + L.ParafiscalContribution + L.ProvisionsValue AS TotalNomina, L.PayrollDateLiquidated as FechaAcumulado
FROM            Payroll.Liquidation AS L INNER JOIN
                         Payroll.Employee AS E ON L.EmployeeId = E.Id INNER JOIN
                         Common.ThirdParty AS TP ON E.ThirdPartyId = TP.Id INNER JOIN
                         Payroll.Contract AS CONT ON E.Id = CONT.EmployeeId AND L.ContractId = CONT.Id INNER JOIN
                         Payroll.Position AS POS ON CONT.PositionId = POS.Id INNER JOIN
                         Payroll.FunctionalUnit AS FU ON CONT.FunctionalUnitId = FU.Id INNER JOIN
                         Payroll.ContractType AS CT ON CONT.ContractTypeId = CT.Id INNER JOIN
                         Payroll.[Group] AS G ON L.GroupId = G.Id INNER JOIN
                         Payroll.CostCenter AS CC ON FU.CostCenterId = CC.Id INNER JOIN
                         Payroll.LiquidationDetail AS LD ON L.Id = LD.PayrollId INNER JOIN
                         Payroll.BranchOffice AS BO ON FU.BranchOfficeId = BO.Id INNER JOIN
                         Common.City AS C1 ON BO.CityId = C1.Id INNER JOIN
                         Payroll.ProfessionalRisk AS PR ON POS.ProfessionalRiskLevelId = PR.Id INNER JOIN
                         Payroll.Bank AS BA ON L.BankId = BA.Id
WHERE        (L.PayrollDateLiquidated = '2025/09/30') 
