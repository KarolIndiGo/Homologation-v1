-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_FACT_VENTASJURIDICAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_FACT_VentasJuridicas
AS

SELECT t.Nit, 
       t.Name AS Cliente, 
       cco.Code AS CentroCosto,
       cco.Name AS Centro,
       CASE
           WHEN sc.Month = '1' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Enero 2024],
       CASE
           WHEN sc.Month = '2' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Febrero 2024],
       CASE
           WHEN sc.Month = '3' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Marzo 2024],
       CASE
           WHEN sc.Month = '4' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Abril 2024],
       CASE
           WHEN sc.Month = '5' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Mayo 2024],
       CASE
           WHEN sc.Month = '6' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Junio 2024],
       CASE
           WHEN sc.Month = '7' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Julio 2024],
       CASE
           WHEN sc.Month = '8' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Agosto 2024],
       CASE
           WHEN sc.Month = '9' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Septiembre 2024],
       CASE
           WHEN sc.Month = '10' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Octubre 2024],
       CASE
           WHEN sc.Month = '11' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Noviembre 2024],
       CASE
           WHEN sc.Month = '12' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Diciembre 2024],
       CASE
           WHEN sc.Month = '1' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Enero 2025],
       CASE
           WHEN sc.Month = '2' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Febrero 2025],
       CASE
           WHEN sc.Month = '3' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Marzo 2025],
       CASE
           WHEN sc.Month = '4' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Abril 2025],
       CASE
           WHEN sc.Month = '5' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Mayo 2025],
       CASE
           WHEN sc.Month = '6' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Junio 2025],
       CASE
           WHEN sc.Month = '7' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Julio 2025],
       CASE
           WHEN sc.Month = '8' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Agosto 2025],
       CASE
           WHEN sc.Month = '9' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Septiembre 2025],
       CASE
           WHEN sc.Month = '10' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Octubre 2025],
       CASE
           WHEN sc.Month = '11' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Noviembre 2025],
       CASE
           WHEN sc.Month = '12' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Diciembre 2025],
       CASE
           WHEN cco.Name LIKE 'NEV%'
           THEN 'Neiva'
           WHEN cco.Name LIKE 'PIT%'
           THEN 'Pitalito'
           WHEN cco.Name LIKE 'TUN%'
           THEN 'Tunja'
           ELSE 'DESCONOCIDO'
       END AS Sede, 
       'Evento' AS Tipo
FROM [INDIGO035].[GeneralLedger].[GeneralLedgerBalance] AS sc
     INNER JOIN [INDIGO035].[Common].[ThirdParty] AS t ON t.Id = sc.IdThirdParty
                                                AND sc.Year IN ('2024', '2025')
     LEFT JOIN [INDIGO035].[Payroll].[CostCenter] AS cco ON cco.Id = sc.IdCostCenter
     JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS c ON c.Id = sc.IdMainAccount
WHERE (c.Number IN ('41301101','41301102', '41260706', '41301103', '41303501','41301104','41103704','41350101', '41351010'))
      AND (t.PersonType = '2')
      AND (c.LegalBookId = '1')
GROUP BY t.Nit, 
         t.Name, 
         cco.Code, 
         sc.Month, 
         sc.Year,
         cco.Name

UNION ALL

SELECT t.Nit, 
       t.Name AS Cliente, 
       cco.Code AS CentroCosto,
       cco.Name AS Centro,
       CASE
           WHEN sc.Month = '1' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Enero 2024],
       CASE
           WHEN sc.Month = '2' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Febrero 2024],
       CASE
           WHEN sc.Month = '3' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Marzo 2024],
       CASE
           WHEN sc.Month = '4' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Abril 2024],
       CASE
           WHEN sc.Month = '5' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Mayo 2024],
       CASE
           WHEN sc.Month = '6' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Junio 2024],
       CASE
           WHEN sc.Month = '7' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Julio 2024],
       CASE
           WHEN sc.Month = '8' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Agosto 2024],
       CASE
           WHEN sc.Month = '9' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Septiembre 2024],
       CASE
           WHEN sc.Month = '10' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Octubre 2024],
       CASE
           WHEN sc.Month = '11' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Noviembre 2024],
       CASE
           WHEN sc.Month = '12' AND sc.Year = '2024'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Diciembre 2024],
       CASE
           WHEN sc.Month = '1' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Enero 2025],
       CASE
           WHEN sc.Month = '2' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Febrero 2025],
       CASE
           WHEN sc.Month = '3' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Marzo 2025],
       CASE
           WHEN sc.Month = '4' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Abril 2025],
       CASE
           WHEN sc.Month = '5' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Mayo 2025],
       CASE
           WHEN sc.Month = '6' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Junio 2025],
       CASE
           WHEN sc.Month = '7' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Julio 2025],
       CASE
           WHEN sc.Month = '8' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Agosto 2025],
       CASE
           WHEN sc.Month = '9' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Septiembre 2025],
       CASE
           WHEN sc.Month = '10' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Octubre 2025],
       CASE
           WHEN sc.Month = '11' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Noviembre 2025],
       CASE
           WHEN sc.Month = '12' AND sc.Year = '2025'
           THEN ((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
       END AS [Diciembre 2025],
       CASE
           WHEN cco.Name LIKE 'NEV%'
           THEN 'Neiva'
           WHEN cco.Name LIKE 'PIT%'
           THEN 'Pitalito'
           WHEN cco.Name LIKE 'TUN%'
           THEN 'Tunja'
           ELSE 'DESCONOCIDO'
       END AS Sede, 
       'PGP' AS Tipo
FROM [INDIGO035].[GeneralLedger].[GeneralLedgerBalance] AS sc
     INNER JOIN [INDIGO035].[Common].[ThirdParty] AS t ON t.Id = sc.IdThirdParty
                                                AND sc.Year IN ('2024', '2025')
     JOIN [INDIGO035].[Payroll].[CostCenter] AS cco ON cco.Id = sc.IdCostCenter
     JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS c ON c.Id = sc.IdMainAccount
WHERE (c.Number IN ('41103701'))
      AND (t.PersonType = '2')
      AND (c.LegalBookId = '1')
GROUP BY t.Nit, 
         t.Name, 
         cco.Code, 
         sc.Month, 
         sc.Year,
         cco.Name
;