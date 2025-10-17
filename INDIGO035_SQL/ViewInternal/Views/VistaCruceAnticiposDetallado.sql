-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaCruceAnticiposDetallado
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VistaCruceAnticiposDetallado]
AS
SELECT        cu.Nit, cu.Name AS Cliente, ar.InvoiceNumber AS Factura, tr.Code AS CodigoCruceAnticipo, tr.DocumentDate AS FechaDocumento, pa.Code AS CodigoAnticipo,
                         trd.Value AS ValorPagado, '33' as Empresa
FROM            Portfolio.PortfolioTransfer AS tr INNER JOIN
                         Portfolio.PortfolioTransferDetail AS trd ON tr.Id = trd.PortfolioTrasferId INNER JOIN
                         Portfolio.AccountReceivable AS ar ON trd.AccountReceivableId = ar.Id INNER JOIN
                         Common.Customer AS cu ON ar.CustomerId = cu.Id INNER JOIN
                         Portfolio.PortfolioAdvance AS pa ON tr.PortfolioAdvanceId = pa.Id
WHERE        (tr.Status = 2) AND (ar.PortfolioStatus = 3)
union
SELECT        cu.Nit, cu.Name AS Cliente, ar.InvoiceNumber AS Factura, tr.Code AS CodigoCruceAnticipo, tr.DocumentDate AS FechaDocumento, pa.Code AS CodigoAnticipo,
                         trd.Value AS ValorPagado, '09' as Empresa
FROM            Portfolio.PortfolioTransfer AS tr INNER JOIN
                         Portfolio.PortfolioTransferDetail AS trd ON tr.Id = trd.PortfolioTrasferId INNER JOIN
                         Portfolio.AccountReceivable AS ar ON trd.AccountReceivableId = ar.Id INNER JOIN
                         Common.Customer AS cu ON ar.CustomerId = cu.Id INNER JOIN
                         Portfolio.PortfolioAdvance AS pa ON tr.PortfolioAdvanceId = pa.Id
						 WHERE        (tr.Status = 2) AND (ar.PortfolioStatus = 3)
