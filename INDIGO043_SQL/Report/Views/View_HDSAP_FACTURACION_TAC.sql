-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURACION_TAC
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_FACTURACION_TAC]
AS

-- SELECT 

   
--   I.PatientCode AS IDENTIFICACION,
--   RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
--   I.AdmissionNumber AS INGRESO,
--   I.InvoiceNumber AS [NRO FACTURA],
--   CAST(I.InvoiceDate AS DATE) AS FECHAFACTURA,
--   CAST(I.TotalInvoice AS NUMERIC(20,2)) AS [TOTAL FACTURA],
--   CUPS.Description, 
--   sod.InvoicedQuantity,
--   ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity) 'CANTIDAD',
--   CAST(ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice) AS NUMERIC(20,2)) 'VALOR SERVICIO'
   
--FROM Billing.invoice i
--  INNER JOIN Billing.InvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId =I.Id 
--  INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id =ID.ServiceOrderDetailId
--  INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId 
--  INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
--  INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
--  LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
--  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS WITH (NOLOCK) ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'





SELECT        
                         distinct
                         ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, ad.NUMINGRES AS Ingreso,i.InvoiceNumber AS NUMERO_FACTURA, ad.IFECHAING FechaIngreso ,ce.Code AS CodigoServicio, ce.Description AS NombreServicio, sod.ServiceDate AS FechaServicio, sod.InvoicedQuantity AS Cantidad, 
                         sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + ha.Name AS EntidadAdministradora, 
                         INEN.NOMENTIDA AS Entidad, fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, cc.Code + ' - ' + cc.Name AS CentroCosto,  i.InvoicedUser AS UsuarioFacturacion, i.InvoiceDate AS FechaFactura, 
                         inv.Name AS Categoria, so.CreationUser AS UsuarioCargo, espmed.DESESPECI AS Especialidad, i.Status AS Estado
FROM            Billing.Invoice AS i INNER JOIN
                         Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                         dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                         dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                         dbo.INENTIDAD AS INEN ON pa.CODENTIDA = INEN.CODENTIDA INNER JOIN
                         Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                         Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
                         Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                         Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId INNER JOIN
                         Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                         Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                         Security.[User] AS u ON u.UserCode = i.InvoicedUser INNER JOIN
                         Billing.InvoiceCategories AS inv ON i.InvoiceCategoryId = inv.Id AND i.InvoiceCategoryId = inv.Id AND i.InvoiceCategoryId = inv.Id LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
                         dbo.INPROFSAL AS med  ON med.CODPROSAL = sod.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1
WHERE        (i.Status = 1)





