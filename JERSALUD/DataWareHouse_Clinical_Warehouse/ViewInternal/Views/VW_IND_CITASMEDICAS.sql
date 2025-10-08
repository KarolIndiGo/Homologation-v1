-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_CITASMEDICAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_CITASMEDICAS
AS

SELECT DISTINCT  
    Ingreso
    , Identificacion
    , TipoDocumento
    , Paciente
    , PrimerApellido
    , SegApellido
    , PrimerNombre
    , SegNombre
    , Sexo
    , CentroAtencion
    , CodMed
    , Medico
    , Especialidad
    , [Fecha de Cita]
    , Actividad
    , RIAS
    , SOLICITUD
    , Tipo
    , Estado
    , [Cita Extra]
    , Cod
    , Usuario
    , [Fecha Registro]
    , [Días Oportunidad]
    , MesRegistro
    , [Fecha DeseaPcte]
    , FECHA_NAC
    , CodEPS
    , EntidadPaciente
    , Fijo
    , Celular
    , Direccion
    , /*UsuarioCancela,*/ /*ROL_USU_CANCELA, FechaCancelacion,*/ Tiene_HC
    , Estado_Real_Cita
    , OBSERVACION_CITA
    , OBSERVACION_CANCELACION
    , [Link Cancelacion]
    , Fechacancelacion
    , Causa_Cancelacion,
	CODUSUARIoCancela,
	Usuario_Cancela,
	Causa_Inatencion,
	Observ_Inatencion,
	EdadEnAños,  --se agrega por solicitud en caso 215789
	IdCita

FROM   (
SELECT  
    CE.NUMINGRES AS Ingreso
    , C.IPCODPACI AS Identificacion
    , CASE PA.IPTIPODOC 
        WHEN 1 THEN 'CC' 
        WHEN 2 THEN 'CE' 
        WHEN 3 THEN 'TI' 
        WHEN 4 THEN 'RC' 
        WHEN 5 THEN 'PA' 
        WHEN 6 THEN 'AS' 
        WHEN 7 THEN 'MS' 
        WHEN 8 THEN 'NU' 
        WHEN 9 THEN 'CN' 
        WHEN 10 THEN 'CD' 
        WHEN 11 THEN 'SC' 
        WHEN 12 THEN 'PE' END AS TipoDocumento
    , PA.IPNOMCOMP AS Paciente
    , PA.IPPRIAPEL AS PrimerApellido
    , PA.IPSEGAPEL AS SegApellido
    , PA.IPPRINOMB AS PrimerNombre
    , PA.IPSEGNOMB AS SegNombre
    , CASE PA.IPSEXOPAC
        WHEN 1 THEN 'H' 
        WHEN 2 THEN 'M' END AS Sexo
    , CA.NOMCENATE AS CentroAtencion
    , P.CODPROSAL AS CodMed
    , P.NOMMEDICO AS Medico
    , E.DESESPECI AS Especialidad
    , C.FECHORAIN AS [Fecha de Cita]
    , A.DESACTMED AS Actividad
    , R.NOMBRE AS RIAS
    , CASE
        WHEN C.CODTIPSOL = '0' THEN 'Presencial' 
        WHEN C.CODTIPSOL = '1' THEN 'Telefónica' END AS SOLICITUD
    , CASE 
        WHEN C.CODTIPCIT = '0' THEN 'Primera Vez' 
        WHEN C.CODTIPCIT = '1' THEN 'Control' 
        WHEN C.CODTIPCIT = '2' THEN 'Pos Operatorio' END AS Tipo
    , CASE C.CODESTCIT 
        WHEN '0' THEN 'Asignada' 
        WHEN '1' THEN 'Cumplida' 
        WHEN '2' THEN 'Incumplida' 
        WHEN '3' THEN 'Preasignada' 
        WHEN 4 THEN 'Cancelada' END AS Estado
    , CASE 
        WHEN C.CITAEXTRA = '0' THEN 'Normal' 
        WHEN C.CITAEXTRA = '1' THEN 'Cita Extra' END AS [Cita Extra]
    , C.CODUSUASI AS Cod
    , US.NOMUSUARI AS Usuario
    , C.FECREGSIS AS [Fecha Registro]
    , DATEDIFF(y, C.FECITADES
    , C.FECHORAIN) AS [Días Oportunidad]
    , MONTH(C.FECREGSIS) AS MesRegistro
    , C.FECITADES AS [Fecha DeseaPcte]
    , PA.IPFECNACI AS FECHA_NAC
    , EA.Code AS CodEPS
    , EA.Name AS EntidadPaciente
    , PA.IPTELEFON AS Fijo
    , PA.IPTELMOVI AS Celular
    , PA.IPDIRECCI AS Direccion 
    , IIF(H.NUMEFOLIO IS NULL, 'SIN HC', 'CON HC') AS Tiene_HC
    , IIF(H.NUMEFOLIO IS NULL, IIF(C.CODESTCIT = '0' AND C.FECHORAIN < DATEADD(DAY, - 1, GETDATE()), 'Incumplida', 
        CASE C.CODESTCIT 
            WHEN '0' THEN 'Asignada' 
            WHEN '1' THEN 'Cumplida' 
            WHEN '2' THEN 'Incumplida' 
            WHEN '3' THEN 'Preasignada' 
            WHEN 4 THEN 'Cancelada' END), 'Cumplida') AS Estado_Real_Cita
    , C.OBSERVACI AS OBSERVACION_CITA
    , C.OBSCAUCAN AS OBSERVACION_CANCELACION
    , 'https://forms.office.com/r/LPJ0SyLy6v' AS [Link Cancelacion]
    ,case 
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
	C.CANCELUSU AS CODUSUARIoCancela,
	US1.NOMUSUARI AS Usuario_Cancela,
	INA.DESMOTANU AS Causa_Inatencion,
	C.OBSCAUINA	AS Observ_Inatencion,
	DATEDIFF(MONTH,PA.IPFECNACI,C.FECHORAIN)/12 AS EdadEnAños,
	C.CODAUTONU AS IdCita
	
FROM [INDIGO031].[dbo].[AGASICITA] AS C 
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS PA ON PA.IPCODPACI = C.IPCODPACI 
INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS P ON P.CODPROSAL = C.CODPROSAL 
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS E ON C.CODESPECI = E.CODESPECI /*P.Codespec1 = E.CODESPECI*/ 
INNER JOIN [INDIGO031].[dbo].[AGACTIMED] AS A ON A.CODACTMED = C.CODACTMED 
INNER JOIN [INDIGO031].[dbo].[SEGusuaru] AS US ON US.CODUSUARI = C.CODUSUASI 
LEFT OUTER JOIN (
    SELECT IPCODPACI, NUMCONCIT AS CITAID, NUMINGRES
    FROM [INDIGO031].[dbo].[ADCONCOEX]
    WHERE CONESTADO NOT IN (/*'1',*/'2')
    UNION ALL
    SELECT IPCODPACI, IDCITA AS CITAID, NUMINGRES
    FROM [INDIGO031].[dbo].[AMBORDOTROSPRO]
) AS CE ON  C.IPCODPACI=CE.IPCODPACI and C.CODAUTONU = CE.CITAID 
LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS EA ON PA.GENCONENTITY = EA.Id 
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON C.CODCENATE = CA.CODCENATE
LEFT OUTER JOIN [INDIGO031].[dbo].[RIASCUPS] AS RIC ON A.IDRIASCUPS = RIC.ID
LEFT OUTER JOIN [INDIGO031].[dbo].[RIAS] AS R ON RIC.IDRIAS = R.ID
LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS US1 ON US1.CODUSUARI = C.CANCELUSU 
LEFT JOIN (
    select max(NUMEFOLIO) as NUMEFOLIO, NUMINGRES
	from [INDIGO031].[dbo].[HCHISPACA]
	group by NUMINGRES
) AS H ON H.NUMINGRES = CE.NUMINGRES 
LEFT JOIN [INDIGO031].[dbo].[AGCAUCANC] AS MC ON MC.CODCAUCAN = C.CODCAUCAN 
LEFT JOIN (
    SELECT CODMOTANU, DESMOTANU
	FROM [INDIGO031].[dbo].[HCMOANULB] 
	WHERE (TIPSERIPS = '9')
) AS INA ON INA.CODMOTANU=C.CODCAUINA
left join [INDIGO031].[dbo].[ADCONCOEX] as cein on cein.NUMCONCIT = C.CODAUTONU

WHERE C.IPCODPACI NOT IN ('33333', '333333', '3131', '33333', '333333', '3333', '0000', '55555', '0000000')
) AS derivedtbl_1

