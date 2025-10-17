-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_RECIBOS_CAJA_ABIERTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0








-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-05-14 10:51:38
-- Database:    INDIGO043
-- Description: Reporte RECIBO DE CAJA
-- =============================================



CREATE VIEW [Report].[View_HDSAP_RECIBOS_CAJA_ABIERTOS]
AS

SELECT        cr.DocumentDate FECHA,
			  cr.Code AS 'NUMERO RECIBO CAJA',
			  CASE WHEN B.Name IS NOT NULL THEN CONCAT(B.Name, ' - ' + EBA.Number) ELSE CONCAT( TCR.Code, ' - ' + TCR.Name) END CONCEPTO,
			  MA.Number CUENTACONTABLE,
			  cr.Value AS VALOR,
			  cr.Detail AS 'DETALLE RECIBO CAJA',
			  I.InvoiceNumber '# FACTURA CRUZADA INGRESO',
			  CASE A.IESTADOIN
			  WHEN ' ' THEN 'ABIERTO'
			  WHEN 'C' THEN 'CERRADO'
			  WHEN 'P' THEN 'PARCIAL'
			  WHEN 'F' THEN 'FACTURADO'
			  END 'ESTADO INGRESO'
			  
FROM          Portfolio.PortfolioAdvance AS pa INNER JOIN
              BILLING.Invoice I ON I.AdmissionNumber = PA.AdmissionNumber INNER JOIN
			  ADINGRESO A ON A.NUMINGRES = I.AdmissionNumber INNER JOIN
              Common.ThirdParty t ON pa.ThirdPartyId = t.Id AND pa.ThirdPartyId = t.Id AND pa.ThirdPartyId = t.Id LEFT OUTER JOIN
              Treasury.CashReceipts AS cr ON cr.Id = pa.CashReceiptId LEFT JOIN
			  Treasury.EntityBankAccounts AS EBA ON cr.IdBankAccount=EBA.Id LEFT JOIN
			  [Payroll].[Bank] B ON EBA.IdBank=B.Id LEFT JOIN
			  [GeneralLedger].[MainAccounts] MA ON cr.IdMainAccount=MA.Id LEFT JOIN
			  [Treasury].[CashRegisters] TCR ON cr.IdCashRegister=TCR.Id





