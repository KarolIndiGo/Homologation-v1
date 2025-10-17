-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_REGISTROSPSICOLOGIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[View_HDSAP_REGISTROSPSICOLOGIA]
AS



SELECT                   CASE INPACIENT.IPTIPODOC
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
						 INPACIENT.IPFECNACI AS FechaNacimiento,
						 CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
                         (datediff(YY, IPFECNACI, getdate())) <= 4) THEN 'Entre 1 y 4' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 5 AND (datediff(YY, IPFECNACI, getdate())) <= 14) 
                         THEN 'Entre 5 y 14' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 15 AND (datediff(YY, IPFECNACI, getdate())) <= 44) THEN 'Entre 15 y 44' WHEN ((datediff(YY, 
                         IPFECNACI, getdate())) >= 45 AND (datediff(YY, IPFECNACI, getdate())) <= 59) THEN 'Entre 45 y 59' WHEN (datediff(YY, IPFECNACI, getdate())) 
                         >= 60 THEN 'Mayores de 60' END AS GrupoEtario1, CASE WHEN ((datediff(YY, IPFECNACI, getdate())) < 1) THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, 
                         getdate())) >= 1 AND (datediff(YY, IPFECNACI, getdate())) <= 4) THEN 'Entre 1 y 4' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 5 AND (datediff(YY, IPFECNACI, 
                         getdate())) <= 9) THEN 'Entre 5 y 9' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 10 AND (datediff(YY, IPFECNACI, getdate())) <= 14) 
                         THEN 'Entre 10 y 14' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 15 AND (datediff(YY, IPFECNACI, getdate())) <= 19) THEN 'Entre 15 y 19' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 20 AND (datediff(YY, IPFECNACI, getdate())) <= 24 THEN 'Entre 20 y 24' WHEN (datediff(YY, IPFECNACI, getdate())) >= 25 AND (datediff(YY, 
                         IPFECNACI, getdate())) <= 29 THEN 'Entre 25 y 29' WHEN (datediff(YY, IPFECNACI, getdate())) >= 30 AND (datediff(YY, IPFECNACI, getdate())) 
                         <= 34 THEN 'Entre 30 y 34' WHEN (datediff(YY, IPFECNACI, getdate())) >= 35 AND (datediff(YY, IPFECNACI, getdate())) <= 39 THEN 'Entre 35 y 39' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 40 AND (datediff(YY, IPFECNACI, getdate())) <= 44 THEN 'Entre 40 y 44' WHEN (datediff(YY, IPFECNACI, getdate())) >= 45 AND (datediff(YY, 
                         IPFECNACI, getdate())) <= 49 THEN 'Entre 45 y 49' WHEN (datediff(YY, IPFECNACI, getdate())) >= 50 AND (datediff(YY, IPFECNACI, getdate())) 
                         <= 54 THEN 'Entre 50 y 54' WHEN (datediff(YY, IPFECNACI, getdate())) >= 55 AND (datediff(YY, IPFECNACI, getdate())) <= 59 THEN 'Entre 55 y 59' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 60 AND (datediff(YY, IPFECNACI, getdate())) <= 64 THEN 'Entre 60 y 64' WHEN (datediff(YY, IPFECNACI, getdate())) >= 65 AND (datediff(YY, 
                         IPFECNACI, getdate())) <= 69 THEN 'Entre 65 y 69' WHEN (datediff(YY, IPFECNACI, getdate())) >= 70 AND (datediff(YY, IPFECNACI, getdate())) 
                         <= 74 THEN 'Entre 70 y 74' WHEN (datediff(YY, IPFECNACI, getdate())) >= 75 AND (datediff(YY, IPFECNACI, getdate())) <= 79 THEN 'Entre 75 y 79' WHEN (datediff(YY, 
                         IPFECNACI, getdate())) >= 80 THEN '80 y mas' END AS GrupoEtario2, 
                         RTRIM(INPACIENT.IPPRINOMB) + ' ' + RTRIM(INPACIENT.IPSEGNOMB) + ' ' + RTRIM(INPACIENT.IPPRIAPEL) + ' ' + RTRIM(INPACIENT.IPSEGAPEL) AS NombrePaciente, 
						 CASE WHEN dbo.INPACIENT.IPTIPOPAC = '1' THEN 'Contributivo' 
						 WHEN dbo.INPACIENT.IPTIPOPAC = '2' THEN 'Subsidiado'
						 WHEN dbo.INPACIENT.IPTIPOPAC = '3' THEN 'Vinculado'
						 WHEN dbo.INPACIENT.IPTIPOPAC = '4' THEN 'Particular'
						 WHEN dbo.INPACIENT.IPTIPOPAC = '5' THEN 'Otro'
						 WHEN dbo.INPACIENT.IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo'
						 WHEN dbo.INPACIENT.IPTIPOPAC = '7' THEN 'Desplazado Reg. Subsidiado'
						 WHEN dbo.INPACIENT.IPTIPOPAC = '8' THEN 'Desplazado No Asegurado'
						 END AS 'Regimen',
				         HCHISPACA.IPCODPACI AS Identificacion, HCHISPACA.NUMINGRES AS Ingreso, dbo.INPACIENT.IPDIRECCI AS Direccion, dbo.INPACIENT.IPTELEFON AS Telefono_Fijo, dbo.INPACIENT.IPTELMOVI AS Celular, HCHISPACA.CODPROSAL AS CodProfesional, 
                         INPACIENT.IPFECNACI AS FecNacimiento, HCHISPACA.FECHISPAC AS FechaHistoria, HCHISPACA.CODDIAGNO AS CodDiag, RTRIM(INDIAGNOS.NOMDIAGNO) AS Diagnóstico, 
                         CASE WHEN INPACIENT.IPSEXOPAC = '1' THEN 'Masculino' WHEN INPACIENT.IPSEXOPAC = '2' THEN 'Femenino' END AS sexo, 
                         (datediff (year,INPACIENT.IPFECNACI, getdate ())) EDAD,
						 INUNIFUNC.UFUDESCRI AS Unidad, RTRIM(INMUNICIP.MUNNOMBRE) AS Municipio, 
                         RTRIM(INENTIDAD.NOMENTIDA) AS Entidad, ADGRUETNI.DESGRUPET AS Etnia, HCHISPACA.DATOBJETI AS Nota
FROM                     dbo.INDIAGNOS INNER JOIN
                         dbo.INMUNICIP INNER JOIN
                         dbo.INUBICACI ON INMUNICIP.DEPMUNCOD = INUBICACI.DEPMUNCOD INNER JOIN
                         dbo.HCHISPACA INNER JOIN
						 dbo.INPROFSAL ON HCHISPACA.CODPROSAL=INPROFSAL.CODPROSAL INNER JOIN
                         dbo.INPACIENT ON HCHISPACA.IPCODPACI = INPACIENT.IPCODPACI INNER JOIN
                         dbo.INUNIFUNC ON HCHISPACA.UFUCODIGO = INUNIFUNC.UFUCODIGO ON INUBICACI.AUUBICACI = INPACIENT.AUUBICACI ON 
                         dbo.INDIAGNOS.CODDIAGNO = HCHISPACA.CODDIAGNO LEFT OUTER JOIN
                         dbo.ADGRUETNI ON INPACIENT.CODGRUPOE = ADGRUETNI.CODGRUPOE FULL OUTER JOIN
                         dbo.ADINGRESO INNER JOIN
                         dbo.INENTIDAD ON ADINGRESO.CODENTIDA = INENTIDAD.CODENTIDA ON HCHISPACA.NUMINGRES = ADINGRESO.NUMINGRES
WHERE        ((HCHISPACA.CODPROSAL IN ('PS07', 'PS08','PS11','PS12','PS13', 'PS14', 'PS15','PS16','PS17','PS18','PS19')) 
	OR INPROFSAL.CODESPEC1='601') 
  

