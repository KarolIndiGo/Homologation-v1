-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewResolution5521
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*******************************************************************************************************************
Nombre: [Report].[ViewResolution5521]
Tipo:Vista
Observacion:Resolucion 5521 del 2013 
Profesional: Amira Esperanza Gil Meneses
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico:
Fecha:
Ovservaciones:
--------------------------------------
Version 2
Persona que modifico:
Fecha:
***********************************************************************************************************************************/
CREATE VIEW [Report].[ViewResolution5521] AS


WITH DISPENSACION
AS
(
SELECT AdmissionNumber 'INGRESO',
      C.ConfirmationDate 'FECHA ENTREGA',
	  ATC.Code 'CODIGO MEDICAMENTO',
	  P.Code 'CUM',
	  D.Quantity 'CANTIDAD ENTREGADA',
	  D.EntityId 'IDFORMULA',
	  D.SalePrice 'Valor unitario', 
	  D.GrandTotalSalesPrice 'Total',
	  ATC.Concentration 'Concentracion'

FROM Inventory .PharmaceuticalDispensing AS C WITH (NOLOCK)
JOIN Inventory .PharmaceuticalDispensingDetail AS D WITH (NOLOCK) ON C.Id =D.PharmaceuticalDispensingId 
JOIN Inventory .InventoryProduct AS P WITH (NOLOCK) ON  D.ProductId =P.ID 
JOIN Inventory .ATC AS ATC  WITH (NOLOCK) ON P.ATCId =ATC.Id  
WHERE C.Status =2 --Estado (registrado = 1,confirmado = 2,anulado = 3)--
)
, 
CTE_DIAS_TRATAMIENTO AS 
(
select 
A.NUMINGRES,
A.CODPRODUC,
DATEDIFF(DAY,A.FECINITRA,B.FECAPLMED) AS [DIAS TRATAMIENTO]
from 
dbo.HCHOJAMED A INNER JOIN
dbo.HCHOJAMED B ON A.NUMINGRES=B.NUMINGRES AND A.CODPRODUC=B.CODPRODUC 
                                           AND A.CONSECUTI=(SELECT MIN(CON.CONSECUTI) FROM dbo.HCHOJAMED CON WHERE A.NUMINGRES=CON.NUMINGRES AND A.CODPRODUC=CON.CODPRODUC)
                                           AND B.CONSECUTI=(SELECT MAX(CON.CONSECUTI) FROM dbo.HCHOJAMED CON WHERE B.NUMINGRES=CON.NUMINGRES AND B.CODPRODUC=CON.CODPRODUC AND CON.FECAPLMED IS NOT NULL)                                           
)

, CTE_CONSULTAS_ORDENAMIENTO 
AS
(
SELECT
  CEN.NOMCENATE 'CENTRO ATENCION',
 HA.Code 'COD_ENTIDAD',
 HA.Name 'ENTIDAD',
 CASE PAC.IPTIPODOC WHEN '1'  THEN 'CC'
				 WHEN '2'  THEN 'CE'
				 WHEN '3'  THEN 'TI'
				 WHEN '4'  THEN 'RC' 
				 WHEN '5'  THEN 'PA'
				 WHEN '6'  THEN 'AS'
				 WHEN '7'  THEN 'MS'
				 WHEN '8'  THEN 'NU'
				 WHEN '9'  THEN 'CN'
				 WHEN '10' THEN 'CD'
				 WHEN '11' THEN 'SA'
				 WHEN '12' THEN 'PE' 
				 WHEN '13' THEN 'PT'
				 WHEN '14' THEN 'DE'
				 WHEN '15' THEN 'SI' END AS [TIPO IDENTIFICACION],
C.IPCODPACI 'IDENTIFICACION',
CAST (PAC.IPFECNACI AS DATE)'FECHA NACIMINIENTO',
CASE PAC.IPSEXOPAC WHEN 1 THEN 'H'
				   WHEN 2 THEN 'F' ELSE 'I' END AS [GENERO],
MUN.DEPCODIGO [DEPARTAMENTO],
MUN.MUNCODIGO AS [MUNICIPIO],

CASE ING.TIPOINGRE WHEN 1 THEN 'A'
                   WHEN 2 THEN 'H' ELSE 'U' END AS [TIPO INGRESO],
CAST (C.FECHAORDE AS DATE)'FECHA ORDEN',
CEN.CODIPSSEC As [COD HABILITACION],
DIS.[CUM],
D.CANPEDPRO  'CANTIDAD SOLICITADA',
DIS.Concentracion 'CONCENTRACION',
PRE.DESFORMED 'PRESENTACION',
TRA.[DIAS TRATAMIENTO],
DIS.[VALOR UNITARIO],
DIS.[TOTAL],
ING.CODDIAING [DIAGNOSTICO],
DIS.[FECHA ENTREGA],

CASE D.NOPOSPROD WHEN 'False' THEN 'SI' ELSE 'NO' END AS PBS--Indica si el medicamento es NO POS--

FROM HCFARMEPC AS C WITH (NOLOCK)
JOIN HCFARMEPD AS D WITH (NOLOCK) ON C.CODCONCEC =D.CODCONCEC AND C.NUMINGRES =D.NUMINGRES 
JOIN IHLISTPRO AS PRO WITH (NOLOCK) ON D.CODPRODUC =PRO.CODPRODUC AND PRO.TIPPRODUC ='1'
JOIN INPROFSAL AS MED WITH (NOLOCK) ON D.CODPROSAL =MED.CODPROSAL 
JOIN ADCENATEN AS CEN WITH (NOLOCK) ON C.CODCENATE =CEN.CODCENATE 
JOIN INUNIFUNC AS UNI WITH (NOLOCK) ON C.UFUCODIGO =UNI.UFUCODIGO 
JOIN INPACIENT AS PAC WITH (NOLOCK) ON C.IPCODPACI =PAC.IPCODPACI
JOIN ADINGRESO AS ING WITH (NOLOCK) ON C.NUMINGRES =ING.NUMINGRES 
JOIN Contract .HealthAdministrator AS HA WITH (NOLOCK) ON ING.GENCONENTITY =HA.Id  
JOIN Inventory .ATC AS ATC  WITH (NOLOCK) ON D.CODPRODUC =ATC.Code 
JOIN Inventory .ATCEntity AS ATCE WITH (NOLOCK) ON ATC.ATCEntityId =ATCE.Id 
JOIN Inventory .PharmacologicalGroup AS PG WITH (NOLOCK) ON PG.Id =ATCE.IdPharmacologicalGroup 
LEFT JOIN IHFORMEDI AS PRE WITH (NOLOCK) ON PRO.CODFORMED =PRE.CODFORMED 
LEFT JOIN DISPENSACION AS DIS WITH (NOLOCK) ON D.ID =DIS.IDFORMULA AND D.NUMINGRES =DIS.INGRESO 
LEFT JOIN dbo.INMUNICIP AS MUN ON CEN.DEPMUNCOD=MUN.DEPMUNCOD
LEFT JOIN CTE_DIAS_TRATAMIENTO AS TRA ON D.NUMINGRES=TRA.NUMINGRES AND D.CODPRODUC=TRA.CODPRODUC
WHERE ORDESTADO <>'3'  --Estado de la Orden: 1. Pendiente 2. Entregada 3. Anulada--
)

SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
 *,
 1 as 'CANTIDAD',
 CAST([FECHA ENTREGA] AS DATE) AS 'FECHA BUSQUEDA', 
 YEAR([FECHA ENTREGA]) AS 'AÑO FECHA BUSQUEDA', 
 MONTH([FECHA ENTREGA]) AS 'MES AÑO FECHA BUSQUEDA',
 CASE MONTH([FECHA ENTREGA])WHEN 1THEN 'ENERO'
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
 DAY([FECHA ENTREGA]) AS 'DIA FECHA BUSQUEDA',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL

FROM CTE_CONSULTAS_ORDENAMIENTO
