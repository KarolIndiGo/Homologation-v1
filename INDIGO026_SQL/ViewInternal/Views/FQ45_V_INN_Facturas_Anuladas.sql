-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Facturas_Anuladas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_Facturas_Anuladas]
AS
SELECT DOC.Code AS CodigoDocumento,
       FAC.InvoiceNumber AS [N Factura],
       FAC.InvoiceDate AS [Fecha Factura],
       CLI.Nit AS Nit,
       CLI.Name AS Cliente,
       SUC.Name AS Sucursal,
       DOC.ConfirmationUser AS Confirmacion,
       PER.Fullname AS [Usuario Confirmacion],
       FAC.DescriptionReversal AS [Razon Anulacion],
       DOC.AnnulmentDate AS [Fecha Anulacion],
       DOC.AnnulmentUser AS [Anulacion],
       PER1.Fullname AS [Usuario Anulacion]
FROM Billing.Invoice FAC
     RIGHT JOIN Inventory.DocumentInvoiceProductSales DOC
        ON FAC.Id = DOC.InvoiceId
     INNER JOIN Common.ThirdParty CLI ON CLI.Id = DOC.ThirdPartyId
     LEFT JOIN Payroll.BranchOffice SUC ON DOC.BranchOfficeId = SUC.Id
     LEFT JOIN [Security].[Person] PER
        ON DOC.ConfirmationUser = PER.Identification
     LEFT JOIN [Security].[Person] PER1
        ON DOC.AnnulmentUser = PER1.Identification
WHERE DOC.Status = '3' AND YEAR(FAC.InvoiceDate)>=2022
