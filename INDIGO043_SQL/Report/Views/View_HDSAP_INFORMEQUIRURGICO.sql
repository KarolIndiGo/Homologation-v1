-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INFORMEQUIRURGICO
-- Extracted by Fabric SQL Extractor SPN v3.9.0











CREATE VIEW [Report].[View_HDSAP_INFORMEQUIRURGICO]
AS
SELECT        TOP (100) PERCENT GrA.Name AS GrupoAtencion, EntA.Name AS 'Entidad', 
                         CASE WHEN Pa.IPTIPODOC = 1 THEN 'CC' WHEN Pa.IPTIPODOC = 2 THEN 'CE' WHEN Pa.IPTIPODOC = 3 THEN 'TI' WHEN Pa.IPTIPODOC = 4 THEN 'RC' WHEN Pa.IPTIPODOC
                          = 5 THEN 'PA' WHEN Pa.IPTIPODOC = 6 THEN 'AS' WHEN Pa.IPTIPODOC = 7 THEN 'MS' END AS TipoDocumento, Q.IPCODPACI AS NumDocumento, 
                         Pa.IPNOMCOMP AS NombrePaciente, Q.NUMINGRES AS Ingreso, Q.CODPROSAL, Q.CODSERIPS, C.DESSERIPS, P.NOMMEDICO, P.CODESPEC1, E.DESESPECI, 
                         '1' AS Cantidad, DX.NOMDIAGNO AS DxPRE, DX2.NOMDIAGNO AS DxPOST,Q.FECHORINI AS FechaInicial, Q.FECHORFIN AS FechaFinal, 
						 --CAST(Q.FECHORINI AS DATE) AS FechaInicial, 
						 --CAST(Q.FECHORINI AS TIME) AS HoraInicial, 
						 --CAST(Q.FECHORFIN AS DATE) AS FechaFinal, 
						 --CAST(Q.FECHORFIN AS TIME) AS HoraFinal,
						 DATEDIFF(MINUTE,Q.FECHORINI, Q.FECHORFIN) AS TiempoCirugia, 
                         CASE WHEN Q.TIPOANEST = 1 THEN 'LOCAL' WHEN Q.TIPOANEST = 2 THEN 'REGIONAL' WHEN Q.TIPOANEST = 3 THEN 'GENERAL' WHEN Q.TIPOANEST = 4 THEN 'COMBINADA'
                          END AS TipoAnestesia, CASE WHEN Q.URGECIRUG = 'TRUE' THEN 'URGENCIA' WHEN Q.URGECIRUG = 'FALSE' THEN 'PROGRAMADA' END AS Tipo, 
                         Q2.CODSERIPS AS Código, CASE WHEN Q2.QXPRINCIP = 'TRUE' THEN 'SI' WHEN Q2.QXPRINCIP = 'FALSE' THEN 'NO' END AS PRINCIPAL, 
                         C2.DESSERIPS AS Descripción, (datediff (year,pa.IPFECNACI, getdate ())) EDAD,
						 INUBICACI.UBINOMBRE AS Barrio, INUBICACI.DEPMUNCOD AS Municipio, Pa.IPFECNACI AS Fnacimiento, 
                         Pa.IPSEXOPAC, CASE WHEN Pa.IPSEXOPAC = 2 THEN 'Femenino' WHEN Pa.IPSEXOPAC = 1 THEN 'Masculino' END AS Sexo,
						 CASE WHEN (datediff(YY, 
                         Pa.IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, Pa.IPFECNACI, getdate())) >= 1 AND (datediff(YY, Pa.IPFECNACI, getdate())) <= 4) 
                         THEN 'Entre 1 y 4' WHEN ((datediff(YY, Pa.IPFECNACI, getdate())) >= 5 AND (datediff(YY, Pa.IPFECNACI, getdate())) <= 14) THEN 'Entre 5 y 14' WHEN ((datediff(YY, 
                         Pa.IPFECNACI, getdate())) >= 15 AND (datediff(YY, Pa.IPFECNACI, getdate())) <= 44) THEN 'Entre 15 y 44' WHEN ((datediff(YY, Pa.IPFECNACI, getdate())) >= 45 AND 
                         (datediff(YY, Pa.IPFECNACI, getdate())) <= 59) THEN 'Entre 45 y 59' WHEN (datediff(YY, Pa.IPFECNACI, getdate())) >= 60 THEN 'Mayores de 60' END AS GrupoEtario1, 
                         Pa.IPTELEFON AS Tel1, Pa.IPTELMOVI AS Tel2, Q.SALACIRUG AS Sala, Q.MATERADIC AS Materiales
FROM            HCQXINFOR AS Q INNER JOIN
                         INPROFSAL AS P ON P.CODPROSAL = Q.CODPROSAL INNER JOIN
                         INDIAGNOS AS DX2 ON Q.CODDIAPRE = DX2.CODDIAGNO INNER JOIN
                         INDIAGNOS AS DX ON Q.CODDIAPRE = DX.CODDIAGNO INNER JOIN
                         INESPECIA AS E ON P.CODESPEC1 = E.CODESPECI INNER JOIN
                         INCUPSIPS AS C ON C.CODSERIPS = Q.CODSERIPS INNER JOIN
                         HCQXREALI AS Q2 ON Q.NUMEFOLIO = Q2.NUMEFOLIO AND Q.IPCODPACI = Q2.IPCODPACI AND Q.NUMINGRES = Q2.NUMINGRES INNER JOIN
                         INCUPSIPS AS C2 ON C2.CODSERIPS = Q2.CODSERIPS INNER JOIN
                         INPACIENT AS Pa ON Q.IPCODPACI = Pa.IPCODPACI INNER JOIN
                         INUBICACI ON Pa.AUUBICACI = INUBICACI.AUUBICACI INNER JOIN
                         ADINGRESO AS Ing ON Q.IPCODPACI = Ing.IPCODPACI AND Q.NUMINGRES = Ing.NUMINGRES INNER JOIN
                         Contract.CareGroup AS GrA ON Ing.GENCAREGROUP = GrA.Id INNER JOIN
                         Contract.HealthAdministrator AS EntA ON Ing.GENCONENTITY = EntA.Id
