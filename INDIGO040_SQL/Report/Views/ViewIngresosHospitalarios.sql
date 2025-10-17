-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewIngresosHospitalarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0





/****************************************************************************************
-----------------------------------------------------------------------------------------
Version 1
Persona que modifico: AMIRA GIL MENESES
Observacion:Se ingresa dirección, Telefono y Móvil del Paciente. Solicitud del HSJ
Fecha:12-07-2023
-----------------------------------------------------------------------------------------
****************************************************************************************/

CREATE VIEW [Report].[ViewIngresosHospitalarios] as

/*
INDIGO001
INDIGO006
INDIGO007
INDIGO008
INDIGO009
INDIGO010
INDIGO012
INDIGO013
INDIGO014
INDIGO015
INDIGO030
*/

WITH ESTANCIA_UNICA
          AS (SELECT EST.IPCODPACI, 
                     EST.NUMINGRES, 
                     MIN(ID) ID
              FROM CHREGESTA AS EST
              GROUP BY EST.IPCODPACI, 
                       EST.NUMINGRES),
          CTE_INGRESOS_HOSPITALARIOS
          AS (SELECT CEN.NOMCENATE 'CENTRO ATENCION',
                     CASE UNI.UFUTIPUNI
                         WHEN 1 THEN 'URGENCIAS'
                         WHEN 2 THEN 'HOSPITALIZACION'
                         WHEN 3 THEN 'APOYO DIAGNOSTICO'
                         WHEN 4 THEN 'APOYO TERAPEUTICO'
                         WHEN 5 THEN 'UCI'
                         WHEN 6 THEN 'UCI'
                         WHEN 7 THEN 'UCI'
                         WHEN 8 THEN 'UCI'
                         WHEN 9 THEN 'UCI'
                         WHEN 10 THEN 'UCI'
                         WHEN 11 THEN 'UCI'
                         WHEN 12 THEN 'UNIDAD RENAL'
                         WHEN 13 THEN 'UNIDAD ONCOLOGICA'
                         WHEN 14 THEN 'UNIDAD MEDICINA NUCLEAR'
                         WHEN 15 THEN 'CONSULTA EXTERNA'
                         WHEN 16 THEN 'UNIDAD MENTAL'
                         WHEN 17 THEN 'UNIDAD DE QUEMADOS'
                         WHEN 18 THEN 'UNIDAD DE CUIDADOS PALATIVOS'
                         WHEN 19 THEN 'CIRUGIA'
                         WHEN 20 THEN 'LABORATORIOS'
                         WHEN 21 THEN 'CARDIOLOGIA NO INVASIVA'
                         WHEN 22 THEN 'CARDIOLOGIA INVASIVA'
                         WHEN 23 THEN 'GINECO OBSTETRICIA'
                         WHEN 24 THEN 'CONSULTA EXTERNA GINOCO OBSTETRICIA'
                         WHEN 30 THEN 'OTRAS'
                         WHEN 31 THEN 'CONSULTA PRIORITARIA' END 'TIPO UNIDAD', 
                     UNI.UFUDESCRI 'UNIDAD FUNCIONAL',
					 CASE EST.CODTIPEST WHEN '001' THEN 'GENERAL' 
									    WHEN '002' THEN 'CUIDADO BASICO' 
									    WHEN '003' THEN 'CUIDADO INTERMEDIO' 
									    ELSE 'CUIDADO INTENSIVO'END AS 'TIPO ESTANCIA',
                     HEA.Code 'CODIGO ENTIDAD', 
                     HEA.Name 'ENTIDAD', 
                     CGR.Name 'GRUPO DE ATENCION',
					 CASE PAC.IPTIPOPAC WHEN 1 THEN 'CONTRIBUTIVO' 
										WHEN 2 THEN 'SUBSIDIADO' 
										WHEN 3 THEN 'VINCULADO' 
										WHEN 4 THEN 'PARTICULAR' 
										WHEN 5 THEN 'OTRO' 
										WHEN 6 THEN 'DESPLAZADO REG. CONTRIBUTIVO' 
										WHEN 7 THEN 'DESPLAZADO REG. SUBSIDIADO' 
										ELSE 'DESPLAZADO NO ASEGURADO' 
										END AS 'RÉGIMEN',
                     CAM.NUMCAMHOS 'CAMA', 
                     CAM.DESCCAMAS 'DESCRIPCION CAMA',
                     CASE PAC.IPTIPODOC
                         WHEN '1' THEN 'CC'
                         WHEN '2' THEN 'CE'
                         WHEN '3' THEN 'TI'
                         WHEN '4' THEN 'RC'
                         WHEN '5' THEN 'PA'
                         WHEN '6' THEN 'AS'
                         WHEN '7' THEN 'MS'
                         WHEN '8' THEN 'NU'
                         WHEN '9' THEN 'NV'
                         WHEN '10' THEN 'CD'
                         WHEN '11' THEN 'SC'
                         WHEN '12' THEN 'PE'
                     END AS [TIPO IDENTIFICACION],
                     CASE PAC.IPTIPODOC
                         WHEN '1' THEN 'CEDULA DE CIUDADANIA'
                         WHEN '2' THEN 'CEDULA DE EXTRANJERIA'
                         WHEN '3' THEN 'TARJETA DE IDENTIDAD'
                         WHEN '4' THEN 'REGISTRO CIVIL'
                         WHEN '5' THEN 'PASAPORTE'
                         WHEN '6' THEN 'ADULTO SIN IDENTIFICACION'
                         WHEN '7' THEN 'MENOR SIN IDENTIFICACION'
                         WHEN '8' THEN 'NUMERO UNICO DE IDENTIFICACIÒN'
                         WHEN '9' THEN 'CERTIFICADO NACIDO VIVO'
                         WHEN '10' THEN 'CARNET DIPLOMATICO'
                         WHEN '11' THEN 'SALVOCONDUCTO'
                         WHEN '12' THEN 'PERMISO ESPECIAL DE PERMANENCIA'  END AS 'DESCRIPCION IDENTIFICACION', 
                     EST.IPCODPACI AS 'IDENTIFICACION', 
                     PAC.IPPRINOMB 'PRIMER NOMBRE', 
                     PAC.IPSEGNOMB 'SEGUNDO NOMBRE', 
                     PAC.IPPRIAPEL 'PRIMER APELLIDO', 
                     PAC.IPSEGAPEL 'SEGUNDO APELLIDO', 
                     PAC.IPNOMCOMP 'NOMBRE COMPLETO PACIENTE', 
                     PAC.IPFECNACI 'FECHA NACIMIENTO', 
                     FLOOR((CAST(CONVERT(VARCHAR(8), EST.FECINIEST, 112) AS INT) - CAST(CONVERT(VARCHAR(8), PAC.IPFECNACI, 112) AS INT)) / 10000) AS EDAD,
					 CASE WHEN PAC.IPSEXOPAC = '1' THEN 'M' ELSE 'F' END 'SEXO',
					 PAC.IPTELMOVI 'MOVIL',
					 PAC.IPTELEFON 'TELEFONO',
					 PAC.IPDIRECCI 'DIRECCION',
                     EST.NUMINGRES 'INGRESO', 
					 CASE WHEN DIS.DISCDESCRI IS NULL THEN 'NINGUNO' ELSE DIS.DISCDESCRI END AS DISCAPACIDAD, 
                     CAST(EST.FECINIEST AS DATE) AS 'FECHA INICIAL ESTANCIA', 
                     PRO.NOMMEDICO 'PROFESIONAL DE LA SALUD', 
                     ESP.DESESPECI 'ESPECIALIDAD', 
                     ING.CODDIAING 'CIE10 INGRESO', 
                     DIA.NOMDIAGNO 'DIAGNOSTICO DE INGRESO', 
                     ING.CODDIAEGR 'CIE10 EGRESO', 
                     DIAE.NOMDIAGNO 'DIAGNOSTICO DE EGRESO', 
                     1 AS 'CANTIDAD', 
					 CAST(EST.FECINIEST AS date) AS 'FECHA BUSQUEDA',
					 YEAR(EST.FECINIEST) AS 'AÑO BUSQUEDA',
					 MONTH(EST.FECINIEST) AS 'MES BUSQUEDA',
					 CONCAT(FORMAT(MONTH(EST.FECINIEST), '00') ,' - ', 
					 CASE MONTH(EST.FECINIEST) 
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
						 WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE BUSQUEDA',
					 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
              FROM CHREGESTA AS EST WITH(NOLOCK)
                   JOIN ESTANCIA_UNICA AS EU WITH(NOLOCK) ON EU.ID = EST.ID
                   JOIN INPACIENT AS PAC WITH(NOLOCK) ON PAC.IPCODPACI = EST.IPCODPACI
/*IN V1*/		   LEFT JOIN ADDISCAPACI DIS ON DIS.DISCCODIGO=PAC.DISCCODIGO   /*FN V1*/
                   JOIN ADINGRESO AS ING WITH(NOLOCK) ON ING.IPCODPACI = EST.IPCODPACI
                                                         AND ING.NUMINGRES = EST.NUMINGRES
                   JOIN CHCAMASHO CAM ON EST.CODICAMAS = CAM.CODICAMAS
                   JOIN ADCENATEN AS CEN WITH(NOLOCK) ON CAM.CODCENATE = CEN.CODCENATE
                   JOIN INUNIFUNC UNI WITH(NOLOCK) ON CAM.UFUCODIGO = UNI.UFUCODIGO
                   JOIN Contract.HealthAdministrator HEA WITH(NOLOCK) ON ING.GENCONENTITY = HEA.ID
                   JOIN Contract.CareGroup AS CGR WITH(NOLOCK) ON ING.GENCAREGROUP = CGR.Id
                   LEFT JOIN..INPROFSAL PRO WITH(NOLOCK) ON EST.CODPROSAL = PRO.CODPROSAL
                   LEFT JOIN..INESPECIA AS ESP WITH(NOLOCK) ON ESP.CODESPECI = EST.CODESPECI
                   LEFT JOIN..INDIAGNOS AS DIA ON ING.CODDIAING = DIA.CODDIAGNO
                   LEFT JOIN..INDIAGNOS AS DIAE ON ING.CODDIAEGR = DIAE.CODDIAGNO 
              --WHERE CAST(EST.FECINIEST AS DATE) BETWEEN @FECINI AND @FECFIN
              )
          SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
                 *
          FROM CTE_INGRESOS_HOSPITALARIOS; 
