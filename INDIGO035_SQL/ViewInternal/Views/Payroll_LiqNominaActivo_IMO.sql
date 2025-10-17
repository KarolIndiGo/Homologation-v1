-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Payroll_LiqNominaActivo_IMO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW VIEWINTERNAL.Payroll_LiqNominaActivo_IMO as
SELECT EmployeeId, PayrollDateLiquidated, W.Name
FROM Payroll.Liquidation AS P 
INNER JOIN INDIGO035.Payroll.WorkCenter AS W ON W.Id=P.WorkCenterId
WHERE PayrollDateLiquidated>='2024-01-01'