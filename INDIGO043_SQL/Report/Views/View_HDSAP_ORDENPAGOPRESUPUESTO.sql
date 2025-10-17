-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ORDENPAGOPRESUPUESTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[View_HDSAP_OrdenPagoPresupuesto]
   
AS

SELECT	
				po.Code [Código Orden Pago],
				po.DocumentDate Fecha,
				po.Document Documento,
				tp.Nit ,
				tp.Name Tercero,
				po.Observations Observaciones,
				ob.code [Código Obligación],
				c.Code [Código Compromiso],
				a.code [Código Disponibilidad],
				CASE po.Status 
					WHEN 1 THEN 'Registrado' 
					WHEN 2 THEN 'Confirmado' 
					WHEN 3 THEN 'Anulado' 
				END Estado,
				cat.Code Codigo ,
				cat.Name Rubro,
				concat (fs.code, '-', fs.name) As Recurso,
                concat (rt.Code, '_', rt.Name) as Tipo,
				pod.InitialValue,
				ISNULL(rr.DebitValue, 0) DebitValue,
				ISNULL(rr.CreditValue, 0) CreditValue,
				pod.InitialValue - ISNULL(rr.DebitValue, 0) + ISNULL(rr.CreditValue, 0) TotalValue,
				concat(cpc.code, '-',cpc.name) CPC
		FROM Budget.PaymentOrder po WITH (NOLOCK)
		JOIN Common.ThirdParty tp WITH (NOLOCK) ON po.ThirdPartyId = tp.Id
		JOIN Budget.PaymentOrderDetail pod WITH (NOLOCK) ON po.Id = pod.PaymentOrderId
		JOIN Budget.ObligationDetail od WITH (NOLOCK) ON pod.ObligationDetailId = od.Id
		JOIN Budget.Obligation ob WITH (NOLOCK) ON od.ObligationId = ob.id
		JOIN Budget.CommitmentDetail cd WITH (NOLOCK) ON od.CommitmentDetailId = cd.id
		JOIN Budget.Commitment c WITH (NOLOCK) ON cd.CommitmentId = c.Id
		JOIN Budget.AvailabilityDetail ad WITH (NOLOCK) ON cd.AvailabilityDetailId = ad.id
		JOIN Budget.Availability a WITH (NOLOCK) ON ad.AvailabilityId = a.id
		JOIN Budget.CPCCatalog cpc WITH (NOLOCK) ON cpc.id = ad.CPCCodeId
		JOIN Budget.Category cat WITH (NOLOCK) ON od.CategoryId = cat.Id
		JOIN Budget.FinancialSource fs WITH (NOLOCK) ON cat.FinancialSourceId = fs.Id
		JOIN Budget.RevenueType rt WITH (NOLOCK) ON od.RevenueTypeId = rt.Id
		LEFT JOIN Common.GetEntityNameDescriptions() gend ON po.EntityName = gend.EntityName
		LEFT JOIN 
		(
			SELECT rrd.PaymentOrderDetailId, SUM(rrd.Value) DebitValue, 0 CreditValue
			FROM Budget.ReimbursementResource rr WITH (NOLOCK)
			JOIN Budget.ReimbursementResourceDetaill rrd WITH (NOLOCK) ON rr.Id = rrd.ReimbursementResourceId
			WHERE rr.Status = 2 
			GROUP BY rrd.PaymentOrderDetailId
		) rr ON pod.Id = rr.PaymentOrderDetailId 
