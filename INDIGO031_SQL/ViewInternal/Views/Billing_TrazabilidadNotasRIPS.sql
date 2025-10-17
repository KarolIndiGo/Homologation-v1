-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_TrazabilidadNotasRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create view [ViewInternal].[Billing_TrazabilidadNotasRIPS] as
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
		ERD.mESSAGEcODE AS CodigoMensaje ,Message as Mensaje, erd.path as Ruta, typemessage as TipoMensaje,
		pn.code as NotaCartera,
			PE.Fullname AS UsuarioNotaCartera, i.OutputDate as FechaEgresoFactura,   CASE
                WHEN AC.PortfolioStatus = '1'
                THEN 'SINRADICAR'
                WHEN AC.PortfolioStatus = '2'
                THEN 'RADICADA SIN CONFIRMAR'
                WHEN AC.PortfolioStatus = '3'
                THEN 'RADICADA ENTIDAD'
                WHEN AC.PortfolioStatus = '7'
                THEN 'CERTIFICADA_PARCIAL'
                WHEN AC.PortfolioStatus = '8'
                THEN 'CERTIFICADA_TOTAL'
                WHEN AC.PortfolioStatus = '14'
                THEN 'DEVOLUCION_FACTURA'
                WHEN AC.PortfolioStatus = '15'
                THEN 'TRASLADO_COBRO_JURIDICO'
            END AS EstadoFactura
	from Billing.ElectronicsProperties ep with (nolock)
	JOIN Billing.ElectronicsRIPS er with (nolock) on ep.Id = er.ElectronicsPropertiesId
	JOIN (SELECT max(format(erd.creationdate,'yyyy-MM-dd HH:mm')) as Fecha, ElectronicsRIPSId
			FROM Billing.ElectronicsRIPSDetail as erd with (nolock)
			group by ElectronicsRIPSId) AS erd1 on ERD1.ElectronicsRIPSId=EP.ID
	JOIN Billing.ElectronicsRIPSDetail as erd with (nolock) on erd.ElectronicsRIPSId=erd1.ElectronicsRIPSId and format(erd.creationdate,'yyyy-MM-dd HH:mm')=Fecha	
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
	LEFT JOIN Portfolio.AccountReceivable AS AC WITH (NOLOCK) ON AC.InvoiceNumber=I.InvoiceNumber
	where ep.EntityName = 'BillingNote' AND ERD.mESSAGEcODE<>'00' --AND ep.StatusRIPS<>'2' --and  i.Status <>'2' 