-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Portfolio_RecaudoCartera
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Portfolio_RecaudoCartera]
AS
     SELECT PA.Code AS Anticipo, 
            T.Nit + ' - ' + T.Name AS Cliente, 
            C.Number + ' - ' + C.Name AS CuentaContable, 
            PA.Value AS Valor, 
            PA.TransferValue AS VrTrasladado, 
            PA.DistributionValue AS ValoresDistribuidos, 
            PA.Balance AS Saldo, 
            PA.Observations AS Observaciones,
            CASE PA.OpeningBalance
                WHEN '1'
                THEN 'Si'
                WHEN '0'
                THEN 'No'
            END AS SaldoInicial,
            CASE PA.STATUS
                WHEN '1'
                THEN 'Registrado'
                WHEN '2'
                THEN 'Confirmado'
                WHEN '3'
                THEN 'Anulado'
            END AS EstadoAnticipo,
            CASE cR.CollectType
                WHEN '1'
                THEN 'Caja'
                WHEN '2'
                THEN 'Bancos'
            END AS [Tipo Recaudo], 
            cr.Code AS Recibo,
            CASE
                WHEN cr.DocumentDate IS NOT NULL
                THEN CONVERT(DATE, (cr.DocumentDate))
                ELSE CONVERT(DATE, PA.ConfirmationDate)
            END AS [Fecha recibo], 
            cr.Value AS ValoRecibo, 
            cr.Detail AS [Detalle Recibo], 
            eba.Number AS CuentaBancaria
     FROM Portfolio.PortfolioAdvance AS PA 
          INNER JOIN Common.ThirdParty AS T  ON T.Id = PA.ThirdPartyId
          INNER JOIN GeneralLedger.MainAccounts AS C  ON C.Id = PA.MainAccountId
                                                                           AND C.LegalBookId = '2'
          LEFT OUTER JOIN Treasury.CashReceipts AS cr  ON cr.Id = PA.CashReceiptId
                                                                            AND cr.CollectType <> '1'
                                                                            AND cr.STATUS <> '3'
                                                                            AND cr.STATUS <> '4'
                                                                            AND cr.Code = PA.Code
                                                                            AND PA.STATUS <> '3'
          LEFT OUTER JOIN Payroll.CostCenter AS ccos  ON ccos.Id = PA.CostCenterId
          LEFT OUTER JOIN Treasury.EntityBankAccounts AS eba  ON eba.Id = cr.IdBankAccount
          LEFT OUTER JOIN Payroll.Bank AS b  ON eba.IdBank = b.Id
     WHERE(PA.STATUS <> '3')
          AND (C.Number NOT IN('23355505', '28050530', '41400502'));
