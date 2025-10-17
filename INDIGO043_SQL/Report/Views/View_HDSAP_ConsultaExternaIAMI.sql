-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ConsultaExternaIAMI
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_ConsultaExternaIAMI]
AS


 SELECT        HCHISPACA.IPCODPACI AS Identificación, Pa.IPNOMCOMP AS Nombre, HCHISPACA.FECHISPAC AS FechaConsulta, A.NOMENTIDA AS Entidad, 
                         HCHISPACA.CODPROSAL AS CodMedico, P.NOMMEDICO AS NombreMedico, E.DESESPECI AS Especialidad, HCHISPACA.NUMINGRES AS Ingreso, 
                         CASE WHEN Pa.IPSEXOPAC = 2 THEN 'Femenino' WHEN Pa.IPSEXOPAC = 1 THEN 'Masculino' END AS Sexo, Pa.IPFECNACI AS FechaNacimiento, DATEDIFF(YY, 
                         Pa.IPFECNACI, GETDATE()) AS Edad, CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
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
                         CASE WHEN IPTIPOPAC = '1' THEN 'Contributivo' WHEN IPTIPOPAC = '2' THEN 'Subsidiado' WHEN IPTIPOPAC = '3' THEN 'Vinculado' WHEN IPTIPOPAC = '4' THEN 'Particular'
                          WHEN IPTIPOPAC = '5' THEN 'Otro' WHEN IPTIPOPAC = '6' THEN 'Desplazado Reg. Contributivo' WHEN IPTIPOPAC = '7' THEN 'Desplazado reg Subsidiado' WHEN IPTIPOPAC
                          = '8' THEN 'Desplazado no Asegurado' END AS TipoRegimen, L.MUNNOMBRE AS MunicipioProcedencia, I.CODDIAING AS CodCIE10Ingreso, 
                         D.NOMDIAGNO AS DiagnosticoIngreso, I.CODDIAEGR AS CodCIE10Egreso, D2.NOMDIAGNO AS DiagnosticoEgreso, '1' AS Cantidad, 
                         HCANTGINE.CANTPRENA AS CantControles, HCANTGINE.NOMSEMGES AS SemanasGes, HCANTGINE.RIESOBTET AS Riesgo_obs, 
                         CASE WHEN HCURGING1.TIPATEPAC = '1' THEN 'Ginecologica' WHEN HCURGING1.TIPATEPAC = '2' THEN 'Obstetrica' END AS Tipo, 
                         HCANTGINE.RESULVDRL AS VDRL, HCANTGINE.DILUCVDRL AS VDRL_diluciones, HCANTGINE.RESCUAHEM AS Cuadro_hematico, 
                         HCANTGINE.TESTSULLI AS Test_Osullivan, 
                         CASE WHEN HCANTGINE.RESULTHIV = '1' THEN 'Positivo' WHEN HCANTGINE.RESULTHIV = '0' THEN 'Negativo' END AS VIH, HCANTGINE.IGGTOXOPL AS IgG, 
                         CASE WHEN HCANTGINE.HEPATITIB = '1' THEN 'Positivo' WHEN HCANTGINE.HEPATITIB = '2' THEN 'Negativo' WHEN HCANTGINE.HEPATITIB = '3' THEN 'No tiene' END
                          AS ASH_B, HCANTGINE.GLUCBASAL AS Glicemia_basal, HCANTGINE.FECULTCIT AS Fecha_Citologia, HCANTECOG.FECULTECO AS F_ultima_eco, 
                         HCANTECOG.NUMSEMULT AS Semanas_dia_eco, HCANTECOG.NUMSEMHIS AS semanas_dia_hc, HCURGING1.ANALISISP AS analisis, 
                         HCURGING1.INDICAMED AS indicaciones, I.IINGREPOR, HCHISPACA.INDICAMED OtrasIndicaciones
FROM            HCURGING1 RIGHT OUTER JOIN
                         INDIAGNOS AS D RIGHT OUTER JOIN
                         INDIAGNOS AS D2 RIGHT OUTER JOIN
                         HCANTECOG RIGHT OUTER JOIN
                         ADINGRESO AS I INNER JOIN
                         INUBICACI AS M INNER JOIN
                         INPACIENT AS Pa ON M.AUUBICACI = Pa.AUUBICACI INNER JOIN
                         INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD INNER JOIN
                         HCHISPACA ON Pa.IPCODPACI = HCHISPACA.IPCODPACI INNER JOIN
                         INESPECIA AS E INNER JOIN
                         INPROFSAL AS P ON E.CODESPECI = P.CODESPEC1 ON HCHISPACA.CODPROSAL = P.CODPROSAL ON I.NUMINGRES = HCHISPACA.NUMINGRES INNER JOIN
                         INENTIDAD AS A ON I.CODENTIDA = A.CODENTIDA ON HCANTECOG.IPCODPACI = Pa.IPCODPACI AND HCANTECOG.NUMINGRES = I.NUMINGRES ON 
                         D2.CODDIAGNO = I.CODDIAEGR ON D.CODDIAGNO = I.CODDIAING ON HCURGING1.IPCODPACI = Pa.IPCODPACI AND 
                         HCURGING1.NUMINGRES = I.NUMINGRES LEFT OUTER JOIN
                         HCANTGINE ON Pa.IPCODPACI = HCANTGINE.IPCODPACI AND I.NUMINGRES = HCANTGINE.NUMINGRES
WHERE        (I.IINGREPOR = 2) 
  

