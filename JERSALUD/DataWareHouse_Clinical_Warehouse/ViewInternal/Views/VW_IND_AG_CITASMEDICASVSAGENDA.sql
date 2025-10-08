-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AG_CITASMEDICASVSAGENDA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AG_CITASMEDICASVSAGENDA
AS
SELECT TOP (100) PERCENT CE.NUMINGRES AS Ingreso, 
                        C.IPCODPACI AS IDENTIFICACION, 
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
                        E.DESESPECI AS ESPECIALIDAD, 
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
                        CASE
                            WHEN C.CITAEXTRA = '0'
                            THEN 'Normal'
                            WHEN C.CITAEXTRA = '1'
                            THEN 'Cita Extra'
                        END AS [CITA EXTRA], 
                        US.NOMUSUARI AS USUARIO, 
                        C.FECREGSIS AS [FECHA REGISTRO], 
                        DATEDIFF(y, C.FECREGSIS, C.FECHORAIN) AS [Días Transcurridos], 
                        MONTH(C.FECREGSIS) AS MesRegistro, 
                        C.FECITADES AS [FECHA DeseaPcte], 
                        PA.IPFECNACI AS FECHA_NAC, 
                        EA.Code AS CodEPS, 
                        EA.Name AS EntidadPaciente, 
                        PA.IPTELEFON AS Fijo, 
                        PA.IPTELMOVI AS Celular, 
                        CONVERT(VARCHAR(11), AG.FECHORAIN, 100) + ' de las ' + CONVERT(VARCHAR(4), DATEPART(hour, AG.FECHORAIN), 103) + ' horas Hasta las ' + CONVERT(VARCHAR(4), DATEPART(hour, AG.FECHORAFI), 101) + ' horas' AS Agenda
FROM [INDIGO031].[dbo].[AGASICITA] AS C
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS PA ON PA.IPCODPACI = C.IPCODPACI
INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS P ON P.CODPROSAL = C.CODPROSAL
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS E ON P.CODESPEC1 = E.CODESPECI
INNER JOIN [INDIGO031].[dbo].[AGACTIMED] AS A ON A.CODACTMED = C.CODACTMED
INNER JOIN [INDIGO031].[dbo].[SEGusuaru] AS US ON US.CODUSUARI = C.CODUSUASI
LEFT OUTER JOIN [INDIGO031].[dbo].[ADCONCOEX] AS CE ON C.CODAUTONU = CE.NUMCONCIT
LEFT OUTER JOIN [INDIGO031].[Contract].[HealthAdministrator] AS EA ON PA.GENCONENTITY = EA.Id
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON C.CODCENATE = CA.CODCENATE
LEFT OUTER JOIN [INDIGO031].[dbo].[RIASCUPS] AS RIC ON A.IDRIASCUPS = RIC.ID
LEFT OUTER JOIN [INDIGO031].[dbo].[RIAS] AS R ON RIC.IDRIAS = R.ID
INNER JOIN [INDIGO031].[dbo].[AGAGEMEDC] AS AG ON C.CODPROSAL = AG.CODPROSAL
            AND CONVERT(VARCHAR(10), C.FECHORAIN, 101) = CONVERT(VARCHAR(10), AG.FECHORAIN, 101)
WHERE(YEAR(C.FECREGSIS) = '2019')
    AND (CONVERT(VARCHAR(10), C.FECREGSIS, 101) >= CONVERT(VARCHAR(10), GETDATE() - 100, 101));
