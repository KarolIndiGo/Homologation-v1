-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_DISTRIBUCION_CXP
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_DISTRIBUCION_CXP]
AS




SELECT distinct
       dc.CreationDate FechaDistribucion,
       t.NIT Nit,
       t.name Proveedor,
	   dc.BillNumber 'NumeroFactura',
	   ac.Code ConsecutivoCXP,
	   DC.CODE 'Codigo de la distribución',
	   case dc.Status
	   when 1
	   then 'Registrado'
	   when 2
	   then 'Confirmado'
	   when 3
	   then 'Anulado'
	   when 4
	   then 'Reversada'
       end 'EstadoDistribucion'

FROM  Cost.CostDistributionDirectCost AS DC 
join Payments.AccountPayable ac on ac.id = dc.AccountPayableId
join Common.ThirdParty t on t.id = dc.ThirdPartyId
  

