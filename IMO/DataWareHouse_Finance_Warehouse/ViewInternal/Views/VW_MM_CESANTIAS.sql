-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_MM_CESANTIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW [ViewInternal].[VW_MM_CESANTIAS]
AS

SELECT 
DISTINCT CAST(TP.Nit AS numeric) as Identificacion,
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
 FROM [INDIGO035].[Payroll].[Fund] FO 
 INNER JOIN [INDIGO035].[Payroll].[FundContract] FC 
   ON FO.Id = FC.FundId 
  AND FC.ContractId = L.ContractId 
  AND FC.FundType = 3) as Fondo,
CONT.BankAccountNumber as CuentaBancaria,
CONT.JobBondingDate as Nov_Ingreso,
CAST(CONT.BasicSalary AS DECIMAL(19,4)) as SueldoActual,
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
L.UnemployedLiquidationDate AS Fecha_Liquidacion_Cesantias--,
--L.UnemployedInterestPayDate
FROM [INDIGO035].[Payroll].[UnemployedLiquidation] L 
LEFT JOIN [INDIGO035].[Payroll].[Employee] E  ON L.EmployeeId = E.Id
LEFT JOIN [INDIGO035].[Common].[ThirdParty] TP ON TP.Id = E.ThirdPartyId
LEFT JOIN [INDIGO035].[Payroll].[Contract] CONT ON CONT.Id = L.ContractId
LEFT JOIN [INDIGO035].[Payroll].[Position] POS ON POS.Id = CONT.PositionId
LEFT JOIN [INDIGO035].[Payroll].[FunctionalUnit] FU ON FU.Id = CONT.FunctionalUnitId
LEFT JOIN [INDIGO035].[Payroll].[ContractType] CT ON CT.Id = CONT.ContractTypeId
LEFT JOIN [INDIGO035].[Payroll].[Group] G ON G.Id = CONT.GroupId
LEFT JOIN [INDIGO035].[Payroll].[CostCenter] CC ON CC.Id = FU.CostCenterId
LEFT JOIN [INDIGO035].[Payroll].[UnemployedLiquidationDetail] LD ON LD.UnemployedLiquidationId = L.Id
LEFT JOIN [INDIGO035].[Payroll].[BranchOffice] BO ON BO.Id = FU.BranchOfficeId
LEFT JOIN [INDIGO035].[Common].[City] C1 ON C1.Id = BO.CityId
LEFT JOIN [INDIGO035].[Payroll].[Bank] BA ON BA.Id = CONT.BankId
LEFT JOIN [INDIGO035].[Payroll].[PayrollParameter] PA ON PA.Id = G.PayrollParameterId
--WHERE Year(L.UnemployedLiquidationDate)='2020'
WHERE L.Year='2024' 
--AND L.UnemployedLiquidationDate= (
--														SELECT MAX(L.UnemployedLiquidationDate)
--															FROM [INDIGO035].[Payroll].[UnemployedLiquidation] L)
--where YEAR(L.UnemployedInterestPayDate) BETWEEN '2020' AND '2020'
--AND  TP.Nit='1075245961'
--ORDER BY Identificacion