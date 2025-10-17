-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_FACT_VentasJuridicas2020
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_FACT_VentasJuridicas2020]
AS
     SELECT t.Nit, 
            t.Name AS Cliente, 
            cco.Code AS CentroCosto,
            CASE
                WHEN sc.Month = '1'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Enero ],
            CASE
                WHEN sc.Month = '2'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Febrero ],
            CASE
                WHEN sc.Month = '3'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Marzo ],
            CASE
                WHEN sc.Month = '4'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Abril ],
            CASE
                WHEN sc.Month = '5'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Mayo ],
            CASE
                WHEN sc.Month = '6'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Junio ],
            CASE
                WHEN sc.Month = '7'
                     AND sc.Year = ''
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Julio ],
            CASE
                WHEN sc.Month = '8'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Agosto ],
            CASE
                WHEN sc.Month = '9'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Septiembre ],
            CASE
                WHEN sc.Month = '10'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Octubre ],
            CASE
                WHEN sc.Month = '11'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Noviembre ],
            CASE
                WHEN sc.Month = '12'
                     AND sc.Year = ''
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Diciembre ],
            CASE
                WHEN cco.Code LIKE 'BOG%'
                THEN 'Boyaca'
                WHEN cco.Code LIKE 'TAM%'
                THEN 'BogotaSur'
                WHEN cco.Code LIKE 'B00%'
                THEN 'BOYACA'
                WHEN cco.Code LIKE 'MET%'
                THEN 'META'
                WHEN cco.Code LIKE 'YOP%'
                THEN 'YOPAL'
            END AS Sede, 
            'Evento' AS Tipo
     FROM GeneralLedger.GeneralLedgerBalance AS sc 
          INNER JOIN Common.ThirdParty AS t ON t.Id = sc.IdThirdParty
                                                                 AND sc.Year = '2020'
          LEFT JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
          JOIN GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount
     WHERE(c.Number LIKE '41%'
           AND c.Number NOT LIKE '4140%'
           AND c.Number <> '4175700701')
          AND (t.PersonType = '2')
          AND (c.LegalBookId = '2')
     GROUP BY t.Nit, 
              t.Name, 
              cco.Code, 
              sc.Month, 
              sc.Year
     UNION ALL
     SELECT t.Nit, 
            t.Name AS Cliente, 
            cco.Code AS CentroCosto,
            CASE
                WHEN sc.Month = '1'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Enero],
            CASE
                WHEN sc.Month = '2'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Febrero],
            CASE
                WHEN sc.Month = '3'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Marzo],
            CASE
                WHEN sc.Month = '4'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Abril],
            CASE
                WHEN sc.Month = '5'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Mayo],
            CASE
                WHEN sc.Month = '6'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Junio],
            CASE
                WHEN sc.Month = '7'
                     AND sc.Year = '2019'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Julio],
            CASE
                WHEN sc.Month = '8'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Agosto],
            CASE
                WHEN sc.Month = '9'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Septiembre],
            CASE
                WHEN sc.Month = '10'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Octubre],
            CASE
                WHEN sc.Month = '11'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Noviembre],
            CASE
                WHEN sc.Month = '12'
                     AND sc.Year = '2019'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Diciembre],
            CASE
                WHEN cco.Code LIKE 'BOG%'
                THEN 'Bogota'
                WHEN cco.Code LIKE 'TAM%'
                THEN 'BogotaSur'
                WHEN cco.Code LIKE 'B00%'
                THEN 'BOYACA'
                WHEN cco.Code LIKE 'MET%'
                THEN 'META'
                WHEN cco.Code LIKE 'YOP%'
                THEN 'YOPAL'
            END AS Sede, 
            'Capita' AS Tipo
     FROM GeneralLedger.GeneralLedgerBalance AS sc 
          INNER JOIN Common.ThirdParty AS t ON t.Id = sc.IdThirdParty
                                                                 AND sc.Year = '2020'
          JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
          JOIN GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount
     WHERE(c.Number = '4140050501'
           OR c.Number = '4175700701')
          AND (t.PersonType = '2')
          AND (c.LegalBookId = '2')
     GROUP BY t.Nit, 
              t.Name, 
              cco.Code, 
              sc.Month, 
              sc.Year;
