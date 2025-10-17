-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_URGENCIASTRIAGE_Y
-- Extracted by Fabric SQL Extractor SPN v3.9.0









CREATE VIEW [Report].[View_HDSAP_URGENCIASTRIAGE_Y]
AS




SELECT 'TIPO DE IDENTIFICACION' = CASE INP.IPTIPODOC
		WHEN 1 THEN 'Cédula de Ciudadanía'
		WHEN 2 THEN 'Cédula de Extranjería'
		WHEN 3 THEN 'Tarjeta de Identidad'
		WHEN 4 THEN 'Registro Civil'
		WHEN 5 THEN 'Pasporte'
		WHEN 6 THEN' Adulto Sin Identificación'
		ELSE 'Menor Sin Identificación'
		END,
		CAST(INP.IPFECNACI AS date) AS 'FECHA DE NACIMIENTO',
        'SEXO PACIENTE'= CASE INP.IPSEXOPAC
         WHEN 1 THEN 'HOMBRE'
		 WHEN 2 THEN 'MUJER'
         ELSE 'INDEFINIDO'
		 end ,
		INP.IPPRIAPEL AS 'PRIMER APELLIDO',
		INP.IPSEGAPEL as 'SEGUNDO APELLIDO',
		INP.IPPRINOMB as 'PRIMER NOMBRE',
		INP.IPSEGNOMB as 'SEGUNDO NOMBRE',
		CONCAT(INE.CODENTIDA,  INE.NOMENTIDA ) AS 'NOMBRE DE LA EAPB',
	   T.IPCODPACI AS Documento, 
       C.IPCODPACI AS IdControl, 
	   cast(T.TRIAFECHA as date) AS 'Clasificacion triage fecha',
       convert(varchar, T.TRIAFECHA, 108) AS 'Clasificacion triage hora', 
       cast(dbo.HCURGING1.FECHINIHI as date) AS 'Fecha consulta',
	   CONVERT(VARCHAR, dbo.HCURGING1.FECHINIHI, 108)'Hora consulta',
       C.IPFECLLEGA AS 'ArriboUrgencias(F1)', 
       T.TRIAFECHA AS 'Triage(F2)', 
       dbo.HCURGING1.FECHINIHI AS 'LlamadoConsulta(F3)', 
       H.FECHISPAC AS 'FinConsulta(F4)', 
       t2.fecha AS 'Revaloracion(F5)', 
       DATEDIFF(MINUTE, C.IPFECLLEGA, T.TRIAFECHA) AS 'F1-F2', 
       DATEDIFF(MINUTE, T.TRIAFECHA, H.FECHISPAC) AS 'F2-F4', 
       DATEDIFF(MINUTE, T.TRIAFECHA, dbo.HCURGING1.FECHINIHI) AS 'F2-F3', 
       DATEDIFF(MINUTE, C.IPFECLLEGA, H.FECHISPAC) AS 'F1-F4', 
       DATEDIFF(MINUTE, C.IPFECLLEGA, dbo.HCURGING1.FECHINIHI) AS 'F1-F3', 
	   DATEDIFF(MINUTE, H.FECHISPAC, t2.fecha) AS 'F4-F5',
       T.TRIAGEDAD AS Edad,
       CASE
           WHEN C.CONESTADO = 1
           THEN 'Sin Atender'
           WHEN C.CONESTADO = 2
           THEN 'Ausente en Clasificacion TRIAGE'
           WHEN C.CONESTADO = 3
           THEN 'Clasificado sin Ingreso'
           WHEN C.CONESTADO = 4
           THEN'Clasificado con Ingreso'
           WHEN C.CONESTADO = 5
           THEN 'Atendido'
           WHEN C.CONESTADO = 6
           THEN 'Ausente en Atencion Inicial Urgencias'
           WHEN C.CONESTADO = 7
           THEN 'Anulado por error de Parametrizacion'
       END AS Estado,
       CASE
           WHEN T.TRIUNIEDA = 1
           THEN 'Años'
           WHEN T.TRIUNIEDA = 2
           THEN 'Meses'
           WHEN T.TRIUNIEDA = 3
           THEN 'Días'
       END AS UnidadEdad, 
       T.TRIAGECLA AS Clasificación,
       CASE
           WHEN T.TRIAGECLA = 1
           THEN 'Emergencia'
           WHEN T.TRIAGECLA = 2
           THEN 'Urgencia Médica'
           WHEN T.TRIAGECLA = 3
           THEN' Urgencia Diferida'
           WHEN T.TRIAGECLA = 4
           THEN 'No Urgente'
       END AS Descripción, 
       T.CODPROSAL AS CódigoMedicoTriage, 
       P.NOMMEDICO AS NombreMedicoTriage,
	   t2.CODPROSAL AS CodigoMedicoRev,
	   P2.NOMMEDICO AS NombreMedicoReva,
       C.UFUCODIGO AS CodigoUnidad, 
       UF.UFUDESCRI AS UnidadFuncional, 
       dbo.HCURGING1.FECINIATE AS FechaInicioAten, 
       T.TRIACAUIN AS CausaIngreso,
	   INM.MUNNOMBRE Municipio
FROM dbo.ADTRIAGEU AS T
INNER JOIN dbo.INPACIENT AS INP ON INP.IPCODPACI = T.IPCODPACI
INNER JOIN INUBICACI UBI ON UBI.AUUBICACI = INP.AUUBICACI
INNER JOIN INMUNICIP INM ON INM.DEPMUNCOD = UBI.DEPMUNCOD
LEFT JOIN dbo.INENTIDAD AS INE ON INE.CODENTIDA = INP.CODENTIDA 
INNER JOIN Contract.CareGroup AS car ON car.id = INP.GENCAREGROUP 
LEFT OUTER JOIN dbo.HCHISPACA AS H ON T.IPCODPACI = H.IPCODPACI
                                                     AND T.NUMINGRES = H.NUMINGRES
     INNER JOIN dbo.INPROFSAL AS P ON T.CODPROSAL = P.CODPROSAL
     LEFT OUTER JOIN dbo.ADCONTURG AS C ON T.CODCONCEC = C.CODCONCEC
     INNER JOIN dbo.INUNIFUNC AS UF ON C.UFUCODIGO = UF.UFUCODIGO
     INNER JOIN dbo.INPACIENT ON T.IPCODPACI = dbo.INPACIENT.IPCODPACI
     INNER JOIN dbo.HCURGING1 ON H.NUMEFOLIO = dbo.HCURGING1.NUMEFOLIO
                                           AND H.NUMINGRES = dbo.HCURGING1.NUMINGRES
                                           AND H.IPCODPACI = dbo.HCURGING1.IPCODPACI
     LEFT OUTER JOIN
(
    SELECT h.IPCODPACI, 
           h.NUMINGRES,
           h.FECHISPAC AS fecha,
		   h.CODPROSAL
    FROM dbo.HCHISPACA as h
	 INNER join 
	         (
			 select min(FECHISPAC) AS FECHA1,
			        IPCODPACI, 
                    NUMINGRES
			 from dbo.HCHISPACA
			 where TIPHISPAC = 'E' 
			 GROUP by IPCODPACI,
			          NUMINGRES
			 ) as t3 on h.FECHISPAC=t3.FECHA1
			            AND h.IPCODPACI=t3.IPCODPACI
						AND h.NUMINGRES=t3.NUMINGRES
) AS t2 ON T.IPCODPACI = t2.IPCODPACI
           AND T.NUMINGRES = t2.NUMINGRES
	 LEFT JOIN dbo.INPROFSAL AS P2 ON t2.CODPROSAL = P2.CODPROSAL
WHERE c.UFUCODIGO IN(01, 038, 0352,12,037)
     AND (H.TIPHISPAC = 'I')
     AND (dbo.HCURGING1.FECINIATE > CONVERT(DATETIME, '2015-12-31 00:00:00', 102))
  

