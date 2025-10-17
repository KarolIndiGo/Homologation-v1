-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TRIAGE5_HORA
-- Extracted by Fabric SQL Extractor SPN v3.9.0













CREATE VIEW [Report].[View_HDSAP_TRIAGE5_HORA]
AS
SELECT        T.IPCODPACI AS Id, C.IPCODPACI AS IdCtrol, T.NUMINGRES, C.IPNOMCOMP AS NombrePaciente, T.TRIAFECHA AS Fecha, T.TRIAGEDAD AS Edad, 
                         CASE WHEN T .TRIUNIEDA = 1 THEN 'Años' WHEN T .TRIUNIEDA = 2 THEN 'Meses' WHEN T .TRIUNIEDA = 3 THEN 'Días' END AS UnidadEdad, 
                         T.TRIAGECLA AS Clasificación,  CONVERT(VARCHAR(10), C.IPFECLLEGA, 23) AS FechaLlegada,
                         CONVERT(VARCHAR(8), C.IPFECLLEGA, 108) AS HoraLlegada, T.TRIAFECHA FechaTriage,
						  datediff(minute,C.IPFECLLEGA, T.TRIAFECHA) AS MinutosLlegadaVSTriage,
                         CASE WHEN T .TRIAGECLA = 1 THEN 'Emergencia' WHEN T .TRIAGECLA = 2 THEN 'Urgencia Médica' WHEN T .TRIAGECLA = 3 THEN 'Urgencia Diferida' WHEN T .TRIAGECLA
                          = 4 THEN 'No Urgente' END AS Descripción, T.CODPROSAL AS CódigoMD, P.NOMMEDICO AS Médico, C.UFUCODIGO AS UnidadF, 
                         UF.UFUDESCRI AS UnidadFuncional, INM.MUNNOMBRE Municipio, case inp.IPSEXOPAC when 1 then 'Masculino' when 2 then 'Femenino' else 'Otro' end Sexo,
						 ine.NOMENTIDA Entidad
FROM                     ADTRIAGEU AS T INNER JOIN
                         ADINGRESO AD ON AD.NUMINGRES = T.NUMINGRES INNER JOIN 
                         INPROFSAL AS P ON T.CODPROSAL = P.CODPROSAL LEFT OUTER JOIN
                         ADCONTURG AS C ON T.CODCONCEC = C.CODCONCEC INNER JOIN
                         INUNIFUNC AS UF ON C.UFUCODIGO = UF.UFUCODIGO INNER JOIN
                         INPACIENT INP ON  T.IPCODPACI = INP.IPCODPACI inner join 
						 INENTIDAD ine on ine.CODENTIDA = inp.CODENTIDA

						 INNER JOIN INUBICACI UBI ON UBI.AUUBICACI = INP.AUUBICACI
                         INNER JOIN INMUNICIP INM ON INM.DEPMUNCOD = UBI.DEPMUNCOD
  

