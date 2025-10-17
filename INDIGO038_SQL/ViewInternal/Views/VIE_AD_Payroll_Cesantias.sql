-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Payroll_Cesantias
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Payroll_Cesantias]
AS
     SELECT E.Id, 
            TP.Nit AS Documento, 
            TP.Name AS Empleado, 
            C.BasicSalary AS [Salario Basico], 
            g.Code AS Cod_Grupo, 
            g.Name AS Grupo, 
            WorkedTotalDays AS [Dias Trabajados], 
            SanctionTotalDays AS [Dias Sancion], 
            cesantia.name AS [Fondo Cesantias], 
            UL.UnemployedInterestTotal [Total Intereses Cesantias], 
            UL.TotalUnemployed AS [Total Cesantias], 
            TotalDeducted AS TotalDeducido, 
            b.name AS Banco, 
            BankAccountNumber AS [Cuenta Bancaria], 
            c.contractinitialdate AS [Fecha Inicial Contrato]
     FROM PAyroll.UnemployedLiquidation UL, 
          Payroll.[Group] G, 
          Payroll.Employee E, 
          Common.ThirdParty tp, 
          Payroll.Contract C, 
          Payroll.FundContract AS fc1, 
          Payroll.Fund AS Cesantia, 
          Payroll.Bank AS b
     WHERE [Year] = 2019
           AND G.Id = UL.GroupId
           AND e.Id = ul.EmployeeId
           AND tp.Id = e.ThirdPartyId
           AND C.Id = UL.ContractId
           AND fc1.ContractId = c.Id
           AND fc1.FundType = '3'
           AND fc1.State = '1'
           AND Cesantia.Id = fc1.FundId
           AND b.id = c.bankid;
--ORDER BY G.Code, TP.Nit
