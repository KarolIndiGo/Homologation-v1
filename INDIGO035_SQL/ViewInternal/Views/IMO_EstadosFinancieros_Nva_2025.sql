-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_EstadosFinancieros_Nva_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[IMO_EstadosFinancieros_Nva_2025]
AS
SELECT { fn CONCAT(C.Number, cco.Code) } AS Llave, 
		C.Number AS Auxiliar, c.Name AS [Nombre auxiliar], cl.Code AS CodClase, cl.Name AS Clase, 
		LEFT(c.Number, 2) AS Grupo,
        (SELECT Name 
				FROM GeneralLedger.MainAccounts 
				WHERE (Number = LEFT(c.Number, 2)) AND (LegalBookId = '1')) AS [Nombre Grupo], LEFT(c.Number, 4) AS Cuenta,
        (SELECT Name
				FROM GeneralLedger.MainAccounts AS MainAccounts_1
				WHERE (Number = LEFT(c.Number, 4)) AND (LegalBookId = '1')) AS [Nombre Cuenta], LEFT(c.Number, 6) AS SubCuenta,
        (SELECT Name
				FROM GeneralLedger.MainAccounts AS MainAccounts_1
				WHERE (Number = LEFT(c.Number, 6)) AND (LegalBookId = '1')) AS [Nombre SubCuenta], t .Nit, t .Name AS [Nombre tercero], cco.Code AS CentroCosto, 
		CASE WHEN sc.Month = '14' AND sc.Year = '2024' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS [SaldosIniciales], 
		CASE WHEN sc.Month = '1' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1,  CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Enero25, 
		CASE WHEN sc.Month = '2' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Febrero25, 
		CASE WHEN sc.Month = '3' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Marzo25, 
		CASE WHEN sc.Month = '4' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Abril25, 
		CASE WHEN sc.Month = '5' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Mayo25, 
		CASE WHEN sc.Month = '6' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Junio25, 
		CASE WHEN sc.Month = '7' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Julio25, 
		CASE WHEN sc.Month = '8' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Agosto25, 
		CASE WHEN sc.Month = '9' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Septiembre25, 
		CASE WHEN sc.Month = '10' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Octubre25, 
		CASE WHEN sc.Month = '11' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Noviembre25, 
		CASE WHEN sc.Month = '12' AND sc.Year = '2025' THEN IIF(cl.Nature <> c.Nature, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY)) * - 1, IIF(c.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS MONEY), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS MONEY))) * IIF(cl.Nature = 2, - 1, 1) END AS Diciembre25, 
		PO.Name AS Cargos, cco.name as centro
FROM    GeneralLedger.GeneralLedgerBalance AS sc INNER JOIN
        GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount INNER JOIN
        GeneralLedger.MainAccountClasses AS cl ON cl.Id = c.IdAccountClass INNER JOIN
        Common.ThirdParty AS t ON t .Id = sc.IdThirdParty LEFT OUTER JOIN
        Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter LEFT OUTER JOIN
        Payroll.Employee AS E ON E.ThirdPartyId = T .Id LEFT OUTER JOIN
        Payroll.Contract AS CONT ON CONT.EmployeeId = E.Id AND CONT.Status = 1 LEFT OUTER JOIN
        Payroll.Position AS PO ON PO.Id = CONT.PositionId
WHERE c.LegalBookId = '1' and cl.Code IN (4,5,6) and CCO.Name Like 'NEV%' --and t .Nit='901127065'
GROUP BY c.Number, t .Nit, t .Name, cco.Code, C.IdAccountLevel, sc.Month, c.Name, cl.Code, cl.Name, sc.Year, c.Nature, cl.Nature, PO.Name, cco.name
