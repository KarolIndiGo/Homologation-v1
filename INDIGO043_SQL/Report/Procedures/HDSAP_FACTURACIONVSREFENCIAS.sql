-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HDSAP_FACTURACIONVSREFENCIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE PROCEDURE [Report].[HDSAP_FACTURACIONVSREFENCIAS]  
	@FechaIni datetime='20190101'
AS

	SELECT  distinct
	    rtrim(F.PatientCode) DocumentoPaciente,F.InvoiceNumber AS Factura,CASE WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal,
	    CUPS.Code AS CUPS, ServiciosIPS.Code AS Código, ServiciosIPS.Name AS Descripción,
		
		dos.InvoicedQuantity AS Cantidad, 
		
			DATENAME(MONTH,F.InvoiceDate) + '/' + DATENAME(YEAR,F.InvoiceDate) AS MesFactura,
			ServiciosIPS.Code AS Código,  F.InvoiceDate
	FROM Billing.Invoice AS F  INNER JOIN
		Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id INNER JOIN
		Security.[User] AS u  ON u.UserCode = F.InvoicedUser INNER JOIN
		Security.Person AS per  ON per.Id = u.IdPerson INNER JOIN
		dbo.ADINGRESO AS ing  ON ing.NUMINGRES = F.AdmissionNumber INNER JOIN
		dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode INNER JOIN
		Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
		Common.ThirdParty AS t  ON t.Id = F.ThirdPartyId INNER JOIN
		Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId left JOIN
		Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId INNER JOIN
		Billing.InvoiceCategories AS cat  ON cat.Id = F.InvoiceCategoryId LEFT OUTER JOIN
		Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
		Contract.SurgicalGroup AS GQ  ON ServiciosIPS.SurgicalGroupId = GQ.Id LEFT OUTER JOIN
		Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId LEFT OUTER JOIN
		dbo.INPROFSAL AS med  ON med.CODPROSAL = dos.PerformsHealthProfessionalCode LEFT OUTER JOIN
		dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1 LEFT OUTER JOIN
		dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR LEFT OUTER JOIN
		dbo.HCREGEGRE AS salida  ON salida.NUMINGRES = F.AdmissionNumber LEFT OUTER JOIN
		Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' LEFT OUTER JOIN
		dbo.INPROFSAL AS medqx  ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode LEFT OUTER JOIN
		dbo.INESPECIA AS espqx  ON espqx.CODESPECI = medqx.CODESPEC1 LEFT OUTER JOIN
		Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
		Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
		Billing.ServiceOrder AS os  ON os.Id = dos.ServiceOrderId LEFT OUTER JOIN
		Contract.CUPSEntity AS CUPS  ON CUPS.Id = dos.CUPSEntityId LEFT OUTER JOIN
		Billing.BillingGroup AS gf  ON gf.Id = CUPS.BillingGroupId LEFT OUTER JOIN
		dbo.INUBICACI AS BB  ON BB.AUUBICACI = P.AUUBICACI LEFT OUTER JOIN
		dbo.INMUNICIP AS EE  ON EE.DEPMUNCOD = BB.DEPMUNCOD LEFT OUTER JOIN
		Payroll.CostCenter AS cc  ON dos.CostCenterId = cc.Id
				
	WHERE  (F.Status = '1') AND (ing.CODCENATE = '001') AND (dos.IsDelete = '0') AND (dos.IsDelete = '0') AND (F.DocumentType IN ('1', '2', '3', '4', '5', '6', '7'))
			AND cc.Code='8001' AND F.InvoiceDate>=@FechaIni --AND F.InvoiceDate<'20190101' 
	ORDER BY InvoiceDate;

