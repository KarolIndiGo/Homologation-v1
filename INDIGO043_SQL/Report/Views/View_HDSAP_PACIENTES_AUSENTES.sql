-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PACIENTES_AUSENTES
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_PACIENTES_AUSENTES]
AS

SELECT        T.IPCODPACI AS Documento, C.IPCODPACI AS IdCtrol, T.NUMINGRES, C.IPNOMCOMP AS NombrePaciente, C.IPFECLLEGA AS Fecha1, T.TRIAFECHA AS Fecha2, 
                         dbo.HCURGING1.FECHINIHI AS FiniAt, H.FECHISPAC AS Fecha3, DATEDIFF(MINUTE, C.IPFECLLEGA, T.TRIAFECHA) AS F1F2, DATEDIFF(MINUTE, 
                         T.TRIAFECHA, H.FECHISPAC) AS F2F3, DATEDIFF(MINUTE, T.TRIAFECHA, dbo.HCURGING1.FECHINIHI) AS FTriagIni, DATEDIFF(MINUTE, C.IPFECLLEGA, 
                         H.FECHISPAC) AS F1F3, DATEDIFF(MINUTE, C.IPFECLLEGA, dbo.HCURGING1.FECHINIHI) AS FllegaIni, T.TRIAGEDAD AS Edad, 
                         CASE WHEN C.CONESTADO = 1 THEN 'Sin Atender' WHEN C.CONESTADO = 2 THEN 'Ausente en Clasificacion TRIAGE' WHEN C.CONESTADO = 3 THEN 'Clasificado sin Ingreso'
                          WHEN C.CONESTADO = 4 THEN 'Clasificado con Ingreso' WHEN C.CONESTADO = 5 THEN 'Atendido' WHEN C.CONESTADO = 6 THEN 'Ausente en Atencion Inicial Urgencias'
                          WHEN C.CONESTADO = 7 THEN 'Anulado por error de Parametrizacion' END AS Estado, 
                         CASE WHEN T .TRIUNIEDA = 1 THEN 'Años' WHEN T .TRIUNIEDA = 2 THEN 'Meses' WHEN T .TRIUNIEDA = 3 THEN 'Días' END AS UnidadEdad, 
                         T.TRIAGECLA AS Clasificación, 
                         CASE WHEN T .TRIAGECLA = 1 THEN 'Emergencia' WHEN T .TRIAGECLA = 2 THEN 'Urgencia Médica' WHEN T .TRIAGECLA = 3 THEN 'Urgencia Diferida' WHEN T .TRIAGECLA
                          = 4 THEN 'No Urgente' END AS Descripción, T.CODPROSAL AS CódigoMD, P.NOMMEDICO AS Médico, C.UFUCODIGO AS UnidadF, 
                         UF.UFUDESCRI AS UnidadFuncional, dbo.HCURGING1.FECINIATE, T.TRIACAUIN AS CausaIngreso
FROM            dbo.ADTRIAGEU AS T LEFT OUTER JOIN
                         dbo.HCHISPACA AS H ON T.IPCODPACI = H.IPCODPACI AND T.NUMINGRES = H.NUMINGRES INNER JOIN
                         dbo.INPROFSAL AS P ON T.CODPROSAL = P.CODPROSAL LEFT OUTER JOIN
                         dbo.ADCONTURG AS C ON T.CODCONCEC = C.CODCONCEC INNER JOIN
                         dbo.INUNIFUNC AS UF ON C.UFUCODIGO = UF.UFUCODIGO INNER JOIN
                         dbo.INPACIENT ON T.IPCODPACI = dbo.INPACIENT.IPCODPACI INNER JOIN
                         dbo.HCURGING1 ON H.NUMEFOLIO = dbo.HCURGING1.NUMEFOLIO AND H.NUMINGRES = dbo.HCURGING1.NUMINGRES AND 
                         H.IPCODPACI = dbo.HCURGING1.IPCODPACI


