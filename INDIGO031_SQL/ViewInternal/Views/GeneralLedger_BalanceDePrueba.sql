-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: GeneralLedger_BalanceDePrueba
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[GeneralLedger_BalanceDePrueba] AS
SELECT c.Number AS Auxiliar, cco.Code AS CentroCosto, c.Name AS [Nombre auxiliar], cl.Code AS CodClase, cl.Name AS Clase, LEFT(c.Number, 2) AS Grupo,
                      (SELECT Name
                       FROM      GeneralLedger.MainAccounts
                       WHERE   (Number = LEFT(c.Number, 2)) AND (LegalBookId = '1')) AS [Nombre Grupo], LEFT(c.Number, 4) AS Cuenta,
                      (SELECT Name
                       FROM      GeneralLedger.MainAccounts AS MainAccounts_1
                       WHERE   (Number = LEFT(c.Number, 4)) AND (LegalBookId = '1')) AS [Nombre Cuenta], LEFT(c.Number, 6) AS SubCuenta,
                      (SELECT Name
                       FROM      GeneralLedger.MainAccounts AS MainAccounts_1
                       WHERE   (Number = LEFT(c.Number, 6)) AND (LegalBookId = '1')) AS [Nombre SubCuenta], t .Nit, t .Name AS [Nombre tercero], 
					   --CASE WHEN sc.Month = '13' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, 
        --          CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
        --          CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS [SaldosIniciales], 
				  CASE WHEN sc.Month = '1' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
                  - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
                  AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Enero2025, CASE WHEN sc.Month = '2' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
                  CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) 
                  END AS Febrero2025, CASE WHEN sc.Month = '3' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
                  AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Marzo2025, CASE WHEN sc.Month = '4' AND 
                  sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
                  - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Abril2025, CASE WHEN sc.Month = '5' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, 
                  CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
                  CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Mayo2025, CASE WHEN sc.Month = '6' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
                  - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
                  AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Junio2025, CASE WHEN sc.Month = '7' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
                  CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) 
                  END AS Julio2025, CASE WHEN sc.Month = '8' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
                  AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Agosto2025, CASE WHEN sc.Month = '9' AND 
                  sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
                  - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Septiembre2025, CASE WHEN sc.Month = '10' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, 
                  IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
                  CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Octubre2025, CASE WHEN sc.Month = '11' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
                  - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
                  AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Noviembre2025, CASE WHEN sc.Month = '12' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
                  CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) 
                  END AS Diciembre2025
FROM     GeneralLedger.GeneralLedgerBalance AS sc WITH (nolock) LEFT OUTER JOIN
         Common.ThirdParty AS t ON t .Id = sc.IdThirdParty LEFT OUTER JOIN
         GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount INNER JOIN
         GeneralLedger.MainAccountClasses AS cl ON cl.Id = c.IdAccountClass LEFT OUTER JOIN
         Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
WHERE  (c.Number BETWEEN '1' AND '94250224') AND (c.LegalBookId = '1')
GROUP BY c.Number, t .Nit, t .Name, cco.Code, sc.Month, c.Name, cl.Code, cl.Name, sc.Year, c.Nature, cl.Nature


--SELECT DISTINCT MONTH, YEAR FROM     GeneralLedger.GeneralLedgerBalance