-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_CESANTIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_CESANTIAS 
AS
SELECT DISTINCT 
    CAST(TP.Nit AS numeric) as Identificacion,
    TP.Name as NombreEmpleado,
    G.Code as CodigoGrupo,
    G.Name as NombreGrupo,
    POS.Name as Cargo, 
    C1.Name as Ciudad,
    BO.Name as Sede,
    FU.Name as UnidadFuncional,
    CC.Name as CentroCosto,
    BA.Name as Banco,
    (SELECT MAX(FO.Name) 
        FROM INDIGO031.Payroll.Fund FO 
        INNER JOIN INDIGO031.Payroll.FundContract FC 
            ON FO.Id = FC.FundId 
            AND FC.ContractId = CONT.Id 
            AND FC.FundType = 3
    ) as Fondo,
    CONT.BankAccountNumber as CuentaBancaria,
    CONT.JobBondingDate as Fecha_Ingreso,
    CAST(CONT.BasicSalary AS money) as SueldoActual,
    L.UnemployedInitialDate AS Fecha_Inicio,
    concat('31-12-', year(L.UnemployedInitialDate)) as Fecha_Fin,
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
FROM INDIGO031.Payroll.UnemployedLiquidation L 
LEFT JOIN INDIGO031.Payroll.Employee E  ON L.EmployeeId = E.Id
LEFT JOIN INDIGO031.Common.ThirdParty TP ON TP.Id = E.ThirdPartyId
LEFT JOIN [INDIGO031].[Payroll].[Contract] CONT ON CONT.Id = L.ContractId
LEFT JOIN [INDIGO031].[Payroll].[Position] POS ON POS.Id = CONT.PositionId
LEFT JOIN INDIGO031.Payroll.FunctionalUnit FU ON FU.Id = CONT.FunctionalUnitId
LEFT JOIN INDIGO031.Payroll.ContractType CT ON CT.Id = CONT.ContractTypeId
LEFT JOIN [INDIGO031].[Payroll].[Group] G ON G.Id = CONT.GroupId 
LEFT JOIN INDIGO031.Payroll.CostCenter CC ON CC.Id = FU.CostCenterId
LEFT JOIN [INDIGO031].[Payroll].[UnemployedLiquidationDetail] LD ON LD.UnemployedLiquidationId = L.Id
LEFT JOIN INDIGO031.Payroll.BranchOffice BO ON BO.Id = FU.BranchOfficeId
LEFT JOIN INDIGO031.Common.City C1 ON C1.Id = BO.CityId
LEFT JOIN INDIGO031.Payroll.Bank BA ON BA.Id = CONT.BankId
LEFT JOIN INDIGO031.Payroll.PayrollParameter PA ON PA.Id = G.PayrollParameterId
WHERE L.Year = '2024' 
  AND (CONT.Status = 1 OR CONT.Status = 4)
