-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_CITASMEDICAS_CONTACTCENTERTOTAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_CITASMEDICAS_CONTACTCENTERTOTAL 
AS

SELECT 
    Ingreso
    , IDENTIFICACION
    , TIPODOCUMENTO
    , PACIENTE
    , PrimerApellido
    , SegApellido
    , PrimerNombre
    , SegNombre
    , SEXO
    , CentroAtencion
    , CodMed
    , MEDICO
    , ESPECIALIDAD
    , [FECHA DE CITA]
    , ACTIVIDAD
    , RIAS
    , SOLICITUD
    , TIPO
    , ESTADO
    , [CITA EXTRA]
    , COD
    , USUARIO
    , [FECHA REGISTRO]
    , [Días Oportunidad]
    , MesRegistro
    , [FECHA DeseaPcte]
    , FECHA_NAC
    , CodEPS
    , EntidadPaciente
    , Fijo
    , Celular
    , Direccion
    , Tiene_HC
    , Estado_Real_Cita
    , OBSERVACION_CITA
    , OBSERVACION_CANCELACION
    , [Link Cancelacion]
    , Fechacancelacion
    , Causa_Cancelacion
    , CodUsuarioCancela
    , Usuario_Cancela
    , Causa_Inatencion
    , Observ_Inatencion
    , Correo

FROM   (
SELECT  
    CE.NUMINGRES AS Ingreso
    , C.IPCODPACI AS IDENTIFICACION
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
        WHEN 12 THEN 'PE' END AS TIPODOCUMENTO
    , PA.IPNOMCOMP AS PACIENTE
    , PA.IPPRIAPEL AS PrimerApellido
    , PA.IPSEGAPEL AS SegApellido
    , PA.IPPRINOMB AS PrimerNombre
    , PA.IPSEGNOMB AS SegNombre
    , CASE PA.IPSEXOPAC 
        WHEN 1 THEN 'H' 
        WHEN 2 THEN 'M' END AS SEXO
    , CA.NOMCENATE AS CentroAtencion
    , P.CODPROSAL AS CodMed
    , P.NOMMEDICO AS MEDICO
    , E.DESESPECI AS ESPECIALIDAD
    , C.FECHORAIN AS [FECHA DE CITA]
    , A.DESACTMED AS ACTIVIDAD
    , R.NOMBRE AS RIAS
    , CASE 
        WHEN C.CODTIPSOL = '0' THEN 'Presencial' 
        WHEN C.CODTIPSOL = '1' THEN 'Telefónica' END AS SOLICITUD
    , CASE 
        WHEN C.CODTIPCIT = '0' THEN 'Primera Vez' 
        WHEN C.CODTIPCIT = '1' THEN 'Control' 
        WHEN C.CODTIPCIT = '2' THEN 'Pos Operatorio' END AS TIPO
    , CASE C.CODESTCIT 
        WHEN '0' THEN 'Asignada' 
        WHEN '1' THEN 'Cumplida' 
        WHEN '2' THEN 'Incumplida' 
        WHEN '3' THEN 'Preasignada' 
        WHEN 4 THEN 'Cancelada' END AS ESTADO
    , CASE 
        WHEN C.CITAEXTRA = '0' THEN 'Normal' 
        WHEN C.CITAEXTRA = '1' THEN 'Cita Extra' END AS [CITA EXTRA]
    , C.CODUSUASI AS COD
    , US.NOMUSUARI AS USUARIO
    , C.FECREGSIS AS [FECHA REGISTRO]
    , DATEDIFF(y, C.FECITADES, C.FECHORAIN) AS [Días Oportunidad]
    , MONTH(C.FECREGSIS) AS MesRegistro
    , C.FECITADES AS [FECHA DeseaPcte]
    , PA.IPFECNACI AS FECHA_NAC
    , EA.Code AS CodEPS
    , EA.Name AS EntidadPaciente
    , PA.IPTELEFON AS Fijo
    , PA.IPTELMOVI AS Celular
    , PA.IPDIRECCI AS Direccion
    , IIF(H.NUMEFOLIO IS NULL, 'SIN HC', 'CON HC') AS Tiene_HC
    , IIF(H.NUMEFOLIO IS NULL, IIF(C.CODESTCIT = '0' AND C.FECHORAIN < DATEADD(DAY, - 1, GETDATE()), 'Incumplida', 
CASE C.CODESTCIT WHEN '0' THEN 'Asignada' WHEN '1' THEN 'Cumplida' WHEN '2' THEN 'Incumplida' WHEN '3' THEN 'Preasignada' WHEN 4 THEN 'Cancelada' END), 'Cumplida') AS Estado_Real_Cita, 
C.OBSERVACI AS OBSERVACION_CITA
    , C.OBSCAUCAN AS OBSERVACION_CANCELACION
    , 'https://forms.office.com/r/LPJ0SyLy6v' AS [Link Cancelacion],
	C.FECHCANCELA	AS Fechacancelacion
    , MC.DESCAUCAN	AS Causa_Cancelacion,
	C.CANCELUSU AS CodUsuarioCancela,
	US1.NOMUSUARI AS Usuario_Cancela,
	INA.DESMOTANU	AS Causa_Inatencion,
	C.OBSCAUINA		AS Observ_Inatencion,
	PA.CORELEPAC AS Correo

FROM [INDIGO031].[dbo].[AGASICITA] AS C  
INNER JOIN INDIGO031.dbo.INPACIENT AS PA ON PA.IPCODPACI = C.IPCODPACI 
INNER JOIN INDIGO031.dbo.INPROFSAL AS P ON P.CODPROSAL = C.CODPROSAL 
INNER JOIN INDIGO031.dbo.INESPECIA AS E ON C.CODESPECI = E.CODESPECI 
INNER JOIN INDIGO031.dbo.AGACTIMED AS A ON A.CODACTMED = C.CODACTMED 
INNER JOIN INDIGO031.dbo.SEGusuaru AS US ON US.CODUSUARI = C.CODUSUASI 
LEFT OUTER JOIN INDIGO031.dbo.ADCONCOEX AS CE ON C.IPCODPACI=CE.IPCODPACI and C.CODAUTONU = CE.NUMCONCIT AND CONESTADO not in ('1','2') and CE.IPFECHCIT>= '2024-01-01'  
LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS EA ON PA.GENCONENTITY = EA.Id 
INNER JOIN INDIGO031.dbo.ADCENATEN AS CA ON C.CODCENATE = CA.CODCENATE 
LEFT OUTER JOIN INDIGO031.dbo.RIASCUPS AS RIC ON A.IDRIASCUPS = RIC.ID 
LEFT OUTER JOIN INDIGO031.dbo.RIAS AS R ON RIC.IDRIAS = R.ID
LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS US1 ON US1.CODUSUARI = C.CANCELUSU 
LEFT JOIN
    (SELECT  MAX(NUMEFOLIO) AS NUMEFOLIO, NUMINGRES
        FROM [INDIGO031].[dbo].[HCHISPACA] 
        WHERE FECHISPAC >= '2024-01-01' 
        GROUP BY NUMINGRES
    ) AS H ON H.NUMINGRES = CE.NUMINGRES 
LEFT JOIN INDIGO031.dbo.AGCAUCANC AS MC ON MC.CODCAUCAN = C.CODCAUCAN 
LEFT JOIN
    (SELECT CODMOTANU, DESMOTANU
        FROM [INDIGO031].[dbo].[HCMOANULB] 
        WHERE (TIPSERIPS = '9')
    ) AS INA ON INA.CODMOTANU=C.CODCAUINA
						   
WHERE  C.FECREGSIS >= '2025-01-01' AND
C.IPCODPACI NOT IN ('33333', '333333', '3131', '33333', '333333', '3333', '0000', '55555', '0000000') 
AND C.FECHORAIN >= DATEADD(MONTH, - 3, GETDATE())
) AS derivedtbl_1




