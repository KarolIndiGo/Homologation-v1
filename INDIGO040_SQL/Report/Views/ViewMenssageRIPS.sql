-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewMenssageRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create view Report.ViewMenssageRIPS as


WITH cte_DetailMessage as (
		select *,TRY_CAST(
					   CASE 
						   WHEN CHARINDEX('[', d.PathDatos) > 0 
								AND CHARINDEX(']', d.PathDatos) > CHARINDEX('[', d.PathDatos)
						   THEN SUBSTRING(d.PathDatos, 
										 CHARINDEX('[', d.PathDatos) + 1, 
										 CHARINDEX(']', d.PathDatos) - CHARINDEX('[', d.PathDatos) - 1
						   )
						   ELSE NULL
					   END AS INT
				   ) + 1 AS ConsecutiveJson
		from (
			select	STUFF(ripd.Path, 
						  1, 
						  PATINDEX('%procedimientos%', ripd.Path) - 1, 
						  REPLACE(SUBSTRING(ripd.Path, 1, PATINDEX('%procedimientos%', ripd.Path) - 1), 
								  '[0]', '') -- Elimina los corchetes de los índices antes de "consultas"
					) AS PathDatos,
					ep.EntityId, ep.EntityName,ep.Id,
					'procedimientos' AS ServicesX,
					ripd.MessageCode,ripd.Message,ripd.CreationDate
			from Billing.ElectronicsProperties ep
			join Billing.ElectronicsRIPS rip on ep.Id = rip.ElectronicsPropertiesId
			join Billing.ElectronicsRIPSDetail ripd on rip.Id = ripd.ElectronicsRIPSId
			where ep.StatusRIPS <> 2
			and ripd.TypeMessage = 'RECHAZADO'
			and ripd.Path LIKE '%procedimientos%'
			and isnull(ripd.Path,'') <> ''
			
			union all 

			select	STUFF(ripd.Path, 
						  1, 
						  PATINDEX('%medicamentos%', ripd.Path) - 1, 
						  REPLACE(SUBSTRING(ripd.Path, 1, PATINDEX('%medicamentos%', ripd.Path) - 1), 
								  '[0]', '') -- Elimina los corchetes de los índices antes de "consultas"
					) AS PathDatos,
					ep.EntityId, ep.EntityName,ep.Id,
					'medicamentos' AS ServicesX,
					ripd.MessageCode,ripd.Message,ripd.CreationDate
			from Billing.ElectronicsProperties ep
			join Billing.ElectronicsRIPS rip on ep.Id = rip.ElectronicsPropertiesId
			join Billing.ElectronicsRIPSDetail ripd on rip.Id = ripd.ElectronicsRIPSId
			where ep.StatusRIPS <> 2
			and ripd.TypeMessage = 'RECHAZADO'
			and ripd.Path LIKE '%medicamentos%'
			and isnull(ripd.Path,'') <> ''

			union all 

			select	STUFF(ripd.Path, 
						  1, 
						  PATINDEX('%consultas%', ripd.Path) - 1, 
						  REPLACE(SUBSTRING(ripd.Path, 1, PATINDEX('%consultas%', ripd.Path) - 1), 
								  '[0]', '') -- Elimina los corchetes de los índices antes de "consultas"
					) AS PathDatos,
					ep.EntityId, ep.EntityName,ep.Id,
					'consultas' AS ServicesX,
					ripd.MessageCode,ripd.Message,ripd.CreationDate
			from Billing.ElectronicsProperties ep
			join Billing.ElectronicsRIPS rip on ep.Id = rip.ElectronicsPropertiesId
			join Billing.ElectronicsRIPSDetail ripd on rip.Id = ripd.ElectronicsRIPSId
			where ep.StatusRIPS <> 2
			and ripd.TypeMessage = 'RECHAZADO'
			and ripd.Path LIKE '%consultas%'
			and isnull(ripd.Path,'') <> ''
			
			union all 

			select	REPLACE(REPLACE(ripd.Path, '[0]', ''), '[1]', '') PathDatos,
					ep.EntityId, ep.EntityName,ep.Id,
					'otrosServicios' AS ServicesX,
					ripd.MessageCode,ripd.Message,ripd.CreationDate
			from Billing.ElectronicsProperties ep
			join Billing.ElectronicsRIPS rip on ep.Id = rip.ElectronicsPropertiesId
			join Billing.ElectronicsRIPSDetail ripd on rip.Id = ripd.ElectronicsRIPSId
			where ep.StatusRIPS <> 2
			and ripd.TypeMessage = 'RECHAZADO'
			and ripd.Path LIKE '%otrosServicios%'
			and isnull(ripd.Path,'') <> ''					
			) d ),
	cte_InvoiceDetail as (select i.id,
								i.InvoiceNumber,
								id.id InvoiceDetailid, 
								idj.ConsecutiveJson,
								idj.ServiceNameJson,
								id.ServiceOrderDetailId
							from Billing.Invoice i
							join Billing.ElectronicsProperties ep on i.id =ep.EntityId and ep.EntityName ='Invoice'
							join Billing.InvoiceDetail id on i.Id =id.InvoiceId
							join Billing.InvoiceDetailJsonMap idj on id.Id = idj.InvoiceDetailId),
		cte_SodID AS (
						SELECT cte.*,CONCAT(cup.Code,' - ',cup.Description) codeName
						FROM cte_InvoiceDetail cte
						JOIN Billing.ServiceOrderDetail sod on cte.ServiceOrderDetailId = sod.id
						join Contract.CUPSEntity cup on sod.CUPSEntityId = cup.Id
						where sod.RecordType =1
						
						union ALL
						
						SELECT cte.*,CONCAT(ip.Code,' - ',ip.Name) codeName
						FROM cte_InvoiceDetail cte
						JOIN Billing.ServiceOrderDetail sod on cte.ServiceOrderDetailId = sod.id
						join Inventory.InventoryProduct ip on sod.ProductId = ip.Id
						where sod.RecordType =2
						),
		cte_GeneralValidations as ( select	ep.EntityId, 
											ep.EntityName,ep.Id,
											ripd.MessageCode,
											ripd.Message,
											ripd.CreationDate,
											ripd.path
									from Billing.ElectronicsProperties ep
									join Billing.ElectronicsRIPS rip on ep.Id = rip.ElectronicsPropertiesId
									join Billing.ElectronicsRIPSDetail ripd on rip.Id = ripd.ElectronicsRIPSId
									where ep.StatusRIPS <> 2
										and ripd.TypeMessage = 'RECHAZADO' 
										and ripd.Path not LIKE'%otrosServicios%'
										and ripd.Path not LIKE'%consultas%'
										and ripd.Path not LIKE'%medicamentos%'
										and ripd.Path not LIKE'%procedimientos%'
									)


select 
'HOSPITAL SAN JOSE' AS EMPRESA,
cteInv.InvoiceNumber Numero_Documento,
		CASE cte.EntityName
					WHEN 'Invoice' THEN 'Factura'
					WHEN 'BillingNote' THEN 'Notas'
					else 'Desconocido'
				END TipoDocumento,
		cteInv.ServiceNameJson as SegmentoJson,
		cteInv.ConsecutiveJson as consecutivoJson,
		cteInv.codeName Codigo_Nombre_Servicio,
		cte.PathDatos Ruta_Validacion_Json,
		cte.MessageCode,
		cte.Message,
		max(cte.CreationDate) CreationDate
from cte_DetailMessage cte
join cte_SodID cteInv	
	on cte.EntityId= cteInv.Id and cte.EntityName='Invoice'
	and cteInv.ConsecutiveJson= cte.ConsecutiveJson and cteInv.ServiceNameJson =cte.ServicesX
GROUP by cteInv.InvoiceNumber,
		cte.EntityName,
		cteInv.ServiceNameJson,
		cteInv.ConsecutiveJson,
		cteInv.codeName,
		cte.PathDatos,
		cte.MessageCode,
		cte.Message

UNION ALL

select 
'HOSPITAL SAN JOSE' AS EMPRESA,
COALESCE(i.InvoiceNumber,bn.Code) Numero_Documento,
		CASE cte.EntityName
					WHEN 'Invoice' THEN 'Factura'
					WHEN 'BillingNote' THEN 'Notas'
					else 'Desconocido'
		END TipoDocumento,
		NULL as SegmentoJson,
		null as consecutivoJson,
		null Codigo_Nombre_Servicio,
		cte.Path Ruta_Validacion_Json,
		cte.MessageCode,
		cte.Message,
		max(cte.CreationDate) CreationDate
from cte_GeneralValidations cte
LEFT JOIN Billing.Invoice i on cte.EntityId =i.id and cte.EntityName='Invoice'
LEFT join Billing.BillingNote bn on cte.EntityId = bn.Id AND cte.EntityName ='BillingNote'
GROUP by cte.EntityName,
		cte.MessageCode,
		cte.Message,cte.Path,i.InvoiceNumber,bn.Code