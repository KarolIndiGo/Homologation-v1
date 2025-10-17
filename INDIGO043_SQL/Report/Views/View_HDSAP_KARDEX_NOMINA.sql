-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_KARDEX_NOMINA
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_KARDEX_NOMINA]
AS

SELECT *,
       CASE 
           WHEN TotalHoras IS NOT NULL AND TotalHoras > 0 
           THEN FORMAT(ValorConcepto / TotalHoras, 'C', 'es-CO') 
           ELSE NULL 
       END AS ValorPorHora
FROM (
    SELECT  TP.Nit, TP.Name AS Empleado, 
           L.PayrollDateLiquidated AS Fecha, 
           C.Code AS CodigoConcepto, C.Name AS NombreConcepto, 
           CASE WHEN C.ConceptType = 1 THEN 'DEVENGADO' ELSE 'DEDUCIDO' END AS TipoConcepto, 
           SUM(LD.ConceptTotalValue) AS ValorConcepto,
           LD.TotalNumberHours AS TotalHoras
    FROM Payroll.LiquidationDetail LD
    JOIN Payroll.Liquidation L ON LD.PayrollId = L.Id
    JOIN Payroll.Concept C ON C.Id = LD.ConceptId
    JOIN Payroll.Employee E ON L.EmployeeId = E.Id
    JOIN Common.ThirdParty TP ON E.ThirdPartyId = TP.Id
    WHERE L.RegisterStatus <> '' AND C.ConceptType <> 3
    GROUP BY LD.Id, E.Id, TP.Nit, TP.Name, L.PayrollDateLiquidated, C.Code, C.Name, C.ConceptType,LD.TotalNumberHours
    
    UNION ALL
    
    SELECT TP.Nit, TP.Name AS Empleado, 
           RC.NextPayrollDate AS Fecha,
           C.Code, C.Name, 
           CASE WHEN C.ConceptType = 1 THEN 'DEVENGADO' ELSE 'DEDUCIDO' END AS TipoConcepto, 
           RD.ValueConceptWithRetroactive AS ValorConcepto,
           NULL AS TotalHoras
    FROM Payroll.RetroactiveC RC
    JOIN Payroll.RetroactiveD RD ON RD.IdRetroactiveC = RC.Id
    JOIN Payroll.Concept C ON C.Id = RD.IdConcept
    JOIN Payroll.Employee E ON RC.IdEmployee = E.Id
    JOIN Common.ThirdParty TP ON E.ThirdPartyId = TP.Id
    WHERE C.ConceptType <> 3
    
    UNION ALL
    
    SELECT  TP.Nit, TP.Name AS Empleado, 
           IP.PeriodEndDate AS Fecha,
           (SELECT C.Code FROM Payroll.PayrollSettings PS 
            JOIN Payroll.Concept C ON C.Id = PS.ServicesIncentivePaymentConceptId) AS CodigoConcepto,
           (SELECT C.Name FROM Payroll.PayrollSettings PS 
            JOIN Payroll.Concept C ON C.Id = PS.ServicesIncentivePaymentConceptId) AS NombreConcepto,
           (SELECT CASE WHEN C.ConceptType = 1 THEN 'DEVENGADO' ELSE 'DEDUCIDO' END 
            FROM Payroll.PayrollSettings PS 
            JOIN Payroll.Concept C ON C.Id = PS.ServicesIncentivePaymentConceptId) AS TipoConcepto,
           IP.TotalAccrued AS ValorConcepto,
           NULL AS TotalHoras
    FROM Payroll.IncentivePayment IP
    JOIN Payroll.Contract C ON IP.ContractId = C.Id
    JOIN Payroll.Employee E ON C.EmployeeId = E.Id
    JOIN Common.ThirdParty TP ON E.ThirdPartyId = TP.Id
    WHERE IP.[Period] = 1
    
    UNION ALL
    
    SELECT  TP.Nit, TP.Name AS Empleado, 
           IP.PeriodEndDate AS Fecha,
           (SELECT C.Code FROM Payroll.PayrollSettings PS 
            JOIN Payroll.Concept C ON C.Id = PS.ChristmasIncentivePaymentConceptId) AS CodigoConcepto,
           (SELECT C.Name FROM Payroll.PayrollSettings PS 
            JOIN Payroll.Concept C ON C.Id = PS.ChristmasIncentivePaymentConceptId) AS NombreConcepto,
           (SELECT CASE WHEN C.ConceptType = 1 THEN 'DEVENGADO' ELSE 'DEDUCIDO' END 
            FROM Payroll.PayrollSettings PS 
            JOIN Payroll.Concept C ON C.Id = PS.ChristmasIncentivePaymentConceptId) AS TipoConcepto,
           IP.TotalAccrued AS ValorConcepto,
           NULL AS TotalHoras
    FROM Payroll.IncentivePayment IP
    JOIN Payroll.Contract C ON IP.ContractId = C.Id
    JOIN Payroll.Employee E ON C.EmployeeId = E.Id
    JOIN Common.ThirdParty TP ON E.ThirdPartyId = TP.Id
    WHERE IP.[Period] = 2
) AS Resultado

