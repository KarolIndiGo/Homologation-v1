-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_FACTURACION_TOTAL_RADICADO_CUV
-- Extracted by Fabric SQL Extractor SPN v3.9.0



-- =============================================
-- Author:      Miguel Angel Ruiz Vega
-- Create date: 2025-02-26 08:57:50
-- Database:    INDIGO043
-- Description: Reporte Facturacion CUV vs Radicacion
-- =============================================



CREATE PROCEDURE [Report].[SP_FACTURACION_TOTAL_RADICADO_CUV]
 @FECINI AS DATE,
 @FECFIN AS DATE
AS

---******FACTURACION TOTAL CON RANGO DE FECHA******-------

 

 

 
SELECT
TIPA.NOMBRE [TIPO IDENTIFICACION],I.PatientCode 'IDENTIFICACION',PAC.IPNOMCOMP 'NOMBRE',DATEDIFF(YEAR, PAC.IPFECNACI,ING.IFECHAING) AS 'EDAD AÑOS',

ING.NUMINGRES AS 'INGRESO', IC.Code + ' - ' + IC.Name as 'CATEGORIA', 

						 CG.Code + ' - ' + CG.Name AS 'GRUPO DE ATENCION',HA.HealthEntityCode as 'CODIGO EPS',

                         isnull(HA.Code + ' - ','') + cg.Name AS 'ENTIDAD ADMINISTRADORA',

						 case

						  when CG.EntityType ='1' then 'EPS Contributivo' 

						  when CG.EntityType = '2' then  'EPS Subsidiado' 

						  when CG.EntityType = '3' then 'ET Vinculados Municipios'

						  when CG.EntityType = '4' then 'ET Vinculados Departamentos' 

						  when CG.EntityType = '5'  then 'ARL Riesgos Laborales' 

						  when CG.EntityType = '6' then 'MP Medicina Prepagada' 

						  when CG.EntityType = '7'  then 'IPS Privada' 

						  when CG.EntityType = '8'  then 'IPS Publica' 

						  when CG.EntityType = '9'  then 'Regimen Especial' 

						  when CG.EntityType = '10'  then 'Accidentes de transito' 

						  when CG.EntityType = '11'  then 'Fosyga' 

						  when CG.EntityType = '12'  then 'Otros' 

						  when CG.EntityType = '13'  then 'Aseguradoras' 

						  when CG.EntityType = '99'  then 'Particulares'

						 end as 'REGIMEN',
						 rid.RadicatedNumber 'NUMERO RADICADO',
						 EP.CUV,

                         TP.Name as 'TERCERO', 
						 i.InvoiceNumber AS 'FACTURA', i.InvoicedUser AS 'USUARIO FACTURO',

                         SU.NOMUSUARI AS 'NOMBRE FACTURADOR', i.InvoiceDate  AS 'FECHA FACTURA', CAST(i.TotalInvoice AS NUMERIC(20,2)) AS 'TOTAL FACTURA', 

						 CAST(i.ThirdPartySalesValue AS NUMERIC(20,2)) AS 'TOTAL ENTIDAD',CAST(i.TotalPatientSalesPrice AS NUMERIC(20,2)) as 'TOTAL PACIENTE', 

                         CASE WHEN i.Status = 1 THEN 'Facturado' WHEN i.Status = 2 THEN 'Anulado' END AS 'ESTADO FACTURA',

						 i.AnnulmentUser + ' - ' + SUA.NOMUSUARI AS 'USUARIO ANULO', i.AnnulmentDate  AS 'FECHA ANULACION', Billing.BillingReversalReason.Name AS 'RAZON ANULACION', 

						i.DescriptionReversal AS 'DESCRIPCION ANULACION'

FROM  Billing.Invoice AS I

  LEFT JOIN PORTFOLIO.RadicateInvoiceD rid ON RID.InvoiceNumber = I.InvoiceNumber

  LEFT JOIN PORTFOLIO.RadicateInvoiceD rid1 ON rid1.ID = rid.RadicateInvoiceCId

  LEFT JOIN Billing.ElectronicsProperties ep on ep.EntityId = i.id

  --INNER JOIN CTE_FACTURACION_TOTAL AS FAC ON FAC.ID=I.id

  INNER JOIN Billing.InvoiceCategories IC on IC.Id = I.InvoiceCategoryId

  LEFT JOIN Common.ThirdParty TP on I.ThirdPartyId= TP.Id

  LEFT JOIN Contract.CareGroup AS CG ON CG.Id = I.CareGroupId

  LEFT JOIN Contract.HealthAdministrator AS HA ON HA.Id = I.HealthAdministratorId

  LEFT JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI = I.PatientCode

  LEFT JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES = I.AdmissionNumber

  LEFT JOIN Billing.BillingReversalReason ON I.ReversalReasonId = Billing.BillingReversalReason.Id

  LEFT JOIN DBO.ADTIPOIDENTIFICA AS TIPA WITH (NOLOCK) ON TIPA.ID=PAC.IPTIPODOC

  LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser

  LEFT JOIN DBO.SEGusuaru SUA WITH (NOLOCK) ON SUA.CODUSUARI = i.AnnulmentUser
  
WHERE CAST(I.InvoiceDate AS DATE) BETWEEN @FECINI AND @FECFIN
  --where i.InvoiceNumber = 'hspe941922'
