-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewResolution0780
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre: [Report].[ViewResolution7080]
Tipo:Vista
Observacion:Resolucion 7080 del 2013 
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

--	DROP VIEW [Report].[ViewResolution7080]

CREATE VIEW [Report].[ViewResolution0780] AS

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
	  D.GrandTotalSalesPrice 'Total'

FROM Inventory .PharmaceuticalDispensing AS C
JOIN Inventory .PharmaceuticalDispensingDetail AS D ON C.Id =D.PharmaceuticalDispensingId 
JOIN Inventory .InventoryProduct AS P ON  D.ProductId =P.ID 
JOIN Inventory .ATC AS ATC ON P.ATCId =ATC.Id  
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
dbo.HCHOJAMED B ON A.CONSECUTI=B.CONSECUTI AND A.CONSECUTI=(SELECT MIN(CON.CONSECUTI) FROM dbo.HCHOJAMED CON WHERE A.NUMINGRES=CON.NUMINGRES AND A.CODPRODUC=CON.CODPRODUC)
                                           AND B.CONSECUTI=(SELECT MAX(CON.CONSECUTI) FROM dbo.HCHOJAMED CON WHERE B.NUMINGRES=CON.NUMINGRES AND B.CODPRODUC=CON.CODPRODUC AND CON.FECAPLMED IS NOT NULL)                                           
)

SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
TP.Nit As [Nit de la IPS],
CEN.CODIPSSEC As [Código habilitación],
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
				 WHEN '15' THEN 'SI'
				 END AS [TIPO IDENTIFICACION],
C.IPCODPACI 'IDENTIFICACION',
PAC.IPPRIAPEL 'PRIMER APELLIDO' , 
PAC.IPSEGAPEL 'SEGUNDO APELLIDO',
PAC.IPPRINOMB 'PRIMER NOMBRE',
PAC.IPSEGNOMB 'SEGUNDO NOMBRE',
DIS.[CUM],
PRO.DESPRODUC 'MEDICAMENTO' , 
TRA.[DIAS TRATAMIENTO],
DIS.[FECHA ENTREGA],
CASE D.NOPOSPROD WHEN 'False' THEN 'SI' ELSE 'NO' END AS PBS,--Indica si el medicamento es  POS--
1 'CANTIDAD',
CAST(DIS.[FECHA ENTREGA] AS DATE) AS 'FECHA BUSQUEDA', 
YEAR(DIS.[FECHA ENTREGA]) AS 'AÑO FECHA BUSQUEDA', 
MONTH(DIS.[FECHA ENTREGA]) AS 'MES AÑO FECHA BUSQUEDA',
CASE MONTH(DIS.[FECHA ENTREGA])WHEN 1THEN 'ENERO'
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
DAY(DIS.[FECHA ENTREGA]) AS 'DIA FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM HCFARMEPC AS C JOIN
HCFARMEPD AS D ON C.CODCONCEC=D.CODCONCEC AND C.ORDESTADO <>'3' JOIN
IHLISTPRO AS PRO ON D.CODPRODUC=PRO.CODPRODUC AND PRO.TIPPRODUC ='1' JOIN 
INPROFSAL AS MED ON D.CODPROSAL =MED.CODPROSAL JOIN 
ADCENATEN AS CEN ON C.CODCENATE =CEN.CODCENATE 
JOIN INUNIFUNC AS UNI ON C.UFUCODIGO =UNI.UFUCODIGO 
JOIN INPACIENT AS PAC ON C.IPCODPACI =PAC.IPCODPACI
JOIN ADINGRESO AS ING ON C.NUMINGRES =ING.NUMINGRES 
JOIN Contract.HealthAdministrator AS HA ON ING.GENCONENTITY =HA.Id 
JOIN Common.ThirdParty AS TP ON HA.ThirdPartyId =TP.Id
JOIN Inventory.ATC AS ATC ON D.CODPRODUC =ATC.Code 
JOIN Inventory.ATCEntity AS ATCE ON ATC.ATCEntityId =ATCE.Id 
JOIN Inventory.PharmacologicalGroup AS PG ON PG.Id =ATCE.IdPharmacologicalGroup 
LEFT JOIN IHFORMEDI AS PRE ON PRO.CODFORMED =PRE.CODFORMED 
LEFT JOIN DISPENSACION AS DIS ON D.ID =DIS.IDFORMULA AND D.NUMINGRES =DIS.INGRESO
LEFT JOIN CTE_DIAS_TRATAMIENTO AS TRA ON D.NUMINGRES=TRA.NUMINGRES AND D.CODPRODUC=TRA.CODPRODUC
WHERE D.NOPOSPROD = 0

 
