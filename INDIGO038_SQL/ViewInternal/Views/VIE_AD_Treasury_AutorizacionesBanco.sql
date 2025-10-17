-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Treasury_AutorizacionesBanco
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Treasury_AutorizacionesBanco]
AS
SELECT cb.Code AS Código, b.Code + '-' + b.Name AS Banco, cb.Number AS Número, u.UserCode AS [Codigo Usuario], p.Fullname AS [Usuario Autorizado]
FROM     Treasury.EntityBankAccounts AS cb INNER JOIN
                  Treasury.EntityBankAccountUser AS ub  ON ub.IdEntityBankAccount = cb.Id INNER JOIN
                  Security.[User] AS u  ON u.UserCode = ub.CodUser INNER JOIN
                  Security.Person AS p  ON p.Id = u.IdPerson INNER JOIN
                  Payroll.Bank AS b  ON b.Id = cb.IdBank INNER JOIN
                  Common.City AS c  ON c.Id = cb.IdCity
