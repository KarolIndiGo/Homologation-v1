-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Factura_Producto_Detalle_2021_2s
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*and fac.InvoiceNumber='FQE39716'*/
CREATE VIEW [ViewInternal].[FQ45_V_INN_Factura_Producto_Detalle_2021_2s]
AS
SELECT        DOC.Code AS Documento, FAC.InvoiceNumber AS Factura, DOC.DocumentDate AS [Fecha del Documento], CLI.Nit AS [Nit del Cliente], CLI.Name AS Cliente, SUC.Name AS Sucursal, CIU.Name AS Ciudad, 
                         DOC.Description AS Descripcion, ALM.Code + ' - ' + ALM.Name AS [Centro de Costo],
                             (SELECT        Name
                               FROM            Inventory.Warehouse
                               WHERE        (Id = DOC.WarehouseId)) AS Almacen, PRO.Code AS [Codigo del Producto], PRO.Name AS Producto, atc.Code AS CodMedicamento, atc.Name AS Medicamento, sg.Code + '-' + sg.Name AS Subgrupo, 
                         CASE PRO.IVAId WHEN 1 THEN 'NO' WHEN 2 THEN 'SI' WHEN 3 THEN 'SI' END AS Iva, DETA.Quantity AS Cantidad, DETA.SalePrice AS [Valor Unitario], DOC.Value AS Subtotal, DOC.ValueTax AS [IVA FACTURA], 
                         DOC.Value + DOC.ValueTax AS [Total sin Retenciones], FAC.TotalInvoice AS [Valor Facturado], PER.Fullname AS [User Creacion], PER1.Fullname AS [User Confirmacion], PRO.ProductCost AS CostoProducto
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
WHERE        (FAC.Status = 1) AND (FAC.DocumentType = 7) AND (DOC.DocumentDate > '20211231')
