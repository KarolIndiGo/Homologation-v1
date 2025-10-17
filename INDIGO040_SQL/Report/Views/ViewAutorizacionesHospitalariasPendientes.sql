-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewAutorizacionesHospitalariasPendientes
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre: [Report].[ViewAutorizacionesHospitalariasPendientes]
Tipo:Vista
Observacion:LISTADO DE PACIENTES DASHBOAR AUTORIZACIONES HOSPITALARIAS - SOLICITUDES PENDIENTES DEE AUTORIZACION
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo
Fecha: 09-03-2023
Ovservaciones:Se ajusta la velocidad del reporte pasando de mas de 20 minutos de ejecución a menos de dos minutos manteniendo la logica principal de
			  la vista original, ademas se suprime una función la cual permitia generar una fecha maxima.
--------------------------------------
Version 3
Persona que modifico:
Fecha:
***********************************************************************************************************************************/

--IN V2

--CREATE VIEW [Report].[ViewAutorizacionesHospitalariasPendientes] AS
------*****1. SCRIPS LISTADO DE PACIENTES DASHBOAR AUTORIZACIONES HOSPITALARIAS - SOLICITUDES PENDIENTES DEE AUTORIZACION*******-------
--DECLARE	@FechaInicio Datetime ='2022-05-01';
--DECLARE	@FechaFin Datetime ='2022-05-05';

--WITH CTE_AUTORIZACIONES_HOSPITALARIAS
--AS
--(
--SELECT  
--CASE WHEN I.NUMINGRES IS NULL THEN '3- Pacientes en la unidad' ELSE '2- Pacientes alta medica' END AS Egreso, 
--CASE J.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END AS Alerta,
--RTRIM(DESCCAMAS) AS Cama,
--dbo.ClaseHabitacion(A.CODCLAHAB) AS ClaseHabitacion,
--dbo.ClaseCama(A.CODCLACAM) AS 'Clase de Cama', 
--C.IPCODPACI AS Identificacion,
--C.NUMINGRES AS Ingreso, 
--dbo.TipoAislamiento(A.CODAISLAM) AS Aislamiento,
--RTRIM(DESTIPEST) AS 'Tipo Estancia',
--RTRIM(IPNOMCOMP) AS Paciente, 
--A.CODCONCEC AS Consecutivo,CAST('' as bit) AS MuestraAlerta,
--J.CODESPTRA AS CodigoEspecialidad,RTRIM(K.DESESPECI) AS DescripcionEspecialidad,CAST(IFECHAING AS DATE) 'Fecha Ingreso', RTRIM(J.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', 
--RTRIM(J.UFUACTPAC) as CodigoUfuActual, CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS FechaEgreso, CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
--FLOOR((CAST(CONVERT(VARCHAR(8), J.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
--RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as EntidadPaciente,C.ID ,C.FECINIEST ,C.FECFINEST
--FROM 
--dbo.CHCAMASHO A INNER JOIN 
--dbo.ADcenaten D ON A.CODCENATE=D.CODCENATE INNER JOIN 
--dbo.INUNIFUNC E ON A.UFUCODIGO=E.UFUCODIGO INNER JOIN 
--dbo.CHREGESTA C ON A.CODICAMAS=C.CODICAMAS AND C.REGESTADO = 1
--INNER JOIN dbo.CHTIPESTA G ON G.CODTIPEST=C.CODTIPEST 
--INNER JOIN dbo.INPacient H ON C.IPCODPACI=H.IPCODPACI
--LEFT  JOIN	dbo.INENTIDAD P ON P.CODENTIDA = H.CODENTIDA
--LEFT  JOIN dbo.HCREGEGRE I ON C.NUMINGRES=I.NUMINGRES
--INNER JOIN dbo.ADINGRESO J ON C.NUMINGRES=J.NUMINGRES
--INNER JOIN dbo.INESPECIA K ON J.CODESPTRA=K.CODESPECI
--INNER JOIN dbo.INUNIFUNC U ON U.UFUCODIGO = J.UFUACTPAC
--WHERE A.CODCENATE= '11011' AND 
--ESTADCAMA = 2 AND 
--NOT EXISTS ( SELECT 1 
--	FROM [Authorization].PatientConfirmation PC 
--	WHERE PC.AdmisionNumber = C.NUMINGRES AND 
--			PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES)
--)
--UNION ALL
--SELECT  '4- Pacientes egresados' AS Egreso, 
--CASE J.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta, RTRIM(DESCCAMAS) AS Cama,dbo.ClaseHabitacion(A.CODCLAHAB) AS ClaseHabitacion,dbo.ClaseCama(A.CODCLACAM) AS 'Clase de Cama', C.IPCODPACI AS Identificacion,C.NUMINGRES AS Ingreso, dbo.TipoAislamiento(A.CODAISLAM) AS Aislamiento,RTRIM(DESTIPEST) AS 'Tipo Estancia',RTRIM(IPNOMCOMP) AS Paciente,
--A.CODCONCEC AS Consecutivo,CAST('' as bit) AS MuestraAlerta,    J.CODESPTRA AS CodigoEspecialidad,RTRIM(K.DESESPECI) AS DescripcionEspecialidad,CAST(IFECHAING AS DATE) 'Fecha Ingreso', 
--RTRIM(J.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', RTRIM(J.UFUACTPAC) as CodigoUfuActual, 
--CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS FechaEgreso, CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
--FLOOR((CAST(CONVERT(VARCHAR(8), J.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
--RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as EntidadPaciente,
--C.ID,C.FECINIEST ,C.FECFINEST 
--FROM dbo.CHCAMASHO A 
--INNER JOIN dbo.ADcenaten D ON A.CODCENATE=D.CODCENATE 
--INNER JOIN dbo.INUNIFUNC E ON A.UFUCODIGO=E.UFUCODIGO 
--LEFT JOIN dbo.CHREGESTA C ON A.CODICAMAS=C.CODICAMAS AND C.REGESTADO = 2
--LEFT JOIN dbo.CHTIPESTA G ON G.CODTIPEST=C.CODTIPEST 
--LEFT JOIN dbo.INPacient H ON C.IPCODPACI=H.IPCODPACI
--LEFT JOIN dbo.INENTIDAD P with(nolock) ON P.CODENTIDA = H.CODENTIDA
--LEFT JOIN dbo.HCREGEGRE I ON C.NUMINGRES=I.NUMINGRES
--LEFT JOIN dbo.ADINGRESO J ON C.NUMINGRES=J.NUMINGRES
--LEFT JOIN dbo.INESPECIA K ON J.CODESPTRA=K.CODESPECI
--LEFT JOIN dbo.INUNIFUNC U ON U.UFUCODIGO = J.UFUACTPAC
--WHERE A.CODCENATE= '11011' AND
--SERSUSCEP = 1 AND 
--NOT EXISTS (
--SELECT 1 FROM [Authorization].PatientConfirmation PC 
--WHERE PC.AdmisionNumber = C.NUMINGRES 
--AND PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES)


--)
    
--UNION ALL
    
--SELECT  
--'1- Pacientes Urgencias con orden de hospitalizacion' as Egreso,
--CASE C.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta,'' as Cama,'Sin Clase' AS ClaseHabitacion,'Sin Clase' AS 'Clase de Cama', C.IPCODPACI AS Identificacion,
--C.NUMINGRES AS Ingreso, '' AS Aislamiento, Historia.Destino AS 'Tipo Estancia',RTRIM(IPNOMCOMP) AS Paciente,0 AS Consecutivo,CAST('' as bit) AS MuestraAlerta,C.CODESPTRA AS CodigoEspecialidad,RTRIM(K.DESESPECI) AS DescripcionEspecialidad,
--CAST(IFECHAING AS DATE) 'Fecha Ingreso',RTRIM(C.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', RTRIM(C.UFUACTPAC) as CodigoUfuActual, 
--CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS FechaEgreso, CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
--FLOOR((CAST(CONVERT(VARCHAR(8), C.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
--RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as EntidadPaciente,'' AS ID,'' FECINIEST ,'' FECFINEST  
--FROM  dbo.ADINGRESO C with (NOLOCK)
--INNER JOIN dbo.ADcenaten D  with(nolock) ON C.CODCENATE=D.CODCENATE 
--INNER JOIN dbo.INUNIFUNC E with(nolock)  ON C.UFUCODIGO=E.UFUCODIGO 
--INNER JOIN dbo.INPacient H  with(nolock) ON C.IPCODPACI=H.IPCODPACI
--INNER JOIN	dbo.INENTIDAD P with(nolock) ON P.CODENTIDA = H.CODENTIDA
--INNER JOIN dbo.INESPECIA K  with(nolock) ON C.CODESPTRA=K.CODESPECI
--INNER JOIN dbo.INUNIFUNC U  with(nolock) ON C.UFUACTPAC = U.UFUCODIGO AND U.UFUTIPUNI = 1
--OUTER APPLY (
--SELECT TOP(1) NUMEFOLIO, IDETIPHIS, 
--CASE INDICAPAC 
--WHEN '2' THEN 'Trasladar a Observacion' 
--WHEN '3' THEN 'Trasladar a Hospitalizacion'
--WHEN '4' THEN 'Trasladar a  UCI Adulto '
--WHEN '5' THEN 'Trasladar a UCI Pediatrica'
--WHEN '6' THEN 'Trasladar a UCI Neonatal'
--WHEN '18' THEN 'Estancia Con la Madre'
--WHEN '19' THEN 'U.Cuidado Intermedio'
--WHEN '20' THEN 'U.Basica'
--WHEN '21' THEN 'Hospitalización Pediatría'
--END as Destino,
--INDICAPAC
--FROM HCHISPACA WHERE NUMINGRES = C.NUMINGRES AND IPCODPACI = C.IPCODPACI AND INDICAPAC IN ('2','3','4','5','6','18','19','20','21') ORDER BY FECHISPAC
--)As Historia
--WHERE c.CODCENATE= '11011'  AND 
--NOT EXISTS (
--SELECT 1 FROM [Authorization].PatientConfirmation PC 
--WHERE PC.AdmisionNumber = C.NUMINGRES 
--AND PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES)
--)
--AND C.IESTADOIN = '' AND C.CODICAMHO IS NULL AND Historia.INDICAPAC is NOT NULL AND E.UFUTIPUNI = '1'
--),

----CTE_SERVICIOS_TOTAL DEMORA 10 SEG
--CTE_SERVICIOS_TOTAL
--AS
--(
--Select 
--A.IDDESCRIPCIONRELACIONADA, 
--Descriptions.Name as DescripcionRelacionada,
--B.SERIPSPOS AS 'NO POS', 
--x.NUMEFOLIO,X.IDETIPHIS, 
--cast(0 as bit) As Seleccione, 
--CAST(A.CODCONCEC as numeric) as CODCONCEC, 
--RTRIM(A.CODSERIPS) AS 'Codigo',
--RTRIM(B.DESSERIPS) AS Descripcion,
--A.CANSERIPS AS Cantidad, 
--CAST(0 AS INT) AS 'Cantidad Autorizada', 
--(CAST(A.NUMEFOLIO AS INT)) AS Folio,
--CAST(1 AS BIT) AS PROSERIPS,
--'1' AS MEDIOSERV,
--CAST(0 AS BIT) AS 'NO POSS',
--RTRIM(A.UFUCODIGO) AS UFUCODIGO,
--RTRIM(C.UFUDESCRI) AS UFUDESCRI, 
--'' AS 'Justificacion Clinica',  
--RTRIM(ING.CODENTIDA) AS Entidad,    
--Case MEDIOSERV WHEN 1 then 'Servicios' ELSE 'Medicamento' END  AS tipoServicio,   
--JUSANULA as JustificacionAnula,   
--C.UFUTIPUNI,   
--ING.ICAUSAING, 
--'' AS Archivo, 
--A.SERSUSCEP, 
--TIPOSERIPS,
--A.NUMINGRES 'Ingreso',
--A.IPCODPACI 'Identificacion',
--CASE A.TIPOSERIPS  when 1 then (select TOP 1 case ESTSERIPS when 1 then 'Solicitado'when 2 then 'Muestra recolectada'when 3 then 'Resultado entregado'when 4 then 'Exámen interpretado'when 5 then 'Remitido'
--															when 6 then 'Anulado'when 7 then 'Extramural'when 8 then 'Muestra recolectada parcialmente'end as 'Estado Asistencial'
--								from HCORDLABO  where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS 
--								)  
--when 2 then 
--( select   TOP 1case ESTSERIPS when 1 then 'Solicitado'when 2 then 'Muestra recolectada'when 3 then 'Resultado entregado'when 4 then 'Exámen interpretado'when 5 then 'Remitido'
--when 6 then 'Anulado'when 7 then 'Extramural'when 8 then 'Muestra recolectada parcialmente'end as 'Estado Asistencial'
--from HCORDPATO    where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS )  

--when 3 then 
--( select   TOP 1
--case ESTSERIPS when 1 then 'Solicitado'when 2 then 'Estudio realizado'when 3 then 'Imagen procesada'when 4 then 'Estudio interpretado'when 5 then 'Remitido'when 6 then 'Anulado'
--when 7 then 'Extramural'end as 'Estado Asistencial'
--from HCORDIMAG    where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS )  

--when 4 then 
--( select   TOP 1
--case ESTSERIPS when 1 then 'Ordenado'when 2 then 'Completado'when 3 then 'Interpretado'when 4 then 'Sin interfaz'when 5 then 'Anulado'end as 'Estado Asistencial'
--from HCORDPRON    where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS )  

--when 5 then
--( select   TOP 1 
--case ESTSERIPS when 1 then 'Solicitado'when 2 then 'Sala programada'when 3 then 'Cancelado'when 4 then 'Realizado'end as 'Estado Asistencial'
--from HCORDPROQ    where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS )  

--when 6 then 'Informe qx' END as 'Estado Asistencial',

--CASE A.TIPOSERIPS when 1 then 
--( select top 1 OBSSERIPS AS Observacion from HCORDLABO where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS AND OBSSERIPS IS NOT NULL) 
--when 2 then 
--( select top 1 OBSSERIPS AS Observacion from HCORDPATO where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS AND OBSSERIPS IS NOT NULL)  
--when 3 then 
--( select top 1 OBSSERIPS AS Observacion from HCORDIMAG where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS AND OBSSERIPS IS NOT NULL)  
--when 4 then 
--( select top 1 OBSSERIPS AS Observacion from HCORDPRON where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS AND OBSSERIPS IS NOT NULL)  
--when 5 then
--( select top 1 OBSSERIPS AS Observacion from HCORDPROQ where NUMINGRES = A.NUMINGRES  AND IPCODPACI = A.IPCODPACI   AND NUMEFOLIO = A.NUMEFOLIO AND CODSERIPS = A.CODSERIPS AND OBSSERIPS IS NOT NULL)  
--END as 'Observacion', 
--CASE A.SOLINFOQX WHEN 1 THEN 'Si' ELSE 'No' END AS InformeQx
--from 
--dbo.ADAUTOSER A INNER JOIN 
--HCHISPACA X ON X.IPCODPACI = A.IPCODPACI AND X.NUMEFOLIO = A.NUMEFOLIO AND X.NUMINGRES = A.NUMINGRES 
--INNER JOIN INCUPSIPS B ON A.CODSERIPS=B.CODSERIPS  
--INNER JOIN INUNIFUNC C ON A.UFUCODIGO=C.UFUCODIGO  
--INNER JOIN ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
--INNER JOIN CTE_AUTORIZACIONES_HOSPITALARIAS AS AUT ON AUT.Identificacion =A.IPCODPACI AND AUT.Ingreso =A.NUMINGRES 
--LEFT join contract.CUPSEntityContractDescriptions CupsDescriptions with(nolock) on  A.IDDESCRIPCIONRELACIONADA= CupsDescriptions.id 
--LEFT join contract.ContractDescriptions Descriptions with(nolock) on Descriptions.id = CupsDescriptions.ContractDescriptionId      
--WHERE
--A.PROESTADO IN ('1')  AND SOLEXTRAM = 0


--UNION ALL
--SELECT 
--'' as IDDESCRIPCIONRELACIONADA, 
--'' As DescripcionRelacionada,
--B.NOPOSPROD AS 'NO POS', 
--X.NUMEFOLIO,X.IDETIPHIS,
--cast(0 as bit) As Seleccione, 
--CAST(A.CODCONCEC as numeric) as CODCONCEC, 
--RTRIM(A.CODPRODUC) AS 'Codigo',
--RTRIM(B.DESPRODUC) AS Descripcion,
--A.CANPEDPRO AS Cantidad, 
--CAST(0 AS INT) AS 'Cantidad Autorizada', 
--CAST(A.NUMEFOLIO AS INT) AS Folio,
--CAST(1 AS BIT) AS PROSERIPS,
--'2' AS MEDIOSERV, 
--CAST(1 AS BIT) AS 'NO POSS',
--RTRIM(A.UFUCODIGO) AS UFUCODIGO,
--RTRIM(C.UFUDESCRI) AS UFUDESCRI,
--'' AS 'Justificacion Clinica', 
--RTRIM(ING.CODENTIDA) AS Entidad, 
--'Medicamentos NO POS' AS tipoServicio, 
--NULL as JustificacionAnula,   
--C.UFUTIPUNI,   ING.ICAUSAING, 
--'' AS Archivo, 
--'' AS SERSUSCEP, 
--'' AS TIPOSERIPS, 
--'' AS NUMINGRES, 
--'' AS  IPCODPACI, 
--case PREESTADO when 1 then 'Solicitado sin autorización'
--			   when 2 then 'Ciclo Completado'
--			   when 3 then 'Tratamiento descontinuado'
--			   when 4 then 'Tratamiento suspendido'
--			   when 5 then 'Plan de manejo externo'
--			   when 6 then 'Solicitado sin existencia'
--			   when 7 then 'Terminado por salida' end AS 'Estado Asistencial',
--'' AS Observacion, 
--'' AS InformeQx
--FROM HCPRESCRA A 
--INNER JOIN HCHISPACA X ON X.IPCODPACI = A.IPCODPACI AND   X.NUMEFOLIO = A.NUMEFOLIO AND X.NUMINGRES = A.NUMINGRES 
--INNER JOIN IHLISTPRO B ON A.CODPRODUC=B.CODPRODUC
--INNER JOIN INUNIFUNC C ON A.UFUCODIGO=C.UFUCODIGO
--INNER JOIN ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES   
--INNER JOIN CTE_AUTORIZACIONES_HOSPITALARIAS AS AUT ON AUT.Identificacion =A.IPCODPACI AND AUT.Ingreso =A.NUMINGRES 
--WHERE 
--NOPOSPROD=1
--)


--SELECT 
-- CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
-- AUT.*,TOT.Codigo,TOT.Descripcion ,TOT.DescripcionRelacionada ,TOT.Cantidad,
-- TOT.[Cantidad Autorizada] ,TOT.[Estado Asistencial],TOT.Folio,
-- CAST(AUT.[Fecha Ingreso] AS date) AS 'FECHA BUSQUEDA',
-- YEAR(AUT.[Fecha Ingreso] ) AS 'AÑO FECHA BUSQUEDA',
-- MONTH(AUT.[Fecha Ingreso] ) AS 'MES AÑO FECHA BUSQUEDA',
-- CASE MONTH(AUT.[Fecha Ingreso]) 
--	WHEN 1 THEN 'ENERO'
--	WHEN 2 THEN 'FEBRERO'
--	WHEN 3 THEN 'MARZO'
--	WHEN 4 THEN 'ABRIL'
--	WHEN 5 THEN 'MAYO'
--	WHEN 6 THEN 'JUNIO'
--	WHEN 7 THEN 'JULIO'
--	WHEN 8 THEN 'AGOSTO'
--	WHEN 9 THEN 'SEPTIEMBRE'
--	WHEN 10 THEN 'OCTUBRE'
--	WHEN 11 THEN 'NOVIEMBRE'
--	WHEN 12 THEN 'DICIEMBRE'
--  END AS 'MES NOMBRE FECHA BUSQUEDA',
--  FORMAT(DAY(AUT.[Fecha Ingreso]), '00') AS 'DIA FECHA BUSQUEDA',
--  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
--FROM 
-- CTE_AUTORIZACIONES_HOSPITALARIAS AS AUT
-- LEFT JOIN CTE_SERVICIOS_TOTAL AS TOT ON AUT.Identificacion =TOT.Identificacion  AND AUT.Ingreso =TOT.Ingreso
----  WHERE AUT.Ingreso=100205    
--GO


--duracion 22:47
CREATE VIEW [Report].[ViewAutorizacionesHospitalariasPendientes] AS

WITH 
CTE_ObtenerFechaMaximaSolicitud AS
(
SELECT A.FECREGIST AS REGDATE, NUMINGRES
FROM ADAUTOSER A 
WHERE A.CODCONCEC=(SELECT MAX(AD.CODCONCEC) FROM ADAUTOSER AD WHERE A.NUMINGRES=AD.NUMINGRES)
UNION ALL
SELECT FECINIEST AS REGDATE ,NUMINGRES
FROM CHREGESTA CH
WHERE ID=(SELECT MAX(C.ID) FROM CHREGESTA C WHERE CH.NUMINGRES=C.NUMINGRES)--ID
UNION ALL
SELECT A.FECINFORM AS REGDATE,NUMINGRES
FROM ADAUTSERC A WHERE A.CODCONCEC=(SELECT MAX(AD.CODCONCEC) FROM ADAUTSERC AD WHERE A.NUMINGRES=AD.NUMINGRES)
),
CTE_PatientConfirmation AS
(
SELECT AdmisionNumber 
FROM 
[Authorization].PatientConfirmation PC INNER JOIN
CTE_ObtenerFechaMaximaSolicitud OMS ON PC.AdmisionNumber=OMS.NUMINGRES AND PC.ConfirmationDate>REGDATE
),
CTE_ORDENADOS AS
(
/*OREDENES DE LABORATORIOS REALIZADOS*/
	SELECT 
	'1' AS TIPO,
	CASE ESTSERIPS WHEN 1 THEN 'Solicitado'
				   WHEN 2 THEN 'Muestra recolectada'
				   WHEN 3 THEN 'Resultado entregado'
				   WHEN 4 THEN 'Exámen interpretado'
				   WHEN 5 THEN 'Remitido'
				   WHEN 6 THEN 'Anulado'
				   WHEN 7 THEN 'Extramural'
				   WHEN 8 THEN 'Muestra recolectada parcialmente' END AS ESTADO,
	NUMINGRES,
	CODSERIPS,
	SUM(CANSERIPS) AS CANTIDAD,
	NUMEFOLIO,
	OBSSERIPS
	FROM HCORDLABO WHERE ESTSERIPS!=6
	GROUP BY ESTSERIPS,NUMINGRES,CODSERIPS,NUMEFOLIO,OBSSERIPS
UNION ALL
/*OREDENES DE PATOLOGIAS REALIZADAS*/
	SELECT 
	'1' AS TIPO,
	CASE ESTSERIPS WHEN 1 THEN 'Solicitado'
				   WHEN 2 THEN 'Muestra recolectada'
				   WHEN 3 THEN 'Resultado entregado'
				   WHEN 4 THEN 'Exámen interpretado'
				   WHEN 5 THEN 'Remitido'
				   WHEN 6 THEN 'Anulado'
				   WHEN 7 THEN 'Extramural'
				   WHEN 8 THEN 'Muestra recolectada parcialmente' END AS ESTADO,
	NUMINGRES,
	CODSERIPS,
	CANSERIPS AS CANTIDAD,
	NUMEFOLIO,
	OBSSERIPS
	FROM HCORDPATO
UNION ALL
/*OREDENES DE IMAGENES REALIZADAS*/
	SELECT 
	'1' AS TIPO,
	CASE ESTSERIPS WHEN 1 THEN 'Solicitado'
				   WHEN 2 THEN 'Estudio realizado'
				   WHEN 3 THEN 'Imagen procesada'
				   WHEN 4 THEN 'Estudio interpretado'
				   WHEN 5 THEN 'Remitido'
				   WHEN 6 THEN 'Anulado'
				   WHEN 7 THEN 'Extramural' END AS ESTADO,
	NUMINGRES,
	CODSERIPS,
	SUM(CANSERIPS) AS CANTIDAD,
	NUMEFOLIO,
	OBSSERIPS
	FROM HCORDIMAG WHERE ESTSERIPS!=6
	GROUP BY ESTSERIPS,NUMINGRES,CODSERIPS,NUMEFOLIO,OBSSERIPS
UNION ALL
/*OREDENES DE PROCEDIMIENTOS NO QX */
	SELECT 
	'1' AS TIPO,
	CASE ESTSERIPS WHEN 1 THEN 'Solicitado'
				   WHEN 2 THEN 'Estudio realizado'
				   WHEN 3 THEN 'Imagen procesada'
				   WHEN 4 THEN 'Estudio interpretado'
				   WHEN 5 THEN 'Remitido'
				   WHEN 6 THEN 'Anulado'
				   WHEN 7 THEN 'Extramural' END AS ESTADO,
	NUMINGRES,
	CODSERIPS,
	CANSERIPS AS CANTIDAD,
	NUMEFOLIO,
	OBSSERIPS
	FROM HCORDPRON
UNION ALL
/*OREDENES DE PROCEDIMIENTOS QX */
	SELECT 
	'1' AS TIPO,
	CASE ESTSERIPS WHEN 1 THEN 'Solicitado'
				   WHEN 2 THEN 'Estudio realizado'
				   WHEN 3 THEN 'Imagen procesada'
				   WHEN 4 THEN 'Estudio interpretado'
				   WHEN 5 THEN 'Remitido'
				   WHEN 6 THEN 'Anulado'
				   WHEN 7 THEN 'Extramural' END AS ESTADO,
	NUMINGRES,
	CODSERIPS,
	CANSERIPS AS CANTIDAD,
	NUMEFOLIO,
	OBSSERIPS
	FROM HCORDPROQ
),

CTE_AUTORIZACIONES_HOSPITALARIAS
AS
(
	SELECT  
	CASE WHEN I.NUMINGRES IS NULL THEN '3- Pacientes en la unidad' ELSE '2- Pacientes alta medica' END AS Egreso, 
	CASE J.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END AS Alerta,
	RTRIM(DESCCAMAS) AS Cama,
	dbo.ClaseHabitacion(A.CODCLAHAB) AS ClaseHabitacion,
	dbo.ClaseCama(A.CODCLACAM) AS 'Clase de Cama', 
	C.IPCODPACI AS Identificacion,
	C.NUMINGRES AS Ingreso, 
	dbo.TipoAislamiento(A.CODAISLAM) AS Aislamiento,
	RTRIM(DESTIPEST) AS 'Tipo Estancia',
	RTRIM(IPNOMCOMP) AS Paciente, 
	A.CODCONCEC AS Consecutivo,CAST('' as bit) AS MuestraAlerta,
	J.CODESPTRA AS CodigoEspecialidad,RTRIM(K.DESESPECI) AS DescripcionEspecialidad,CAST(IFECHAING AS DATE) 'Fecha Ingreso', RTRIM(J.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', 
	RTRIM(J.UFUACTPAC) as CodigoUfuActual, CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS FechaEgreso, CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
	FLOOR((CAST(CONVERT(VARCHAR(8), J.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
	RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as EntidadPaciente,C.ID ,C.FECINIEST ,C.FECFINEST
	FROM 
	dbo.CHCAMASHO A INNER JOIN 
	dbo.ADcenaten D ON A.CODCENATE=D.CODCENATE INNER JOIN 
	dbo.INUNIFUNC E ON A.UFUCODIGO=E.UFUCODIGO INNER JOIN 
	dbo.CHREGESTA C ON A.CODICAMAS=C.CODICAMAS AND C.REGESTADO = 1
	INNER JOIN dbo.CHTIPESTA G ON G.CODTIPEST=C.CODTIPEST 
	INNER JOIN dbo.INPacient H ON C.IPCODPACI=H.IPCODPACI
	LEFT  JOIN	dbo.INENTIDAD P ON P.CODENTIDA = H.CODENTIDA
	LEFT  JOIN dbo.HCREGEGRE I ON C.NUMINGRES=I.NUMINGRES
	INNER JOIN dbo.ADINGRESO J ON C.NUMINGRES=J.NUMINGRES
	INNER JOIN dbo.INESPECIA K ON J.CODESPTRA=K.CODESPECI
	INNER JOIN dbo.INUNIFUNC U ON U.UFUCODIGO = J.UFUACTPAC
	WHERE
	ESTADCAMA = 2 AND 
	NOT EXISTS ( SELECT 1 
		FROM [Authorization].PatientConfirmation PC 
		WHERE PC.AdmisionNumber = C.NUMINGRES AND 
				PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES)
	)
	UNION ALL
	SELECT  '4- Pacientes egresados' AS Egreso, 
	CASE J.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta, RTRIM(DESCCAMAS) AS Cama,dbo.ClaseHabitacion(A.CODCLAHAB) AS ClaseHabitacion,dbo.ClaseCama(A.CODCLACAM) AS 'Clase de Cama', C.IPCODPACI AS Identificacion,C.NUMINGRES AS Ingreso, dbo.TipoAislamiento(A.CODAISLAM) AS Aislamiento,RTRIM(DESTIPEST) AS 'Tipo Estancia',RTRIM(IPNOMCOMP) AS Paciente,
	A.CODCONCEC AS Consecutivo,CAST('' as bit) AS MuestraAlerta,    J.CODESPTRA AS CodigoEspecialidad,RTRIM(K.DESESPECI) AS DescripcionEspecialidad,CAST(IFECHAING AS DATE) 'Fecha Ingreso', 
	RTRIM(J.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', RTRIM(J.UFUACTPAC) as CodigoUfuActual, 
	CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS FechaEgreso, CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
	FLOOR((CAST(CONVERT(VARCHAR(8), J.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
	RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as EntidadPaciente,
	C.ID,C.FECINIEST ,C.FECFINEST 
	FROM dbo.CHCAMASHO A 
	INNER JOIN dbo.ADcenaten D ON A.CODCENATE=D.CODCENATE 
	INNER JOIN dbo.INUNIFUNC E ON A.UFUCODIGO=E.UFUCODIGO 
	LEFT JOIN dbo.CHREGESTA C ON A.CODICAMAS=C.CODICAMAS AND C.REGESTADO = 2
	LEFT JOIN dbo.CHTIPESTA G ON G.CODTIPEST=C.CODTIPEST 
	LEFT JOIN dbo.INPacient H ON C.IPCODPACI=H.IPCODPACI
	LEFT JOIN dbo.INENTIDAD P with(nolock) ON P.CODENTIDA = H.CODENTIDA
	LEFT JOIN dbo.HCREGEGRE I ON C.NUMINGRES=I.NUMINGRES
	LEFT JOIN dbo.ADINGRESO J ON C.NUMINGRES=J.NUMINGRES
	LEFT JOIN dbo.INESPECIA K ON J.CODESPTRA=K.CODESPECI
	LEFT JOIN dbo.INUNIFUNC U ON U.UFUCODIGO = J.UFUACTPAC
	WHERE 
	SERSUSCEP = 1 AND 
	NOT EXISTS (
	SELECT 1 FROM [Authorization].PatientConfirmation PC 
	WHERE PC.AdmisionNumber = C.NUMINGRES 
	AND PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES)
	)
    
	UNION ALL
    
	SELECT  
	'1- Pacientes Urgencias con orden de hospitalizacion' as Egreso,
	CASE C.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta,'' as Cama,'Sin Clase' AS ClaseHabitacion,'Sin Clase' AS 'Clase de Cama', C.IPCODPACI AS Identificacion,
	C.NUMINGRES AS Ingreso, '' AS Aislamiento, Historia.Destino AS 'Tipo Estancia',RTRIM(IPNOMCOMP) AS Paciente,0 AS Consecutivo,CAST('' as bit) AS MuestraAlerta,C.CODESPTRA AS CodigoEspecialidad,RTRIM(K.DESESPECI) AS DescripcionEspecialidad,
	CAST(IFECHAING AS DATE) 'Fecha Ingreso',RTRIM(C.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', RTRIM(C.UFUACTPAC) as CodigoUfuActual, 
	CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS FechaEgreso, CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
	FLOOR((CAST(CONVERT(VARCHAR(8), C.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
	RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as EntidadPaciente,'' AS ID,'' FECINIEST ,'' FECFINEST  
	FROM  dbo.ADINGRESO C with (NOLOCK)
	INNER JOIN dbo.ADcenaten D  with(nolock) ON C.CODCENATE=D.CODCENATE 
	INNER JOIN dbo.INUNIFUNC E with(nolock)  ON C.UFUCODIGO=E.UFUCODIGO 
	INNER JOIN dbo.INPacient H  with(nolock) ON C.IPCODPACI=H.IPCODPACI
	INNER JOIN	dbo.INENTIDAD P with(nolock) ON P.CODENTIDA = H.CODENTIDA
	INNER JOIN dbo.INESPECIA K  with(nolock) ON C.CODESPTRA=K.CODESPECI
	INNER JOIN dbo.INUNIFUNC U  with(nolock) ON C.UFUACTPAC = U.UFUCODIGO AND U.UFUTIPUNI = 1
	OUTER APPLY (
	SELECT TOP(1) NUMEFOLIO, IDETIPHIS, 
	CASE INDICAPAC 
	WHEN '2' THEN 'Trasladar a Observacion' 
	WHEN '3' THEN 'Trasladar a Hospitalizacion'
	WHEN '4' THEN 'Trasladar a  UCI Adulto '
	WHEN '5' THEN 'Trasladar a UCI Pediatrica'
	WHEN '6' THEN 'Trasladar a UCI Neonatal'
	WHEN '18' THEN 'Estancia Con la Madre'
	WHEN '19' THEN 'U.Cuidado Intermedio'
	WHEN '20' THEN 'U.Basica'
	WHEN '21' THEN 'Hospitalización Pediatría'
	END as Destino,
	INDICAPAC
	FROM HCHISPACA WHERE NUMINGRES = C.NUMINGRES AND IPCODPACI = C.IPCODPACI AND INDICAPAC IN ('2','3','4','5','6','18','19','20','21') ORDER BY FECHISPAC
	)As Historia
	WHERE
	NOT EXISTS (SELECT 1 FROM CTE_PatientConfirmation PC WHERE  C.NUMINGRES =PC.AdmisionNumber)
	AND C.IESTADOIN = '' AND C.CODICAMHO IS NULL AND Historia.INDICAPAC is NOT NULL AND E.UFUTIPUNI = '1'
),


CTE_SERVICIOS_TOTAL
AS
(
Select
Descriptions.Name as DescripcionRelacionada,
RTRIM(A.CODSERIPS) AS 'Codigo',
RTRIM(B.DESSERIPS) AS Descripcion,
A.CANSERIPS AS Cantidad, 
CAST(0 AS INT) AS 'Cantidad Autorizada', 
A.NUMEFOLIO AS Folio,
A.NUMINGRES INGRESO,
A.IPCODPACI AS Identificacion,
ORD.ESTADO AS [ESTADO ASISTENCIAL]
from 
dbo.ADAUTOSER A INNER JOIN 
CTE_ORDENADOS ORD ON A.NUMINGRES=ORD.NUMINGRES AND A.CODSERIPS=ORD.CODSERIPS AND A.NUMEFOLIO=ORD.NUMEFOLIO INNER JOIN
INCUPSIPS B ON A.CODSERIPS=B.CODSERIPS LEFT JOIN
contract.CUPSEntityContractDescriptions CupsDescriptions with(nolock) on  A.IDDESCRIPCIONRELACIONADA= CupsDescriptions.id 
LEFT join contract.ContractDescriptions Descriptions with(nolock) on Descriptions.id = CupsDescriptions.ContractDescriptionId      
WHERE
A.PROESTADO IN ('1')  AND SOLEXTRAM = 0

UNION ALL

SELECT 
'' As DescripcionRelacionada, 
RTRIM(A.CODPRODUC) AS 'Codigo',
RTRIM(B.DESPRODUC) AS Descripcion,
A.CANPEDPRO AS Cantidad, 
CAST(0 AS INT) AS 'Cantidad Autorizada', 
A.NUMEFOLIO AS Folio,
A.NUMINGRES AS INGRESO, 
A.IPCODPACI AS  IDENTIFICACION, 
case PREESTADO when 1 then 'Solicitado sin autorización'
			   when 2 then 'Ciclo Completado'
			   when 3 then 'Tratamiento descontinuado'
			   when 4 then 'Tratamiento suspendido'
			   when 5 then 'Plan de manejo externo'
			   when 6 then 'Solicitado sin existencia'
			   when 7 then 'Terminado por salida' end AS [ESTADO ASISTENCIAL]
FROM HCPRESCRA A 
INNER JOIN IHLISTPRO B ON A.CODPRODUC=B.CODPRODUC
WHERE 
NOPOSPROD=1
)


SELECT
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 AUT.*,
 TOT.Codigo,
 TOT.Descripcion,
 TOT.DescripcionRelacionada ,
 TOT.Cantidad,
 TOT.[Cantidad Autorizada] ,
 TOT.[Estado Asistencial],
 TOT.Folio,
 CAST(AUT.[Fecha Ingreso] AS date) AS 'FECHA BUSQUEDA',
 YEAR(AUT.[Fecha Ingreso] ) AS 'AÑO FECHA BUSQUEDA',
 MONTH(AUT.[Fecha Ingreso] ) AS 'MES AÑO FECHA BUSQUEDA',
 CASE MONTH(AUT.[Fecha Ingreso]) WHEN 1 THEN 'ENERO'
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
  FORMAT(DAY(AUT.[Fecha Ingreso]), '00') AS 'DIA FECHA BUSQUEDA',
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
 CTE_AUTORIZACIONES_HOSPITALARIAS AS AUT
 LEFT JOIN CTE_SERVICIOS_TOTAL AS TOT ON AUT.Ingreso =TOT.Ingreso
-- WHERE AUT.Ingreso=100205    
