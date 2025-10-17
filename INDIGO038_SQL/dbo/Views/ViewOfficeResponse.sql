-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: dbo
-- Object: ViewOfficeResponse
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [dbo].[ViewOfficeResponse]
AS
SELECT   
	c.Id,
	c.RadicatedConsecutive, 
	c.DocumentDate,
	c.RadicatedDate, 
	cus.Name,
	c.ReceivesTheSettled,
	c.DocumentCommentRadicated, 
	p.PatientCode,
	p.PatientName,
	p.RadicatedNumber,
	p.InvoiceNumber, 
    p.BalanceInvoice,
	Con.Code + ' - ' + con.NameSpecific AS ConceptGlosa, 
	conEva.NameSpecific AS ConceptEvalution, 
	ISNULL(m.JustificationGlosaText, '') AS JustificationGlosaText,
	ISNULL(m.JustificationReiterationText, '')  AS JustificationReiterationText, 
	ISNULL(m.ValueGlosado, 0) AS valueglosado, 
	ISNULL(m.ValueAcceptedFirstInstance, 0) AS ValueAcceptedFirstInstance, 
	ISNULL(m.ValueReiterated, 0) AS valuereiterated, 
    ISNULL(m.ValueAcceptedSecondInstance, 0) AS ValueAcceptedSecondInstance,
	de.servicecode + ' - ' + de.servicename as ServiceName, 
	m.MainGlosa,
	Rg.Code +' - ' + rg.Name  ResponsibleGlosa,
	rr.Code + '-' + rr.Name as ResponsibleReiteration,
	d.DocumentType, 
	grr.Comments
FROM   Glosas.GlosaObjectionsReceptionC AS c 
INNER JOIN Glosas.GlosaObjectionsReceptionD AS d ON c.Id = d.GlosaObjectionsReceptionCId 
INNER JOIN Glosas.GlosaInvoiceDetail AS de ON d.InvoiceNumber = de.InvoiceNumber
INNER JOIN Glosas.GlosaMovementGlosa AS m ON de.Id = m.InvoiceDetailId 
INNER JOIN Glosas.GlosaPortfolioGlosada AS p ON p.InvoiceNumber = d.InvoiceNumber
INNER JOIN Common.Customer AS cus ON cus.Id = c.CustomerId 
INNER JOIN Common.ConceptGlosas AS con ON con.Id = m.CodeGlosaId 
inner join [Glosas].[Responsible] Rg on Rg.id = m.ResponsibleId
LEFT JOIN Common.ConceptGlosas AS conEva ON  conEva.code = m.codeglosaEvaluation 
left join [Glosas].[Responsible] rr on rr.id = m.ResponsibleReiterationId
LEFT join Glosas.RadicateResponse grr on grr.Id = c.IdRadicateResponse
