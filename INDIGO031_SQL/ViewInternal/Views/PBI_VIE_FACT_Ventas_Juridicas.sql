-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: PBI_VIE_FACT_Ventas_Juridicas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[PBI_VIE_FACT_Ventas_Juridicas]
AS
     SELECT t.Nit, 
            t.Name AS Cliente, 
            cco.Code AS CentroCosto, 
            sc.Year AS Año, 
            sc.month AS Mes,
            CASE sc.Month
                WHEN '1'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '2'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '3'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '4'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '5'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '6'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '7'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '8'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '9'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '10'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '11'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '12'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS Ventas,
            CASE
                WHEN cco.Code LIKE 'BOG%'
                THEN 'Bogota'
                WHEN cco.Code LIKE 'TAM%'
                THEN 'BogotaSur'
                WHEN cco.Code LIKE 'B00%'
                THEN 'BOYACA'
                WHEN cco.Code LIKE 'MET%'
                THEN 'META'
            END AS Sede, 
            'Evento' AS Tipo,
            CASE
                WHEN cco.Code LIKE 'TAM%'
                THEN '5500000000'
                WHEN cco.Code LIKE 'MET%'
                THEN '5500000000'
                WHEN cco.Code LIKE 'B00%'
                THEN '3500000000'
            END AS Presupuesto,
            CASE t.PersonType
                WHEN '1'
                THEN 'Natural'
                WHEN '2'
                THEN 'Juridica'
            END AS Persona
     FROM GeneralLedger.GeneralLedgerBalance AS sc 
          INNER JOIN Common.ThirdParty AS t ON t.Id = sc.IdThirdParty
                                                                 AND sc.Year >= '2018'
          JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
          JOIN GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount
     WHERE(c.Number LIKE '4110%'
           OR c.Number LIKE '4170%')
          AND (t.PersonType = '2')
          AND (c.LegalBookId = '2')
     GROUP BY t.Nit, 
              t.Name, 
              t.PersonType, 
              cco.Code, 
              sc.Month, 
              sc.Year
     UNION ALL
     SELECT t.Nit, 
            t.Name AS Cliente, 
            cco.Code AS CentroCosto, 
            sc.Year AS Año, 
            sc.month AS Mes,
            CASE sc.Month
                WHEN '1'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '2'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '3'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '4'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '5'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '6'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '7'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '8'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '9'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '10'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '11'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
                WHEN '12'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS Ventas,
            CASE
                WHEN cco.Code LIKE 'BOG%'
                THEN 'Bogota'
                WHEN cco.Code LIKE 'TAM%'
                THEN 'BogotaSur'
                WHEN cco.Code LIKE 'B00%'
                THEN 'BOYACA'
                WHEN cco.Code LIKE 'MET%'
                THEN 'META'
            END AS Sede, 
            'Capita' AS Tipo,
            CASE
                WHEN cco.Code LIKE 'TAM%'
                THEN '5500000000'
                WHEN cco.Code LIKE 'MET%'
                THEN '5500000000'
                WHEN cco.Code LIKE 'B00%'
                THEN '3500000000'
            END AS Presupuesto,
            CASE t.PersonType
                WHEN '1'
                THEN 'Natural'
                WHEN '2'
                THEN 'Juridica'
            END AS Persona
     FROM GeneralLedger.GeneralLedgerBalance AS sc 
          INNER JOIN Common.ThirdParty AS t ON t.Id = sc.IdThirdParty
                                                                 AND sc.Year >= '2018'
          JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
          JOIN GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount
     WHERE(c.Number = '4140050501')
          AND (t.PersonType = '2')
          AND (c.LegalBookId = '2')
     GROUP BY t.Nit, 
              t.Name, 
              t.PersonType, 
              cco.Code, 
              sc.Month, 
              sc.Year;
