-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_NOTAS_CREDITO
-- Extracted by Fabric SQL Extractor SPN v3.9.0





-- =============================================
-- Author:      MIGUEL ANGEL RUIZ VEGA
-- Create date: 2025-03-03 11:37:27
-- Database:    INDIGO043
-- Description: REPORTE NOTAS CREDITO
-- =============================================




CREATE VIEW [Report].[View_HDSAP_NOTAS_CREDITO]
AS


         SELECT  DISTINCT
		         CASE pfn.NoteType  
                    WHEN 1  
                    THEN 'Factura Total '  
                    WHEN 2  
                    THEN 'Factura Cuota '  
                    WHEN 3  
                    THEN 'Anticipo'  
                    WHEN 4  
                    THEN 'Distribucion de Anticipo '  
					WHEN 5
					THEN 'Reversión Anticipo vs CxC'
					WHEN 6
					THEN 'Factura Detallada'
                END AS TipoNota,   
                pfn.Code AS Consecutivo,   
                pfn.NoteDate AS FechaNota,   
                pfn.Observations AS Observacion,  
                CASE pfn.Nature  
                    WHEN 1  
                    THEN 'Debito'  
                    WHEN 2  
                    THEN 'Credito'  
                END AS Nota,   
                'Confirmado' AS Estado,   
                CAST(pna.AdjusmentValue AS INT) AS [Valor ajustado],   
                ar.Value AS [Valor de la cuenta por cobrar],   
                ar.Balance AS [Saldo de la cuenta por cobrar],   
                ar.InvoiceNumber AS Factura,   
                ar.AccountReceivableDate AS FechaFactura,   
                ct.Name,
				    MA.Number AS CuentaContableG,   
                MA.Name AS Nombreconcepto,  
                CASE MA.Nature  
                    WHEN 1  
                    THEN 'Debito'  
                    WHEN 2  
                    THEN 'Credito'  
                END AS Expr1,   
				AC.DebitValue ValorNotaDebito,
				ac.CreditValue ValorNotaCredito,
                pfn.CreationUser AS Usuario,  
                CASE ham.EntityType  
                    WHEN 1  
                    THEN 'EPS Contributivo'  
                    WHEN 2  
                    THEN 'EPS Subsidiado'  
                    WHEN 3  
                    THEN 'ET Vinculados Municipios'  
                    WHEN 4  
                    THEN 'ET Vinculados Departamentos'  
                    WHEN 5  
                    THEN 'ARL Riesgos Laborales'  
                    WHEN 6  
                    THEN 'MP Medicina Prepagada'  
                    WHEN 7  
                    THEN 'IPS Privada'  
                    WHEN 8  
                    THEN 'IPS Publica'  
                    WHEN 9  
                    THEN 'Regimen Especial'  
                    WHEN 10  
                    THEN 'Accidentes de transito'  
                    WHEN 11  
                    THEN 'Fosyga'  
                    WHEN 12  
                    THEN 'Otros'  
                END AS [Tipo de entidad],   
                tpy.Nit  
         FROM Portfolio.PortfolioNote AS pfn  
              LEFT JOIN Portfolio.PortfolioNoteAccountReceivableAdvance AS pna ON pna.PortfolioNoteId = pfn.Id  
              LEFT JOIN Portfolio.AccountReceivable AS ar ON ar.Id = pna.AccountReceivableId  
			  LEFT JOIN Portfolio.AccountReceivableShare AC ON AC.AccountReceivableId = AR.ID
              INNER JOIN Common.Customer AS ct ON ct.Id = pfn.CustomerId  
              LEFT  JOIN Portfolio.PortfolioNoteDetail AS PND ON PND.PortfolioNoteId = pfn.Id  
			  LEFT JOIN generalLedger.JournalVouchers jv on jv.EntityCode = pfn.code
			  LEFT JOIN GeneralLedger.JournalVoucherDetails jvd ON JVD.IdAccounting = JV.ID
              LEFT  JOIN GeneralLedger.MainAccounts AS MA ON MA.Id = jvD.IdMainAccount
              LEFT  JOIN Billing.Invoice AS inv ON inv.InvoiceNumber = ar.InvoiceNumber  
			  LEFT OUTER JOIN Billing.InvoiceCategories AS IC ON INV.InvoiceCategoryId=IC.Id  
              LEFT OUTER JOIN Contract.HealthAdministrator AS ham ON ham.Id = inv.HealthAdministratorId  
              LEFT OUTER JOIN Common.ThirdParty AS tpy ON tpy.Id = inv.ThirdPartyId  
  
        WHERE (MA.Number IN('58909006') OR MA.Number BETWEEN '4312' AND '43129508')  and not ma.Number in ('13191604','24079002')  
--and ar.InvoiceNumber in ('HSPE968478',
--'HSPE968484',	 
--'HSPE968507',	 
--'HSPE968713',
--'HSPE968829',	
--'HSPE968852',	 
--'HSPE968866',	 
--'HSPE969019',	 
--'HSPE969146',	 
--'HSPE969598',	 
--'HSPE969600',
--'HSPE947464')
  

