-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_BILLING_REPORTENOTASELECTRONICAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_Billing_ReporteNotasElectronicas
AS 

select 
distinct uo.UnitName as Sucursal ,(bn.Code) as ConsecutivoDianNota,
InvoiceNumber as Factura,  CASE bn.Nature WHEN 1 THEN 'Debito' when 2 then 'Credito' end as Naturaleza, 
CASE ed.Status 
			 WHEN 0 THEN 'Invalida' 
			 WHEN 1 THEN 'Registrada' 
			 WHEN 2 THEN 'Enviada y Recibida' 
			 WHEN 3 THEN 'Valida' 
			 WHEN 4 THEN 'Invalida' 
			 WHEN 99 THEN 'Pendiente - Proc. Validacion' 
			 WHEN 88 THEN 'Pendiente - Proc. Envio' 
			 when 77 then 'No Procesa - Dif. Version'  END AS [Estado Nota DIAN],  
			
			 CASE when A.Destination=2 and A.Status = 0 THEN 'Fallido' 
			 WHEN A.Destination=2 and  A.Status =1 THEN 'Exitoso' ELSE '' END AS [Estado Envio DIAN],
			  CUDE, CU.Nit +' - '+CU.Name as Cliente, bnd.DocumentDate as FechaDocumento, ed.ShippingDate as FechaEnvio
from  	[INDIGO035].[Billing].[BillingNote] AS	bn	
--inner join Billing.Invoice AS F ON F.Id=BN.EntityId
inner join [INDIGO035].[Common].[OperatingUnit] as uo on uo.Id=bn.OperatingUnitId
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS CU ON CU.Id=bn.CustomerPartyId
 INNER JOIN [INDIGO035].[Billing].[BillingNoteDetail] AS	bnd	  on	bnd.BillingNoteId=bn.Id	
 INNER JOIN [INDIGO035].[Billing].[ElectronicDocument] AS	ed	  on	ed.EntityId=bn.Id and ed.EntityName='BillingNote'
 INNER JOIN (
					select  ElectronicDocumentId, max(Id) as max_Id, Destination
					from    [INDIGO035].[Billing].[ElectronicDocumentDetail]  AS T 
					where Destination=2
					group by  T.ElectronicDocumentId, Destination ) as R on  R.ElectronicDocumentId= ed.Id 
					LEFT OUTER JOIN [INDIGO035].[Billing].[ElectronicDocumentDetail] AS A  ON A.Id= R.max_Id 
where  year(bn.NoteDate)>='2023' --and InvoiceNumber='IMNV304'
