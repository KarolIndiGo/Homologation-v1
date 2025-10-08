-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_LEDGER_ESTADORESULTADOS_UCI_ABNER
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_LEDGER_ESTADORESULTADOS_UCI_ABNER
AS
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
         FROM INDIGO031.GeneralLedger.MainAccounts
         WHERE(Number = LEFT(c.Number, 2))
              AND (LegalBookId = '2')
     ) AS [Nombre Grupo], 
            LEFT(c.Number, 4) AS Cuenta, 
     (
         SELECT Name
         FROM INDIGO031.GeneralLedger.MainAccounts AS MainAccounts_1
         WHERE(Number = LEFT(c.Number, 4))
              AND (LegalBookId = '2')
     ) AS [Nombre Cuenta], 
            LEFT(c.Number, 6) AS SubCuenta, 
     (
         SELECT Name
         FROM INDIGO031.GeneralLedger.MainAccounts AS MainAccounts_1
         WHERE(Number = LEFT(c.Number, 6))
              AND (LegalBookId = '2')
     ) AS [Nombre SubCuenta], 
            t.Nit, 
            t.Name AS [Nombre tercero],
            CASE
                WHEN sc.Month = '1'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Enero2021,
            CASE
                WHEN sc.Month = '2'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Febrero2021,
            CASE
                WHEN sc.Month = '3'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Marzo2021,
            CASE
                WHEN sc.Month = '4'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Abril2021,
            CASE
                WHEN sc.Month = '5'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Mayo2021,
            CASE
                WHEN sc.Month = '6'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Junio2021,
            CASE
                WHEN sc.Month = '7'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Julio2021,
            CASE
                WHEN sc.Month = '8'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Agosto2021,
            CASE
                WHEN sc.Month = '9'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Septiembre2021,
            CASE
                WHEN sc.Month = '10'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Octubre2021,
            CASE
                WHEN sc.Month = '11'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Noviembre2021,
            CASE
                WHEN sc.Month = '12'
                     AND sc.Year = '2021'
                THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4))
            END AS Diciembre2021
     FROM INDIGO031.GeneralLedger.GeneralLedgerBalance AS sc 
          LEFT OUTER JOIN INDIGO031.Common.ThirdParty AS t  ON t.Id = sc.IdThirdParty
          LEFT OUTER JOIN INDIGO031.GeneralLedger.MainAccounts AS c  ON c.Id = sc.IdMainAccount
          INNER JOIN INDIGO031.GeneralLedger.MainAccountClasses AS cl  ON cl.Id = c.IdAccountClass
          LEFT OUTER JOIN INDIGO031.Payroll.CostCenter AS cco  ON cco.Id = sc.IdCostCenter
     WHERE(c.Number BETWEEN '40000000' AND '69999999')
          AND (c.LegalBookId = '2')
          AND (sc.Year = '2021')
          AND cco.Code = 'NVA004'
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