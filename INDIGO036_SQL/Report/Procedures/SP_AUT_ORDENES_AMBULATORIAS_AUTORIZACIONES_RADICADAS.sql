-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_AUT_ORDENES_AMBULATORIAS_AUTORIZACIONES_RADICADAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE PROCEDURE [Report].[SP_AUT_ORDENES_AMBULATORIAS_AUTORIZACIONES_RADICADAS]
 @FechaInicial as DATETIME,
 @FechaFinal as DATETIME
AS


 --declare @FechaInicial DATETIME='2022-12-01'
 --declare @FechaFinal DATETIME ='2022-12-31';


WITH 
CTE_ORDENES
AS
(
-- Ordenes de imagenes ambulatorias
SELECT 'HCORDIMAG' EntityName, h.AUTO EntityId,	h.CANSERIPS Quantity,h.OBSSERIPS Observations
FROM DBO.HCORDIMAG h
WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
UNION ALL
-- Ordenes de laboratorios ambulatorios
SELECT 'HCORDLABO' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity,h.CODSERIPS Observations
FROM DBO.HCORDLABO h
WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('6')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
UNION ALL
-- Ordenes de patologias ambulatorias
SELECT 'HCORDPATO' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity,h.OBSSERIPS Observations
FROM DBO.HCORDPATO h
WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
UNION ALL
-- Ordenes de interconsultas ambulatorias
SELECT 'HCORDINTE' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity,h.OBSSERIPS Observations
FROM DBO.HCORDINTE h
WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
UNION ALL
-- Ordenes de procedimientos no Qx ambulatorias
SELECT 'HCORDPRON' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity,h.OBSSERIPS Observations
FROM DBO.HCORDPRON h
WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
UNION ALL
-- Ordenes de procedimientos Qx ambulatorias
SELECT	'HCORDPROQ' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity, h.OBSSERIPS Observations
FROM DBO.HCORDPROQ h
WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
UNION ALL
--Hemocomponentes
SELECT 'HCORHEMCO' EntityName, h.ID EntityId, hd.Quantity Quantity,'' Observations
FROM .ADINGRESO ing
INNER JOIN .HCORHEMCO h ON ing.NUMINGRES = h.NUMINGRES
INNER JOIN 
(
	SELECT	hd.HCORHEMCOID, 
			hd.CODSERIPS, 
			hd.TraceabilityPaperworkId, 
			hd.TraceabilityPaperworkEventsId, 
			hd.IDDESCRIPCIONRELACIONADA,
			COUNT(1) Quantity
	FROM .HCORHEMSER hd
	WHERE hd.ESTADO NOT IN (3)
	GROUP BY hd.HCORHEMCOID, hd.CODSERIPS, hd.TraceabilityPaperworkId, hd.TraceabilityPaperworkEventsId, hd.IDDESCRIPCIONRELACIONADA
) hd ON h.ID = hd.HCORHEMCOID
WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
UNION ALL
-- Ordenes de control por la especialidad que atendió al paciente
SELECT 'HCDESCOEX' EntityName, h.AUTO EntityId, 1 Quantity, hc.INDICAMED Observations
FROM dbo.HCHISPACA hc
INNER JOIN .HCDESCOEX h ON hc.NUMINGRES = h.NUMINGRES AND hc.NUMEFOLIO = h.NUMEFOLIO
WHERE cast(hc.FECHISPAC as date) between @FechaInicial and @FechaFinal
),

CTE_AUTORIZACIONES_AMBULATORIAS_RADICADAS
AS
(
select TP.Id ,RTRIM(ha.Name) 'ENTIDAD',CG.Code 'CODIGO GRUPO', RTRIM(CG.Name) 'GRUPO DE ATENCION',
CASE PAC.IPTIPODOC WHEN '1' THEN 'CEDULA DE CIUDADANIA' WHEN '2' THEN 'CEDULA DE EXTRANJERIA' WHEN '3' THEN 'TARJETA DE IDENTIDAD' WHEN '4' THEN 'REGISTRO CIVIL'
WHEN '5' THEN 'PASAPORTE' WHEN '6' THEN 'ADULTO SIN IDENTIFICACION' WHEN '7' THEN 'MENOR SIN IDENTIFICACION' WHEN '8' THEN 'NUMERO UNICO DE IDENTIFICACION'
WHEN '9' THEN 'CERTIFICADO NACIDO VIVO' WHEN '10' THEN 'CARNET DIPLOMATICO'WHEN '11' THEN 'SALVOCONDUCTO' WHEN '12' THEN 'PERMISO ESPECIAL DE PERMANENCIA' 
WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA' WHEN '14' THEN 'DOCUMENTO EXTRANJERO' WHEN '15' THEN 'SIN IDENTIFICACION' END AS 'TIPO IDENTIFICACION',
TP.PatientCode 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',PAC.IPTELEFON 'TELEFONO',PAC.IPTELMOVI 'CELULAR',PAC.IPDIRECCI 'DIRECCION',tp.AdmissionNumber 'INGRESO' ,tp.Folio 'FOLIO' ,
CASE CUPS.ServiceType WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas'
  WHEN 4 THEN 'Procedimientos no Qx' WHEN 5 THEN 'Procedimientos Qx' WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa'
  WHEN 9 THEN 'HEMOCOMPONENTES' END 'TIPO SERVICIO',tp.ServiceCode 'CODIGO CUPS ORDENADO',CUPS.Description 'DESCRIPCION CUPS ORDENADO',cd.Name 'DESCRIPCION RELACIONADA',
TP.RequestQuantity 'CANTIDAD ORDENADA' ,tp.RequestDate 'FECHA ORDEN','AUTORIZACION EN PROCESO' 'ESTADO',
CASE TP.Status WHEN 1 THEN 'SOLICITADO' WHEN 2 THEN 'RADICADO' WHEN 3 THEN 'RADICADO PENDIENTE AUTORIZACION' WHEN 4 THEN 'RADICADO NO AUTORIZADO' END 'ESTADO DETALLADO',
CASE TPE.ReportType WHEN 1 THEN 'Llamada Telefónica' WHEN 2 THEN 'Envío Físico' WHEN 3 THEN 'Registro Página Web' WHEN 4 THEN 'Correo Electrónico'
WHEN 5 THEN 'Tramita Paciente' END 'TIPO REPORTE',
CASE TPE.Status WHEN 1 THEN 'Pendiente por Autorizar' WHEN 2 THEN 'Autorizado'  WHEN 3 THEN 'No Autorizado' WHEN 4 THEN 'Autorizado con Aval' END 'ESTADO EVENTO',
IIF(tp.AdmissionNumber IS NULL,TP.DocumentDate,
IIF(TPE.ReportType ='5',TPE.CreationDate,ISNULL(TPE.RegistrationDate,ISNULL(TPE.SendDate,ISNULL(TPE.InitialTime,ISNULL(TPE.CreationDate,TP.DocumentDate)))))) 'FECHA RADICADO', 
TPE.RadicateNumber 'NUMERO RADICADO',USU.NOMUSUARI 'USUARIO CREO',PRO.NOMMEDICO 'PROFESIONAL',ESP.DESESPECI 'ESPECIALIDAD',ISNULL(ING.CODDIAING,ING.CODDIAEGR) 'CIE10',
DIA.NOMDIAGNO 'DIAGNOSTICO',ORD.Observations AS OBSERVACION
from [Authorization].TraceabilityPaperwork tp with(nolock)
INNER JOIN Contract .CUPSEntity AS CUPS with(nolock) ON CUPS.CODE =tp.ServiceCode
INNER JOIN DBO.INPACIENT AS PAC with(nolock) ON PAC.IPCODPACI =TP.PatientCode 
INNER JOIN INPROFSAL AS PRO with(nolock) ON PRO.CODPROSAL =tp.ProfessionalCode  
INNER JOIN INESPECIA AS ESP with(nolock) ON ESP.CODESPECI =PRO.CODESPEC1
LEFT JOIN DBO.ADINGRESO AS ING with(nolock) ON ING.NUMINGRES =tp.AdmissionNumber
LEFT JOIN Contract .HealthAdministrator ha with(nolock) on ha.Id =tp.HealthAdministratorId 
LEFT JOIN Contract .CareGroup AS CG with(nolock) ON CG.Id =TP.CareGroupId 
LEFT JOIN [Authorization].TraceabilityPaperworkEvents AS TPE with(nolock) ON TPE.TraceabilityPaperworkId =TP.Id 
LEFT JOIN SEGusuaru AS USU with(nolock) ON USU.CODUSUARI =TPE.CreationUser 
LEFT JOIN DBO.INDIAGNOS AS DIA with(nolock) ON DIA.CODDIAGNO =ISNULL(ING.CODDIAING,ING.CODDIAEGR)
--LEFT JOIN Contract.CUPSEntityContractDescriptions cecd ON CUPS.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
LEFT JOIN Contract.ContractDescriptions cd ON tp.ContractDescriptionId = cd.Id
LEFT JOIN CTE_ORDENES ORD ON TP.EntityName=ORD.EntityName AND TP.EntityId=ORD.EntityId
where tp.Type =1 and tp.Status in (1,2,3) AND cast(tp.RequestDate as date) between @FechaInicial and @FechaFinal
)

SELECT * FROM 
CTE_AUTORIZACIONES_AMBULATORIAS_RADICADAS AUT
ORDER BY AUT.Id ,AUT.[FECHA ORDEN]
