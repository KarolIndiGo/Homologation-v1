-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_SINRADICAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_SINRADICAR]
AS


select i.invoicenumber Factura,
       i.invoicedate FechaFactura,
	   t.nit,
	   t.name Tercero,
	   case p.PortfolioStatus
	   when 1
	   then 'SINRADICAR'
	   end EstadoFactura,
	   i.TotalInvoice TotalFactura,
	   cc.Name GrupoAtención,
	   case c.state
	   when 2
	   then 'Devolucion'
	   end Estado  


from Billing.Invoice i
inner join Portfolio.AccountReceivable p on p.InvoiceId = i.id
inner join Common.ThirdParty t on t.id = i.ThirdPartyId
inner join Contract.CareGroup cc on cc.Id = i.CareGroupId
left join Glosas.GlosaDevolutionsReceptionD d on d.InvoiceNumber = i.InvoiceNumber
left join Glosas.GlosaDevolutionsReceptionC c on c.id = d.GlosaDevolutionsReceptionCId
where p.PortfolioStatus = 1 and not i.Status = 2 and p.balance <> 0

  

