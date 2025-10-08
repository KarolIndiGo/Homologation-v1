-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_FACTURACIONCARTERA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FacturacionCartera]
AS

SELECT 
    ar.InvoiceNumber AS Factura,
    ar.AccountReceivableDate AS FechaFactura,
    t.Nit AS NitEntidad,
    t.Name AS Entidad,
    c.Code AS Contracto,
    cg.Code AS CodigoGrupoAtencion,
    cg.Name AS GrupoAtencion,
    ar.PortfolioStatus AS EstadoCartera,
    ar.OpeningBalance AS SaldoInicial,
    ar.Value AS Valor,
    ar.Balance AS Saldo
FROM [INDIGO035].[Portfolio].[AccountReceivable] AS ar
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS t
    ON ar.ThirdPartyId = t.Id
LEFT JOIN [INDIGO035].[Billing].[Invoice] AS i
    ON i.Id = ar.InvoiceId
LEFT JOIN [INDIGO035].[Contract].[CareGroup] AS cg
    ON cg.Id = i.CareGroupId
LEFT JOIN [INDIGO035].[Contract].[Contract] AS c
    ON cg.ContractId = c.Id
WHERE ar.AccountReceivableType = 2
  AND ar.Balance > 0
  AND ar.Status = 2;