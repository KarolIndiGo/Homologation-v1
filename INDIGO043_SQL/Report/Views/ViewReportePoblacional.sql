-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewReportePoblacional
-- Extracted by Fabric SQL Extractor SPN v3.9.0





/*******************************************************************************************************************
Nombre: [Report].[ViewReportePoblacional]
Tipo:Vista
Observacion:Vista para pacientes con grupo poblacional.
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:25-05-2023
Ovservaciones: se cambia la logica del CTE_PACIENTES_UNICOS
--------------------------------------
Version 2
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:31-05-2023
Observación: se cambia la logica para que no tenga en cuenta los pacientes pertenecientes a una ednia sino a los que pertenesca a un grupo poblacional.
--------------------------------------
Version 3
Persona que modifico: Amira Gil Meneses
Fecha:16-11-2023
Observación: Se agrega el campo EDAD
***********************************************************************************************************************************/

CREATE view [Report].[ViewReportePoblacional] as

 WITH CTE_PACIENTES_UNICOS AS
 (
  SELECT
   ING.IPCODPACI,
   ING.NUMINGRES,
   ING.MUNCODIGOACC,
   ING.ZONAEVENTOCC,
   ING.IFECHAING
  FROM
   dbo.ADINGRESO ING
  WHERE ING.NUMINGRES=(SELECT MAX(I.NUMINGRES) FROM dbo.ADINGRESO I WHERE ING.IPCODPACI=I.IPCODPACI)
   --INNER JOIN (SELECT IPCODPACI, MAX(NUMINGRES) NUMINGRES
   --            FROM 
			--    dbo.ADINGRESO 
			--   GROUP BY 
			--    IPCODPACI) INGU ON INGU.IPCODPACI = ING.IPCODPACI AND INGU.NUMINGRES = ING.NUMINGRES
),

CTE_GRUPO_POBLACIONAL AS
 (
  SELECT 
   PA.IPCODPACI,
   STRING_AGG (GRUP.DESCRIPCION, ', ') DESCRIPCION
  FROM
   dbo.INPACIENT AS PA 
   INNER JOIN dbo.ADPOBESPEPAC GRU ON PA.IPCODPACI=GRU.IPCODPACI AND GRU.ESTADO = 1
   INNER JOIN dbo.ADPOBESPE GRUP ON GRU.IDADPOBESPE=GRUP.ID
  GROUP BY  
   PA.IPCODPACI
)

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 CASE PA.IPTIPODOC WHEN '1'  THEN 'CC'
				 WHEN '2'  THEN 'CE'
				 WHEN '3'  THEN 'TI'
				 WHEN '4'  THEN 'RC' 
				 WHEN '5'  THEN 'PA'
				 WHEN '6'  THEN 'AS'
				 WHEN '7'  THEN 'MS'
				 WHEN '8'  THEN 'NUIP'
				 WHEN '9'  THEN 'CN'
				 WHEN '10' THEN 'CD'
				 WHEN '11' THEN 'SA'
				 WHEN '12' THEN 'PE' 
				 WHEN '13' THEN 'PT' 
				 WHEN '14' THEN 'DE'
                 WHEN '15' THEN 'SI' END AS [Tipo documento],
PA.IPCODPACI AS [Número documento],
CONCAT (TRIM(PA.IPPRINOMB),' ',TRIM(PA.IPSEGNOMB)) As [Nombres del usuario],
CONCAT (TRIM(PA.IPPRIAPEL),' ',TRIM(PA.IPSEGAPEL)) As [Apellidos del usuario],
DEP.nomdepart AS Departamento,
MUN.MUNNOMBRE AS [Municipio de residencia],
CASE PA.ZONAPARTADA  WHEN '1' THEN 'SI' 
                     WHEN '0' THEN 'NO' END AS [Zona de residencia],
IIF (PA.TIPCOBSAL='6','SI','NO') AS [Desplazado],
CASE PA.IPTIPOPAC WHEN '1' THEN 'Contributivo' 
             WHEN '2' THEN 'Subsidiado'
			 WHEN '3' THEN 'Vinculado'
			 WHEN '4' THEN 'Particular'
			 WHEN '5' THEN 'Otro'
			 WHEN '6' THEN 'Desplazado Reg. Contributivo'
			 WHEN '7' THEN 'Desplazado Reg. Subsidiado'
			 WHEN '8' THEN 'Desplazado No Asegurado' END AS [Régimen de afiliación],
CAST (PA.IPFECNACI AS DATE) AS [Fecha de nacimiento],
DATEDIFF (YEAR, PA.IPFECNACI, GETDATE()) AS [Edad],
CASE PA.IPSEXOPAC WHEN '1' THEN 'Masculino'
                  WHEN '2' THEN 'Femenino' END AS [Sexo],
CASE ETN.CODGRUPOE WHEN '000' THEN 'NINGUNO' 
                   WHEN '001' THEN 'INDIGENAS' 
			       WHEN '002' THEN 'AFROCOLOMBIANOS NEGROS MULATOS O AFRODESCENDIENTES' 
			       WHEN '003' THEN 'RAIZALES SAN ANDRES Y PROVIDENCIA' 
			       WHEN '004' THEN 'PUEBLO ROM GITANOS' 
				   WHEN '005' THEN 'PALENQUEROS'
			       WHEN '999' THEN 'NO SABE  NO INFORMA  NO APLICA' END AS [Pertenencia étnica],
GRUP.DESCRIPCION AS [Grupo Poblacional],
DIS.DISCDESCRI AS [Condición de discapacidad],
CASE PA.IPESTADOC WHEN '1' THEN 'Soltero (a)' 
                  WHEN '2' THEN 'Casado (a)'
				  WHEN '3' THEN 'Viudo (a)'
				  WHEN '4' THEN 'Union libre'
				  WHEN '4' THEN'separado(a)/Div' END AS [Estado civil],
NIV.NIVEDESCRI AS [Nivel educativo],
PA.IPESTRATO AS [Estrato socioeconómico],
OCU.desactivi AS [Ocupación],
CRE.CREDDESCRI AS [Creencia],
ING.NUMINGRES as [Ult. Num Ingreso],
CAST(ING.IFECHAING AS date) AS [Ult. Fecha Ingreso],
1 as 'CANTIDAD',
CAST(ING.IFECHAING AS date) AS 'FECHA BUSQUEDA',
YEAR(ING.IFECHAING) AS 'AÑO BUSQUEDA',
MONTH(ING.IFECHAING) AS 'MES BUSQUEDA',
CONCAT(FORMAT(MONTH(ING.IFECHAING), '00') ,' - ', 
   CASE MONTH(ING.IFECHAING) 
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
FROM 
 CTE_PACIENTES_UNICOS ING 
 INNER JOIN dbo.INPACIENT AS PA ON ING.IPCODPACI=PA.IPCODPACI 
 LEFT JOIN CTE_GRUPO_POBLACIONAL GRUP ON PA.IPCODPACI=GRUP.IPCODPACI 
 LEFT JOIN dbo.INUBICACI UBI on PA.AUUBICACI=UBI.AUUBICACI  
 LEFT JOIN dbo.INMUNICIP MUN ON UBI.DEPMUNCOD=MUN.DEPMUNCOD 
 LEFT JOIN dbo.INDEPARTA DEP ON MUN.DEPCODIGO=DEP.depcodigo
 LEFT JOIN dbo.ADGRUETNI ETN ON PA.CODGRUPOE=ETN.CODGRUPOE
 LEFT JOIN dbo.ADDISCAPACI AS DIS ON PA.DISCCODIGO=DIS.DISCCODIGO
 LEFT JOIN dbo.ADACTIVID AS OCU ON PA.CODACTIVI=OCU.codactivi
 LEFT JOIN dbo.ADCREDO AS CRE ON PA.CREDCODIGO=CRE.CREDCODIGO
 LEFT JOIN dbo.ADNIVELED AS NIV ON PA.NIVECODIGO=NIV.NIVECODIGO
--WHERE 
-- PA.IPCODPACI='1000659251'
