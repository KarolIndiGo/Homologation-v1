-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_VISTACRUCEANTICIPOSDETALLADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_VISTACRUCEANTICIPOSDETALLADO]
AS
           SELECT [Nit], 
       [Cliente], 
       [Factura], 
	   [FechaRadicado],
       [CodigoCruceAnticipo], 
       [FechaDocumento], 
       [CodigoAnticipo], 
	   [FechaAnticipo],
       [ValorPagado], 
       [Empresa], 
       [Regimen]
FROM
(
    SELECT cu.Nit, 
           cu.Name AS Cliente, 
           ar.InvoiceNumber AS Factura, 
		   RIC.ConfirmDate AS FechaRadicado,
           tr.Code AS CodigoCruceAnticipo,
           tr.DocumentDate AS FechaDocumento, 
           pa.Code AS CodigoAnticipo, 
		   pa.DocumentDate AS FechaAnticipo,
           trd.Value AS ValorPagado, 
           '043' AS Empresa,
           CASE cg.EntityType
               WHEN 1
               THEN 'EPS Contributivo'
               WHEN 2
               THEN 'EPS Subsidiado'
               WHEN 3
               THEN 'ET Vinculados Municipios'
               WHEN 4
               THEN 'ET Vinculados Departamentos'
               WHEN 5
               THEN 'ARL Riesgos Laborales'
               WHEN 6
               THEN 'MP Medicina Prepagada'
               WHEN 7
               THEN 'IPS Privada'
               WHEN 8
               THEN 'IPS Publica'
               WHEN 9
               THEN 'Regimen Especial'
               WHEN 10
               THEN 'Accidentes de transito'
               WHEN 11
               THEN 'Fosyga'
               WHEN 12
               THEN 'Otros'
               WHEN 13
               THEN 'Aseguradoras'
               WHEN 99
               THEN 'Particulares'
           END AS Regimen
    FROM Portfolio.PortfolioTransfer AS tr
         INNER JOIN Portfolio.PortfolioTransferDetail AS trd ON tr.Id = trd.PortfolioTrasferId
         INNER JOIN Portfolio.AccountReceivable AS ar ON trd.AccountReceivableId = ar.Id
         INNER JOIN Common.Customer AS cu ON ar.CustomerId = cu.Id
         INNER JOIN Portfolio.PortfolioAdvance AS pa ON tr.PortfolioAdvanceId = pa.Id
         LEFT JOIN
    (
		SELECT InvoiceNumber, CareGroupId
        FROM Billing.INVOICE
        UNION
        SELECT InvoiceNumber, CareGroupId
        FROM Billing.INVOICE
    ) AS IV ON ar.InvoiceNumber = IV.InvoiceNumber
         LEFT JOIN
    (
        SELECT Id, 
               Code, 
               Name, 
               EntityType
        FROM Contract.CareGroup
    ) AS CG ON IV.CareGroupId = CG.Id
	LEFT JOIN Portfolio.RadicateInvoiceD RID ON AR.InvoiceNumber=RID.InvoiceNumber AND RID.State='2'
	LEFT JOIN Portfolio.RadicateInvoiceC RIC ON RID.RadicateInvoiceCId=RIC.Id 
    WHERE(tr.STATUS = 2)
         --AND (ar.PortfolioStatus = 3)
		 AND tr.Observations<>'Traslado de anticipo modulo facturación'
		 AND tr.Observations<>'Traslado de anticipo modulo facturación'

) AS aut 
