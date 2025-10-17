-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CITASENESPERAVSAGENDAMIENTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_CITASENESPERAVSAGENDAMIENTO]
AS

	SELECT 
    CE.IPCODPACI AS IdPaciente, 
    PA.IPNOMCOMP AS NombrePaciente, 
    EN.NOMENTIDA AS EntidadPcte,
    CE.FECREGSIS AS FechaRegCitasEnEspera, 
    CE.FECHACITA AS FechaDeseadaCitasEnEspera, 
    CI.FECHORAIN AS FechaAsignadaAgendamiento, 
    ES.DESESPECI AS Especialidad, 
    AM.DESACTMED AS ActividadCitasEnEspera, 
    AM2.DESACTMED AS ActividadAgendamiento, 
    CE.CODPROSAL AS ProfesionalSolicitado, 
    CI.CODPROSAL AS ProfesionalAsignado, 
    IIF(CE.ESTADO=1,'En espera', IIF(CE.ESTADO=2,'Asignada',IIF(CE.ESTADO=3, 'Cancelada', 'Otro'))) AS EstadoCitaEnEspera, 
    CE.OBSERVACI AS ObservacionesCitasEnEspera, 
    IIF(CI.CODESTCIT='0','Asignada', IIF(CI.CODESTCIT='1','Cumplida',IIF(CI.CODESTCIT='2', 'Incumplida', IIF(CI.CODESTCIT='3', 'PreAsignada', 
    IIF(CI.CODESTCIT='4', 'Cita Cancelada', 'Otro'))))) AS EstadoAgendamiento, 
    CI.OBSCAUCAN AS ObservacionCancelacionAgendamiento, 
    US.NOMUSUARI AS UsuarioCitasEnEspera 
FROM   
    AGCITAESP AS CE 
    INNER JOIN SEGusuaru AS US ON CE.CODUSUASI = US.CODUSUARI 
    INNER JOIN INESPECIA AS ES ON CE.CODESPECI=ES.CODESPECI 
    INNER JOIN AGASICITA AS CI ON CE.IPCODPACI=CI.IPCODPACI AND CE.CODESPECI =CI.CODESPECI AND CI.FECREGSIS >=  CE.FECREGSIS 
    INNER JOIN AGACTIMED AS AM ON CE.CODACTMED=AM.CODACTMED 
    INNER JOIN AGACTIMED AS AM2 ON CI.CODACTMED=AM2.CODACTMED 
    INNER JOIN INPACIENT AS PA ON CE.IPCODPACI=PA.IPCODPACI 
    INNER JOIN INENTIDAD AS EN ON PA.CODENTIDA=EN.CODENTIDA 
WHERE 
    CE.ESTADO=1;

  

