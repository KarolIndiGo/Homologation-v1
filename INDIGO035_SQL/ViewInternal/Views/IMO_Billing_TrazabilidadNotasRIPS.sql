-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Billing_TrazabilidadNotasRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




create view [ViewInternal].[IMO_Billing_TrazabilidadNotasRIPS] as
select 
		--er.Id,
		--i.OperatingUnitId OperativeUnitId,
		--ep.EntityId DocumentTypeId,
		--ep.EntityName DocumentType,
		ou.UnitName as UnidadOperativa,
		case bn.Nature when  1 then 'Debito' when 2 then 'Credito' end as Naturaleza,
		bn.Code  as NotaRIPS,
		bn.NoteDate  as FechaNotaRIPS,
		i.invoicenumber as NroFactura,
		--i.ThirdPartyId ThirdPartyId,
		tp.Nit as Nit,
		tp.Name as Entidad,
		i.PatientCode as DocumentoPaciente, 
		paciente.IPNOMCOMP as Paciente,
		ep.CUV,
		case ep.StatusRIPS when 1 then 'Registrado' when 2 then 'Validado' when 3 then 'Invalido' when 99 then 'Erroneo' end as EstadoRIPS,
			er.sendDate as FechaValidación,
		--ep.EntityId,
		--ep.EntityName,
		--er.CosmoDBId,
		i.AdmissionNumber as Ingreso,
		--cp.Code AS CareGroupCode,
		--cp.Name AS CareGroupName
		Message as Mensaje, erd.path as Ruta, typemessage as TipoMensaje,
		pn.code as NotaCartera,
			PE.Fullname AS UsuarioNotaCartera
	from Billing.ElectronicsProperties ep with (nolock)
	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=ep.id	
	JOIN Billing.BillingNote bn with (nolock) on ep.EntityId = bn.Id
	JOIN Billing.BillingNoteDetail bnd with (nolock) on bnd.BillingNoteId = bn.Id
	JOIN Billing.Invoice i with (nolock) on bnd.InvoiceId = i.Id
	JOIN Common.OperatingUnit AS OU with (nolock) ON OU.ID=i.OperatingUnitId
	JOIN Common.ThirdParty tp with (nolock) on i.ThirdPartyId = tp.Id
	JOIN DBO.INPACIENT paciente with (nolock) on i.PatientCode = paciente.IPCODPACI
	--LEFT JOIN Contract.CareGroup AS cp with (nolock) ON i.CareGroupId = cp.Id
	LEFT JOIN Portfolio.PortfolioNote PN with (nolock) ON PN.ID=BN.EntityId
	LEFT JOIN Security.[User] AS US  ON US.UserCode=pn.CreationUser
	LEFT JOIN Security.[Person] AS PE  ON PE.ID=US.IdPerson
	where ep.EntityName = 'BillingNote' 