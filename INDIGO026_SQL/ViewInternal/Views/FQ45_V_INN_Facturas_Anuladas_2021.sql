-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Facturas_Anuladas_2021
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_Facturas_Anuladas_2021]
AS
SELECT        DOC.Code AS CodigoDocumento, FAC.InvoiceNumber AS [N Factura], FAC.InvoiceDate AS [Fecha Factura], CLI.Nit, CLI.Name AS Cliente, SUC.Name AS Sucursal, DOC.ConfirmationUser AS Confirmacion, 
                         PER.Fullname AS [Usuario Confirmacion], FAC.DescriptionReversal AS [Razon Anulacion], DOC.AnnulmentDate AS [Fecha Anulacion], DOC.AnnulmentUser AS Anulacion, PER1.Fullname AS [Usuario Anulacion]
FROM            Billing.Invoice AS FAC RIGHT OUTER JOIN
                         Inventory.DocumentInvoiceProductSales AS DOC ON FAC.Id = DOC.InvoiceId INNER JOIN
                         Common.ThirdParty AS CLI ON CLI.Id = DOC.ThirdPartyId LEFT OUTER JOIN
                         Payroll.BranchOffice AS SUC ON DOC.BranchOfficeId = SUC.Id LEFT OUTER JOIN
                         Security.Person AS PER ON DOC.ConfirmationUser = PER.Identification LEFT OUTER JOIN
                         Security.Person AS PER1 ON DOC.AnnulmentUser = PER1.Identification
WHERE        (DOC.Status = 3) AND (FAC.InvoiceDate > CONVERT(DATETIME, '2020-12-31 23:59:59', 102))
