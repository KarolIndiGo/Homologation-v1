-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TAC_RESONANCIA_ELECTRO
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_TAC_RESONANCIA_ELECTRO]
AS

SELECT        Cedula, TipDoc, Nombre, Edad, Direccion, Municipio, Ingreso, CodigoServicio, NombreServicio, FechaServicio, Cantidad, ValorUnitario, Descuento, Total, Categoria, GrupoAtencion, EntidadAdministradora, TerceroEntidad, 
                         UnidadesFuncionales, CentroCosto, Factura, UsuarioFacturacion, NombreFacturacion, UsuarioCargo, NombreCargo, FechaFactura, IngresaPor, CodigoEntidad, AuthorizationNumber, Nommedico, Especialidad
FROM            (SELECT        ad.IPCODPACI AS Cedula, pa.IPTIPODOC AS TipDoc, pa.IPNOMCOMP AS Nombre, CAST(DATEDIFF(dd, CAST(pa.IPFECNACI AS date), sod.ServiceDate) / 365.25 AS int) AS Edad, pa.IPDIRECCI AS Direccion, 
                                                    innm.MUNNOMBRE AS Municipio, ad.NUMINGRES AS Ingreso, ce.Code AS CodigoServicio, ce.Description AS NombreServicio, CAST(sod.ServiceDate AS date) AS FechaServicio, sod.InvoicedQuantity AS Cantidad, 
                                                    sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, cg.Code + ' - ' + cg.Name AS GrupoAtencion, 
                                                    ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, cc.Code + ' - ' + cc.Name AS CentroCosto, i.InvoiceNumber AS Factura, 
                                                    i.InvoicedUser AS UsuarioFacturacion, per.Fullname AS NombreFacturacion, so.CreationUser AS UsuarioCargo, per2.Fullname AS NombreCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, 
                                                    ha.Code AS CodigoEntidad, ad.IAUTORIZA AS AuthorizationNumber, INPF.NOMMEDICO AS Nommedico, ines.DESESPECI AS Especialidad
                          FROM            Billing.Invoice AS i INNER JOIN
                                                    Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
                                                    Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                                                    dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                                                    dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI LEFT OUTER JOIN
                                                    dbo.INUBICACI AS inn ON inn.AUUBICACI = pa.AUUBICACI LEFT OUTER JOIN
                                                    dbo.INMUNICIP AS innm ON innm.DEPMUNCOD = inn.DEPMUNCOD LEFT OUTER JOIN
                                                    Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                                                    Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
                                                    Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                                                    Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId INNER JOIN
                                                    Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                                                    Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                                                    Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                                                    Security.Person AS per ON per.Id = u.IdPerson LEFT OUTER JOIN
                                                    Security.[User] AS ua ON ua.UserCode = so.CreationUser LEFT OUTER JOIN
                                                    Security.Person AS per2 ON per2.Id = ua.IdPerson LEFT OUTER JOIN
                                                    Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
                                                    Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId LEFT OUTER JOIN
                                                    dbo.INPROFSAL AS INPF ON INPF.CODPROSAL = sod.PerformsHealthProfessionalCode LEFT OUTER JOIN
                                                    dbo.INESPECIA AS ines ON ines.CODESPECI = sod.PerformsProfessionalSpecialty
                          WHERE        (i.Status = 1)
                          UNION ALL
                          SELECT        ad.IPCODPACI AS Cedula, pa.IPTIPODOC AS TipDoc, pa.IPNOMCOMP AS Nombre, CAST(DATEDIFF(dd, CAST(pa.IPFECNACI AS date), sod.ServiceDate) / 365.25 AS int) AS Edad, pa.IPDIRECCI AS Direccion, 
                                                   innm.MUNNOMBRE AS Municipio, ad.NUMINGRES AS Ingreso, p.Code AS CodigoServicio, p.Name AS NombreServicio, CAST(sod.ServiceDate AS date) AS FechaServicio, sod.InvoicedQuantity AS Cantidad, 
                                                   sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, cg.Code + ' - ' + cg.Name AS GrupoAtencion, 
                                                   ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, cc.Code + ' - ' + cc.Name AS CentroCosto, i.InvoiceNumber AS Factura, 
                                                   i.InvoicedUser AS UsuarioFacturacion, per.Fullname AS NombreFacturacion, so.CreationUser AS UsuarioCargo, per2.Fullname AS NombreCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, 
                                                   ha.Code AS CodigoEntidad, ad.IAUTORIZA AS AuthorizationNumber, INPF.NOMMEDICO AS Nommedico, ines.DESESPECI AS Especialidad
                          FROM            Billing.Invoice AS i INNER JOIN
                                                   Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
                                                   Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                                                   dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                                                   dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI LEFT OUTER JOIN
                                                   dbo.INUBICACI AS inn ON inn.AUUBICACI = pa.AUUBICACI LEFT OUTER JOIN
                                                   dbo.INMUNICIP AS innm ON innm.DEPMUNCOD = inn.DEPMUNCOD LEFT OUTER JOIN
                                                   Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                                                   Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
                                                   Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                                                   Inventory.InventoryProduct AS p ON p.Id = sod.ProductId INNER JOIN
                                                   Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                                                   Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                                                   Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                                                   Security.Person AS per ON per.Id = u.IdPerson LEFT OUTER JOIN
                                                   Security.[User] AS ua ON ua.UserCode = so.CreationUser LEFT OUTER JOIN
                                                   Security.Person AS per2 ON per2.Id = ua.IdPerson LEFT OUTER JOIN
                                                   Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
                                                   Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId LEFT OUTER JOIN
                                                   dbo.INPROFSAL AS INPF ON INPF.CODPROSAL = sod.PerformsHealthProfessionalCode LEFT OUTER JOIN
                                                   dbo.INESPECIA AS ines ON ines.CODESPECI = sod.PerformsProfessionalSpecialty
                          WHERE        (i.Status = 1)) AS datos

