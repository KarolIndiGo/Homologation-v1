-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VISTACRUCEANTICIPOSDETALLADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VistaCruceAnticiposDetallado]
AS

SELECT
    cu.Nit,
    cu.Name AS Cliente,
    ar.InvoiceNumber AS Factura,
    tr.Code AS CodigoCruceAnticipo,
    tr.DocumentDate AS FechaDocumento,
    pa.Code AS CodigoAnticipo,
    trd.Value AS ValorPagado,
    '33' AS Empresa
FROM [INDIGO035].[Portfolio].[PortfolioTransfer] AS tr
INNER JOIN [INDIGO035].[Portfolio].[PortfolioTransferDetail] AS trd
    ON tr.Id = trd.PortfolioTrasferId
INNER JOIN [INDIGO035].[Portfolio].[AccountReceivable] AS ar
    ON trd.AccountReceivableId = ar.Id
INNER JOIN [INDIGO035].[Common].[Customer] AS cu
    ON ar.CustomerId = cu.Id
INNER JOIN [INDIGO035].[Portfolio].[PortfolioAdvance] AS pa
    ON tr.PortfolioAdvanceId = pa.Id
WHERE (tr.Status = 2) AND (ar.PortfolioStatus = 3)

UNION

SELECT
    cu.Nit,
    cu.Name AS Cliente,
    ar.InvoiceNumber AS Factura,
    tr.Code AS CodigoCruceAnticipo,
    tr.DocumentDate AS FechaDocumento,
    pa.Code AS CodigoAnticipo,
    trd.Value AS ValorPagado,
    '09' AS Empresa
FROM [INDIGO035].[Portfolio].[PortfolioTransfer] AS tr
INNER JOIN [INDIGO035].[Portfolio].[PortfolioTransferDetail] AS trd
    ON tr.Id = trd.PortfolioTrasferId
INNER JOIN [INDIGO035].[Portfolio].[AccountReceivable] AS ar
    ON trd.AccountReceivableId = ar.Id
INNER JOIN [INDIGO035].[Common].[Customer] AS cu
    ON ar.CustomerId = cu.Id
INNER JOIN [INDIGO035].[Portfolio].[PortfolioAdvance] AS pa
    ON tr.PortfolioAdvanceId = pa.Id
WHERE (tr.Status = 2) AND (ar.PortfolioStatus = 3);