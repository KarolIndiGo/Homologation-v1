-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_LEDGER_ESTADORESULTADOS_2022
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_Ledger_EstadoResultados_2022
AS

SELECT  RTRIM(c.Number) + RTRIM(cco.Code) AS CuentaCentroCosto, c.Number AS Auxiliar, cco.Code AS CCosto, cco.Name AS [Centro Costo], c.Name AS [Nombre auxiliar], cl.Code AS CodClase, cl.Name AS Clase, LEFT(c.Number, 2) AS Grupo,
               (SELECT Name
              FROM   [INDIGO035].[GeneralLedger].[MainAccounts]
              WHERE (Number = LEFT(c.Number, 2)) AND (LegalBookId = '1')) AS [Nombre Grupo], LEFT(c.Number, 4) AS Cuenta,
               (SELECT Name
              FROM   [INDIGO035].[GeneralLedger].[MainAccounts] AS MainAccounts_1
              WHERE (Number = LEFT(c.Number, 4)) AND (LegalBookId = '1')) AS [Nombre Cuenta], LEFT(c.Number, 6) AS SubCuenta,
               (SELECT Name
              FROM   [INDIGO035].[GeneralLedger].[MainAccounts] AS MainAccounts_1
              WHERE (Number = LEFT(c.Number, 6)) AND (LegalBookId = '1')) AS [Nombre SubCuenta], t.Nit, t.Name AS [Nombre tercero], CASE WHEN sc.Month = '1' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Enero2022, CASE WHEN sc.Month = '2' AND 
           sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Febrero2022, CASE WHEN sc.Month = '3' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Marzo2022, CASE WHEN sc.Month = '4' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) 
           - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Abril2022, CASE WHEN sc.Month = '5' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Mayo2022, CASE WHEN sc.Month = '6' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Junio2022, 
           CASE WHEN sc.Month = '7' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Julio2022, CASE WHEN sc.Month = '8' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Agosto2022, CASE WHEN sc.Month = '9' AND 
           sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Septiembre2022, CASE WHEN sc.Month = '10' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Octubre2022, CASE WHEN sc.Month = '11' AND 
           sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Noviembre2022, CASE WHEN sc.Month = '12' AND sc.Year = '2022' THEN CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)) END AS Diciembre2022
FROM   [INDIGO035].[GeneralLedger].[GeneralLedgerBalance] AS sc  LEFT OUTER JOIN
           [INDIGO035].[Common].[ThirdParty] AS t  ON t.Id = sc.IdThirdParty LEFT OUTER JOIN
           [INDIGO035].[GeneralLedger].[MainAccounts] AS c  ON c.Id = sc.IdMainAccount INNER JOIN
           [INDIGO035].[GeneralLedger].[MainAccountClasses] AS cl  ON cl.Id = c.IdAccountClass LEFT OUTER JOIN
           [INDIGO035].[Payroll].[CostCenter] AS cco  ON cco.Id = sc.IdCostCenter
WHERE (c.Number BETWEEN '4110' AND '61703504') AND (c.LegalBookId = '1') AND (sc.Year = '2022')
GROUP BY c.Number, t.Nit, t.Name, cco.Code, sc.Month, c.Name, cl.Code, cl.Name, sc.Year, cco.Name
