-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_BILLING_TRAZABILIDADRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.IMO_Billing_TrazabilidadRIPS
AS
	
select 
			--er.Id,
			--i.OperatingUnitId OperativeUnitId,
			OU.UnitName as UnidadOperativa,
			--ep.EntityId DocumentTypeId,
			--ep.EntityName DocumentTypeName,
			i.InvoiceNumber  as NroFactura,
			i.InvoiceDate  as FechaFactura,
			--i.ThirdPartyId ThirdPartyId,
			tp.Nit  as Nit,
			tp.Name  as Entidad,
			i.PatientCode as DocumentoPaciente,
			paciente.IPNOMCOMP as Paciente,
			ep.CUV,
--			Estados - Trazabilidad de validación de RIPS
--1 - FEV validada Servicios DIAN - En petición para validación por servicio del ministerio
--2 - Generación código CUV validado por servicio del ministerio
--3 - Validaciones generadas desde servicio del ministerio
--99 - Unexpected Token - Validación credenciales de acceso al SISPRO
			case ep.StatusRIPS when 1 then 'Por Validar' when 2 then 'Validado' when 3 then 'Invalido' when 99 then 'Erroneo' end as EstadoRIPS,
			
			er.sendDate as FechaValidación,
			--ep.EntityId,
			--ep.EntityName,
			--er.CosmoDBId,
			i.AdmissionNumber  as Ingreso,
			--cp.Code AS CareGroupCode,
			--cp.Name AS CareGroupName, 
			erd.CreationDate as FechaValidaciónDetalle,
			erd.MessageCode AS CodigoMensaje ,erd.Message as Mensaje ,erd.Path as Ruta, erd.TypeMessage as TipoMensaje,
			PE.Fullname AS UsuarioFactura
	from [INDIGO035].[Billing].[ElectronicsProperties] ep 
	JOIN [INDIGO035].[Billing].[ElectronicsRIPS] er  on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.CreationDate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM [INDIGO035].[Billing].[ElectronicsRIPSDetail] as erd 
			group by ElectronicsRIPSId) AS erd1 on erd1.ElectronicsRIPSId=ep.Id
	JOIN [INDIGO035].[Billing].[ElectronicsRIPSDetail] as erd  on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.CreationDate,'yyyy-MM-dd HH:mm')=Fecha	
	JOIN [INDIGO035].[Billing].[Invoice] i  on ep.EntityId = i.Id
	JOIN [INDIGO035].[Common].[OperatingUnit] AS OU  ON OU.Id=i.OperatingUnitId
	JOIN [INDIGO035].[Common].[ThirdParty] tp  on i.ThirdPartyId = tp.Id
	LEFT JOIN [INDIGO035].[dbo].[INPACIENT] paciente  on i.PatientCode = paciente.IPCODPACI
	LEFT JOIN [INDIGO035].[Security].[UserInt] AS US  ON US.UserCode=i.InvoicedUser
	LEFT JOIN [INDIGO035].[Security].[PersonInt] AS PE  ON PE.Id=US.IdPerson
	where ep.EntityName = 'Invoice' and i.InvoiceDate>='01/01/2025' and erd.TypeMessage IN ('RECHAZADO','ERROR') and i.Status <>'2' --and erd.path is not null 
	--and erd.path <>'' 
	--and 	i.InvoiceNumber in ('KE248381','KE248380','KE248382')
	union all
		select 
			--er.Id,
			--i.OperatingUnitId OperativeUnitId,
			OU.UnitName as UnidadOperativa,
			--ep.EntityId DocumentTypeId,
			--ep.EntityName DocumentTypeName,
			i.InvoiceNumber  as NroFactura,
			i.InvoiceDate  as FechaFactura,
			--i.ThirdPartyId ThirdPartyId,
			tp.Nit  as Nit,
			tp.Name  as Entidad,
			i.PatientCode as DocumentoPaciente,
			paciente.IPNOMCOMP as Paciente,
			ep.CUV,
--			Estados - Trazabilidad de validación de RIPS
--1 - FEV validada Servicios DIAN - En petición para validación por servicio del ministerio
--2 - Generación código CUV validado por servicio del ministerio
--3 - Validaciones generadas desde servicio del ministerio
--99 - Unexpected Token - Validación credenciales de acceso al SISPRO
			case ep.StatusRIPS when 1 then 'Por Validar' when 2 then 'Validado' when 3 then 'Invalido' when 99 then 'Erroneo' end as EstadoRIPS,
			
			er.sendDate as FechaValidación,
			--ep.EntityId,
			--ep.EntityName,
			--er.CosmoDBId,
			i.AdmissionNumber  as Ingreso,
			--cp.Code AS CareGroupCode,
			--cp.Name AS CareGroupName, 
			erd.CreationDate as FechaValidaciónDetalle,
			erd.MessageCode AS CodigoMensaje ,erd.Message as Mensaje ,erd.Path as Ruta, erd.TypeMessage as TipoMensaje,
			PE.Fullname AS UsuarioFactura
	from [INDIGO035].[Billing].[ElectronicsProperties] AS ep 
	JOIN [INDIGO035].[Billing].[ElectronicsRIPS] er  on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.CreationDate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM [INDIGO035].[Billing].[ElectronicsRIPSDetail] as erd 
			group by ElectronicsRIPSId) AS erd1 on erd1.ElectronicsRIPSId=ep.Id
	JOIN [INDIGO035].[Billing].[ElectronicsRIPSDetail] as erd  on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.CreationDate,'yyyy-MM-dd HH:mm')=Fecha	
	JOIN [INDIGO035].[Billing].[Invoice] i  on ep.EntityId = i.Id
	JOIN [INDIGO035].[Common].[OperatingUnit] AS OU  ON OU.Id=i.OperatingUnitId
	JOIN [INDIGO035].[Common].[ThirdParty] tp  on i.ThirdPartyId = tp.Id
	LEFT JOIN [INDIGO035].[dbo].[INPACIENT] paciente  on i.PatientCode = paciente.IPCODPACI
	LEFT JOIN [INDIGO035].[Security].[UserInt] AS US  ON US.UserCode=i.InvoicedUser
	LEFT JOIN [INDIGO035].[Security].[PersonInt] AS PE  ON PE.Id=US.IdPerson
	where ep.EntityName = 'Invoice' and i.InvoiceDate>='01/01/2025' and Message like '%accessToken%' and i.Status <>'2'  --and erd.path is not null 
	--and erd.path <>'' --and i.InvoiceNumber='NEV1308946'
