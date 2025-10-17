-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURAS_POLIZA
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_FACTURAS_POLIZA]
AS

select distinct 
      I.InvoiceDate FechaFactura,
      c.ConfirmDate FechaRadicacion,
      i.InvoiceNumber NumeroFactura,
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
                         END AS 'Tipo documento',
						 pac.IPCODPACI IdentificacionPaciente,
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
						 ine.NOMENTIDA Entidad,
						 pa.value ValorFactura,
						 pa.Balance Saldo,
						 ISNULL(t1.ValueGlosado,0) ValorGlosado,
						 ISNULL(t1.ValueAcceptedIPSconciliation,0) ValorAceptadoConciliacion,
						 ISNULL(t1.ValuePendingConciliation,0) ValorAceptadoEAPB,
						 a.NUMSOA AS NumeroPoliza,
						 CASE PA.Status
						 WHEN  1
						 THEN 'Registrado' 
						 WHEN 2
						 THEN 'Confirmado'
						 WHEN 3
						 THEN 'Anulado'
						 END EstadoFactura,
						 i.AdmissionNumber,
						 case a.ESTASE 
						 when 1
						 then 'ASEGURADO'
						 when 2
						 then 'NO ASEGURADO'
						 when 3
						 then 'VEHÍCULO FANTASMA'
						 when 4
						 then 'PÓLIZA FALSA'
						 when 5
						 then 'VEHÍCULO EN FUGA'
						 when 6
						 then 'ASEGURADO D.2497'
						 else 'OTROS'
						 end EstadoAsegurado
 
from Billing.invoice i
join ADINGRESO ad on ad.NUMINGRES = i.AdmissionNumber
join INPACIENT pac on pac.IPCODPACI = PatientCode
join INENTIDAD ine on ine.CODENTIDA = ad.CODENTIDA
join Contract.HealthAdministrator cg on cg.Id = i.HealthAdministratorId
join ADFURIPSU a on a.NUMFAC = i.InvoiceNumber or a.IdInvoice = i.id
join Portfolio.AccountReceivable  pa on pa.InvoiceId = i.id
join Portfolio.RadicateInvoiceD  d on d.InvoiceNumber = i.InvoiceNumber
join Portfolio.RadicateInvoiceC c on c.id = d.RadicateInvoiceCId
left join 
(select ValueAcceptedIPSconciliation, ValuePendingConciliation, InvoiceNumber,bi.InvoiceId,ValueGlosado,ValueReiterated
from Glosas.GlosaMovementGlosa gg
join Billing.InvoiceDetail bi on bi.id = gg.InvoiceDetailId
) t1 on t1.InvoiceId = i.id
where  i.Status = 1  --and d.InvoiceNumber = 'hspe791843' 

