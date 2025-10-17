-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_EUTRIAGE_GINECO
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_EUTRIAGE_GINECO]
AS


SELECT        T.IPCODPACI AS Documento, C.IPCODPACI AS IdControl, T.NUMINGRES AS Ingreso, C.IPNOMCOMP AS NombrePaciente, C.IPFECLLEGA AS [ArriboUrgencias(F1)], T.TRIAFECHA AS [Triage(F2)], 
                         dbo.HCURGING1.FECHINIHI AS [LlamadoConsulta(F3)], H.FECHISPAC AS [FinConsulta(F4)], t2.fecha AS [Revaloracion(F5)], DATEDIFF(MINUTE, C.IPFECLLEGA, T.TRIAFECHA) AS [F1-F2], DATEDIFF(MINUTE, 
                         T.TRIAFECHA, H.FECHISPAC) AS [F2-F4], DATEDIFF(MINUTE, T.TRIAFECHA, dbo.HCURGING1.FECHINIHI) AS [F2-F3], DATEDIFF(MINUTE, H.FECHISPAC, dbo.HCURGING1.FECHINIHI) AS [F4-F3], 
                         DATEDIFF(MINUTE, C.IPFECLLEGA, H.FECHISPAC) AS [F1-F4], DATEDIFF(MINUTE, C.IPFECLLEGA, dbo.HCURGING1.FECHINIHI) AS [F1-F3], DATEDIFF(MINUTE, H.FECHISPAC, t2.fecha) AS [F4-F5], 
                         T.TRIAGEDAD AS Edad, 
                         CASE WHEN C.CONESTADO = 1 THEN 'Sin Atender' WHEN C.CONESTADO = 2 THEN 'Ausente en Clasificacion TRIAGE' WHEN C.CONESTADO = 3 THEN 'Clasificado sin Ingreso' WHEN C.CONESTADO = 4 THEN 'Clasificado con Ingreso'
                          WHEN C.CONESTADO = 5 THEN 'Atendido' WHEN C.CONESTADO = 6 THEN 'Ausente en Atencion Inicial Urgencias' WHEN C.CONESTADO = 7 THEN 'Anulado por error de Parametrizacion' END AS Estado, 
                         CASE WHEN T .TRIUNIEDA = 1 THEN 'Años' WHEN T .TRIUNIEDA = 2 THEN 'Meses' WHEN T .TRIUNIEDA = 3 THEN 'Días' END AS UnidadEdad, T.TRIAGECLA AS Clasificación, 
                         CASE WHEN T .TRIAGECLA = 1 THEN 'Emergencia' WHEN T .TRIAGECLA = 2 THEN 'Urgencia Médica' WHEN T .TRIAGECLA = 3 THEN 'Urgencia Diferida' WHEN T .TRIAGECLA = 4 THEN 'No Urgente' END AS Descripción, 
                         T.CODPROSAL AS CódigoMedicoTriage, P.NOMMEDICO AS NombreMedicoTriage, t2.CODPROSAL AS CodigoMedicoRev, P2.NOMMEDICO AS NombreMedicoReva, HCURGING1.CODPROSAL AS CodigoMedico, P.NOMMEDICO MedicoConsulta , C.UFUCODIGO AS CodigoUnidad, 
                         UF.UFUDESCRI AS UnidadFuncional, dbo.HCURGING1.FECINIATE AS FechaInicioAten, T.TRIACAUIN AS CausaIngreso
FROM            dbo.ADTRIAGEU AS T LEFT OUTER JOIN
                         dbo.HCHISPACA AS H ON T.IPCODPACI = H.IPCODPACI AND T.NUMINGRES = H.NUMINGRES INNER JOIN
                         dbo.INPROFSAL AS P ON T.CODPROSAL = P.CODPROSAL LEFT OUTER JOIN
                         dbo.ADCONTURG AS C ON T.CODCONCEC = C.CODCONCEC INNER JOIN
                         dbo.INUNIFUNC AS UF ON C.UFUCODIGO = UF.UFUCODIGO INNER JOIN
                         dbo.INPACIENT ON T.IPCODPACI = dbo.INPACIENT.IPCODPACI INNER JOIN
                         dbo.HCURGING1 ON H.NUMEFOLIO = dbo.HCURGING1.NUMEFOLIO AND H.NUMINGRES = dbo.HCURGING1.NUMINGRES AND 
                         H.IPCODPACI = dbo.HCURGING1.IPCODPACI and HCURGING1.CODPROSAL = P.CODPROSAL LEFT OUTER JOIN
                             (SELECT        h.IPCODPACI, h.NUMINGRES, h.FECHISPAC AS fecha, h.CODPROSAL
                               FROM            dbo.HCHISPACA AS h INNER JOIN
                                                             (SELECT        MIN(FECHISPAC) AS FECHA1, IPCODPACI, NUMINGRES
                                                               FROM            dbo.HCHISPACA
                                                               WHERE        (TIPHISPAC = 'E')
                                                               GROUP BY IPCODPACI, NUMINGRES) AS t3 ON h.FECHISPAC = t3.FECHA1 AND h.IPCODPACI = t3.IPCODPACI AND h.NUMINGRES = t3.NUMINGRES) AS t2 ON T.IPCODPACI = t2.IPCODPACI AND 
                         T.NUMINGRES = t2.NUMINGRES LEFT OUTER JOIN
					     dbo.INPROFSAL AS P2 ON t2.CODPROSAL = P2.CODPROSAL
WHERE         (H.TIPHISPAC = 'I') AND (dbo.HCURGING1.FECINIATE > CONVERT(DATETIME, '2015-12-31 00:00:00', 102))
  

