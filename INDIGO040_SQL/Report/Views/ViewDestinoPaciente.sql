-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewDestinoPaciente
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--select *,INDAUDFOR from dbo.HCHISPACA where INDAUDFOR!=0
--select * from dbo.HCURGING1 where NUMINGRES='66278'
CREATE VIEW Report.ViewDestinoPaciente as 

SELECT 
B.IPCODPACI AS [IDENTIFICACION PACIENTE],
PAC.IPNOMCOMP AS PACIENTE,
B.NUMINGRES AS INGRESO,
A.TRIAGECLA AS [CLASIFICACION DE TRIAGE],
A.TRIAFECHA AS [FECHA DE TRIAGE],
CASE B.INDICAPAC WHEN 1 THEN 'Trasladar a Urgencias'
				 WHEN 2 THEN 'Trasladar a Observacion Urgencias'
				 WHEN 3 THEN 'Trasladar a Hospitalizacion'
				 WHEN 4 THEN 'Trasladar a UCI Adulto'
				 WHEN 5 THEN 'Trasladar a UCI Pediatrica'
				 WHEN 6 THEN 'Trasladar a UCI Neonatal'
				 WHEN 7 THEN 'Trasladar a Consulta Externa'
				 WHEN 8 THEN 'Trasladar a Cirugia'
				 WHEN 9 THEN 'Hospitalizacion en Casa'
				 WHEN 10 THEN 'Referencia'
				 WHEN 11 THEN 'Morgue' 
				 WHEN 12 THEN 'Salida' 
				 WHEN 13 THEN 'Continua en la Unidad' 
				 WHEN 15 THEN 'Retiro Voluntario' 
				 WHEN 16 THEN 'Fuga' END AS DESTINO,
B.FECINIATE AS [FECHA INICIAL ATENCIÓN]
FROM 
dbo.HCURGING1 B INNER JOIN
dbo.INPACIENT PAC ON B.IPCODPACI=PAC.IPCODPACI LEFT JOIN
dbo.ADTRIAGEU A ON B.NUMINGRES=A.NUMINGRES AND CAST(B.NUMEFOLIO AS INT)=(SELECT MIN(CAST(C.NUMEFOLIO AS INT)) FROM dbo.HCURGING1 C WHERE A.NUMINGRES=C.NUMINGRES)
WHERE CAST(B.FECINIATE AS DATE)=CAST(GETDATE() AS DATE)


-- SELECT * FROM dbo.ADTRIAGEU WHERE NUMINGRES=65863          
