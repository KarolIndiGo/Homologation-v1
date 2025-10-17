-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Ledger_EstadoResultados_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Ledger_EstadoResultados_2025] AS

     SELECT RTRIM(c.Number) + RTRIM(cco.Code) AS CuentaCentroCosto, 
            c.Number AS Auxiliar, 
            cco.Code AS CCosto, 
            cco.Name AS [Centro Costo], 
            c.Name AS [Nombre auxiliar], 
            cl.Code AS CodClase, 
            cl.Name AS Clase, 
            LEFT(c.Number, 2) AS Grupo, 
     (
         SELECT Name
         FROM GeneralLedger.MainAccounts
         WHERE(Number = LEFT(c.Number, 2))
              AND (LegalBookId = '2')
     ) AS [Nombre Grupo], 
            LEFT(c.Number, 4) AS Cuenta, 
     (
         SELECT Name
         FROM GeneralLedger.MainAccounts AS MainAccounts_1
         WHERE(Number = LEFT(c.Number, 4))
              AND (LegalBookId = '2')
     ) AS [Nombre Cuenta], 
            LEFT(c.Number, 6) AS SubCuenta, 
     (
         SELECT Name
         FROM GeneralLedger.MainAccounts AS MainAccounts_1
         WHERE(Number = LEFT(c.Number, 6))
              AND (LegalBookId = '2')
     ) AS [Nombre SubCuenta], 
            t.Nit, 
            t.Name AS [Nombre tercero],
            CASE
                WHEN sc.Month = '1'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Enero2025,
            CASE
                WHEN sc.Month = '2'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Febrero2025,
            CASE
                WHEN sc.Month = '3'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Marzo2025,
            CASE
                WHEN sc.Month = '4'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Abril2025,
            CASE
                WHEN sc.Month = '5'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Mayo2025,
            CASE
                WHEN sc.Month = '6'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Junio2025,
            CASE
                WHEN sc.Month = '7'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Julio2025,
            CASE
                WHEN sc.Month = '8'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Agosto2025,
            CASE
                WHEN sc.Month = '9'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Septiembre2025,
            CASE
                WHEN sc.Month = '10'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Octubre2025,
            CASE
                WHEN sc.Month = '11'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Noviembre2025,
            CASE
                WHEN sc.Month = '12'
                     AND sc.Year = '2025'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY)
            END AS Diciembre2025
     FROM GeneralLedger.GeneralLedgerBalance AS sc 
          LEFT OUTER JOIN Common.ThirdParty AS t  ON t.Id = sc.IdThirdParty
          LEFT OUTER JOIN GeneralLedger.MainAccounts AS c  ON c.Id = sc.IdMainAccount
          INNER JOIN GeneralLedger.MainAccountClasses AS cl  ON cl.Id = c.IdAccountClass
          LEFT OUTER JOIN Payroll.CostCenter AS cco  ON cco.Id = sc.IdCostCenter
     WHERE(c.Number BETWEEN '4101010601' AND '999999999999')
          AND (c.LegalBookId = '2')
          AND (sc.Year = '2025')
     GROUP BY c.Number, 
              t.Nit, 
              t.Name, 
              cco.Code, 
              sc.Month, 
              c.Name, 
              cl.Code, 
              cl.Name, 
              sc.Year, 
              cco.Name;

