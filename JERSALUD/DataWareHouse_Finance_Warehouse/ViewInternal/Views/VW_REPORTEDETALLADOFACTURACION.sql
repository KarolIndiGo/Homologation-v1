-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_REPORTEDETALLADOFACTURACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[VW_REPORTEDETALLADOFACTURACION]
AS

SELECT        Cedula, Nombre, Ingreso, CodigoServicio, NombreServicio, FechaServicio, Cantidad, ValorUnitario, Descuento, Total, Categoria, GrupoAtencion, EntidadAdministradora, TerceroEntidad, UnidadesFuncionales, CentroCosto, 
                         Factura, UsuarioFacturacion, UsuarioCargo, FechaFactura, IngresaPor, CodigoEntidad, especialidad
FROM            (SELECT        ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, ad.NUMINGRES AS Ingreso, ce.Code AS CodigoServicio, ce.Description AS NombreServicio, CAST(sod.ServiceDate AS date) AS FechaServicio, 
                                                    sod.InvoicedQuantity AS Cantidad, sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, 
                                                    cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, 
                                                    cc.Code + ' - ' + cc.Name AS CentroCosto, i.InvoiceNumber AS Factura, i.InvoicedUser AS UsuarioFacturacion, so.CreationUser AS UsuarioCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, 
                                                    ha.Code AS CodigoEntidad, esp.DESESPECI AS especialidad
                          FROM            INDIGO031.Billing.Invoice AS i INNER JOIN
                                                    INDIGO031.Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
                                                    INDIGO031.Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                                                    INDIGO031.dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                                                    INDIGO031.dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                                                    INDIGO031.Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                                                    INDIGO031.Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
                                                    INDIGO031.Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                                                    INDIGO031.Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId INNER JOIN
                                                    INDIGO031.Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                                                    INDIGO031.Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                                                    INDIGO031.Security.[UserInt] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                                                    INDIGO031.Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
                                                    INDIGO031.Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId INNER JOIN
                                                    INDIGO031.dbo.INPROFSAL AS med ON sod.PerformsHealthProfessionalCode = med.CODPROSAL INNER JOIN
                                                    INDIGO031.dbo.INESPECIA AS esp ON med.CODESPEC1 = esp.CODESPECI INNER JOIN
                                                    INDIGO031.dbo.INUBICACI AS ubi ON ad.DEPMUNCOD = ubi.DEPMUNCOD
                          WHERE        (i.Status = 1)
                          UNION ALL
                          SELECT        ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, ad.NUMINGRES AS Ingreso, p.Code AS CodigoServicio, p.Name AS NombreServicio, CAST(sod.ServiceDate AS date) AS FechaServicio, 
                                                   sod.InvoicedQuantity AS Cantidad, sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, 
                                                   cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, 
                                                   cc.Code + ' - ' + cc.Name AS CentroCosto, i.InvoiceNumber AS Factura, i.InvoicedUser AS UsuarioFacturacion, so.CreationUser AS UsuarioCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, 
                                                   ha.Code AS CodigoEntidad, '' AS especialidad
                          FROM            INDIGO031.Billing.Invoice AS i INNER JOIN
                                                   INDIGO031.Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
                                                   INDIGO031.Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                                                   INDIGO031.dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                                                   INDIGO031.dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                                                   INDIGO031.Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                                                   INDIGO031.Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
                                                   INDIGO031.Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                                                   INDIGO031.Inventory.InventoryProduct AS p ON p.Id = sod.ProductId INNER JOIN
                                                   INDIGO031.Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                                                   INDIGO031.Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                                                   INDIGO031.Security.[UserInt] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                                                   INDIGO031.Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
                                                   INDIGO031.Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId
                          WHERE        (i.Status = 1)) AS datos
