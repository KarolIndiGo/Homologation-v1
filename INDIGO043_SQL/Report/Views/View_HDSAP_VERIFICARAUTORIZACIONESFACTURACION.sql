-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_VERIFICARAUTORIZACIONESFACTURACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_VERIFICARAUTORIZACIONESFACTURACION]
AS
SELECT *
FROM
(

    /***** Servicios *****/

    SELECT ad.IPCODPACI AS Cedula, 
           pa.IPNOMCOMP AS Nombre, 
           ad.NUMINGRES AS Ingreso, 
           ce.Code AS CodigoServicio, 
           ce.Description AS NombreServicio, 
		   SOD.AuthorizationNumber Autorizacion,
           sod.ServiceDate AS FechaServicio, 
           sod.InvoicedQuantity AS Cantidad, 
           i.InvoiceNumber AS Factura, 
           i.InvoicedUser AS UsuarioFacturacion, 
           i.InvoiceDate AS FechaFactura,
           CASE i.STATUS
               WHEN '1'
               THEN 'Facturado'
               WHEN '2'
               THEN 'Anulado'
           END AS 'EstadoFactura'
    FROM Billing.Invoice AS i
         INNER JOIN Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id
         INNER JOIN dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber
         INNER JOIN dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI
         INNER JOIN Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId
         INNER JOIN Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId

    UNION ALL

    /********* MEDICAMENTOS *******/

    SELECT ad.IPCODPACI AS Cedula, 
           pa.IPNOMCOMP AS Nombre, 
           ad.NUMINGRES AS Ingreso, 
           p.Code AS CodigoServicio, 
           p.Name AS NombreServicio, 
		   SOD.AuthorizationNumber Autorizacion,
           sod.ServiceDate AS FechaServicio, 
           sod.InvoicedQuantity AS Cantidad, 
           i.InvoiceNumber AS Factura, 
           i.InvoicedUser AS UsuarioFacturacion, 
           i.InvoiceDate AS FechaFactura,
           CASE i.STATUS
               WHEN '1'
               THEN 'Facturado'
               WHEN '2'
               THEN 'Anulado'
           END AS 'EstadoFactura'
    FROM Billing.Invoice AS i
         INNER JOIN Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id
         INNER JOIN dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber
         INNER JOIN dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI
         INNER JOIN Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId
         INNER JOIN Inventory.InventoryProduct AS p ON p.Id = sod.ProductId
) AS datos
