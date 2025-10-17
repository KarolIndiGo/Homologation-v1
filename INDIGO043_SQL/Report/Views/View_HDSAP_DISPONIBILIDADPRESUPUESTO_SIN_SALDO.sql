-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_DISPONIBILIDADPRESUPUESTO_SIN_SALDO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_DISPONIBILIDADPRESUPUESTO_SIN_SALDO]
   
AS

SELECT	
				a.Code Código,
				cpc.Code CodigoCPC,
				cpc.Name NombreCPC,
				cn.Code CódigoCompromiso,
				a.DocumentDate Fecha,
				a.ExpirationDate FechaVencimiento,
				CASE a.AvailabilityType 
					WHEN 1 THEN 'Ninguno' 
					WHEN 2 THEN 'Disponibilidad' 
					WHEN 3 THEN 'Vigencia Factura'
					ELSE 'N/A'
				END TipoDisponibilidad ,
				a.Observations Observaciones ,
				CASE a.Status 
					WHEN 1 THEN 'Registrado' 
					WHEN 2 THEN 'Confirmado' 
					WHEN 3 THEN 'Anulado' 
					ELSE 'N/A'
				END Estado,
				cat.Code CódigoRubro,
				cat.Name NombreRubro,
				fs.Code CodigoRecurso,
				fs.Name NombreRecurso,
				rt.Code TipoCodigo,
				rt.Name TipoNombre,				
				ad.InitialValue ValorInicial,
				ISNULL(am.DebitValue, 0) ValorDebito,
				ISNULL(am.CreditValue, 0) ValorCredito,
				ad.InitialValue - ISNULL(am.DebitValue, 0) + ISNULL(am.CreditValue, 0) Total,
				ISNULL(cn.ExecutedValue, 0) ValorEjecutado,
				ad.InitialValue - ISNULL(am.DebitValue, 0) + ISNULL(am.CreditValue, 0) - ISNULL(cn.ExecutedValue, 0) Saldo
	FROM Budget.Availability a WITH (NOLOCK)
	JOIN Budget.AvailabilityDetail ad WITH (NOLOCK) ON a.Id = ad.AvailabilityId
	JOIN Budget.CPCCatalog cpc on cpc.id = ad.CPCCodeId
	JOIN Budget.Budget b WITH (NOLOCK) ON ad.BudgetId = b.Id
	JOIN Budget.Category cat WITH (NOLOCK) ON b.CategoryId = cat.Id
	JOIN Budget.FinancialSource fs WITH (NOLOCK) ON cat.FinancialSourceId = fs.Id
	JOIN Budget.RevenueType rt WITH (NOLOCK) ON b.RevenueTypeId = rt.Id

		/************************************  MODIFICACIONES ************************************/
		LEFT JOIN 
		(
			SELECT	amd.AvailabilityDetailId, SUM(IIF(amd.Nature = 1, amd.Value, 0)) DebitValue, SUM(IIF(amd.Nature = 1, 0, amd.Value)) CreditValue
			FROM  Budget.AvailabilityModification am WITH (NOLOCK)
			JOIN  Budget.AvailabilityModificationDetail amd WITH (NOLOCK) ON am.Id = amd.AvailabilityModificationId
			WHERE am.Status = 2 
			GROUP BY amd.AvailabilityDetailId
		) am ON ad.Id = am.AvailabilityDetailId 

		/************************************** COMPROMISOS **************************************/
		LEFT JOIN 
		(
			SELECT	cd.AvailabilityDetailId, SUM(cd.InitialValue + ISNULL(cm.CreditValue, 0) - ISNULL(cm.DebitValue, 0)) ExecutedValue, ct.Code
			FROM  Budget.Commitment c WITH (NOLOCK)
			JOIN  Budget.CommitmentDetail cd WITH (NOLOCK) ON c.Id = cd.CommitmentId
			join Budget.Category ct WITH (NOLOCK) ON ct.Id = cd.CategoryId
			LEFT JOIN 
			(
				SELECT cmd.CommitmentDetailId, SUM(IIF(cmd.Nature = 1, cmd.Value, 0)) DebitValue, SUM(IIF(cmd.Nature = 1, 0, cmd.Value)) CreditValue
				FROM  Budget.CommitmentModification cm WITH (NOLOCK)
				JOIN  Budget.CommitmentModificationDetail cmd WITH (NOLOCK) ON cm.Id = cmd.CommitmentModificationId
				WHERE cm.Status = 2 
				GROUP BY cmd.CommitmentDetailId
			) cm ON cd.Id = cm.CommitmentDetailId
			WHERE c.Status = 2 
			GROUP BY cd.AvailabilityDetailId,
			         ct.Code
		) cn ON ad.Id = cn.AvailabilityDetailId 
	WHERE ad.balance > 0 and a.Status = 2
