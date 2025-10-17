-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCircular056_EarlyWarning
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/**************************************************************************************************************************
--Nombre: [Report].[Circular056_EarlyWarning]
--Tipo:Vista
--Observacion:Indicadores Circular 056 Alerta Temprana
--Profesional: Amira Gil Meneses
--Fecha:20/12/2022
------------------------------------------------------------------------------------------
--Modificaciones
------------------------------------------------------------------------------------------
--Versión 1
--Persona que modifico: 
--Fecha:
--Observaciones: 
------------------------------------------------------------------------------------------
*****************************************************************************************************************************/

CREATE VIEW [Report].[ViewCircular056_EarlyWarning] AS

WITH 

CTE_PACIENTE AS
(
SELECT
PAC.IPCODPACI,
CASE PAC.IPTIPODOC WHEN '1'  THEN 'CEDULA DE CIUDADANIA'
				 WHEN '2'  THEN 'CEDULA DE EXTRANJERIA'
				 WHEN '3'  THEN 'TARJETA DE IDENTIDAD'
				 WHEN '4'  THEN 'REGISTRO CIVIL' 
				 WHEN '5'  THEN 'PASAPORTE'
				 WHEN '6'  THEN 'ADULTO SIN IDENTIFICACION'
				 WHEN '7'  THEN 'MENOR SIN IDENTIFICACION'
				 WHEN '8'  THEN 'NUMERO UNICO DE IDENTIFICACIÒN'
				 WHEN '9'  THEN 'CERTIFICADO NACIDO VIVO'
				 WHEN '10' THEN 'CARNET DIPLOMATICO'
				 WHEN '11' THEN 'SALVOCONDUCTO'
				 WHEN '12' THEN 'PERMISO ESPECIAL DE PERMANENCIA' END AS [TIPO_DOC],
PAC.IPCODPACI AS [NUM_DOC],
CAST(PAC.IPFECNACI AS DATE) AS [FECHA_NACI],
CASE PAC.IPSEXOPAC WHEN 1 THEN 'H'
				   WHEN 2 THEN 'F' ELSE 'I' END AS [GENERO],
PAC.IPNOMCOMP AS [NOMBRES Y APELLIDOS],
ENT.HealthEntityCode AS [ENTIDAD]

FROM
DBO.INPACIENT PAC INNER JOIN
Contract.HealthAdministrator ENT ON PAC.CODENTIDA=ENT.Code 
INNER JOIN DBO.ADTIPOIDENTIFICA TID ON PAC.IPTIPODOC=TID.CODIGO
),

CTE_CANCELACION AS
(
SELECT
CAN.Id,
CAN.CancellationDate,
USU.NOMUSUARI,
CAN.CancellationReasonsObservations
FROM
[Authorization].TraceabilityPaperwork CAN INNER JOIN
dbo.SEGusuaru USU ON CAN.CancellationUserCode=USU.CODUSUARI
),
------------------------------------------------------------------------------------------
--Genera la información de los indicadores:

--1 Tiempo de Espera en Consulta Medica general Cups 890201
--2 Tiempo de Espera en Consulta Medica Especializada Medicina Interna Cups 890266
--3 Tiempo de Espera en Consulta Medica Especializada Ginecologia Cups 890250
--4 Tiempo de Espera en Consulta Medica Especializada Pediatria Cups 890283
--5 Tiempo de Espera en Consulta Medica Especializada Cirugia General Cups 890235
--6 Tiempo de Espera en Consulta Medica Especializada Obstetricia Cups 890250
--7 Tiempo de Espera en Consulta de Odontologia General Cups 890203
--8 Oportunidad de Servicios de Imagenologia y Diagnostico General Radiologia Simple
------------------------------------------------------------------------------------------
CTE_INDICADORES as  (
SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
AGC.CODCENATE AS [CENTRO ATENCIÓN],
PAC.[TIPO_DOC],
PAC.[NUM_DOC],
PAC.[FECHA_NACI],
PAC.[GENERO],
PAC.[NOMBRES Y APELLIDOS],
PAC.[ENTIDAD],
CASE AGC.CODSERIPS WHEN '890201' THEN '01 - Tiempo de espera en consulta medica general'
                   WHEN '890266' THEN '02 - Tiempo de espera en consulta medica especializada medicina interna' 				   	   
				   WHEN '890283' THEN '04 - Tiempo de espera en consulta medica especializada pediatria'
				   WHEN '890235' THEN '05 - Tiempo de espera en consulta medica especializada cirugia general'
				   WHEN '890203' THEN '07 - Tiempo de espera en consulta de odontologia general' ELSE
	CASE WHEN ACT.DESACTMED='CONSULTA DE PRIMERA VEZ POR ESPECIALISTA EN GINECOLOGA' AND ACT.CODSERIPS='890250' THEN '03 - Tiempo de espera en consulta medica especializada Ginecologia'
		 WHEN ACT.DESACTMED='CONSULTA DE PRIMERA VEZ POR ESPECIALISTA EN OBSTETRICIA' AND ACT.CODSERIPS='890250' THEN '06 - Tiempo de espera en consulta medica especializada cirugia general'
		 WHEN ACT.DESACTMED='CONSULTA DE PRIMERA VEZ POR ESPECIALISTA EN GINECOLOGA Y OBSTETRICIA 15MIN' AND ACT.CODSERIPS='890250' THEN '03 - Tiempo de espera en consulta medica especializada Ginecologia' ELSE
	CASE WHEN AGC.CODSERIPS BETWEEN '881112' AND '882841' THEN '08 - Oportunidad de servicios de imagenologia y diagnostico general radiologia simple' END END END AS [INDICADOR],
AGC.CODSERIPS AS [CUPS],
ACT.DESACTMED AS [DESCRIPCION CUPS],
CAST (AGC.FECREGSIS AS DATE) AS [FECHA SOLICITUD],
CAST (AGC.FECHAOFERTADA AS DATE) AS [FECHA_RESULTADO_ASIGNADA],
DATEDIFF(day,AGC.FECREGSIS,AGC.FECHAOFERTADA) as [NUMERADOR],
'Citas Asignadas' 'NUM_NOMBRE',
 1 AS [DENOMINADOR],
'Total Dias' 'DEN_NOMBRE',
 1  as 'CANTIDAD',
CAST(AGC.FECREGSIS AS DATE) AS 'FECHA BUSQUEDA', 
 YEAR(AGC.FECREGSIS) AS 'AÑO FECHA BUSQUEDA', 
 MONTH(AGC.FECREGSIS) AS 'MES FECHA BUSQUEDA',
CASE MONTH(AGC.FECREGSIS)
  WHEN 1  THEN 'ENERO'
  WHEN 2  THEN 'FEBRERO'
  WHEN 3  THEN 'MARZO'
  WHEN 4  THEN 'ABRIL'
  WHEN 5  THEN 'MAYO'
  WHEN 6  THEN 'JUNIO'
  WHEN 7  THEN 'JULIO'
  WHEN 8  THEN 'AGOSTO' 
  WHEN 9  THEN 'SEPTIEMBRE'
  WHEN 10 THEN 'OCTUBRE'
  WHEN 11 THEN 'NOVIEMBRE'   
  WHEN 12 THEN 'DICIEMBRE'
 END AS 'MES NOMBRE FECHA BUSQUEDA', 
 DAY(AGC.FECREGSIS) AS 'DIA FECHA BUSQUEDA'
 	,CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM dbo.AGASICITA AS AGC 
INNER JOIN dbo.AGACTIMED AS ACT ON AGC.CODSERIPS=ACT.CODSERIPS
INNER JOIN CTE_PACIENTE PAC ON AGC.IPCODPACI=PAC.IPCODPACI


UNION ALL
------------------------------------------------------------------------------------------
--10 LABORATORIO--
--Oportunidad Toma de Muestras Laboratorio Básico
------------------------------------------------------------------------------------------

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
ORD.CODCENATE AS [CENTRO ATENCIÓN],
PAC.[TIPO_DOC],
PAC.[NUM_DOC],
PAC.[FECHA_NACI],
PAC.[GENERO],
PAC.[NOMBRES Y APELLIDOS],
PAC.[ENTIDAD],
'10 - Oportunidad toma de muestras laboratorio básico' AS [INDICADOR], 
	ORD.CODSERIPS as [CUPS],
	cups.[Description] as [DESCRIPCIÓN CUPS],	
	CAST (ORD.FECORDMED AS DATE) AS [FECHA SOLICITUD],
	CAST (RES.FECREGIST AS DATE) AS [FECHA_RESULTADO_ASIGNADA],
	DATEDIFF(day,ORD.FECORDMED,RES.FECREGIST) as [NUMERADOR],
'Citas Asignadas' 'NUM_NOMBRE',
 1 AS [DENOMINADOR],
'Total Dias' 'DEN_NOMBRE',
 1  as 'CANTIDAD',
	CAST(ORD.FECORDMED AS date) AS 'FECHA BUSQUEDA',
	YEAR(ORD.FECORDMED) AS 'AÑO FECHA BUSQUEDA',
	MONTH(ORD.FECORDMED) AS 'MES FECHA BUSQUEDA',
	CASE MONTH(ORD.FECORDMED) WHEN 1 THEN 'ENERO'
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
	FORMAT(DAY(ORD.FECORDMED), '00') AS 'DIA FECHA BUSQUEDA',
	CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM dbo.HCORDLABO ORD
LEFT JOIN dbo.INUNIFUNC UNF ON ORD.UFUCODIGO=UNF.UFUCODIGO 
LEFT JOIN dbo.INPROFSAL PRO ON PRO.CODPROSAL=ORD.CODPROSAL
LEFT JOIN Contract.CUPSEntity CUPS ON CUPS.Code=ORD.CODSERIPS
LEFT JOIN Contract.CupsSubgroup DCUP ON CUPS.CUPSSubGroupId=DCUP.ID
LEFT JOIN dbo.INPROFSAL PROF on ORD.USURECMUE=prof.CODUSUARI 
LEFT JOIN dbo.INTERCTRL RES ON ORD.AUTO=RES.AUTOLABOR AND RES.AUTO=(SELECT MAX(RE.AUTO) FROM INTERCTRL RE WHERE ORD.AUTO=RE.AUTOLABOR)--RES.ESTADOINT='1'
LEFT JOIN CTE_CANCELACION CAN ON ORD.IPCODPACI=CAN.Id
LEFT JOIN CTE_PACIENTE PAC ON ORD.IPCODPACI=PAC.IPCODPACI

UNION ALL
------------------------------------------------------------------------------------------
--11 CIRUGIA PROGRAMADA--
--Tiempo de Espera en la Realizacion de Cirugia General Programada
------------------------------------------------------------------------------------------
SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
AGX.CODCENATE AS [CENTRO ATENCIÓN],
PAC.[TIPO_DOC],
PAC.[NUM_DOC],
PAC.[FECHA_NACI],
PAC.[GENERO],
PAC.[NOMBRES Y APELLIDOS],
PAC.[ENTIDAD],
'11 - Tiempo de espera en la realizacion de cirugia general programada' AS [INDICADOR],
AGX.CODSERIPS AS [CUPS],
ACT.DESACTMED AS [DESCRIPCION CUPS],
CAST (AGX.FECREGSIS AS DATE) AS [FECHA_SOLICITUD],
CAST (AGX.FECHORAIN AS DATE) AS [FECHA_RESULTADO_ASIGNADA],
DATEDIFF(day,AGX.FECREGSIS,AGX.FECHORAIN) as [NUMERADOR],
'Citas Asignadas' 'NUM_NOMBRE',
 1 AS [DENOMINADOR],
'Total Dias' 'DEN_NOMBRE',
 1  as 'CANTIDAD',
CAST(AGX.FECREGSIS AS DATE) AS 'FECHA BUSQUEDA', 
YEAR(AGX.FECREGSIS) AS 'AÑO FECHA BUSQUEDA', 
MONTH(AGX.FECREGSIS) AS 'MES AÑO FECHA BUSQUEDA',
CASE MONTH(AGX.FECREGSIS)
  WHEN 1  THEN 'ENERO'
  WHEN 2  THEN 'FEBRERO'
  WHEN 3  THEN 'MARZO'
  WHEN 4  THEN 'ABRIL'
  WHEN 5  THEN 'MAYO'
  WHEN 6  THEN 'JUNIO'
  WHEN 7  THEN 'JULIO'
  WHEN 8  THEN 'AGOSTO' 
  WHEN 9  THEN 'SEPTIEMBRE'
  WHEN 10 THEN 'OCTUBRE'
  WHEN 11 THEN 'NOVIEMBRE'   
  WHEN 12 THEN 'DICIEMBRE' END AS 'MES NOMBRE FECHA BUSQUEDA',
 FORMAT (DAY(AGX.FECREGSIS), '00') AS 'DIA FECHA BUSQUEDA',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL

FROM dbo.AGEPROGQX AGX 
INNER JOIN dbo.AGACTIMED ACT ON AGX.CODSERIPS=ACT.CODSERIPS
INNER JOIN CTE_PACIENTE PAC ON AGX.IPCODPACI=PAC.IPCODPACI

UNION ALL
------------------------------------------------------------------------------------------
-- 13 TRIAGE--
--Tiempo de Espera Consulta de Urgencias Triage II
------------------------------------------------------------------------------------------
SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
TRI.CODCENATE AS [CENTRO ATENCIÓN],
PAC.[TIPO_DOC],
PAC.[NUM_DOC],
PAC.[FECHA_NACI],
PAC.[GENERO],
PAC.[NOMBRES Y APELLIDOS],
PAC.[ENTIDAD],
'13 - Tiempo de espera consulta de urgencias Triage II' AS [INDICADOR],
NULL AS [CUPS],
NULL AS [DESCRIPCIÓN CUPS],
CONVERT(VARCHAR(5),CAST(TRI.FECINGURG AS TIME)) AS [FECHA SOLICITUD], --SOLO HORA--
CONVERT(VARCHAR(5),CAST(TRI.FECINFORM AS TIME)) AS [FECHA_RESULTADO_ASIGNADA], --SOLO HORA--
DATEDIFF(day,TRI.FECINGURG,TRI.FECINFORM ) as [NUMERADOR],
'Total Minutos' 'NUM_NOMBRE',
 1 AS [DENOMINADOR],
'Total Pacientes' 'DEN_NOMBRE',
1  as 'CANTIDAD',
CAST(TRI.FECINGURG AS DATE) AS 'FECHA BUSQUEDA', 
YEAR(TRI.FECINGURG) AS 'AÑO FECHA BUSQUEDA', 
MONTH(TRI.FECINGURG) AS 'MES AÑO FECHA BUSQUEDA',
CASE MONTH(TRI.FECINGURG)
  WHEN 1  THEN 'ENERO'
  WHEN 2  THEN 'FEBRERO'
  WHEN 3  THEN 'MARZO'
  WHEN 4  THEN 'ABRIL'
  WHEN 5  THEN 'MAYO'
  WHEN 6  THEN 'JUNIO'
  WHEN 7  THEN 'JULIO'
  WHEN 8  THEN 'AGOSTO' 
  WHEN 9  THEN 'SEPTIEMBRE'
  WHEN 10 THEN 'OCTUBRE'
  WHEN 11 THEN 'NOVIEMBRE'   
  WHEN 12 THEN 'DICIEMBRE' END AS 'MES NOMBRE FECHA BUSQUEDA' ,
 FORMAT( DAY(TRI.FECINGURG), '00') AS 'DIA FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM dbo.ADATEINIU AS TRI
INNER JOIN CTE_PACIENTE PAC ON TRI.IPCODPACI=PAC.IPCODPACI

UNION ALL
------------------------------------------------------------------------------------------
-- 9 IMAGENOLOGIA Y DX ESPECIALIZADO TAC-
--Oportunidad de Servicios de Imagenologia y Diagnostico Especializado TAC
------------------------------------------------------------------------------------------
SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
A.CODCENATE AS [CENTRO ATENCIÓN],
PAC.[TIPO_DOC],
PAC.[NUM_DOC],
PAC.[FECHA_NACI],
PAC.[GENERO],
PAC.[NOMBRES Y APELLIDOS],
PAC.[ENTIDAD],
'09 - Oportunidad de servicios de imagenologia y diagnostico especializado TAC' AS [INDICADOR],
	A.CODSERIPS AS [CUPS],
	cups.[Description] as [DESCRIPCIÓN CUPS],
	CAST (A.FECORDMED AS DATE) AS [FECHA SOLICITUD],
	CAST (A.FECRECEXA AS DATE) AS [FECHA_RESULTADO_ASIGNADA],
	DATEDIFF(day,A.FECORDMED,A.FECRECEXA) as [NUMERADOR],
'Citas Asignadas' 'NUM_NOMBRE',
 1 AS [DENOMINADOR],
'Total Dias' 'DEN_NOMBRE',
   1  as 'CANTIDAD',
	CAST(A.FECORDMED AS date) AS 'FECHA BUSQUEDA',
	YEAR(A.FECORDMED) AS 'AÑO FECHA BUSQUEDA',
	MONTH(A.FECORDMED) AS 'MES FECHA BUSQUEDA',
	 CASE MONTH(A.FECORDMED) WHEN 1 THEN 'ENERO'
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
	FORMAT(DAY(A.FECORDMED), '00') AS 'DIA FECHA BUSQUEDA',
	CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
	FROM dbo.AMBORDIMA AS A
	INNER JOIN dbo.INCUPSIPS B WITH (NOLOCK) ON  A.CODSERIPS=B.CODSERIPS
	INNER JOIN CTE_PACIENTE PAC ON A.IPCODPACI=PAC.IPCODPACI
	LEFT JOIN Contract.CUPSEntity CUPS ON CUPS.Code=A.CODSERIPS
 )

 SELECT
  *
 FROM
  CTE_INDICADORES
 WHERE 
  [INDICADOR] IS NOT NULL
