-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_TES_PLanillaPagos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_TES_PLanillaPagos] as

SELECT Id, SaldoInicial, Comprobante, Planilla, FechaDispersion, EstadoPlanilla, FechaComp, EstadoComp, Detalle, ValorComp, Nit, Proveedor, Email, CuentaBancaria, Banco, Factura, FechaFactura, VrFactura, COALESCE (Retefuente, 0) Retefuente, COALESCE (ReteIva, 0) ReteIva, COALESCE (ReteIca, 0) ReteIca, 
           COALESCE (OtrasRetenciones, 0) OtrasRetenciones, COALESCE (SinRetencion, 0) SinRetencion, VrPagadoFactura, Nota, VrNota, TipoNota, Descripción
FROM   (SELECT rf.Id AS Id, CASE rf.initialBalance WHEN '0' THEN 'No' WHEN '1' THEN 'SaldoInicial' END AS 'SaldoInicial', ce.Code AS 'Comprobante', pd.Code AS 'Planilla', pd.ScheduledDate AS 'FechaDispersion', 
                       CASE PD.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' WHEN '4' THEN 'PagoParcial' WHEN '5' THEN 'Pagototal' END AS 'EstadoPlanilla', ce.DocumentDate AS 'FechaComp', 
                       CASE ce.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' WHEN '4' THEN 'Reversado' END AS 'EstadoComp', ce.Detail AS 'Detalle', ce.Value AS 'ValorComp', t .Nit AS 'Nit', t .Name AS 'Proveedor', A.Email AS 'Email', cb.Number AS 'CuentaBancaria', b.Name AS 'Banco', 
                       rf.BillNumber AS 'Factura', rf.BillDate AS 'FechaFactura', rf.value AS 'VrPagadoFactura', /*rf.value + COALESCE (concepto.Value, 0)*/ rf.InvoiceValue AS 'VrFactura', COALESCE (concepto.Value, 0) AS 'VrRetencion', 
                       CASE Cuenta.RetencionType WHEN '1' THEN 'Retefuente' WHEN '2' THEN 'ReteIva' WHEN '3' THEN 'ReteIca' WHEN '4' THEN 'OtrasRetenciones' ELSE 'SinRetencion' END AS TipoRetencion, CabNota.Code AS 'Nota', COALESCE (Nota.AdjusmentValue, 0) AS 'VrNota', 
                       CASE CabNota.Nature WHEN '1' THEN 'Debito' WHEN '2' THEN 'Credito' END AS 'TipoNota', CabNota.Comment AS Descripción
            FROM   Payments.AccountPayable AS rf  LEFT OUTER JOIN
                       Payments.AccountPayableDetailConcept AS concepto ON concepto.IdAccountPayable = rf.Id AND concepto.Nature = 2 AND concepto.IdRetentionConcept IS NOT NULL LEFT OUTER JOIN
                       GeneralLedger.RetentionConcepts AS bconcepto  ON bconcepto.Id = concepto.IdRetentionConcept LEFT OUTER JOIN
                       GeneralLedger.MainAccounts AS Cuenta  ON Cuenta.Id = concepto.IdAccount INNER JOIN
                       Common.ThirdParty AS t  ON rf.IdThirdParty = t .Id LEFT OUTER JOIN
                       Common.Supplier AS pr  ON pr.Id = rf.IdSupplier LEFT OUTER JOIN
                       Common.SupplierBankAccount AS cb  ON cb.SupplierId = pr.Id AND cb.PaymentDefault = '1' LEFT OUTER JOIN
                       Payroll.Bank AS b  ON b.Id = cb.BankId LEFT OUTER JOIN
                       Common.Email AS A  ON A.IdPerson = t .PersonId LEFT OUTER JOIN
                       Payments.PaymentNotesAccountPayableAdvance AS Nota  ON rf.Id = Nota.AccountPayableId LEFT OUTER JOIN
                       Payments.PaymentNotes AS CabNota  ON Nota.PaymentNoteId = CabNota.Id LEFT OUTER JOIN
                       Treasury.SchedulePaymentDetail AS pdd  ON rf.Id = pdd.AccountPayableId AND pdd.SupplierId = rf.IdSupplier INNER JOIN
                       Treasury.SchedulePayment AS pd  ON pd.Id = pdd.SchedulePaymentId AND pdd.ThirdPartyId = rf.IdThirdParty AND pdd.AccountPayableId = rf.Id LEFT OUTER JOIN
                       Treasury.VoucherTransaction AS ce  ON ce.Id = pdd.VoucherTransactionId LEFT OUTER JOIN
                       Treasury.DischargeBill AS df  ON df.IdAccountPayable = rf.Id LEFT OUTER JOIN
                       Treasury.TreasuryPaymentConcepts AS cf ON cf.Id = df.IdPaymentConcept
            WHERE pd.Status = '1'  AND (rf.BillNumber IS NOT NULL)/*AND (ce.VoucherClass = '1') */ ) 
			source PIVOT (SUM(SOURCE.VrRetencion) FOR source.TipoRetencion IN (Retefuente, ReteIva, ReteIca, OtrasRetenciones, SinRetencion)) AS PIVOTABLE
