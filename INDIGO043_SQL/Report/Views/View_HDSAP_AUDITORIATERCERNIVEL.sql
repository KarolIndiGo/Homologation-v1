-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_AUDITORIATERCERNIVEL
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_AUDITORIATERCERNIVEL]
AS

SELECT        ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, ad.NUMINGRES AS Ingreso, ce.Code AS CodigoServicio, ce.Description AS NombreServicio, 
                         sod.ServiceDate AS FechaServicio, sod.InvoicedQuantity AS Cantidad, sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, 
                         id.GrandTotalSalesPrice AS Total, cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + cg.Name AS EntidadAdministradora, 
                         fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, i.InvoiceNumber AS Factura, CASE WHEN i.Status = 1 THEN 'FACT' WHEN i.Status = 2 THEN 'ANUL' END AS ESTADO , i.InvoicedUser AS UsuarioFacturacion, 
                         i.InvoiceDate AS FechaFactura, Billing.InvoiceCategories.Name AS Categoria, sod.PerformsHealthProfessionalCode AS CodProfesional, 
                         Esp.DESESPECI AS Especialidad, Pf.NOMMEDICO AS Profesional
FROM            Billing.Invoice AS i INNER JOIN
                         Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                         dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                         dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                         Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                         Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                         Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId INNER JOIN
                         Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                         dbo.INPROFSAL AS Pf ON sod.PerformsHealthProfessionalCode = Pf.CODPROSAL INNER JOIN
                         dbo.INESPECIA AS Esp ON Pf.CODESPEC1 = Esp.CODESPECI INNER JOIN
                         Security.[User] AS u ON u.UserCode = i.InvoicedUser INNER JOIN
                         Billing.InvoiceCategories ON i.InvoiceCategoryId = Billing.InvoiceCategories.Id AND i.InvoiceCategoryId = Billing.InvoiceCategories.Id AND 
                         i.InvoiceCategoryId = Billing.InvoiceCategories.Id LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId



