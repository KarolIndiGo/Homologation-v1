-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_CitasMedicas_2022
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_CitasMedicas_2022]
AS
--select * from INDIGO010..AGCAUCANC
SELECT  DISTINCT 
    CE.NUMINGRES AS Ingreso, 
    C.IPCODPACI AS IDENTIFICACION,
    CASE PA.IPTIPODOC
        WHEN 1
        THEN 'CC'
        WHEN 2
        THEN 'CE'
        WHEN 3
        THEN 'TI'
        WHEN 4
        THEN 'RC'
        WHEN 5
        THEN 'PA'
        WHEN 6
        THEN 'AS'
        WHEN 7
        THEN 'MS'
        WHEN 8
        THEN 'NU'
		WHEN 9 THEN 'CN' WHEN 10 THEN 'CD' WHEN 11 THEN 'SC' WHEN 12 THEN 'PE'
    END AS TIPODOCUMENTO, 
    PA.IPNOMCOMP AS PACIENTE, 
    PA.IPPRIAPEL AS PrimerApellido, 
    PA.IPSEGAPEL AS SegApellido, 
    PA.IPPRINOMB AS PrimerNombre, 
    PA.IPSEGNOMB AS SegNombre,
    CASE PA.IPSEXOPAC
        WHEN 1
        THEN 'H'
        WHEN 2
        THEN 'M'
    END AS SEXO, 
    CA.NOMCENATE AS CentroAtencion, 
    P.CODPROSAL AS CodMed, 
    P.NOMMEDICO AS MEDICO, 
    Rtrim(E.DESESPECI) AS ESPECIALIDAD, 
    C.FECHORAIN AS [FECHA DE CITA], 
    A.DESACTMED AS ACTIVIDAD, 
    R.NOMBRE AS RIAS,
    CASE
        WHEN C.CODTIPSOL = '0'
        THEN 'Presencial'
        WHEN C.CODTIPSOL = '1'
        THEN 'Telefónica'
    END AS SOLICITUD,
    CASE
        WHEN C.CODTIPCIT = '0'
        THEN 'Primera Vez'
        WHEN C.CODTIPCIT = '1'
        THEN 'Control'
        WHEN C.CODTIPCIT = '2'
        THEN 'Pos Operatorio'
    END AS TIPO,
    CASE C.CODESTCIT
        WHEN '0'
        THEN 'Asignada'
        WHEN '1'
        THEN 'Cumplida'
        WHEN '2'
        THEN 'Incumplida'
        WHEN '3'
        THEN 'Preasignada'
        WHEN 4
        THEN 'Cancelada'
    END AS ESTADO,
	CONVERT(varchar,PA.IPFECNACI,21) AS FechaNacimiento,
    DATEDIFF(year, PA.IPFECNACI,  ING.IFECHAING) AS EdadEnAtencion, 
    CASE
        WHEN C.CITAEXTRA = '0'
        THEN 'Normal'
        WHEN C.CITAEXTRA = '1'
        THEN 'Cita Extra'
    END AS [CITA EXTRA], 
    US.NOMUSUARI AS USUARIO, 
(
    SELECT sub1.descrirol
    FROM dbo.SEGrolesu AS sub1 
    WHERE sub1.codigorol = US.CODIGOROL
) AS ROL_USU_CREA, 
    C.FECREGSIS AS [FECHA REGISTRO], 
    DATEDIFF(y, C.FECITADES, C.FECHORAIN) AS [Días Oportunidad], 
    MONTH(C.FECREGSIS) AS MesRegistro, 
    C.FECITADES AS [FECHA DeseaPcte], 
    PA.IPFECNACI AS FECHA_NAC, 
    EA.Code AS CodEPS, 
    EA.Name AS EntidadPaciente, 
    PA.IPTELEFON AS Fijo, 
    PA.IPTELMOVI AS Celular, 
    PA.IPDIRECCI AS Direccion, 
    US1.NOMUSUARI AS UsuarioCancela, 
(
    SELECT sub2.descrirol
    FROM dbo.SEGrolesu AS sub2 
    WHERE sub2.codigorol = US1.CODIGOROL
) AS ROL_USU_CANCELA, 
    C.FECHCANCELA AS FechaCancelacion, 
    IIF(H.NUMEFOLIO IS NULL, 'SIN HC', 'CON HC') AS Tiene_HC, 
    IIF(H.NUMEFOLIO IS NULL, IIF(C.CODESTCIT = '0'
                                    AND C.FECHORAIN < DATEADD(DAY, -1, GETDATE()), 'Incumplida',
                                                                                CASE C.CODESTCIT
                                                                                    WHEN '0'
                                                                                    THEN 'Asignada'
                                                                                    WHEN '1'
                                                                                    THEN 'Cumplida'
                                                                                    WHEN '2'
                                                                                    THEN 'Incumplida'
                                                                                    WHEN '3'
                                                                                    THEN 'Preasignada'
                                                                                    WHEN 4
                                                                                    THEN 'Cancelada'
                                                                                END), 'Cumplida') AS Estado_Real_Cita, 
    C.OBSERVACI AS OBSERVACION_CITA, 
    MC.DESCAUCAN AS CAUSA_CANCELACION, 
    C.OBSCAUCAN AS OBSERVACION_CANCELACION,
	'https://forms.office.com/r/LPJ0SyLy6v' as [Link Cancelacion]
FROM dbo.AGASICITA AS C 
    INNER JOIN dbo.INPACIENT AS PA  ON PA.IPCODPACI = C.IPCODPACI
	LEFT OUTER JOIN dbo.adingreso as ING on  PA.IPCODPACI = ING.IPCODPACI
    INNER JOIN dbo.INPROFSAL AS P  ON P.CODPROSAL = C.CODPROSAL
    INNER JOIN dbo.INESPECIA AS E  ON P.CODESPEC1 = E.CODESPECI
    INNER JOIN dbo.AGACTIMED AS A  ON A.CODACTMED = C.CODACTMED
    INNER JOIN dbo.SEGusuaru AS US  ON US.CODUSUARI = C.CODUSUASI
    LEFT OUTER JOIN dbo.ADCONCOEX AS CE  ON C.CODAUTONU = CE.NUMCONCIT
    LEFT OUTER JOIN Contract.HealthAdministrator AS EA  ON PA.GENCONENTITY = EA.Id
    INNER JOIN dbo.ADCENATEN AS CA  ON C.CODCENATE = CA.CODCENATE
    LEFT OUTER JOIN dbo.RIASCUPS AS RIC  ON A.IDRIASCUPS = RIC.ID
    LEFT OUTER JOIN dbo.RIAS AS R  ON RIC.IDRIAS = R.ID
    LEFT OUTER JOIN dbo.SEGusuaru AS US1  ON US1.CODUSUARI = C.CANCELUSU
    LEFT JOIN dbo.HCHISPACA AS H  ON H.NUMINGRES = CE.NUMINGRES
    LEFT JOIN dbo.AGCAUCANC AS MC  ON MC.CODCAUCAN = C.CODCAUCAN
    
--WHERE C.FECHORAIN >= DATEADD(MONTH, -3, GETDATE())
WHERE c.ipcodpaci not in ('33333',  '333333', '3131', '33333', '333333', '3333','0000', '55555', '0000000') and
YEAR(C.FECHORAIN) = '2022'
