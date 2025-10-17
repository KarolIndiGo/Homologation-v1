-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CITASUNIDADGINECOLOGIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_CITASUNIDADGINECOLOGIA]
AS
     SELECT CIT.IPCODPACI AS Documento, 
            PAC.IPNOMCOMP AS NombrePaciente, 
            CIT.FECHORAIN FechaCita, 
            ESP.CODESPECI CodigoEspecialidad, 
            ESP.DESESPECI Especialidad, 
            PRO.NOMMEDICO Medico, 
            CIT.OBSERVACI ObservacionCita, 
            USU.NOMUSUARI UsuarioAsignaCita, 
            CIT.FECREGSIS FechaRegistro,
			INE.NOMENTIDA AS Entidad,
            CASE DATEPART([MONTH], CIT.FECHORAIN)
                WHEN 1
                THEN 'Enero'
                WHEN 2
                THEN 'Febrero'
                WHEN 3
                THEN 'Marzo'
                WHEN 4
                THEN 'Abril'
                WHEN 5
                THEN 'Mayo'
                WHEN 6
                THEN 'Junio'
                WHEN 7
                THEN 'Julio'
                WHEN 8
                THEN 'Agosto'
                WHEN 9
                THEN 'Septiembre'
                WHEN 10
                THEN 'Octubre'
                WHEN 11
                THEN 'Noviembre'
                WHEN 12
                THEN 'Diciembre'
            END AS Mes,
		 case CIT.CODESTCIT
		 when 0
		 then 'Asignada'
		 when 1
		 then 'Cumplida'
		 when 2
		 then 'Incumplida'
		 when 3
		 then 'Preasignada'
		 when 4
		 then 'Cancelada'
		 end Estado
     FROM dbo.AGASICITA CIT
          INNER JOIN dbo.INPACIENT AS PAC ON CIT.IPCODPACI = PAC.IPCODPACI
		  INNER JOIN dbo.INENTIDAD AS INE ON PAC.CODENTIDA = INE.CODENTIDA
          INNER JOIN dbo.INESPECIA AS ESP ON CIT.CODESPECI = ESP.CODESPECI
          INNER JOIN dbo.INPROFSAL AS PRO ON CIT.CODPROSAL = PRO.CODPROSAL
          LEFT JOIN dbo.SEGusuaru AS USU ON CIT.CODUSUASI = USU.CODUSUARI
     WHERE CIT.CODESPECI IN('085', '204', '142')
          AND CIT.OBSERVACI IS NOT NULL
          AND CIT.OBSERVACI <> '';



