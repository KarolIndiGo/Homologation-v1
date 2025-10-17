-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRE_FACTURA_TAC
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_PRE_FACTURA_TAC]
AS

select pac.IPCODPACI Documento,
       pac.IPNOMCOMP NombrePaciente,
	   A.NUMINGRES Ingreso,
	   case a.NUMINGRES
	   when ''
	   then 'Abierto'
	   when 'P'
	   then 'Parcial'
	   End EstadoIngreso,
	   cup.Code CodigoCups,
	   cup.Description DescripcionCups,
	   sod.TotalSalesPrice,
	   so.OrderDate FechaOrdenServicio
 
from ADINGRESO a
join INPACIENT pac on pac.IPCODPACI = a.IPCODPACI
join Billing.ServiceOrder so on so.AdmissionNumber = a.NUMINGRES
join Billing.ServiceOrderDetail sod on sod.ServiceOrderId = so.id
join Contract.CUPSEntity cup on cup.id = sod.CUPSEntityId
WHERE A.IESTADOIN IN (' ','P')
  

