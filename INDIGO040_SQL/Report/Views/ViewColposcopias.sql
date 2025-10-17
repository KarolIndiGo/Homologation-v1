-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewColposcopias
-- Extracted by Fabric SQL Extractor SPN v3.9.0





/*******************************************************************************************************************
Nombre: [Report].[ViewColposcopias]
Tipo:Vista
Observacion:Reporte sobre Colposcopia
Profesional: Nilsson Miguel Galindo Lopez
Fecha:17-11-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Vercion 1
Persona que modifico: 
Fecha:
Ovservaciones: 
--------------------------------------
Vercion 2
Persona que modifico:
Fecha:
***********************************************************************************************************************************/
CREATE VIEW [Report].[ViewColposcopias]
AS
SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
CEN.NOMCENATE AS [CENTRO DE ATENCION],
CASE pac.IPTIPODOC WHEN 1 THEN 'CC - CEDULA DE CIUDADANIA' 
				   WHEN 2 THEN 'CE - CEDULA DE EXTRANJERIA' 
				   WHEN 3 THEN 'TI - TARJETA DE IDENTIDAD' 
				   WHEN 4 THEN 'RC - REGISTRO CIVIL' 
				   WHEN 5 THEN 'PA - PASAPORTE' 
				   WHEN 6 THEN 'AS - ADULTO SIN IDENTIFICACION' 
				   WHEN 7 THEN 'MS - MENOR SIN IDENTIFICACION' 
				   WHEN 8 THEN 'NU - NUMERO UNICO DE IDENTIFICACIÒN' 
				   WHEN 9 THEN 'NV - CERTIFICADO NACIDO VIVO' 
				   WHEN 10 THEN 'CD - CARNET DIPLOMATICO' 
				   WHEN 11 THEN 'SC - SALVOCONDUCTO' 
				   WHEN 12 THEN 'PE - PERMISO ESPECIAL DE PERMANENCIA' ELSE 'OTRO' END [TIPO IDENTIFICACION],
pac.IPCODPACI AS IDENTIFICACION,
pac.IPNOMCOMP AS [NOMBRE PACIENTE],
pac.IPFECNACI AS [FECHA DE NACIMIENTO],
FLOOR((CAST(CONVERT(VARCHAR(8), ING.IFECHAING , 112) AS INT) - CAST(CONVERT(VARCHAR(8), PAC.IPFECNACI, 112) AS INT)) / 10000) AS [EDAD],
CASE PAC.IPSEXOPAC WHEN 1 THEN 'MASCULINO' WHEN 2 THEN 'FEMENINO' END AS SEXO,
PAC.IPTELEFON AS [TELEFONO],
PAC.IPTELMOVI AS [CELULAR],
EAPB.CODENTIDA AS [CODIGO EAPB],
EAPB.NOMENTIDA AS [NOMBRE EAPB],
CASE PAC.IPTIPOPAC WHEN 1 THEN 'Contributivo'
				   WHEN 2 THEN 'Subsidiado'
				   WHEN 3 THEN 'Vinculado'
				   WHEN 4 THEN 'Particular'
				   WHEN 5 THEN 'Otro' 
				   WHEN 6 THEN 'Desplazado Reg. Contributivo'
				   WHEN 7 THEN 'Desplazado Reg. Subsidiado'
				   WHEN 8 THEN 'Desplazado No Asegurado' END AS [REGIMEN],
ING.NUMINGRES AS [NUMERO DE INGRESO],
FIS.VALOR AS [RESULTADO COLONOSCOPIA],
FEC.VALOR AS [FECHA COLONOSCOPIA],
ING.IFECHAING AS [FECHA INGRESO],
1 as 'CANTIDAD',
CAST(ING.IFECHAING AS date) AS 'FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
[Report].[TablaExamenFisico] FIS INNER JOIN
DBO.INPACIENT PAC ON FIS.IPCODPACI=PAC.IPCODPACI AND NOMBRE_VARIABLE='Resultado de colposcopia' INNER JOIN 
DBO.INENTIDAD EAPB ON PAC.CODENTIDA=EAPB.CODENTIDA LEFT JOIN
dbo.ADINGRESO ING ON FIS.NUMINGRES=ING.NUMINGRES LEFT JOIN
DBO.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE LEFT JOIN
[Report].[TablaExamenFisico] FEC ON FIS.NUMINGRES=FEC.NUMINGRES AND FEC.NOMBRE_VARIABLE='Fecha de realización de colposcopia'
