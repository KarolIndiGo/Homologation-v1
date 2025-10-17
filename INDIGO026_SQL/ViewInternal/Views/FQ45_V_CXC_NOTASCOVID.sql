-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CXC_NOTASCOVID
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_CXC_NOTASCOVID]
AS
SELECT N.Id,
       N.Code
          AS Nota,
       CASE N.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' END
          AS EstadoNota,
       N.NoteDate
          AS FechaNota,
       Cl.Name
          AS Cliente,
       DN.Observations,
       CASE N.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END
          AS Naturaleza,
       CONVERT (MONEY, DN.Value, 100)
          AS ValorNota,
       AR.InvoiceNumber
          AS Factura,
       CONVERT (MONEY, CN.PreviousBalance, 100)
          AS SaldoAnterior,
       CONVERT (MONEY, CN.Balance, 100)
          AS SaldoActual,
       CPN.Code
          AS CodCpto,
       CPN.Name
          AS Concepto,
       MAC.Number
          [Numero de Cuenta],
       MAC.[Name]
          [Nombre de Cuenta],
       CONVERT (MONEY, CN.AdjusmentValue, 100)
          AS Ajuste,
       CONVERT (MONEY, AR.Value, 100)
          AS VlrFactura,
       CASE AR.PortfolioStatus
          WHEN 1 THEN 'Sin Radicar'
          WHEN 2 THEN 'Radicada Sin Confirmar'
          WHEN 3 THEN 'Radicada Entidad'
          WHEN 7 THEN 'CERTIFICADA_PARCIAL'
          WHEN 8 THEN 'CERTIFICADA_TOTAL'
          WHEN 14 THEN 'DEVOLUCION_FACTURA'
          WHEN 15 THEN 'CUENTA DE DIFICIL RECAUDO'
       END
          AS EstadoCartera,
       P.Identification
          AS CodCrea,
       P.Fullname
          AS UsuarioCrea,
       CON.Identification
          AS CodConfirma,
       CON.Fullname
          AS UsuarioConfirma
FROM Portfolio.PortfolioNote AS N
     INNER JOIN Portfolio.PortfolioNoteDetail AS DN
        ON DN.PortfolioNoteId = N.Id AND N.Status <> 3
     INNER JOIN Portfolio.PortfolioNoteAccountReceivableAdvance AS CN
        ON CN.PortfolioNoteId = N.Id
     INNER JOIN Portfolio.AccountReceivable AS AR
        ON CN.AccountReceivableId = AR.Id
     INNER JOIN Portfolio.PortfolioNoteConcept AS CPN
        ON DN.PortfolioNoteConceptId = CPN.Id
     INNER JOIN GeneralLedger.MainAccounts MAC
        ON MAC.ID = CPN.IdAccount
     INNER JOIN Common.Customer AS Cl ON N.CustomerId = Cl.Id
     INNER JOIN Security.Person AS P
        ON N.CreationUser = P.Identification
     LEFT OUTER JOIN Security.Person AS CON
        ON N.ConfirmationUser = CON.Identification
