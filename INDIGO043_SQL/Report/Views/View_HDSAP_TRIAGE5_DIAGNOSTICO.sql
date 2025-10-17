-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TRIAGE5_DIAGNOSTICO
-- Extracted by Fabric SQL Extractor SPN v3.9.0









CREATE VIEW [Report].[View_HDSAP_TRIAGE5_DIAGNOSTICO]
AS
SELECT        T.IPCODPACI AS Id, C.IPCODPACI AS IdCtrol, T.NUMINGRES, C.IPNOMCOMP AS NombrePaciente, T.TRIAFECHA AS Fecha, T.TRIAGEDAD AS Edad, 
                         CASE WHEN T .TRIUNIEDA = 1 THEN 'Años' WHEN T .TRIUNIEDA = 2 THEN 'Meses' WHEN T .TRIUNIEDA = 3 THEN 'Días' END AS UnidadEdad, 
                         T.TRIAGECLA AS Clasificación, C.IPFECLLEGA LlegadaAdmision, T.TRIAFECHA FechaTriage, DIAG.CODDIAGNO CodigoDiagnosticoIngreso, diag.NOMDIAGNO DiagnosticoIngreso,
						 diag1.CODDIAGNO CodigoDiagnosticoEgreso, diag1.NOMDIAGNO DiagnosticoEgreso,
						  datediff(minute,C.IPFECLLEGA, T.TRIAFECHA) AS MinutosLlegadaVSTriage,
                         CASE WHEN T .TRIAGECLA = 1 THEN 'Emergencia' WHEN T .TRIAGECLA = 2 THEN 'Urgencia Médica' WHEN T .TRIAGECLA = 3 THEN 'Urgencia Diferida' WHEN T .TRIAGECLA
                          = 4 THEN 'No Urgente' END AS Descripción, T.CODPROSAL AS CódigoMD, P.NOMMEDICO AS Médico, C.UFUCODIGO AS UnidadF, 
                         UF.UFUDESCRI AS UnidadFuncional
FROM                     ADTRIAGEU AS T INNER JOIN
                         ADINGRESO AD ON AD.NUMINGRES = T.NUMINGRES INNER JOIN 
                         INPROFSAL AS P ON T.CODPROSAL = P.CODPROSAL LEFT OUTER JOIN
                         ADCONTURG AS C ON T.CODCONCEC = C.CODCONCEC INNER JOIN
						 INDIAGNOS AS DIAG on DIAG.CODDIAGNO = AD.CODDIAING left JOIN 
						 INDIAGNOS AS DIAG1 ON DIAG1.CODDIAGNO = AD.CODDIAEGR JOIN
                         INUNIFUNC AS UF ON C.UFUCODIGO = UF.UFUCODIGO INNER JOIN
                         INPACIENT ON T.IPCODPACI = INPACIENT.IPCODPACI
  

