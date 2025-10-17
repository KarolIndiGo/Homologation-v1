-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Factura_Producto_Detalle_2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[FQ45_V_INN_Factura_Producto_Detalle_2024]    Script Date: 25/06/2025 11:01:13 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE VIEW [ViewInternal].[FQ45_V_INN_Factura_Producto_Detalle_2024]
AS
SELECT DOC.Code
          AS Documento,
       FAC.InvoiceNumber
          AS Factura,
       DOC.DocumentDate
          AS [Fecha del Documento],
       CLI.Nit
          AS [Nit del Cliente],
       CLI.Name
          AS Cliente,
       SUC.Name
          AS Sucursal,
       CIU.Name
          AS Ciudad,
       DOC.Description
          AS Descripcion,
       ALM.Code + ' - ' + ALM.Name
          AS [Centro de Costo],
          (select name from Inventory.Warehouse where Id=DOC.WarehouseId) AS Almacen ,
       PRO.Code
          AS [Codigo del Producto],
       PRO.Name
          AS Producto,
		  atc.code as CodMedicamento,
		  atc.name as Medicamento,
		   sg.code+'-'+sg.name as [Subgrupo],
       CASE PRO.IVAId WHEN 1 THEN 'NO' WHEN 2 THEN 'SI' WHEN 3 THEN 'SI' END
          AS Iva,
       DETA.Quantity
          AS Cantidad,
       DETA.SalePrice
          AS [Valor Unitario],
       DOC.Value
          AS Subtotal,
       DOC.ValueTax
          AS [IVA FACTURA],
       DOC.Value + DOC.ValueTax
          AS [Total sin Retenciones],
       FAC.TotalInvoice
          AS [Valor Facturado],
       PER.Fullname
          AS [User Creacion],
       PER1.Fullname
          AS [User Confirmacion],
		  pg.name as Grupo,
		  costo.AverageCost as CostoProducto,
		  (DETA.Quantity*DETA.SalePrice) as VentaTotal,
		   costo.AverageCost *  DETA.Quantity as CostoProductoTotal,
		   (DETA.Quantity*DETA.SalePrice)-(costo.AverageCost *  DETA.Quantity) as VrMargen,
		   (((DETA.Quantity*DETA.SalePrice)-(costo.AverageCost *  DETA.Quantity))/ (DETA.Quantity*DETA.SalePrice))as [%Margen],
		   CASE
		   WHEN FAC.Status = 1 THEN 'Facturado'
		   WHEN FAC.Status = 2 THEN 'Anulado'
		   END AS EstadoFactura, --Se agrega campo para identificador el estado de la factura
		   fac.cufe,
		   CASE
		   WHEN dia.Status = 3 THEN 'Validada '
		   WHEN dia.Status = 4 THEN 'Invalida ' 
		   END AS [Estado Dian]
FROM Billing.Invoice AS FAC
     INNER JOIN Inventory.DocumentInvoiceProductSales AS DOC
        ON FAC.Id = DOC.InvoiceId
     INNER JOIN Common.Customer AS CLI
        ON CLI.ThirdPartyId = FAC.ThirdPartyId
     LEFT OUTER JOIN Payroll.BranchOffice AS SUC
        ON DOC.BranchOfficeId = SUC.Id
     LEFT OUTER JOIN Common.City AS CIU ON SUC.CityId = CIU.Id
     INNER JOIN Payroll.FunctionalUnit AS ALM
        ON DOC.FunctionalUnitId = ALM.Id
     INNER JOIN Inventory.DocumentInvoiceProductSalesDetail AS DETA
        ON DETA.DocumentInvoiceProductSalesId = DOC.Id
     INNER JOIN Inventory.InventoryProduct AS PRO
        ON DETA.ProductId = PRO.Id
     LEFT JOIN [Security].[Person] PER1
        ON DOC.CreationUser = PER1.Identification
     LEFT JOIN [Security].[Person] PER
        ON DOC.ConfirmationUser = PER.Identification
		left outer join Inventory.ATC as atc on atc.id=pro.atcid
		LEFT OUTER JOIN
                         Inventory.ProductSubGroup AS sg ON sg.Id = pro.ProductSubGroupId
		LEFT OUTER JOIN
                         Inventory.ProductGroup AS pg ON pg.Id = pro.ProductGroupId
      LEFT OUTER JOIN  Billing.ElectronicDocument AS dia
	    ON dia.CUFE = FAC.CUFE 
		left outer join 
		(SELECT ProductId, AverageCost,EntityCode
			FROM Inventory.Kardex
				where EntityName='DocumentInvoiceProductSales') as costo on costo.EntityCode=doc.code and costo.ProductId=pro.id
WHERE  (FAC.DocumentType = 7) and  year(DOC.DocumentDate) ='2024' and  (month(DOC.DocumentDate) between '1' and '12')  --(FAC.Status = 1) Se quita del filtro el estado Facturado y se dejan los 2 estados (Facturado, Anulado)
