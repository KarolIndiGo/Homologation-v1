-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Common_Proveedores
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Common_Proveedores]
AS
SELECT DISTINCT 
           e.Code AS [Código Proveedor], t.Nit, t.DigitVerification AS [Digito Verificacion], t.Name AS [Nombre Tercero], tp.Code + ' - ' + tp.Name AS [Tipo Proveedor], c.Number AS [Cuenta contable], l.Code + ' - ' + l.Name AS [Línea Distribución], c.Name AS [Descripción Cuenta Contable], cb.Number AS [Nro Cuenta], 
           CASE cb.Type WHEN '1' THEN 'Ahorro' WHEN '2' THEN 'Corriente' END AS [Tipo Cuenta], b.Code AS [Código Banco], b.Name AS Banco, dp.Fullname AS [Usuario creación], m.Email AS [E-mail], tel.Phone AS Teléfono, CI.Name AS Ciudad, Dir.Addresss AS Dirección
FROM   Common.Supplier AS e  INNER JOIN
           Common.SuppliersDistributionLines AS dl  ON dl.IdSupplier = e.Id INNER JOIN
           Common.DistributionLines AS l  ON l.Id = dl.IdDistributionLine INNER JOIN
           Common.ThirdParty AS t  ON t.Id = e.IdThirdParty INNER JOIN
           GeneralLedger.MainAccounts AS c  ON c.Id = l.IdMainAccount LEFT OUTER JOIN
           Common.SupplierBankAccount AS cb  ON cb.SupplierId = e.Id LEFT OUTER JOIN
           Payroll.Bank AS b  ON b.Id = cb.BankId LEFT OUTER JOIN
          Security.[User] AS u  ON u.UserCode = e.CreationUser LEFT OUTER JOIN
          Security.Person AS dp  ON dp.Id = u.IdPerson LEFT OUTER JOIN
           Common.Email AS m  ON m.IdPerson = t.PersonId LEFT OUTER JOIN
           Common.SupplierDetailType AS sdt  ON sdt.SupplierId = e.Id LEFT OUTER JOIN
           Common.SupplierType AS tp ON tp.Id = sdt.SupplierTypeId LEFT OUTER JOIN
           Common.Phone AS tel ON tel.IdPerson = t.PersonId LEFT OUTER JOIN
           Common.City AS CI  ON e.IdCity = CI.Id LEFT OUTER JOIN
           Common.Address AS Dir  ON Dir.IdPerson = t.PersonId
WHERE (e.Status = '1') and cb.State=1

