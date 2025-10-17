/****** Object:  View [ViewInternal].[VistaCruceAnticiposDetallado]    Script Date: 16/10/2025 6:22:19 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



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
GO


