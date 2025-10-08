-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VISTACRUCEANTICIPOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VistaCruceAnticipos]
AS

SELECT 
    pa.Code AS NumeroAnticipo,
    ISNULL(cr.Code, CASE pa.OpeningBalance WHEN 1 THEN 'Saldo Inicial' END) AS DocumentoFuente,
    pa.DocumentDate AS FechaDocumento,
    tp.Nit AS Nit,
    tp.Name AS Cliente,
    pa.Value AS ValorAnticipo,
    pa.DebitValue AS NotasDB,
    pa.CreditValue AS NotasCR,
    pa.TransferValue AS ValorCruzado,
    pa.DistributionValue AS ValorDistribuido,
    pa.Balance AS Saldo
FROM [INDIGO035].[Portfolio].[PortfolioAdvance] AS pa
LEFT OUTER JOIN [INDIGO035].[Treasury].[CashReceipts] AS cr
    ON pa.CashReceiptId = cr.Id
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS tp
    ON pa.ThirdPartyId = tp.Id
   AND tp.Id IN (
        SELECT ThirdPartyId
        FROM [INDIGO035].[Common].[Customer]
    )
WHERE pa.Status = 2;