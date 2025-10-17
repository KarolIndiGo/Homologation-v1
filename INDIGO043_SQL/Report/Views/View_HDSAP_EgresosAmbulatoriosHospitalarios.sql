-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_EgresosAmbulatoriosHospitalarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0









CREATE VIEW [Report].[View_HDSAP_EgresosAmbulatoriosHospitalarios]
AS

SELECT    
CASE P.IPTIPODOC
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
EH.IPCODPACI AS Identificacion, 
P.IPNOMCOMP AS Nombre, 
CASE WHEN P.IPSEXOPAC = 2 THEN 'Femenino' WHEN P.IPSEXOPAC = 1 THEN 'Masculino' END AS Sexo, 
G.DESGRUPET AS PertenenciaEtnica, 
P.IPFECNACI AS FechaNacimiento, 
DATEDIFF(YY, P.IPFECNACI, I.IFECHAING) AS Edad,
DATEDIFF(YY, 
                         P.IPFECNACI, GETDATE()) AS Expr1, CASE WHEN (datediff(YY, IPFECNACI, getdate())) < 1 THEN 'Menores de 1' WHEN ((datediff(YY, IPFECNACI, getdate())) >= 1 AND 
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
CASE WHEN IPTIPOPAC = 1 THEN 'Contributivo' WHEN IPTIPOPAC = 2 THEN 'Subsidiado' WHEN IPTIPOPAC = 3 THEN 'Vinculado' WHEN IPTIPOPAC = 4 THEN 'Particular' WHEN IPTIPOPAC = 5 THEN 'Otro' WHEN
                          IPTIPOPAC = 6 THEN 'Desplazado Reg. Contributivo' WHEN IPTIPOPAC = 7 THEN 'Desplazado reg Subsidiado' WHEN IPTIPOPAC = 8 THEN 'Desplazado no Asegurado' END AS TipoRegimen,
S.NOMENTIDA AS Entidad, L.MUNNOMBRE AS MunicipioProcedencia, 
I.CODDIAING AS CodCIE10Ingreso, 
D.NOMDIAGNO AS DiagnosticoIngreso, 
I.CODDIAEGR AS CodCIE10Egreso, 
D2.NOMDIAGNO AS DiagnosticoEgreso, 
I.IFECHAING AS FechaIngresoInstitucion, 
U2.UFUDESCRI AS UnidadIngreso, 
T3.Fecha AS FechaIngresoHospitalizacion, 
U3.UFUDESCRI AS UnidadIngresoHospitalizacion, 
U4.UFUDESCRI AS UnidadEgresohospitalizacion, 
CONCAT(PR.CODPROSAL,'-',pr.NOMMEDICO) 'MEDICO EGRESA',
EM.DESESPECI AS EspecialidadMedicoEgreso, 
EE.FECEGRESO AS FechaEgresoCama, 
EH.FECALTPAC AS FechaAltaMedica,  
EE.NUMINGRES AS Ingreso, 
EE.FECMUEPAC AS FechaMuerte, 
U.UFUDESCRI AS UnidadSalida, 
                         CASE WHEN EH.ESTPACEGR = '1' THEN 'Mejor' WHEN EH.ESTPACEGR = '2' THEN 'Igual o Peor' WHEN EH.ESTPACEGR = '3' THEN 'Fallecido' WHEN EH.ESTPACEGR
                          = '4' THEN 'Remitido' WHEN EH.ESTPACEGR = '5' THEN 'HospitalizacionCasa' END AS Estado, '1' AS Cantidad, I.CODESPTRA, 
                         INESPECIA.DESESPECI AS Especialida_Tratante,
						 case when AD.CODGRUPOE ='001' THEN 'INDIGENA'
						 WHEN AD.CODGRUPOE='002' THEN  'GITANO'
						 WHEN AD.CODGRUPOE='003' THEN  'RAIZAL'
						 WHEN AD.CODGRUPOE='004' THEN  'PALENQUERO'
						 WHEN AD.CODGRUPOE='005' THEN  'NEGRO MULATO'
						 WHEN AD.CODGRUPOE='006' THEN  'OTROS'
						 END AS 'GRUPO_ETNICO', DATEDIFF(day,T3.Fecha,EE.FECEGRESO) as 'Días Estancia', SA.CreationDate AS 'FechaBoletaSalida',
T4.FECREGIST AS 'FechaUltimaNota',
DATEDIFF (MINUTE, EH.FECALTPAC, T4.FECREGIST)  as 'AltMed-UltNot',
DATEDIFF (MINUTE, T4.FECREGIST, EE.FECEGRESO)  as 'UltNot-EgrCam',
DATEDIFF (MINUTE, EE.FECEGRESO, SA.CreationDate)  as 'EgrCam-BolSal',
-- I.FECHEGRESO,
-- BI.InvoiceDate,
DATEDIFF (HOUR,  I.FECHEGRESO ,BI.InvoiceDate)  as 'TiempoHorasAltamedicaVSFactura',

CS.DESCCAMAS AS CamaEgreso
FROM            HCREGEGRE AS EH LEFT OUTER JOIN
                         CHREGEGRE AS EE ON EE.IPCODPACI = EH.IPCODPACI AND EE.NUMINGRES = EH.NUMINGRES INNER JOIN
                         INUNIFUNC AS U ON U.UFUCODIGO = EH.UFUCODIGO INNER JOIN
                         INPACIENT AS P ON P.IPCODPACI = EH.IPCODPACI INNER JOIN
                         ADINGRESO AS I ON I.NUMINGRES = EH.NUMINGRES LEFT JOIN
						 Billing.Invoice BI ON BI.AdmissionNumber = I.NUMINGRES INNER JOIN
                         INENTIDAD AS S ON S.CODENTIDA = I.CODENTIDA INNER JOIN
                         INUBICACI AS M ON M.AUUBICACI = P.AUUBICACI INNER JOIN
                         INPROFSAL AS PR ON PR.CODPROSAL = EH.CODPROSAL INNER JOIN
                         INESPECIA AS EM ON EM.CODESPECI = PR.CODESPEC1 AND PR.CODPROSAL = EH.CODPROSAL INNER JOIN
                         INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD LEFT OUTER JOIN
                         INESPECIA ON I.CODESPTRA = INESPECIA.CODESPECI LEFT OUTER JOIN
                         ADGRUETNI AS G ON G.CODGRUPOE = P.CODGRUPOE LEFT OUTER JOIN
                         INDIAGNOS AS D ON D.CODDIAGNO = I.CODDIAING LEFT OUTER JOIN
                         INDIAGNOS AS D2 ON D2.CODDIAGNO = I.CODDIAEGR LEFT OUTER JOIN
                             (SELECT        IPCODPACI, NUMINGRES, MIN(FECINIEST) AS Fecha
                               FROM            CHREGESTA AS t
                               GROUP BY IPCODPACI, NUMINGRES) AS T3 ON T3.NUMINGRES = EE.NUMINGRES AND T3.IPCODPACI = EE.IPCODPACI LEFT OUTER JOIN
                         INUNIFUNC AS U2 ON U2.UFUCODIGO = I.UFUCODIGO LEFT OUTER JOIN
                         INUNIFUNC AS U3 ON U3.UFUCODIGO = I.UFUINGHOS LEFT OUTER JOIN
                         INUNIFUNC AS U4 ON U4.UFUCODIGO = I.UFUEGRHOS LEFT OUTER JOIN
                         INESPECIA AS EM1 ON EM1.CODESPECI = I.CODESPTRA LEFT OUTER JOIN
						 ADGRUETNI as AD  ON p.CODGRUPOE= ad.CODGRUPOE LEFT OUTER JOIN
						 Billing.SlipOut AS SA ON SA.AdmissionNumber=I.NUMINGRES LEFT OUTER JOIN
						     (Select T1.* From HCCTRNOTE As T1 Inner Join
                                  (Select NUMINGRES, Max(FECREGIST) As Max_Fecha 
                                   From HCCTRNOTE Group By NUMINGRES) As T2 On T1.NUMINGRES = T2.NUMINGRES  And T1.FECREGIST = T2.Max_Fecha) AS T4 ON T4.NUMINGRES=EE.NUMINGRES AND T4.IPCODPACI=EE.IPCODPACI

                         LEFT JOIN (select NUMINGRES, MAX(FECFINEST) as fecha from CHREGESTA
                         group by NUMINGRES) AS T1 ON I.NUMINGRES=T1.NUMINGRES
						 INNER JOIN CHREGESTA AS CA ON CA.NUMINGRES=T1.NUMINGRES AND CA.FECFINEST=T1.fecha
						 INNER JOIN CHCAMASHO AS CS ON CS.CODICAMAS=CA.CODICAMAS
						 --where eh.NUMINGRES = '3108890'

  

