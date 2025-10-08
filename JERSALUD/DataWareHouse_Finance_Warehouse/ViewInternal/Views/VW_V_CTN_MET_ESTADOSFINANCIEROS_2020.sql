-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_CTN_MET_ESTADOSFINANCIEROS_2020
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_V_CTN_MET_ESTADOSFINANCIEROS_2020] AS

     SELECT{FN CONCAT(CASE
                          WHEN C.IdAccountLevel = 6
                          THEN C.Number
                      END, CC.Code)}AS Llave,
           CASE
               WHEN C.IdAccountLevel = 6
               THEN C.Number
           END AS SubAuxiliar,
           CASE
               WHEN C.IdAccountLevel = 6
               THEN C.Name
           END AS Nombre_SubAuxiliar, 
           cl.Code AS Clase, 
           cl.Name AS NombreClase,
           CASE
               WHEN C4.IdAccountLevel = 2
               THEN C4.Number
           END AS Grupo,
           CASE
               WHEN C4.IdAccountLevel = 2
               THEN C4.Name
           END AS NombreGrupo,
           CASE
               WHEN C3.IdAccountLevel = 3
               THEN C3.Number
           END AS Cuenta,
           CASE
               WHEN C3.IdAccountLevel = 3
               THEN C3.Name
           END AS NombreCuenta,
           CASE
               WHEN C2.IdAccountLevel = 4
               THEN C2.Number
           END AS SubGrupo,
           CASE
               WHEN C2.IdAccountLevel = 4
               THEN C2.Name
           END AS NombreSubGrupo, 
           T.Nit, 
           T.Name AS Tercero, 
           CC.Code AS CC, 
           CC.Name AS CentroCosto,
           CASE B.[Month]
               WHEN 1
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Enero,
           CASE B.[Month]
               WHEN 2
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Febrero,
           CASE B.[Month]
               WHEN 3
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Marzo,
           CASE B.[Month]
               WHEN 4
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Abril,
           CASE B.[Month]
               WHEN 5
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Mayo,
           CASE B.[Month]
               WHEN 6
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Junio,
           CASE B.[Month]
               WHEN 7
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Julio,
           CASE B.[Month]
               WHEN 8
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Agosto,
           CASE B.[Month]
               WHEN 9
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Septiembre,
           CASE B.[Month]
               WHEN 10
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Octubre,
           CASE B.[Month]
               WHEN 11
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Noviembre,
           CASE B.[Month]
               WHEN 12
               THEN CONVERT(DECIMAL(19,4), SUM(B.CreditValue) - SUM(B.DebitValue), 0)
               ELSE '0'
           END AS Diciembre, 
           Car.Cargo
     FROM INDIGO031.GeneralLedger.GeneralLedgerBalance AS B
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS C  ON B.IdMainAccount = C.Id
                                                                                       AND B.Year = '2020'
          INNER JOIN INDIGO031.GeneralLedger.MainAccountClasses AS cl ON C.IdAccountClass = cl.Id
                                                                                 AND C.LegalBookId = 1
                                                                                 AND cl.Code BETWEEN '4' AND '6'
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS C1 ON C.IdParent = C1.Id
                                                                           AND C1.LegalBookId = 1
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS C2 ON C1.IdParent = C2.Id
                                                                           AND C2.LegalBookId = 1
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS C3 ON C2.IdParent = C3.Id
                                                                           AND C3.LegalBookId = 1
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS C4 ON C3.IdParent = C4.Id
                                                                           AND C4.LegalBookId = 1
          INNER JOIN INDIGO031.Common.ThirdParty AS T  ON B.IdThirdParty = T.Id
          INNER JOIN INDIGO031.Payroll.CostCenter AS CC ON B.IdCostCenter = CC.Id
          LEFT OUTER JOIN
     (
         SELECT MAX(CONT.Id) AS Id, 
                E.ThirdPartyId AS Tercero, 
                PO.Name AS Cargo
         FROM INDIGO031.Payroll.Employee AS E
              JOIN INDIGO031.Payroll.Contract AS CONT ON CONT.EmployeeId = E.Id
              JOIN INDIGO031.Payroll.Position AS PO ON PO.Id = CONT.PositionId
         GROUP BY E.ThirdPartyId, 
                  PO.Name
     ) AS Car ON Car.Tercero = T.Id
     WHERE(CC.Code LIKE 'MET%')
     GROUP BY C.IdAccountLevel, 
              cl.Code, 
              cl.Name, 
              C3.IdAccountLevel, 
              C2.IdAccountLevel, 
              C1.IdAccountLevel, 
              C4.IdAccountLevel, 
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
              C4.Name, 
              C4.Number, 
              B.Month, 
              Car.Cargo;
