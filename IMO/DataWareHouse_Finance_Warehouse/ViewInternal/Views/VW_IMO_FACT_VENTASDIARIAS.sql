-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_FACT_VENTASDIARIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_FACT_VentasDiarias
AS

SELECT
    'Evento' AS Tipo,
    cc.Code,
    cc.Name AS [Centro Costo],
    tcoco.Code AS [Tipo Comprobante],
    tcoco.Name AS NombreComprobante,
    coco.EntityCode AS CodDocumento,
    CASE coco.EntityName
        WHEN 'Invoice' THEN 'Factura'
        WHEN 'LoanMerchandise' THEN 'Mercancia Prestamo'
        WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmaceutica'
        WHEN 'TransferOrder' THEN 'Orden Traslado'
        WHEN 'InventoryAdjustment' THEN 'Ajustes de Inventario'
        WHEN 'PharmaceuticalDispensingDevolution' THEN 'Devolución de Dispensación'
        WHEN 'AccountPayable' THEN 'Cuentas x Pagar'
        WHEN 'RemissionEntrance' THEN 'Remision Entrada'
        WHEN 'RemissionReclassification' THEN 'Reclasificación de Remision'
        ELSE coco.EntityName
    END AS Documento,
    cuenta.Number AS cuenta,
    coco.VoucherDate AS [Fecha comprobante],
    MONTH(coco.VoucherDate) AS Mes,
    CASE WHEN T.PersonType = 1 THEN '999' ELSE T.Nit END AS Nit,
    T.Name AS Tercero,
    ((SUM(dcoco.DebitValue) - SUM(dcoco.CreditValue))) * -1 AS Valor,
    DATENAME(weekday, coco.VoucherDate) AS DiaSemana,
    CASE
        WHEN cc.Name LIKE 'NEV%' THEN 'Neiva'
        WHEN cc.Name LIKE 'PIT%' THEN 'Pitalito'
        WHEN cc.Name LIKE 'TUN%' THEN 'Tunja'
        ELSE 'DESCONOCIDO'
    END AS Sede
FROM [INDIGO035].[GeneralLedger].[JournalVouchers] AS coco
INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherDetails] AS dcoco ON coco.Id = dcoco.IdAccounting
INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherTypes] AS tcoco ON coco.IdJournalVoucher = tcoco.Id
INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS cuenta ON cuenta.Id = dcoco.IdMainAccount
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS T ON T.Id = dcoco.IdThirdParty
INNER JOIN [INDIGO035].[Payroll].[CostCenter] AS cc ON cc.Id = dcoco.IdCostCenter
WHERE
    (T.PersonType = '2')
    AND (coco.VoucherDate >= '01-01-2022')
    AND (cuenta.Number IN ('41301101','41301102', '41260706', '41301103', '41303501','41301104','41103704','41350101', '41351010'))
    AND coco.Status = '2'
    AND (coco.LegalBookId = '1')
GROUP BY
    cc.Code, cc.Name, tcoco.Name, coco.EntityCode, coco.EntityName, cuenta.Number, coco.VoucherDate,
    tcoco.Code, T.Nit, T.Name, T.PersonType

UNION ALL

SELECT
    'PGP' AS Tipo,
    cc.Code,
    cc.Name AS [Centro Costo],
    tcoco.Code AS [Tipo Comprobante],
    tcoco.Name AS NombreComprobante,
    coco.EntityCode AS CodDocumento,
    CASE coco.EntityName
        WHEN 'Invoice' THEN 'Factura'
        WHEN 'LoanMerchandise' THEN 'Mercancia Prestamo'
        WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmaceutica'
        WHEN 'TransferOrder' THEN 'Orden Traslado'
        WHEN 'InventoryAdjustment' THEN 'Ajustes de Inventario'
        WHEN 'PharmaceuticalDispensingDevolution' THEN 'Devolución de Dispensación'
        WHEN 'AccountPayable' THEN 'Cuentas x Pagar'
        WHEN 'RemissionEntrance' THEN 'Remision Entrada'
        WHEN 'RemissionReclassification' THEN 'Reclasificación de Remision'
        ELSE coco.EntityName
    END AS Documento,
    cuenta.Number AS cuenta,
    coco.VoucherDate AS [Fecha comprobante],
    MONTH(coco.VoucherDate) AS Mes,
    CASE WHEN T.PersonType = 1 THEN '999' ELSE T.Nit END AS Nit,
    T.Name AS Tercero,
    ((SUM(dcoco.DebitValue) - SUM(dcoco.CreditValue))) * -1 AS Valor,
    DATENAME(weekday, coco.VoucherDate) AS DiaSemana,
    CASE
        WHEN cc.Name LIKE 'NEV%' THEN 'Neiva'
        WHEN cc.Name LIKE 'PIT%' THEN 'Pitalito'
        WHEN cc.Name LIKE 'TUN%' THEN 'Tunja'
        ELSE 'DESCONOCIDO'
    END AS Sede
FROM [INDIGO035].[GeneralLedger].[JournalVouchers] AS coco
INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherDetails] AS dcoco ON coco.Id = dcoco.IdAccounting
INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherTypes] AS tcoco ON coco.IdJournalVoucher = tcoco.Id
INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS cuenta ON cuenta.Id = dcoco.IdMainAccount
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS T ON T.Id = dcoco.IdThirdParty
INNER JOIN [INDIGO035].[Payroll].[CostCenter] AS cc ON cc.Id = dcoco.IdCostCenter
WHERE
    (cuenta.Number IN ('41103701'))
    AND (T.PersonType = '2')
    AND (coco.VoucherDate >= '01-01-2022')
    AND coco.Status = '2'
    AND (coco.LegalBookId = '1')
GROUP BY
    cc.Code, cc.Name, tcoco.Name, coco.EntityCode, coco.EntityName, cuenta.Number, coco.VoucherDate,
    tcoco.Code, T.Nit, T.Name, T.PersonType

UNION ALL

SELECT
    'Naturales' AS Tipo,
    cc.Code,
    cc.Name AS [Centro Costo],
    tcoco.Code AS [Tipo Comprobante],
    tcoco.Name AS NombreComprobante,
    coco.EntityCode AS CodDocumento,
    CASE coco.EntityName
        WHEN 'Invoice' THEN 'Factura'
        WHEN 'LoanMerchandise' THEN 'Mercancia Prestamo'
        WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmaceutica'
        WHEN 'TransferOrder' THEN 'Orden Traslado'
        WHEN 'InventoryAdjustment' THEN 'Ajustes de Inventario'
        WHEN 'PharmaceuticalDispensingDevolution' THEN 'Devolución de Dispensación'
        WHEN 'AccountPayable' THEN 'Cuentas x Pagar'
        WHEN 'RemissionEntrance' THEN 'Remision Entrada'
        WHEN 'RemissionReclassification' THEN 'Reclasificación de Remision'
        ELSE coco.EntityName
    END AS Documento,
    cuenta.Number AS cuenta,
    coco.VoucherDate AS [Fecha comprobante],
    MONTH(coco.VoucherDate) AS Mes,
    CASE WHEN T.PersonType = 1 THEN '999' ELSE T.Nit END AS Nit,
    T.Name AS Tercero,
    ((SUM(dcoco.DebitValue) - SUM(dcoco.CreditValue))) * -1 AS Valor,
    DATENAME(weekday, coco.VoucherDate) AS DiaSemana,
    CASE
        WHEN cc.Name LIKE 'NEV%' THEN 'Neiva'
        WHEN cc.Name LIKE 'PIT%' THEN 'Pitalito'
        WHEN cc.Name LIKE 'TUN%' THEN 'Tunja'
        ELSE 'DESCONOCIDO'
    END AS Sede
FROM [INDIGO035].[GeneralLedger].[JournalVouchers] AS coco
INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherDetails] AS dcoco ON coco.Id = dcoco.IdAccounting
INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherTypes] AS tcoco ON coco.IdJournalVoucher = tcoco.Id
INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS cuenta ON cuenta.Id = dcoco.IdMainAccount
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS T ON T.Id = dcoco.IdThirdParty
INNER JOIN [INDIGO035].[Payroll].[CostCenter] AS cc ON cc.Id = dcoco.IdCostCenter
WHERE
    (cuenta.Number LIKE '41%')
    AND (T.PersonType = '1')
    AND (coco.VoucherDate >= '01-01-2022')
    AND (coco.LegalBookId = '1')
    AND tcoco.Code NOT IN ('000003','000002')
GROUP BY
    cc.Code, cc.Name, tcoco.Name, coco.EntityCode, coco.EntityName, cuenta.Number, coco.VoucherDate,
    tcoco.Code, T.Nit, T.Name, T.PersonType