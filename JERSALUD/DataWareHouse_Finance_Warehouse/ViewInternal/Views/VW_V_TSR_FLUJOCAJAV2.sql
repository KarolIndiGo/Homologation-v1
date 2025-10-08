-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_TSR_FLUJOCAJAV2
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_TSR_FLUJOCAJAV2 AS

SELECT 
    ce.Code AS [Nro comprobante], 
    t.Nit, 
    t.Name AS Tercero,
    CASE ce.VoucherClass
        WHEN '1' THEN 'Pago'
        WHEN '2' THEN 'Reembolso'
        WHEN '3' THEN 'Traslado'
    END AS [Clase Comprobante],
    CASE ce.ExpenseType
        WHEN '1' THEN 'Afecta Banco'
        WHEN '2' THEN 'Afecta Caja Menor'
        WHEN '3' THEN 'Afecta Caja Mayor'
        WHEN '4' THEN 'Producto Bancario'
    END AS [Tipo de Egreso], 
    c.Name AS [Caja/Cuenta], 
    ce.CreationDate AS [Fecha creación], 
    ce.DocumentDate AS [Fecha documento], 
    ce.Value AS [Valor pagado], 
    cone.Code + ' -' + cone.Description AS [Concepto de Egreso], 
    c.Number AS Cuenta, 
    ce.TransactionDate AS [Fecha consignación], 
    ce.CheckNumber AS Cheque, 
    ce.NoteNumber AS Nota, 
    ce.BeneficiaryIdentification AS [Nit Destinatario-Tercero], 
    ce.Beneficiary AS [Nombre Destinatario-Tercero], 
    rf.BillNumber AS Factura, 
    rf.BillDate AS [Fecha factura], 
    rf.ExpirationDate AS [Fecha vencimiento], 
    cf.Code + ' - ' + cf.Name AS [Concepto Factura], 
    df.AdvancedValue AS [Vr pagado factura], 
    c1.Number + ' - ' + c1.Name AS [Cuenta Contable], 
    ce.Detail AS Detalle, 
    ce.BankAccountNumber AS [Cuenta bancaria], 
    ce.BankName AS Banco, 
    tc.Nit AS [Nit CxP], 
    tc.Name AS [Tercero CxP], 
    dce.Value AS Valor, 
    nota.Description AS DetalleReversion, 
    pr.Name AS Proveedor,
    CASE
        WHEN c1.Number LIKE '12%' THEN 'TP_INVERSIONES'
        WHEN c1.Number LIKE '1325%' THEN 'TP_ACCIONISTAS'
        WHEN c1.Number LIKE '1330%' THEN 'TP_ANTICIPOS'
        WHEN c1.Number LIKE '1340%' THEN 'TP_ACTIVOSFIJOS'
        WHEN c1.Number LIKE '1355%' THEN 'TP_IMPUESTOS'
        WHEN c1.Number LIKE '1365%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '138035%' THEN 'TP_PROVEEDORES'
        WHEN c1.Number LIKE '138060%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '14%' THEN 'TP_PROVEEDORES'
        WHEN c1.Number LIKE '15%' THEN 'TP_ACTIVOS FIJOS'
        WHEN c1.Number LIKE '18%' THEN 'TP_IMPUESTOS'
        WHEN c1.Number LIKE '2105%' THEN 'TP_OBLIGACIONES FINANCIERAS'
        WHEN c1.Number LIKE '2115%' THEN 'TP_OBLIGACIONES FINANCIERAS'
        WHEN c1.Number LIKE '2120%' THEN 'TP_LEASING'
        WHEN c1.Number LIKE '2140%' THEN 'TP_OBLIGACIONES FINANCIERAS'
        WHEN c1.Number LIKE '2195%' THEN 'TP_OBLIGACIONES FINANCIERAS'
        WHEN c1.Number LIKE '2355%' THEN 'TP_ACCIONISTAS'
        WHEN c1.Number LIKE '2360%' THEN 'TP_ACCIONISTAS'
        WHEN c1.Number LIKE '2365%' THEN 'TP_IMPUESTOS'
        WHEN c1.Number LIKE '2368%' THEN 'TP_IMPUESTOS'
        WHEN c1.Number LIKE '237005%' THEN 'TP_SEGURIDAD SOCIAL'
        WHEN c1.Number LIKE '237010%' THEN 'TP_SEGURIDAD SOCIAL'
        WHEN c1.Number LIKE '237015%' THEN 'TP_SEGURIDAD SOCIAL'
        WHEN c1.Number LIKE '237020%' THEN 'TP_SEGURIDAD SOCIAL'
        WHEN c1.Number LIKE '237025%' THEN 'TP_SEGURIDAD SOCIAL'
        WHEN c1.Number LIKE '237030%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '237035%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '237040%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '237045%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '237050%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '237055%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '238035%' THEN 'TP_PROVEEDORES'
        WHEN c1.Number LIKE '2404%' THEN 'TP_IMPUESTOS'
        WHEN c1.Number LIKE '2408%' THEN 'TP_IMPUESTOS'
        WHEN c1.Number LIKE '250505%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '251010%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '251505%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '252005%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '252505%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '253015%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '253020%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '261010%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '261015%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '261020%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '261025%' THEN 'TP_NOMINA'
        WHEN c1.Number LIKE '31%' THEN 'TP_ACCIONISTAS'
        WHEN c1.Number LIKE '421005%' THEN 'TP_FINANCIEROS'
        WHEN c1.Number LIKE '530505%' THEN 'TP_FINANCIEROS'
        WHEN c1.Number LIKE '53052001%' THEN 'TP_FINANCIEROS'
        WHEN c1.Number LIKE '53052002%' THEN 'TP_FINANCIEROS'
        WHEN c1.Number LIKE '53052003%' THEN 'TP_LEASING'
        WHEN c1.Number LIKE '53052004%' THEN 'TP_FINANCIEROS'
        ELSE ST.Name
    END AS TipoProveedor, 
    rf.Code AS CxP, 
    rf.Coments AS [Observacion CxP], 
    pb.Number AS [CuentaBancaria Proveedor], 
    bp.Name AS [Banco Proveedor], 
    uo.UnitName AS Sede,
    CASE ce.Status
        WHEN '1' THEN 'Registrado'
        WHEN '2' THEN 'Confirmado'
        WHEN '3' THEN 'Anulado'
        WHEN '4' THEN 'Reversado'
    END AS Estado
FROM INDIGO031.Treasury.VoucherTransaction AS ce
    INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS c ON ce.IdMainAccount = c.Id
    INNER JOIN INDIGO031.Treasury.VoucherTransactionDetails AS dce ON ce.Id = dce.IdVoucherTransaction
    INNER JOIN INDIGO031.Common.ThirdParty AS t ON ce.IdThirdParty = t.Id
    INNER JOIN INDIGO031.Common.ThirdParty AS tc ON dce.IdThirdParty = tc.Id
    LEFT OUTER JOIN INDIGO031.Treasury.ExpenseConcepts AS cone ON cone.Id = dce.IdExpenseConcept
    LEFT OUTER JOIN INDIGO031.Treasury.DischargeBill AS df ON df.IdVoucherTransactionD = dce.Id
    LEFT OUTER JOIN INDIGO031.Treasury.TreasuryPaymentConcepts AS cf ON cf.Id = df.IdPaymentConcept
    LEFT OUTER JOIN INDIGO031.Payments.AccountPayable AS rf ON rf.Id = df.IdAccountPayable
    LEFT OUTER JOIN INDIGO031.Treasury.EntityBankAccounts AS eba ON eba.Id = ce.IdEntityBankAccount
    LEFT OUTER JOIN INDIGO031.Common.OperatingUnit AS uo ON uo.Id = ce.IdUnitOperative
    LEFT OUTER JOIN INDIGO031.GeneralLedger.MainAccounts AS c1 ON c1.Id = dce.IdMainAccount
    LEFT OUTER JOIN INDIGO031.Treasury.TreasuryNote AS nota ON nota.VoucherTransactionId = ce.Id
    LEFT OUTER JOIN INDIGO031.Common.SupplierType AS ST ON ST.Id = rf.SupplierTypeId
    LEFT OUTER JOIN INDIGO031.Common.Supplier AS pr ON pr.Id = rf.IdSupplier
    LEFT OUTER JOIN INDIGO031.Common.SupplierBankAccount AS pb ON pb.SupplierId = pr.Id
    LEFT OUTER JOIN INDIGO031.Payroll.Bank AS bp ON bp.Id = pb.BankId
WHERE (ce.VoucherClass <> '3')
    AND (ce.DocumentDate >= '20200101');