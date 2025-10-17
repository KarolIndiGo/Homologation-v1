-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURACION_SOAT
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_FACTURACION_SOAT]
AS


select      b.InvoiceNumber,
            b.InvoiceDate FechaFactura,
			b.AdmissionNumber Ingreso,
			b.TotalInvoice ValorFactura,
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
				t.Nit,
				t.name Tercero,
			CASE B.Status
			WHEN 1
			THEN 'Facturado'
			Else 'Anulado'
			End EstadoFactura,
			CASE pac.IPTIPODOC
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
			pac.IPCODPACI Identificacion,
			pac.IPNOMCOMP Nombre,						 			
			ISNULL(a.NUMSOA, 'Sin Numero Póliza') NumeroPóliza,
			a.FECOCUEVE FechaAccidente,
			t.Name NombreAseguradora,
			a.PLAVEHACC Placa	

       
from  ADFURIPSU a
join Billing.Invoice b  on b.id = a.IdInvoice
join Common.ThirdParty t on t.id = b.ThirdPartyId
JOIN ADINGRESO AD ON AD.NUMINGRES = A.NUMINGRES
join INPACIENT pac on pac.IPCODPACI = a.NUMDOCVIC
join  INENTIDAD AS INE on INE.CODENTIDA = AD.CODENTIDA--
JOIN Contract.CareGroup CG ON CG.ID = AD.GENCAREGROUP
  

