-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_TrazabilidadRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[Billing_TrazabilidadRIPS]    Script Date: 15/04/2025 9:12:53 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE view [ViewInternal].[Billing_TrazabilidadRIPS] as
	
	select UPPER(LEFT(UnidadOperativa, 1)) + LOWER(SUBSTRING(UnidadOperativa, 2, LEN(UnidadOperativa))) as UnidadOperativa,	NroFactura,	FechaFactura,	Nit,	Entidad,	DocumentoPaciente,	Paciente,	CUV,	EstadoRIPS,	FechaValidación,
	Ingreso,	FechaValidaciónDetalle,	CodigoMensaje,	Mensaje,	Ruta,	TipoMensaje,	UsuarioFactura, DATEDIFF(MINUTE,FechaFactura,FechaValidación) as TiempoValida,  FechaIngreso, FechaEgreso

	from (
	
	
	select 
			--er.Id,
			--i.OperatingUnitId OperativeUnitId,
			ou.UnitName as UnidadOperativa,
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
			erd.creationdate as FechaValidaciónDetalle,
			ERD.mESSAGEcODE AS CodigoMensaje ,Message as Mensaje ,erd.path as Ruta, typemessage as TipoMensaje,
			PE.Fullname AS UsuarioFactura, i.InitialDate as FechaIngreso,i.OutputDate as FechaEgreso
	from Billing.ElectronicsProperties ep with (nolock)
	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.creationdate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM Billing.ElectronicsRIPSDetail as erd with (nolock)
			where ERD.mESSAGEcODE <> '-999'
			group by ElectronicsRIPSId) AS erd1 on ERD1.ElectronicsRIPSId=EP.ID
	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.creationdate,'yyyy-MM-dd HH:mm')=Fecha	
	JOIN Billing.Invoice i with (nolock) on ep.EntityId = i.Id
	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
	LEFT JOIN dbo.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
	LEFT JOIN Security.[User] AS US  ON US.UserCode=I.InvoicedUser
	LEFT JOIN Security.[Person] AS PE  ON PE.ID=US.IdPerson
	where ep.EntityName = 'Invoice' and i.InvoiceDate>='04/01/2025' and typemessage IN ('RECHAZADO') and i.Status <>'2' -- and erd.path is not null  
	--and i.Status <>'2'
	--and erd.path <>'' 
	--and i.InvoiceNumber='FEV526726'

--	union all

--		select 
--			--er.Id,
--			--i.OperatingUnitId OperativeUnitId,
--			ou.UnitName as UnidadOperativa,
--			--ep.EntityId DocumentTypeId,
--			--ep.EntityName DocumentTypeName,
--			i.InvoiceNumber  as NroFactura,
--			i.InvoiceDate  as FechaFactura,
--			--i.ThirdPartyId ThirdPartyId,
--			tp.Nit  as Nit,
--			tp.Name  as Entidad,
--			i.PatientCode as DocumentoPaciente,
--			paciente.IPNOMCOMP as Paciente,
--			ep.CUV,
----			Estados - Trazabilidad de validación de RIPS
----1 - FEV validada Servicios DIAN - En petición para validación por servicio del ministerio
----2 - Generación código CUV validado por servicio del ministerio
----3 - Validaciones generadas desde servicio del ministerio
----99 - Unexpected Token - Validación credenciales de acceso al SISPRO
--			case ep.StatusRIPS when 1 then 'Registrado' when 2 then 'Validado' when 3 then 'Invalido' when 99 then 'Erroneo' end as EstadoRIPS,
			
--			er.sendDate as FechaValidación,
--			--ep.EntityId,
--			--ep.EntityName,
--			--er.CosmoDBId,
--			i.AdmissionNumber  as Ingreso,
--			--cp.Code AS CareGroupCode,
--			--cp.Name AS CareGroupName, 
--			erd.creationdate as FechaValidaciónDetalle,
--			ERD.mESSAGEcODE AS CodigoMensaje ,Message as Mensaje ,erd.path as Ruta, typemessage as TipoMensaje,
--			PE.Fullname AS UsuarioFactura
--	from Billing.ElectronicsProperties ep with (nolock)
--	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
--	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=ep.id	
--	JOIN Billing.Invoice i with (nolock) on ep.EntityId = i.Id
--	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
--	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
--	LEFT JOIN dbo.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
--	LEFT JOIN Security.[User] AS US WITH (NOLOCK) ON US.UserCode=I.InvoicedUser
--	LEFT JOIN Security.[Person] AS PE WITH (NOLOCK) ON PE.ID=US.IdPerson
--	where ep.EntityName = 'Invoice' and i.InvoiceDate>='01/01/2025' and typemessage IN ('ERROR') and i.Status <>'2'   --and erd.path is not null 
--	--and erd.path <>'' --and i.InvoiceNumber='NEV1308946'

	union all 

--	select 
--			--er.Id,
--			--i.OperatingUnitId OperativeUnitId,
--			ou.UnitName as UnidadOperativa,
--			--ep.EntityId DocumentTypeId,
--			--ep.EntityName DocumentTypeName,
--			i.InvoiceNumber  as NroFactura,
--			i.InvoiceDate  as FechaFactura,
--			--i.ThirdPartyId ThirdPartyId,
--			tp.Nit  as Nit,
--			tp.Name  as Entidad,
--			i.PatientCode as DocumentoPaciente,
--			paciente.IPNOMCOMP as Paciente,
--			ep.CUV,
----			Estados - Trazabilidad de validación de RIPS
----1 - FEV validada Servicios DIAN - En petición para validación por servicio del ministerio
----2 - Generación código CUV validado por servicio del ministerio
----3 - Validaciones generadas desde servicio del ministerio
----99 - Unexpected Token - Validación credenciales de acceso al SISPRO
--			case ep.StatusRIPS when 1 then 'Registrado' when 2 then 'Validado' when 3 then 'Invalido' when 99 then 'Erroneo' end as EstadoRIPS,
			
--			er.sendDate as FechaValidación,
--			--ep.EntityId,
--			--ep.EntityName,
--			--er.CosmoDBId,
--			i.AdmissionNumber  as Ingreso,
--			--cp.Code AS CareGroupCode,
--			--cp.Name AS CareGroupName, 
--			erd.creationdate as FechaValidaciónDetalle,
--			ERD.mESSAGEcODE AS CodigoMensaje ,Message as Mensaje ,erd.path as Ruta, typemessage as TipoMensaje,
--			PE.Fullname AS UsuarioFactura
--	from Billing.ElectronicsProperties ep with (nolock)
--	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
--	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=ep.id	
--	JOIN Billing.Invoice i with (nolock) on ep.EntityId = i.Id
--	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
--	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
--	LEFT JOIN dbo.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
--	LEFT JOIN Security.[User] AS US WITH (NOLOCK) ON US.UserCode=I.InvoicedUser
--	LEFT JOIN Security.[Person] AS PE WITH (NOLOCK) ON PE.ID=US.IdPerson
--	where ep.EntityName = 'Invoice' and i.InvoiceDate>='01/01/2025' and Message like '%accessToken%' and i.Status <>'2' --and erd.path is not null 
--	--and erd.path <>'' --and i.InvoiceNumber='NEV1308946'
--union all
		select 
			--er.Id,
			--i.OperatingUnitId OperativeUnitId,
			ou.UnitName as UnidadOperativa,
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
			erd.creationdate as FechaValidaciónDetalle,
			ERD.mESSAGEcODE AS CodigoMensaje ,Message as Mensaje ,erd.path as Ruta, typemessage as TipoMensaje,
			PE.Fullname AS UsuarioFactura,  i.InitialDate as FechaIngreso,i.OutputDate as FechaEgreso
	from Billing.ElectronicsProperties ep with (nolock)
	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.creationdate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM Billing.ElectronicsRIPSDetail as erd with (nolock)
			where ERD.mESSAGEcODE <> '-999'
			group by ElectronicsRIPSId) AS erd1 on ERD1.ElectronicsRIPSId=EP.ID
	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.creationdate,'yyyy-MM-dd HH:mm')=Fecha	
	JOIN Billing.Invoice i with (nolock) on ep.EntityId = i.Id
	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
	LEFT JOIN dbo.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
	LEFT JOIN Security.[User] AS US  ON US.UserCode=I.InvoicedUser
	LEFT JOIN Security.[Person] AS PE  ON PE.ID=US.IdPerson
	where ep.EntityName = 'Invoice' and i.InvoiceDate>='04/01/2025' and ERD.mESSAGEcODE like '%-99%' and i.Status <>'2' --and erd.path is not null 
	--and erd.path <>'' --and i.InvoiceNumber='NEV1308946

	union all

			select 
			--er.Id,
			--i.OperatingUnitId OperativeUnitId,
			ou.UnitName as UnidadOperativa,
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
			erd.creationdate as FechaValidaciónDetalle,
			ERD.mESSAGEcODE AS CodigoMensaje ,Message as Mensaje ,erd.path as Ruta, typemessage as TipoMensaje,
			PE.Fullname AS UsuarioFactura,  i.InitialDate as FechaIngreso,i.OutputDate as FechaEgreso
	from Billing.ElectronicsProperties ep with (nolock)
	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.creationdate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM Billing.ElectronicsRIPSDetail as erd with (nolock)
			where ERD.mESSAGEcODE <> '-999'
			group by ElectronicsRIPSId) AS erd1 on ERD1.ElectronicsRIPSId=EP.ID
	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.creationdate,'yyyy-MM-dd HH:mm')=Fecha	
	JOIN Billing.Invoice i with (nolock) on ep.EntityId = i.Id
	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
	LEFT JOIN dbo.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
	LEFT JOIN Security.[User] AS US  ON US.UserCode=I.InvoicedUser
	LEFT JOIN Security.[Person] AS PE  ON PE.ID=US.IdPerson
	where ep.EntityName = 'Invoice' and i.InvoiceDate>='04/01/2025' and ERD.mESSAGEcODE = '99' and i.Status <>'2' --and erd.path is not null 
	--and erd.path <>'' --and i.InvoiceNumber='NEV1308946
	
	) as a
	where EstadoRIPS<>'Validado' and CodigoMensaje not like 'CF%' --and UnidadOperativa='Florencia'
	group by UnidadOperativa,	NroFactura,	FechaFactura,	Nit,	Entidad,	DocumentoPaciente,	Paciente,	CUV,	EstadoRIPS,	FechaValidación,
	Ingreso,	FechaValidaciónDetalle,	CodigoMensaje,	Mensaje,	Ruta,	TipoMensaje,	UsuarioFactura,  FechaIngreso, FechaEgreso
	--order by FechaFactura desc
