-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VCARTERARADICATAXPACIENTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VCarteraRadicataXPaciente]
AS

SELECT 
    rc.RadicatedConsecutive AS Radicado,
    tp.Nit AS Nit,
    tp.Name AS Entidad,
    ar.InvoiceNumber AS Factura,
    CASE paci.IPTIPODOC
        WHEN '1' THEN 'Cédula de Ciudadanía'
        WHEN '2' THEN 'Cédula de Extranjería'
        WHEN '3' THEN 'Tarjeta de Identidad'
        WHEN '4' THEN 'Registro Civil'
        WHEN '5' THEN 'Pasaporte'
        WHEN '6' THEN 'Adulto Sin Identificación'
        WHEN '7' THEN 'Menor Sin Identificación'
        ELSE ''
    END AS TipoIdentificacionPaciente,
    rd.PatientCode AS IdentificacionPaciente,
    rd.PatientName AS NombrePaciente,
    rd.IngressDate AS FechaIngreso,
    CAST(rd.InvoiceDate AS date) AS FechaFactura,
    rc.ConfirmDateSystem AS FechaRadicado,
    ISNULL(FUR.NUMSOA,'') AS NumeroPoliza,
    CAST(rd.InvoiceValueEntity + rd.InvoiceValuePacient AS decimal(18,0)) AS ValorBrutoFactura,
    CAST(rd.InvoiceValuePacient AS decimal(18,0)) AS ValorCuotaRecuperacion,
    CAST(ISNULL(rd.CreditNoteValue,0) AS decimal(18,0)) AS ValorNotaCredito,
    CAST(ISNULL(rd.DebitNoteValue,0) AS decimal(18,0)) AS ValorNotaDebito,
    CAST(rd.BalanceInvoice AS decimal(18,0)) AS ValorNetoFactura,
    ISNULL(notas.Value,0) AS TotalNotas,
    ISNULL(pagos.Valor,0) AS TotalPagos,
    ar.Balance AS SaldoActual
FROM [INDIGO035].[Portfolio].[AccountReceivable] AS ar
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS tp
    ON ar.ThirdPartyId = tp.Id
INNER JOIN [INDIGO035].[Portfolio].[RadicateInvoiceD] AS rd
    ON rd.InvoiceNumber = ar.InvoiceNumber
   AND rd.State = 2
INNER JOIN [INDIGO035].[Portfolio].[RadicateInvoiceC] AS rc
    ON rc.Id = rd.RadicateInvoiceCId
   AND rc.State = 2
LEFT JOIN (
    SELECT ar.InvoiceNumber, SUM(ptd.Value) AS Valor
    FROM [INDIGO035].[Portfolio].[PortfolioTransfer] AS pt
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioTransferDetail] AS ptd
        ON pt.Id = ptd.PortfolioTrasferId
    INNER JOIN [INDIGO035].[Portfolio].[AccountReceivable] AS ar
        ON ar.Id = ptd.AccountReceivableId
    WHERE pt.Status = 2
      AND ar.AccountReceivableType = 2
    GROUP BY ar.InvoiceNumber
) AS pagos
    ON pagos.InvoiceNumber = ar.InvoiceNumber
LEFT JOIN (
    SELECT ar.InvoiceNumber, SUM(pnd.AdjusmentValue) AS Value
    FROM [INDIGO035].[Portfolio].[PortfolioNote] AS pn
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioNoteAccountReceivableAdvance] AS pnd
        ON pnd.PortfolioNoteId = pn.Id
    INNER JOIN [INDIGO035].[Portfolio].[AccountReceivable] AS ar
        ON ar.Id = pnd.AccountReceivableId
    WHERE ar.AccountReceivableType = 2
    GROUP BY ar.InvoiceNumber
) AS notas
    ON notas.InvoiceNumber = ar.InvoiceNumber
LEFT JOIN [INDIGO035].[dbo].[INPACIENT] AS paci
    ON paci.IPCODPACI = rd.PatientCode
LEFT JOIN [INDIGO035].[dbo].[ADFURIPSU] AS FUR
    ON FUR.NUMINGRES = rd.IngressNumber
WHERE ar.AccountReceivableType = 2;