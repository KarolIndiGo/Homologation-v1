-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Treasury_AutorizacionesCaja
-- Extracted by Fabric SQL Extractor SPN v3.9.0

 CREATE VIEW [ViewInternal].[VIE_AD_Treasury_AutorizacionesCaja]
AS
SELECT C.Code AS [Còd Caja], C.Name AS [Descripciòn Caja], CASE C.Type WHEN '1' THEN 'Menor ' WHEN '2' THEN 'Mayor' END AS [Tipo Caja], p.Identification, U.UserCode AS [Còd Usuario], p.Fullname AS Usuario
FROM   Treasury.CashRegisterUser AS UA  INNER JOIN
          Treasury.CashRegisters AS C  ON C.Id = UA.IdCashRegister INNER JOIN
          Security.[User] AS U ON U.Id = UA.IdUser INNER JOIN
           Security.Person AS p ON p.Id = U.IdPerson
