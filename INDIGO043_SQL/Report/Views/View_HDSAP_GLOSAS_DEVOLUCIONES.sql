-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_GLOSAS_DEVOLUCIONES
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_GLOSAS_DEVOLUCIONES]
AS


SELECT                   distinct
						B.RadicatedConsecutive AS Consecutivo, D.Nit, D.Name AS EAPB, A.InvoiceNumber AS Factura, A.InvoiceDate AS [Fecha Factura], A.BalanceInvoice AS Saldo, A.RadicatedNumber AS Radicado, 
                         A.RadicatedDate AS [Fecha Radicado], A.PatientCode AS Identificacion, A.PatientName AS [Nombre Paciente], A.Ingress AS Ingreso, A.ContractCode AS Contrato, A.PlanCode AS [Plan], 
                         A.ContractName AS [Descripcion Contrato], A.UserNameInvoice AS Facturador, CASE WHEN a.state = 1 THEN 'Sin Confirmar' WHEN a.state = 2 THEN 'Confirmada' END AS Estado, 
                         B.CreationDate AS [Fecha Creacion], B.DocumentDate AS [Fecha Oficio Devolucion], B.DocumentNumber AS Oficio, 
                         CASE WHEN c.TypeDevolution = 1 THEN 'Justificada' WHEN c.TypeDevolution = 2 THEN 'Injustificada' END AS [Tipo Devolucion], E.Code AS Concepto, E.NameSpecific AS [Descripcion Concepto], 
                         C.Comment AS Comentario, C.Answer AS Respuesta, acr.Balance AS SaldoCartera, CASE WHEN rid.RadicatedNumber IS NULL THEN 'Anulado' ELSE rid.RadicatedNumber END AS Radicadoconfirmado, 
                         rid.RadicatedDate AS fecharadicacion, 
                         CASE ham.EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado' WHEN 3 THEN 'ET Vinculados Municipios' WHEN 4 THEN 'ET Vinculados Departamentos' WHEN 5 THEN 'ARL Riesgos Laborales'
                          WHEN 6 THEN 'MP Medicina Prepagada' WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito' WHEN 11 THEN 'Fosyga' WHEN 12
                          THEN 'Otros' END AS 'Tipo de entidad'
FROM            Glosas.GlosaDevolutionsReceptionD AS A INNER JOIN
                         Glosas.GlosaDevolutionsReceptionC AS B ON A.GlosaDevolutionsReceptionCId = B.Id INNER JOIN
                         Glosas.GlosaMovementDevolutions AS C ON C.IdDevolutionsReceptionD = A.Id INNER JOIN
                         Common.Customer AS D ON B.CustomerId = D.Id INNER JOIN
                         Common.ConceptGlosas AS E ON C.IdConceptGlosa = E.Id LEFT OUTER JOIN
                         Portfolio.RadicateInvoiceD AS rid ON rid.InvoiceNumber = A.InvoiceNumber LEFT OUTER JOIN
                         Portfolio.AccountReceivable AS acr ON acr.InvoiceNumber = A.InvoiceNumber LEFT OUTER JOIN
                         Billing.Invoice AS inv ON inv.InvoiceNumber = A.InvoiceNumber LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ham ON ham.Id = inv.HealthAdministratorId
  

