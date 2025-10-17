-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AD_AG_Agendas
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_AD_AG_Agendas]
AS
SELECT        CentroAtención, FECHA_INICIAL, FECHA_FINAL, COD_CONSULTARIO, CONSULTORIO, MEDICO, ESPECIALIDAD, Actividad_Medica, FECHA_CREA_AGENDA, UsuarioCreaAgenda, OcupacionMinutoConsultorio, DiaAgenda, 
                         TURNOBLOQ, CODAUTONU
FROM            (
                         
SELECT 
D.NOMCENATE AS CentroAtención, CONVERT(datetime, A.FECHORAIN, 121) AS FECHA_INICIAL, CONVERT(datetime, A.FECHORAFI, 121) AS FECHA_FINAL, 
C.CODIGOCON AS COD_CONSULTARIO, C.DESCRICON AS CONSULTORIO, P.NOMMEDICO AS MEDICO, E.DESESPECI AS ESPECIALIDAD, 
			Actividades AS Actividad_Medica,
          A.FECREGSIS AS FECHA_CREA_AGENDA, U.NOMUSUARI AS UsuarioCreaAgenda, 
		  DATEDIFF(MINUTE, A.FECHORAIN, A.FECHORAFI) AS OcupacionMinutoConsultorio, DATENAME(WEEKDAY, A.FECHORAIN) AS DiaAgenda, A.TURNOBLOQ,
		  A.CODAUTONU
FROM  AGAGEMEDC AS A INNER JOIN
          AGCONSULT AS C  ON C.CODIGOCON = A.CODIGOCON AND C.ESTADOCON = 'True' and c.codcenate= a.codcenate INNER JOIN
          INESPECIA AS E  ON E.CODESPECI = A.CODESPECI INNER JOIN
          INPROFSAL AS P  ON P.CODPROSAL = A.CODPROSAL INNER JOIN
          SEGusuaru AS U  ON U.CODUSUARI = A.CODUSUASI INNER JOIN
          ADCENATEN AS D  ON D.CODCENATE = A.CODCENATE inner join
		  (SELECT distinct  CODAUTONU AS AUTO,	STUFF(
							(SELECT ',' + aG.CODACTMED +'-'+ rtrim(AG.DESACTMED) 
								FROM 
									 AGAGEMEDD AS AD inner join
									 AGACTIMED AS AG ON AG.CODACTMED=AD.CODACTMED
									 where AD.CODAUTONU=AA.CODAUTONU 
			
								FOR XML PATH ('')),
							1,2, '') As Actividades
FROM	AGAGEMEDD AS AA) as dx on dx.AUTO=a.CODAUTONU 
		 
WHERE (A.FECHORAIN >= '01/01/2022 00:00') )	 
                          AS derivedtbl_1
