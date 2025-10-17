-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: PBIP_View_FIN_INGRESOS_VENTAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[PBIP_View_FIN_INGRESOS_VENTAS] AS
SELECT 
 'Juridicas' Tipo,
 (sc.Year*10000) + (sc.Month*100) + 1 ID_TIEMPO,
 t.Nit,
 t.Name AS Cliente, 
 cco.Code AS CentroCosto,
 cco.Name as [Descripcion Centro Costo],
 (SUM(sc.DebitValue) - SUM(sc.CreditValue)) * - 1 ACUMULADO
FROM 
 GeneralLedger.GeneralLedgerBalance AS sc 
 INNER JOIN Common.ThirdParty AS t ON t .Id = sc.IdThirdParty 
 LEFT OUTER JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter 
 LEFT OUTER JOIN GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount 
WHERE 
 (t .PersonType = '2') AND	
 (c.LegalBookId = '1') AND 
 (c.Number BETWEEN '41' AND '41999999') --AND 
 --sc.Year =YEAR(GETDATE()) AND (sc.Year > 2022) 
GROUP BY 
 t.Nit, 
 t.Name, 
 cco.Code, 
 cco.name, 
 (sc.Year*10000) + (sc.Month*100) + 1

UNION ALL

SELECT 
 'Naturales' Tipo,
 (sc.Year*10000) + (sc.Month*100) + 1 ID_TIEMPO,
 '000.000.000' nit,
 'Personas Naturales' AS Cliente, 
 cco.Code AS CentroCosto,
 cco.Name as [Descripcion Centro Costo],
 (SUM(sc.DebitValue) - SUM(sc.CreditValue)) * - 1 ACUMULADO
FROM 
 GeneralLedger.GeneralLedgerBalance AS sc 
 INNER JOIN Common.ThirdParty AS t ON t .Id = sc.IdThirdParty 
 LEFT OUTER JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter 
 LEFT OUTER JOIN GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount 
WHERE 
 (t .PersonType = '1') AND	
 (c.LegalBookId = '1') AND 
 (c.Number BETWEEN '41' AND '41999999')
GROUP BY 
 cco.Code, 
 cco.name, 
 (sc.Year*10000) + (sc.Month*100) + 1

