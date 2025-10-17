-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Factura_Producto_Detalle_Reg_2022
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[FQ45_V_INN_Factura_Producto_Detalle_Reg_2022]
AS
SELECT        PRO.Code AS [Codigo del Producto], PRO.Name AS Producto, FAC.InvoiceNumber AS Factura, DOC.DocumentDate AS [Fecha del Documento], CLI.Nit AS [Nit del Cliente], CLI.Name AS Cliente, SUC.Name AS Sucursal, 
                         DETA.Quantity AS Cantidad, DETA.SalePrice AS [Valor Unitario], PER.Fullname AS [User Creacion], PER1.Fullname AS [User Confirmacion]
FROM            Billing.Invoice AS FAC INNER JOIN
                         Inventory.DocumentInvoiceProductSales AS DOC ON FAC.Id = DOC.InvoiceId INNER JOIN
                         Common.Customer AS CLI ON CLI.ThirdPartyId = FAC.ThirdPartyId LEFT OUTER JOIN
                         Payroll.BranchOffice AS SUC ON DOC.BranchOfficeId = SUC.Id LEFT OUTER JOIN
                         Common.City AS CIU ON SUC.CityId = CIU.Id INNER JOIN
                         Payroll.FunctionalUnit AS ALM ON DOC.FunctionalUnitId = ALM.Id INNER JOIN
                         Inventory.DocumentInvoiceProductSalesDetail AS DETA ON DETA.DocumentInvoiceProductSalesId = DOC.Id INNER JOIN
                         Inventory.InventoryProduct AS PRO ON DETA.ProductId = PRO.Id LEFT OUTER JOIN
                         Security.Person AS PER1 ON DOC.CreationUser = PER1.Identification LEFT OUTER JOIN
                         Security.Person AS PER ON DOC.ConfirmationUser = PER.Identification LEFT OUTER JOIN
                         Inventory.ATC AS atc ON atc.Id = PRO.ATCId LEFT OUTER JOIN
                         Inventory.ProductSubGroup AS sg ON sg.Id = PRO.ProductSubGroupId
WHERE        (FAC.Status = 1) AND (FAC.DocumentType = 7) AND year(FAC.InvoiceDate) = '2022'
