-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Payroll_LiqNominaActivo
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Payroll_LiqNominaActivo] as
SELECT EmployeeId, PayrollDateLiquidated, W.Name
FROM Payroll.Liquidation AS P 
INNER JOIN INDIGO022.Payroll.WorkCenter AS W ON W.Id=P.WorkCenterId
WHERE PayrollDateLiquidated>='2024-01-01'

