-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_OPORTUNIDADCITAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[View_HDSAP_OPORTUNIDADCITAS]
AS
SELECT distinct
    dbo.TipDocR256(INP.IPTIPODOC) AS TipoDocumento, 
    INP.IPCODPACI AS Identificacion, 
    INP.IPPRINOMB AS PrimerNombre,
    INP.IPSEGNOMB AS SegundoNombre,
    INP.IPPRIAPEL AS PrimerApellido,
    INP.IPSEGAPEL AS SegundoApellido,
    INP.IPSEXOPAC AS Sexo,  
    CAST(INP.IPFECNACI AS DATE) AS FNacimiento,
    INP.IPDIRECCI AS Direccion,
    INMU.MUNNOMBRE AS Municipio, 
    INE.NOMENTIDA AS Entidad,
    CASE HA.EntityType 
        WHEN 1 THEN 'EPS Contributivo'
        WHEN 2 THEN 'EPS Subsidiado'
        WHEN 3 THEN 'ET Vinculados Municipios'
        WHEN 4 THEN 'ET Vinculados Departamentos'
        WHEN 5 THEN 'ARL Riesgos Laborales'
        WHEN 6 THEN 'MP Medicina Prepagada'
        WHEN 7 THEN 'IPS Privada'
        WHEN 8 THEN 'IPS Publica'
        WHEN 9 THEN 'Regimen Especial'
        WHEN 10 THEN 'Accidentes de transito'
        WHEN 11 THEN 'Fosyga'
        WHEN 12 THEN 'Otros'
    END AS TipoEntidad, 
    HA.HealthEntityCode AS CodigoEntidad, 
    INP.IPTELEFON AS Tel1, 
    INP.IPTELMOVI AS Tel2, 
    INES.DESESPECI AS Especialidad, 
    INPR.NOMMEDICO AS Medico, 
    CASE WHEN AGC.FECREGSIS IS NULL THEN AGA.FECREGSIS
        ELSE AGC.FECREGSIS 
    END AS FechaPrimeraSolicitud,
    AGA.FECITADES AS FechaDeseada, 
    AGA.FECHORAIN AS FechaAsignacionCita, 
    DATEDIFF(DAY, CASE WHEN AGC.FECREGSIS IS NULL THEN AGA.FECREGSIS ELSE AGC.FECREGSIS END, AGA.FECHORAIN) AS DiasDesdePrimeraSolicitud,
    DATEDIFF(DAY, AGA.FECITADES, AGA.FECHORAIN) AS DiasDesdeFechaDeseada, 
    AGAC.DESACTMED AS Actividad,
    AGA.CODUSUASI AS CodigoAsignoCitaMedica,
    prs.Fullname AS NombreAsignoCitaMedica, 
    CASE AGA.CODESTCIT
        WHEN 0 THEN 'Asignada'
        WHEN 1 THEN 'Cumplida'
        WHEN 2 THEN 'Incumplida'
        WHEN 3 THEN 'PreAsignada'
        WHEN 4 THEN 'Cita Cancelada'
    END AS EstadoCita
FROM 
    dbo.INPACIENT AS INP 
    INNER JOIN dbo.INENTIDAD AS INE ON INP.CODENTIDA = INE.CODENTIDA 
    INNER JOIN dbo.AGASICITA AS AGA ON INP.IPCODPACI = AGA.IPCODPACI 
    INNER JOIN dbo.INPROFSAL AS INPR ON AGA.CODPROSAL = INPR.CODPROSAL 
    INNER JOIN dbo.INESPECIA AS INES ON AGA.CODESPECI = INES.CODESPECI 
    INNER JOIN dbo.INUBICACI AS INU ON INP.AUUBICACI = INU.AUUBICACI 
    INNER JOIN dbo.INMUNICIP AS INMU ON INU.DEPMUNCOD = INMU.DEPMUNCOD 
    INNER JOIN dbo.AGACTIMED AS AGAC ON AGA.CODACTMED = AGAC.CODACTMED 
    LEFT OUTER JOIN dbo.AGCITESPE AS AGCI ON AGA.CODESPECI = AGCI.CODESPECI AND AGA.IPCODPACI = AGCI.IPCODPACI 
    INNER JOIN [Security].[User] AS usr ON usr.UserCode = AGA.CODUSUASI 
    INNER JOIN [Security].[Person] AS prs ON prs.Id = usr.IdPerson 
    LEFT JOIN Contract.HealthAdministrator AS HA ON HA.Id = INP.GENCONENTITY  
    LEFT JOIN AGCITAESP AS AGC ON AGA.CODAUTONU = AGC.IDCITA
	--where aga.IPCODPACI = '1078756299';

  

