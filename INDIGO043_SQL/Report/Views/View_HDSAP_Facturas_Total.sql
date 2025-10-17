-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_Facturas_Total
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_Facturas_Total]
AS


   SELECT distinct
   convert(datetime, i.InvoiceDate) AS ff, 
   ad.IPCODPACI AS Cedula, 
   CASE pa.IPTIPODOC
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
							 WHEN 9
							 THEN 'CN'
							 WHEN 11
							 THEN 'SC'
							 WHEN 12
							 THEN 'PE'
							 WHEN 13
							 THEN 'PT'
							 WHEN 14
							 THEN 'DE'
							 WHEN 15
							 THEN 'SI'
                         END AS 'Tipo Documento', 
                         pa.IPNOMCOMP AS Nombre,DATEDIFF(YEAR, Pa.IPFECNACI,ad.IFECHAING) AS EdadAños, 
                         ad.NUMINGRES AS Ingreso, ic.Code + ' - ' + ic.Name as Categoria, 
						 cg.Code + ' - ' + cg.Name AS GrupoAtencion,ha.HealthEntityCode as 'Codigo EPS',
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
						  t.Name as Tercero, i.InvoiceNumber AS Factura, i.InvoicedUser AS UsuarioFacturacion, 
                         Pe.Fullname AS NomFacturador, cast(i.InvoiceDate as date) AS FechaFactura, i.TotalInvoice AS TotalFactura, 
						 i.ThirdPartySalesValue AS TotalEntidad,i.TotalPatientSalesPrice as 'Total paciente', 
                         CASE WHEN i.Status = 1 THEN 'Facturado' WHEN i.Status = 2 THEN 'Anulado' END AS EstadoF,
						 --CASE ar.PortfolioStatus
						 --WHEN '1' THEN 'SINRADICAR' WHEN '2' THEN 'RADICADA SIN CONFIRMAR' WHEN '3' THEN 'RADICADA ENTIDAD ' 
						 --WHEN '7' THEN 'CERTIFICADA_PARCIAL ' WHEN '8' THEN 'CERTIFICADA_TOTAL ' WHEN '14' THEN 'DEVOLUCION_FACTURA '
						 --WHEN '15' THEN 'CTA DIFICIL RECAUDO ' END AS 'Estado Cartera',
						 
						 i.AnnulmentUser AS AnulaUsuario, 
                         i.AnnulmentDate AS AnulaFecha, Billing.BillingReversalReason.Name AS AnulaRazon, 
						 Billing.BillingReversalReason.Description AS AnulaDescripcion


FROM            Billing.Invoice AS i INNER JOIN
				Billing.InvoiceCategories ic on ic.Id = i.InvoiceCategoryId inner join
                         dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                         dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
					     Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNEr JOIN
                         Security.[User] AS u ON u.UserCode = i.InvoicedUser inner JOIN
						 Security.Person pe ON pe.Id = u.IdPerson left join
                         Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId left JOIN
                         Billing.BillingReversalReason ON i.ReversalReasonId = Billing.BillingReversalReason.Id  LEFT JOIN
						 --Portfolio.AccountReceivable ar on i.InvoiceNumber = ar.InvoiceNumber and ar.AccountReceivableType='2' and i.InvoiceNumber is not null LEFT join
						 Common.ThirdParty t on ha.ThirdPartyId= t.Id 
  

