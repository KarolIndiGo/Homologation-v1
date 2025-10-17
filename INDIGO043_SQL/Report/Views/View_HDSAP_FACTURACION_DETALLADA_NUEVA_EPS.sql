-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURACION_DETALLADA_NUEVA_EPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0
















CREATE VIEW [Report].[View_HDSAP_FACTURACION_DETALLADA_NUEVA_EPS]
AS


  SELECT 
     I.InvoiceDate AS 'FECHA',
    '891180134' 'NIT',
	'415510047901' 'CODIGO HABILITACIÓN',	
	FORMAT(I.InvoiceDate, 'dd/MM/yyyy') AS 'FECHA DE FACTURA',
	i.InvoiceNumber 'NUMERO DE FACTURA',
	i.cufe CUFE,
	LEFT(i.InvoiceNumber, 4) 'PREFIJO DE LA FACTURA',
	SUBSTRING(i.InvoiceNumber, 5, LEN(i.InvoiceNumber) - 4) 'CONSECUTIVO DE LA FACTURA',
	CASE HA.CODE WHEN 'E0116' THEN '01-01-02-00230-2019-NUEVA EPS CONTRIBUTIVO'
	WHEN 'E0117' THEN '01-01-02-00230-2019-NUEVA EPS SUBSIDIADO'
	END 'NUMERO DE CONTRATO',
	cast(i.TotalInvoice as INT )	AS [VALOR BRUTO FACTURA],
						   cast(i.TotalInvoice - id.SubTotalPatientSalesPrice as INT ) AS [VALOR NETO FACTURA],
						   ISNULL(BD.Code,0) [NUMERO DE NOTA CREDITO],
						   ISNULL(CAST(BDN.BillingValue AS INT), 0) AS [VALOR NOTA CREDITO],			  					   						   
						   CASE PAC.IPTIPODOC
                            when	1	then	'CC'
							when	2	then	'CE'
							when	3	then	'TI'
							when	4	then	'RC'
							when	5	then	'PA'
							when	6	then	'AS'
							when	7	then	'MS'
							when	8	then	'NU'
							when	9	then	'CN'
							when	10	then	'CD'
							when	11	then	'SC'
							when	12	then	'PE'
							when	13	then	'PT'
							when	14	then	'DE'
							when	15	then	'SI'
							when	97	then	'NI'
						    END AS [Tipo Documento],
						 PAC.IPCODPACI [NUMERO DOCUMENTO],
						CASE 
						WHEN ID.SubTotalPatientSalesPrice = 4500 THEN CONVERT(INT, ID.SubTotalPatientSalesPrice) 
						WHEN ID.SubTotalPatientSalesPrice = 18200 THEN CONVERT(INT, ID.SubTotalPatientSalesPrice) 
						WHEN ID.SubTotalPatientSalesPrice = 47700 THEN CONVERT(INT, ID.SubTotalPatientSalesPrice) 
						ELSE 0
					    END AS 'CUOTA MODERADORA',
						
						 CASE 
						WHEN ID.SubTotalPatientSalesPrice NOT IN (4500, 18200, 47700) 
						THEN CONVERT(INT, ID.SubTotalPatientSalesPrice)
						ELSE 0
					    END AS 'COPAGO',
						i.OutputDiagnosis AS 'CODIGO DEL DIAGNOSTICO',
						 FORMAT(ING.IFECHAING, 'dd/MM/yyyy') AS 'FECHA INGRESO',
						 FORMAT(i.OutputDate, 'dd/MM/yyyy') AS 'FECHA EGRESO',
						 ISNULL(LEFT(SOD.AuthorizationNumber, 9), '') AS 'AUTORIZACION',
						CASE 
						WHEN ipr.code LIKE '%DM%' 
						THEN 'Insumos' 
						WHEN SOD.RecordType = '1'
						THEN 'Procedimiento' 
						WHEN SOD.RecordType = '2' 
						THEN 'Medicamento'
					    END AS [TIPO SERVICIO],
                         ISNULL(IPR.Code,CUPS.Code) AS [CODIGO DEL SERVICIO FACTURADO],
						 ISNULL(IPR.Code,CUPS.Code) AS 'CODIGO DEL SERVICIO CONTRATADO',
						 ISNULL(IPR.Name,CUPS.Description)AS [DECRIPCION DEL SERVICIO],
						 ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity) 'CANTIDAD',
						 CAST(FLOOR(ISNULL(IDS.TotalSalesPrice, ID.GrandTotalSalesPrice + Id.ThirdPartyDiscount) / ISNULL(IDS.InvoicedQuantity, ID.InvoicedQuantity)) AS NUMERIC(20,0)) AS 'VALOR UNITARIO',
						 CAST(ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) AS NUMERIC(20,0)) 'VALOR TOTAL',
						 '0' AS [VALOR IVA]


 FROM Billing.Invoice AS I WITH (NOLOCK)
  INNER JOIN Billing.InvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId =I.Id 
  INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id =ID.ServiceOrderDetailId
  INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId 
  INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = SOD.PerformsFunctionalUnitId
  INNER JOIN Payroll.CostCenter AS COST WITH (NOLOCK) ON COST.Id =SOD.CostCenterId
  INNER JOIN dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
  INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
  INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
  INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
  LEFT JOIN Billing.BillingNoteDetail BDN ON BDN.InvoiceId = I.ID
  LEFT JOIN Billing.BillingNote BD ON BD.ID = BDN.BillingNoteId
  LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
  LEFT JOIN Billing.BillingConcept AS BCT WITH (NOLOCK) ON CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = SOD.ProductId
  LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI WITH (NOLOCK) ON GLI.Id = IPR.IVAId
  LEFT JOIN Inventory.ProductGroup PG WITH (NOLOCK) ON PG.Id = IPR.ProductGroupId
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR WITH (NOLOCK) ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD WITH (NOLOCK) ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI WITH (NOLOCK) ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI WITH (NOLOCK) ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED WITH (NOLOCK) ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED WITH (NOLOCK) ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT WITH (NOLOCK) ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS WITH (NOLOCK) ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
  LEFT JOIN Contract .IPSService AS IPS WITH (NOLOCK) ON IPS.Id =IDS.IPSServiceId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX WITH (NOLOCK) ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX WITH (NOLOCK) ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC WITH (NOLOCK)  ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC WITH (NOLOCK) ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
  LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = SO.CreationUser 
  LEFT JOIN Billing.InvoiceCategories ICT WITH (NOLOCK) ON ICT.Id = I.InvoiceCategoryId
  LEFT JOIN DBO.ADTIPOIDENTIFICA AS TIPA WITH (NOLOCK) ON TIPA.ID=PAC.IPTIPODOC
  LEFT JOIN Contract.HealthAdministrator AS HA  ON HA.Id = I.HealthAdministratorId
  LEFT JOIN Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = SOD.IPSServiceId
  LEFT JOIN Billing.BillingGroup AS BG  ON BG.Id = CUPS.BillingGroupId
  LEFT JOIN dbo.INUBICACI AS BB  ON BB.AUUBICACI = PAC.AUUBICACI 
  LEFT JOIN dbo.INMUNICIP AS EE  ON EE.DEPMUNCOD = BB.DEPMUNCOD
  LEFT JOIN Contract.SurgicalGroup AS GQ  ON IPS.SurgicalGroupId = GQ.Id
  LEFT JOIN dbo.INDIAGNOS AS DIAG  ON DIAG.CODDIAGNO = ISNULL(ING.CODDIAEGR,ING.CODDIAING)
  LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = i.AnnulmentUser
  LEFT JOIN Billing.BillingReversalReason ON I.ReversalReasonId = Billing.BillingReversalReason.Id
  where  ha.code IN ('E0117', 'E0116') 
    AND i.Status = 1 
    AND id.TotalSalesPrice > 0  
  ---AND i.InvoiceNumber IN ('HSPE692118','HSPE693117');


