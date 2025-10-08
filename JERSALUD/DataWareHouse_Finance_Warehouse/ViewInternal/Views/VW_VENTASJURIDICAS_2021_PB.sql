-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VENTASJURIDICAS_2021_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VENTASJURIDICAS_2021_PB AS
SELECT
    CASE
        WHEN cco.Code LIKE 'BOG%' THEN 'Bogota'
        WHEN cco.Code LIKE 'MED%' THEN 'Medicamentos'
        WHEN cco.Code LIKE 'TAM%' THEN 'Bogota'
        WHEN cco.Code LIKE 'B00%' THEN 'Boyaca'
        WHEN cco.Code LIKE 'B0Y%' THEN 'Boyaca'
        WHEN cco.Code LIKE 'MET%' THEN 'Meta'
        WHEN cco.Code LIKE 'NVA%' THEN 'Neiva'
        WHEN cco.Code LIKE 'MVI%' THEN 'Medicamentos'
        WHEN cco.Code LIKE 'MTU%' THEN 'Medicamentos'
        WHEN cco.Code LIKE 'YOP%' THEN 'Casanare'
    END AS Sede,
    t.Nit,
    t.Name AS Cliente,
    cco.Code AS CodCC,
    CASE
        WHEN sc.Month = '1'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Enero 2021],
    CASE
        WHEN sc.Month = '2' AND sc.Year = '2021'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Febrero 2021],
    CASE
        WHEN sc.Month = '3'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Marzo 2021],
    CASE
        WHEN sc.Month = '4'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Abril 2021],
    CASE
        WHEN sc.Month = '5'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Mayo 2021],
    CASE
        WHEN sc.Month = '6'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Junio 2021],
    CASE
        WHEN sc.Month = '7' AND sc.Year = '2021'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Julio 2021],
    CASE
        WHEN sc.Month = '8'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Agosto 2021],
    CASE
        WHEN sc.Month = '9'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Septiembre 2021],
    CASE
        WHEN sc.Month = '10'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Octubre 2021],
    CASE
        WHEN sc.Month = '11'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Noviembre 2021],
    CASE
        WHEN sc.Month = '12' AND sc.Year = '2021'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Diciembre 2021],
    cco.Name AS CentroCosto,
    'Evento' AS Tipo,
    c.Number AS Cuenta
FROM INDIGO031.GeneralLedger.GeneralLedgerBalance AS sc
    INNER JOIN INDIGO031.Common.ThirdParty AS t
        ON t.Id = sc.IdThirdParty AND sc.Year = '2021'
    INNER JOIN INDIGO031.Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
    INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS c
        ON c.Id = sc.IdMainAccount
WHERE
    (c.Number LIKE '41%')
    AND (c.Number NOT LIKE '4140%')
    AND (c.Number <> '4175700701')
    AND (t.PersonType = '2')
    AND (c.LegalBookId = '2')
    AND (sc.DebitValue - sc.CreditValue <> 0)
GROUP BY
    t.Nit,
    t.Name,
    cco.Code,
    cco.Name,
    sc.Month,
    sc.Year,
    c.Number

UNION ALL

SELECT
    CASE
        WHEN cco.Code LIKE 'BOG%' THEN 'Bogota'
        WHEN cco.Code LIKE 'MED%' THEN 'Medicamentos'
        WHEN cco.Code LIKE 'TAM%' THEN 'Bogota'
        WHEN cco.Code LIKE 'B00%' THEN 'Boyaca'
        WHEN cco.Code LIKE 'B0Y%' THEN 'Boyaca'
        WHEN cco.Code LIKE 'MET%' THEN 'Meta'
        WHEN cco.Code LIKE 'NVA%' THEN 'Neiva'
        WHEN cco.Code LIKE 'MVI%' THEN 'Medicamentos'
        WHEN cco.Code LIKE 'MTU%' THEN 'Medicamentos'
        WHEN cco.Code LIKE 'YOP%' THEN 'Casanare'
    END AS Sede,
    t.Nit,
    t.Name AS Cliente,
    cco.Code AS CodCC,
    CASE
        WHEN sc.Month = '1'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Enero 2021],
    CASE
        WHEN sc.Month = '2' AND sc.Year = '2021'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Febrero 2021],
    CASE
        WHEN sc.Month = '3'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Marzo 2021],
    CASE
        WHEN sc.Month = '4'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Abril 2021],
    CASE
        WHEN sc.Month = '5'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Mayo 2021],
    CASE
        WHEN sc.Month = '6'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Junio 2021],
    CASE
        WHEN sc.Month = '7' AND sc.Year = '2021'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Julio 2021],
    CASE
        WHEN sc.Month = '8'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Agosto 2021],
    CASE
        WHEN sc.Month = '9'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Septiembre 2021],
    CASE
        WHEN sc.Month = '10'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Octubre 2021],
    CASE
        WHEN sc.Month = '11'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Noviembre 2021],
    CASE
        WHEN sc.Month = '12' AND sc.Year = '2021'
        THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
    END AS [Diciembre 2021],
    cco.Name AS CentroCosto,
    'Capita' AS Tipo,
    c.Number AS Cuenta
FROM INDIGO031.GeneralLedger.GeneralLedgerBalance AS sc
    INNER JOIN INDIGO031.Common.ThirdParty AS t
        ON t.Id = sc.IdThirdParty AND sc.Year = '2021'
    INNER JOIN INDIGO031.Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
    INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS c
        ON c.Id = sc.IdMainAccount
WHERE
    (c.Number = '4140050501'
     OR c.Number = '4175700701')
    AND (t.PersonType = '2')
    AND (c.LegalBookId = '2')
    AND (sc.DebitValue - sc.CreditValue <> 0)
GROUP BY
    t.Nit,
    t.Name,
    cco.Code,
    cco.Name,
    sc.Month,
    sc.Year,
    c.Number