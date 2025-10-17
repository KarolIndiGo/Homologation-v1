-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_REFERENCIARECIBIDAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0









CREATE VIEW [Report].[View_HDSAP_REFERENCIARECIBIDAS]
AS
		SELECT distinct   Pa.IPPRINOMB AS PrimerNombre,pa.IPSEGNOMB SegundoNombre, pa.IPPRIAPEL PrimerApellido, pa.IPSEGAPEL SegundoApellido,
CASE pa.IPTIPODOC
                             WHEN '1'
                             THEN 'CC'
                             WHEN '2'
                             THEN 'CE '
                             WHEN '3'
                             THEN 'TI'
                             WHEN '4'
                             THEN 'RC'
                             WHEN '5'
                             THEN 'PA'
                             WHEN '6'
                             THEN 'AS'
                             WHEN '7'
                             THEN 'MS'
                             WHEN '8'
                             THEN 'NU'
							 WHEN '9'
							 THEN 'CN'
							 WHEN '11'
							 THEN 'SC'
							 WHEN '12'
							 THEN 'PE'
							 WHEN '13'
							 THEN 'PT'
							 WHEN '14'
							 THEN 'DE'
							 WHEN '15'
							 THEN 'SI'
                         END AS 'Tipo Documento',
Pa.IPCODPACI AS Identificación,
L.MUNNOMBRE AS MunicipioProcedencia,
 CASE WHEN IPTIPOPAC = '1' THEN 'Contributivo' WHEN IPTIPOPAC = '2' THEN 'Subsidiado' WHEN IPTIPOPAC = '3' THEN 'Vinculado' WHEN IPTIPOPAC = '4' THEN 'Particular' WHEN IPTIPOPAC = '5' THEN 'Otro' WHEN
 IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo' WHEN IPTIPOPAC = '7' THEN 'Desplazado reg Subsidiado' WHEN IPTIPOPAC = '8' THEN 'Desplazado no Asegurado' END AS 'TipoRegimen',
case pa.IPSEXOPAC
when 1
then 'Masculino'
when 2
then 'Femenino'
end Sexo,
     (CAST(DATEDIFF(dd, PA.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS 'Edad',
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
pa.IPFECNACI as 'fecha nacimiento',DATEDIFF(YEAR,Pa.IPFECNACI,I.IFECHAING) AS EdadAños, 

i.IFECHAING AS FechaIngreso, 
 CONVERT(CHAR(10), i.IFECHAING,103) AS FechaIngr,
 CONVERT(CHAR(5), i.IFECHAING,108) AS Hora,
                         RTRIM(A.NOMENTIDA) AS 'Entidad', RTRIM(E.DESESPECI) AS Especialidad,  RTRIM(I.AIPSREMIS) AS 'CODIGO IPS REMITE',IP.DSCRIPIPS AS 'NOMBRE IPS REMITE'
						 ,I.CODDIAING AS 'DIAGNOSTICO INGRESO'
						 ,RTRIM(d.NOMDIAGNO) as 'Nombre Diagnostico'
						 , CASE WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, 
                         i.IFECHAING)) >= 1 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 4) THEN 'Entre 1 y 4' WHEN ((datediff(YY, IPFECNACI, i.IFECHAING)) >= 5 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 14) 
                         THEN 'Entre 5 y 14' WHEN ((datediff(YY, IPFECNACI, i.IFECHAING)) >= 15 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 44) THEN 'Entre 15 y 44' WHEN ((datediff(YY, IPFECNACI, i.IFECHAING)) >= 45 AND 
                         (datediff(YY, IPFECNACI, i.IFECHAING)) <= 59) THEN 'Entre 45 y 59' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 60 THEN 'Mayores de 60' END AS GrupoEtario1, CASE WHEN ((datediff(YY, IPFECNACI, 
                         i.IFECHAING)) < 1) THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, i.IFECHAING)) >= 1 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 4) THEN 'Entre 1 y 4' WHEN ((datediff(YY, IPFECNACI, 
                         i.IFECHAING)) >= 5 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 9) THEN 'Entre 5 y 9' WHEN ((datediff(YY, IPFECNACI, i.IFECHAING)) >= 10 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 14) 
                         THEN 'Entre 10 y 14' WHEN ((datediff(YY, IPFECNACI, i.IFECHAING)) >= 15 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 19) THEN 'Entre 15 y 19' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 20 AND 
                         (datediff(YY, IPFECNACI, i.IFECHAING)) <= 24 THEN 'Entre 20 y 24' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 25 AND (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         <= 29 THEN 'Entre 25 y 29' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 30 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 34 THEN 'Entre 30 y 34' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         >= 35 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 39 THEN 'Entre 35 y 39' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 40 AND (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         <= 44 THEN 'Entre 40 y 44' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 45 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 49 THEN 'Entre 45 y 49' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         >= 50 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 54 THEN 'Entre 50 y 54' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 55 AND (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         <= 59 THEN 'Entre 55 y 59' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 60 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 64 THEN 'Entre 60 y 64' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         >= 65 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 69 THEN 'Entre 65 y 69' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 70 AND (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         <= 74 THEN 'Entre 70 y 74' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) >= 75 AND (datediff(YY, IPFECNACI, i.IFECHAING)) <= 79 THEN 'Entre 75 y 79' WHEN (datediff(YY, IPFECNACI, i.IFECHAING)) 
                         >= 80 THEN '80 y mas' END AS 'GrupoEtario2'
						 , I.NUMINGRES Ingreso, EG.FechaAlta
             
                         
                         FROM            
                         ADINGRESO AS I INNER join
                         INPACIENT AS Pa ON Pa.IPCODPACI = I.IPCODPACI INNER JOIN

                         INESPECIA AS E ON E.CODESPECI = i.CODESPTRA INNER JOIN
                         INENTIDAD AS A ON A.CODENTIDA = i.CODENTIDA INNER JOIN
                         INUBICACI AS M ON M.AUUBICACI = Pa.AUUBICACI INNER JOIN
                         INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD LEFT OUTER JOIN
                         HCURGING1 ON Pa.IPCODPACI = HCURGING1.IPCODPACI AND I.NUMINGRES = HCURGING1.NUMINGRES LEFT OUTER JOIN
                         HCANTGINE ON Pa.IPCODPACI = HCANTGINE.IPCODPACI AND I.NUMINGRES = HCANTGINE.NUMINGRES LEFT OUTER JOIN
                         HCHISPACA ON Pa.IPCODPACI = HCHISPACA.IPCODPACI AND I.NUMINGRES = HCHISPACA.NUMINGRES  LEFT OUTER JOIN
                         INESPECIA AS E2 ON E2.CODESPECI = HCHISPACA.CODESPTRA LEFT OUTER JOIN
                         INDIAGNOS AS D ON D.CODDIAGNO = I.CODDIAING LEFT OUTER JOIN
                         INDIAGNOS AS D2 ON D2.CODDIAGNO = I.CODDIAEGR left join
                         ADGRUETNI as AD  ON pa.CODGRUPOE= ad.CODGRUPOE LEFT JOIN
						 ADCONTIPS AS IP ON  I.AIPSREMIS= IP.CODIGOIPS OUTER APPLY
						 (SELECT TOP 1 MAX(EG.FECALTPAC) FechaAlta FROM dbo.HCREGEGRE EG WHERE EG.NUMINGRES=I.NUMINGRES) EG
 where i.IINGREPOR='4'

