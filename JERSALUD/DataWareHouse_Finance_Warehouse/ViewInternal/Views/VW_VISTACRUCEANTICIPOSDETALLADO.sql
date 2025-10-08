-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VISTACRUCEANTICIPOSDETALLADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0



--SELECT COUNT(*) [ViewInternal].[VW_VISTACRUCEANTICIPOSDETALLADO]
CREATE VIEW [ViewInternal].[VW_VISTACRUCEANTICIPOSDETALLADO] AS
SELECT        cu.Nit, cu.Name AS Cliente, ar.InvoiceNumber AS Factura, tr.Code AS CodigoCruceAnticipo, tr.DocumentDate AS FechaDocumento, pa.Code AS CodigoAnticipo,
                         trd.Value AS ValorPagado, '33' as Empresa
FROM            INDIGO031.Portfolio.PortfolioTransfer AS tr INNER JOIN
                         INDIGO031.Portfolio.PortfolioTransferDetail AS trd ON tr.Id = trd.PortfolioTrasferId INNER JOIN
                         INDIGO031.Portfolio.AccountReceivable AS ar ON trd.AccountReceivableId = ar.Id INNER JOIN
                         INDIGO031.Common.Customer AS cu ON ar.CustomerId = cu.Id INNER JOIN
                         INDIGO031.Portfolio.PortfolioAdvance AS pa ON tr.PortfolioAdvanceId = pa.Id
WHERE        (tr.Status = 2) AND (ar.PortfolioStatus = 3)
union
SELECT        cu.Nit, cu.Name AS Cliente, ar.InvoiceNumber AS Factura, tr.Code AS CodigoCruceAnticipo, tr.DocumentDate AS FechaDocumento, pa.Code AS CodigoAnticipo,
                         trd.Value AS ValorPagado, '09' as Empresa
FROM            INDIGO031.Portfolio.PortfolioTransfer AS tr INNER JOIN
                         INDIGO031.Portfolio.PortfolioTransferDetail AS trd ON tr.Id = trd.PortfolioTrasferId INNER JOIN
                         INDIGO031.Portfolio.AccountReceivable AS ar ON trd.AccountReceivableId = ar.Id INNER JOIN
                         INDIGO031.Common.Customer AS cu ON ar.CustomerId = cu.Id INNER JOIN
                         INDIGO031.Portfolio.PortfolioAdvance AS pa ON tr.PortfolioAdvanceId = pa.Id
						 WHERE        (tr.Status = 2) AND (ar.PortfolioStatus = 3)
