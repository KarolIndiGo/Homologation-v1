-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_FACT_VentasJuridicas_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create view [ViewInternal].[FQ45_V_FACT_VentasJuridicas_2025]
AS
SELECT 'FarmaQx' as Sede,t.Nit,
       t.Name AS Cliente,
       cco.Code AS CodCC,
       CASE
          WHEN sc.Month = '1'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Enero 2025],
       CASE
          WHEN sc.Month = '2' AND sc.Year = '2025'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Febrero 2025],
       CASE
          WHEN sc.Month = '3'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Marzo 2025],
       CASE
          WHEN sc.Month = '4'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Abril 2025],
       CASE
          WHEN sc.Month = '5'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Mayo 2025],
       CASE
          WHEN sc.Month = '6'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Junio 2025],
       CASE
          WHEN sc.Month = '7' AND sc.Year = '2025'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Julio 2025],
       CASE
          WHEN sc.Month = '8'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Agosto 2025],
       CASE
          WHEN sc.Month = '9'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Septiembre 2025],
       CASE
          WHEN sc.Month = '10'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Octubre 2025],
       CASE
          WHEN sc.Month = '11'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Noviembre 2025],
       CASE
          WHEN sc.Month = '12' AND sc.Year = '2025'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Diciembre 2025],
       cco.Name AS CentroCosto,
       'Evento' AS Tipo,
       c.Number AS Cuenta, C.Name AS NombreCuenta
FROM GeneralLedger.GeneralLedgerBalance AS sc 
     INNER JOIN Common.ThirdParty AS t
        ON t.Id = sc.IdThirdParty AND sc.Year = '2025'
     INNER JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
     INNER JOIN GeneralLedger.MainAccounts AS c
        ON c.Id = sc.IdMainAccount
WHERE     (c.Number LIKE '41%')
      AND (t.PersonType = '2')
      AND (c.LegalBookId = '1')
      AND (sc.DebitValue - sc.CreditValue <> 0)
GROUP BY t.Nit,
         t.Name,
         cco.Code,
         cco.Name,
         sc.Month,
         sc.Year,
         c.Number, c.Name
