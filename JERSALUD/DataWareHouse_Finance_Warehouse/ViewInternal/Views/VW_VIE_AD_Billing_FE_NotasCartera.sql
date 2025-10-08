-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_Billing_FE_NotasCartera
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_Billing_FE_NotasCartera AS

SELECT DISTINCT
    TOP (100) PERCENT
    U.UnitName AS [Unidad Operativa],
    pn.Code AS NotaCartera,
    pn.NoteDate AS [Fecha Nota],
    C.Nit,
    C.Name AS Cliente,
    CASE pn.Nature
        WHEN 1 THEN 'Debito'
        WHEN 2 THEN 'Credito'
    END AS Naturaleza,
    pn.Observations AS ObservaciónCartera,
    pnc.Name AS ConceptoNota,
    ma.Number + '-' + ma.Name AS CuentaContable,
    bn.Observations AS ObservacionesFactElectronica,
    bnd.InvoiceNumber AS Factura,
    bnd.DocumentDate AS FechaFactura,
    bnd.AdjusmentValue AS ValorAjuste,
    bn.Code AS Consecutivo,
    CASE bnd.ConceptId
        WHEN 1 THEN 'Devolución o no aceptación de partes del servicio'
        WHEN 2 THEN 'Anulación de factura electrónica'
        WHEN 3 THEN 'Rebaja total aplicada'
        WHEN 4 THEN 'Descuento total aplicado'
        WHEN 5 THEN 'Rescisión: nulidad por falta de requisitos'
        WHEN 6 THEN 'Otros'
    END AS Concepto_FactElectronica,
    CASE ed.Status
        WHEN 0 THEN 'Invalida'
        WHEN 1 THEN 'Registrada'
        WHEN 2 THEN 'Enviada y Recibida'
        WHEN 3 THEN 'Factura Validada'
        WHEN 4 THEN 'Validacion Fallida'
        WHEN 99 THEN 'Pendiente - Proc. Validacion'
        WHEN 88 THEN 'Pendiente - Proc. Envio'
        WHEN 77 THEN 'No Procesa - Dif. Version'
    END AS [Estado Nota],
    ed.FilePath AS Ruta,
    ed.ShippingDate AS FechaEnvio,
    CASE edd.Status
        WHEN 0 THEN 'Fallido'
        WHEN 1 THEN 'Exitoso'
        ELSE ''
    END AS [Estado Envio],
    edd.Comentarios AS Comentarios,
    CASE edd.Destination
        WHEN 0 THEN 'Validación Previa a generacion XML'
        WHEN 1 THEN 'Envio Documento Electronico '
        WHEN 2 THEN 'Validación Documento XML'
    END AS Destino
FROM INDIGO031.Portfolio.PortfolioNote pn
LEFT OUTER JOIN INDIGO031.Billing.BillingNote bn ON bn.EntityId = pn.Id
LEFT OUTER JOIN INDIGO031.Billing.BillingNoteDetail bnd ON bnd.BillingNoteId = bn.Id
LEFT OUTER JOIN INDIGO031.Billing.ElectronicDocument ed ON ed.EntityId = bn.Id AND ed.EntityName = 'BillingNote'
LEFT OUTER JOIN (
    SELECT
        a.ElectronicDocumentId,
        a.Comments AS Comentarios,
        a.Status,
        a.Id,
        a.Destination,
        a.CreationDate
    FROM INDIGO031.Billing.ElectronicDocumentDetail AS a
    INNER JOIN (
        SELECT
            ElectronicDocumentId,
            MAX(Id) AS max_Id
        FROM INDIGO031.Billing.ElectronicDocumentDetail AS t
        GROUP BY t.ElectronicDocumentId
    ) AS r ON r.ElectronicDocumentId = a.ElectronicDocumentId AND a.Id = r.max_Id
) AS edd ON edd.ElectronicDocumentId = ed.Id
LEFT OUTER JOIN INDIGO031.Common.OperatingUnit AS U ON U.Id = pn.OperatingUnitId
LEFT OUTER JOIN INDIGO031.Common.Customer C ON C.Id = pn.CustomerId
LEFT OUTER JOIN INDIGO031.Portfolio.PortfolioNoteDetail pnd ON pnd.PortfolioNoteId = pn.Id
LEFT OUTER JOIN INDIGO031.Portfolio.PortfolioNoteConcept pnc ON pnc.Id = pnd.PortfolioNoteConceptId
LEFT OUTER JOIN INDIGO031.GeneralLedger.MainAccounts ma ON ma.Id = pnd.MainAccountId
WHERE pn.NoteDate >= '01-01-2020'

UNION ALL

SELECT DISTINCT
    TOP (100) PERCENT
    U.UnitName AS [Unidad Operativa],
    '' AS NotaCartera,
    bn.NoteDate AS [Fecha Nota],
    C.Nit,
    C.Name AS Cliente,
    CASE bn.Nature
        WHEN 1 THEN 'Debito'
        WHEN 2 THEN 'Credito'
    END AS Naturaleza,
    '' AS ObservaciónCartera,
    '' AS ConceptoNota,
    '' AS CuentaContable,
    bn.Observations AS ObservacionesFactElectronica,
    bnd.InvoiceNumber AS Factura,
    bnd.DocumentDate AS FechaFactura,
    bnd.AdjusmentValue AS ValorAjuste,
    bn.Code AS Consecutivo,
    CASE bnd.ConceptId
        WHEN 1 THEN 'Devolución o no aceptación de partes del servicio'
        WHEN 2 THEN 'Anulación de factura electrónica'
        WHEN 3 THEN 'Rebaja total aplicada'
        WHEN 4 THEN 'Descuento total aplicado'
        WHEN 5 THEN 'Rescisión: nulidad por falta de requisitos'
        WHEN 6 THEN 'Otros'
    END AS Concepto_FactElectronica,
    CASE ed.Status
        WHEN 0 THEN 'Invalida'
        WHEN 1 THEN 'Registrada'
        WHEN 2 THEN 'Enviada y Recibida'
        WHEN 3 THEN 'Factura Validada'
        WHEN 4 THEN 'Validacion Fallida'
        WHEN 99 THEN 'Pendiente - Proc. Validacion'
        WHEN 88 THEN 'Pendiente - Proc. Envio'
        WHEN 77 THEN 'No Procesa - Dif. Version'
    END AS [Estado Nota],
    ed.FilePath AS Ruta,
    ed.ShippingDate AS FechaEnvio,
    CASE edd.Status
        WHEN 0 THEN 'Fallido'
        WHEN 1 THEN 'Exitoso'
        ELSE ''
    END AS [Estado Envio],
    edd.Comentarios AS Comentarios,
    CASE edd.Destination
        WHEN 0 THEN 'Validación Previa a generacion XML'
        WHEN 1 THEN 'Envio Documento Electronico '
        WHEN 2 THEN 'Validación Documento XML'
    END AS Destino
FROM INDIGO031.Billing.BillingNote bn
LEFT OUTER JOIN INDIGO031.Billing.BillingNoteDetail bnd ON bnd.BillingNoteId = bn.Id
LEFT OUTER JOIN INDIGO031.Billing.ElectronicDocument ed ON ed.EntityId = bn.Id AND ed.EntityName = 'BillingNote'
LEFT OUTER JOIN (
    SELECT
        a.ElectronicDocumentId,
        a.Comments AS Comentarios,
        a.Status,
        a.Id,
        a.Destination,
        a.CreationDate
    FROM INDIGO031.Billing.ElectronicDocumentDetail AS a
    INNER JOIN (
        SELECT
            ElectronicDocumentId,
            MAX(Id) AS max_Id
        FROM INDIGO031.Billing.ElectronicDocumentDetail AS t
        GROUP BY t.ElectronicDocumentId
    ) AS r ON r.ElectronicDocumentId = a.ElectronicDocumentId AND a.Id = r.max_Id
) AS edd ON edd.ElectronicDocumentId = ed.Id
LEFT OUTER JOIN INDIGO031.Common.OperatingUnit AS U ON U.Id = bn.OperatingUnitId
LEFT OUTER JOIN INDIGO031.Common.ThirdParty AS C ON C.Id = bn.CustomerPartyId
WHERE bn.NoteDate >= '01-01-2020' AND bn.EntityName = 'Invoice'
