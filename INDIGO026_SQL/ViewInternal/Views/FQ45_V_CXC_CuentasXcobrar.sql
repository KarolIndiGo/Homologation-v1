-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CXC_CuentasXcobrar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_CXC_CuentasXcobrar]
AS
SELECT pib.Code AS [Codigo],
       CASE pib.Status
          WHEN '1' THEN 'Sin Confimar'
          WHEN '2' THEN 'Confirmado'
          WHEN '3' THEN 'Anulado'
       END AS [Estado],
       ter.[Name] AS [Cliente],
       ter.Nit + '-' + ter.DigitVerification AS [NIT],
       piba.InvoiceNumber AS [Numero de Factura],
       piba.[Value] AS [Valor Factura],
       piba.Balance AS [Saldo Factura],
       piba.AccountReceivableDate AS [Fecha de Factura],
       piba.ExpiredDate AS [Fecha de Vencimiento],
       piba.Observations AS [Observaciones],
       CASE piba.PortfolioStatus
          WHEN '1' THEN 'Sin Confimar'
          WHEN '2' THEN 'Confirmado'
          WHEN '3' THEN 'Anulado'
       END AS [Estado de Factura],
       'Saldo Inicial' AS [Modulo],
       PER.Fullname AS [Usuario Creación],
       PER1.Fullname AS [Usuario Confirmación],
       NULL AS [Usuario Anulacion]
FROM Portfolio.PortfolioInitialBalance pib
     INNER JOIN Portfolio.PortfolioInitialBalanceAccountReceivable piba
        ON pib.Id = piba.PortfolioInitialBalanceId
     INNER JOIN Common.ThirdParty ter ON piba.ThirdPartyId = ter.Id
     LEFT JOIN [Security].[Person] PER
        ON pib.CreationUser = PER.Identification
     LEFT JOIN [Security].[Person] PER1
        ON pib.ConfirmationUser = PER1.Identification
UNION ALL
(SELECT doc.Code
           AS [Codigo],
        CASE doc.Status
           WHEN '1' THEN 'Sin Confimar'
           WHEN '2' THEN 'Confirmado'
           WHEN '3' THEN 'Anulado'
        END
           AS [Estado],
        ter.[Name]
           AS [Cliente],
        ter.Nit + '-' + ter.DigitVerification
           AS [NIT],
        fac.InvoiceNumber
           AS [Numero de Factura],
        fac.TotalInvoice
           AS [Valor Factura],
        cxc.Balance
           AS [Saldo Factura],
        fac.InvoiceDate
           AS [Fecha de Factura],
        fac.InvoiceExpirationDate
           AS [Fecha de Vencimiento],
        doc.[Description]
           AS [Observaciones],
        CASE fac.Status WHEN '1' THEN 'Facturado' WHEN '2' THEN 'Anulado' END
           AS [Estado de Factura],
        'Factura de Productos'
           AS [Modulo],
        PER.Fullname
           AS [Usuario Creación],
        NULL
           AS [Usuario Confirmación],
        PER1.Fullname
           AS [Usuario Anulacion]
 FROM Billing.Invoice fac
      LEFT OUTER JOIN Inventory.DocumentInvoiceProductSales AS doc
         ON FAC.Id = doc.InvoiceId
      INNER JOIN Common.ThirdParty ter ON fac.ThirdPartyId = ter.Id
      LEFT OUTER JOIN Portfolio.AccountReceivable AS cxc
         ON fac.Id = cxc.InvoiceId
      LEFT JOIN [Security].[Person] PER
         ON fac.InvoicedUser = PER.Identification
      LEFT JOIN [Security].[Person] PER1
         ON fac.AnnulmentUser = PER1.Identification)
