-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_FAC_FACTURAS_ANULADAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0






/*******************************************************************************************************************
Nombre: [Report].[SP_FAC_FACTURAS_ANULADAS]
Tipo:Procedimiento almacenado
Observacion:
Profesional:Ing Andres Cabrera
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:18-05-2023
Observaciones: Se quita la condición que no traiga información sobre ingresos cerrados o anulados. Segun lo solicitado en el ticket 9712
--------------------------------------
Version 3
Persona que modifico: Amira Gil Meneses
Fecha: 29-02-2024
Observación: Se declaran variables de Fecha de Inicio y  Fecha Final con base a solicitud en el ticket No. 13163
--------------------------------------
Version 4
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha: 11-04-2024
Observación: Se cambia toda la logica del cte CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_MAX
--------------------------------------
Version 5
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha: 16-05-2024
Observación: Se cambia toda la logica del cte CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_MAX, PARA QUE NOS MUESTRE LA FACTURA QUE REMPLAZA CORRECTAMENTE,
***********************************************************************************************************************************/

CREATE PROCEDURE [Report].[SP_FAC_FACTURAS_ANULADAS]
@FECHAINICIAL date, @FECHAFINAL date
as

--DECLARE @FECHAINICIAL as date = '2024-01-01'
--DECLARE @FECHAFINAL as date = '2024-05-17';


WITH CTE_INGRESOS_ANULADOS
AS
(
   SELECT DISTINCT FAC.AdmissionNumber FROM Billing.Invoice AS FAC
   WHERE FAC.Status ='2'  AND cast(FAC.ANNULMENTDATE as date) 
   BETWEEN @FECHAINICIAL AND @FECHAFINAL--AND AdmissionNumber in ('9512','11193')--'10179'
),
CTE_FACTURAS_ANULADAS
AS
(
   SELECT DISTINCT FAC.Id ,FAC.AdmissionNumber,FAC.PatientCode ,FAC.InvoiceNumber ,FAC.TotalInvoice ,FAC.InvoiceDate, FAC.ReversalReasonId ,FAC.AnnulmentDate ,
   FAC.DescriptionReversal,PAC.IPNOMCOMP,HA.Name,USU.NOMUSUARI 'USUARIO FACTURO', USUA.NOMUSUARI 'USUARIO ANULO',--,BRR.Name 'Razon'
   FAC.InvoiceCategoryId
   FROM Billing.Invoice FAC
   INNER JOIN CTE_INGRESOS_ANULADOS AS ANU ON FAC.AdmissionNumber =ANU.AdmissionNumber 
   INNER JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI =FAC.PatientCode 
   INNER JOIN Contract .HealthAdministrator AS HA ON HA.Id =FAC.HealthAdministratorId 
   INNER JOIN DBO.SEGusuaru AS USU ON USU.CODUSUARI =FAC.InvoicedUser 
   INNER JOIN DBO.SEGusuaru AS USUA ON USUA.CODUSUARI =FAC.AnnulmentUser 
   
   WHERE FAC.Status =2 and cast(FAC.AnnulmentDate as date) between @FECHAINICIAL and @FECHAFINAL
),
CTE_FACTURAS_SIN_ANULAR
AS
(
SELECT FAC.* FROM Billing .Invoice AS FAC
INNER JOIN CTE_INGRESOS_ANULADOS AS ANU ON FAC.AdmissionNumber =ANU.AdmissionNumber 
WHERE FAC.Status =1
),
CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO
AS
(
SELECT FAC.AdmissionNumber,FAC.PatientCode,FAC.InvoiceNumber ,FAC.TotalInvoice,FAC.InvoiceDate  FROM Billing .Invoice AS FAC
INNER JOIN CTE_INGRESOS_ANULADOS AS ANU ON FAC.AdmissionNumber =ANU.AdmissionNumber 
WHERE FAC.Status =1
),
CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_MAX
AS
(
--in v4
 -- SELECT FAC.AdmissionNumber,FAC.PatientCode,FAC.InvoiceNumber ,FAC.TotalInvoice,FAC.InvoiceDate  FROM Billing .Invoice AS FAC
 -- INNER JOIN
 -- (
 --   SELECT FAC.AdmissionNumber,FAC.PatientCode,MAX(FAC.ID) ID FROM Billing .Invoice AS FAC
 --   INNER JOIN CTE_INGRESOS_ANULADOS AS ANU ON FAC.AdmissionNumber =ANU.AdmissionNumber
	--WHERE FAC.Status =1
	--GROUP BY FAC.AdmissionNumber,FAC.PatientCode
 -- ) AS G ON G.ID =FAC.Id 
--fn v4
--IN V5
  --SELECT 
  --FAC.AdmissionNumber,FAC.PatientCode,FAC.InvoiceNumber ,FAC.TotalInvoice,FAC.InvoiceDate  
  --FROM 
  --Billing.Invoice AS FAC
  --WHERE FAC.ID=(SELECT MAX(FA.ID) 
		--		FROM 
		--		Billing.Invoice FA 
		--		INNER JOIN (SELECT AdmissionNumber,InvoiceCategoryId FROM Billing.Invoice F WHERE F.Status=2) F ON FA.AdmissionNumber=F.AdmissionNumber AND FA.InvoiceCategoryId=F.InvoiceCategoryId
  --WHERE FAC.AdmissionNumber=FA.AdmissionNumber) AND FAC.Status=1 and fac.AdmissionNumber='68028'
  --FN V5
SELECT  
FAC.AdmissionNumber,FAC.PatientCode,FAC.InvoiceNumber ,FAC.TotalInvoice,FAC.InvoiceDate  
FROM 
Billing.Invoice FAC
INNER JOIN CTE_FACTURAS_ANULADAS ANU ON FAC.AdmissionNumber=ANU.AdmissionNumber AND FAC.InvoiceCategoryId=ANU.InvoiceCategoryId
WHERE FAC.Status=1
),
CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_FOLIO
AS
(
SELECT 
FAC.AdmissionNumber,FAC.PatientCode,FAC.InvoiceNumber ,FAC.TotalInvoice,FAC.InvoiceDate  
FROM
Billing.Invoice FAC
INNER JOIN CTE_FACTURAS_ANULADAS ANU ON FAC.AdmissionNumber=ANU.AdmissionNumber AND 1=
(SELECT COUNT(*) FROM Billing.Invoice F WHERE F.AdmissionNumber=FAC.AdmissionNumber AND Status=1)
WHERE FAC.Status=1 --AND FAC.AdmissionNumber='5F6AAB700A'
),
CTE_FACTURAS_ANULADAS_DETALLE
AS
(
  select  fac.AdmissionNumber ,InvoiceId ,min(ServiceOrderDetailId) SOD
  from Billing .InvoiceDetail  id
  inner join Billing .Invoice as fac on fac.Id =id.InvoiceId 
  INNER JOIN CTE_FACTURAS_ANULADAS AS ANU ON ANU.AdmissionNumber =FAC.AdmissionNumber AND FAC.Id =ANU.Id 
  where Balance =0
  group by fac.AdmissionNumber ,InvoiceId
),
CTE_FACTURAS_SIN_ANULAR_DETALLE
AS
(
  select  fac.AdmissionNumber ,InvoiceId ,min(ServiceOrderDetailId) SOD,FAC.InvoiceNumber ,FAC.TotalInvoice ,FAC.InvoiceDate 
  from Billing .InvoiceDetail  id
  inner join Billing .Invoice as fac on fac.Id =id.InvoiceId 
  INNER JOIN CTE_FACTURAS_SIN_ANULAR AS ANU ON ANU.AdmissionNumber =FAC.AdmissionNumber AND FAC.Id =ANU.Id 
  where Balance >0
  group by fac.AdmissionNumber ,InvoiceId,FAC.InvoiceNumber,FAC.TotalInvoice ,FAC.InvoiceDate
),
CTE_FINAL_FACTURA_ANULADAS
AS
(
SELECT --ANU.Id,
ANU.AdmissionNumber 'INGRESO',ING.IESTADOIN 'ESTADO',ANU.PatientCode 'IDENTIFICACION',
ANU.IPNOMCOMP 'PACIENTE',ANU.Name 'ENTIDAD',ANU.InvoiceNumber 'FACTURA ANULADA',
CAST(ANU.InvoiceDate AS DATE) 'FECHA DE FACTURA',ANU.TotalInvoice 'VALOR ANULADO',
ANU.[USUARIO FACTURO],ANU.[USUARIO ANULO] ,
ANU.AnnulmentDate as'FECHA ANULACION',
--BRR.Description  'RAZON DE ANULACION',
ANU.DescriptionReversal 'OBSERVACIONES ANULACION',ISNULL(DETSIN.InvoiceNumber,
ISNULL(CON.InvoiceNumber,ISNULL(MAXI.InvoiceNumber,FOL.InvoiceNumber))) 'FACTURA REMPLAZO',
ISNULL(DETSIN.TotalInvoice ,ISNULL(CON.TotalInvoice,ISNULL(MAXI.TotalInvoice,FOL.TotalInvoice))) 'VALOR REMPLAZO',
ISNULL(DETSIN.InvoiceDate  ,ISNULL(CON.InvoiceDate,ISNULL(MAXI.InvoiceDate,FOL.InvoiceDate))) 'FECHA FACTURA REMPLAZO',
ANU.ReversalReasonId  
--CON.TotalInvoice ,CON.InvoiceNumber,MAXI.InvoiceNumber ,MAXI.TotalInvoice 
FROM CTE_FACTURAS_ANULADAS ANU
INNER JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES =ANU.AdmissionNumber 
LEFT JOIN CTE_FACTURAS_ANULADAS_DETALLE AS DET ON DET.InvoiceId =ANU.Id 
LEFT JOIN CTE_FACTURAS_SIN_ANULAR_DETALLE AS DETSIN ON DETSIN.AdmissionNumber =DET.AdmissionNumber AND DETSIN .SOD =DET.SOD
LEFT JOIN CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO AS CON ON CON.AdmissionNumber =ANU.AdmissionNumber AND ANU.TotalInvoice =CON.TotalInvoice 
LEFT JOIN CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_MAX AS MAXI ON ANU.AdmissionNumber=MAXI.AdmissionNumber
LEFT JOIN CTE_FACTURAS_SIN_ANULAR_CONSOLIDADO_FOLIO FOL ON ANU.AdmissionNumber=FOL.AdmissionNumber
LEFT JOIN Billing .Invoice AS FAC ON FAC.Id =DETSIN.InvoiceId 
-- IN V2 WHERE ING.IESTADOIN NOT IN ('C','A') FN V2
)

SELECT DISTINCT
ANU.INGRESO ,ANU.ESTADO ,ANU.IDENTIFICACION ,
rtrim(ANU.PACIENTE) 'PACIENTE' ,
RTRIM(ANU.ENTIDAD) 'ENTIDAD' ,
ANU.[FACTURA ANULADA] ,
ANU.[FECHA ANULACION] ,ANU.[FECHA DE FACTURA] ,ANU.[VALOR ANULADO],
ANU.[USUARIO FACTURO] ,
ANU.[USUARIO ANULO] ,
ANU.[FECHA ANULACION] ,
BRR.Description 'RAZONES ANULACION',
ANU.[OBSERVACIONES ANULACION] ,
ANU.[FACTURA REMPLAZO] ,
ANU.[VALOR REMPLAZO] ,
ANU.[FECHA FACTURA REMPLAZO] 
FROM CTE_FINAL_FACTURA_ANULADAS ANU
LEFT JOIN Billing.BillingReversalReason AS BRR ON BRR.ID=ANU.ReversalReasonId 
--where ANU.INGRESO='5F6AAB700A'
