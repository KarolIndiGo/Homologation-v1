-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_CitasMedicas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_CitasMedicas] AS

SELECT DISTINCT  Ingreso, Identificacion, TipoDocumento, Paciente, PrimerApellido, SegApellido, PrimerNombre, SegNombre, Sexo, CentroAtencion, CodMed, Medico, Especialidad, [Fecha de Cita], Actividad, RIAS, Solicitud, Tipo, Estado, [Cita Extra], Cod,Usuario, 
             [Fecha Registro], [Días Oportunidad], MesRegistro, [Fecha DeseaPcte], Fecha_Nac, CodEPS, EntidadPaciente, Fijo, Celular, Direccion, /*UsuarioCancela,*/ /*ROL_USU_CANCELA, FechaCancelacion,*/ Tiene_HC, Estado_Real_Cita, Observacion_Cita, --CAUSA_CANCELACION, 
             Observacion_Cancelacion, [Link Cancelacion],--, Cita_dada_por
			 Fechacancelacion,
			 Causa_Cancelacion,
			 CodUsuarioCancela,
			  Usuario_Cancela,
			 Causa_Inatencion,
			 Observ_Inatencion,
			 EdadEnAños,  --se agrega por solicitud en caso 215789
			 IdCita





FROM   (
SELECT  
                           CE.NUMINGRES AS Ingreso, C.IPCODPACI AS Identificacion, 
						   CASE PA.IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' WHEN 9 THEN 'CN' WHEN 10 THEN 'CD' WHEN 11 THEN 'SC' WHEN 12 THEN 'PE' END AS TipoDocumento, 
						    PA.IPNOMCOMP AS Paciente, PA.IPPRIAPEL AS PrimerApellido, PA.IPSEGAPEL AS SegApellido, PA.IPPRINOMB AS PrimerNombre, PA.IPSEGNOMB AS SegNombre, CASE PA.IPSEXOPAC WHEN 1 THEN 'H' WHEN 2 THEN 'M' END AS Sexo, 
                           CA.NOMCENATE AS CentroAtencion, P.CODPROSAL AS CodMed, P.NOMMEDICO AS Medico, E.DESESPECI AS Especialidad, C.FECHORAIN AS [Fecha de Cita], A.DESACTMED AS Actividad, R.NOMBRE AS RIAS, 
                           CASE WHEN C.CODTIPSOL = '0' THEN 'Presencial' WHEN C.CODTIPSOL = '1' THEN 'Telefónica' END AS SOLICITUD, CASE WHEN C.CODTIPCIT = '0' THEN 'Primera Vez' WHEN C.CODTIPCIT = '1' THEN 'Control' WHEN C.CODTIPCIT = '2' THEN 'Pos Operatorio' END AS Tipo, 
                           CASE C.CODESTCIT WHEN '0' THEN 'Asignada' WHEN '1' THEN 'Cumplida' WHEN '2' THEN 'Incumplida' WHEN '3' THEN 'Preasignada' WHEN 4 THEN 'Cancelada' END AS Estado, 
                           CASE WHEN C.CITAEXTRA = '0' THEN 'Normal' WHEN C.CITAEXTRA = '1' THEN 'Cita Extra' END AS [Cita Extra], C.CODUSUASI AS Cod,  US.NOMUSUARI AS Usuario,
C.FECREGSIS AS [Fecha Registro], DATEDIFF(y, C.FECITADES, C.FECHORAIN) AS [Días Oportunidad], MONTH(C.FECREGSIS) AS MesRegistro, C.FECITADES AS [Fecha DeseaPcte], PA.IPFECNACI AS FECHA_NAC, EA.Code AS CodEPS, EA.Name AS EntidadPaciente, PA.IPTELEFON AS Fijo, PA.IPTELMOVI AS Celular, PA.IPDIRECCI AS Direccion, 
                           --US1.NOMUSUARI AS UsuarioCancela, 
--C.FECHCANCELA AS FechaCancelacion, 
IIF(H.NUMEFOLIO IS NULL, 'SIN HC', 'CON HC') AS Tiene_HC, 
IIF(H.NUMEFOLIO IS NULL, IIF(C.CODESTCIT = '0' AND C.FECHORAIN < DATEADD(DAY, - 1, GETDATE()), 'Incumplida', 
CASE C.CODESTCIT WHEN '0' THEN 'Asignada' WHEN '1' THEN 'Cumplida' WHEN '2' THEN 'Incumplida' WHEN '3' THEN 'Preasignada' WHEN 4 THEN 'Cancelada' END), 'Cumplida') AS Estado_Real_Cita, 
C.OBSERVACI AS OBSERVACION_CITA, 
 --MC.DESCAUCAN AS CAUSA_CANCELACION, 
 C.OBSCAUCAN AS OBSERVACION_CANCELACION, 'https://forms.office.com/r/LPJ0SyLy6v' AS [Link Cancelacion],
	case 
		when US.NOMUSUARI like '%call%' then 'Contact Center'  
		when US.NOMUSUARI like '%contac%' then 'Contact Center'  
		when US.NOMUSUARI like '%Meta%' then 'Meta'  
		when US.NOMUSUARI like '%Boyaca%' then 'Boyaca'  
		when US.NOMUSUARI like '%Casanare%' then 'Casanare'  
		when US.NOMUSUARI like '%Medisalud%' then 'Medisalud'  
		else 'Por Definir' 
	end AS Cita_dada_por,
	C.FECHCANCELA	AS Fechacancelacion,
	MC.DESCAUCAN	AS Causa_Cancelacion,
	C.CANCELUSU AS CodUsuarioCancela,
	US1.NOMUSUARI AS Usuario_Cancela,
	INA.DESMOTANU	AS Causa_Inatencion,
	C.OBSCAUINA		AS Observ_Inatencion,
	DATEDIFF(MONTH,PA.IPFECNACI,C.FECHORAIN)/12 AS EdadEnAños,
	C.CODAUTONU AS IdCita
	--INNER JOIN dbo.INPROFSAL AS PROF WITH (NOLOCK) ON HC.CODPROSAL = PROF.CODPROSAL
 --         INNER JOIN dbo.INESPECIA AS ESP WITH (NOLOCK) ON HC.CODESPTRA = ESP.CODESPECI --PROF.CODESPEC1 = ESP.CODESPECI
	
             FROM    dbo.AGASICITA AS C INNER JOIN
                           dbo.INPACIENT AS PA ON PA.IPCODPACI = C.IPCODPACI INNER JOIN
                           dbo.INPROFSAL AS P ON P.CODPROSAL = C.CODPROSAL INNER JOIN
                           dbo.INESPECIA AS E ON C.CODESPECI = E.CODESPECI /*P.CODESPEC1 = E.CODESPECI*/ INNER JOIN
                           dbo.AGACTIMED AS A ON A.CODACTMED = C.CODACTMED INNER JOIN
                           dbo.SEGusuaru AS US ON US.CODUSUARI = C.CODUSUASI LEFT OUTER JOIN
                           --dbo.ADCONCOEX AS CE ON c.IPCODPACI=ce.IPCODPACI and C.CODAUTONU = CE.NUMCONCIT AND CONESTADO not in ('1','2') LEFT OUTER JOIN
						   (SELECT IPCODPACI, NUMCONCIT AS CITAID, NUMINGRES
FROM DBO.ADCONCOEX
WHERE CONESTADO NOT IN (/*'1',*/'2')

UNION ALL

SELECT IPCODPACI, IDCITA AS CITAID, NUMINGRES
FROM DBO.AMBORDOTROSPRO
--WHERE ESTADO IN ('2','3','4')
) AS CE ON  c.IPCODPACI=ce.IPCODPACI and C.CODAUTONU = CE.CITAID  LEFT OUTER JOIN
                           Contract.HealthAdministrator AS EA ON PA.GENCONENTITY = EA.Id INNER JOIN
                           dbo.ADCENATEN AS CA ON C.CODCENATE = CA.CODCENATE LEFT OUTER JOIN
                           dbo.RIASCUPS AS RIC ON A.IDRIASCUPS = RIC.ID LEFT OUTER JOIN
                           dbo.RIAS AS R ON RIC.IDRIAS = R.ID LEFT OUTER JOIN
                           dbo.SEGusuaru AS US1 ON US1.CODUSUARI = C.CANCELUSU LEFT JOIN
                            (select max(NUMEFOLIO) as numefolio, numingres
								from dbo.HCHISPACA
								group by NUMINGRES) AS H ON H.NUMINGRES = CE.NUMINGRES LEFT JOIN
                           dbo.AGCAUCANC AS MC ON MC.CODCAUCAN = C.CODCAUCAN LEFT JOIN
						   (SELECT CODMOTANU, DESMOTANU
							FROM dbo.HCMOANULB 
							WHERE (TIPSERIPS = '9')) AS INA ON INA.CODMOTANU=c.CODCAUINA
						   left join dbo.ADCONCOEX as cein on cein.NUMCONCIT = c.CODAUTONU
             WHERE  --c.IPCODPACI='1050200144' and
			 --C.FECHORAIN BETWEEN '2022-01-01' AND '2023-12-31' 
			  c.ipcodpaci NOT IN ('33333', '333333', '3131', '33333', '333333', '3333', '0000', '55555', '0000000')  
			  --and c.CODAUTONU='618537'
			  --and cein.NUMCONCIT='449'
		--	 AND C.FECHORAIN >= DATEADD(MONTH, - 3, GETDATE())
			 
	 --AND P.NOMMEDICO LIKE '%BUSTAMANTE%'
			 ) AS derivedtbl_1
			 --where derivedtbl_1.IDENTIFICACION='1050200144'
--GO





