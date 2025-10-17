-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Billing_TrazabilidadRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[IMO_Billing_TrazabilidadRIPS]    Script Date: 10/02/2025 5:42:40 p. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO



CREATE view [ViewInternal].[IMO_Billing_TrazabilidadRIPS] as
	
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
			PE.Fullname AS UsuarioFactura
	from Billing.ElectronicsProperties ep with (nolock)
	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.creationdate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM Billing.ElectronicsRIPSDetail as erd with (nolock)
			group by ElectronicsRIPSId) AS erd1 on ERD1.ElectronicsRIPSId=EP.ID
	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.creationdate,'yyyy-MM-dd HH:mm')=Fecha	
	JOIN Billing.Invoice i with (nolock) on ep.EntityId = i.Id
	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
	LEFT JOIN dbo.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
	LEFT JOIN Security.[User] AS US  ON US.UserCode=I.InvoicedUser
	LEFT JOIN Security.[Person] AS PE  ON PE.ID=US.IdPerson
	where ep.EntityName = 'Invoice' and i.InvoiceDate>='01/01/2025' and typemessage IN ('RECHAZADO','ERROR') and i.Status <>'2' --and erd.path is not null 
	--and erd.path <>'' 
	--and 	i.InvoiceNumber in ('KE248381','KE248380','KE248382')
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
			PE.Fullname AS UsuarioFactura
	from Billing.ElectronicsProperties ep with (nolock)
	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.creationdate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM Billing.ElectronicsRIPSDetail as erd with (nolock)
			group by ElectronicsRIPSId) AS erd1 on ERD1.ElectronicsRIPSId=EP.ID
	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.creationdate,'yyyy-MM-dd HH:mm')=Fecha	
	JOIN Billing.Invoice i with (nolock) on ep.EntityId = i.Id
	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
	LEFT JOIN dbo.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
	LEFT JOIN Security.[User] AS US  ON US.UserCode=I.InvoicedUser
	LEFT JOIN Security.[Person] AS PE  ON PE.ID=US.IdPerson
	where ep.EntityName = 'Invoice' and i.InvoiceDate>='01/01/2025' and Message like '%accessToken%' and i.Status <>'2'  --and erd.path is not null 
	--and erd.path <>'' --and i.InvoiceNumber='NEV1308946'
