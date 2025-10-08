-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_HOMI_CXC_GESTION_CARTERA_RADICACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE PROCEDURE Report.SP_HOMI_CXC_GESTION_CARTERA_RADICACION
AS 

WITH CTE_FACTURACION_RADICACION AS (
  SELECT
    CASE ar.PortfolioStatus
      WHEN 1 THEN 'SIN RADICAR'
      WHEN 2 THEN 'RADICADA POR RECIBIR ENTIDAD'
      WHEN 3 THEN 'RADICADA RECIBIDO ENTIDAD'
      WHEN 4 THEN 'OBJETADA O GLOSADA'
      WHEN 7 THEN 'CERTIFICADA PARCIAL'
      WHEN 8 THEN 'CERTIFICADA TOTAL'
      WHEN 14 THEN 'DEVOLUCION FACTURA'
      WHEN 15 THEN 'CUENTA DIFICIL RECAUDO'
      WHEN 16 THEN 'COBRO JURIDICO'
    END AS [ESTADO CARTERA],
    TP.Nit AS NIT,
    TP.Name AS TERCERO,
    ISNULL(cg.Name, 'SALDO INICIAL') AS [GRUPO ATENCION],
    CASE TP.PersonType
      WHEN 1 THEN 'NATURAL'
      WHEN 2 THEN 'JURIDICA'
    END AS [TIPO PERSONA],
    CASE ar.AccountReceivableType
      WHEN 1 THEN 'Facturación Básica'
      WHEN 2 THEN 'Facturación Ley 100'
      WHEN 3 THEN 'Impuestos Industria y Comercio'
      WHEN 4 THEN 'Pagarés'
      WHEN 5 THEN 'Acuerdos de Pago'
      WHEN 6 THEN 'Documento de Pago a Cuota Moderadora'
      WHEN 7 THEN 'Factura de Producto'
      WHEN 8 THEN 'Impuesto Predial'
    END AS [TIPO DOCUMENTO],
    ar.InvoiceNumber AS [FACTURA],
    ar.Value AS [VALOR FACTURA],
    ar.Balance AS [SALDO FACTURA],
    CAST(ar.AccountReceivableDate AS DATE) AS [FECHA FACTURA],
    ar.InvoiceId,
    CASE ar.Status
      WHEN 3 THEN 'ANULADO'
      ELSE 'FACTURADO'
    END AS [ESTADO FACTURA],
    CASE ar.OpeningBalance
      WHEN 1 THEN 'SI'
      ELSE 'NO'
    END AS [SALDO INICIAL],
    ar.AccountWithoutRadicateId
  FROM
    [INDIGO036].[Common].[ThirdParty] TP
    INNER JOIN [INDIGO036].[Portfolio].[AccountReceivable] ar ON TP.Id = ar.ThirdPartyId
    LEFT JOIN [INDIGO036].[Contract].[CareGroup] cg ON ar.CareGroupId = cg.Id
    LEFT JOIN [INDIGO036].[GeneralLedger].[MainAccounts] AS mar ON mar.Id = ar.AccountWithoutRadicateId
  WHERE
    ar.Status <> 3
    AND ar.AccountReceivableType = 2
    AND ar.Balance > 0
),

CTE_RADICACION AS (
  SELECT
    rid.InvoiceNumber,
    MIN(ri.Id) AS Id,
    MIN(rid.RadicatedNumber) AS RadicatedNumber
  FROM
    [INDIGO036].[Portfolio].[RadicateInvoiceC] ri
    INNER JOIN [INDIGO036].[Portfolio].[RadicateInvoiceD] rid ON ri.Id = rid.RadicateInvoiceCId
    INNER JOIN CTE_FACTURACION_RADICACION AS FAC ON FAC.FACTURA = rid.InvoiceNumber
  WHERE
    rid.State <> '4'
  GROUP BY
    rid.InvoiceNumber
),

CTE_GLOSADAS AS (
  SELECT
    dev.InvoiceNumber,
    dev.State
  FROM
    [INDIGO036].[Glosas].[GlosaDevolutionsReceptionD] dev
    INNER JOIN [INDIGO036].[Glosas].[GlosaDevolutionsReceptionC] AS cab ON cab.Id = dev.GlosaDevolutionsReceptionCId
    INNER JOIN [INDIGO036].[Common].[Customer] AS cli ON cli.Id = cab.CustomerId
    INNER JOIN [INDIGO036].[Common].[ThirdParty] AS TER ON TER.Id = cli.ThirdPartyId
    INNER JOIN CTE_FACTURACION_RADICACION AS RAD ON RAD.FACTURA = dev.InvoiceNumber
      AND RAD.NIT = TER.Nit
  WHERE
    cab.State <> '4'
  GROUP BY
    dev.InvoiceNumber,
    dev.State
)

SELECT
  FAC.[SALDO INICIAL],
  FAC.[TIPO PERSONA],
  FAC.NIT,
  FAC.TERCERO,
  FAC.[GRUPO ATENCION],
  FAC.FACTURA,
  FAC.[FECHA FACTURA],
  FAC.[VALOR FACTURA],
  FAC.[SALDO FACTURA],
  FAC.[ESTADO CARTERA],
  RI.RadicatedConsecutive AS [CONSECUTIVO RADICADO],
  CAST(RI.CreationDate AS DATE) AS [FECHA CREACION RADICADO],
  CAST(RI.ConfirmDateSystem AS DATE) AS [FECHA CONFIRMACION RADICADO],
  CAST(RI.ConfirmDate AS DATE) AS [FECHA RECIBIDO ENTIDAD],
  IIF(GLO.InvoiceNumber IS NULL, 'NO', 'SI') AS [PROCESO GLOSAS]
FROM
  CTE_FACTURACION_RADICACION FAC
  LEFT JOIN CTE_GLOSADAS AS GLO ON GLO.InvoiceNumber = FAC.FACTURA
  LEFT JOIN CTE_RADICACION AS RAD ON RAD.InvoiceNumber = FAC.FACTURA
  LEFT JOIN [INDIGO036].[Portfolio].[RadicateInvoiceC] RI ON RAD.Id = RI.Id;
