-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_CITASENESPERA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[CitasEnEspera]
AS

SELECT 
	 CASE
	     WHEN CE.CODCENATE IN ( '001'  ) THEN 'Sucursal Neiva'
		 WHEN CE.CODCENATE IN ( '002'  ) THEN 'Sucursal Pitalito'
		  END AS Sucursal, CE.CODCENATE as Centro_Atencion, CE.CODAUTONU,
		 CE.IPCODPACI AS IdPaciente, PA.IPNOMCOMP AS  NombrePaciente, EN.NOMENTIDA AS EntidadPcte,
			CE.FECREGSIS AS FechaRegCitasEnEspera, CAST(CE.FECHACITA AS DATETIME) AS FechaDeseadaCitasEnEspera, 
			CE.CODESPECI as CodEspecialidad, ES.DESESPECI AS Especialidad, CE.CODACTMED AS CodActividad, AM.DESACTMED AS ActividadCitasEnEspera, 
			AM2.DESACTMED AS ActividadAgendamiento, --CE.CODPROSAL AS ProfesionalSolicitado, CI.CODPROSAL AS ProfesionalAsignado, 
			IIF(CE.ESTADO=1,'En espera', IIF(CE.ESTADO=2,'Asignada',IIF(CE.ESTADO=3, 'Cancelada', 'Otro'))) AS EstadoCitaEnEspera, 
			CE.OBSERVACI AS ObservacionesCitasEnEspera, CI.FECHORAIN AS FechaAsignadaAgendamiento,
			IIF(CI.CODESTCIT='0','Asignada', IIF(CI.CODESTCIT='1','Cumplida',IIF(CI.CODESTCIT='2', 'Incumplida', IIF(CI.CODESTCIT='3', 'PreAsignada', 
			IIF(CI.CODESTCIT='4', 'Cita Cancelada', 'En espera'))))) AS EstadoAgendamiento, CI.OBSCAUCAN AS ObservacionCancelacionAgendamiento, 
			US.NOMUSUARI AS UsuarioCitasEnEspera
			,PA.IPTELEFON AS Telefono
	  ,PA.IPTELMOVI AS Celular
	  ,PA.CORELEPAC AS Correo,RTRIM(ha.Name) AS Entidad, CI.CODAUTONU as IdCita
			--, ci.CODAUTONU as codcitya,
			--ci.CODTIPCIT , 
			--CASE 
			--WHEN  ci.CODTIPCIT = '0' THEN 'Primera Vez'
			--WHEN  ci.CODTIPCIT = '1' THEN 'Control'
			--WHEN  ci.CODTIPCIT = '2' THEN 'Pos Operatorio'
			--WHEN  ci.CODTIPCIT = '3' THEN 'Cita Web' 
			--WHEN  ci.CODTIPCIT is null THEN 'Sin tipo' 
			--ELSE 'OTRO'
			--END AS TipoCita

    FROM   INDIGO035.dbo.AGCITAESP AS CE left JOIN 
	INDIGO035.dbo.SEGusuaru AS US  ON CE.CODUSUASI = US.CODUSUARI left JOIN 
			indigo035.dbo.INESPECIA AS ES ON CE.CODESPECI=ES.CODESPECI LEFT JOIN 
			indigo035.dbo.AGASICITA AS CI ON CE.IPCODPACI=CI.IPCODPACI AND CE.CODESPECI =CI.CODESPECI AND CI.FECREGSIS >=  CE.FECREGSIS left JOIN 
			indigo035.dbo.AGACTIMED AS AM ON CE.CODACTMED=AM.CODACTMED left JOIN 
			indigo035.dbo.AGACTIMED AS AM2 ON CI.CODACTMED=AM2.CODACTMED left JOIN 
			indigo035.dbo.INPACIENT AS PA ON CE.IPCODPACI=PA.IPCODPACI left JOIN 
			indigo035.dbo.INENTIDAD AS EN ON PA.CODENTIDA=EN.CODENTIDA 
			left join INDIGO035.Contract.HealthAdministrator as ha on ha.Id = PA.GENCONENTITY

	WHERE CE.ESTADO=1 --AND CE.IPCODPACI='1056798915'--CE.IPCODPACI='1056798915' 7187696
	--ORDER BY CE.CODAUTONU

	--select * FROM   indigo102.dbo.AGCITAESP
	---where IPCODPACI='1056798915'