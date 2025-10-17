-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CNT_EF_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create view [ViewInternal].[FQ45_V_CNT_EF_2025]
AS
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
       CASE B.[Month]
          WHEN 1
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Enero,
       CASE B.[Month]
          WHEN 2
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Febrero,
       CASE B.[Month]
          WHEN 3
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Marzo,
       CASE B.[Month]
          WHEN 4
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Abril,
       CASE B.[Month]
          WHEN 5
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Mayo,
       CASE B.[Month]
          WHEN 6
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Junio,
       CASE B.[Month]
          WHEN 7
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Julio,
       CASE B.[Month]
          WHEN 8
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Agosto,
       CASE B.[Month]
          WHEN 9
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Septiembre,
       CASE B.[Month]
          WHEN 10
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Octubre,
       CASE B.[Month]
          WHEN 11
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Noviembre,
       CASE B.[Month]
          WHEN 12
          THEN
             CONVERT (MONEY, SUM (B.CreditValue) - SUM (B.DebitValue), 0)
          ELSE
             '0'
       END
          AS Diciembre,
       PO.Name
          AS Cargos
FROM GeneralLedger.GeneralLedgerBalance AS B
     INNER JOIN GeneralLedger.MainAccounts AS C 
        ON B.IdMainAccount = C.Id AND B.Year = '2025'
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
         PO.Name
