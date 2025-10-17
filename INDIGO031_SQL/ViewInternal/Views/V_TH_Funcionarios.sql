-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_TH_Funcionarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_TH_Funcionarios]
AS
     SELECT TP.Nit AS Identificación, 
            TP.Name AS Nombre, 
            C.Id, 
            C.JobBondingDate AS Ingreso, 
            POS.Name AS Cargo, 
            UN.Name AS Unidad, 
            C.Id AS Num_Contrato_Vigente, 
            CT.Name AS Tipo_Contrato, 
            C.BasicSalary AS Salario, 
            C.ContractInitialDate AS Fec_Ini_Contra_Vigente, 
            C.ContractEndingDate AS Fec_Fin_Contra_Vigente, 
            B.Name AS Banco, 
            C.BankAccountNumber AS Cuenta, 
     (
         SELECT TP.Name
         FROM Payroll.FundContract AS FC
              INNER JOIN Payroll.Fund AS F ON FC.FundId = F.Id
              CROSS JOIN Common.ThirdParty AS TP
         WHERE(F.ThirdPartyId = TP.Id)
              AND (FC.ContractId = C.Id)
              AND (FC.FundType = 1)
              AND (FC.State = 1)
     ) AS Salud, 
     (
         SELECT TP.Name
         FROM Payroll.FundContract AS FC
              INNER JOIN Payroll.Fund AS F ON FC.FundId = F.Id
              CROSS JOIN Common.ThirdParty AS TP
         WHERE(F.ThirdPartyId = TP.Id)
              AND (FC.ContractId = C.Id)
              AND (FC.FundType = 2)
              AND (FC.State = 1)
     ) AS Expr1, 
     (
         SELECT TP.Name
         FROM Payroll.FundContract AS FC
              INNER JOIN Payroll.Fund AS F ON FC.FundId = F.Id
              CROSS JOIN Common.ThirdParty AS TP
         WHERE(F.ThirdPartyId = TP.Id)
              AND (FC.ContractId = C.Id)
              AND (FC.FundType = 3)
              AND (FC.State = 1)
     ) AS Cesantias, 
     (
         SELECT TP.Name
         FROM Payroll.FundContract AS FC
              INNER JOIN Payroll.Fund AS F ON FC.FundId = F.Id
              CROSS JOIN Common.ThirdParty AS TP
         WHERE(F.ThirdPartyId = TP.Id)
              AND (FC.ContractId = C.Id)
              AND (FC.FundType = 4)
              AND (FC.State = 1)
     ) AS Riesgos, 
     (
         SELECT TP.Name
         FROM Payroll.FundContract AS FC
              INNER JOIN Payroll.Fund AS F ON FC.FundId = F.Id
              CROSS JOIN Common.ThirdParty AS TP
         WHERE(F.ThirdPartyId = TP.Id)
              AND (FC.ContractId = C.Id)
              AND (FC.FundType = 3)
              AND (FC.State = 1)
     ) AS Caja_Compensación,
            CASE C.STATUS
                WHEN 1
                THEN 'ACTIVO'
                WHEN 2
                THEN 'LIQUIDADO'
                WHEN 3
                THEN 'ANULADO'
                WHEN 4
                THEN 'REEMPLAZADO'
            END AS Estado, 
            C.RetirementDate AS Retiro, 
            M.Name AS Motivo_Retiro, 
            C.Notes AS Notas
     FROM Payroll.Contract AS C
          INNER JOIN Payroll.Employee AS E ON C.EmployeeId = E.Id
          INNER JOIN Common.ThirdParty AS TP ON E.ThirdPartyId = TP.Id
          INNER JOIN Payroll.Position AS POS ON C.PositionId = POS.Id
          INNER JOIN Payroll.FunctionalUnit AS UN ON C.FunctionalUnitId = UN.Id
          INNER JOIN Payroll.ContractType AS CT ON C.ContractTypeId = CT.Id
          INNER JOIN Payroll.Bank AS B ON C.BankId = B.Id
          LEFT OUTER JOIN Payroll.RetirementReason AS M ON C.RetirementReasonId = M.Id;
