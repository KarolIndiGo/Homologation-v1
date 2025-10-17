-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ATENCIONDIARIAINGRESO
-- Extracted by Fabric SQL Extractor SPN v3.9.0












CREATE VIEW [Report].[View_HDSAP_ATENCIONDIARIAINGRESO]
AS

SELECT     
H.FECHISPAC FechaAtencion,
CASE pte.IPTIPODOC
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
						 U.UFUDESCRI AS Unidadfuncional, H.CODPROSAL AS CodMedico, P.NOMMEDICO AS Medico, E.DESESPECI AS Especialidad, H.NUMINGRES AS Ingreso, 
                         CONVERT(varchar, H.FECHISPAC, 105) AS FechaConsulta, '1' AS Cantidad, DATEDIFF(YY, 
                         PTE.IPFECNACI, GETDATE()) AS Edades,
						 DATEDIFF(YY, 
                         PTE.IPFECNACI, GETDATE()) AS Edad, CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
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
                         CASE WHEN pte.IPTIPOPAC = '1' THEN 'Contributivo' WHEN pte.IPTIPOPAC = '2' THEN 'Subsidiado' WHEN pte.IPTIPOPAC = '3' THEN 'Vinculado' WHEN pte.IPTIPOPAC
                          = '4' THEN 'Particular' WHEN pte.IPTIPOPAC = '5' THEN 'Otro' WHEN pte.IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo' WHEN pte.IPTIPOPAC = '7' THEN 'Desplazado reg Subsidiado'
                          WHEN pte.IPTIPOPAC = '8' THEN 'Desplazado no Asegurado' END AS TipoRegimen, H.IPCODPACI AS Identificacion, PTE.IPNOMCOMP AS Nombre, 
                         CASE WHEN Pte.IPSEXOPAC = 2 THEN 'Femenino' WHEN Pte.IPSEXOPAC = 1 THEN 'Masculino' END AS Sexo,  
                         I.IFECHAING AS FechaIngresoInstitucion, FIC.TENARTSIS 'Tension Sistolica', fic.TENARTDIA 'Tension Arterial Diastolica' , HC.FECPROPAR FechaProbableParto, hc.RIESOBTET RiesgosObstétricos,

						 fic.FRERESPAC FrecuenciaRespiratoria, fic.REGSO2PAC SaturacionOxigeno, fic.TEMPERPAC Temperatura, fic.DESNEUPAC Neurologia, 
                         fic.FRECARPAC FrecuenciaCardiaca , S.NOMENTIDA AS Entidad, L.MUNNOMBRE AS MunicipioProcedencia, H.CODDIAGNO AS CodDx, INDIAGNOS.NOMDIAGNO AS Dx, PTE.IPFECNACI AS FechaNacimiento ,fic.PESOPACIE / 1000.0 AS PesoPacienteKg, 
                         fic.TALLAPACI / 100.0 AS TallaPacienteMetros--, POE.DESCRIPCION AS GrupoPoblacional
FROM            HCHISPACA AS H INNER JOIN
                         INPROFSAL AS P ON P.CODPROSAL = H.CODPROSAL AND P.TIPPROFES = 2 INNER JOIN
                         INESPECIA AS E ON E.CODESPECI = P.CODESPEC1 INNER JOIN
						 HCANTGINE AS HC ON HC.NUMINGRES = H.NUMINGRES INNER JOIN
						 HCEXFISIC AS FIC ON FIC.NUMINGRES = H.NUMINGRES INNER JOIN
                         INUNIFUNC AS U ON U.UFUCODIGO = H.UFUCODIGO INNER JOIN
                         ADINGRESO AS I ON I.NUMINGRES = H.NUMINGRES AND I.IPCODPACI = H.IPCODPACI INNER JOIN
                         INPACIENT AS PTE ON PTE.IPCODPACI = H.IPCODPACI INNER JOIN
                         INENTIDAD AS S ON S.CODENTIDA = I.CODENTIDA INNER JOIN
                         INUBICACI AS M ON M.AUUBICACI = PTE.AUUBICACI INNER JOIN
                         INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD LEFT OUTER JOIN
                         INDIAGNOS ON H.CODDIAGNO = INDIAGNOS.CODDIAGNO
						-- where H.FECHISPAC between '2024-08-01' and '2024-08-31'

