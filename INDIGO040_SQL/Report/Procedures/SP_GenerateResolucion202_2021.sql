-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_GenerateResolucion202_2021
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre: [Report].[SP_GenerateResolucion202_2021]
Tipo:Procedimiento Almacenado (SP)
Observacion:Informe de la 202 V#2, con tablas variables almacenadas por grupo poblacional
Profesional: Nilsson Miguel Galindo Lopez
Fecha:26-10-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:21-02-2023
Ovservaciones: Se parametriza las historiaa clinicas de odontologia (28) y salud bucal (33), para las instituciones que reportan RIAS
------------------------------------------------------------------------------------------
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:10-10-2023
Observaciones: Se ajustan las escalas de desarrollo, se crea nueva tabla, para no tener encuenta solo la tabla dbo.HCESCADETALLE
			   si no tambien la tabla HCESCALASRESULTITEMS
--------------------------------------------------------------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:23-01-2022
Observaciones: Se ajusta la logica del COP y del IPA
--------------------------------------------------------------------------------------------
Version 4
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:23-02-2024
Observaciones: Se ajusta la logica para el grupo de tuberculosis, teniendo en cuenta primero los laboratorios y despues las nuevas variables
			   creadas para CHOAN
--------------------------------------------------------------------------------------------
Version 5
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:01-08-2024
Observaciones: Se cambia la logica del COP
***********************************************************************************************************************************/


	CREATE PROCEDURE report.SP_GenerateResolucion202_2021 
	    @FechaInicial date,
	    @FechaFinal date
	AS


--declare @FechaInicial date = '2024-08-01';
--declare @FechaFinal date = '2024-08-30';

--set @FechaInicial = '2024-07-01';
--set @FechaFinal = '2024-07-31';



/************************************************************************************************************************************************
---------------------------------------DECLARACION DE LAS VARIABLES TABLAS----------------------------------------------------------------------
************************************************************************************************************************************************/
DECLARE @BASE as TABLE([IPCODPACI] [varchar](25) NOT NULL,
							  [FECHISPAC] [datetime] NOT NULL,
							  [CODCENATE] [char](10) NOT NULL,
							  [NUMINGRES] [char](10),
							  FECHEGRESO DATE,
							  [CENTRO DE ATENCION] VARCHAR(100));

DECLARE @TLBIngreso as TABLE([IPCODPACI] [varchar](25) NOT NULL,
							  [FECHISPAC] [datetime] NOT NULL,
							  [CODCENATE] [char](10) NOT NULL,
							  [NUMINGRES] [char](10),
							  FECHEGRESO DATE,
							  [CENTRO DE ATENCION] VARCHAR(100));

DECLARE @TLBHistoria as TABLE(NUMERO INT,
							  [IPCODPACI] [varchar](25) NOT NULL,
							  [FECHISPAC] [datetime] NOT NULL,
							  [CODCENATE] [char](10) NOT NULL,
							  [NUMINGRES] [char](10),
							  FECHEGRESO DATE,
							  [CENTRO DE ATENCION] VARCHAR(100));

DECLARE @TBLGestacion AS TABLE(NUMERO INT,
							   IPCODPACI VARCHAR (25),
							   FECHISPAC DATETIME,
							   FECPROPAR DATETIME,
							   VALOR INT,
							   GESTACION INT);

DECLARE @TBLMedicamento AS TABLE(ID INT,
								 TIPO INT,
								 IPCODPACI VARCHAR(25),
								 FECINIDOS DATETIME,
								 DESPRODUC CHAR(255));

DECLARE @TBLRecienNacido AS TABLE(IPCODPACI VARCHAR (25),
								  [49] DATE,
								  [50] DATE);

DECLARE @TBLControlPrenatal AS TABLE(NUMERO INT,
									 IPCODPACI VARCHAR (25),
									 [56] DATE);

DECLARE @TBLGestantes AS TABLE(IPCODPACI VARCHAR(25),
							   [14] INT,
							   [23] INT,
							   [33] VARCHAR(10),
							   [35] INT,
							   [49] VARCHAR(10),
							   [50] VARCHAR(10),
							   [51] VARCHAR(10),
							   [56] VARCHAR(10),
							   [58] VARCHAR(10),
							   [59] INT,
							   [60] INT,
							   [61] INT)
DECLARE @TBLExaFisico AS TABLE(IPCODPACI VARCHAR (25),
                            VARIABLE INT,
							VALOR VARCHAR (5000),
							EDAD INT,
							[10] VARCHAR(1),
							FECHA DATE,
							NUMINGRES [char](10),
							NUMEFOLIO INT,
							OPCION INT);

DECLARE @TBLNotasAdministrativas AS TABLE(IPCODPACI VARCHAR (25),
									   VARIABLE INT,
									   VALOR VARCHAR (MAX),
									   CODIGO VARCHAR (50),
									   EDAD INT,
									   [10] VARCHAR(1),
									   TIPO INT,
									   ID INT);

DECLARE @TBLFacturacion AS TABLE (ID INT,
								  IPCODPACI VARCHAR (25),
								  VARIABLE INT,
								  Code VARCHAR (8),
								  FECHASERVICIO DATE,
								  EDAD INT,
								  [10] VARCHAR(1),
								  NUMINGRES [char](10));

DECLARE @TBLFechaMamografia AS TABLE(IPCODPACI VARCHAR (25),
									VALOR DATE,
									EDAD INT,
									[10] VARCHAR(1));

DECLARE @TBLResultadosmamografia AS TABLE(IPCODPACI VARCHAR(25),
										  VALOR INT,
										  EDAD INT,
										  [10] VARCHAR(1));

DECLARE @TBLfechaBiopsias AS TABLE(IPCODPACI VARCHAR(25),
										  VALOR DATE,
										  EDAD INT,
										  [10] VARCHAR(1));

DECLARE @TBLDocumentos AS TABLE(IPCODPACI VARCHAR(25),
								VARIABLE INT,
								FECHA DATE)
DECLARE @TBLResultadoBiopsiaMama AS TABLE (IPCODPACI VARCHAR(25),
										   VALOR INT);

DECLARE @TBLCaMama AS TABLE (NUMERO INT,
							 IPCODPACI VARCHAR (25),
							 [96] VARCHAR(10),
							 [97] INT,
							 [99] VARCHAR(10),
							 [100] VARCHAR(10),
							 [101] INT);

DECLARE @TBLAgudezaVisual AS TABLE (IPCODPACI VARCHAR(25),
									[27] INT,
									[28] INT,
									[62] VARCHAR(10));

DECLARE @TBLAnticonceptivo AS TABLE(IPCODPACI VARCHAR(24),
									[53] VARCHAR(10),
									[54] INT,
									[55] VARCHAR (10));
DECLARE @TBLFechaColposcopia AS TABLE(IPCODPACI VARCHAR(25),
									  [91] VARCHAR(10));

DECLARE @TBLCancerCervix AS TABLE (IPCODPACI VARCHAR(25),
								   [47] INT,
								   [86] INT,
								   [87] VARCHAR (10),
								   [88] INT,
								   [89] INT,
								   [90] BIGINT,
								   [91] VARCHAR (10),
								   [93] VARCHAR (10),
								   [94] INT);

DECLARE @TBLCancerColon AS TABLE (IPCODPACI VARCHAR(25),
								  [24] INT,
								  [36] INT,
								  [66] VARCHAR(10),
								  [67] VARCHAR(10));
DECLARE @TBLCancerProstata AS TABLE(IPCODPACI VARCHAR(25),
									[22] INT,
									[64] VARCHAR (10),
									[73] VARCHAR (10),
									[109] VARCHAR(4));
DECLARE @TBLCOP AS TABLE(IPCODPACI VARCHAR(25),
						 [76] VARCHAR(10),
						 [102] VARCHAR(12));
--DECLARE @TBLACalculoCOP as TABLE(IPCODPACI VARCHAR(25),
--								 CEO_C INT,
--								 CEO_O INT,
--								 CEO_E INT,
--								 CPO_C INT,
--								 CPO_O INT,
--								 CPO_P INT,
--								 FECHAREG DATE,
--								 NUMEFOLIO INT,
--								 NUMERO INT);
DECLARE @TBLACalculoCOP as TABLE(IPCODPACI VARCHAR(25),
								 ID INT,
								 COP CHAR(12),
								 FECHAREG DATE);
DECLARE @TBLPrimeraInfancia AS TABLE(IPCODPACI VARCHAR(25),
									 [71] INT,
									 [77] INT);
DECLARE @TBLRNacido AS TABLE (IPCODPACI VARCHAR(25),
							  [37] INT,
							  [38] INT,
							  [48] INT,
							  [65] VARCHAR(10),
							  [84] VARCHAR (10),
							  [85] INT);
DECLARE @TBLLaboratorio AS TABLE (IPCODPACI VARCHAR(25),
								  FECORDMED DATETIME,
								  VALOR VARCHAR(MAX),
								  ANALITO VARCHAR(150),
								  [AUTO] INT,
								  VARIABLE INT);
DECLARE @TBLARiesgoCardio AS TABLE(IPCODPACI VARCHAR(25),
								   [57] INT,
								   [72] VARCHAR(10),
								   [92] INT,
								   [95] INT,
								   [98] INT,
								   [103] VARCHAR(10),
								   [104] VARCHAR(10),
								   [105] VARCHAR(10),
								   [106] VARCHAR(10),
								   [107] VARCHAR(10),
								   [111] VARCHAR(10),
								   [114] INT,
								   [117] VARCHAR(10),
								   [118] VARCHAR(10));

DECLARE @TBLEscalaVale AS TABLE (IPCODPACI VARCHAR(25),
								 [40] INT,
								 [63] VARCHAR(10));

DECLARE @TBLEscalas AS TABLE (IPCODPACI VARCHAR(25),
							  [43] INT,
							  [44] INT,
							  [45] INT,
							  [46] INT,
							  [16] INT);
DECLARE @TBLTodaPoblacion AS TABLE (IPCODPACI VARCHAR(25),
									[29] VARCHAR(10),
									[30] VARCHAR(5),
									[31] VARCHAR (10),
									[32] INT,
									[42] INT,
									[52] VARCHAR (10),
									[78] VARCHAR (10),
									[79] INT,
									[80] VARCHAR(10),
									[81] INT,
									[82] VARCHAR(10),
									[83] INT,
									[110] VARCHAR(10));
DECLARE @TBLExamenFisico AS TABLE (IPCODPACI VARCHAR(25),
								   [29] VARCHAR (10),
								   [30] VARCHAR (5),
								   [31] VARCHAR (10),
								   [32] INT);
DECLARE @TBLTuberculosis AS TABLE(IPCODPACI VARCHAR(25),
								  [18] INT,
								  [112] VARCHAR(10),
								  [113] INT);
DECLARE @ANTVALORES AS TABLE(ID INT,
							 IDHCHISPACA INT,
							 CODANTECEDENTE INT,
							 IDANTVARIABLE INT,
							 VALOR VARCHAR(5000),
							 IDITEMLISTA INT);
DECLARE @ANTECEDENTES AS TABLE (IPCODPACI VARCHAR (25),
								IDHCHISPACA INT,
								VARIABLE INT,
								VALOR VARCHAR (50));
DECLARE @IPA AS TABLE (IPCODPACI VARCHAR (25),
					   [19] VARCHAR(10));
--IN V3
DECLARE @ESCALADETALLE AS TABLE(TIPOESCALA INT,
								IPCODPACI VARCHAR (25),
								NUMEFOLIO INT,
								AREAEVALU VARCHAR(1),
								RESULTADO VARCHAR(50));
--FN V3
/************************************************************************************************************************************************
-------------------------------------POBLACION SUJETA A REPORTARSE EN LA 202----------------------------------------------------------------------
************************************************************************************************************************************************/
--SE CLASIFICAN TODOS LOS PACIENTES QUE TENGAN UN INGRESO AMBULATORIO DEPENDIENDO DE LA INSTITUCIÓN SE PALICAN LAS RIAS.
DECLARE @ID_COMPANY VARCHAR(9)=(CAST(DB_NAME() AS VARCHAR(9)));
IF @ID_COMPANY='INDIGO043' OR @ID_COMPANY='INDIGO040' OR @ID_COMPANY='INDIGO041' OR @ID_COMPANY='INDIGO039' OR 
   @ID_COMPANY='INDIGO036' OR @ID_COMPANY='INDIGO030' OR @ID_COMPANY='INDIGO023' OR @ID_COMPANY='INDIGO045' OR
   @ID_COMPANY='INDIGO046' OR @ID_COMPANY='INDIGO047'
BEGIN
	INSERT INTO @BASE
	SELECT  
	ING.IPCODPACI,
	ING.IFECHAING,
	ING.CODCENATE,
	ING.NUMINGRES,
	CAST(ING.FECHEGRESO AS DATE) AS FECHEGRESO,
	CEN.NOMCENATE
	FROM DBO.ADINGRESO ING 
	INNER JOIN dbo.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE
	WHERE CAST(ING.IFECHAING AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND ING.IINGREPOR=2
END 
ELSE
BEGIN
	INSERT INTO @BASE
	SELECT  
	HC.IPCODPACI,
	HC.FECHISPAC,
	HC.CODCENATE,
	HC.NUMINGRES,
	CAST(ING.FECHEGRESO AS DATE) AS FECHEGRESO,
	CEN.NOMCENATE
	FROM HCHISPACA HC INNER JOIN
	dbo.ADINGRESO ING ON HC.NUMINGRES=ING.NUMINGRES
	INNER JOIN dbo.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE
	WHERE CAST(HC.FECHISPAC AS DATE) BETWEEN @FechaInicial AND @FechaFinal AND HC.IDMODELOHC IN (6,7,8,9,10,11,12,13,14,16,18,28,30,33,35,41)

END

--SE AGREGA TODA LA POBALCION RECIEN NACIDO
INSERT INTO @TLBIngreso
SELECT * FROM @BASE
UNION ALL
SELECT
RN.IPCODPACIHIJO AS IPCODPACI,
RN.FECHISPAC,
ING.CODCENATE,
RN.NUMINGRESHIJO AS NUMINGRES,
CAST(ING.FECHEGRESO AS DATE) AS FECHEGRESO,
CEN.NOMCENATE
FROM 
dbo.HCRECINAC RN INNER JOIN
DBO.ADINGRESO ING ON RN.NUMINGRESHIJO=ING.NUMINGRES AND RN.FECHANACIM BETWEEN @FechaInicial AND @FechaFinal
INNER JOIN dbo.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE
UNION ALL
--SE AGREGA LA POBLACIÓN CON PARTOS
SELECT
RN.IPCODPACI,
RN.FECHISPAC,
ING.CODCENATE,
RN.NUMINGRES,
CAST(ING.FECHEGRESO AS DATE) AS FECHEGRESO,
CEN.NOMCENATE
FROM 
dbo.HCRECINAC RN INNER JOIN
DBO.ADINGRESO ING ON RN.NUMINGRES=ING.NUMINGRES AND RN.FECHANACIM BETWEEN @FechaInicial AND @FechaFinal
INNER JOIN dbo.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE
UNION ALL
--POBLACION CON PROCEDIMIENTO DE COLPOSCOPIA
SELECT
CX.IPCODPACI,
CX.FECHORAIN,
ING.CODCENATE,
CX.NUMINGRES,
CAST(ING.FECHEGRESO AS DATE) AS FECHEGRESO,
CEN.NOMCENATE
FROM  
dbo.AGEPROGQX CX INNER JOIN
DBO.ADINGRESO ING ON CX.NUMINGRES=ING.NUMINGRES AND CX.FECHORAIN BETWEEN @FechaInicial AND @FechaFinal INNER JOIN
Contract.CUPSEntity CUP ON CX.CODSERIPS=CUP.Code AND CUP.Description LIKE '%COLPOSCOPIA%'
INNER JOIN dbo.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE
UNION ALL
--POBLACION CON PROCEDIMIENTOS DE LEGRADO0S
SELECT
CX.IPCODPACI,
CX.FECHORINI,
ING.CODCENATE,
CX.NUMINGRES,
CAST(ING.FECHEGRESO AS DATE) AS FECHEGRESO,
CEN.NOMCENATE
FROM  
dbo.HCQXINFOR CX INNER JOIN
DBO.ADINGRESO ING ON CX.NUMINGRES=ING.NUMINGRES AND CX.FECHORINI BETWEEN @FechaInicial AND @FechaFinal INNER JOIN
Contract.CUPSEntity CUP ON CX.CODSERIPS=CUP.Code AND (CUP.Description LIKE '%LEGRADO%' OR CUP.Description LIKE '%SALPINGECTOMIA%')
INNER JOIN dbo.ADCENATEN CEN ON ING.CODCENATE=CEN.CODCENATE

---------------------CONTAMOS LOS PACIENTES QUE ESTAN REPETIDOS CON LA COLUMNA NUMERO PARA ELIMINARLOS--------------------------------------------------

INSERT INTO @TLBHistoria
SELECT 
ROW_NUMBER ( )   
OVER (PARTITION BY ING.IPCODPACI  order by ING.NUMINGRES DESC) 'NUMERO',
* FROM @TLBIngreso ING;
--SE ELIMINA LOS PACIENTES QUE SE ENCUENTRAN DUPLICADOS
DELETE FROM @TLBHistoria WHERE NUMERO!=1;


/**********************************************************************************************************************
------------------------- VARIABLES TABLA 3 AL 13 DATOS PERSONALES DEL PACIENTE----------------------------------------
***********************************************************************************************************************/

SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
HC.[CENTRO DE ATENCION],
'2' AS [0],
ROW_NUMBER ( )   
OVER (order by HC.FECHISPAC DESC) [1],
CASE WHEN MONTH(HC.FECHISPAC) BETWEEN 1 AND 3 THEN CONCAT ('1 - Primer Trimestre ', YEAR(HC.FECHISPAC)) 
	 WHEN MONTH(HC.FECHISPAC) BETWEEN 4 AND 6 THEN CONCAT ('2 - Segundo Trimestre ', YEAR(HC.FECHISPAC)) 
	 WHEN MONTH(HC.FECHISPAC) BETWEEN 7 AND 9 THEN CONCAT ('3 - Tercero Trimestre ', YEAR(HC.FECHISPAC)) 
	 WHEN MONTH(HC.FECHISPAC) BETWEEN 10 AND 12 THEN CONCAT ('4 - Cuarto Trimestre ', YEAR(HC.FECHISPAC)) END as TRIMESTRE,
HC.NUMINGRES AS [INGRESO],
CONVERT(varchar, CAST(HC.FECHISPAC as date), 23) [FECHA ATENCION],
ID.CODENTIDA AS [CODIGO ENTIDAD],
ID.NOMENTIDA AS ENTIDAD,
CASE PAC.TIPCOBSAL WHEN 1 THEN 'Contributivo'
				   WHEN 2 THEN 'Subsidiado Total'
				   WHEN 3 THEN 'Subsidiado Parcial'
				   WHEN 4 THEN 'Poblacion Pobre sin Asegurar con SISBEN'
				   WHEN 5 THEN 'Poblacion Pobre sin Asegurar sin SISBEN'
				   WHEN 6 THEN 'Desplazados'
				   WHEN 7 THEN 'Plan de Salud Adicional'
				   WHEN 8 THEN 'Otros' ELSE 'Otros' END AS [TIPO COBERTURA],
(((12* year(HC.FECHISPAC))-(12*(year(PAC.IPFECNACI))))+ (month(HC.FECHISPAC)-month(PAC.IPFECNACI)))/12 AS EDAD,
DATEDIFF(MONTH,PAC.IPFECNACI,HC.FECHISPAC) AS MESES,
PAC.IPCODPACI,
CEN.CODIPSSEC AS [2],
CASE PAC.IPTIPODOC WHEN '1' THEN 'CC' 
				   WHEN '2' THEN 'CE'
				   WHEN '3' THEN 'TI'
				   WHEN '4' THEN 'RC'	
				   WHEN '5' THEN 'PA'	
				   WHEN '6' THEN 'AS'
				   WHEN '7' THEN 'MS'
				   WHEN '8' THEN 'MS'
				   WHEN '9' THEN 'CN'
				   WHEN '10' THEN 'CD'	
				   WHEN '11' THEN 'SC' 
				   WHEN '12' THEN 'PE'
				   WHEN '13' THEN 'PT'
				   WHEN '14' THEN 'DE' ELSE 'N/A'END AS [3],
REPLACE(PAC.IPPRIAPEL,'Ñ','N') AS [5],
CASE PAC.IPSEGAPEL WHEN '' THEN 'NONE' ELSE REPLACE(PAC.IPSEGAPEL,'Ñ','N') END AS [6],
REPLACE(PAC.IPPRINOMB,'Ñ','N') AS [7],
CASE PAC.IPSEGNOMB WHEN '' THEN 'NONE' ELSE REPLACE(PAC.IPSEGNOMB,'Ñ','N') END AS [8],
CONVERT(VARCHAR, CAST(PAC.IPFECNACI AS DATE), 23) AS [9],
CASE PAC.IPSEXOPAC WHEN 1 THEN 'M' ELSE 'F' END AS [10],
CASE GE.DESGRUPET WHEN 'INDIGENAS' THEN '1' 
				  WHEN 'PUEBLO ROM GITANOS' THEN '2' 
				  WHEN 'RAIZALES SAN ANDRES Y PROVIDENCIA' THEN '3' 
				  WHEN 'PALENQUEROS DE SAN BASILIO' THEN '4' 
				  WHEN 'AFROCOLOMBIANOS NEGROS MULATOS O AFRODESCENDIENTES' THEN '5'
				  ELSE '6' END AS [11],
PAC.CODACTIVI AS [12],
--ISNULL(ACT.CODACTIVI,'9999') AS [12],
CASE NIV.NIVEDESCRI WHEN 'PRE ESCOLAR' THEN '1'
					WHEN 'BASICA PRIMARIA' THEN '2'
					WHEN 'BASICA SECUNDARIA BACHILLERATO BASICO' THEN '3'
					WHEN 'MEDIA ACADEMICA O CLASICA BACHILLERATO BASICO' THEN '4'
					WHEN 'MEDIA TECNICA BACHILLERATO TECNICO' THEN '5'
					WHEN 'NORMALISTA' THEN '6'
					WHEN 'TECNICA PROFESIONAL' THEN '7'
					WHEN 'TECNOLOGICA' THEN '8'
					WHEN 'PROFESIONAL' THEN '9'
					WHEN 'ESPECIALIZACION' THEN '10'
					WHEN 'MAESTRIA' THEN '11'
					WHEN 'DOCTORADO' THEN '12' ELSE '13' END AS [13],
CASE PAI.Name WHEN 'Colombia' THEN '170' WHEN 'Brasil' THEN '076'  WHEN 'Venezuela' THEN '862' WHEN 'Perú' THEN '604'  WHEN 'Chile' THEN '152'
			  WHEN 'Estados Unidos' THEN '840' WHEN 'Argentina' THEN '032' WHEN 'Ecuador' THEN '218' WHEN 'México' THEN '484' WHEN 'Bolivia' THEN '068'
ELSE '170' END AS [34],
CAST(HC.FECHISPAC as date) [FECHA BUSQUEDA],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
INTO #TBLConsulta202
from 
@TLBHistoria HC INNER JOIN
DBO.INPACIENT PAC ON HC.IPCODPACI=PAC.IPCODPACI INNER JOIN
dbo.INENTIDAD ID ON PAC.CODENTIDA=ID.CODENTIDA LEFT JOIN
DBO.ADGRUETNI GE ON PAC.CODGRUPOE=GE.CODGRUPOE LEFT JOIN
dbo.ADCENATEN CEN ON HC.CODCENATE=CEN.CODCENATE LEFT JOIN
dbo.ADNIVELED NIV ON PAC.NIVECODIGO=NIV.NIVECODIGO LEFT JOIN
Common.Country PAI ON PAC.IDPAIS=PAI.Id
--LEFT JOIN Report.Actividades ACT ON PAC.CODACTIVI=ACT.CODIGO;
/*********************************TABLA DE MEDICAMENTOS DISPENSADOS**************************************************/
INSERT INTO @TBLMedicamento
SELECT
DD.ID,
CASE WHEN PRO.[Name] LIKE '%ACIDO%FOLICO%' THEN 1 
	 WHEN PRO.[Name] LIKE '%FOLICO%ACIDO%' THEN 1	
	 WHEN PRO.[Name] LIKE '%SULFATO%FERROSO%' THEN 3 
	 WHEN PRO.[Name] LIKE '%CALCIO%' THEN 4
	 WHEN PRO.[Name] LIKE '%PRESERVATIVOS%' THEN 5 
	 WHEN PRO.[Name] LIKE '%LEVONORGESTREL%' THEN 7
	 WHEN PRO.[Name] LIKE '%MEDROXIPROGESTERONA%' THEN 8
	 WHEN PRO.[Name] LIKE '%VITAMINA A%' THEN 6
	 WHEN PRO.[Name] LIKE '%ETINILESTRADIOL%' THEN 9 
	 WHEN PRO.[Name] LIKE '%INTRAUTERINO%' THEN 10 END AS TIPO,
ING.IPCODPACI,
DD.ServiceDate,
PRO.[Name] AS DESPRODUC
FROM 
#TBLConsulta202 PAC INNER JOIN
ADINGRESO ING ON PAC.IPCODPACI=ING.IPCODPACI INNER JOIN
Inventory.PharmaceuticalDispensing D ON ING.NUMINGRES=D.AdmissionNumber INNER JOIN
Inventory.PharmaceuticalDispensingDetail DD ON D.Id=DD.PharmaceuticalDispensingId INNER JOIN
Inventory.InventoryProduct PRO ON DD.ProductId=PRO.ID
WHERE (PRO.[NAME] LIKE '%ACIDO%FOLICO%' OR PRO.[NAME] LIKE '%FOLICO%ACIDO%' OR PRO.[NAME] LIKE '%SULFATO%FERROSO%' OR PRO.[NAME] LIKE '%CALCIO%' OR PRO.[NAME] LIKE '%INTRAUTERINO%' 
OR PRO.[NAME] LIKE '%PRESERVATIVOS%'OR PRO.[NAME] LIKE '%LEVONORGESTREL%' OR PRO.[NAME] LIKE '%DIU%' OR PRO.[NAME] LIKE '%CONDONES%' 
OR PRO.[NAME] LIKE '%MEDROXIPROGESTERONA%' OR PRO.[NAME] LIKE '%VITAMINA A%' OR PRO.[NAME] LIKE '%LEVONORGESTREL/ETINILESTRADIOL%') AND PRO.[NAME] NOT LIKE '%BARRERA%' AND CAST(DD.ServiceDate AS DATE) BETWEEN @FechaInicial AND @FechaFinal
/*****************************************************************************************************************************************************
--------------------------------------------------------TABLA DE EXAMEN FISICO--------------------------------------------------------------------
*****************************************************************************************************************************************************/
----------------------------------VARIABLE TABLA EXAMENES FISICOS-------------------------------------------------------
INSERT INTO @TBLExaFisico
SELECT
FIS.IPCODPACI,
CASE FIS.NOMBRE_VARIABLE WHEN 'Fecha de atención en salud para la promoción y apoyo de la lactancia materna' THEN 1
                     WHEN 'Fecha de realización de prueba sangre oculta en heces'THEN 2---Fecha sangre oculta
                     WHEN 'Fecha de realización de colonoscopia tamizaje'THEN 3 -- Fecha Colonoscopia
					 WHEN 'Fecha de colesterol LDL'THEN 4 --Fecha LDL
					 WHEN 'Fecha de realización de PSA'THEN 5
					 WHEN 'Fecha de realización de Ag Hep B' THEN 6 --Fecha Hepatitis B
					 WHEN 'Fecha realización de prueba tamizaje para sífilis' THEN 7
					 WHEN 'Fecha de realización de prueba para VIH' THEN 8
					 WHEN 'Fecha tamizaje TSH neonatal' THEN 9
					 WHEN 'Fecha de toma de mamografía'THEN 10 --FECHA MAMOGRAFIA
					 WHEN 'Fecha de toma de Bx de mama'THEN 11--FECHA DE TOMA BIOPSIA
					 WHEN 'Fecha de resultado de Bx CCU' THEN 12 --FECHA BIOPSIA DE CUELLO UTERINO
					 WHEN 'Fecha de Hemoglobina' THEN 13 WHEN 'Fecha Hemoglobina' THEN 13 --FECHA DE TOMA HEMOGLOBINA
					 WHEN 'Fecha de Glicemia' THEN 14 --Glicemia Basal
					 WHEN 'Fecha de creatinina' THEN 15 --FECHA CREATININA
					 WHEN 'Fecha de toma tamizaje Hep C' THEN 16 --FECHA HEPATITIS C
					 WHEN 'Fecha de colesterol HDL'THEN 17 --FECHA HDL
					 WHEN 'Fecha de trigliceridos' THEN 18 --FECHA TRIGLICERIDOS
					 WHEN 'Resultado de prueba de sangre oculta en heces (a partir de 50 años)'THEN 19 ---Sangre Oculta
					 WHEN 'Agudeza visual OD' THEN 20 
					 WHEN 'Respuesta a la luz OI' THEN 21 --Ojo izquierdo
					 WHEN 'Respuesta a la luz OD'THEN 22
					 WHEN 'Agudeza visual OI'THEN 23
					 WHEN 'Resultado de colonoscopia de tamizaje' THEN 24 -- Resultado Colonoscopia
					 WHEN 'Resultado de tamizaje para Hepatitis C' THEN 25 --Hepatitis C
					 WHEN 'Metodo Elegido'THEN 26 --Planificacion Metodo elegido
					 WHEN 'Resultado de glicemia' THEN 27 --Glicemia Basal
					 WHEN 'Resultado de Ag Hep B' THEN 28 --Res Hepatitis B
					 WHEN 'Resultado de prueba tamizaje para sífilis' THEN 29
					 WHEN 'Resultado de prueba para VIH' THEN 30
					 WHEN 'Resultado tamizaje TSH neonatal' THEN 31
					 WHEN 'Resultado de colesterol LDL' THEN 32 --VALOR LDL
					 WHEN 'Resultado de trigliceridos' THEN 33--VALOR TRIGLICERIDOS
					 WHEN 'Resultado de BX de mama' THEN 34--RESULTADO BIOPSIA DE MAMA
					 WHEN 'Resultado de Bx CCU' THEN 35 --RESULTADO BIOPSIA DE MAMA
					 WHEN 'Resultado de hemoglobina' THEN 36 WHEN 'Resultado hemoglobina' THEN 36 --RESULTADO HEMOGLOBINA
					 WHEN 'Resultado de creatinina' THEN 37--RESULTADO CREATININA
					 WHEN 'Clasificacion Riesgo Cardiovascular' THEN 38
					 WHEN 'Resultado de mamografía' THEN 39
					 WHEN 'Tacto Rectal' THEN 40 WHEN 'Descripcion Tacto rectal' THEN 40 --PROSTATA
					 WHEN 'Resultado de colesterol HDL' THEN 41 
					 WHEN 'Resultado de creatinina 3' THEN 42 
					 WHEN 'Resultado de PSA' THEN 43 
					 WHEN 'fecha de realizacion de colonoscopia' THEN 44 
					 WHEN 'Fecha de atención en salud para la promoción y apoyo de la lactancia materna' THEN 45 
					 WHEN 'Técnica de lactancia materna' THEN 46 
					 WHEN 'Resultado de tamizaje VALE 2' THEN 47 --ESCALA VALE RESULTADO
					 WHEN 'Fecha de tamizaje VALE' THEN 48 --ESCALA VALE FECHA
					 WHEN 'Clasificación del riesgo gestacional' THEN 49 
					 WHEN 'Descripción ojos' THEN 50 --tamizaje neonatal visual
					 WHEN 'Resultado de tamizaje auditivo neonatal' THEN 51
					 WHEN 'Baciloscopia' THEN 52
					 WHEN 'Fecha de toma de baciloscopia diagnóstico' THEN 53 
					 WHEN 'Resultado de baciloscopia' THEN 54 END AS VARIABLE,
FIS.VALOR,
PAC.EDAD,
PAC.[10],
FIS.FECHA,
FIS.NUMINGRES,
FIS.NUMEFOLIO,
FIS.OPCION
FROM --SELECT TOP 10 * FROM [Report].[TablaExamenFisico]
#TBLConsulta202 PAC INNER JOIN
[Report].[TablaExamenFisico] FIS ON PAC.IPCODPACI=FIS.IPCODPACI
WHERE FIS.NOMBRE_VARIABLE IN ('Fecha de atención en salud para la promoción y apoyo de la lactancia materna',
'Fecha de realización de prueba sangre oculta en heces','Fecha de realización de colonoscopia tamizaje',
'Fecha de colesterol LDL','Fecha de realización de PSA','Fecha de realización de Ag Hep B','Fecha realización de prueba tamizaje para sífilis', 
'Fecha de realización de prueba para VIH','Fecha tamizaje TSH neonatal','Fecha de toma de mamografía','Fecha de toma de Bx de mama',
'Fecha de resultado de Bx CCU', 'Fecha de toma hemoglobina','Fecha Hemoglobina','Fecha de Glicemia','Fecha de creatinina','Fecha de toma tamizaje Hep C',
'Fecha de colesterol HDL','Fecha de trigliceridos','Resultado de prueba de sangre oculta en heces (a partir de 50 años)',
'Respuesta a la luz OI','Respuesta a la luz OD','Resultado de colonoscopia de tamizaje',
'Resultado de tamizaje para Hepatitis C','Metodo Elegido','Resultado de glicemia','Resultado de Ag Hep B','Resultado de prueba tamizaje para sífilis',
'Resultado de prueba para VIH','Resultado tamizaje TSH neonatal','Resultado de colesterol LDL','Resultado de trigliceridos','Resultado de BX de mama',
'Resultado de Bx CCU','Resultado de hemoglobina','Resultado hemoglobina','Resultado de creatinina','Resultado de PSA','Clasificacion Riesgo Cardiovascular','Tacto Rectal',
'Resultado de mamografía','Agudeza visual OI','Agudeza visual OD','Resultado de colesterol HDL','Resultado de creatinina 3','Resultado de creatinina 3',
'fecha de realizacion de colonoscopia','Descripcion Tacto rectal','Fecha de atención en salud para la promoción y apoyo de la lactancia materna',
'Técnica de lactancia materna','Resultado de tamizaje VALE 2','Fecha de tamizaje VALE','Clasificación del riesgo gestacional','Descripción ojos',
'Resultado de tamizaje auditivo neonatal','Baciloscopia','Fecha de toma de baciloscopia diagnóstico','Resultado de baciloscopia') AND FIS.FECHA BETWEEN @FechaInicial AND @FechaFinal;
----------------------------------VARIABLE TABLA GESTACION-------------------------------------------------------------
INSERT INTO @TBLGestacion
SELECT 
ROW_NUMBER ( )   
OVER (PARTITION BY GES.IPCODPACI  order by GES.FECPROPAR DESC) 'NUMERO',
GES.IPCODPACI,
GES.FECHISPAC,
GES.FECPROPAR,
FIS.VALOR,
RIE.GESTACION
FROM  
#TBLConsulta202 PAC INNER JOIN
dbo.HCRIESGOSP RIE ON PAC.IPCODPACI=RIE.IPCODPACI AND (CAST(RIE.FECGESTA AS DATE) BETWEEN @FechaInicial AND @FechaFinal) INNER JOIN
DBO.HCANTGINE GES ON PAC.IPCODPACI=GES.IPCODPACI AND (CAST(GES.FECHISPAC AS DATE) BETWEEN @FechaInicial AND @FechaFinal) LEFT JOIN
@TBLExaFisico FIS ON PAC.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=49 AND FIS.NUMEFOLIO=(SELECT MAX(A.NUMEFOLIO) FROM @TBLExaFisico A WHERE FIS.IPCODPACI=A.IPCODPACI AND A.VARIABLE=49)
DELETE FROM @TBLGestacion WHERE NUMERO!=1;
/*************************************************************************
-------------------------RECIEN NACIDO------------------------------
*************************************************************************/
---------------------RECIEN NACIDO VARIABLES 49,50------------------------------------------------
INSERT INTO @TBLRecienNacido
SELECT
RN.IPCODPACI,
CAST(RN.FECHANACIM AS DATE) AS [49],
IIF(HC.FECHEGRESO IS NULL,NULL
						  ,IIF(HC.FECHEGRESO BETWEEN @FechaInicial AND @FechaFinal,CAST(HC.FECHEGRESO AS DATE)
																				   ,'1845-01-01')) AS [50]
FROM 
@TLBHistoria HC INNER JOIN
dbo.HCRECINAC RN ON HC.IPCODPACI=RN.IPCODPACI AND RN.NUMEFOLIO=(select MAX(CAST(R.NUMEFOLIO AS INT)) FROM dbo.HCRECINAC R where RN.IPCODPACI=R.IPCODPACI)
WHERE CONVERT(DATE,RN.FECHANACIM) BETWEEN @FechaInicial AND @FechaFinal;
--------------------------------------------------TABLA DE FACTURACION DE PROCEDIMIENTOS------------------------------------------------
INSERT INTO @TBLFacturacion
SELECT
FD.ID,
PAC.IPCODPACI,
CASE CUPS.Code WHEN '876801' THEN 1 WHEN '876802' THEN 1--MAMOGRAFIA
			   WHEN '851101' THEN 2 WHEN '851102' THEN 2 WHEN '851103' THEN 2 WHEN '851200' THEN 2 --PATOLOGÍA DE MAMAS
			   WHEN '673201' THEN 3 --Tratamiento ablativo o de escisión posterior a la realización de la técnica de inspección visual
			   WHEN '892901' THEN 4 WHEN '898001' THEN 4 WHEN '908436' THEN 4 WHEN '892904' THEN 4 --Tamizaje del cáncer de cuello uterino
			   WHEN '702203' THEN 5--Fecha de colposcopia
			   WHEN '861801' THEN 6 --INSERCION DE ANTICONCEPTIVOS SUBDERMICOS
			   WHEN '662101' THEN 7 WHEN '662102' THEN 7 WHEN '662103' THEN 7 WHEN '662104' THEN 7 WHEN '662201' THEN 7 WHEN '662202' THEN 7
			   WHEN '662203' THEN 7 WHEN '662204' THEN 7 --LEGRADOS
END AS VARIABLE,
CUPS.Code,
CAST(SD.ServiceDate AS DATE) AS FECHASERVICIO,--[99]
PAC.EDAD,
[10],
F.AdmissionNumber
FROM 
#TBLConsulta202 PAC INNER JOIN 
BILLING.INVOICE F ON PAC.IPCODPACI=F.PatientCode AND F.Status != 2 INNER JOIN
BILLING.INVOICEDETAIL FD ON F.Id=FD.InvoiceId /*AND FD.ID=(SELECT MAX(D.ID) FROM BILLING.INVOICEDETAIL D WHERE F.Id=D.InvoiceId)*/ INNER JOIN
BILLING.SERVICEORDERDETAIL SD ON FD.ServiceOrderDetailId=SD.Id AND (SD.ServiceDate BETWEEN @FechaInicial AND @FechaFinal) INNER JOIN
CONTRACT.CUPSENTITY AS CUPS ON CUPS.ID = SD.CUPSENTITYID 
WHERE CUPS.Code IN ('876801','876802','851101','851102','851103','851200','673201','892901','898001','908436','892904','702203','861801','662101',
'662102','662103','662104','662201','662202','662203','662204');

---------------------------Primer control prenatal variable 56-----------------------------------
DECLARE @PRENATAL DATETIME=@FechaInicial
SET @PRENATAL=(@PRENATAL-210)
INSERT INTO @TBLControlPrenatal
SELECT
HIS.NUMEFOLIO AS 'NUMERO',
HIS.IPCODPACI,
CAST(HIS.FECHISPAC AS DATE) AS [56]
FROM 
@TLBHistoria HC INNER JOIN
dbo.HCHISPACA HIS ON HC.IPCODPACI=HIS.IPCODPACI AND HIS.IDMODELOHC=11
WHERE HIS.FECHISPAC BETWEEN @PRENATAL AND @FechaFinal;
--DELETE FROM @TBLControlPrenatal WHERE NUMERO!=1;


---------------------------GESTANTES VARIABLE 14,23,33,35,49,50,56,58,59,60----------------------------------
INSERT INTO @TBLGestantes
-------POBLACION GESTANTE--------------------
SELECT
--ROW_NUMBER ( )   
--OVER (PARTITION BY GES.IPCODPACI  order by GES.FECHISPAC DESC) 'NUMERO',
PAC.IPCODPACI,
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR (PAC.[10]='M'),0
													,IIF(PRO.IPCODPACI IS NULL,IIF(GES.IPCODPACI IS NULL,IIF(RN.[49] IS NULL,21,2)
																										,IIF(RN.[49] IS NULL,GES.GESTACION,2)
																				   )
																			  ,2)
	) AS [14],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'0',IIF(GES.IPCODPACI IS NULL,'0','21')) AS [23],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'1845-01-01',IIF(GES.IPCODPACI IS NULL,'1845-01-01',IIF(GES.FECPROPAR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),GES.FECPROPAR,23)))) AS [33],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'0',IIF(GES.IPCODPACI IS NULL,'0',ISNULL(GES.VALOR,'21'))) AS [35],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR GES.IPCODPACI IS NULL,'1845-01-01',ISNULL(CONVERT(VARCHAR(10),RN.[49],23),'1800-01-01')) AS [49],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR GES.IPCODPACI IS NULL OR PRO.NUMINGRES IS NOT NULL,'1845-01-01',ISNULL(CONVERT(VARCHAR(10),RN.[50],23),'1800-01-01')) AS [50],
IIF(PAC.MESES<=8 OR GES.IPCODPACI IS NOT NULL,IIF(HC.FECHISPAC IS NULL,IIF(FIS.VALOR IS NULL,IIF(LAC.VALOR IS NULL,IIF(DIA.FECDIAGNO IS NOT NULL,CONVERT(NCHAR(10),DIA.FECDIAGNO,23)
																																						  ,'1800-01-01')
																												  ,CONVERT(VARCHAR(10),LAC.FECHA,23))
																							,CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FIS.VALOR),103),23))
																	  ,CONVERT(VARCHAR(10),HC.FECHISPAC,23))
											 ,'1845-01-01') AS [51],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'1845-01-01',IIF(GES.IPCODPACI IS NULL,'1845-01-01',ISNULL(CONVERT(VARCHAR(10),PREI.[56],23),'1800-01-01'))) AS [56],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'1845-01-01',IIF(GES.IPCODPACI IS NULL,'1845-01-01',ISNULL(CONVERT(VARCHAR(10),PREF.[56],23),'1800-01-01'))) AS [58],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'0',IIF(GES.IPCODPACI IS NULL,'0',IIF(ACF.IPCODPACI IS NULL,'21','1'))) AS [59],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'0',IIF(GES.IPCODPACI IS NULL,'0',IIF(FE.IPCODPACI IS NULL,'21','1'))) AS [60],
IIF((PAC.EDAD>=60 OR PAC.EDAD<=10) OR PAC.[10]='M' OR RN.[49] IS NOT NULL OR PRO.NUMINGRES IS NOT NULL,'0',IIF(GES.IPCODPACI IS NULL,'0',IIF(CAL.IPCODPACI IS NULL,'21','1'))) AS [61]
FROM 
#TBLConsulta202 PAC LEFT JOIN
DBO.HCHISPACA HC ON PAC.IPCODPACI=HC.IPCODPACI AND HC.IDMODELOHC=24 
											   AND HC.FECHISPAC BETWEEN @FechaInicial AND @FechaFinal
											   AND HC.FECHISPAC=(SELECT MAX(H.FECHISPAC) FROM DBO.HCHISPACA H WHERE HC.IPCODPACI=H.IPCODPACI AND H.IDMODELOHC=36)  LEFT JOIN
@TBLExaFisico FIS ON PAC.IPCODPACI=FIS.IPCODPACI AND FIS.NUMEFOLIO=(SELECT MAX(F.NUMEFOLIO) FROM @TBLExaFisico F WHERE FIS.IPCODPACI=F.IPCODPACI AND F.VARIABLE=45) 
												 AND FIS.VARIABLE=45 LEFT JOIN
@TBLExaFisico LAC ON PAC.IPCODPACI=LAC.IPCODPACI AND LAC.NUMEFOLIO=(SELECT MAX(F.NUMEFOLIO) FROM @TBLExaFisico F WHERE LAC.IPCODPACI=F.IPCODPACI AND F.VARIABLE=46) 
												 AND LAC.VARIABLE=46 LEFT JOIN
@TBLGestacion GES ON PAC.IPCODPACI=GES.IPCODPACI LEFT JOIN
@TBLMedicamento ACF ON GES.IPCODPACI=ACF.IPCODPACI AND ACF.TIPO=1 
												   AND ACF.ID=(SELECT MAX(MED.ID) FROM @TBLMedicamento MED WHERE ACF.IPCODPACI=MED.IPCODPACI AND MED.TIPO=1) LEFT JOIN
@TBLRecienNacido RN ON PAC.IPCODPACI=RN.IPCODPACI LEFT JOIN
@TBLControlPrenatal PREI ON GES.IPCODPACI=PREI.IPCODPACI AND PREI.NUMERO=(SELECT MIN(INI.NUMERO) FROM @TBLControlPrenatal INI WHERE PAC.IPCODPACI=INI.IPCODPACI) LEFT JOIN
@TBLControlPrenatal PREF ON GES.IPCODPACI=PREF.IPCODPACI AND PREF.NUMERO=(SELECT MAX(INI.NUMERO) FROM @TBLControlPrenatal INI WHERE PAC.IPCODPACI=INI.IPCODPACI) LEFT JOIN
dbo.HCQXINFOR PRO ON PAC.IPCODPACI=PRO.IPCODPACI AND CAST(PRO.FECHORINI AS DATE) BETWEEN @FechaInicial AND @FechaFinal 
												 AND PRO.CODSERIPS IN ('750101','750105','664001','664002','664003','690103')
												 AND PRO.NUMEFOLIO = (SELECT MAX(INF.NUMEFOLIO) FROM dbo.HCQXINFOR INF WHERE PRO.IPCODPACI=INF.IPCODPACI AND CAST(INF.FECHORINI AS DATE) BETWEEN @FechaInicial AND @FechaFinal 
																																						 AND INF.CODSERIPS IN ('750101','750105')) LEFT JOIN
@TBLMedicamento FE ON GES.IPCODPACI=FE.IPCODPACI AND FE.TIPO=3
												 AND FE.ID=(SELECT MAX(MED.ID) FROM @TBLMedicamento MED WHERE FE.IPCODPACI=MED.IPCODPACI AND MED.TIPO=3) LEFT JOIN
@TBLMedicamento CAL ON GES.IPCODPACI=CAL.IPCODPACI AND CAL.TIPO=4
												   AND CAL.ID=(SELECT MAX(MED.ID) FROM @TBLMedicamento MED WHERE CAL.IPCODPACI=MED.IPCODPACI AND MED.TIPO=4)
LEFT JOIN INDIAGNOH DIA ON PAC.IPCODPACI=DIA.IPCODPACI AND DIA.CODDIAGNO='Z391'	AND CAST(DIA.FECDIAGNO AS DATE) BETWEEN  @FechaInicial AND @FechaFinal;
-----------------------------------------------------TABLA DE NOTAS ADMINISTRATIVAS---------------------------------------------------------

INSERT INTO @TBLNotasAdministrativas
SELECT
PAC.IPCODPACI,
CASE CAV.NOMBRE WHEN 'MAMOGRAFIAS' THEN '1' 
				WHEN 'RESULTADO DE CITOLOGIA' THEN '2' END AS VARIABLE,--MAMOGRAFIAS
NOAD.VALOR AS VALOR,--96 CONVERT(DATE,CONVERT(NCHAR(10),NOAD.VALOR),103) AS [96],
LIS.CODIGO, --97
PAC.EDAD,
PAC.[10],
NOAD.IDNTVARIABLE,
NOTA.ID
FROM
#TBLConsulta202 PAC INNER JOIN
NTNOTASADMINISTRATIVASC NOTA ON PAC.IPCODPACI=NOTA.IPCODPACI INNER JOIN
NTADMINISTRATIVAS CAV ON NOTA.IDNOTAADMINISTRATIVA=CAV.ID LEFT JOIN
NTNOTASADMINISTRATIVASD NOAD ON NOTA.ID=NOAD.IDNTNOTASADMINISTRATIVASC LEFT JOIN
NTVARIABLESL LIS ON NOAD.IDITEMLISTA=LIS.ID
WHERE CAV.NOMBRE IN ('MAMOGRAFIAS','RESULTADO DE CITOLOGIA') AND (NOTA.FECHACREACION BETWEEN @FechaInicial AND @FechaFinal);

----------------------------------------TABLA DE ANTECEDENTES----------------------------------------------------------------------
DECLARE @YEAR VARCHAR(4),@MES VARCHAR (2),@NOMTABLA VARCHAR(32),@I DATETIME,@sqlExa as nvarchar(2000),@TABLA VARCHAR(16)

SET @I=@FechaInicial
SET @YEAR=(YEAR(@I))
SET @MES=(MONTH(@I))

WHILE @I<@FechaFinal
BEGIN
	IF(@MES<=9)
		BEGIN
			SET @Mes = '0' + @Mes
		END

	SET @NOMTABLA=CONCAT('SELECT * FROM ANTVALORES',@YEAR+@MES);
	SET @TABLA=CONCAT('ANTVALORES',@YEAR+@MES);
	SET @sqlExa = @NOMTABLA

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DBO].'+@TABLA) AND type in (N'U'))
	BEGIN
		INSERT INTO @ANTVALORES EXEC sp_executesql @sqlExa
	END
	SET @I=@I+31
	SET @YEAR=(YEAR(@I))
	SET @MES=(MONTH(@I))
END


------------------------------------------------------------------------------------------------------
INSERT INTO @ANTECEDENTES
SELECT
HC.IPCODPACI,
VAL.IDHCHISPACA,
CASE ANT.VARIABLE WHEN 'índice paquetes/año' THEN 1
				  WHEN 'Índice de paquetes año (IPA)'THEN 2 END AS VARIABLE,
VAL.VALOR
FROM 
@ANTVALORES VAL INNER JOIN
ANTVARIABLES ANT ON VAL.IDANTVARIABLE=ANT.ID INNER JOIN
HCHISPACA HC ON VAL.IDHCHISPACA=HC.ID INNER JOIN
#TBLConsulta202 PAC ON HC.IPCODPACI=PAC.IPCODPACI
WHERE ANT.VARIABLE IN ('índice paquetes/año','Índice de paquetes año (IPA)') AND VAL.VALOR NOT LIKE '%[^0-9.,]%'
AND (VAL.VALOR NOT LIKE '%<%' AND VAL.VALOR NOT LIKE '%P%'
AND VAL.VALOR NOT LIKE '%>%' AND VAL.VALOR NOT LIKE '%-%' AND VAL.VALOR NOT LIKE '%R%' AND VAL.VALOR NOT LIKE '%D%' AND VAL.VALOR NOT LIKE '%C%'
AND VAL.VALOR NOT LIKE '%E%' AND VAL.VALOR NOT LIKE '%*%' AND VAL.VALOR NOT LIKE '%/%' 
AND VAL.VALOR NOT IN('NO','.','O','*',',','NA','n fuma','NO A','M','BNO','.15.25','YA NO FUNA','...','....'))
--------------------------------------RESULTADOS CARGADOS COMO PDF DE LOS PACIENTES-------------------------------------------------
INSERT INTO @TBLDocumentos
select 
IPCODPACI,
CASE CODSERIPS WHEN '851101' THEN 1 WHEN '851102' THEN 1 WHEN '851103' THEN 1 WHEN '851200' THEN 1 END AS VARIABLE,
CAST(FECPROCES AS DATE) AS FECHA
from HCDOCUMAD 
where CODSERIPS in ('851101','851102','851103','851200') AND FECPROCES BETWEEN @FechaInicial AND @FechaFinal

----------------------------------------FECHA MAMOGRAFIA-------------------------------------------------------------------
INSERT INTO @TBLFechaMamografia
SELECT 
F.IPCODPACI,F.FECHASERVICIO AS VALOR,F.EDAD,F.[10]
FROM @TBLFacturacion F WHERE VARIABLE=1 AND EDAD>=35 AND [10]='F' AND F.ID=(SELECT MAX(FAC.ID) FROM @TBLFacturacion FAC WHERE F.IPCODPACI=FAC.IPCODPACI AND FAC.VARIABLE=1)
UNION ALL
SELECT 
IPCODPACI,CONVERT(DATE,CONVERT(NCHAR(10),VALOR),103) AS VALOR,EDAD,[10]
FROM @TBLExaFisico WHERE VARIABLE=10 AND EDAD>=35 AND [10]='F'
UNION ALL
SELECT 
IPCODPACI,CONVERT(DATE,CONVERT(NCHAR(10),VALOR),103) AS VALOR,EDAD,[10]
FROM @TBLNotasAdministrativas WHERE VARIABLE=1 AND EDAD>=35 AND [10]='F' AND TIPO='70';

---------------------------------------------RESULTADO MAMOGRAFIA--------------------------------------------------------------------------------
INSERT INTO @TBLResultadosmamografia
SELECT 
IPCODPACI,
CASE VALOR WHEN '001' THEN 1 
		   WHEN '002' THEN 2 
		   WHEN '003' THEN 3
		   WHEN '004' THEN 4
		   WHEN '005' THEN 5 
		   WHEN '006' THEN 6
		   WHEN '007' THEN 7
		   WHEN '008' THEN 21
		   WHEN '009' THEN 21 END AS VALOR,
EDAD,
[10]
FROM @TBLExaFisico WHERE VARIABLE=39 AND EDAD>=35 AND [10]='F'
UNION ALL
SELECT 
IPCODPACI,
CASE VALOR WHEN '001' THEN 1 
		   WHEN '002' THEN 2 
		   WHEN '003' THEN 3
		   WHEN '004' THEN 4
		   WHEN '005' THEN 5 
		   WHEN '006' THEN 6
		   WHEN '007' THEN 7
		   WHEN '008' THEN 21
		   WHEN '009' THEN 21 END AS VALOR,
EDAD,
[10]
FROM @TBLNotasAdministrativas WHERE VARIABLE=1 AND TIPO=72 AND EDAD>=35 AND [10]='F';

----------------------------------FECHA TOMA BIOPSIA DE MAMA--------------------------------

INSERT INTO @TBLfechaBiopsias
SELECT F.IPCODPACI,F.FECHASERVICIO AS VALOR,F.EDAD,F.[10] 
FROM @TBLFacturacion F WHERE VARIABLE=2 AND EDAD>=35 AND [10]='F' AND F.ID=(SELECT MAX(A.ID) FROM @TBLFacturacion A WHERE F.IPCODPACI=A.IPCODPACI AND A.VARIABLE=2)
UNION ALL
SELECT IPCODPACI,CONVERT(DATE,CONVERT(NCHAR(10),VALOR),103) AS VALOR,EDAD,[10] FROM @TBLExaFisico WHERE VARIABLE=11 AND EDAD>=35 AND [10]='F';

----------------------------------RESULTADO DE LA BIOPSIA DE MAMA------------------------------------------------------------------------------

INSERT INTO @TBLResultadoBiopsiaMama
SELECT 
IPCODPACI,
CASE VALOR WHEN '001' THEN 1
		   WHEN '002' THEN 2
		   WHEN '003' THEN 3
		   WHEN '004' THEN 4
		   WHEN '005' THEN 5 ELSE '21' END AS VALOR
FROM @TBLExaFisico WHERE VARIABLE=34 AND EDAD>=35 AND [10]='F';

-------------------REPORTE DE CANCER DE MAMAS VARIABLES 96,97,99,100,101-----------------------------------------

INSERT INTO @TBLCaMama
SELECT 
ROW_NUMBER ( )   
OVER (PARTITION BY PAC.IPCODPACI  order by FEC.VALOR DESC) 'NUMERO',
PAC.IPCODPACI,
ISNULL(CONVERT(VARCHAR(10),FEC.VALOR,23),'1800-01-01') AS [96],
ISNULL(RES.VALOR,'21') AS [97],
ISNULL(CONVERT(VARCHAR(10),FEB.VALOR,23),'1800-01-01') AS [99],
ISNULL(CONVERT(VARCHAR(10),DOC.FECHA,23),'1800-01-01') AS [100],
ISNULL(BIO.VALOR,'21') AS [101]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLFechaMamografia FEC ON PAC.IPCODPACI=FEC.IPCODPACI LEFT JOIN
@TBLResultadosmamografia RES ON PAC.IPCODPACI=RES.IPCODPACI LEFT JOIN
@TBLfechaBiopsias FEB ON PAC.IPCODPACI=FEB.IPCODPACI LEFT JOIN
@TBLDocumentos DOC ON PAC.IPCODPACI=DOC.IPCODPACI AND DOC.VARIABLE=1 LEFT JOIN
@TBLResultadoBiopsiaMama BIO ON PAC.IPCODPACI=BIO.IPCODPACI
WHERE PAC.EDAD>=35 AND PAC.[10]='F'
UNION ALL
-------------------------POBLACION NO REPORTAR----------
SELECT
1 AS 'NUMERO',
PAC.IPCODPACI,
'1845-01-01' AS [96],
'0' AS [97],
'1845-01-01' AS [99],
'1845-01-01' AS [100],
'0' AS [101]
FROM #TBLConsulta202 PAC WHERE PAC.EDAD<=34 AND PAC.[10]='F'
UNION ALL
SELECT
1 AS 'NUMERO',
PAC.IPCODPACI,
'1845-01-01' AS [96],
'0' AS [97],
'1845-01-01' AS [99],
'1845-01-01' AS [100],
'0' AS [101]
FROM #TBLConsulta202 PAC WHERE PAC.[10]='M';
DELETE FROM @TBLCaMama WHERE NUMERO!=1;
/**********************************************************************************************************************************************************
--------------------------------------------------------INFORMACIÓN SOBRE TAMIZAJE VISUAL----------------------------------------
********************************************************************************************************************************************************/
INSERT INTO @TBLAgudezaVisual
SELECT 
PAC.IPCODPACI,
IIF(PAC.MESES=0,CASE OD.OPCION WHEN 1 THEN 5 WHEN 2 THEN 4 ELSE 21 END,
CASE WHEN OI.VALOR LIKE '%20/20%' THEN 3 WHEN OI.VALOR LIKE '%NORMAL%' THEN 3 WHEN OI.VALOR LIKE '20/10' THEN 3 WHEN OI.VALOR LIKE '20/13' THEN 3 
	 WHEN OI.VALOR LIKE '20/15' THEN 4 WHEN OI.VALOR LIKE '20/25' THEN 4 WHEN OI.VALOR LIKE '20/30' THEN 4 WHEN OI.VALOR LIKE '20/35' THEN 4 WHEN OI.VALOR LIKE '20/40' THEN 4 
	 WHEN OI.VALOR LIKE '20/100' THEN 5 WHEN OI.VALOR LIKE '20/140' THEN 5 WHEN OI.VALOR LIKE '20/200' THEN 5 WHEN OI.VALOR LIKE'20/50' THEN 5 WHEN OI.VALOR LIKE '20/70' THEN 5 
	 WHEN OI.VALOR LIKE '25/20' THEN 5 WHEN OI.VALOR LIKE '25/20' THEN 5 WHEN OI.VALOR LIKE '30/20' THEN 5 WHEN OI.VALOR LIKE '30/30' THEN 5 WHEN OI.VALOR LIKE '30/40' THEN 5 
	 WHEN OI.VALOR LIKE '30/50' THEN 5 WHEN OI.VALOR LIKE '30/70' THEN 5 WHEN OI.VALOR LIKE '40/20' THEN 5 WHEN OI.VALOR LIKE '40/30' THEN 5 WHEN OI.VALOR LIKE '40/40' THEN 5 
	 WHEN OI.VALOR LIKE '40/50' THEN 5 WHEN OI.VALOR LIKE '40/60' THEN 5 WHEN OI.VALOR LIKE '50/50' THEN 5 WHEN OI.VALOR LIKE '50/70' THEN 5 WHEN OI.VALOR LIKE '50/80' THEN 5 
	 WHEN OI.VALOR LIKE '70/100' THEN 5 WHEN OI.VALOR LIKE '70/70' THEN 5 WHEN OI.VALOR LIKE '70/80' THEN 5 WHEN OI.VALOR LIKE '80/80' THEN 5
	 ELSE 21 END) [27],
IIF(PAC.MESES=0,CASE OI.OPCION WHEN 1 THEN 5 WHEN 2 THEN 4 ELSE 21 END,
CASE WHEN OD.VALOR LIKE '%20/20%' THEN 3 WHEN OD.VALOR LIKE '%NORMAL%' THEN 3 WHEN OD.VALOR LIKE '20/10' THEN 3 WHEN OD.VALOR LIKE '20/13' THEN 3 
	 WHEN OD.VALOR LIKE '20/15' THEN 4 WHEN OD.VALOR LIKE '20/25' THEN 4 WHEN OD.VALOR LIKE '20/30' THEN 4 WHEN OD.VALOR LIKE '20/35' THEN 4 WHEN OD.VALOR LIKE '20/40' THEN 4 
	 WHEN OD.VALOR LIKE '20/100' THEN 5 WHEN OD.VALOR LIKE '20/140' THEN 5 WHEN OD.VALOR LIKE '20/200' THEN 5 WHEN OD.VALOR LIKE'20/50' THEN 5 WHEN OD.VALOR LIKE '20/70' THEN 5 
	 WHEN OD.VALOR LIKE '25/20' THEN 5 WHEN OD.VALOR LIKE '25/20' THEN 5 WHEN OD.VALOR LIKE '30/20' THEN 5 WHEN OD.VALOR LIKE '30/30' THEN 5 WHEN OD.VALOR LIKE '30/40' THEN 5 
	 WHEN OD.VALOR LIKE '30/50' THEN 5 WHEN OD.VALOR LIKE '30/70' THEN 5 WHEN OD.VALOR LIKE '40/20' THEN 5 WHEN OD.VALOR LIKE '40/30' THEN 5 WHEN OD.VALOR LIKE '40/40' THEN 5 
	 WHEN OD.VALOR LIKE '40/50' THEN 5 WHEN OD.VALOR LIKE '40/60' THEN 5 WHEN OD.VALOR LIKE '50/50' THEN 5 WHEN OD.VALOR LIKE '50/70' THEN 5 WHEN OD.VALOR LIKE '50/80' THEN 5 
	 WHEN OD.VALOR LIKE '70/100' THEN 5 WHEN OD.VALOR LIKE '70/70' THEN 5 WHEN OD.VALOR LIKE '70/80' THEN 5 WHEN OD.VALOR LIKE '80/80' THEN 5
	 ELSE 21 END) [28],
IIF(OI.FECHA IS NULL,IIF(OD.FECHA IS NULL,'1800-01-01',CONVERT(VARCHAR(10),OD.FECHA,23)),CONVERT(VARCHAR(10),OI.FECHA,23))AS [62]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLExaFisico OD ON PAC.IPCODPACI=OD.IPCODPACI AND OD.VARIABLE=20 AND OD.NUMEFOLIO=(SELECT MAX(F.NUMEFOLIO) FROM @TBLExaFisico F WHERE PAC.IPCODPACI=F.IPCODPACI AND F.VARIABLE=20) LEFT JOIN
@TBLExaFisico OI ON PAC.IPCODPACI=OI.IPCODPACI AND OI.VARIABLE=23 AND OI.NUMEFOLIO=(SELECT MAX(F.NUMEFOLIO) FROM @TBLExaFisico F WHERE PAC.IPCODPACI=F.IPCODPACI AND F.VARIABLE=23);

-------------------------------------ANTICONCEPTIVOS VARIABLES 53,54,55----------------------------------------------------------------------------

INSERT INTO @TBLAnticonceptivo
SELECT
PAC.IPCODPACI,
IIF(PAC.EDAD BETWEEN 10 AND 60,ISNULL(CONVERT(VARCHAR(10),HC.FECHISPAC,23),'1800-01-01'),'1845-01-01') AS [53],
IIF(PAC.EDAD BETWEEN 10 AND 60,ISNULL(CASE MED.TIPO WHEN 5 THEN 15 WHEN 7 THEN 2 WHEN 8 THEN 7  ELSE 21 END,ISNULL(13,ISNULL(3,21))),0) AS [54],
IIF(PAC.EDAD BETWEEN 10 AND 60,ISNULL(CONVERT(VARCHAR(10),MED.FECINIDOS,23),ISNULL(CONVERT(VARCHAR(10),FACA.FECHASERVICIO,23),ISNULL(CONVERT(VARCHAR(10),FACB.FECHASERVICIO,23),'1800-01-01'))),'1845-01-01') AS [55]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLMedicamento MED ON PAC.IPCODPACI=MED.IPCODPACI AND MED.TIPO IN (5,7,8,9,10)
												   AND MED.ID=(SELECT TOP 1 ID FROM @TBLMedicamento ME WHERE MED.IPCODPACI=ME.IPCODPACI AND ME.TIPO IN (5,7,8)) LEFT JOIN
DBO.HCHISPACA HC ON PAC.IPCODPACI=HC.IPCODPACI AND HC.NUMEFOLIO=(SELECT MAX(H.NUMEFOLIO) FROM DBO.HCHISPACA H WHERE HC.IPCODPACI=H.IPCODPACI AND H.IDMODELOHC=30 AND H.FECHISPAC BETWEEN @FechaInicial AND @FechaFinal) LEFT JOIN
@TBLFacturacion FACA ON PAC.IPCODPACI=FACA.IPCODPACI AND FACA.VARIABLE=7 AND FACA.ID=(SELECT MAX(A.ID) FROM @TBLFacturacion A WHERE FACA.IPCODPACI=A.IPCODPACI AND VARIABLE=7) LEFT JOIN
@TBLFacturacion FACB ON PAC.IPCODPACI=FACB.IPCODPACI AND FACB.VARIABLE=6 AND FACB.ID=(SELECT MAX(A.ID) FROM @TBLFacturacion A WHERE FACB.IPCODPACI=A.IPCODPACI AND VARIABLE=6)

/*************************************************************************************************
--------------------------GRUPO CANCER DE CERVIX-------------------------------------------------
*************************************************************************************************/
-----------------------------FECHA DE COLPOSCOPIA----------------------------------------
INSERT INTO @TBLFechaColposcopia
SELECT 
FAC.IPCODPACI,
CONVERT(VARCHAR(10),FAC.FECHASERVICIO,23) AS [91]
FROM @TBLFacturacion FAC WHERE VARIABLE=5
UNION ALL
SELECT 
FIS.IPCODPACI,
CONVERT(VARCHAR(10),FIS.VALOR,23) AS [91]
FROM @TBLExaFisico FIS WHERE VARIABLE=44
UNION ALL
SELECT
CX.IPCODPACI,
CONVERT(VARCHAR(10),CX.FECHORINI,23) AS [91]
FROM  
dbo.HCQXINFOR CX INNER JOIN
Contract.CUPSEntity CUP ON CX.CODSERIPS=CUP.Code AND CUP.Description LIKE '%COLPOSCOPIA%' AND CX.FECHORINI BETWEEN @FechaInicial AND @FechaFinal;


---------------------------------CANCER DE CERVIX VARIABLES 47,86,87,91,93,94------------------------------------

INSERT INTO @TBLCancerCervix
SELECT 
PAC.IPCODPACI,
IIF(PAC.EDAD<=10 OR PAC.[10]='M',0,IIF(FAC1.VARIABLE IS NULL,0,6)) AS [47],--21 saco error y el 10 tambien
IIF(PAC.EDAD<=10 OR PAC.[10]='M','0'
								,IIF(NA1.VARIABLE IS NULL,IIF(FAC2.VARIABLE IS NULL,'21'
																				   ,CASE FAC2.CODE WHEN '892901' THEN '1' 
																								  WHEN '898001' THEN '1' 
																								  WHEN '908436' THEN '2' 
																								  WHEN '892904' THEN '3' END)
														,'1')) AS [86],
IIF(PAC.EDAD<=10 OR PAC.[10]='M','1845-01-01'
								,IIF(NA1.VALOR IS NULL,IIF(FAC2.FECHASERVICIO IS NULL,'1800-01-01'
																					 ,CONVERT(VARCHAR(10),FAC2.FECHASERVICIO,23))
													  ,CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),NA1.VALOR),103),23))) AS [87],
IIF(PAC.EDAD<=10 OR PAC.[10]='M','0',IIF(NA2.VALOR IS NULL,IIF(NA4.VALOR IS NULL,'21',CASE NA4.CODIGO WHEN '001' THEN 10
																									  WHEN '002' THEN 8
																									  WHEN '003' THEN 9
																									  WHEN '004' THEN 10
																									  WHEN '005' THEN 11
																									  WHEN '006' THEN 12
																									  WHEN '007' THEN 13
																									  WHEN '008' THEN 14
																									  WHEN '009' THEN 15
																									  WHEN '010' THEN 16
																									  WHEN '011' THEN 17
																									  WHEN '012' THEN 18 END
																									  ),CASE WHEN NA2.CODIGO='001' THEN 1
																	 WHEN NA2.CODIGO='002' THEN 2
																	 WHEN NA2.CODIGO='003' THEN 3
																	 WHEN NA2.CODIGO='004' THEN 4
																	 WHEN NA2.CODIGO='005' THEN 5
																	 WHEN NA2.CODIGO='006' THEN 6 END)) AS [88],
IIF(PAC.EDAD<=10 OR PAC.[10]='M','0'
								,IIF(NA3.CODIGO IS NULL,'999'
													   ,CASE WHEN NA3.CODIGO='001' THEN 1
															 WHEN NA3.CODIGO='002' THEN 2
															 WHEN NA3.CODIGO='003' THEN 3
															 WHEN NA3.CODIGO='004' THEN 4 END)) AS [89],
IIF(PAC.EDAD<=10 OR PAC.[10]='M','0',IIF(NA1.VARIABLE IS NULL,IIF(FAC2.VARIABLE IS NULL,'999',CONVERT(BIGINT,PAC.[2])),CONVERT(BIGINT,PAC.[2]))) AS [90],
IIF(PAC.EDAD<=10 OR PAC.[10]='M','1845-01-01',IIF(FECC.[91] IS NULL,'1800-01-01',FECC.[91])) AS [91],
IIF(PAC.EDAD<=10 OR PAC.[10]='M','1845-01-01','1800-01-01') AS [93],
IIF(PAC.EDAD<=10 OR PAC.[10]='M',0,21) AS [94]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLFacturacion FAC1 ON PAC.IPCODPACI=FAC1.IPCODPACI AND FAC1.VARIABLE=3
													 AND FAC1.ID=(SELECT MAX(FAC.ID) FROM @TBLFacturacion FAC WHERE FAC1.IPCODPACI=FAC.IPCODPACI AND FAC.VARIABLE=3) LEFT JOIN
@TBLNotasAdministrativas AS NA1 ON PAC.IPCODPACI=NA1.IPCODPACI AND NA1.VARIABLE=2 
															   AND NA1.ID=(SELECT MAX(N.ID) FROM @TBLNotasAdministrativas N WHERE NA1.IPCODPACI=N.IPCODPACI AND N.VARIABLE=2)
															   AND NA1.TIPO=(SELECT TOP 1 ID FROM NTVARIABLES WHERE VARIABLE LIKE '%Fecha de resultado de citologia actual%') LEFT JOIN
@TBLNotasAdministrativas AS NA2 ON PAC.IPCODPACI=NA2.IPCODPACI AND NA2.VARIABLE=2 
															   AND NA2.ID=(SELECT MAX(N.ID) FROM @TBLNotasAdministrativas N WHERE NA2.IPCODPACI=N.IPCODPACI AND N.VARIABLE=2)
															   AND NA2.TIPO=(SELECT TOP 1 ID FROM NTVARIABLES WHERE VARIABLE LIKE '%Hallazgos en celulas escamosas%') LEFT JOIN
@TBLNotasAdministrativas AS NA3 ON PAC.IPCODPACI=NA3.IPCODPACI AND NA3.VARIABLE=2 
															   AND NA3.ID=(SELECT MAX(N.ID) FROM @TBLNotasAdministrativas N WHERE NA3.IPCODPACI=N.IPCODPACI AND N.VARIABLE=2)
															   AND NA3.TIPO=(SELECT TOP 1 ID FROM NTVARIABLES WHERE VARIABLE LIKE '%Calidad de la muestra%') LEFT JOIN

@TBLNotasAdministrativas AS NA4 ON PAC.IPCODPACI=NA4.IPCODPACI AND NA4.VARIABLE=2 
															   AND NA4.ID=(SELECT MAX(N.ID) FROM @TBLNotasAdministrativas N WHERE NA4.IPCODPACI=N.IPCODPACI AND N.VARIABLE=2)
															   AND NA4.TIPO=(SELECT TOP 1 ID FROM NTVARIABLES WHERE VARIABLE LIKE '%Hallazgos en celulas glandulares%') LEFT JOIN

@TBLFacturacion FAC2 ON PAC.IPCODPACI=FAC2.IPCODPACI AND FAC2.VARIABLE=4
													 AND FAC2.ID=(SELECT MAX(FAC.ID) FROM @TBLFacturacion FAC WHERE FAC2.IPCODPACI=FAC.IPCODPACI AND FAC.VARIABLE=4)LEFT JOIN
@TBLFechaColposcopia FECC ON PAC.IPCODPACI=FECC.IPCODPACI AND FECC.[91]=(SELECT MAX(A.[91]) FROM @TBLFechaColposcopia A WHERE FECC.IPCODPACI=A.IPCODPACI);


/******************************************************************************
------------------------CANCER DE COLONos----------------------------------------DESDE CANCER DE COLON FUNCIONA UNICAMENTE PARA COHAN
******************************************************************************/
-----------------------VARIABLES 24,36,66,67
INSERT INTO @TBLCancerColon
SELECT 
PAC.IPCODPACI,
IIF(PAC.EDAD BETWEEN 50 AND 75,IIF(FIS1.VALOR IS NULL,21,CASE FIS1.VALOR WHEN '001' THEN 4
																		 WHEN '002' THEN 5
																		 WHEN '003' THEN 6
																		 WHEN '004' THEN 21
																		 WHEN '005' THEN 21 END),0) AS [24],
IIF(PAC.EDAD BETWEEN 50 AND 75,IIF(FIS2.VALOR IS NULL OR (FIS1.VALOR='004' OR FIS1.VALOR='005'),IIF(OT.RESULCOLONOSCOPIA IS NULL,21,OT.RESULCOLONOSCOPIA),
																								  CASE FIS2.VALOR WHEN '001' THEN 2
																												  WHEN '002' THEN 3
																												  WHEN '003' THEN 4
																												  WHEN '004' THEN 5
																												  WHEN '005' THEN 6 END)
							 ,0) AS [36],
IIF(PAC.EDAD>=50,IIF(FIS3.VALOR IS NULL,IIF(OT.FECHAREGISTRO IS NULL,'1800-01-01',CONVERT(VARCHAR(10),OT.FECHAREGISTRO,23)),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FIS3.VALOR),103),23))
							  ,'1845-01-01') AS [66],
IIF(PAC.EDAD BETWEEN 50 AND 75,IIF(FIS4.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FIS4.VALOR),103),23))
							  ,'1845-01-01') AS [67]
	
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLExaFisico FIS1 ON PAC.IPCODPACI=FIS1.IPCODPACI AND FIS1.VARIABLE=19 AND FIS1.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE PAC.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=19) LEFT JOIN
@TBLExaFisico FIS2 ON PAC.IPCODPACI=FIS2.IPCODPACI AND FIS2.VARIABLE=24 AND FIS2.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE PAC.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=24) LEFT JOIN 
@TBLExaFisico FIS3 ON PAC.IPCODPACI=FIS3.IPCODPACI AND FIS3.VARIABLE=3 AND FIS3.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE PAC.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=3)LEFT JOIN
@TBLExaFisico FIS4 ON PAC.IPCODPACI=FIS4.IPCODPACI AND FIS4.VARIABLE=2 AND FIS4.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE PAC.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=2) LEFT JOIN
DBO.HCPLAOTRPROC OT ON PAC.IPCODPACI=OT.IPCODPACI AND OT.RESULCOLONOSCOPIA IS NOT NULL AND CAST(OT.FECHAREGISTRO AS DATE) BETWEEN @FechaInicial AND @FechaFinal

/********************************************************************************************************************************************/
------------------------------------------------LABORATORIOS------------------------------------------------------------------------
/****************************************************************************************************************************************/

INSERT INTO @TBLLaboratorio
select 
A.IPCODPACI,
A.FECRECMUE,
VAL.VALOR,
VAL.ANALITO,
VAL.[AUTO],
CASE A.CODSERIPS WHEN '904902' THEN 1 WHEN '904904' THEN 1 --TCH
				 WHEN '903841' THEN 2 --GLICEMIA
				 WHEN '903817' THEN 3 WHEN '903816' THEN 3--LDL
				 WHEN '903815' THEN 4 --HDL
				 WHEN '903868' THEN 5 --TRIGLICERIDOS
				 WHEN '902113' THEN 6 WHEN '902207' THEN 6 WHEN '902208' THEN 6 WHEN '902209'THEN 6 WHEN '902210' THEN 6 
				 WHEN '902213' THEN 6 WHEN '903426'THEN 6 WHEN '903427' THEN 6--HEMOGLOBINA
				 WHEN '903895' THEN 7 --CREATININA
				 WHEN '906225' THEN 8 WHEN '906263'THEN 8 --HEPATITIS C
				 WHEN '906915' THEN 9 WHEN '906039' THEN 9 --SIFILIS
				 WHEN '906249' THEN 10 --VIH
				 WHEN '901101' THEN 11 WHEN '901111' THEN 11--TUBERCULOSIS
				 WHEN '906317' THEN 12 --HEPATITIS B
				 WHEN '906610' THEN 13 WHEN '906611' THEN 13 WHEN '906612' THEN 13 --PSA DE PROSTATA
END AS VARIABLE
from 
#TBLConsulta202 PAC INNER JOIN
dbo.AMBORDLAB A ON PAC.IPCODPACI=A.IPCODPACI AND A.FECRECMUE BETWEEN @FechaInicial AND @FechaFinal INNER JOIN
INTERLABD VAL ON A.AUTO=VAL.AUTOLABOR
WHERE A.CODSERIPS IN('904902','904904','903841','903817','903816','903815','903868','902113','902207','902208','902209','902210',
'902213','903426','903427','903895','906225','906263','906915','906039','906249','901101','901111','906317','906610','906611','906612') AND A.ESTSERIPS!=6
UNION ALL
select
A.IPCODPACI,
A.FECRECMUE,
VAL.VALOR,
VAL.ANALITO,
VAL.[AUTO],
CASE A.CODSERIPS WHEN '904902' THEN 1 WHEN '904904' THEN 1 --TSH
				 WHEN '903841' THEN 2 --GLICEMIA
				 WHEN '903817' THEN 3 WHEN '903816' THEN 3--LDL
				 WHEN '903815' THEN 4 --HDL
				 WHEN '903868' THEN 5 --TRIGLICERIDOS
				 WHEN '902113' THEN 6 WHEN '902207' THEN 6 WHEN '902208' THEN 6 WHEN '902209'THEN 6 WHEN '902210' THEN 6 
				 WHEN '902213' THEN 6 WHEN '903426' THEN 6 WHEN '903427' THEN 6--HEMOGLOBINA
				 WHEN '903895' THEN 7 --CREATININA
				 WHEN '906225' THEN 8 WHEN '906263' THEN 8 --HEPATITIS C
				 WHEN '906915' THEN 9 WHEN '906039' THEN 9 --SIFILIS
				 WHEN '906249' THEN 10 --VIH
				 WHEN '901101' THEN 11 WHEN '901111' THEN 11--TUBERCULOSIS
				 WHEN '906317' THEN 12 --HEPATITIS B
				 WHEN '906610' THEN 13 WHEN '906611' THEN 13 WHEN '906612' THEN 13 --PSA DE PROSTATA
END AS VARIABLE
from 
#TBLConsulta202 PAC INNER JOIN
dbo.HCORDLABO A ON PAC.IPCODPACI=A.IPCODPACI AND A.FECRECMUE BETWEEN @FechaInicial AND @FechaFinal INNER JOIN
INTERLABD VAL ON A.AUTO=VAL.AUTOLABOR
WHERE A.CODSERIPS IN('904902','904904','903841','903817','903816','903815','903868','902113','902207','902208','902209','902210',
'902213','903426','903427','903895','906225','906263','906915','906039','906249','901101','901111','906317','906610','906611','906612') AND A.ESTSERIPS!=6;
/*************************************************************************
-------------------------CANCER DE PROSTATA------------------------------
*************************************************************************/
--------------PROSTATA VARIABLES 22,64,73,109----------------------------
INSERT INTO @TBLCancerProstata
SELECT 
PAC.IPCODPACI,
IIF(FIS.VALOR IS NULL
	,IIF(PAC.[10]='F'OR PAC.EDAD<=39,0,21)
	,CASE WHEN FIS.VALOR LIKE '%NORMAL%' THEN 5 
		  WHEN FIS.VALOR LIKE '%sin alteraciones%' THEN 5  
		  WHEN FIS.VALOR LIKE '%sin alteracion%' THEN 5  
		  WHEN FIS.VALOR LIKE '%NO%AUMENTO%TAMAÑO' THEN 5 
		  WHEN FIS.VALOR LIKE '%NO%AUMENTADA%TAMAÑO' THEN 5	
		  WHEN FIS.VALOR LIKE '%SIN%AUMENTO%TAMAÑO%' THEN 5
		  WHEN FIS.VALOR LIKE '%ANORMAL%' THEN 4
		  WHEN FIS.VALOR LIKE '%AUMENTO%TAMAÑO%' THEN 4 
		  WHEN FIS.VALOR LIKE '%AUMENTADA%TAMAÑO%' THEN 4 
		  WHEN FIS.VALOR LIKE '%Hiperplasia%prostatica%' THEN 4 ELSE 21 END) AS [22],
IIF(FIS.FECHA IS NULL,IIF(PAC.[10]='F'OR PAC.EDAD<=39,'1845-01-01','1800-01-01'),CONVERT(VARCHAR(10),FIS.FECHA,23)) AS [64],
IIF(FAC.FECHASERVICIO IS NULL,IIF(PAC.[10]='F'OR PAC.EDAD<=39,'1845-01-01','1800-01-01'),CONVERT(VARCHAR(10),FAC.FECHASERVICIO,23))AS [73],
IIF(PAC.EDAD<40 OR PAC.[10]='F','0',IIF(LAB.IPCODPACI IS NULL,'998',CONVERT(VARCHAR(3),LAB.VALOR))) AS [109]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLExaFisico FIS ON PAC.IPCODPACI=FIS.IPCODPACI AND VARIABLE=40 
												 AND FIS.FECHA=(SELECT MAX(FI.FECHA) FROM @TBLExaFisico FI WHERE FIS.IPCODPACI=FI.IPCODPACI AND FI.VARIABLE=40) LEFT JOIN
@TBLFacturacion FAC ON PAC.IPCODPACI=FAC.IPCODPACI AND FAC.VARIABLE=8 AND FAC.ID=(SELECT MAX(A.ID) FROM @TBLFacturacion A WHERE FAC.IPCODPACI=A.IPCODPACI AND A.VARIABLE=8) LEFT JOIN
@TBLLaboratorio LAB ON PAC.IPCODPACI=LAB.IPCODPACI AND LAB.VARIABLE=13
												  

/*************************************************************************
-------------------------ODONTOLOGÍA O SALUD BUCAL------------------------------
*************************************************************************/
INSERT INTO @TBLACalculoCOP
--SELECT
--PAC.IPCODPACI ,
--DET.CEO_C,DET.CEO_O,DET.CEO_E,
--DET.CPO_C,DET.CPO_O,DET.CPO_P,
--CON.FECHAREG,
--CON.NUMEFOLIO,
--DIENTES.NUMERO
--FROM 
--#TBLConsulta202 PAC 
--INNER JOIN ODONTOCONTROL CON ON PAC.IPCODPACI=CON.IPCODPACI AND CON.NUMEFOLIO=
--	(SELECT MAX(CO.NUMEFOLIO) FROM ODONTOCONTROL CO  INNER JOIN ODONTOCONTROLVALO DE ON CON.IPCODPACI=CO.IPCODPACI AND CO.ID=DE.IDODONTOCONTROL AND (CAST(CO.FECHAREG AS DATE) BETWEEN @FechaInicial AND @FechaFinal) ) --INNER JOIN PARA SOLO TENER EN CUENTA LAS VALORACIONES, LEFT JOIN PARA TENER ENCUENTA TODAS LAS CONSULTAS YA SEA POR ODONTOLOGIA O POR SALUD BUCAL.
--INNER JOIN ODONTOCONTROLVALO DET ON CON.ID=DET.IDODONTOCONTROL
--INNER JOIN (SELECT 
--			DIE.IDODONTOCONTROL,
--			COUNT(TRATA.IDODONTODIENTE) AS NUMERO
--			FROM 
--			dbo.ODONTODIENTE DIE
--			LEFT JOIN (SELECT IDODONTODIENTE FROM(SELECT IDODONTODIENTE FROM dbo.ODONTODIENTETRATA WHERE CONSECTRA!=51
--					   UNION ALL
--					   SELECT IDODONTODIENTE FROM dbo.ODONTODIENTEDIAG
--					   ) TRATA GROUP BY IDODONTODIENTE) TRATA ON DIE.ID=TRATA.IDODONTODIENTE GROUP BY DIE.IDODONTOCONTROL
--			) DIENTES ON CON.ID=DIENTES.IDODONTOCONTROL;
SELECT
ODC.IPCODPACI,
ODC.ID,
 RIGHT('00'+RTRIM(CAST(SUM(OD.NUMERO)-COP.CPO_P-COP.CEO_C-((COP.CPO_C+COP.CEO_C+COP.CPO_O+COP.CEO_O))AS CHAR(2))),2)+'00'+
 RIGHT('00'+RTRIM(CAST(COP.CPO_C+COP.CEO_C AS CHAR(2))),2)+
 RIGHT('00'+RTRIM(CAST(COP.CPO_O+COP.CEO_O AS CHAR(2))),2)+
 RIGHT('00'+RTRIM(CAST(COP.CPO_P+COP.CEO_E AS CHAR(2))),2)+
 RIGHT('00'+RTRIM(CAST(SUM(OD.NUMERO) AS CHAR(2))),2) AS COP,
 CAST(ODC.FECHAREG AS DATE) AS FECHAREG
FROM
#TBLConsulta202 PAC
INNER JOIN dbo.ODONTOCONTROL ODC ON PAC.IPCODPACI=ODC.IPCODPACI
INNER JOIN(SELECT DISTINCT A.IDODONTOCONTROL, A.DIENTE, 1 AS NUMERO 
		   FROM dbo.ODONTODIENTE A
		   INNER JOIN dbo.ODONTODIENTETRATA B ON A.ID=B.IDODONTODIENTE AND B.CONSECTRA!=51
		   UNION 
		   SELECT DISTINCT A.IDODONTOCONTROL, A.DIENTE, 1 AS NUMERO 
		   FROM dbo.ODONTODIENTE A
		   INNER JOIN dbo.ODONTODIENTEDIAG B ON A.ID=B.IDODONTODIENTE) OD ON ODC.ID=IDODONTOCONTROL
INNER JOIN dbo.ODONTOCONTROLVALO COP ON ODC.ID=COP.IDODONTOCONTROL
WHERE CAST(FECHAREG AS DATE) BETWEEN @FechaInicial AND @FechaFinal
GROUP BY ODC.IPCODPACI,ODC.ID,COP.CEO_C,COP.CEO_E,COP.CEO_O,COP.CPO_C,COP.CPO_P,CPO_O,CAST(ODC.FECHAREG AS DATE)
--------------COP 76,102----------------------------
INSERT INTO @TBLCOP
SELECT
PAC.IPCODPACI,
IIF(PAC.MESES<6,'1845-01-01',IIF(COP.FECHAREG IS NULL,'1800-01-01',CONVERT(VARCHAR(10),COP.FECHAREG,23))) AS [76],
IIF(PAC.MESES<6,'0'
			   ,IIF(COP.ID IS NULL,'21'
								  ,COP.COP 
					) 
	) AS [102]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLACalculoCOP COP ON PAC.IPCODPACI=COP.IPCODPACI AND COP.FECHAREG=(SELECT MAX(CO.FECHAREG) FROM @TBLACalculoCOP CO WHERE PAC.IPCODPACI=CO.IPCODPACI);

/*************************************************************************
-------------------------PRIMERA INFANCIA------------------------------
*************************************************************************/
-------------------------VARIABLES 71,77-------------------------------
INSERT INTO @TBLPrimeraInfancia
SELECT 
PAC.IPCODPACI,
IIF(PAC.MESES BETWEEN 24 AND 59,IIF(MED1.FECINIDOS IS NULL,21,1),0) AS [71],
IIF(PAC.MESES BETWEEN 24 AND 59,IIF(MED2.FECINIDOS IS NULL,21,1),0) AS [77]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLMedicamento MED1 ON PAC.IPCODPACI=MED1.IPCODPACI AND MED1.TIPO=6 LEFT JOIN
@TBLMedicamento MED2 ON PAC.IPCODPACI=MED2.IPCODPACI AND MED2.TIPO=3
													 AND MED2.ID=(SELECT MAX(MED.ID) FROM @TBLMedicamento MED WHERE MED2.IPCODPACI=MED.IPCODPACI AND MED.TIPO=3);

/************************GRUPO DE RECIEN NACIDOS***********************************
-------------------------VARIABLES 48,65-------------------------------
***********************************************************************************/
INSERT INTO @TBLRNacido
SELECT 
PAC.IPCODPACI,
IIF(DATEDIFF(DAY,PAC.[9],FAUD.FECHA)<=7,IIF(FAUD.IPCODPACI IS NULL,21,CASE FAUD.VALOR WHEN 'PASO' THEN 5
															   WHEN 'NO PASO' THEN 4
															   WHEN 'PASÓ' THEN 5
															   WHEN 'NO PASÓ' THEN 5 
															   WHEN 'No aplica' THEN 21
															   WHEN 'No evaluado' THEN 21 ELSE 21 END),0) AS [37],
IIF(DATEDIFF(DAY,PAC.[9],FVIS.FECHA)<=7,IIF(FVIS.IPCODPACI IS NULL,21,CASE WHEN FVIS.VALOR LIKE '%NORMAL%' THEN 5
													WHEN FVIS.VALOR LIKE '%ANORMAL%' THEN 4
													WHEN FVIS.VALOR ='Isocoria normoreactiva, no fondo de ojo' THEN 5
													WHEN FVIS.VALOR LIKE '%SIN LESIONES%' THEN 5 ELSE 21 END),0) AS [38],
IIF(DATEDIFF(DAY,PAC.[9],FIS.FECREGITE)<=7,IIF(FIS.REGSO2PAC IS NULL,21
										  ,CASE WHEN FIS.REGSO2PAC<=94 THEN 4 ELSE 5 END)
			  ,0) AS [48],
IIF(DATEDIFF(DAY,PAC.[9],FIS.FECREGITE)<=7
	,IIF(FIS.FECREGITE IS NULL,'1800-01-01',CONVERT(VARCHAR(10),FIS.FECREGITE,23))
	,'1845-01-01') AS [65],
IIF(DATEDIFF(DAY,PAC.[9],LAB.FECORDMED)<=7 OR DATEDIFF(DAY,PAC.[9],FTSH.FECHA)<=7,IIF(LAB.FECORDMED IS NULL,IIF(FTSH.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FTSH.VALOR),103),23))
										 ,CONVERT(VARCHAR(10),LAB.FECORDMED,23))
			   ,'1845-01-01') AS [84],
IIF(DATEDIFF(DAY,PAC.[9],LAB.FECORDMED)<=7 OR DATEDIFF(DAY,PAC.[9],TSH.FECHA)<=7,IIF(LAB.VALOR IS NULL,IIF(TSH.VALOR IS NULL,21,CASE CONVERT(NCHAR(1),REPLACE(TSH.VALOR,',','')) WHEN 1 THEN 5
																												 WHEN 2 THEN 4
																												 WHEN 3 THEN 21 END)
									  ,IIF(LAB.VALOR LIKE '%VE%',21
															    ,CASE WHEN CAST(REPLACE(LAB.VALOR,'.','') AS NCHAR(2)) BETWEEN 17 AND 91 THEN 5 ELSE 4 END))
			   ,0) AS [85]
FROM 
#TBLConsulta202 PAC LEFT JOIN
DBO.HCEXFISIC FIS ON PAC.IPCODPACI=FIS.IPCODPACI AND FIS.NUMEFOLIO=(SELECT MIN(CAST(FI.NUMEFOLIO AS INT)) FROM DBO.HCEXFISIC FI WHERE FIS.IPCODPACI=FI.IPCODPACI AND FI.IDETIPHIS='HCURGING1' AND FI.FECREGITE BETWEEN @FechaInicial AND @FechaFinal) LEFT JOIN
@TBLLaboratorio LAB ON PAC.IPCODPACI=LAB.IPCODPACI AND LAB.ANALITO LIKE '%TSH%' 
												   AND LAB.VARIABLE=1
												   AND LAB.FECORDMED=(SELECT MIN(CAST(LA.FECORDMED AS INT)) FROM @TBLLaboratorio LA WHERE LAB.IPCODPACI=LA.IPCODPACI) LEFT JOIN
@TBLExaFisico TSH ON PAC.IPCODPACI=TSH.IPCODPACI AND TSH.VARIABLE=31
												 AND TSH.NUMEFOLIO=(SELECT MIN(CAST(TS.NUMEFOLIO AS INT)) FROM @TBLExaFisico TS WHERE PAC.IPCODPACI=TS.IPCODPACI AND TSH.VARIABLE=31) LEFT JOIN
@TBLExaFisico FTSH ON PAC.IPCODPACI=FTSH.IPCODPACI AND FTSH.VARIABLE=9
												   AND FTSH.NUMEFOLIO=(SELECT MIN(CAST(TS.NUMEFOLIO AS INT)) FROM @TBLExaFisico TS WHERE PAC.IPCODPACI=TS.IPCODPACI AND TS.VARIABLE=9) LEFT JOIN
@TBLExaFisico FAUD ON PAC.IPCODPACI=FAUD.IPCODPACI AND FAUD.VARIABLE=51
												   AND FAUD.NUMEFOLIO=(SELECT MIN(CAST(TS.NUMEFOLIO AS INT)) FROM @TBLExaFisico TS WHERE PAC.IPCODPACI=TS.IPCODPACI AND TS.VARIABLE=51) LEFT JOIN
@TBLExaFisico FVIS ON PAC.IPCODPACI=FVIS.IPCODPACI AND FVIS.VARIABLE=50
												   AND FVIS.NUMEFOLIO=(SELECT MIN(CAST(TS.NUMEFOLIO AS INT)) FROM @TBLExaFisico TS WHERE PAC.IPCODPACI=TS.IPCODPACI AND TS.VARIABLE=50);

/*********************************************************************************************************
---------------------------------------------RIESGO CARDIO VASCULAR--------------------------------------
*********************************************************************************************************/

------------------------------VARIABLES 57,72,92,95,98,103,104,105,106,107,111,117,118-------------------
INSERT INTO @TBLARiesgoCardio
SELECT
PAC.IPCODPACI,
IIF(PAC.EDAD<=18,0
				,IIF(LGL.VALOR IS NULL,IIF(FGL.VALOR IS NULL,998,IIF(ROUND(REPLACE(FGL.VALOR,',','.'),0)>=997,997, ROUND(REPLACE(FGL.VALOR,',','.'),0)))
									  ,IIF(LGL.VALOR LIKE '%[A-Z]%' OR LGL.VALOR LIKE '%<%',998,IIF(ROUND(LGL.VALOR,0)>=997,997,ROUND(LGL.VALOR,0))))
	) AS [57],
IIF(PAC.EDAD<=18,'1845-01-01'
			   ,IIF(LDL.VALOR IS NULL,IIF(FFDL.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FFDL.VALOR),103),23))
									 ,CONVERT(VARCHAR(10),LDL.FECORDMED,23))
	) AS [72], 
IIF(PAC.EDAD<=18,0
				,IIF(LDL.VALOR IS NULL,IIF(FDL.VALOR IS NULL,998,ROUND(REPLACE(FDL.VALOR,',','.'),0))
									  ,IIF(LDL.VALOR LIKE '%[A-Z]%' OR LDL.VALOR LIKE '%-%',998,ROUND(REPLACE(LDL.VALOR,',','.'),0)))
	) AS [92],
IIF(PAC.EDAD<=18,'0'
				,IIF(HDL.VALOR IS NULL,IIF(FHDL.VALOR IS NULL,'998',ROUND(REPLACE(FHDL.VALOR,',','.'),0))
									  ,IIF(HDL.VALOR LIKE '%[A-Z]%','998',ROUND(TRY_CONVERT(FLOAT,HDL.VALOR),0)))
	) AS [95],
IIF(PAC.EDAD<=18,0
				,IIF(TRI.VALOR IS NULL,IIF(FTRI.VALOR IS NULL,998,ROUND(REPLACE(FTRI.VALOR,',','.'),0))
									  ,IIF(TRI.VALOR LIKE '%[A-Z]%' OR TRI.VALOR LIKE'%(*)%',998,ROUND(TRI.VALOR,0)))
	) AS [98],
IIF((PAC.MESES BETWEEN 6 AND 23) OR (PAC.EDAD BETWEEN 10 AND 17 AND PAC.[10]='F') OR (GES.IPCODPACI IS NOT NULL)
				,IIF(HEM.FECORDMED IS NULL,IIF(FFHEM.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FFHEM.VALOR),103),23))
										  ,CONVERT(VARCHAR(10),HEM.FECORDMED,23)),'1845-01-01'
	) AS [103],
IIF((PAC.MESES BETWEEN 6 AND 23) OR (PAC.EDAD BETWEEN 10 AND 17 AND PAC.[10]='F') OR (GES.IPCODPACI IS NOT NULL)
				,IIF(HEM.VALOR IS NULL,IIF(FHEM.VALOR IS NULL,IIF(FFHEM.VALOR IS NULL,'0','998'),FHEM.VALOR)
				,IIF(HEM.VALOR LIKE '%[A-Z]%',IIF(HEM.FECORDMED IS NULL,'0','998'),HEM.VALOR)),'0'
	) AS [104], 
IIF(PAC.EDAD<=18,'1845-01-01'
				,IIF(LGL.FECORDMED IS NULL,IIF(FFGL.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FFGL.VALOR),103),23))
										  ,CONVERT(VARCHAR(10),LGL.FECORDMED,23))
	) AS [105],
IIF(PAC.EDAD<=18,'1845-01-01'
				,IIF(CRE.FECORDMED IS NULL,IIF(FFCRE.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FFCRE.VALOR),103),23))
										  ,CONVERT(VARCHAR(10),CRE.FECORDMED,23))
	) AS [106],
IIF(PAC.EDAD<=18,0
				,IIF(CRE.VALOR IS NULL,IIF(FCRE.VALOR IS NULL,998,ROUND(REPLACE(FCRE.VALOR,',','.'),0))
									  ,IIF(CRE.VALOR LIKE '%[A-Z]%' OR CRE.VALOR NOT LIKE '%//%',998,IIF(CRE.VALOR LIKE '%.',998,ROUND(CRE.VALOR,0)) ))
	) AS [107],
IIF(PAC.EDAD<=18,'1845-01-01'
				,IIF(HDL.FECORDMED IS NULL,IIF(FFHDL.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FFHDL.VALOR),103),23))
										  ,CONVERT(VARCHAR(10),HDL.FECORDMED,23))
	) AS [111],
IIF(PAC.EDAD<=18,0,IIF(FIS.VALOR IS NULL,21,CASE FIS.VALOR WHEN '001' THEN 5
														   WHEN '002' THEN 6
														   WHEN '003' THEN 4
														   WHEN '004' THEN 4 ELSE 21 END)) AS [114],
IIF(PAC.EDAD<=18,0,CASE FIS.VALOR WHEN '001' THEN 5
								  WHEN '002' THEN 6
								  WHEN '003' THEN 4
								  WHEN '004' THEN 4 ELSE 21 END) AS [117],
IIF(PAC.EDAD<=18,'1845-01-01'
				,IIF(TRI.FECORDMED IS NULL,IIF(FFTRI.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FFTRI.VALOR),103),23))
										  ,CONVERT(VARCHAR(10),TRI.FECORDMED,23))
	) AS [118]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@TBLLaboratorio LGL ON PAC.IPCODPACI=LGL.IPCODPACI AND LGL.ANALITO LIKE '%GLUCOSA%' 
												   AND LGL.VARIABLE=2
												   AND LGL.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE LGL.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=2 AND LA.ANALITO LIKE '%GLUCOSA%') LEFT JOIN
@TBLExaFisico FGL ON PAC.IPCODPACI=FGL.IPCODPACI AND FGL.VARIABLE=27 
												 AND FGL.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FGL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=27)
												 AND FGL.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FGL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=27) LEFT JOIN
@TBLExaFisico FFGL ON PAC.IPCODPACI=FFGL.IPCODPACI AND FFGL.VARIABLE=14 
												   AND FFGL.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FFGL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=14)
												   AND FFGL.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FFGL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=14) LEFT JOIN
@TBLLaboratorio LDL ON PAC.IPCODPACI=LDL.IPCODPACI AND LDL.ANALITO LIKE '%LDL%' 
												   AND LDL.VARIABLE IN (3,4)
												   AND LDL.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE LDL.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE IN (3,4) AND LA.ANALITO LIKE '%LDL%') LEFT JOIN
@TBLExaFisico FDL ON PAC.IPCODPACI=FDL.IPCODPACI AND FDL.VARIABLE=32 
												 AND FDL.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=32)
												 AND FDL.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=32) LEFT JOIN
@TBLExaFisico FFDL ON PAC.IPCODPACI=FFDL.IPCODPACI AND FFDL.VARIABLE=4 
												   AND FFDL.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FFDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=4)
												   AND FFDL.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FFDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=4) LEFT JOIN
@TBLLaboratorio HDL ON PAC.IPCODPACI=HDL.IPCODPACI AND HDL.ANALITO LIKE '%HDL%' 
												   AND HDL.VARIABLE=4
												   AND HDL.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE HDL.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=4 AND LA.ANALITO LIKE '%HDL%') LEFT JOIN
@TBLExaFisico FHDL ON PAC.IPCODPACI=FHDL.IPCODPACI AND FHDL.VARIABLE=41
												   AND FHDL.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FHDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=41)
												   AND FHDL.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FHDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=41) LEFT JOIN
@TBLExaFisico FFHDL ON PAC.IPCODPACI=FFHDL.IPCODPACI AND FFHDL.VARIABLE=4 
													 AND FFHDL.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FFHDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=4)
													 AND FFHDL.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FFHDL.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=4) LEFT JOIN
@TBLLaboratorio TRI ON PAC.IPCODPACI=TRI.IPCODPACI AND TRI.ANALITO LIKE '%TRIGLI%' AND TRI.VARIABLE=5
												   AND TRI.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE TRI.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=5 AND LA.ANALITO LIKE '%TRIGLI%') LEFT JOIN
@TBLExaFisico FTRI ON PAC.IPCODPACI=FTRI.IPCODPACI AND FTRI.VARIABLE=33
												   AND FTRI.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FTRI.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=33) LEFT JOIN
@TBLExaFisico FFTRI ON PAC.IPCODPACI=FFTRI.IPCODPACI AND FFTRI.VARIABLE=18 
												     AND FFTRI.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FFTRI.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=18)
													 AND FFTRI.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FFTRI.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=18) LEFT JOIN
@TBLLaboratorio HEM ON PAC.IPCODPACI=HEM.IPCODPACI AND HEM.ANALITO LIKE '%HEMOGLOBINA%' 
												   AND HEM.VARIABLE=6
												   AND HEM.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE HEM.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=6 
																																			  AND LA.ANALITO LIKE '%HEMOGLOBINA%' 
																																			  AND LA.ANALITO NOT LIKE '%MEDIA%') LEFT JOIN
@TBLExaFisico FHEM ON PAC.IPCODPACI=FHEM.IPCODPACI AND FHEM.VARIABLE=36
												   AND FHEM.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FHEM.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=36)
												   AND FHEM.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FHEM.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=36) LEFT JOIN
@TBLExaFisico FFHEM ON PAC.IPCODPACI=FFHEM.IPCODPACI AND FFHEM.VARIABLE=13
												     AND FFHEM.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FFHEM.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=13)
													 AND FFHEM.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FFHEM.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=13) LEFT JOIN
@TBLLaboratorio CRE ON PAC.IPCODPACI=CRE.IPCODPACI AND CRE.ANALITO LIKE '%CREATININA%' 
												   AND CRE.VARIABLE=7
												   AND CRE.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE CRE.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=7 AND LA.ANALITO LIKE '%CREATININA%') LEFT JOIN
@TBLExaFisico FCRE ON PAC.IPCODPACI=FCRE.IPCODPACI AND FCRE.VARIABLE=37
												   AND FCRE.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FCRE.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=37)
												   AND FCRE.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FCRE.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=37) LEFT JOIN
@TBLExaFisico FFCRE ON PAC.IPCODPACI=FFCRE.IPCODPACI AND FFCRE.VARIABLE=15
												     AND FFCRE.NUMINGRES=(SELECT MAX(FIS.NUMINGRES) FROM @TBLExaFisico FIS WHERE FFCRE.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=15)
													 AND FFCRE.NUMEFOLIO=(SELECT MAX(FIS.NUMEFOLIO) FROM @TBLExaFisico FIS WHERE FFCRE.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=15) LEFT JOIN
@TBLExaFisico FIS ON PAC.IPCODPACI=FIS.IPCODPACI AND FIS.VARIABLE=38 
												 AND FIS.NUMINGRES=(SELECT MAX(FI.NUMINGRES) FROM @TBLExaFisico FI WHERE FIS.IPCODPACI=FI.IPCODPACI AND FI.VARIABLE=38 )
												 AND FIS.NUMEFOLIO=(SELECT MAX(FI.NUMEFOLIO) FROM @TBLExaFisico FI WHERE FIS.IPCODPACI=FI.IPCODPACI AND FI.VARIABLE=38 ) LEFT JOIN
@TBLGestacion GES ON PAC.IPCODPACI=GES.IPCODPACI;


/*****************************************************************************************************
------------------------------------------------------TEST 0 A 12------------------------------------
*****************************************************************************************************/
INSERT INTO @TBLEscalaVale
SELECT
PAC.IPCODPACI,
IIF(PAC.EDAD<=12,IIF(VAL.RESULTADO IS NULL,IIF(ESC.RESULTADO IS NULL,IIF(FVALR.VALOR IS NULL,21,CONVERT(VARCHAR(2),FVALR.VALOR)),CASE WHEN ESC.RESULTADO='0' THEN 5 ELSE 4 END),CASE WHEN VAL.RESULTADO='0' THEN 5 ELSE 4 END),0) AS [40],
IIF(PAC.EDAD<=12,IIF(VAL.FECHAREGISTRO IS NULL,IIF(ESC.FECHAREGISTRO IS NULL,IIF(FVALF.VALOR IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FVALF.VALOR),103),23)),CONVERT(VARCHAR(10),ESC.FECHAREGISTRO,21)),CONVERT(VARCHAR(10),VAL.FECHAREGISTRO,21)),'1845-01-01') AS [63]
FROM 
#TBLConsulta202 PAC LEFT JOIN
ESCALAVALE VAL ON PAC.IPCODPACI=VAL.IPCODPACI AND VAL.NUMEFOLIO=(SELECT MAX(VA.NUMEFOLIO)FROM ESCALAVALE VA WHERE VAL.IPCODPACI=VA.IPCODPACI AND CAST(VA.FECHAREGISTRO AS DATE) BETWEEN @FechaInicial AND @FechaFinal)LEFT JOIN
dbo.HCESCALAS ESC ON PAC.IPCODPACI=ESC.IPCODPACI AND ESC.ID=(SELECT MAX(A.ID) FROM dbo.HCESCALAS A WHERE ESC.IPCODPACI=A.IPCODPACI AND A.TIPOESCALA=45 AND CAST(A.FECHAREGISTRO AS DATE) BETWEEN @FechaInicial AND @FechaFinal) LEFT JOIN
@TBLExaFisico FVALR ON PAC.IPCODPACI=FVALR.IPCODPACI AND FVALR.VARIABLE=47
													 AND FVALR.NUMEFOLIO=(SELECT MAX(FI.NUMEFOLIO) FROM @TBLExaFisico FI WHERE FVALR.IPCODPACI=FI.IPCODPACI AND FI.VARIABLE=47 ) LEFT JOIN
@TBLExaFisico FVALF ON PAC.IPCODPACI=FVALF.IPCODPACI AND FVALF.VARIABLE=48
													 AND FVALF.NUMEFOLIO=(SELECT MAX(FI.NUMEFOLIO) FROM @TBLExaFisico FI WHERE FVALF.IPCODPACI=FI.IPCODPACI AND FI.VARIABLE=48 );
/**************************************************************************************************************
----------------------------------------------ESCALAS VARIABLES 43,44,45,46------------------------------------
**************************************************************************************************************/
INSERT INTO @ESCALADETALLE
SELECT 
A.TIPOESCALA,
A.IPCODPACI,
A.NUMEFOLIO,
B.AREAEVALU,
CONVERT(VARCHAR(50),B.RESULTADO) AS RESULTADO
FROM
dbo.HCESCALAS A INNER JOIN
dbo.HCESCADETALLE B ON A.ID=B.HCESCALAID AND (CAST(A.FECHAREGISTRO AS DATE) BETWEEN @FechaInicial AND @FechaFinal)
UNION ALL
SELECT 
A.TIPOESCALA,
A.IPCODPACI,
--A.NUMEFOLIO,
B.ID AS NUMEFOLIO,
CASE B.TAGPREGUNTA WHEN '1' THEN 'A'
				   WHEN '2' THEN 'B'
				   WHEN '3' THEN 'C'
				   WHEN '4' THEN 'D' END AS AREAEVALU,
IIF(@ID_COMPANY='INDIGO025',IIF(A.RESULTADO>='27','30','0'),IIF(B.VALORITEMSELECCIONADO NOT LIKE '%[A-Z]%',ROUND(REPLACE(B.VALORITEMSELECCIONADO,',','.'),0),0)) AS RESULTADO
FROM
dbo.HCESCALAS A INNER JOIN
dbo.HCESCALASRESULTITEMS B ON A.ID=B.IDHCESCALAS AND (CAST(A.FECHAREGISTRO AS DATE) BETWEEN @FechaInicial AND @FechaFinal)
---------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO @TBLEscalas
SELECT 
PAC.IPCODPACI,
IIF(PAC.EDAD<=8,IIF(ESCA.IPCODPACI IS NOT NULL,ISNULL(CASE WHEN PAC.MESES BETWEEN 1 AND 3 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 1 THEN '3' 
																	  WHEN ESCA.RESULTADO BETWEEN 2 AND 3 THEN '4' ELSE '5' END) 
							WHEN PAC.MESES BETWEEN 4 AND 6 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 4 THEN '3' 
																	  WHEN ESCA.RESULTADO BETWEEN 5 AND 6 THEN '4' ELSE '5' END) 
							WHEN PAC.MESES BETWEEN 7 AND 9 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 7 THEN '3' 
																	  WHEN ESCA.RESULTADO BETWEEN 8 AND 10 THEN '4' ELSE '5' END)
							WHEN PAC.MESES BETWEEN 10 AND 12 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 11 THEN '3' 
																		WHEN ESCA.RESULTADO BETWEEN 12 AND 13 THEN '4' ELSE '5' END)
							WHEN PAC.MESES BETWEEN 13 AND 18 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 13 THEN '3' 
																		WHEN ESCA.RESULTADO BETWEEN 14 AND 16 THEN '4' ELSE '5' END)
							WHEN PAC.MESES BETWEEN 19 AND 24 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 16 THEN '3'
																		WHEN ESCA.RESULTADO BETWEEN 17 AND 19 THEN '4' ELSE '5' END)
							WHEN PAC.MESES BETWEEN 25 AND 36 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 19 THEN '3' 
																		WHEN ESCA.RESULTADO BETWEEN 20 AND 23 THEN '4' ELSE '5' END)
							WHEN PAC.MESES BETWEEN 37 AND 48 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 22 THEN '3' 
																		WHEN ESCA.RESULTADO BETWEEN 23 AND 26 THEN '4' ELSE '5' END)
							WHEN PAC.MESES BETWEEN 49 AND 60 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 26 THEN '3'
																		WHEN ESCA.RESULTADO BETWEEN 27 AND 29 THEN '4' ELSE '5' END)
							WHEN PAC.MESES BETWEEN 61 AND 84 THEN (CASE WHEN ESCA.RESULTADO BETWEEN 0 AND 26 THEN '3'
																		WHEN ESCA.RESULTADO BETWEEN 27 AND 29 THEN '4' ELSE '5' END ) ELSE '0' END ,21),21),0) AS [43],
IIF(PAC.EDAD<=8,IIF(ESCB.IPCODPACI IS NOT NULL,ISNULL(CASE WHEN PAC.MESES BETWEEN 1 AND 3 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 1 THEN '3' 
																						WHEN ESCB.RESULTADO BETWEEN 2 AND 3 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 4 AND 6 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 4 THEN '3' 
																						WHEN ESCB.RESULTADO BETWEEN 5 AND 6 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 7 AND 9 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 7 THEN '3'
																						WHEN ESCB.RESULTADO BETWEEN 8 AND 10 THEN '4' ELSE '5' END ) 
											  WHEN PAC.MESES BETWEEN 10 AND 12 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 9 THEN '3' 
																						  WHEN ESCB.RESULTADO BETWEEN 10 AND 12 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 13 AND 18 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 12 THEN '3'
																						  WHEN ESCB.RESULTADO BETWEEN 13 AND 15 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 19 AND 24 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 14 THEN '3' 
																						  WHEN ESCB.RESULTADO BETWEEN 15 AND 18 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 25 AND 36 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 18 THEN '3'
																						  WHEN ESCB.RESULTADO BETWEEN 19 AND 21 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 37 AND 48 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 21 THEN '3'
																						  WHEN ESCB.RESULTADO BETWEEN 22 AND 24 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 49 AND 84 THEN (CASE WHEN ESCB.RESULTADO BETWEEN 0 AND 23 THEN '3'
																						  WHEN ESCB.RESULTADO BETWEEN 24 AND 28 THEN '4' ELSE '5' END)
				 ELSE '0' END	
										,21),21),0) AS [44],
IIF(PAC.EDAD<=8,IIF(ESCD.IPCODPACI IS NOT NULL,ISNULL(CASE WHEN PAC.MESES BETWEEN 1 AND 3 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 1 THEN '3'
																						WHEN ESCD.RESULTADO BETWEEN 2 AND 3 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 4 AND 6 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 4 THEN '3'
																						WHEN ESCD.RESULTADO BETWEEN 5 AND 6 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 7 AND 9 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 7 THEN '3'
																						WHEN ESCD.RESULTADO BETWEEN 8 AND 9 THEN '4' ELSE '5' END) 
											  WHEN PAC.MESES BETWEEN 10 AND 12 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 9 THEN '3'
																						  WHEN ESCD.RESULTADO BETWEEN 10 AND 12 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 13 AND 18 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 12 THEN '3'
																						  WHEN ESCD.RESULTADO BETWEEN 13 AND 14 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 19 AND 24 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 14 THEN '3'
																						  WHEN ESCD.RESULTADO BETWEEN 15 AND 17 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 25 AND 36 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 18 THEN '3'
																						  WHEN ESCD.RESULTADO BETWEEN 19 AND 22 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 37 AND 48 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 22 THEN '3'
																						  WHEN ESCD.RESULTADO BETWEEN 23 AND 26 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 49 AND 84 THEN (CASE WHEN ESCD.RESULTADO BETWEEN 0 AND 25 THEN '3'
																						  WHEN ESCD.RESULTADO BETWEEN 26 AND 28 THEN '4' ELSE '5' END) ELSE '0' END	
										,21),21),0) AS [45],
IIF(PAC.EDAD<=8,IIF(ESCC.IPCODPACI IS NOT NULL,ISNULL(CASE WHEN PAC.MESES BETWEEN 1 AND 3 THEN (CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 1 THEN '3'
																						WHEN ESCC.RESULTADO BETWEEN 2 AND 3 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 4 AND 6 THEN (CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 4 THEN '3'
																						WHEN ESCC.RESULTADO BETWEEN 5 AND 6 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 7 AND 9 THEN (CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 7 THEN '3'
																						WHEN ESCC.RESULTADO BETWEEN 8 AND 9 THEN '4' ELSE '5' END) 
											  WHEN PAC.MESES BETWEEN 10 AND 12 THEN (CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 9 THEN '3'
																						  WHEN ESCC.RESULTADO BETWEEN 10 AND 12 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 13 AND 18 THEN(CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 12 THEN '3'
																						 WHEN ESCC.RESULTADO BETWEEN 13 AND 14 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 19 AND 24 THEN(CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 13 THEN '3'
																						 WHEN ESCC.RESULTADO BETWEEN 14 AND 17 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 25 AND 36 THEN(CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 17 THEN '3'
																						 WHEN ESCC.RESULTADO BETWEEN 18 AND 21 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 37 AND 48 THEN (CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 21 THEN '3'
																						  WHEN ESCC.RESULTADO BETWEEN 22 AND 25 THEN '4' ELSE '5' END)
											  WHEN PAC.MESES BETWEEN 49 AND 84 THEN (CASE WHEN ESCC.RESULTADO BETWEEN 0 AND 24 THEN '3'
																						  WHEN ESCC.RESULTADO BETWEEN 25 AND 28 THEN '4' ELSE '5' END)ELSE '0' END	
										,21),21),0) AS [46],
IIF(PAC.EDAD<=60,0,IIF(ESCE.RESULTADO<=18,4,IIF(ESCE.RESULTADO >=19,5,21))) AS [16]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@ESCALADETALLE ESCA ON PAC.IPCODPACI=ESCA.IPCODPACI AND ESCA.AREAEVALU='A' 
													AND ESCA.TIPOESCALA=22
													AND ESCA.NUMEFOLIO=(SELECT MAX(A.NUMEFOLIO) FROM @ESCALADETALLE A WHERE ESCA.IPCODPACI=A.IPCODPACI AND A.AREAEVALU='A' AND A.TIPOESCALA=22)LEFT JOIN
@ESCALADETALLE ESCB ON PAC.IPCODPACI=ESCB.IPCODPACI AND ESCB.AREAEVALU='B' 
													AND ESCB.TIPOESCALA=22
													AND ESCB.NUMEFOLIO=(SELECT MAX(A.NUMEFOLIO) FROM @ESCALADETALLE A WHERE ESCB.IPCODPACI=A.IPCODPACI AND A.AREAEVALU='B' AND A.TIPOESCALA=22)LEFT JOIN
@ESCALADETALLE ESCD ON PAC.IPCODPACI=ESCD.IPCODPACI AND ESCD.AREAEVALU='D' 
													AND ESCD.TIPOESCALA=22
													AND ESCD.NUMEFOLIO=(SELECT MAX(A.NUMEFOLIO) FROM @ESCALADETALLE A WHERE ESCD.IPCODPACI=A.IPCODPACI AND A.AREAEVALU='D' AND A.TIPOESCALA=22)LEFT JOIN
@ESCALADETALLE ESCC ON PAC.IPCODPACI=ESCC.IPCODPACI AND ESCC.AREAEVALU='C' 
													AND ESCC.TIPOESCALA=22
													AND ESCD.NUMEFOLIO=(SELECT MAX(A.NUMEFOLIO) FROM @ESCALADETALLE A WHERE ESCC.IPCODPACI=A.IPCODPACI AND A.AREAEVALU='C' AND A.TIPOESCALA=22)LEFT JOIN
@ESCALADETALLE ESCE ON PAC.IPCODPACI=ESCE.IPCODPACI AND ESCE.TIPOESCALA=9
												    AND ESCE.NUMEFOLIO=(SELECT MAX(A.NUMEFOLIO) FROM @ESCALADETALLE A WHERE ESCE.IPCODPACI=A.IPCODPACI AND A.TIPOESCALA=9)
/*****************************************************************************************************************
--------------------------------------------VARIABLES DE TALLA Y PESO 29,30,31,32-------------------------------
****************************************************************************************************************/
INSERT INTO @TBLExamenFisico
SELECT
FIS.IPCODPACI,
CONVERT(VARCHAR(10),FIS.FECREGITE,23) AS [29],
IIF(FIS.PESOPACIE=0,'0.00',IIF(FIS.PESOPACIE<=999,CONVERT(VARCHAR(5),FORMAT(FIS.PESOPACIE,'##.##')),CONVERT(VARCHAR(5),FORMAT(FIS.PESOPACIE/1000,'##.##')))) AS [30],
CONVERT(VARCHAR(10),FIS.FECREGITE,23) AS [31],
IIF(FIS.TALLAPACI=0,'0',CAST(FIS.TALLAPACI AS INT)) AS [32]
FROM
#TBLConsulta202 PAC INNER JOIN
dbo.HCEXFISIC FIS ON PAC.IPCODPACI=FIS.IPCODPACI AND FIS.NUMEFOLIO=(SELECT MAX(FI.NUMEFOLIO) FROM HCEXFISIC FI INNER JOIN  dbo.ADINGRESO IG ON FI.NUMINGRES=IG.NUMINGRES AND IG.IINGREPOR IN (2,3) AND FIS.IPCODPACI=FI.IPCODPACI AND (FI.PESOPACIE!=0 OR FI.TALLAPACI!=0) 
																																				 AND (CAST(FI.FECREGITE AS DATE) BETWEEN @FechaInicial AND @FechaFinal))
/*****************************************************************************************************************
-------------------------TODA LA POBLACION VARIABLES 29,30,31,32,42,78,79,80,81,82,83,110------------------------
****************************************************************************************************************/
INSERT INTO @TBLTodaPoblacion
SELECT
PAC.IPCODPACI,
IIF(PAC.MESES<=1 AND RN.IPCODPACI IS NOT NULL,CAST(RN.FECHISPAC AS DATE),ISNULL(EXF.[29],'1800-01-01')) AS [29],
IIF(PAC.MESES<=1 AND RN.IPCODPACI IS NOT NULL,FORMAT(RN.PESORECNA/1000,'0.##'),ISNULL(EXF.[30],'999')) AS [30],
IIF(PAC.MESES<=1 AND RN.IPCODPACI IS NOT NULL,CAST(RN.FECHISPAC AS DATE),ISNULL(EXF.[31],'1800-01-01')) AS [31],
IIF(PAC.MESES<=1 AND RN.IPCODPACI IS NOT NULL,RN.TALLARECI,ISNULL(EXF.[32],'999')) AS [32],
IIF(PAC.EDAD>=50,IIF(LAB.VALOR IS NULL,21,CASE LAB.VALOR WHEN '001' THEN 4
														 WHEN '002' THEN 5
														 WHEN '003' THEN 21
														 WHEN '004' THEN 0 END),0) AS [42],
IIF(HC.FECHISPAC IS NULL,'1800-01-01',CONVERT(VARCHAR(10),HC.FECHISPAC,23)) AS [52],
IIF(GES.IPCODPACI IS NOT NULL,IIF(HPB.VALOR IS NULL,ISNULL(CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),FSC.VALOR),103),23) ,'1800-01-01')
												  ,CONVERT(VARCHAR(10),HPB.FECORDMED,23))
						 ,'1845-01-01') AS [78],--FECHA DE HEPATITS B
IIF(GES.IPCODPACI IS NOT NULL,IIF(HPB.VALOR IS NULL,ISNULL(CASE H.VALOR WHEN '001'THEN 4
																		WHEN '002'THEN 5 
																		WHEN '003'THEN 21
																		WHEN '004'THEN 0 END,21),CASE HPB.VALOR WHEN 'POSITIVO' THEN 4
																												WHEN 'NEGATIVO' THEN 5 END)
							 ,21) AS [79],--RESULTADO HEPATITIS B
IIF(LABO.VALOR IS NULL,IIF(GES.IPCODPACI IS NULL,'1845-01-01','1800-01-01'),CONVERT(VARCHAR(10),LABO.FECORDMED,23)) AS [80],
IIF(LABO.VALOR IS NULL,IIF(GES.IPCODPACI IS NULL,0,21),CASE WHEN LABO.VALOR LIKE '%NO REACTIVO%' THEN 5
															WHEN LABO.VALOR LIKE '%NO REACTIVA%' THEN 5
															WHEN LABO.VALOR LIKE '%REACTIVA%' THEN 4 
															WHEN LABO.VALOR LIKE '%NEGATIVA%' THEN 5
															WHEN LABO.VALOR LIKE '%POSITIVA%' THEN 4 ELSE 21 END) AS [81],
IIF(LABOR.VALOR IS NULL,IIF(GES.IPCODPACI IS NULL,'1845-01-01','1800-01-01'),CONVERT(VARCHAR(10),LABOR.FECORDMED,23)) AS [82],
IIF(LABOR.VALOR IS NULL,IIF(GES.IPCODPACI IS NULL,0,21),CASE WHEN LABOR.VALOR LIKE '%NEGATIVO%' THEN 5
															 WHEN LABOR.VALOR LIKE '%POSITIVO%' THEN 4 ELSE 21 END) AS [83],
IIF(PAC.EDAD>=50,IIF(LAB.FECORDMED IS NULL,'1800-01-01',CONVERT(VARCHAR(10),LAB.FECORDMED,23)),'1845-01-01') AS [110]
FROM 
#TBLConsulta202 PAC LEFT JOIN
HCHISPACA HC ON PAC.IPCODPACI=HC.IPCODPACI AND CAST(HC.FECHISPAC AS DATE) BETWEEN @FechaInicial AND @FechaFinal
										   AND HC.ID=(SELECT MAX(H.ID) FROM HCHISPACA H WHERE HC.IPCODPACI=H.IPCODPACI AND H.IDMODELOHC IN (6,7,8,9,10,11,12,13,14,16,18,30) AND H.IDMODELOHC IS NOT NULL AND CAST(H.FECHISPAC AS DATE) BETWEEN @FechaInicial AND @FechaFinal) LEFT JOIN
@TBLGestacion GES ON PAC.IPCODPACI=GES.IPCODPACI LEFT JOIN
@TBLExamenFisico EXF ON PAC.IPCODPACI=EXF.IPCODPACI LEFT JOIN
@TBLLaboratorio LAB ON PAC.IPCODPACI=LAB.IPCODPACI AND LAB.VARIABLE=8 
												   AND LAB.ANALITO LIKE '%HEPATITIS C%' LEFT JOIN
@TBLLaboratorio HPB ON PAC.IPCODPACI=HPB.IPCODPACI AND HPB.VARIABLE=12
												   AND HPB.ANALITO LIKE '%HEPATITIS B%' LEFT JOIN
@TBLExaFisico FSC ON PAC.IPCODPACI=FSC.IPCODPACI AND FSC.VARIABLE=6 
												 AND FSC.NUMEFOLIO=(SELECT MAX(FS.NUMEFOLIO) FROM @TBLExaFisico FS WHERE PAC.IPCODPACI=FS.IPCODPACI AND FS.VARIABLE=6) LEFT JOIN
@TBLExaFisico H ON PAC.IPCODPACI=H.IPCODPACI AND H.VARIABLE=28 
											 AND H.NUMEFOLIO=(SELECT MAX(FS.NUMEFOLIO) FROM @TBLExaFisico FS WHERE H.IPCODPACI=FS.IPCODPACI AND FS.VARIABLE=28) LEFT JOIN
@TBLLaboratorio LABO ON PAC.IPCODPACI=LABO.IPCODPACI AND LABO.VARIABLE=9
													 AND (LABO.ANALITO LIKE '%VDRL%' OR LABO.ANALITO LIKE '%FTA-ABS O TPHA-PRUEBA%')
													 AND LABO.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE PAC.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=9 AND (LA.ANALITO LIKE '%VDRL%' OR LA.ANALITO LIKE '%FTA-ABS O TPHA-PRUEBA%')) LEFT JOIN
@TBLLaboratorio LABOR ON PAC.IPCODPACI=LABOR.IPCODPACI AND LABOR.VARIABLE=10
													   AND LABOR.ANALITO LIKE '%VIH%'
													   AND LABOR.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE PAC.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=10 AND LA.ANALITO LIKE '%VIH%') LEFT JOIN
dbo.HCRECINAC RN ON PAC.IPCODPACI=RN.IPCODPACIHIJO AND RN.NUMEFOLIO=(SELECT MIN(R.NUMEFOLIO) FROM dbo.HCRECINAC R WHERE PAC.IPCODPACI=R.IPCODPACIHIJO);
--/*****************************************************************************************************
------------------------------TBERCULOSIS VARIABLES 18,112,113-----------------------------------------
--******************************************************************************************************/
INSERT INTO @TBLTuberculosis
SELECT DISTINCT
PAC.IPCODPACI,
IIF(LAB.VALOR IS NULL,IIF(SIS.VALOR IS NULL,21,IIF(SIS.VALOR='2',2,1))
					 ,CASE WHEN LAB.VALOR LIKE '%No se observan%' THEN 2 
						   WHEN LAB.VALOR LIKE '%NEGATIVO%' THEN 2
						   WHEN LAB.VALOR LIKE '%POSITIVO%' THEN 1 END) AS [18],
IIF(LAB.FECORDMED IS NULL,IIF(BACF.VALOR IS NULL,IIF(SIS.FECHISPAC IS NULL,'1800-01-01',CONVERT(VARCHAR(10),CONVERT(DATE,SIS.FECHISPAC,103),23))
												,CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(NCHAR(10),BACF.VALOR),103),23))
						 ,CONVERT(VARCHAR(10),LAB.FECORDMED,23)) AS [112],
IIF(LAB.VALOR IS NULL,IIF(BACR.VALOR IS NULL,21,CASE BACR.VALOR WHEN '001' THEN 1
																WHEN '002' THEN 2
																WHEN '003' THEN 3 ELSE 21 END)
					 ,CASE WHEN LAB.VALOR LIKE '%NO SE OBSERVAN%' THEN 1
						   WHEN LAB.VALOR LIKE '%NEGATIVO%' THEN 1
						   WHEN LAB.VALOR LIKE '%POSITIVO%' THEN 2 ELSE 21 END) AS [113]
FROM
#TBLConsulta202 PAC
LEFT JOIN [report].[TablaRevisionXSistema] SIS ON PAC.IPCODPACI=SIS.IPCODPACI AND SIS.FECHISPAC BETWEEN @FechaInicial AND @FechaFinal
																			  AND SIS.IDRSVARIABLE=7
																			  AND SIS.FECHISPAC=(SELECT MAX(SI.FECHISPAC) FROM [report].[TablaRevisionXSistema] SI WHERE SIS.IPCODPACI=SI.IPCODPACI AND (SI.FECHISPAC BETWEEN @FechaInicial AND @FechaFinal) AND SI.IDRSVARIABLE=7)
LEFT JOIN @TBLLaboratorio LAB ON PAC.IPCODPACI=LAB.IPCODPACI AND LAB.VARIABLE=11
															 AND (LAB.VALOR LIKE '%BAAR%' OR LAB.VALOR LIKE '%B.A.A.R%' OR LAB.VALOR LIKE '%LECTURA O BACILOSCOPIA%')
															 AND LAB.AUTO=(SELECT MAX(LA.AUTO) FROM @TBLLaboratorio LA WHERE LAB.IPCODPACI=LA.IPCODPACI AND LA.VARIABLE=11 
																																						AND (LA.VALOR LIKE '%BAAR%' OR LA.VALOR LIKE '%B.A.A.R%'))
LEFT JOIN @TBLExaFisico BACF ON PAC.IPCODPACI=BACF.IPCODPACI AND BACF.VARIABLE=53
															 AND BACF.NUMEFOLIO=(SELECT MAX(BAC.NUMEFOLIO) FROM @TBLExaFisico BAC WHERE PAC.IPCODPACI=BAC.IPCODPACI AND BAC.VARIABLE=53)
LEFT JOIN @TBLExaFisico BACR ON PAC.IPCODPACI=BACR.IPCODPACI AND BACR.VARIABLE=54
															 AND BACR.NUMEFOLIO=(SELECT MAX(BAC.NUMEFOLIO) FROM @TBLExaFisico BAC WHERE PAC.IPCODPACI=BAC.IPCODPACI AND BAC.VARIABLE=54);
/*****************************************************************************************************
----------------------------IPA VARIABLES 19-----------------------------------------
******************************************************************************************************/
INSERT INTO @IPA
SELECT
PAC.IPCODPACI,
IIF(PAC.EDAD<=12 OR ANT.VALOR LIKE '%98%','98',IIF(ANT.VALOR IS NULL,'99',CASE WHEN ANT.VALOR LIKE '%NO%FUM%' THEN '0' 
																			   WHEN ANT.VALOR LIKE '%,%' THEN CONVERT(VARCHAR(10),ROUND(REPLACE(ANT.VALOR,',','.'),0))
																			   WHEN ANT.VALOR LIKE '%.%' THEN CONVERT(VARCHAR(10),ROUND(ANT.VALOR,0))
																			   WHEN ANT.VALOR=0 THEN '0'
																			   WHEN ANT.VALOR>=1 AND ANT.VALOR<=95 THEN CONVERT(VARCHAR(10),ANT.VALOR)
																			   WHEN ANT.VALOR=96 OR ANT.VALOR>=100 THEN '96' 
																			   WHEN ANT.VALOR=97 THEN '97' ELSE '99' END)) AS [19]
FROM 
#TBLConsulta202 PAC LEFT JOIN
@ANTECEDENTES ANT ON PAC.IPCODPACI=ANT.IPCODPACI AND ANT.VARIABLE IN (1,2)
--TICKET 14183
/********************************************************************************************************************************************************
--------------------------------------------------------CONSULTA 202------------------------------------------------------------------------
********************************************************************************************************************************************************/
--INSERT INTO [Report].[Resolucion202_2021]--PARA SAN ANDRES

SELECT --DISTINCT
--ROW_NUMBER ( )   
--OVER (PARTITION BY HC.IPCODPACI  order by HC.IPCODPACI DESC) 'NUMERO',
PAC.ID_COMPANY,
--PAC.[CENTRO DE ATENCION],
PAC.TRIMESTRE,PAC.INGRESO,PAC.[FECHA ATENCION],PAC.[CODIGO ENTIDAD],PAC.ENTIDAD,PAC.[TIPO COBERTURA],PAC.[0],PAC.[1],PAC.[2],PAC.[3],PAC.IPCODPACI AS [4],
PAC.[5],PAC.[6],PAC.[7],PAC.[8],PAC.[9],PAC.[10],PAC.[11],PAC.[12],PAC.[13],
GES.[14],
'0' AS [15],
ES.[16],
'0' AS [17],
TU.[18],
IPA.[19],
'21' AS [20],'21' AS [21],
CP.[22],
GES.[23],
CCO.[24],
'21' [25],--COMODIN
'0' AS [26],
AV.[27],AV.[28],
TOD.[29], TOD.[30], TOD.[31],TOD.[32],
GES.[33],
PAC.[34],
GES.[35],
CCO.[36],
RN.[37],RN.[38],
'0' AS [39],
VAL.[40],
'0'AS [41],
TOD.[42],
ES.[43],ES.[44],ES.[45],ES.[46],
CC.[47],
RN.[48],
GES.[49],GES.[50],GES.[51],
TOD.[52],
AN.[53],AN.[54],AN.[55],
GES.[56],
RC.[57],
GES.[58],GES.[59],GES.[60],GES.[61],
AV.[62],
VAL.[63],
CP.[64],
RN.[65],
CCO.[66],CCO.[67],
'1845-01-01' AS [68],
IIF(PAC.MESES=0,'1800-01-01','1845-01-01') AS [69],
IIF(PAC.MESES>=6 AND PAC.MESES<=23,21,0) AS [70],
PRI.[71],
RC.[72],
CP.[73],
'0' AS [74],
IIF(PAC.MESES=0,'1800-01-01','1845-01-01') AS [75],
COP.[76],
PRI.[77],
TOD.[78],TOD.[79],TOD.[80],TOD.[81],TOD.[82],TOD.[83],
RN.[84],RN.[85],
CC.[86],CC.[87],CC.[88],CC.[89],CC.[90],CC.[91],
RC.[92],
CC.[93],CC.[94],
RC.[95],
CM.[96],CM.[97],
RC.[98],
CM.[99],CM.[100],CM.[101],
COP.[102],
RC.[103],RC.[104],RC.[105],RC.[106],RC.[107],
'1845-01-01' AS [108],
CP.[109],
TOD.[110],
RC.[111],
TU.[112],TU.[113], 
RC.[114],
'0' AS [115],'0' AS [116],	
RC.[117],RC.[118],
1 CANTIDAD,
PAC.[FECHA BUSQUEDA],
PAC.ULT_ACTUAL
FROM 
#TBLConsulta202 PAC INNER JOIN 
@TBLGestantes GES ON PAC.IPCODPACI=GES.IPCODPACI INNER JOIN 
@TBLCaMama CM ON PAC.IPCODPACI=CM.IPCODPACI INNER JOIN 
@TBLAgudezaVisual AV ON PAC.IPCODPACI=AV.IPCODPACI INNER JOIN 
@TBLAnticonceptivo AN ON PAC.IPCODPACI=AN.IPCODPACI INNER JOIN
@TBLCancerCervix CC ON PAC.IPCODPACI=CC.IPCODPACI INNER JOIN
@TBLCancerColon CCO ON PAC.IPCODPACI=CCO.IPCODPACI INNER JOIN
@TBLCancerProstata CP ON PAC.IPCODPACI=CP.IPCODPACI INNER JOIN
@TBLCOP COP ON PAC.IPCODPACI=COP.IPCODPACI INNER JOIN
@TBLPrimeraInfancia PRI ON PAC.IPCODPACI=PRI.IPCODPACI INNER JOIN
@TBLRNacido RN ON PAC.IPCODPACI=RN.IPCODPACI INNER JOIN
@TBLARiesgoCardio RC ON PAC.IPCODPACI=RC.IPCODPACI INNER JOIN	
@TBLEscalaVale VAL ON PAC.IPCODPACI=VAL.IPCODPACI INNER JOIN
@TBLEscalas ES ON PAC.IPCODPACI=ES.IPCODPACI INNER JOIN
@TBLTodaPoblacion TOD ON PAC.IPCODPACI=TOD.IPCODPACI INNER JOIN
@TBLTuberculosis TU ON PAC.IPCODPACI=TU.IPCODPACI INNER JOIN
@IPA IPA ON PAC.IPCODPACI=IPA.IPCODPACI
--where pac.IPCODPACI in ('1040883118')
ORDER BY [1]
DROP TABLE #TBLConsulta202

