-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ASIGNACIONCITASMEDICAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_ASIGNACIONCITASMEDICAS]
AS



SELECT INP.IPTIPODOC AS TipoDocumen, 
       INP.IPCODPACI AS Identificacion, 
       INP.IPPRINOMB AS 'PRIMER NOMBRE', 
       INP.IPSEGNOMB AS 'SEGUNDO NOMBRE', 
       INP.IPPRIAPEL AS 'PRIMER APELLIDO', 
       INP.IPSEGAPEL AS 'SEGUNDO APELLIDO', 
       INP.IPSEXOPAC AS Sexo, 
       CAST(INP.IPFECNACI AS DATE) AS FNacimiento, 
       INP.IPDIRECCI AS Direccion, 
       INMU.MUNNOMBRE AS Municipio, 
       INE.NOMENTIDA AS Entidad,
       CASE HA.EntityType
           WHEN 1
           THEN 'EPS Contributivo'
           WHEN 2
           THEN 'EPS Subsidiado'
           WHEN 3
           THEN 'ET Vinculados Municipios'
           WHEN 4
           THEN 'ET Vinculados Departamentos'
           WHEN 5
           THEN 'ARL Riesgos Laborales'
           WHEN 6
           THEN 'MP Medicina Prepagada'
           WHEN 7
           THEN 'IPS Privada'
           WHEN 8
           THEN 'IPS Publica'
           WHEN 9
           THEN 'Regimen Especial'
           WHEN 10
           THEN 'Accidentes de transito'
           WHEN 11
           THEN 'Fosyga'
           WHEN 12
           THEN 'Otros'
       END AS 'Tipo de entidad ', 
       HA.HealthEntityCode AS 'COIDIGO ENTIDAD', 
       INP.IPTELEFON AS Tel1, 
       INP.IPTELMOVI AS Tel2, 
       INES.DESESPECI AS Especialidad, 
       INPR.NOMMEDICO AS Médico,
       CASE
           WHEN AGC.FECREGSIS IS NULL
           THEN AGA.FECREGSIS
           ELSE AGC.FECREGSIS
       END AS '1SOLICITUD',
--AGA.FECREGSIS AS '1SOLICITUD',--FECREGSIS
       AGA.FECITADES AS '2DESEADA', --FECITADES
       AGA.FECHORAIN AS '3ASIGNACION', --FECHORAIN
       DATEDIFF(d, (CASE
                        WHEN AGC.FECREGSIS IS NULL
                        THEN AGA.FECREGSIS
                        ELSE AGC.FECREGSIS
                    END), AGA.FECHORAIN) AS Dias1, 
       DATEDIFF(d, AGA.FECITADES, AGA.FECHORAIN) AS Dias2, 
       AGAC.DESACTMED AS Acitvidad, 
       AGA.CODUSUASI AS 'Codigo Asigno la Cita Medica', 
       prs.Fullname AS 'Nombre Asigno Cita Medica',
       CASE AGA.CODESTCIT
           WHEN 0
           THEN 'Asignada'
           WHEN 1
           THEN 'Cumplida'
           WHEN 2
           THEN 'Incumplida'
           WHEN 3
           THEN 'PreAsignada'
           WHEN 4
           THEN 'Cita Cancelada'
       END AS 'ESTADO CITA'
FROM INPACIENT AS INP
     INNER JOIN INENTIDAD AS INE ON INP.CODENTIDA = INE.CODENTIDA
     INNER JOIN AGASICITA AS AGA ON INP.IPCODPACI = AGA.IPCODPACI
     LEFT JOIN INPROFSAL AS INPR ON AGA.CODPROSAL = INPR.CODPROSAL
     LEFT JOIN INESPECIA AS INES ON AGA.CODESPECI = INES.CODESPECI
     INNER JOIN INUBICACI AS INU ON INP.AUUBICACI = INU.AUUBICACI
     INNER JOIN INMUNICIP AS INMU ON INU.DEPMUNCOD = INMU.DEPMUNCOD
     LEFT JOIN AGACTIMED AS AGAC ON AGA.CODACTMED = AGAC.CODACTMED
     LEFT OUTER JOIN AGCITESPE AS AGCI ON AGA.CODESPECI = AGCI.CODESPECI
                                              AND AGA.IPCODPACI = AGCI.IPCODPACI
     INNER JOIN [Security].[User] AS usr ON usr.UserCode = AGA.CODUSUASI
     INNER JOIN Security.Person AS prs ON prs.Id = usr.IdPerson
     LEFT JOIN Contract.HealthAdministrator AS HA ON HA.Id = INP.GENCONENTITY
     LEFT JOIN AGCITAESP AS AGC ON AGA.CODAUTONU = AGC.IDCITA

