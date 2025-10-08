-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VISTADIFERENCIALIBROS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VistaDiferenciaLibros]
AS

SELECT
    datacol.Anio,
    datacol.Mes,
    datacol.IdMainAccount,
    datacol.Number + ' - ' + datacol.Name AS CuentaColgap,
    datacol.Nit,
    datacol.CodeCostCenter,
    datacol.DebitValue,
    datacol.CreditValue,
    manif.Number + ' - ' + manif.Name AS CuentaNiif,
    ISNULL(datanif.DebitValue, 0) AS DebitValueNiif,
    ISNULL(datanif.CreditValue, 0) AS CreditValueNiif
FROM (
    SELECT
        MONTH(jv.VoucherDate) AS Mes,
        YEAR(jv.VoucherDate) AS Anio,
        jvd.IdMainAccount,
        ma.Number,
        ma.Name,
        t.Nit,
        cc.Code AS CodeCostCenter,
        jvd.IdThirdParty,
        jvd.IdCostCenter,
        SUM(jvd.DebitValue) AS DebitValue,
        SUM(jvd.CreditValue) AS CreditValue
    FROM [INDIGO035].[GeneralLedger].[JournalVouchers] AS jv
    INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherDetails] AS jvd
        ON jv.Id = jvd.IdAccounting
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
        ON ma.Id = jvd.IdMainAccount
    LEFT JOIN [INDIGO035].[Common].[ThirdParty] AS t
        ON t.Id = jvd.IdThirdParty
    LEFT JOIN [INDIGO035].[Payroll].[CostCenter] AS cc
        ON cc.Id = jvd.IdCostCenter
    WHERE ma.LegalBookId = 1
      AND jv.IsClosedYear = 0
    GROUP BY
        MONTH(jv.VoucherDate),
        YEAR(jv.VoucherDate),
        jvd.IdMainAccount,
        ma.Number,
        ma.Name,
        jvd.IdThirdParty,
        t.Nit,
        jvd.IdCostCenter,
        cc.Code
) AS datacol
INNER JOIN [INDIGO035].[GeneralLedger].[HomologationAccount] AS ha
    ON ha.OfficialMainAccountId = datacol.IdMainAccount
INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS manif
    ON manif.Id = ha.MainAccountId
LEFT JOIN (
    SELECT
        MONTH(jv.VoucherDate) AS Mes,
        YEAR(jv.VoucherDate) AS Anio,
        jvd.IdMainAccount,
        jvd.IdThirdParty,
        jvd.IdCostCenter,
        SUM(jvd.DebitValue) AS DebitValue,
        SUM(jvd.CreditValue) AS CreditValue
    FROM [INDIGO035].[GeneralLedger].[JournalVouchers] AS jv
    INNER JOIN [INDIGO035].[GeneralLedger].[JournalVoucherDetails] AS jvd
        ON jv.Id = jvd.IdAccounting
    INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS ma
        ON ma.Id = jvd.IdMainAccount
    WHERE ma.LegalBookId = 2
      AND jv.IsClosedYear = 0
    GROUP BY
        MONTH(jv.VoucherDate),
        YEAR(jv.VoucherDate),
        jvd.IdMainAccount,
        jvd.IdThirdParty,
        jvd.IdCostCenter
) AS datanif
    ON datacol.Anio = datanif.Anio
   AND datacol.Mes = datanif.Mes
   AND datanif.IdMainAccount = ha.MainAccountId
   AND ISNULL(datacol.IdThirdParty, 0) = ISNULL(datanif.IdThirdParty, 0)
   AND ISNULL(datacol.IdCostCenter, 0) = ISNULL(datanif.IdCostCenter, 0)
WHERE datacol.DebitValue <> ISNULL(datanif.DebitValue, 0)
   OR datacol.CreditValue <> ISNULL(datanif.CreditValue, 0);