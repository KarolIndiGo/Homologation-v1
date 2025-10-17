-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_FACTURACION_DETALLADA_MALLAMAS_DEP_HUILA
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_FACTURACION_DETALLADA_MALLAMAS_DEP_HUILA] 
 
@FecIni AS date,
@FecFin AS date

AS

DECLARE @TIPOFACTURA AS INT = 27;
 
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
	 CAST(JV.VoucherDate as date) BETWEEN @FecIni AND @FecFin AND
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
 
SELECT                      I.InvoiceNumber AS Factura,ICT.Name AS Categoría,case I.[Status] when '1' THEN 'Facturado' when '2' then 'Anulado' end as 'Estado'
						   , I.InvoiceDate AS FechaFactura, I.TotalInvoice AS TotalFactura, 
                         I.AdmissionNumber AS Ingreso, ing.IFECHAING AS FechaIngreso, 
                         CASE ing.ICAUSAING WHEN '1' THEN 'Heridos_en_combate' WHEN '2' THEN 'Enfermedad_profesional' WHEN '3' THEN 'Enfermedad_gral_adulto' WHEN '4' THEN 'Enfermedad_gral_pediatria' WHEN '5' THEN 'Odontología' WHEN
                          '6' THEN 'Accidente_transito' WHEN '7' THEN 'Catastrofe/Fisalud' WHEN '8' THEN 'Quemados' WHEN '9' THEN 'Maternidad' WHEN '10' THEN 'Accidente_Laboral' WHEN '11' THEN 'Cirugia_Programada' END AS [Causa de Ingreso],
                          CASE ing.TIPOINGRE WHEN '1' THEN 'Ambulatorio' WHEN '2' THEN 'Hospitalario' END AS Tipo_Ingreso, I.PatientCode AS Identificación,
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
						  PAC.IPNOMCOMP AS Paciente,DATEDIFF(YEAR, PAC.IPFECNACI,ing.IFECHAING) AS EdadAños, CG.Name AS GrupoAtención, TP.Nit,TP.Name as 'Tercero',  
                         HA.Code + ' - ' + HA.Name AS [Entidad Administradora], CASE SOD.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS ServiciosMedicamentos, 
						 ISNULL(IPR.Code,ServiciosIPS.Code) AS Código,
						 ISNULL(IPR.Name,ServiciosIPS.Name)AS Descripción,
 
                         CASE SOD.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS PresentacionServicio, 
						 IPS.Code AS Subcodigo, IPS.Name AS Subnombre, 
                         SOD.InvoicedQuantity AS Cantidad,
						 ID. SubTotalPatientSalesPrice As [Cuota Paciente],
						 ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice) AS ValorUnitario,
						-- CASE WHEN dq.TotalSalesPrice IS NULL THEN dos.TotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorUnitario, 
						 ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) 	AS ValorTotal,			 
						-- CASE WHEN dq.TotalSalesPrice IS NULL      THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal, 
						 FU.Code AS UnidadFuncional, FU.Name AS DescripcionUnidadFuncional, COST.Code + '-' + COST.Name AS CentroCosto,
 
                         ALT.[FECHA ALTA MEDICA] AS FechaAltaMedica, ing.CODDIAEGR AS CIE10, diag.NOMDIAGNO AS Diagnóstico, 
						 ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode))) AS CodigoMèdico,
 
						 --CASE WHEN dq.PerformsHealthProfessionalCode IS NULL 
       --                  THEN dos.PerformsHealthProfessionalCode ELSE dq.PerformsHealthProfessionalCode END AS CodigoMèdico, 
						 RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) AS NombreMedico,
 
						 --CASE WHEN rtrim(medqx.NOMMEDICO) IS NULL THEN med.NOMMEDICO ELSE rtrim(medqx.NOMMEDICO) 
       --                  END AS NombreMedico, 
						 ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) AS Especialidad,
 
						 --CASE WHEN espmed.DESESPECI IS NULL THEN espqx.DESESPECI ELSE espmed.DESESPECI END AS Especialidad, 
						 SO.Code AS Orden, CAST(SO.OrderDate AS DATE) AS FechaOrden, 
						 CASE SOD.SettlementType WHEN '3' THEN 'Si' ELSE 'No' END AS AplicaProcedimiento, 
						 CASE I.IsCutAccount WHEN 'True' THEN 'Si' ELSE 'No' END AS Corte,
						 SU.NOMUSUARI AS Usuario, gf.Name AS [Grupo Facturación], 
                         CUPS.Code AS CUPS, CUPS.Description AS [Descripcion CUPS], 
						 BB.UBINOMBRE AS Ubicación, EE.MUNNOMBRE AS Municipio, 
						 GQ.Name AS GrupoQX, 
                         CASE ing.IINGREPOR WHEN '1' THEN 'Urgencias' WHEN '2' THEN 'CX' WHEN '3' THEN 'Nacido Hospital' WHEN '4' THEN 'Remitido' WHEN '5' THEN 'Hospitalizacion' END AS IngresaPor, 
                         CASE CUPS.ServiceType WHEN '1' THEN 'Laboratorios' WHEN '2' THEN 'Patologias' WHEN '3' THEN 'Imagenes DX' WHEN '4' THEN 'QX' WHEN '5' THEN 'No Qx' WHEN '6' THEN 'Interconsulta' WHEN '7' THEN 'Ninguno' WHEN
                          '8' THEN 'CX' ELSE 'Ninguno' END AS TipoServicio,
						  DATENAME(MONTH,I.InvoiceDate) AS MesFactura,
						SOD.CostValue AS CostoUnit, SOD.CostValue*SOD.InvoicedQuantity AS CostTotal
 
 
FROM
     Billing.Invoice AS I 
	 INNER JOIN CTE_FACTURACION_UNICA AS UNI  ON UNI.EntityId =I.Id
     INNER JOIN Billing.InvoiceDetail AS ID  ON ID.InvoiceId = I.Id 
	 INNER JOIN Billing.ServiceOrderDetail AS SOD  ON SOD.Id = ID.ServiceOrderDetailId
	 INNER JOIN Billing.ServiceOrder AS SO  ON SO.Id = SOD.ServiceOrderId 
	 INNER JOIN dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
     INNER JOIN Common.ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
     INNER JOIN Contract.CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
     INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
	 INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = SOD.PerformsFunctionalUnitId
     INNER JOIN Payroll.CostCenter AS COST WITH (NOLOCK) ON COST.Id =SOD.CostCenterId
  LEFT JOIN dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR
  LEFT JOIN Contract.HealthAdministrator AS HA  ON HA.Id = I.HealthAdministratorId
  LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
  LEFT JOIN Billing.BillingConcept AS BCT WITH (NOLOCK) ON CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Billing.BillingGroup AS gf  ON gf.Id = CUPS.BillingGroupId
  LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = SOD.ProductId
  LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI WITH (NOLOCK) ON GLI.Id = IPR.IVAId
  LEFT JOIN Inventory.ProductGroup PG WITH (NOLOCK) ON PG.Id = IPR.ProductGroupId
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR WITH (NOLOCK) ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD WITH (NOLOCK) ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = SOD.IPSServiceId
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
  LEFT JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC WITH (NOLOCK)  ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC WITH (NOLOCK) ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
  LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = SO.CreationUser 
  LEFT JOIN Billing.InvoiceCategories ICT  ON ICT.Id = I.InvoiceCategoryId
  LEFT JOIN dbo.INUBICACI AS BB  ON BB.AUUBICACI = PAC.AUUBICACI 
  LEFT JOIN dbo.INMUNICIP AS EE  ON EE.DEPMUNCOD = BB.DEPMUNCOD
  LEFT JOIN Contract.SurgicalGroup AS GQ  ON IPS.SurgicalGroupId = GQ.Id
 where  ha.code in ('00012','EA0485','EA0075');
