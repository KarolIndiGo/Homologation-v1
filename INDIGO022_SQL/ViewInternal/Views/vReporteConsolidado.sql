-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: vReporteConsolidado
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE view [ViewInternal].[vReporteConsolidado]
as (
SELECT        i.InvoiceDate AS ff, ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, ad.NUMINGRES AS Ingreso, ic.Code + ' - ' + ic.Name as Categoria, cg.Code + ' - ' + cg.Name AS GrupoAtencion, 
                         isnull(ha.Code + ' - ','') + cg.Name AS EntidadAdministradora,
						 case
						  when cg.EntityType ='1' then 'EPS Contributivo' 
						  when cg.EntityType = '2' then  'EPS Subsidiado' 
						  when cg.EntityType = '3' then 'ET Vinculados Municipios'
						  when cg.EntityType = '4' then 'ET Vinculados Departamentos' 
						  when cg.EntityType = '5'  then 'ARL Riesgos Laborales' 
						  when cg.EntityType = '6' then 'MP Medicina Prepagada' 
						  when cg.EntityType = '7'  then 'IPS Privada' 
						  when cg.EntityType = '8'  then 'IPS Publica' 
						  when cg.EntityType = '9'  then 'Regimen Especial' 
						  when cg.EntityType = '10'  then 'Accidentes de transito' 
						  when cg.EntityType = '11'  then 'Fosyga' 
						  when cg.EntityType = '12'  then 'Otros' 
						  when cg.EntityType = '13'  then 'Aseguradoras' 
						  when cg.EntityType = '99'  then 'Particulares'
						 end as Regimen,
						  isnull(ha.Name, cg.Name) AS Tercero, i.InvoiceNumber AS Factura, i.InvoicedUser AS UsuarioFacturacion, 
                         Pe.Fullname AS NomFacturador, cast(i.InvoiceDate as date) AS FechaFactura, i.TotalInvoice AS TotalFactura, i.ThirdPartySalesValue AS TotalEntidad, 
                         CASE WHEN i.Status = 1 THEN 'Facturado' WHEN i.Status = 2 THEN 'Anulado' END AS EstadoF, i.AnnulmentUser AS AnulaUsuario, 
                         i.AnnulmentDate AS AnulaFecha, Billing.BillingReversalReason.Name AS AnulaRazon, Billing.BillingReversalReason.Description AS AnulaDescripcion
FROM            Billing.Invoice AS i INNER JOIN
				Billing.InvoiceCategories ic on ic.Id = i.InvoiceCategoryId inner join
                         dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                         dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
					     Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNEr JOIN
                         Security.[User] AS u ON u.UserCode = i.InvoicedUser inner JOIN
						 Security.Person pe ON pe.Id = u.IdPerson left join
                         Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId left JOIN
                         Billing.BillingReversalReason ON i.ReversalReasonId = Billing.BillingReversalReason.Id
						 )

