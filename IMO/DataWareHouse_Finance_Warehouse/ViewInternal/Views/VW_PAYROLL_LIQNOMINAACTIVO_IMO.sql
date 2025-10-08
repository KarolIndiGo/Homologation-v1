-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_PAYROLL_LIQNOMINAACTIVO_IMO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.Payroll_LiqNominaActivo_IMO
AS

SELECT EmployeeId, PayrollDateLiquidated, W.Name
FROM [INDIGO035].[Payroll].[Liquidation] AS P 
INNER JOIN [INDIGO035].[Payroll].[WorkCenter] AS W ON W.Id=P.WorkCenterId
WHERE PayrollDateLiquidated>='2024-01-01'