-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewAutorizacionesHospitalariasEstancias
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[ViewAutorizacionesHospitalariasEstancias] AS

WITH CTE_AUTORIZACIONES_HOSPITALARIAS AS
 (
    SELECT  CASE WHEN  I.NUMINGRES IS NULL THEN '3- Pacientes en la unidad' ELSE '2- Pacientes alta medica' END AS Egreso, 
    CASE J.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta, RTRIM(DESCCAMAS) AS Cama,dbo.ClaseHabitacion(A.CODCLAHAB) AS 'Clase Habitacion',
    dbo.ClaseCama(A.CODCLACAM) AS 'Clase de Cama', C.IPCODPACI AS Identificacion,C.NUMINGRES AS Ingreso, dbo.TipoAislamiento(A.CODAISLAM) AS Aislamiento,RTRIM(DESTIPEST) AS 'Tipo Estancia',
    RTRIM(IPNOMCOMP) AS Paciente, A.CODCONCEC AS Consecutivo,CAST('' as bit) AS 'Muestra Alerta',
    RTRIM(K.DESESPECI) AS 'Descripcion Especialidad',CAST(IFECHAING AS DATE) 'Fecha Ingreso', RTRIM(J.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', 
    CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS 'Fecha Egreso', CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
    FLOOR((CAST(CONVERT(VARCHAR(8), J.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
	RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as 'Entidad Paciente',C.ID 
    FROM dbo.CHCAMASHO A 
    INNER JOIN dbo.ADcenaten D ON A.CODCENATE=D.CODCENATE 
    INNER JOIN dbo.INUNIFUNC E ON A.UFUCODIGO=E.UFUCODIGO 
    INNER JOIN dbo.CHREGESTA C ON A.CODICAMAS=C.CODICAMAS AND C.REGESTADO = 1
    INNER JOIN dbo.CHTIPESTA G ON G.CODTIPEST=C.CODTIPEST 
    INNER JOIN dbo.INPacient H ON C.IPCODPACI=H.IPCODPACI
    LEFT  JOIN	dbo.INENTIDAD P with(nolock) ON P.CODENTIDA = H.CODENTIDA
    LEFT  JOIN dbo.HCREGEGRE I ON C.NUMINGRES=I.NUMINGRES
    INNER JOIN dbo.ADINGRESO J ON C.NUMINGRES=J.NUMINGRES
    INNER JOIN dbo.INESPECIA K ON J.CODESPTRA=K.CODESPECI
    INNER JOIN dbo.INUNIFUNC U ON U.UFUCODIGO = J.UFUACTPAC
    WHERE 
	CAST(IFECHAING AS DATE) BETWEEN CAST(DATEADD(m,-365,GETDATE()) AS DATE) AND CAST(GETDATE() AS DATE) AND
	ESTADCAMA =2  
    	AND NOT EXISTS (
    		SELECT 1 FROM [Authorization].PatientConfirmation PC 
    		WHERE PC.AdmisionNumber = C.NUMINGRES 
    			AND PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES)
    	)
    UNION ALL
    SELECT  '4- Pacientes egresados' AS Egreso, 
    CASE J.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta, RTRIM(DESCCAMAS) AS Cama,dbo.ClaseHabitacion(A.CODCLAHAB) AS 'Clase Habitacion',
	dbo.ClaseCama(A.CODCLACAM) AS 'Clase de Cama', C.IPCODPACI AS Identificacion,C.NUMINGRES AS Ingreso, dbo.TipoAislamiento(A.CODAISLAM) AS Aislamiento,RTRIM(DESTIPEST) AS 'Tipo Estancia',RTRIM(IPNOMCOMP) AS Paciente,
	A.CODCONCEC AS Consecutivo,CAST('' as bit) AS 'Muestra Alerta',RTRIM(K.DESESPECI) AS 'Descripcion Especialidad',CAST(IFECHAING AS DATE) 'Fecha Ingreso', 
    RTRIM(J.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', 
	CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS 'Fecha Egreso', CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
	FLOOR((CAST(CONVERT(VARCHAR(8), J.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
	RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as 'Entidad Paciente',C.ID 
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
	CAST(IFECHAING AS DATE) BETWEEN CAST(DATEADD(m,-365,GETDATE()) AS DATE) AND CAST(GETDATE() AS DATE) AND
	SERSUSCEP = 1 AND  
    	 NOT EXISTS (SELECT 1 
		             FROM [Authorization].PatientConfirmation PC 
		             WHERE PC.AdmisionNumber = C.NUMINGRES AND 
					       PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES))
   	UNION ALL
    SELECT  '1- Pacientes Urgencias con orden de hospitalizacion' as Egreso,
    CASE C.SERSUSCEP WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta,'' as Cama,'Sin Clase' AS 'Clase Habitacion','Sin Clase' AS 'Clase de Cama', C.IPCODPACI AS Identificacion,
    C.NUMINGRES AS Ingreso, '' AS Aislamiento, Historia.Destino AS 'Tipo Estancia',RTRIM(IPNOMCOMP) AS Paciente,0 AS Consecutivo,CAST('' as bit) AS 'Muestra Alerta',
	RTRIM(K.DESESPECI) AS 'Descripcion Especialidad',CAST(IFECHAING AS DATE) 'Fecha Ingreso',RTRIM(C.UFUACTPAC) + ' - ' + RTRIM(U.UFUDESCRI) as 'Unidad Funcional Actual', 
	CASE WHEN FECHEGRESO IS NULL THEN 'Sin egreso' ELSE CONVERT(VARCHAR, (FORMAT(FECHEGRESO, 'dd/MM/yyyy'))) END AS 'Fecha Egreso', CAST(H.IPFECNACI AS DATE) AS 'Fecha Nacimiento', 
    FLOOR((CAST(CONVERT(VARCHAR(8), C.IFECHAING   , 112) AS INT) - CAST(CONVERT(VARCHAR(8), H.IPFECNACI, 112) AS INT)) / 10000) AS 'Edad',
	RTRIM(P.CODENTIDA) + '-'+ RTRIM(P.NOMENTIDA) as 'Entidad Paciente','' AS ID 
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
	 CAST(IFECHAING AS DATE) BETWEEN CAST(DATEADD(m,-365,GETDATE()) AS DATE) AND CAST(GETDATE() AS DATE) AND
   	 NOT EXISTS (SELECT 1 
		             FROM [Authorization].PatientConfirmation PC 
		             WHERE PC.AdmisionNumber = C.NUMINGRES AND 
					       PC.ConfirmationDate > [Authorization].ObtenerFechaMaximaSolicitud(C.NUMINGRES))
    	AND C.IESTADOIN = '' AND C.CODICAMHO IS NULL AND Historia.INDICAPAC is NOT NULL AND E.UFUTIPUNI = '1'
),

-----********CTE SOLICITUD DE AUTORIZACION DE ESTANCIAS *******---------
CTE_SOLICITUD_AUTORIZACION_ESTANCIA
AS
(
  SELECT A.ID,A.IPCODPACI 'Identificacion',A.NUMINGRES 'Ingreso',B.UFUCODIGO,RTRIM(B.UFUCODIGO) + '-' + RTRIM(D.UFUDESCRI) AS UnidadFuncional,A.CODICAMAS as Cama,
  CASE B.CODCLACAM WHEN 1 THEN 'Observación urgencias' WHEN 2 THEN 'Recuperacion post-quirurgico' WHEN 3 THEN 'Hospitalaria' WHEN 4 THEN 'Cuna de Pbservación' END AS ClaseCama,
  RTRIM(C.DESTIPEST) AS TipoEstancia,A.FECINIEST 'Fecha Inicial',A.FECFINEST as 'Fecha Final','' as DiasAutorizados,
  iif(A.FECFINEST='1900-01-01 00:00:00.000',DATEDIFF(DAY,A.FECINIEST,GETDATE()), DATEDIFF(DAY,A.FECINIEST,A.FECFINEST) ) as DiasEstancia,
  NOREQAUTO,NOREQAUTJUS,CASE A.NOREQAUTO WHEN 1 THEN 'Alerta' ELSE 'Normal' END as Alerta,
  A.ID as IdReporte
  FROM
  dbo.CHREGESTA A
  INNER JOIN DBO.CHCAMASHO B ON B.CODICAMAS = A.CODICAMAS
  INNER JOIN DBO.CHTIPESTA C ON C.CODTIPEST = A.CODTIPEST
  INNER JOIN DBO.INUNIFUNC D ON D.UFUCODIGO = B.UFUCODIGO
  INNER JOIN CTE_AUTORIZACIONES_HOSPITALARIAS AS HOS ON HOS.Identificacion =A.IPCODPACI and HOS.Ingreso =A.NUMINGRES 
),

CTE_CTE_SOLICITUD_DETALLE_AUTORIZACION_ESTANCIA
AS
(  --- Detalle
  SELECT CODCONCEC,RTRIM(A.CODSERIPS) AS  'Cups',CANSERIPS 'Cantidad Solicitada',CASE ESTATUSER WHEN 1 THEN 'Autorizado' WHEN 2 THEN 'No Autorizado' WHEN 3 THEN 'Solicitado' END AS 'Estado',
  CANSERAUT 'Cantidad Autorizada',CHREGESTAID,ESTATUSER,RTRIM(B.DESSERIPS) AS NomServicio,CODCONCEC as IdReporte,A.IDDESCRIPCIONRELACIONADA,Descriptions.Name as DescripcionRelacionada,
  A.NUMINGRES 'Ingreso',A.IPCODPACI 'Identificacion'
  FROM
  dbo.ADAUTSERD A
  INNER JOIN DBO.INCUPSIPS B ON B.CODSERIPS = A.CODSERIPS
  INNER JOIN CTE_SOLICITUD_AUTORIZACION_ESTANCIA AS EST ON EST.Identificacion =A.IPCODPACI AND EST.Ingreso =A.NUMINGRES AND EST.ID =A.CHREGESTAID 
  LEFT join contract.CUPSEntityContractDescriptions CupsDescriptions with(nolock) on A.IDDESCRIPCIONRELACIONADA = CupsDescriptions.id
  LEFT join contract.ContractDescriptions Descriptions with(nolock) on Descriptions.id = CupsDescriptions.ContractDescriptionId
)

SELECT
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 AUT.*,/*EST.Cama, */ EST.ClaseCama ,EST.DiasAutorizados ,EST.TipoEstancia ,EST.DiasEstancia,
 EST.[Fecha Inicial] ,est.[Fecha Final] ,DETEST.Cups ,DETEST.NomServicio 'Servicio',
 detest.[Cantidad Solicitada] ,DETEST.[Cantidad Autorizada] ,DETEST.Estado,
 1 as 'CANTIDAD',
 CAST(AUT.[Fecha Ingreso] AS date) AS 'FECHA BUSQUEDA',
 YEAR(AUT.[Fecha Ingreso] ) AS 'AÑO FECHA BUSQUEDA',
 MONTH(AUT.[Fecha Ingreso] ) AS 'MES AÑO FECHA BUSQUEDA',
 CASE MONTH(AUT.[Fecha Ingreso]) 
	WHEN 1 THEN 'ENERO'
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
	WHEN 12 THEN 'DICIEMBRE'
  END AS 'MES NOMBRE FECHA BUSQUEDA',
  FORMAT(DAY(AUT.[Fecha Ingreso]), '00') AS 'DIA FECHA BUSQUEDA',
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
 CTE_AUTORIZACIONES_HOSPITALARIAS AS AUT
 LEFT JOIN CTE_SOLICITUD_AUTORIZACION_ESTANCIA AS EST ON EST.Identificacion =AUT.Identificacion AND EST.Ingreso =AUT.Ingreso
 LEFT JOIN CTE_CTE_SOLICITUD_DETALLE_AUTORIZACION_ESTANCIA AS DETEST ON DETEST.Ingreso =EST.Ingreso AND DETEST.Identificacion =EST.Identificacion AND DETEST.CHREGESTAID =EST.ID
