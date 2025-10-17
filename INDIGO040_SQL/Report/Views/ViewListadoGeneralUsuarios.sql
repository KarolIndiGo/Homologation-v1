-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewListadoGeneralUsuarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: [Report].[ViewInterConsultationRequests]
Tipo:Vista
Observacion:
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:Nilsson Miguel Galindo
Fecha:02-12-2024
Observaciones:Se agregan los campos de especialidad y unidad funcional, tambien se elimina el CTE_HISTORIA para que la vista mejore en su rendimiento,
			  esto solicitado en el ticket 22777
--------------------------------------
Version 3
Persona que modifico
Observación:
Fecha:
***********************************************************************************************************************************/
CREATE View Report.ViewListadoGeneralUsuarios
AS
--IN V2 WITH CTE_HISTORIA
--AS
--(
--SELECT TOP 1000 *FROM HCHISPACA WHERE INDICAPAC IN (12)
--) FN V2

SELECT
CAST(HIS.FECHISPAC AS DATE) 'FECHA DE BUSQUEDA',
DOC.NOMBRE 'TIPO DE DOCUMENTO',
DEM.IPCODPACI 'ID PACIENTE', 
CASE PAC.IPSEXOPAC WHEN 1 THEN 'Masculino' WHEN 2 THEN 'Femenino' END 'SEXO',
CG.Name AS [GRUPO DE ATENCION], HEA.Name AS [ENTIDAD], 
PAC.IPNOMCOMP 'NOMBRE PACIENTE', HIS.NUMINGRES '# INGRESO',
HIS.FECHISPAC 'FECHA',HIS.NUMEFOLIO 'FOLIO', 
--CASE DEM.ORIGENINSCRIPCION WHEN 1 THEN 'Dashboard RIAS'
--						   WHEN 2 THEN 'Orden de servicios'
--						   WHEN 3 THEN 'Agendamiento' 
--						   WHEN 4 THEN 'Desde la Historia Clinica (Formulario demanda Inducida)'END 'ORIGEN', 
DEM.USUARIO 'COD. USUARIO',
SEG.NOMUSUARI 'USUARIO INDUCE',
HIS.CODDIAGNO 'COD. CIE-10',
DIA.NOMDIAGNO 'DIAGNOSTICO', RIAS.NOMBRE 'RIAS INDUCIDA',
ESP.DESESPECI AS ESPECIALIDAD,
FUN.UFUDESCRI AS [UNIDAD FUNCIONAL]
FROM RIASXPACIENTE DEM
INNER JOIN RIAS RIAS ON RIAS.ID=DEM.IDRIAS
INNER JOIN INPACIENT PAC ON PAC.IPCODPACI = DEM.IPCODPACI
INNER JOIN SEGUSUARU SEG ON SEG.CODUSUARI=DEM.USUARIO
INNER JOIN dbo.ADTIPOIDENTIFICA DOC ON PAC.IPTIPODOC=DOC.CODIGO
--IN V2 INNER JOIN CTE_HISTORIA HIS ON HIS.IPCODPACI=DEM.IPCODPACI
INNER JOIN dbo.HCHISPACA HIS ON HIS.IPCODPACI=DEM.IPCODPACI AND HIS.INDICAPAC IN (12)
INNER JOIN DBO.INPROFSAL PRO ON HIS.CODPROSAL=PRO.CODPROSAL
INNER JOIN DBO.INESPECIA AS ESP ON HIS.CODESPTRA=ESP.CODESPECI /*FN V2*/
INNER JOIN INDIAGNOP DIAP ON DIAP.NUMINGRES = HIS.NUMINGRES AND DIAP.NUMEFOLIO=HIS.NUMEFOLIO AND CODDIAPRI IN (1)
INNER JOIN ADINGRESO ING ON ING.NUMINGRES=HIS.NUMINGRES
LEFT JOIN INDIAGNOS DIA ON DIA.CODDIAGNO=DIAP.CODDIAGNO
LEFT JOIN CONTRACT.HEALTHADMINISTRATOR HEA ON ING.GENCONENTITY=HEA.ID 
LEFT JOIN Contract.CareGroup CG ON ING.GENCAREGROUP =CG.ID
LEFT JOIN DBO.INUNIFUNC FUN ON HIS.UFUCODIGO=FUN.UFUCODIGO
WHERE PAC.IPNOMCOMP NOT LIKE '%PRUEBAS%'

