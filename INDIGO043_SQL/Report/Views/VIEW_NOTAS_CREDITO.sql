-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_NOTAS_CREDITO
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[VIEW_NOTAS_CREDITO]  
AS  
SELECT          DISTINCT
                CASE pfn.NoteType
				WHEN 1 THEN 'Factura Total'
				WHEN 2 THEN 'Factura Cuota'
				WHEN 3 THEN 'Anticipo'
				WHEN 4 THEN 'Distribución de Anticipo'
				WHEN 5 THEN 'Reversión Anticipo vs CxC'
				WHEN 6 THEN 'Factura Detallada'
				ELSE 'Otro'
                END AS LaNotaaplica, pfn.Code AS Consecutivo, 
                        convert(varchar, pfn.NoteDate,100) AS FechaNota, pfn.Observations AS Observacion, CASE pfn.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Nota, 'Confirmado' AS Estado,
						pna.AdjusmentValue  as [Valor ajustado],
						 ar.Value AS [Valor de la cuenta por cobrar], ar.Balance AS [Saldo de la cuenta por cobrar], ar.InvoiceNumber AS Factura, ar.AccountReceivableDate AS FechaFactura, ct.Name, MA.Number AS CuentaContableG, 
                         MA.Name AS Nombreconcepto, CASE MA.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Expr1, pna.AdjusmentValue AS ValorNota, pfn.CreationUser AS Usuario, 
                         CASE ham.EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado' WHEN 3 THEN 'ET Vinculados Municipios' WHEN 4 THEN' ET Vinculados Departamentos' WHEN 5 THEN' ARL Riesgos Laborales'
                          WHEN 6 THEN 'MP Medicina Prepagada' WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito' WHEN 11 THEN 'Fosyga' WHEN 12
                          THEN 'Otros' END AS [Tipo de entidad], tpy.Nit
FROM            Portfolio.PortfolioNote AS pfn INNER JOIN
                         Portfolio.PortfolioNoteAccountReceivableAdvance AS pna ON pna.PortfolioNoteId = pfn.Id LEFT OUTER JOIN
                         Portfolio.AccountReceivable AS ar ON ar.Id = pna.AccountReceivableId INNER JOIN
                         Common.Customer AS ct ON ct.Id = pfn.CustomerId LEFT OUTER JOIN
                         Portfolio.PortfolioNoteDetail AS PND ON PND.PortfolioNoteId = pfn.Id LEFT OUTER JOIN
                         GeneralLedger.MainAccounts AS MA ON MA.Id = pna.MainAccountId LEFT OUTER JOIN
                         Billing.Invoice AS inv ON inv.InvoiceNumber = ar.InvoiceNumber LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ham ON ham.Id = inv.HealthAdministratorId LEFT OUTER JOIN
                         Common.ThirdParty AS tpy ON tpy.Id = inv.ThirdPartyId 
						 -- where  (MA.Number IN('58909006') OR MA.Number BETWEEN '4312' AND '43129508') 
						 where PFN.Status = 2 --AND ar.InvoiceNumber = 'HSPE890506'
