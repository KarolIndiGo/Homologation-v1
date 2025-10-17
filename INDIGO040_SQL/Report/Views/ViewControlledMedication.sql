-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewControlledMedication
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[ViewControlledMedication]
Tipo: Vista
Observacion:Registro por parte del medico cuando solicita un medicamento controlado, con su respectiva dispensación y devoluciones,
			cuando se amerita.
Profesional: Nilsson Miguel Galindo Lopez
Fecha:27-10-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:27-11-2023
Observaciones: Se cambia la logica para que la tabla principal no sea la tabla dbo.HCPRODUCTOSCONTROL, si no la de dispensacion.
-------------------------------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewControlledMedication] AS 

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
CEN.NOMCENATE AS [CENTRO DE ATENCION],
DOC.NOMBRE AS [TIPO IDENTIFICACION],
PAC.IPCODPACI AS [IDENTIFICACION],
PAC.IPNOMCOMP AS [PACIENTE],
CASE PAC.IPSEXOPAC WHEN 1 THEN 'MASCULINO' ELSE 'FEMENINO' END AS[GENERO DEL PACIENTE],
CAST(PAC.IPFECNACI AS DATE) AS [FECHA DE NACIMIENTO],
CASE ING.CODTIPPAC WHEN '1' THEN 'Maternas' 
				   WHEN '2' THEN 'Pediatrico'
				   WHEN '3' THEN 'Población general' 
				   WHEN '4' THEN 'Adulto mayor' 
				   WHEN '5' THEN 'Población general' END AS [TIPO DE PACIENTE], 
DATEDIFF(YEAR,PAC.IPFECNACI,ING.IFECHAING)-(CASE WHEN DATEADD(YY,DATEDIFF(YEAR,IPFECNACI,ING.IFECHAING),IPFECNACI)>ING.IFECHAING THEN 1 ELSE 0 END) AS EDAD,
HEA.Code AS [CODIGO ENTIDAD],
HEA.Name AS [ENTIDAD],
CG.Name AS [GRUPO DE ATENCION],
RTRIM(UFU.UFUCODIGO)+' - '+UFU.UFUDESCRI AS [UNIDAD FUNCIONAL],
CON.NUMINGRES AS INGRESO,
CON.NUMEFOLIO AS FOLIO,
CON.INCONSECUCONTROL AS [CONSECUTIVO DE CONTROL],
CON.FECHAREGISTRO AS [FECHA SOLICITUD],
CON.CODPRODUC AS [CODIGO MEDICAMENTO],
PRO.Description AS [MEDICAMENTO],
CON.CANTIDAD AS [CANTIDAD],
IIF(DIS.Code IS NULL,IIF(ING.FECHEGRESO IS NULL,'SOLICITADO','CANCELADO'),'DISPENSADO') AS ESTADO,
RTRIM(PROM.CODPROSAL)+' - '+PROM.NOMMEDICO AS [MEDICO PRESCRIPTOR],
DIS.Code AS [CODIGO DISPENSACION],
DIS.ConfirmationDate AS [FECHA Y HORA DISPENSACION],
DISD.Quantity AS [CANTIDAD DISPENSADA],
RTRIM(USU.CODUSUARI)+' - '+USU.NOMUSUARI AS [USUARIO DISPENSACION],
DD.Code AS [CODIGO DEVOLUCIÓN],
DD.ConfirmationDate as [FECHA DEVOLUCION],
DDD.Quantity AS [CANTIDAD DEVOLUCION],
SOD.RateManualSalePrice AS [VALOR UNITARIO],
CAST(CON.FECHAREGISTRO AS date) AS 'FECHA BUSQUEDA',
YEAR(CON.FECHAREGISTRO) AS 'AÑO FECHA BUSQUEDA',
MONTH(CON.FECHAREGISTRO) AS 'MES FECHA BUSQUEDA',
CASE MONTH(CON.FECHAREGISTRO) WHEN 1 THEN 'ENERO'
								WHEN 2 THEN 'FEBRERO'
								WHEN 3 THEN 'MARZO'
								WHEN 4 THEN 'ABRIL'
								WHEN 5 THEN 'MAYO'
								WHEN 6 THEN 'JUNIO'
								WHEN 7 THEN 'JULIO'
								WHEN 8 THEN 'AGOSTO'
								WHEN 9 THEN 'SEPTIEMBRE'
								WHEN 10 THEN 'OCTUBRE'
								WHEN 11 THEN 'NOVIEMBRE'
								WHEN 12 THEN 'DICIEMBRE' END AS 'MES NOMBRE FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
Inventory.PharmaceuticalDispensing DIS
INNER JOIN Inventory.PharmaceuticalDispensingDetail DISD ON DIS.Id=DISD.PharmaceuticalDispensingId
INNER JOIN Inventory.InventoryProduct PRO ON DISD.ProductId=PRO.Id AND ProductControl=1
INNER JOIN dbo.ADINGRESO ING ON DIS.AdmissionNumber=ING.NUMINGRES
INNER JOIN dbo.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE 
INNER JOIN dbo.INPACIENT PAC ON ING.IPCODPACI=PAC.IPCODPACI 
LEFT JOIN dbo.ADTIPOIDENTIFICA DOC ON PAC.IPTIPODOC=DOC.CODIGO
LEFT JOIN dbo.INUNIFUNC UFU ON CAST(DISD.FunctionalUnitId AS varchar)=UFU.UFUCODIGO
LEFT JOIN dbo.HCFARMEPD D ON DISD.EntityId=D.ID AND DISD.EntityName='HCFARMEPD'
LEFT JOIN dbo.HCPRESCRA A ON D.IdSourceTable=A.ID AND D.SourceTable='HCPRESCRA'
LEFT JOIN dbo.HCPRODUCTOSCONTROL CON ON A.CODCONCEC=CON.CODCONCECMED AND CON.CODPRODUC=A.CODPRODUC
LEFT JOIN dbo.INPROFSAL PROM ON CON.CODPROSAL=PROM.CODPROSAL
LEFT JOIN CONTRACT.HEALTHADMINISTRATOR HEA ON CAST(ING.GENCONENTITY as varchar) = HEA.Code
LEFT JOIN Contract.CareGroup CG ON CAST(ING.GENCAREGROUP as varchar) = CG.Code
LEFT JOIN dbo.SEGusuaru USU ON DIS.ConfirmationUser=USU.CODUSUARI
LEFT JOIN Inventory.PharmaceuticalDispensingDetailBatchSerial BAT ON DISD.Id=BAT.PharmaceuticalDispensingDetailId
LEFT JOIN Inventory.PharmaceuticalDispensingDevolutionDetail DDD ON BAT.Id=DDD.PharmaceuticalDispensingDetailBatchSerialId
LEFT JOIN Inventory.PharmaceuticalDispensingDevolution DD ON DDD.PharmaceuticalDispensingDevolutionId=DD.Id AND DD.Status=2
LEFT JOIN Billing.ServiceOrder SO ON DIS.Id=SO.EntityId AND SO.EntityName='PharmaceuticalDispensing'
LEFT JOIN Billing.ServiceOrderDetail SOD ON SO.Id=SOD.ServiceOrderId AND PRO.Id=SOD.ProductId