-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_BILLING_TRAZABILIDADNOTASRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.IMO_Billing_TrazabilidadNotasRIPS
AS

select 
		--er.Id,
		--i.OperatingUnitId OperativeUnitId,
		--ep.EntityId DocumentTypeId,
		--ep.EntityName DocumentType,
		OU.UnitName as UnidadOperativa,
		case bn.Nature when  1 then 'Debito' when 2 then 'Credito' end as Naturaleza,
		bn.Code  as NotaRIPS,
		bn.NoteDate  as FechaNotaRIPS,
		i.InvoiceNumber as NroFactura,
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
		erd.Message as Mensaje, erd.Path as Ruta, erd.TypeMessage as TipoMensaje,
		PN.Code as NotaCartera,
			PE.Fullname AS UsuarioNotaCartera
	from [INDIGO035].[Billing].[ElectronicsProperties] ep 
	JOIN [INDIGO035].[Billing].[ElectronicsRIPS] er  on ep.Id = er.ElectronicsPropertiesId
	JOIN [INDIGO035].[Billing].[ElectronicsRIPSDetail] as erd  on erd.ElectronicsRIPSId=ep.Id	
	JOIN [INDIGO035].[Billing].[BillingNote] bn  on ep.EntityId = bn.Id
	JOIN [INDIGO035].[Billing].[BillingNoteDetail] bnd  on bnd.BillingNoteId = bn.Id
	JOIN [INDIGO035].[Billing].[Invoice] i  on bnd.InvoiceId = i.Id
	JOIN [INDIGO035].[Common].[OperatingUnit] AS OU  ON OU.Id=i.OperatingUnitId
	JOIN [INDIGO035].[Common].[ThirdParty] tp  on i.ThirdPartyId = tp.Id
	JOIN [INDIGO035].[dbo].[INPACIENT] paciente  on i.PatientCode = paciente.IPCODPACI
	--LEFT JOIN Contract.CareGroup AS cp  ON i.CareGroupId = cp.Id
	LEFT JOIN [INDIGO035].[Portfolio].[PortfolioNote] PN  ON PN.Id=bn.EntityId
	LEFT JOIN [INDIGO035].[Security].[UserInt] AS US  ON US.UserCode=PN.CreationUser
	LEFT JOIN [INDIGO035].[Security].[PersonInt] AS PE  ON PE.Id=US.IdPerson
	where ep.EntityName = 'BillingNote' 
