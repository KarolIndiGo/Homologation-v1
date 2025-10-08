-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_ESTADOSFINANCIEROS_2022
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_EstadosFinancieros_2022
AS 

SELECT { fn CONCAT(C.Number, cco.Code) } AS Llave, 
       C.Number AS Auxiliar, C.Name AS [Nombre auxiliar], cl.Code AS CodClase, cl.Name AS Clase, 
       LEFT(C.Number, 2) AS Grupo,
       (SELECT Name 
            FROM [INDIGO035].[GeneralLedger].[MainAccounts] 
            WHERE (Number = LEFT(C.Number, 2)) AND (LegalBookId = '1')) AS [Nombre Grupo], 
       LEFT(C.Number, 4) AS Cuenta,
       (SELECT Name
            FROM [INDIGO035].[GeneralLedger].[MainAccounts] AS MainAccounts_1
            WHERE (Number = LEFT(C.Number, 4)) AND (LegalBookId = '1')) AS [Nombre Cuenta], 
       LEFT(C.Number, 6) AS SubCuenta,
       (SELECT Name
            FROM [INDIGO035].[GeneralLedger].[MainAccounts] AS MainAccounts_1
            WHERE (Number = LEFT(C.Number, 6)) AND (LegalBookId = '1')) AS [Nombre SubCuenta], 
       t.Nit, t.Name AS [Nombre tercero], cco.Code AS CentroCosto, 
       CASE WHEN sc.Month = '14' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS [SaldosIniciales], 
       CASE WHEN sc.Month = '1' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1,  CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Enero, 
       CASE WHEN sc.Month = '2' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Febrero, 
       CASE WHEN sc.Month = '3' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Marzo, 
       CASE WHEN sc.Month = '4' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Abril, 
       CASE WHEN sc.Month = '5' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Mayo, 
       CASE WHEN sc.Month = '6' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Junio, 
       CASE WHEN sc.Month = '7' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Julio, 
       CASE WHEN sc.Month = '8' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Agosto, 
       CASE WHEN sc.Month = '9' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Septiembre, 
       CASE WHEN sc.Month = '10' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Octubre, 
       CASE WHEN sc.Month = '11' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Noviembre, 
       CASE WHEN sc.Month = '12' AND sc.Year = '2022' THEN IIF(cl.Nature <> C.Nature, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4))) * -1, IIF(C.Nature = 1, CAST((SUM(sc.DebitValue) - SUM(sc.CreditValue)) AS DECIMAL(19,4)), CAST((SUM(sc.CreditValue) - SUM(sc.DebitValue)) AS DECIMAL(19,4)))) * IIF(cl.Nature = 2, -1, 1) END AS Diciembre, 
       PO.Name AS Cargos
FROM    [INDIGO035].[GeneralLedger].[GeneralLedgerBalance] AS sc INNER JOIN
        [INDIGO035].[GeneralLedger].[MainAccounts] AS C ON C.Id = sc.IdMainAccount INNER JOIN
        [INDIGO035].[GeneralLedger].[MainAccountClasses] AS cl ON cl.Id = C.IdAccountClass INNER JOIN
        [INDIGO035].[Common].[ThirdParty] AS t ON t.Id = sc.IdThirdParty INNER JOIN
        [INDIGO035].[Payroll].[CostCenter] AS cco ON cco.Id = sc.IdCostCenter LEFT OUTER JOIN
        [INDIGO035].[Payroll].[Employee] AS E ON E.ThirdPartyId = t.Id LEFT OUTER JOIN
        [INDIGO035].[Payroll].[Contract] AS CONT ON CONT.EmployeeId = E.Id AND CONT.Status = 1 LEFT OUTER JOIN
        [INDIGO035].[Payroll].[Position] AS PO ON PO.Id = CONT.PositionId 
WHERE C.LegalBookId = '1'
GROUP BY C.Number, t.Nit, t.Name, cco.Code, C.IdAccountLevel, sc.Month, C.Name, cl.Code, cl.Name, sc.Year, C.Nature, cl.Nature, PO.Name


