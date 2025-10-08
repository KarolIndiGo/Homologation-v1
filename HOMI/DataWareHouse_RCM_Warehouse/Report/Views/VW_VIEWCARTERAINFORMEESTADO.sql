-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: VW_VIEWCARTERAINFORMEESTADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW Report.VW_VIEWCARTERAINFORMEESTADO
AS

WITH CTE_CUENTA AS (
  SELECT
    ACS.AccountWithoutRadicateId,
    ACS.AccountRadicateId,
    ACS.AccountObjectionRemediedId,
    ACS.AccountConciliationId,
    ACS.AccountHardCollectionId,
    ACS.AccountLegalCollectionId,
    MA.Number
  FROM
    [INDIGO036].[Contract].[ContractAccountingStructure] ACS
    INNER JOIN [INDIGO036].[GeneralLedger].[MainAccounts] AS MA ON MA.Id = ACS.AccountLegalCollectionId
),
CTE_CARTERA AS (
  SELECT
    AR.Id,
    TP.Nit,
    TP.Name AS [CLIENTE],
    AR.InvoiceNumber AS [NUMERO FACTURA],
    CASE
      AR.PortfolioStatus
      WHEN 1 THEN 'Sin Radicar'
      WHEN 2 THEN 'Radicada sin Confirmar'
      WHEN 3 THEN 'Radicada Entidad'
      WHEN 4 THEN 'Objetada o Glosada'
      WHEN 7 THEN 'Certificada Parcial'
      WHEN 8 THEN 'Certificada Total'
      WHEN 14 THEN 'Devolución Factura'
      WHEN 15 THEN 'Cuenta de Dificil Recaudo'
      WHEN 16 THEN 'Cobro Jurídico'
    END AS [ESTADO CARTERA],
    CASE
      AR.OpeningBalance
      WHEN 1 THEN 'SI'
      ELSE 'NO'
    END AS [SALDO INICIAL],
    AR.Value,
    ma.Number,
    ma.Name,
    ara.Value AS [VALOR EN CUENTA],
    ara.Balance AS [SALDO]
  FROM
    [INDIGO036].[Portfolio].[AccountReceivable] AS AR
    INNER JOIN [INDIGO036].[Portfolio].[AccountReceivableAccounting] AS ara ON ara.AccountReceivableId = AR.Id
    INNER JOIN [INDIGO036].[GeneralLedger].[MainAccounts] AS ma ON ma.Id = ara.MainAccountId
    INNER JOIN [INDIGO036].[Common].[ThirdParty] AS TP ON TP.Id = AR.ThirdPartyId
  WHERE
    AR.Balance <> 0
    AND AR.AccountReceivableType = 2
)
SELECT
  DISTINCT CAR.*,
  EST.ESTADO
FROM
  CTE_CARTERA CAR
  INNER JOIN [INDIGO036].[dbo].[CARTERA_ESTADO] EST ON CAR.Number = EST.CUENTA