-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_NOTASCARTERA
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_NOTASCARTERA]
AS

     SELECT distinct
	        pn.Code AS Codigo, 
            tp.Nit + ' - ' + tp.Name AS Cliente, 
            pn.NoteDate AS Fecha,
            CASE pn.NoteType
                WHEN '1'
                THEN 'Factura Total'
                WHEN '2'
                THEN 'Factura Cuota'
                WHEN '3'
                THEN 'Anticipo'
                WHEN '4'
                THEN 'Distribucion de Anticipo'
            END AS TipoNota,
            CASE pn.Nature
                WHEN '1'
                THEN 'Debito'
                WHEN '2'
                THEN 'Credito'
            END AS Naturaleza,
            CASE pn.STATUS
                WHEN '1'
                THEN 'Registrado'
                WHEN '2'
                THEN 'Confirmado'
                WHEN '3'
                THEN 'Anulado'
            END AS Estado, 
            acr.InvoiceNumber AS Factura, 
            pnara.AdjusmentValue AS ValorConcepto, 
            pnd.Value AS ValorAjuste, 
            nc.Code + ' - ' + nc.Name AS ConceptoNota, 
            acr.Value AS ValorInicial, 
            acr.Balance AS Saldo, 
            fac.InvoiceDate AS FechaFactura, 
            us.UserCode + ' - ' + pe.Fullname AS UsuarioCreaNota
     FROM Portfolio.PortfolioNote AS pn
          INNER JOIN Portfolio.PortfolioNoteDetail AS pnd ON pn.Id = pnd.PortfolioNoteId
          INNER JOIN Common.ThirdParty AS tp ON pnd.ThirdPartyId = tp.Id
          INNER JOIN Portfolio.PortfolioNoteConcept AS nc ON pnd.PortfolioNoteConceptId = nc.Id
          INNER JOIN Portfolio.PortfolioNoteAccountReceivableAdvance AS pnara ON pn.Id = pnara.PortfolioNoteId
          LEFT JOIN Portfolio.AccountReceivable AS acr ON pnara.AccountReceivableId = acr.Id
          LEFT JOIN
		  
     (
         SELECT invoicenumber, 
                invoicedate
         FROM Billing.Invoice
         UNION ALL
         SELECT invoicenumber, 
                invoicedate
         FROM Billing.Invoice

     ) AS fac ON acr.InvoiceNumber = fac.InvoiceNumber
          LEFT JOIN Security.[User] AS us ON us.UserCode = pn.CreationUser
          LEFT JOIN Security.Person AS pe ON pe.Id = us.IdPerson
  		-- where fac.InvoiceNumber = 'HSPE422736'

