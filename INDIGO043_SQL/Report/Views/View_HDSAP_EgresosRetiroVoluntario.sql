-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_EgresosRetiroVoluntario
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_EGRESOSRETIROVOLUNTARIO]
AS


SELECT i.IFECHAING AS FechaIngreso, 
       F.UFUDESCRI AS UnidadFuncional,
       HC.IPCODPACI AS Identificacion, 
       PA.IPNOMCOMP AS Nombre, 
       (CAST(DATEDIFF(dd, PA.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS Edad,
	   CASE when (CAST(DATEDIFF(dd, PA.IPFECNACI, GETDATE()) / 365.25 AS INT)) between 0 and 5 	     
	   then 'Primera Infancia'
	   when (CAST(DATEDIFF(dd, PA.IPFECNACI, GETDATE()) / 365.25 AS INT)) between 6 and 11 	     
	   then 'Infancia'
	   when (CAST(DATEDIFF(dd, PA.IPFECNACI, GETDATE()) / 365.25 AS INT)) between 12 and 18	     
	   then 'Adolecencia'
	   when (CAST(DATEDIFF(dd, PA.IPFECNACI, GETDATE()) / 365.25 AS INT)) between 19 and 26	     
	   then 'Juventud'
	   when (CAST(DATEDIFF(dd, PA.IPFECNACI, GETDATE()) / 365.25 AS INT)) between 27 and 59	     
	   then 'Adulto'
	   else 'Vejez'	   
	   end AS 'Grupo Etario',
       CASE PA.IPSEXO
           WHEN 'H'
           THEN 'Masculino'
           WHEN 'M'
           THEN 'Femenino'
       END AS Sexo, 
       HC.CODDIAGNO AS CodigoDiagnostico, 
       DI.NOMDIAGNO AS NombreDiagnostico,
	   M.MUNNOMBRE AS Municipio,
	   hc.FECHISPAC AS FechaEgreso,
	   CASE hc.INDICAPAC
	       WHEN 1 
		   THEN 'Trasladar a Urgencias: Solo consulta externa' 
		   WHEN 2 
		   THEN 'Trasladar a Observacion Urgencias: solo Urgencias '
		   WHEN 3
		   THEN 'Trasladar a Hospitalizacion: Dif Misma Unidad'
		   WHEN 4
		   THEN 'Trasladar a UCI Adulto: Dif Misma Unidad'
		   WHEN 5
		   THEN 'Trasladar a UCI Pediatrica: Dif Misma Unidad'
		   WHEN 6
		   THEN 'Trasladar a UCI Neonatal: Dif Misma Unidad'
		   WHEN 7
		   THEN 'Trasladar a Consulta Externa: Dif Misma Unidad'
		   WHEN 8
		   THEN 'Trasladar a Cirugia: Dif Misma Unidad'
		   WHEN 9
		   THEN 'Hospitalizacion en Casa'
		   WHEN 10
		   THEN 'Referencia'
		   WHEN 11
		   THEN 'Morgue'
		   WHEN 12
		   THEN 'Salida'
		   WHEN 13
		   THEN 'Continua en la Unidad'
		   WHEN 14
		   THEN 'Paciente en Tratamiento'
		   WHEN 15
		   THEN 'Retiro Voluntario'
		   WHEN 16
		   THEN 'Fuga'
		   WHEN 17
		   THEN 'Salida Parcial'
		   WHEN 18
		   THEN 'Estancia Con la Madre'
		   WHEN 19
		   THEN 'U.Cuidado Intermedio'
		   WHEN 20
		   THEN 'U.Basica'
		   WHEN 21
		   THEN 'No Aplica' 
		END AS Destino,
		CASE D.TRIAGECLA
		WHEN 1
		THEN 'TRIAGE 1'
		WHEN 2
		THEN 'TRIAGE 2'
		WHEN 3
		THEN 'TRIAGE 3'
		WHEN 4
		THEN 'TRIAGE 4'
		WHEN 5
		THEN 'TRIAGE 5'
		END TRIAGE,
		INE.DESESPECI
FROM dbo.HCHISPACA AS HC
     INNER JOIN .ADINGRESO AS I ON I.NUMINGRES = HC.NUMINGRES
     INNER JOIN .INPACIENT AS PA ON PA.IPCODPACI = HC.IPCODPACI
     INNER JOIN .INDIAGNOS AS DI ON DI.CODDIAGNO = HC.CODDIAGNO
	 INNER JOIN .INUBICACI AS U ON U.AUUBICACI=PA.AUUBICACI
	 INNER JOIN .INMUNICIP AS M ON M.DEPMUNCOD=U.DEPMUNCOD
	 INNER JOIN .INUNIFUNC AS F ON F.UFUCODIGO=HC.UFUCODIGO
	 INNER JOIN .ADTRIAGEU AS D ON D.NUMINGRES = HC.NUMINGRES
	 INNER JOIN .INESPECIA AS INE ON INE.CODESPECI = HC.CODESPTRA
	 where HC.INDICAPAC = 15




