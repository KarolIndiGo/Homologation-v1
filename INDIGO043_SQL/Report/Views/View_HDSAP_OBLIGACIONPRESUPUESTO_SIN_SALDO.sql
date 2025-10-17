-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_OBLIGACIONPRESUPUESTO_SIN_SALDO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_OBLIGACIONPRESUPUESTO_SIN_SALDO]
   
AS

SELECT	        case o.Status
                when 1
				then 'Registrado'
				when 2
				then 'Confirmado'
				when 3
				then 'Anulado'
				end Estado,
				o.Code [Código Obligacion],
				o.DocumentDate Fecha,
				o.Document Documento,
				o.Observations Observaciones,
				c.code [Código Compromiso],
				a.code [Código Disponibilidad],
				tp.Nit,
				tp.Name Tercero,
				cat.Code CodigoRubro,
				cat.Name NombreRubro,
				od.TotalObligation,
	            od.ExecutedValue ValorEjecutado,
				concat(cpc.code, '-',cpc.name) CPC
		FROM Budget.Obligation o WITH (NOLOCK)
		JOIN Common.ThirdParty tp WITH (NOLOCK) ON o.ThirdPartyId = tp.Id
		JOIN Budget.ObligationDetail od WITH (NOLOCK) ON o.Id = od.ObligationId
		JOIN Budget.Obligation ob WITH (NOLOCK) ON od.ObligationId = ob.id
		JOIN Budget.CommitmentDetail cd WITH (NOLOCK) ON od.CommitmentDetailId = cd.id
		JOIN Budget.Commitment c WITH (NOLOCK) ON cd.CommitmentId = c.Id
		JOIN Budget.AvailabilityDetail ad WITH (NOLOCK) ON cd.AvailabilityDetailId = ad.id
		JOIN Budget.Availability a WITH (NOLOCK) ON ad.AvailabilityId = a.id
		left JOIN Budget.CPCCatalog cpc WITH (NOLOCK) ON cpc.id = ad.CPCCodeId
		JOIN Budget.Category cat WITH (NOLOCK) ON od.CategoryId = cat.Id
	WHERE o.[Status] = 2 and od.Balance > 0
