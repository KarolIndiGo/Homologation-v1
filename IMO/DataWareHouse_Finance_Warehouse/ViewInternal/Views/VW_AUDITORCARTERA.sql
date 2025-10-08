-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_AUDITORCARTERA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[AuditorCartera]
AS

SELECT
    data.Documento,
    CAST(data.Fecha AS date) AS Fecha,
    data.Codigo,
    data.Cuenta,
    SUM(data.Debito) AS Debito,
    SUM(data.Credito) AS Credito,
    ISNULL(cont.Debito, 0) AS DebitoContabilidad,
    ISNULL(cont.Credito, 0) AS CreditoContabilidad
FROM (
    SELECT
        'Radicacion' AS Documento,
        rc.ConfirmDate AS Fecha,
        rc.RadicatedConsecutive AS Codigo,
        masr.Id AS IdCuenta,
        masr.Number AS Cuenta,
        0 AS Debito,
        rd.BalanceInvoice AS Credito
    FROM [INDIGO035].[Portfolio].[RadicateInvoiceC] AS rc
    INNER JOIN [INDIGO035].[Portfolio].[RadicateInvoiceD] AS rd
        ON rc.Id = rd.RadicateInvoiceCId
    INNER JOIN [INDIGO035].[Portfolio].[AccountReceivable] AS ar
        ON ar.InvoiceNumber = rd.InvoiceNumber
       AND ar.AccountReceivableType = 2
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS masr
        ON masr.Id = ar.AccountWithoutRadicateId
    WHERE rc.State = 2

    UNION ALL

    SELECT
        'Radicacion' AS Documento,
        rc.ConfirmDate AS Fecha,
        rc.RadicatedConsecutive AS Codigo,
        mare.Id AS IdCuenta,
        mare.Number AS Cuenta,
        rd.BalanceInvoice AS Debito,
        0 AS Credito
    FROM [INDIGO035].[Portfolio].[RadicateInvoiceC] AS rc
    INNER JOIN [INDIGO035].[Portfolio].[RadicateInvoiceD] AS rd
        ON rc.Id = rd.RadicateInvoiceCId
    INNER JOIN [INDIGO035].[Portfolio].[AccountReceivable] AS ar
        ON ar.InvoiceNumber = rd.InvoiceNumber
       AND ar.AccountReceivableType = 2
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS mare
        ON mare.Id = ar.AccountRadicateId
    WHERE rc.State = 2
) AS data
LEFT JOIN (
    SELECT
        jv.EntityCode AS Codigo,
        jvd.IdMainAccount AS IdCuenta,
        SUM(jvd.DebitValue) AS Debito,
        SUM(jvd.CreditValue) AS Credito
    FROM [INDIGO035].[GeneralLedger].[JournalVouchers] AS jv
    INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherDetails] AS jvd
        ON jv.Id = jvd.IdAccounting
    WHERE jv.EntityName = 'RadicateInvoiceC'
      AND jv.Status = 2
    GROUP BY jv.EntityCode, jvd.IdMainAccount
) AS cont
    ON data.IdCuenta = cont.IdCuenta
   AND data.Codigo = cont.Codigo
GROUP BY
    data.Documento, data.Fecha, data.Codigo, data.Cuenta, cont.Debito, cont.Credito

UNION ALL

SELECT
    dataNota.Documento,
    CAST(dataNota.Fecha AS date) AS Fecha,
    dataNota.Codigo,
    dataNota.Cuenta,
    SUM(dataNota.Debito) AS Debito,
    SUM(dataNota.Credito) AS Credito,
    ISNULL(contNota.Debito, 0) AS DebitoContabilidad,
    ISNULL(contNota.Credito, 0) AS CreditoContabilidad
FROM (
    SELECT
        'Notas' AS Documento,
        n.NoteDate AS Fecha,
        n.Code AS Codigo,
        ma.Id AS IdCuenta,
        ma.Number AS Cuenta,
        CASE n.Nature WHEN 1 THEN nara.AdjusmentValue ELSE 0 END AS Debito,
        CASE n.Nature WHEN 1 THEN 0 ELSE nara.AdjusmentValue END AS Credito
    FROM [INDIGO035].[Portfolio].[PortfolioNote] AS n
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioNoteAccountReceivableAdvance] AS nara
        ON n.Id = nara.PortfolioNoteId
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
        ON ma.Id = nara.MainAccountId
    WHERE n.Status = 2

    UNION ALL

    SELECT
        'Notas' AS Documento,
        n.NoteDate AS Fecha,
        n.Code AS Codigo,
        ma.Id AS IdCuenta,
        ma.Number AS Cuenta,
        CASE n.Nature WHEN 1 THEN nara.AdjusmentValue ELSE 0 END AS Debito,
        CASE n.Nature WHEN 1 THEN 0 ELSE nara.AdjusmentValue END AS Credito
    FROM [INDIGO035].[Portfolio].[PortfolioNote] AS n
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioNoteAccountReceivableAdvance] AS nara
        ON n.Id = nara.PortfolioNoteId
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioAdvance] AS pa
        ON pa.Id = nara.PortfolioAdvanceId
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
        ON ma.Id = pa.MainAccountId
    WHERE n.Status = 2

    UNION ALL

    SELECT
        'Notas' AS Documento,
        n.NoteDate AS Fecha,
        n.Code AS Codigo,
        ma.Id AS IdCuenta,
        ma.Number AS Cuenta,
        CASE nd.Nature WHEN 1 THEN nd.Value ELSE 0 END AS Debito,
        CASE nd.Nature WHEN 1 THEN 0 ELSE nd.Value END AS Credito
    FROM [INDIGO035].[Portfolio].[PortfolioNote] AS n
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioNoteDetail] AS nd
        ON n.Id = nd.PortfolioNoteId
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
        ON ma.Id = nd.MainAccountId
    WHERE n.Status = 2

    UNION ALL

    SELECT
        'Notas' AS Documento,
        n.NoteDate AS Fecha,
        n.Code AS Codigo,
        ma.Id AS IdCuenta,
        ma.Number AS Cuenta,
        nd.Value AS Debito,
        0 AS Credito
    FROM [INDIGO035].[Portfolio].[PortfolioNote] AS n
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioNoteDistribution] AS nd
        ON n.Id = nd.PortfolioNoteId
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
        ON ma.Id = nd.MainAccountId
    WHERE n.Status = 2

    UNION ALL

    SELECT
        'Notas' AS Documento,
        n.NoteDate AS Fecha,
        n.Code AS Codigo,
        ma.Id AS IdCuenta,
        ma.Number AS Cuenta,
        0 AS Debito,
        (SELECT SUM(Value)
         FROM [INDIGO035].[Portfolio].[PortfolioNoteDistribution]
         WHERE PortfolioNoteId = n.Id) AS Credito
    FROM [INDIGO035].[Portfolio].[PortfolioNote] AS n
    INNER JOIN [INDIGO035].[Portfolio].[PortfolioAdvance] AS pa
        ON pa.Id = n.PortfolioAdvanceId
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
        ON ma.Id = pa.MainAccountId
    WHERE n.Status = 2
      AND n.NoteType = 4
) AS dataNota
LEFT JOIN (
    SELECT
        jv.EntityCode AS Codigo,
        jvd.IdMainAccount AS IdCuenta,
        SUM(jvd.DebitValue) AS Debito,
        SUM(jvd.CreditValue) AS Credito
    FROM [INDIGO035].[GeneralLedger].[JournalVouchers] AS jv
    INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherDetails] AS jvd
        ON jv.Id = jvd.IdAccounting
    WHERE jv.EntityName = 'PortfolioNote'
      AND jv.Status = 2
    GROUP BY jv.EntityCode, jvd.IdMainAccount
) AS contNota
    ON contNota.IdCuenta = dataNota.IdCuenta
   AND contNota.Codigo  = dataNota.Codigo
GROUP BY
    dataNota.Documento, dataNota.Fecha, dataNota.Codigo, dataNota.IdCuenta, dataNota.Cuenta, contNota.Debito, contNota.Credito;