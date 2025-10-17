-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Portfolio_NotasCartera_Entidad
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [ViewInternal].[Portfolio_NotasCartera_Entidad] as
SELECT credito.Factura, isnull(Credito.Ajuste,0)- isnull(debito.Ajuste,0) as Ajuste, credito.TipoNota
FROM (
SELECT  
c.InvoiceNumber AS Factura,  sum(FA.AdjusmentValue) AS Ajuste, case nc.NoteType when 1 then 'Debito' when 2 then 'Credito' end as TipoNota
		  
FROM   INDIGO031.Portfolio.PortfolioNote AS NC WITH (nolock) INNER JOIN
           (select max(id) as ID,PortfolioNoteId  
		    from INDIGO031.Portfolio.PortfolioNoteDetail
			group by PortfolioNoteId) AS ND  ON ND.PortfolioNoteId = NC.Id INNER JOIN
           INDIGO031.Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = NC.OperatingUnitId INNER JOIN
           INDIGO031.Common.Customer AS CL WITH (nolock) ON CL.Id = NC.CustomerId INNER JOIN
           --VIESECURITY.Security.[User] AS U WITH (nolock) ON U.UserCode = NC.CreationUser INNER JOIN
           --VIESECURITY.Security.Person AS P WITH (nolock) ON U.IdPerson = P.Id INNER JOIN
           INDIGO031.Portfolio.PortfolioNoteAccountReceivableAdvance AS FA WITH (nolock) ON FA.PortfolioNoteId = NC.Id INNER JOIN
           INDIGO031.Portfolio.AccountReceivable AS c WITH (nolock) ON c.Id = FA.AccountReceivableId LEFT OUTER JOIN
           INDIGO031.Billing.Invoice AS F WITH (nolock) ON F.InvoiceNumber = c.InvoiceNumber --LEFT OUTER JOIN
           --INDIGO031.Portfolio.PortfolioNoteConcept AS conc WITH (nolock) ON conc.Id = ND.PortfolioNoteConceptId LEFT OUTER JOIN
          -- [192.168.10.4].vie18.Billing.Invoice AS F1 WITH (nolock) ON F1.InvoiceNumber = c.InvoiceNumber
WHERE (NC.Status = 2) and nc.Nature=2  and NC.NoteDate>='01-01-2019'  
group by c.InvoiceNumber, nc.NoteType) AS Credito left outer join
(
SELECT  
c.InvoiceNumber AS Factura,  sum(FA.AdjusmentValue) AS Ajuste, case nc.NoteType when 1 then 'Debito' when 2 then 'Credito' end as TipoNota
		  
FROM   INDIGO031.Portfolio.PortfolioNote AS NC WITH (nolock) INNER JOIN
           (select max(id) as ID,PortfolioNoteId  
		    from INDIGO031.Portfolio.PortfolioNoteDetail
			group by PortfolioNoteId) AS ND  ON ND.PortfolioNoteId = NC.Id INNER JOIN
           INDIGO031.Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = NC.OperatingUnitId INNER JOIN
           INDIGO031.Common.Customer AS CL WITH (nolock) ON CL.Id = NC.CustomerId INNER JOIN
           --VIESECURITY.Security.[User] AS U WITH (nolock) ON U.UserCode = NC.CreationUser INNER JOIN
           --VIESECURITY.Security.Person AS P WITH (nolock) ON U.IdPerson = P.Id INNER JOIN
           INDIGO031.Portfolio.PortfolioNoteAccountReceivableAdvance AS FA WITH (nolock) ON FA.PortfolioNoteId = NC.Id INNER JOIN
           INDIGO031.Portfolio.AccountReceivable AS c WITH (nolock) ON c.Id = FA.AccountReceivableId LEFT OUTER JOIN
           INDIGO031.Billing.Invoice AS F WITH (nolock) ON F.InvoiceNumber = c.InvoiceNumber --LEFT OUTER JOIN
           --INDIGO031.Portfolio.PortfolioNoteConcept AS conc WITH (nolock) ON conc.Id = ND.PortfolioNoteConceptId LEFT OUTER JOIN
          -- [192.168.10.4].vie18.Billing.Invoice AS F1 WITH (nolock) ON F1.InvoiceNumber = c.InvoiceNumber
WHERE (NC.Status = 2) and nc.Nature=1  and NC.NoteDate>='01-01-2019'  -- and c.InvoiceNumber='TEV74083'
group by c.InvoiceNumber, nc.NoteType) as debito on debito.Factura=Credito.Factura
--where credito.Factura='TEV74083'
