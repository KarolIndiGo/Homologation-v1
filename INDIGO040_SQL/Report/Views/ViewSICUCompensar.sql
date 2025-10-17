-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewSICUCompensar
-- Extracted by Fabric SQL Extractor SPN v3.9.0






/*******************************************************************************************************************
Nombre: [Report].[ViewSICUCompensar]
Tipo:Vista
Observacion:Archivo que se debe generar para asociar el envío de historias clínicas a Compensar, 
			esto para dar cumplimiento con el compromiso adquirido por parte del Hospital San Jose con el pagador(compensar).  
Profesional: Nilsson Miguel Galindo
Fecha:13-10-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:29-11-2023
Ovservaciones:Se quita el numero de autorizacion por el numero de ingreso, tambien se cambia la fecha de la factura a fecha de la atencion
			  Esto solicitado por el hospital
--------------------------------------
Version 3
Persona que modifico:
Fecha:
Ovservaciones:
***********************************************************************************************************************************/
CREATE view [Report].[ViewSICUCompensar] as

WITH
--CTE_NumeroAutorizacion as
--(
--SELECT 
--SO.AdmissionNumber,
--SOD.AuthorizationNumber
--FROM
--Billing.ServiceOrderDetail SOD INNER JOIN
--Billing.ServiceOrder SO ON SOD.ServiceOrderId=SO.ID AND SOD.AuthorizationNumber IS NOT NULL AND SOD.AuthorizationNumber!=''
----WHERE SO.AdmissionNumber='69401'
--GROUP BY SO.AdmissionNumber,SOD.AuthorizationNumber
--),
CTE_CONSULTA AS
(
SELECT
'899999017'AS [NIT de la institución],
SO.AdmissionNumber AS [No de Autorización],
CASE PAC.IPTIPODOC WHEN 1 THEN 1
				   WHEN 16 THEN 2
				   WHEN 3 THEN 3
				   WHEN 2 THEN 4
				   WHEN 5 THEN 5
				   WHEN 10 THEN 6
				   WHEN 4 THEN 7
				   WHEN 8 THEN 8
				   WHEN 9 THEN 9
				   WHEN 11 THEN 10
				   WHEN 12 THEN 11
				   WHEN 6 THEN 12
				   WHEN 7 THEN 13
				   WHEN 13 THEN 14 END AS [Tipo de identificación paciente],
SO.PatientCode AS [Número de identificación del paciente],
CASE PAC.IPTIPODOC WHEN 1 THEN 'CC'
				   WHEN 16 THEN 'NI'
				   WHEN 3 THEN 'TI'
				   WHEN 2 THEN 'CE'
				   WHEN 5 THEN 'PA'
				   WHEN 4 THEN 'RC'
				   WHEN 8 THEN 'NUI'
				   WHEN 9 THEN 'CN'
				   WHEN 10 THEN 'CD'
				   WHEN 12 THEN 'PE'
				   WHEN 13 THEN 'PE'
				   WHEN 11 THEN 'SV' END AS [NUIP],
CUPS.Code AS [Código cups],
FACD.ServiceDate AS [Fecha de atención],
'FACTURADO' AS [Estado de la Factura],
CASE WHEN FUN.[Name] LIKE '%URGENCIAS%' THEN '4' 
	 WHEN FUN.[Name] LIKE '%CONSULTA EXTERNA%' THEN '1' 
	 WHEN FUN.[Name]='SANTA TERESITA AMBULATORIO' THEN '1' 
	 WHEN FUN.[Name]LIKE'%HOSPITALIZACI%ON%' THEN '3'  
	 WHEN FUN.[Name]='CIRUGIA GENERAL CONSULTA EXTERNA' THEN '2'
	 WHEN FUN.[Name]='CIRUGIA PLASTICA CONSULTA EXTERNA' THEN '2' 
	 WHEN FUN.[Name]='SALAS UNIDAD QUIRURGICA' THEN '3' ELSE CASE CUPS.ServiceType WHEN 1 THEN '5' 
																				   WHEN 2 THEN '8'
																				   WHEN 3 THEN '6' 
																				   WHEN 4 THEN '4'
																				   WHEN 8 THEN '1' ELSE SO.AdmissionNumber END END AS [Tipo de Servicio],
CUPS.Description,
SO.AdmissionNumber,
'899999017-4'AS [NIT Origen],
'EPS008' AS EPS,
ING.IFECHAING AS [FECHA INGRESO],
ISNULL(ING.FECHEGRESO,ISNULL(HCN.FECINIATE,ISNULL(HCU.FECINIATE,HCUR.FECINIATE))) AS [FECHA EGRESO]
FROM 
Billing.ServiceOrderDetail SOD 
INNER JOIN Billing.ServiceOrder SO ON SOD.ServiceOrderId=SO.ID 
INNER JOIN dbo.INPACIENT PAC ON SO.PatientCode=PAC.IPCODPACI 
INNER JOIN Contract.CUPSEntity CUPS ON SOD.CUPSEntityId=CUPS.Id 
INNER JOIN Billing.InvoiceDetail FACD ON SOD.ID=FACD.ServiceOrderDetailId 
INNER JOIN Billing.Invoice FAC ON FACD.InvoiceId=FAC.Id AND FAC.Status=1 
INNER JOIN Payroll.FunctionalUnit FUN ON SOD.PerformsFunctionalUnitId=FUN.Id 
INNER JOIN Contract.HealthAdministrator EPS ON SOD.HealthAdministratorId=EPS.ID AND EPS.HealthEntityCode='EPS008'
INNER JOIN dbo.ADINGRESO ING ON SO.AdmissionNumber=ING.NUMINGRES
LEFT JOIN dbo.HCNOTEVO1 HCN ON SO.AdmissionNumber=HCN.NUMINGRES AND HCN.INDICAPAC IN (11,12,15,16)
LEFT JOIN dbo.HCURGING1 HCU ON SO.AdmissionNumber=HCU.NUMINGRES AND HCU.INDICAPAC IN (11,12,15,16)
LEFT JOIN dbo.HCURGEVO1 HCUR ON SO.AdmissionNumber=HCUR.NUMINGRES AND HCUR.INDICAPAC IN (11,12,15,16)
--LEFT JOIN CTE_NumeroAutorizacion AU ON SO.AdmissionNumber=AU.AdmissionNumber
--WHERE FAC.AdmissionNumber='71265'
)

SELECT TOP 100 PERCENT * 
FROM CTE_CONSULTA 
WHERE [Tipo de Servicio] IN ('3','4')
ORDER BY [FECHA EGRESO]
