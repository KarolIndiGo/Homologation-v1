-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewDemandaInducida
-- Extracted by Fabric SQL Extractor SPN v3.9.0


    /*******************************************************************************************************************
Nombre:[Report].ViewDemandaInducida
Tipo:View
Observacion: 
Profesional: 
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:Nilsson Miguel Galindo
Fecha:06-12-2024
Observaciones:Se agrega unidad funcional y especialidad, tambien se supprime CTE que no cumplia ninguna función.
-------------------------------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico:Amira Gil Meneses
Fecha: 22-04-2025
Observaciones: Se adicionan los campos de Edad, Orientación Sexual y Grupo etario. Ticket No. 26334
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewDemandaInducida]
AS

--WITH CTE_HISTORIA
--AS
--(
--SELECT*FROM HCHISPACA WHERE INDICAPAC IN (12)
--)

SELECT 
      CAST(HIS.FECHISPAC AS DATE) 'FECHA DE BUSQUEDA'
     ,DOC.NOMBRE 'TIPO DE DOCUMENTO',DEM.IPCODPACI 'ID PACIENTE' 
     ,CASE PAC.IPSEXOPAC WHEN 1 THEN 'Masculino' WHEN 2 THEN 'Femenino' END 'SEXO'
     ,CG.Name AS [GRUPO DE ATENCION]
     ,HEA.Name AS [ENTIDAD] 
     ,PAC.IPNOMCOMP 'NOMBRE PACIENTE'
     ,CASE PAC.IPORIENTSEXUAL WHEN '1' THEN 'Homosexual'
							  WHEN '2' THEN 'Heterosexual'
							  WHEN '3' THEN 'Bisexual'
							  WHEN '8' THEN 'Otro'
							  WHEN '9' THEN 'No sabe/No informa/No aplica'
	                          END AS 'ORIENTACION SEXUAL'
	 ,DATEDIFF(YEAR, PAC.IPFECNACI, GETDATE()) AS 'EDAD'
	 ,CASE WHEN DATEDIFF(YEAR, PAC.IPFECNACI, GETDATE()) BETWEEN 0 AND 5 THEN 'Primera Infancia'
           WHEN DATEDIFF(YEAR, PAC.IPFECNACI, GETDATE()) BETWEEN 6 AND 11 THEN 'Infancia'
           WHEN DATEDIFF(YEAR, PAC.IPFECNACI, GETDATE()) BETWEEN 12 AND 17 THEN 'Adolescencia'
           WHEN DATEDIFF(YEAR, PAC.IPFECNACI, GETDATE()) BETWEEN 18 AND 28 THEN 'Juventud'
           WHEN DATEDIFF(YEAR, PAC.IPFECNACI, GETDATE()) BETWEEN 29 AND 59 THEN 'Adultez'
           WHEN DATEDIFF(YEAR, PAC.IPFECNACI, GETDATE()) >= 60 THEN 'Vejez'
           ELSE 'Edad no válida' END AS [GRUPO ETARIO]
     ,HIS.NUMINGRES '# INGRESO'
	 ,HIS.FECHISPAC 'FECHA'
     ,HIS.NUMEFOLIO 'FOLIO'
     ,CASE DEM.ORIGENINSCRIPCION WHEN 1 THEN 'Dashboard RIAS'
     						   WHEN 2 THEN 'Orden de servicios'
     						   WHEN 3 THEN 'Agendamiento' 
     						   WHEN 4 THEN 'Desde la Historia Clinica (Formulario demanda Inducida)'END 'ORIGEN' 
     ,DEM.USUARIO 'COD. USUARIO'
     ,NOMUSUARI 'USUARIO INDUCE'
     ,HIS.CODDIAGNO 'COD. CIE-10'
     ,DIA.NOMDIAGNO 'DIAGNOSTICO'
     ,RIAS.NOMBRE 'CANALIZACIÓN RIAS'
     ,ESP.DESESPECI AS ESPECIALIDAD
     ,FUN.UFUDESCRI AS [UNIDAD FUNCIONAL]
FROM RIASXPACIENTE DEM
     INNER JOIN RIAS RIAS 
		ON RIAS.ID=DEM.IDRIAS
     INNER JOIN INPACIENT PAC 
		ON PAC.IPCODPACI = DEM.IPCODPACI
     INNER JOIN SEGUSUARU SEG 
		ON SEG.CODUSUARI=DEM.USUARIO
     INNER JOIN dbo.ADTIPOIDENTIFICA DOC 
		ON PAC.IPTIPODOC=DOC.CODIGO
     INNER JOIN HCHISPACA HIS 
		ON HIS.IPCODPACI=DEM.IPCODPACI 
		AND HIS.INDICAPAC IN (12)
     INNER JOIN INDIAGNOP DIAP 
		ON DIAP.NUMINGRES = HIS.NUMINGRES 
		AND DIAP.NUMEFOLIO=HIS.NUMEFOLIO 
		AND CODDIAPRI IN (1)
     INNER JOIN ADINGRESO ING 
		ON ING.NUMINGRES=HIS.NUMINGRES
     LEFT JOIN dbo.INPROFSAL PRO 
		ON HIS.CODPROSAL=PRO.CODPROSAL
     LEFT JOIN dbo.INESPECIA ESP 
		ON PRO.CODESPEC1=ESP.CODESPECI
     LEFT JOIN INDIAGNOS DIA 
		ON DIA.CODDIAGNO=DIAP.CODDIAGNO
     LEFT JOIN dbo.INUNIFUNC FUN 
		ON HIS.UFUCODIGO=FUN.UFUCODIGO
     LEFT JOIN CONTRACT.HEALTHADMINISTRATOR HEA 
		ON ING.GENCONENTITY=HEA.ID 
     LEFT JOIN Contract.CareGroup CG 
		ON ING.GENCAREGROUP =CG.ID 
WHERE PAC.IPNOMCOMP NOT LIKE '%PRUEBAS%'
       
