-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Billing_ReporteNotasElectronicas
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IMO_Billing_ReporteNotasElectronicas] as
select 
distinct uo.UnitName as Sucursal ,(BN.CODE) as ConsecutivoDianNota,
InvoiceNumber as Factura,  CASE BN.NATURE WHEN 1 THEN 'Debito' when 2 then 'Credito' end as Naturaleza, 
CASE ed.Status 
			 WHEN 0 THEN 'Invalida' 
			 WHEN 1 THEN 'Registrada' 
			 WHEN 2 THEN 'Enviada y Recibida' 
			 WHEN 3 THEN 'Valida' 
			 WHEN 4 THEN 'Invalida' 
			 WHEN 99 THEN 'Pendiente - Proc. Validacion' 
			 WHEN 88 THEN 'Pendiente - Proc. Envio' 
			 when 77 then 'No Procesa - Dif. Version'  END AS [Estado Nota DIAN],  
			
			 CASE when a.Destination=2 and A.status = 0 THEN 'Fallido' 
			 WHEN a.Destination=2 and  A.status =1 THEN 'Exitoso' ELSE '' END AS [Estado Envio DIAN],
			  CUDE, cu.nit +' - '+CU.Name as Cliente, bnd.DocumentDate as FechaDocumento, ed.ShippingDate as FechaEnvio
from  	Billing.BillingNote	bn	
--inner join Billing.Invoice AS F ON F.Id=BN.EntityId
inner join Common.OperatingUnit as uo on uo.Id=bn.OperatingUnitId
INNER JOIN Common.ThirdParty AS CU ON CU.ID=BN.CustomerPartyId
 INNER JOIN Billing.BillingNoteDetail	bnd	 WITH (NOLOCK) on	bnd.BillingNoteId=bn.Id	
 INNER JOIN Billing.ElectronicDocument	ed	WITH (NOLOCK)  on	ed.EntityId=bn.Id and ed.EntityName='BillingNote'
 INNER JOIN (
					select  ElectronicDocumentID, max(Id) as max_Id, Destination
					from    Billing.ElectronicDocumentDetail  AS T WITH (NOLOCK)
					where Destination=2
					group by  T.ElectronicDocumentID, Destination ) as R on  R.ElectronicDocumentID= ED.ID 
					LEFT OUTER JOIN Billing.ElectronicDocumentDetail AS A WITH (NOLOCK) ON A.ID= R.max_Id 
where  year(bn.NoteDate)>='2023' --and InvoiceNumber='IMNV304'

