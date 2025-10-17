-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_SERVICIOS_TERCERIZADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [Report].[VIEW_SERVICIOS_TERCERIZADOS] as
select 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 aos.Code [CODIGO AUTORIZACION],
 aos.DocumentDate [FECHA DOCUMENTO],
 PER.Fullname AS 'USUARIO CREA AUTORIZACION',
 CASE AOS.Status WHEN 1 THEN 'REGISTRADA' WHEN 2 THEN 'CONFIRMADA' WHEN 3 THEN 'ANULADA' END AS 'ESTADO',
 case aos.Type when 1 then 'Hospitalaria' else 'Ambulatoria' END [TIPO AUTORIZACION],
 aos.AdmissionNumber [INGRESO],iif(fac.AdmissionNumber is null,'INGRESO NO FACTURADO','INGRESO FACTURADO')  AS 'FACTURADO' ,FAC.InvoiceNumber 'NRO DE FACTURA',
 TP.Nit [NIT], TP.Name [TERCERO],EST.TECNOLOGIA ,IIF(EST.CUPSEntityId IS NOT NULL,'ESTA EN FACTURA','NO ESTA EN FACTURA') AS 'SERVICIO FACTURADO',
 ce.Code [CODIGO CUPS],ce.Description [CUPS],IPS.Code [CODIGO SERVICIO],IPS.Name [SERVICIO IPS],
 cd.code + ' - ' + cd.name AS DESCRIPCION,
 CASE assod.ServiceType WHEN 1 THEN 'SOAT' WHEN 2 THEN 'OTRO' WHEN 3 THEN 'CUPS' END [TIPO SERVICIO],IPSQX.Code [SUBCODIGO],IPSQX.Name [SUBNOMBRE],
 assod.InvoicedQuantity [CANTIDAD],
 CASE WHEN QX.Id IS NULL THEN assod.SubTotalSalesPrice ELSE QX.TotalSalesPrice END [PRECIO UNITARIO],
 CASE WHEN QX.Id IS NULL THEN assod.GrandTotalSalesPrice ELSE QX.TotalSalesPrice END [PRECIO TOTAL],
 CASE WHEN QX.Id IS NULL THEN '0' ELSE assod.SubTotalSalesPrice END [PRECIO QX],
 ASSOD.AuthorizationNumber [AUTORIZACION],HEA.CODE + ' - ' + HEA.Name [ENTIDAD],CG.Code + ' - ' + CG.Name [GRUPO ATENCION],
 FU.Code + ' - ' + fu.Name [UNIDAD FUNCIONAL] ,SAL.NOMMEDICO [PROFESIONAL],EST.[CODIGO GRUPO ATENCION] 'CODIGO GRUPO DE ATENCION FACTURA',
 EST.[GRUPO DE ATENCION] 'GRUPO ATENCION FACTURA',
 CAST(aos.DocumentDate AS date) AS 'FECHA BUSQUEDA',
 YEAR(aos.DocumentDate) AS 'AÑO BUSQUEDA',
 MONTH(aos.DocumentDate) AS 'MES BUSQUEDA',
 CONCAT(FORMAT(MONTH(aos.DocumentDate), '00') ,' - ', 
   CASE MONTH(aos.DocumentDate) 
    WHEN 1 THEN 'ENERO'
    WHEN 2 THEN 'FEBRERO'
    WHEN 3 THEN 'MARZO'
    WHEN 4 THEN 'ABRIL'
    WHEN 5 THEN 'MAYO'
    WHEN 6 THEN 'JUNIO'
    WHEN 7 THEN 'JULIO'
    WHEN 8 THEN 'AGOSTO'
    WHEN 9 THEN 'SEPTIEMBRE'
    WHEN 10 THEN 'OCTUBRE'
    WHEN 11 THEN 'NOVIEMBRE'
    WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
from 
 [Authorization].AuthorizationOutsourcedServices  aos
 JOIN Security.[User] AS USU ON USU.UserCode=AOS.CreationUser 
 JOIN Security.Person AS PER ON PER.Id =USU.IdPerson 
 LEFT JOIN Common.ThirdParty AS TP ON aos.ThirdPartyId =TP.Id 
 LEFT JOIN [Authorization].AuthorizationOutsourcedServicesServiceOrderDetail AS assod on assod.AuthorizationOutsourcedServicesId =aos.Id 
 LEFT JOIN [Authorization].AuthorizationOutsourcedServicesServiceOrderDetailSurgical AS QX ON QX.AuthorizationOutsourcedServicesServiceOrderDetailId =assod.Id
 left join Contract.CUPSEntity as ce on ce.Id =assod.CUPSEntityId 
 LEFT JOIN Contract.IPSService AS IPS ON IPS.Id =assod.IPSServiceId 
 left join Payroll.FunctionalUnit as fu on fu.Id =assod.PerformsFunctionalUnitId 
 LEFT JOIN dbo.INPROFSAL AS SAL ON SAL.CODPROSAL =assod.PerformsHealthProfessionalCode 
 LEFT JOIN Contract.IPSService AS IPSQX ON IPSQX.Id =QX.IPSServiceId 
 LEFT JOIN Contract.HealthAdministrator AS HEA ON HEA.Id =assod.HealthAdministratorId 
 LEFT JOIN Contract.CareGroup CG ON CG.Id =assod.CareGroupId 
 LEFT JOIN Contract.ContractDescriptions cd ON CAST (assod.CUPSEntityContractDescriptionId as varchar) = cd.code
 LEFT JOIN (select AdmissionNumber,InvoiceNumber   
            from Billing.Invoice 
			where Status =1 group by AdmissionNumber,InvoiceNumber) as fac on fac.AdmissionNumber =aos.AdmissionNumber 
 LEFT JOIN (SELECT F.AdmissionNumber,F.InvoiceNumber ,CUPS.Code ,CUPS.Description, SOD.CUPSEntityId, CAT.Name AS 'TECNOLOGIA',CG.Code 'CODIGO GRUPO ATENCION',CG.Name 'GRUPO DE ATENCION' 
            FROM Billing.Invoice AS F WITH (NOLOCK)
			INNER JOIN Billing.InvoiceDetail AS DF WITH (NOLOCK) ON DF.InvoiceId = F.Id
			INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id = DF.ServiceOrderDetailId
			INNER JOIN Billing.InvoiceCategories AS CAT ON CAT.Id =F.InvoiceCategoryId 
			INNER JOIN Contract.CareGroup AS CG ON CG.Id =F.CareGroupId 
			LEFT OUTER JOIN Billing.ServiceOrderDetailSurgical AS DQ WITH (NOLOCK) ON DQ.ServiceOrderDetailId = SOD.Id AND DQ.OnlyMedicalFees = '0'
			LEFT OUTER JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
			 WHERE F.Status =1 GROUP BY F.AdmissionNumber,F.InvoiceNumber ,CUPS.Code ,CUPS.Description, SOD.CUPSEntityId,CAT.Name,
			 CG.Code,CG.Name) AS EST ON EST.AdmissionNumber =FAC.AdmissionNumber AND EST.InvoiceNumber =FAC.InvoiceNumber AND EST.CUPSEntityId =assod.CUPSEntityId 
