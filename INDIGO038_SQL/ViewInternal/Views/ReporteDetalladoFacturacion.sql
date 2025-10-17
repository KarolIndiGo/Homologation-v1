-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: ReporteDetalladoFacturacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[ReporteDetalladoFacturacion]
AS
SELECT        Cedula, Nombre, Ingreso, CodigoServicio, NombreServicio, FechaServicio, Cantidad, ValorUnitario, Descuento, Total, Categoria, GrupoAtencion, EntidadAdministradora, TerceroEntidad, UnidadesFuncionales, CentroCosto, 
                         Factura, UsuarioFacturacion, UsuarioCargo, FechaFactura, IngresaPor, CodigoEntidad, especialidad
FROM            (SELECT        ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, ad.NUMINGRES AS Ingreso, ce.Code AS CodigoServicio, ce.Description AS NombreServicio, CAST(sod.ServiceDate AS date) AS FechaServicio, 
                                                    sod.InvoicedQuantity AS Cantidad, sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, 
                                                    cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, 
                                                    cc.Code + ' - ' + cc.Name AS CentroCosto, i.InvoiceNumber AS Factura, i.InvoicedUser AS UsuarioFacturacion, so.CreationUser AS UsuarioCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, 
                                                    ha.Code AS CodigoEntidad, esp.DESESPECI AS especialidad
                          FROM            Billing.Invoice AS i INNER JOIN
                                                    Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
                                                    Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                                                    dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                                                    dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                                                    Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                                                    Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
                                                    Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                                                    Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId INNER JOIN
                                                    Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                                                    Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                                                    Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                                                    Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
                                                    Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId INNER JOIN
                                                    dbo.INPROFSAL AS med ON sod.PerformsHealthProfessionalCode = med.CODPROSAL INNER JOIN
                                                    dbo.INESPECIA AS esp ON med.CODESPEC1 = esp.CODESPECI INNER JOIN
                                                    dbo.INUBICACI AS ubi ON ad.DEPMUNCOD = ubi.DEPMUNCOD
                          WHERE        (i.Status = 1)
                          UNION ALL
                          SELECT        ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, ad.NUMINGRES AS Ingreso, p.Code AS CodigoServicio, p.Name AS NombreServicio, CAST(sod.ServiceDate AS date) AS FechaServicio, 
                                                   sod.InvoicedQuantity AS Cantidad, sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, 
                                                   cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, 
                                                   cc.Code + ' - ' + cc.Name AS CentroCosto, i.InvoiceNumber AS Factura, i.InvoicedUser AS UsuarioFacturacion, so.CreationUser AS UsuarioCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, 
                                                   ha.Code AS CodigoEntidad, '' AS especialidad
                          FROM            Billing.Invoice AS i INNER JOIN
                                                   Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
                                                   Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                                                   dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                                                   dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                                                   Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                                                   Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
                                                   Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                                                   Inventory.InventoryProduct AS p ON p.Id = sod.ProductId INNER JOIN
                                                   Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                                                   Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                                                   Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                                                   Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
                                                   Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId
                          WHERE        (i.Status = 1)) AS datos
