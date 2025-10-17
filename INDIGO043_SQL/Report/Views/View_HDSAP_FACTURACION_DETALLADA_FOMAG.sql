-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURACION_DETALLADA_FOMAG
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_FACTURACION_DETALLADA_FOMAG]
AS

 
WITH CTE_FACTURACION_UNICA
AS
(
  SELECT  JVT.Code 'CODIGO COMPROBANTE', JVT.Description 'COMPROBANTE CONTABLE',JV.Consecutive 'CONSECUTIVO CONTABLE',JV.EntityCode, JV.EntityId,
	 CAST(JV.VoucherDate AS DATE) VoucherDate, CAST(sum(JVD.CreditValue) as numeric) Valor_Credito,
	 AdmissionNumber
  FROM 
	 GeneralLedger.JournalVouchers JV WITH (NOLOCK)
	 INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger.JournalVoucherTypes JVT WITH (NOLOCK) ON JVT.Id = JV.IdJournalVoucher
	 INNER JOIN Billing.Invoice AS F WITH (NOLOCK) ON F.Id =JV.EntityId
	WHERE 
	 JV.LegalBookId =1 AND 
	 jv.EntityName ='Invoice' AND 
	 F.DocumentType <> 5 AND 
	 IdJournalVoucher = 27
	GROUP BY JVT.Code, JV.Consecutive, JVT.Description, JV.EntityCode, JV.EntityId,CAST(JV.VoucherDate AS DATE),AdmissionNumber
),
 
CTE_ALTA_MEDICA
AS
(
  	SELECT  EGR.NUMINGRES 'INGRESO',EGR.IPCODPACI 'IDENTIFICACION', EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM 
	 HCREGEGRE EGR WITH (NOLOCK)
	 INNER JOIN (SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA' 
	             FROM DBO.HCREGEGRE EGR WITH (NOLOCK) INNER JOIN CTE_FACTURACION_UNICA AS ING  ON EGR.NUMINGRES=ING.AdmissionNumber 
				 GROUP BY EGR.NUMINGRES,EGR.IPCODPACI)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC
 
)
 
SELECT                     
                           '891180134' NIT,
						   LEFT(i.InvoiceNumber, 4) 'PREFIJO DE LA FACTURA',
						   SUBSTRING(i.InvoiceNumber, 5, LEN(i.InvoiceNumber) - 4) 'CONSECUTIVO DE LA FACTURA',
						   PAC.IPCODPACI 'num. documento',
						  ISNULL(IPR.Code,ServiciosIPS.Code) AS CódigoServicio,
						 ISNULL(IPR.Name,ServiciosIPS.Name)AS DescripciónServicio,	
						 ING.IFECHAING 'FECHA INICIO',
						 ING.FECHEGRESO 'FIN SERVICIO',
						 ' ' 'Plan',
						 ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice) AS 'VALOR UNITARIO',
						 SOD.InvoicedQuantity AS CANTIDAD,
						 '' 'Cuota Moderadora',
						 '' 'Iva',
						 '' Debito,
						 '' Credito,
						 ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice * SOD.InvoicedQuantity) AS 'VALOR TOTAL',
						 '' Nap,
						 '' Anticipo,
						 '' Descuento,
						 diag.CODDIAGNO AS 'CODIGO DEL DIAGNOSTICO',
						 diag.NOMDIAGNO 'NOMBRE DIAGNOSTICO',
						 gf.name AS 'Ambito',
						 CONCAT(PAC.IPPRINOMB,IPSEGNOMB)NOMBRES,
						 CONCAT(PAC.IPPRIAPEL,IPSEGAPEL)APELLIDOS,
						  CASE PAC.IPTIPODOC
                             WHEN '1'
                             THEN 'CC'
                             WHEN '2'
                             THEN 'CE '
                             WHEN '3'
                             THEN 'TI'
                             WHEN '4'
                             THEN 'RC'
                             WHEN '5'
                             THEN 'PA'
                             WHEN '6'
                             THEN 'AS'
                             WHEN '7'
                             THEN 'MS'
                             WHEN '8'
                             THEN 'NU'
                         END AS [Tipo Documento],
						 RC.RadicatedConsecutive NumeroRadicado,
						 RC.DocumentDate FechaRadicación,
						  CASE SOD.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS ServiciosMedicamentos,
						  ict.Name Categoria

						
 
 
FROM
     Billing.Invoice AS I 
	 INNER JOIN CTE_FACTURACION_UNICA AS UNI  ON UNI.EntityId =I.Id
	 INNER JOIN Portfolio.RadicateInvoiceD rd on rd.InvoiceNumber = i.InvoiceNumber
	 INNER JOIN Portfolio.RadicateInvoiceC RC ON RC.ID = RD.RadicateInvoiceCId
     INNER JOIN Billing.InvoiceDetail AS ID  ON ID.InvoiceId = I.Id 
	 INNER JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id = ID.ServiceOrderDetailId
	 INNER JOIN Billing.ServiceOrder AS SO  ON SO.Id = SOD.ServiceOrderId 
	 INNER JOIN dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
     INNER JOIN Common.ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
     INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
  LEFT JOIN dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR
  LEFT JOIN Contract.HealthAdministrator AS HA  ON HA.Id = I.HealthAdministratorId
  LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId
  LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
  LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = SOD.ProductId
  LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI WITH (NOLOCK) ON GLI.Id = IPR.IVAId
  LEFT JOIN Inventory.ProductGroup PG WITH (NOLOCK) ON PG.Id = IPR.ProductGroupId
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR WITH (NOLOCK) ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD WITH (NOLOCK) ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = SOD.IPSServiceId
  LEFT JOIN Billing.BillingGroup AS gf  ON gf.Id = CUPS.BillingGroupId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI WITH (NOLOCK) ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI WITH (NOLOCK) ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED WITH (NOLOCK) ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED WITH (NOLOCK) ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT WITH (NOLOCK) ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS WITH (NOLOCK) ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
  LEFT JOIN Contract .IPSService AS IPS WITH (NOLOCK) ON IPS.Id =IDS.IPSServiceId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX WITH (NOLOCK) ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX WITH (NOLOCK) ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN CTE_ALTA_MEDICA AS ALT ON ALT.INGRESO =I.AdmissionNumber 

  where  ha.code in ('EA0534') --and i.InvoiceNumber = 'hspe201389';
