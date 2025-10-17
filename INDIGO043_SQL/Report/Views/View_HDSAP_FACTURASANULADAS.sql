-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURASANULADAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_FACTURASANULADAS]
AS

SELECT         i.InvoiceNumber AS Factura, i.InvoiceDate AS ff, ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, IPFECNACI as FecNacimiento, ad.NUMINGRES AS Ingreso,
               ad.IFECHAING AS f_ingreso, EGR.FECALTPAC AS f_alta_medica, 
                         EGR.FECEGRESO AS f_egreso_cama, cg.Code + ' - ' + cg.Name AS GrupoAtencion, 
                         ha.Code + ' - ' + ha.Name AS EntidadAdministradora, ha.Name AS Tercero, i.InvoicedUser AS UsuarioFacturacion, 
                         Pe.Fullname AS NomFacturador, i.InvoiceDate AS FechaFactura, i.TotalInvoice AS TotalFactura, i.ThirdPartySalesValue AS TotalEntidad, 
                         CASE WHEN i.Status = '1' THEN 'Facturado' WHEN i.Status = '2' THEN 'Anulado' END AS EstadoF, i.AnnulmentUser AS AnulaUsuario, 
                         i.AnnulmentDate AS AnulaFecha, Billing.BillingReversalReason.Name AS AnulaRazon, Billing.BillingReversalReason.Description AS AnulaDescripcion, 
                         i.DescriptionReversal AS AnulaMotivo, Cat.Name AS Categoria, AD.FECHEGRESO FechaEgreso
FROM            Billing.Invoice AS i INNER JOIN
                         ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                         INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                         Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                         Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId INNER JOIN
                         Security.[User] AS Us ON i.InvoicedUser = Us.UserCode INNER JOIN
                         Billing.InvoiceCategories AS Cat ON i.InvoiceCategoryId = Cat.Id AND i.InvoiceCategoryId = Cat.Id AND i.InvoiceCategoryId = Cat.Id LEFT OUTER JOIN
                         Billing.BillingReversalReason ON i.ReversalReasonId = Billing.BillingReversalReason.Id LEFT OUTER JOIN
                         Security.Person AS Pe ON Us.IdPerson = Pe.Id LEFT OUTER JOIN
                         CHREGEGRE AS EGR ON ad.NUMINGRES = EGR.NUMINGRES
where  ha.Name like '%ASMET%'


