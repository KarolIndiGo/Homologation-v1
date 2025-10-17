-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_V2_FAC_REPORTE_PROCEDIMIENTOS_NO_QX_POR_RECONOCER_VALORIZADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_V2_FAC_REPORTE_PROCEDIMIENTOS_NO_QX_POR_RECONOCER_VALORIZADO]
AS

SELECT CUPS.Code 'CUPS',
CUPS.Description 'DESCRIPCION CUPS',cast(avg(SOD.TotalSalesPrice) as numeric ) 'VALOR UNITARIO'
FROM Billing .ServiceOrder SO WITH (NOLOCK)
INNER JOIN Billing .ServiceOrderDetail AS SOD WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId 
INNER JOIN Billing.ServiceOrderDetailDistribution sodd WITH (NOLOCK) on sodd.ServiceOrderDetailId =sod.id
INNER JOIN Billing.RevenueControlDetail rcd WITH (NOLOCK) ON sodd.RevenueControlDetailId = rcd.Id
INNER JOIN Billing.RevenueControl rc WITH (NOLOCK) on rc.Id =rcd.RevenueControlId 
INNER JOIN DBO.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =SO.PatientCode 
INNER JOIN DBO.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =SO.AdmissionNumber 
INNER JOIN Payroll.FunctionalUnit fu WITH (NOLOCK) on fu.Id = sod.PerformsFunctionalUnitId
INNER JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id =SOD.CUPSEntityId 
LEFT JOIN DBO.INPROFSAL AS PRO WITH (NOLOCK) ON PRO.CODPROSAL =SOD.PerformsHealthProfessionalCode 

WHERE CUPS.ServiceType IN (3,4,5) and year(cast(sod.ServiceDate as date))=2023
group by CUPS.Code,CUPS.Description
