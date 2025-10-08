-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_PAYROLL_LIQNOMINAACTIVO
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_PAYROLL_LIQNOMINAACTIVO] as
SELECT EmployeeId, PayrollDateLiquidated, W.Name
FROM INDIGO031.Payroll.Liquidation AS P 
INNER JOIN INDIGO031.Payroll.WorkCenter AS W ON W.Id=P.WorkCenterId
WHERE PayrollDateLiquidated>='2024-01-01'

