-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PROCEDIMIENTOSQUIROFANOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


-- =============================================
-- Author:		Miguel Angel Ruiz Vega
-- Create date: 03-01-2024
-- Description:	ESTADISTICA
-- =============================================

CREATE VIEW [Report].[View_HDSAP_PROCEDIMIENTOSQUIROFANOS]
AS

SELECT CASE pa.IPTIPODOC
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
       GrA.Name AS GrupoAtencion, 
       EntA.Name AS Entidad, 
       Q.IPCODPACI AS 'Documento', 
       Pa.IPNOMCOMP AS NombrePaciente,
       CASE
           WHEN pa.IPTIPOPAC = '1'
           THEN 'Contributivo'
           WHEN pa.IPTIPOPAC = '2'
           THEN 'Subsidiado'
           WHEN pa.IPTIPOPAC = '3'
           THEN 'Vinculado'
           WHEN pa.IPTIPOPAC = '4'
           THEN 'Particular'
           WHEN pa.IPTIPOPAC = '5'
           THEN 'Otro'
           WHEN pa.IPTIPOPAC = '6'
           THEN 'Desplazado Reg. Contributivo'
           WHEN pa.IPTIPOPAC = '7'
           THEN 'Desplazado Reg. Subsidiado'
           WHEN pa.IPTIPOPAC = '8'
           THEN 'Desplazado No Asegurado'
       END AS 'Regimen', 
	   DATEDIFF(YY,Pa.IPFECNACI, GETDATE()) AS Expr11, CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
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
       ge.DESGRUPET AS 'GrupoEtnico', 
       Q.NUMINGRES, 
       Q.CODPROSAL, 
       Q.CODSERIPS, 
       C.DESSERIPS, 
       P.NOMMEDICO, 
       P.CODESPEC1, 
       E.DESESPECI, 
       '1' AS Cantidad, 
       DX.NOMDIAGNO AS DxPRE, 
       DX2.NOMDIAGNO AS DxPOST, 
       Q.FECHORINI AS FEchaInicial, 
       Q.FECHORFIN AS FechaFinal, 
       DATEDIFF(MINUTE, Q.FECHORINI, Q.FECHORFIN) AS TiempoQuirurgicoeNmIN,
       CASE
           WHEN Q.TIPOANEST = 1
           THEN 'LOCAL'
           WHEN Q.TIPOANEST = 2
           THEN 'REGIONAL'
           WHEN Q.TIPOANEST = 3
           THEN 'GENERAL'
           WHEN Q.TIPOANEST = 4
           THEN 'COMBINADA'
       END AS TipoAnestesia,
       CASE
           WHEN Q.URGECIRUG = 'TRUE'
           THEN 'URGENCIA'
           WHEN Q.URGECIRUG = 'FALSE'
           THEN 'PROGRAMADA'
       END AS Tipo, 
       Q2.CODSERIPS AS Código,
       CASE
           WHEN Q2.QXPRINCIP = 'TRUE'
           THEN 'SI'
           WHEN Q2.QXPRINCIP = 'FALSE'
           THEN 'NO'
       END AS PRINCIPAL, 
       C2.DESSERIPS AS Descripción, 
       DATEDIFF(YY, Pa.IPFECNACI, GETDATE()) AS Expr1, 
    
       INUBICACI.UBINOMBRE AS Barrio, 
       INUBICACI.DEPMUNCOD AS Municipio, 
       Pa.IPFECNACI AS Fnacimiento, 
       Pa.IPSEXOPAC,
       CASE
           WHEN Pa.IPSEXOPAC = 2
           THEN 'Femenino'
           WHEN Pa.IPSEXOPAC = 1
           THEN 'Masculino'
       END AS Sexo,
       (datediff (year,pa.IPFECNACI, getdate ())) EDAD, 
       Pa.IPTELEFON AS Tel1, 
       Pa.IPTELMOVI AS Tel2, 
       Q.SALACIRUG AS Sala, 
       Q.MATERADIC AS Materiales,
       CASE HI.INDICAPAC
           WHEN '1'
           THEN 'Trasladar a Urgencias: Solo consulta externa'
           WHEN '2'
           THEN 'Trasladar a Observacion Urgencias'
           WHEN '3'
           THEN 'Trasladar a Hospitalizacion'
           WHEN '4'
           THEN 'Trasladar a UCI Adulto'
           WHEN '5'
           THEN 'Trasladar a UCI Pediatrica'
           WHEN '6'
           THEN 'Trasladar a UCI Neonatal'
           WHEN '7'
           THEN 'Trasladar a Consulta Externa'
           WHEN '8'
           THEN 'Trasladar a Cirugia'
           WHEN '9'
           THEN 'Hospitalizacion en Casa'
           WHEN '10'
           THEN 'Referencia'
           WHEN '11'
           THEN 'Morgue'
           WHEN '12'
           THEN 'Salida'
           WHEN '13'
           THEN 'Continua en la Unidad'
           WHEN '14'
           THEN 'Paciente en Tratamiento'
           WHEN '15'
           THEN 'Retiro Voluntario'
           WHEN '16'
           THEN 'Fuga'
           WHEN '17'
           THEN 'Salida Parcial'
           WHEN '18'
           THEN 'Estancia Con la Madre'
           WHEN '19'
           THEN 'U.Cuidado Intermedio'
           WHEN '20'
           THEN 'U.Basica'
           WHEN '21'
           THEN 'No Aplica'
       END AS Destino,
	   HI.NUMEFOLIO AS Folio
FROM HCQXINFOR AS Q
     INNER JOIN INPROFSAL AS P ON P.CODPROSAL = Q.CODPROSAL
     INNER JOIN INDIAGNOS AS DX2 ON Q.CODDIAPRE = DX2.CODDIAGNO
     INNER JOIN INDIAGNOS AS DX ON Q.CODDIAPRE = DX.CODDIAGNO
     INNER JOIN INESPECIA AS E ON P.CODESPEC1 = E.CODESPECI
     INNER JOIN INCUPSIPS AS C ON C.CODSERIPS = Q.CODSERIPS
     INNER JOIN HCQXREALI AS Q2 ON Q.NUMEFOLIO = Q2.NUMEFOLIO
                                                 AND Q.IPCODPACI = Q2.IPCODPACI
                                                 AND Q.NUMINGRES = Q2.NUMINGRES
     INNER JOIN INCUPSIPS AS C2 ON C2.CODSERIPS = Q2.CODSERIPS
     INNER JOIN INPACIENT AS Pa ON Q.IPCODPACI = Pa.IPCODPACI
     INNER JOIN INUBICACI ON Pa.AUUBICACI = INUBICACI.AUUBICACI
     INNER JOIN ADINGRESO AS Ing ON Q.IPCODPACI = Ing.IPCODPACI
                                                  AND Q.NUMINGRES = Ing.NUMINGRES
     INNER JOIN Contract.CareGroup AS GrA ON Ing.GENCAREGROUP = GrA.Id
     INNER JOIN Contract.HealthAdministrator AS EntA ON Ing.GENCONENTITY = EntA.Id
     LEFT JOIN ADGRUETNI AS GE ON GE.CODGRUPOE = Pa.CODGRUPOE
     LEFT JOIN HCHISPACA AS HI ON Q.NUMEFOLIO = HI.NUMEFOLIO
                                                AND Q.NUMINGRES = HI.NUMINGRES
WHERE HI.ESTAFOLIO ='1'

