-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Ledger_VentasJuridicas_2021
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Ledger_VentasJuridicas_2021]
AS
SELECT 'Medisalud UT' as Sede,t.Nit,
       t.Name AS Cliente,
       cco.Code AS CodCC,
       CASE
          WHEN sc.Month = '1'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Enero 2021],
       CASE
          WHEN sc.Month = '2' AND sc.Year = '2021'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Febrero 2021],
       CASE
          WHEN sc.Month = '3'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Marzo 2021],
       CASE
          WHEN sc.Month = '4'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Abril 2021],
       CASE
          WHEN sc.Month = '5'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Mayo 2021],
       CASE
          WHEN sc.Month = '6'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Junio 2021],
       CASE
          WHEN sc.Month = '7' AND sc.Year = '2021'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Julio 2021],
       CASE
          WHEN sc.Month = '8'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Agosto 2021],
       CASE
          WHEN sc.Month = '9'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Septiembre 2021],
       CASE
          WHEN sc.Month = '10'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Octubre 2021],
       CASE
          WHEN sc.Month = '11'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Noviembre 2021],
       CASE
          WHEN sc.Month = '12' AND sc.Year = '2021'
          THEN
             ((SUM (sc.DebitValue) - SUM (sc.CreditValue))) * -1
       END AS [Diciembre 2021],
       cco.Name AS CentroCosto,
       'Evento' AS Tipo,
       c.Number AS Cuenta, C.Name AS NombreCuenta
FROM GeneralLedger.GeneralLedgerBalance AS sc 
     INNER JOIN Common.ThirdParty AS t
        ON t.Id = sc.IdThirdParty AND sc.Year = '2021'
     INNER JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
     INNER JOIN GeneralLedger.MainAccounts AS c
        ON c.Id = sc.IdMainAccount
WHERE     (c.Number LIKE '41%')
      AND (t.PersonType = '2')
      AND (c.LegalBookId = '2')
      AND (sc.DebitValue - sc.CreditValue <> 0)
GROUP BY t.Nit,
         t.Name,
         cco.Code,
         cco.Name,
         sc.Month,
         sc.Year,
         c.Number, c.Name
