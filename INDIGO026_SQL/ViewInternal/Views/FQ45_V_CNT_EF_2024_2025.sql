-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CNT_EF_2024_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_CNT_EF_2024_2025] AS

SELECT {FN CONCAT (CASE WHEN C.IdAccountLevel = 5 THEN C.Number END, CC.Code)}
          AS Llave,
       CASE WHEN C.IdAccountLevel = 5 THEN C.Number END
          AS Auxiliar,
       CASE WHEN C.IdAccountLevel = 5 THEN C.Name END
          AS NombreAuxiliar,
       cl.Code
          AS Clase,
       cl.Name
          AS NombreClase,
       CASE WHEN C3.IdAccountLevel = 2 THEN C3.Number END
          AS Grupo,
       CASE WHEN C3.IdAccountLevel = 2 THEN C3.Name END
          AS NombreGrupo,
       CASE WHEN C2.IdAccountLevel = 3 THEN C2.Number END
          AS Cuenta,
       CASE WHEN C2.IdAccountLevel = 3 THEN C2.Name END
          AS NombreCuenta,
       CASE WHEN C1.IdAccountLevel = 4 THEN C1.Number END
          AS SubGrupo,
       CASE WHEN C1.IdAccountLevel = 4 THEN C1.Name END
          AS NombreSubGrupo,
       T.Nit,
       T.Name
          AS Tercero,
       CC.Code
          AS CC,
       CC.Name
          AS CentroCosto,
	   CASE WHEN B.[Month] = 1 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Enero24,
	   CASE WHEN B.[Month] = 2 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Febrero24,
	   CASE WHEN B.[Month] = 3 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Marzo24,
	   CASE WHEN B.[Month] = 4 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Abril24,
	   CASE WHEN B.[Month] = 5 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Mayo24,
	   CASE WHEN B.[Month] = 6 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Junio24,
	   CASE WHEN B.[Month] = 7 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Julio24,
	   CASE WHEN B.[Month] = 8 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Agosto24,
	   CASE WHEN B.[Month] = 9 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Septiembre24,
	   CASE WHEN B.[Month] = 10 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Octubre24,
	   CASE WHEN B.[Month] = 11 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Noviembre24,
	   CASE WHEN B.[Month] = 12 AND B.Year = 2024 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Diciembre24,
	   CASE WHEN B.[Month] = 1 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Enero25,
	   CASE WHEN B.[Month] = 2 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Febrero25,
	   CASE WHEN B.[Month] = 3 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Marzo25,
	   CASE WHEN B.[Month] = 4 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Abril25,
	   CASE WHEN B.[Month] = 5 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Mayo25,
	   CASE WHEN B.[Month] = 6 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Junio25,
	   CASE WHEN B.[Month] = 7 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Julio25,
	   CASE WHEN B.[Month] = 8 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Agosto25,
	   CASE WHEN B.[Month] = 9 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Septiembre25,
	   CASE WHEN B.[Month] = 10 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Octubre25,
	   CASE WHEN B.[Month] = 11 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Noviembre25,
	   CASE WHEN B.[Month] = 12 AND B.Year = 2025 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Diciembre25,

       PO.Name
          AS Cargos
FROM GeneralLedger.GeneralLedgerBalance AS B
     INNER JOIN GeneralLedger.MainAccounts AS C 
        ON B.IdMainAccount = C.Id AND B.Year in ('2024','2025')
     INNER JOIN GeneralLedger.MainAccountClasses AS cl
        ON     C.IdAccountClass = cl.Id
           AND C.LegalBookId = 1
           AND cl.Code BETWEEN '4' AND '6'
     INNER JOIN GeneralLedger.MainAccounts AS C1
        ON C.IdParent = C1.Id AND C1.LegalBookId = 1
     INNER JOIN GeneralLedger.MainAccounts AS C2
        ON C1.IdParent = C2.Id AND C2.LegalBookId = 1
     INNER JOIN GeneralLedger.MainAccounts AS C3
        ON C2.IdParent = C3.Id AND C3.LegalBookId = 1
     LEFT OUTER JOIN Common.ThirdParty AS T 
        ON B.IdThirdParty = T.Id
     LEFT OUTER JOIN Payroll.CostCenter AS CC ON B.IdCostCenter = CC.Id
     LEFT OUTER JOIN Payroll.Employee AS E ON E.ThirdPartyId = T.Id
     LEFT OUTER JOIN Payroll.Contract AS CONT
        ON CONT.EmployeeId = E.Id AND CONT.Status = 1
     LEFT OUTER JOIN Payroll.Position AS PO ON PO.Id = CONT.PositionId
GROUP BY C.IdAccountLevel,
         cl.Code,
         cl.Name,
         C3.IdAccountLevel,
         C2.IdAccountLevel,
         C1.IdAccountLevel,
         C.Name,
         C3.Name,
         C2.Name,
         C1.Name,
         T.Nit,
         T.Name,
         CC.Code,
         CC.Name,
         C.Number,
         C1.Number,
         C2.Number,
         C3.Number,
         B.Month,
         PO.Name,
		 b.year
