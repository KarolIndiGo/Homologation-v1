-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewResolucion1552
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre: [Report].[ViewResolucion1552]
Tipo:Vista
Observacion:Resolución 1552
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:03-05-2023
Ovservaciones:Se corrigen los campos de hubicacion del centro de atención, ya que estaban quemados en el codigo, y se crea CTE de ubicación, segun ticket 9556
--------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Observacion:Se agrega la tabla dbo.ADTIPOIDENTIFICA, para los tipos de identificación
Fecha:24-11-2023
*****************************************************************************************************************************/

CREATE View [Report].[ViewResolucion1552] as

WITH 
CTE_UBICACION AS
(
	SELECT 
	UBI.DEPMUNCOD,
	MUN.MUNNOMBRE,
	DEP.nomdepart
	FROM
	dbo.INUBICACI UBI INNER JOIN 
	dbo.INMUNICIP MUN ON UBI.DEPMUNCOD=MUN.DEPMUNCOD INNER JOIN
	dbo.INDEPARTA DEP ON MUN.DEPCODIGO=DEP.depcodigo
	GROUP BY UBI.DEPMUNCOD,	MUN.MUNNOMBRE,DEP.nomdepart
)

Select 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
AGE.CODAUTONU AS [Id Agenda],
pac.IPNOMCOMP As [Nombres y Apellidos Completos],
--CASE PAC.IPTIPODOC WHEN '1'  THEN 'CEDULA DE CIUDADANIA'
--					WHEN '2'  THEN 'CEDULA DE EXTRANJERIA'
--					WHEN '3'  THEN 'TARJETA DE IDENTIDAD'
--					WHEN '4'  THEN 'REGISTRO CIVIL'
--					WHEN '5'  THEN 'PASAPORTE'
--					WHEN '6'  THEN 'ADULTO SIN IDENTIFICACION'
--					WHEN '7'  THEN 'MENOR SIN IDENTIFICACION'
--					WHEN '8'  THEN 'NUMERO UNICO DE IDENTIFICACIÒN'
--					WHEN '9'  THEN 'CERTIFICADO NACIDO VIVO'
--					WHEN '10' THEN 'CARNET DIPLOMATICO'
--					WHEN '11' THEN 'SALVOCONDUCTO'
--					WHEN '12' THEN 'PERMISO ESPECIAL DE PERMANENCIA'
--					WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
--					WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
--					WHEN '15' THEN 'SIN IDENTIFICACION'
--					END AS 'Tipo Documento',
 DOC.NOMBRE AS [Tipo Documento],
 PAC.IPCODPACI AS [Numero de Identificacion],
 DEP.nomdepart AS Departamento,
 MUN.MUNNOMBRE AS Municipio,
 ISNULL(PAC.IPTELMOVI,PAC.IPTELEFON) AS Telefono,
 CAST(Age.FECREGSIS AS DATE) AS [Fecha solicitud cita],
 CAST(Age.FECHAOFERTADA AS DATE) AS [Fecha Asignada],
 CAST(Age.FECHORAIN AS DATE) AS [Fecha confirmada],
ISNULL(ESP.[CodEspeciaHomologo REPS],INE.CODESPECI) AS [Codigo Servicio solicitado],
ISNULL(ESP.[EspecialidadHomologo REPS],INE.DESESPECI) AS [Servicio solicitado],
UBIC.MUNNOMBRE AS [Depart Munic],
EMP.INDNITEMP AS [Nit],
 Ct.CODIPSSEC AS [Codigo],
 Ct.NOMCENATE AS [Razon Social],
 1 AS [Numero de Citas],
 DATEDIFF(day,Age.FECREGSIS,Age.FECHORAIN) as [Dias Citas Registro vs Asignada],
 DATEDIFF(DAY,Age.FECHAOFERTADA,Age.FECHORAIN) AS [Dias Citas Ofertada vs Asignada],
 ENT.NOMENTIDA AS [ENTIDAD DEL PACIENTE],
 CAST(Age.FECREGSIS AS DATE) AS 'FECHA BUSQUEDA', 
 YEAR(Age.FECREGSIS) AS 'AÑO BUSQUEDA',
 MONTH(Age.FECREGSIS) AS 'MES BUSQUEDA',
 CONCAT(FORMAT(MONTH(Age.FECREGSIS), '00') ,' - ', 
	   CASE MONTH(Age.FECREGSIS) 
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
 dbo.INPACIENT As PAC
 INNER JOIN dbo.INUBICACI UBI ON PAC.AUUBICACI=UBI.AUUBICACI
 INNER JOIN dbo.INMUNICIP MUN ON UBI.DEPMUNCOD=MUN.DEPMUNCOD
 INNER JOIN dbo.INDEPARTA DEP ON MUN.DEPCODIGO=DEP.depcodigo
 INNER JOIN dbo.AGASICITA As Age ON pac.IPCODPACI=Age.IPCODPACI
 INNER JOIN dbo.ADCENATEN AS Ct ON  Age.CODCENATE=Ct.CODCENATE
 INNER JOIN dbo.INENTIDAD ENT ON PAC.CODENTIDA=ENT.CODENTIDA
 INNER JOIN CTE_UBICACION UBIC ON CT.DEPMUNCOD=UBIC.DEPMUNCOD
 INNER JOIN dbo.INESPECIA INE ON AGE.CODESPECI=INE.CODESPECI
 /*IN V3*/INNER JOIN dbo.ADTIPOIDENTIFICA DOC ON PAC.IPTIPODOC=DOC.CODIGO/*FN V3*/
 INNER JOIN dbo.INEMPRESU EMP ON EMP.INDCODDGH=DB_NAME()
 LEFT JOIN Report.HomologoEspecialidades ESP ON AGE.CODESPECI=ESP.CodEspecia
 WHERE 
  AGE.CODESTCIT=1 AND AGE.CODESPECI IS NOT NULL
