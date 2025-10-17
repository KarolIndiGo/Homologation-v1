-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_AF_Proveedores_Admon
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_AF_Proveedores_Admon]
AS
SELECT PRO.Code AS Nit, TER.DigitVerification AS DV, PRO.Name AS Cliente, PRO.TimeLimitDays AS [Dias de Plazo],
                      (SELECT CreationDate
                       FROM      Common.Supplier
                       WHERE   (Code = PRO.Code)) AS [Fecha de Registro VIE15], PRO.CreationDate AS [Fecha de Registro VIE45], SP.Code + ' - ' + SP.Name AS [Tipo de Proveedor], 
                  CASE PRO.Status WHEN 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS Estado
FROM     Common.Supplier AS PRO LEFT OUTER JOIN
                  Common.SupplierDetailType AS ST ON ST.SupplierId = PRO.Id LEFT OUTER JOIN
                  Common.SupplierType AS SP ON SP.Id = ST.SupplierTypeId LEFT OUTER JOIN
                  Common.SupplierBankAccount AS CUE ON PRO.Id = CUE.SupplierId LEFT OUTER JOIN
                  Payroll.Bank AS BAN ON CUE.BankId = BAN.Id LEFT OUTER JOIN
                  Common.Person AS PER ON PRO.Code = PER.IdentificationNumber LEFT OUTER JOIN
                  Common.Address AS DIR ON DIR.IdPerson = PER.Id LEFT OUTER JOIN
                  Common.City AS CIU ON PRO.IdCity = CIU.Id LEFT OUTER JOIN
                  Common.Email AS EMA ON EMA.IdPerson = PER.Id LEFT OUTER JOIN
                  Common.Phone AS TEL ON PER.Id = TEL.IdPerson LEFT OUTER JOIN
                  Common.ThirdParty AS TER ON TER.Nit = PRO.Code
