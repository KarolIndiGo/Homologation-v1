-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Ledger_BalanceGeneral2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0





create view [ViewInternal].[VIE_AD_Ledger_BalanceGeneral2024]
AS
--SELECT  c.Number AS Auxiliar, cco.Code AS CentroCosto, c.Name AS [Nombre auxiliar], cl.Code AS CodClase, cl.Name AS Clase, LEFT(c.Number, 2) AS Grupo,
--               (SELECT  Name
--              FROM     GeneralLedger.MainAccounts
--              WHERE   (Number = LEFT(c.Number, 2)) AND (LegalBookId = '1')) AS [Nombre Grupo], LEFT(c.Number, 4) AS Cuenta,
--               (SELECT  Name
--              FROM     GeneralLedger.MainAccounts AS MainAccounts_1
--              WHERE   (Number = LEFT(c.Number, 4)) AND (LegalBookId = '1')) AS [Nombre Cuenta], LEFT(c.Number, 6) AS SubCuenta,
--               (SELECT  Name
--              FROM     GeneralLedger.MainAccounts AS MainAccounts_1
--              WHERE   (Number = LEFT(c.Number, 6)) AND (LegalBookId = '1')) AS [Nombre SubCuenta], t .Nit, t .Name AS [Nombre tercero], CASE WHEN sc.Month = '14' AND sc.Year = '2023' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, 
--           CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS [SaldosIniciales], CASE WHEN sc.Month = '1' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) 
--           - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Enero2024, CASE WHEN sc.Month = '2' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) 
--           AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Febrero2024, CASE WHEN sc.Month = '3' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, 
--           CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Marzo2024, CASE WHEN sc.Month = '4' AND 
--           sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Abril2024, 
--           CASE WHEN sc.Month = '5' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) 
--           * IIF(cl.Nature = 2, - 1, 1) END AS Mayo2024, CASE WHEN sc.Month = '6' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) 
--           - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Junio2024, CASE WHEN sc.Month = '7' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) 
--           AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Julio2024, CASE WHEN sc.Month = '8' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, 
--           CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Agosto2024, CASE WHEN sc.Month = '9' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
--           AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Septiembre2024, CASE WHEN sc.Month = '10' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
--           CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Octubre2024, CASE WHEN sc.Month = '11' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
--           - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Noviembre2024, CASE WHEN sc.Month = '12' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, 
--           IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Diciembre2024
--FROM    GeneralLedger.GeneralLedgerBalance AS sc  LEFT OUTER JOIN
--           Common.ThirdParty AS t ON t .Id = sc.IdThirdParty LEFT OUTER JOIN
--           GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount INNER JOIN
--           GeneralLedger.MainAccountClasses AS cl ON cl.Id = c.IdAccountClass LEFT OUTER JOIN
--           Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
--WHERE  (c.Number BETWEEN '11050501' AND '38105601') AND (c.LegalBookId = '1')
--GROUP BY c.Number, t .Nit, t .Name, cco.Code, sc.Month, c.Name, cl.Code, cl.Name, sc.Year, c.Nature, cl.Nature
--GO



SELECT c.Number AS Auxiliar, cco.Code AS CentroCosto, c.Name AS [Nombre auxiliar], cl.Code AS CodClase, cl.Name AS Clase, LEFT(c.Number, 2) AS Grupo,
               (SELECT Name
              FROM   GeneralLedger.MainAccounts
              WHERE (Number = LEFT(c.Number, 2)) AND (LegalBookId = '1')) AS [Nombre Grupo], LEFT(c.Number, 4) AS Cuenta,
               (SELECT Name
              FROM   GeneralLedger.MainAccounts AS MainAccounts_1
              WHERE (Number = LEFT(c.Number, 4)) AND (LegalBookId = '1')) AS [Nombre Cuenta], LEFT(c.Number, 6) AS SubCuenta,
               (SELECT Name
              FROM   GeneralLedger.MainAccounts AS MainAccounts_1
              WHERE (Number = LEFT(c.Number, 6)) AND (LegalBookId = '1')) AS [Nombre SubCuenta], t .Nit, t .Name AS [Nombre tercero], 
			  CASE WHEN sc.Month = '14' AND sc.Year = '2023' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) 
           - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS [SaldosIniciales], 
		   CASE WHEN sc.Month = '1' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, 
           CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Enero2024, 
           CASE WHEN sc.Month = '2' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
           CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Febrero2024, CASE WHEN sc.Month = '3' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) 
           * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Marzo2024, CASE WHEN sc.Month = '4' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
           - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Abril2024, CASE WHEN sc.Month = '5' AND 
           sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
           AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Mayo2024, CASE WHEN sc.Month = '6' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
           - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Junio2024, CASE WHEN sc.Month = '7' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) 
           - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Julio2024, CASE WHEN sc.Month = '8' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, 
           CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Agosto2024, 
           CASE WHEN sc.Month = '9' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), 
           CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Septiembre2024, CASE WHEN sc.Month = '10' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
           AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Octubre2024, CASE WHEN sc.Month = '11' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) 
           - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Noviembre2024, 
		   CASE WHEN sc.Month = '12' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) 
           AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Diciembre2024

FROM   GeneralLedger.GeneralLedgerBalance AS sc WITH (nolock) LEFT OUTER JOIN
           Common.ThirdParty AS t ON t .Id = sc.IdThirdParty LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount AND c.legalbookid = '1' and c.number not in ('140305','1301260601') and (c.Number BETWEEN '1101010601' AND '3899999999') INNER JOIN
           GeneralLedger.MainAccountClasses AS cl ON cl.Id = c.IdAccountClass LEFT OUTER JOIN
          Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
WHERE (c.Number BETWEEN '1101010601' AND '3899999999') AND (c.LegalBookId = '1') 
AND (sc.year = '2024' AND sc.month BETWEEN '1' AND '12') OR
           (sc.Year = '2023' AND month = '14') OR
     (sc.year = '2024' AND sc.month BETWEEN '1' AND '12')
GROUP BY c.Number, t .Nit, t .Name, cco.Code, sc.Month, c.Name, cl.Code, cl.Name, sc.Year, c.Nature, cl.Nature
