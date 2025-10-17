-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Payroll_LiqNominaActivo
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW VIEWINTERNAL.Payroll_LiqNominaActivo as
SELECT EmployeeId, PayrollDateLiquidated, W.Name
FROM INDIGO031.Payroll.Liquidation AS P 
INNER JOIN INDIGO031.Payroll.WorkCenter AS W ON W.Id=P.WorkCenterId
WHERE PayrollDateLiquidated>='2024-01-01'

