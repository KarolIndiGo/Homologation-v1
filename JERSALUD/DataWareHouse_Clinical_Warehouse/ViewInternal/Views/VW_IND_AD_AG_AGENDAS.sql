-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AD_AG_AGENDAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_IND_AD_AG_AGENDAS
AS
SELECT        
    CentroAtención
    , FECHA_INICIAL
    , FECHA_FINAL
    , COD_CONSULTARIO
    , CONSULTORIO
    , MEDICO
    , ESPECIALIDAD
    , Actividad_Medica
    , FECHA_CREA_AGENDA
    , UsuarioCreaAgenda
    , OcupacionMinutoConsultorio
    , DiaAgenda
    , TURNOBLOQ
    , CODAUTONU
FROM  (                    
SELECT 
D.NOMCENATE AS CentroAtención
, CONVERT(datetime, A.FECHORAIN, 121) AS FECHA_INICIAL
, CONVERT(datetime, A.FECHORAFI, 121) AS FECHA_FINAL, 
C.CODIGOCON AS COD_CONSULTARIO
, C.DESCRICON AS CONSULTORIO
, P.NOMMEDICO AS MEDICO
, E.DESESPECI AS ESPECIALIDAD
, Actividades AS Actividad_Medica
, A.FECREGSIS AS FECHA_CREA_AGENDA
, U.NOMUSUARI AS UsuarioCreaAgenda
, DATEDIFF(MINUTE, A.FECHORAIN, A.FECHORAFI) AS OcupacionMinutoConsultorio
, DATENAME(WEEKDAY, A.FECHORAIN) AS DiaAgenda
, A.TURNOBLOQ
, A.CODAUTONU
FROM  INDIGO031.dbo.AGAGEMEDC AS A 
INNER JOIN INDIGO031.dbo.AGCONSULT AS C  ON C.CODIGOCON = A.CODIGOCON AND C.ESTADOCON = 'True' and C.CODCENATE= A.CODCENATE 
INNER JOIN INDIGO031.dbo.INESPECIA AS E  ON E.CODESPECI = A.CODESPECI
INNER JOIN INDIGO031.dbo.INPROFSAL AS P  ON P.CODPROSAL = A.CODPROSAL
INNER JOIN INDIGO031.dbo.SEGusuaru AS U  ON U.CODUSUARI = A.CODUSUASI
INNER JOIN INDIGO031.dbo.ADCENATEN AS D  ON D.CODCENATE = A.CODCENATE 
/*inner join (SELECT distinct  CODAUTONU AS AUTO,	STUFF(
							(SELECT ',' + aG.Codactmed +'-'+ rtrim(AG.Desactmed) 
								FROM 
									 AGAGEMEDD AS AD inner join
									 AGACTIMED AS AG ON AG.Codactmed=AD.Codactmed
									 where AD.Codautonu=AA.Codautonu 
			
								FOR XML PATH ('')),
							1,2, '') As Actividades
FROM	AGAGEMEDD AS AA) as dx on dx.Auto=a.Codautonu */
INNER JOIN (
    SELECT
        CODAUTONU AS AUTO,
        -- podria ser necesario el uso de distinct STRING_AGG(DISTINCT AG.Codactmed + '-' + RTRIM(AG.Desactmed), ',')
        STRING_AGG(AG.CODACTMED + '-' + RTRIM(AG.DESACTMED), ',') AS Actividades
    FROM INDIGO031.dbo.AGAGEMEDD AS AD
    INNER JOIN INDIGO031.dbo.AGACTIMED AS AG 
        ON AG.CODACTMED = AD.CODACTMED
    GROUP BY CODAUTONU
) AS dx ON dx.AUTO = A.CODAUTONU
		 
WHERE (A.FECHORAIN >= '01/01/2022 00:00') )	 
                          AS derivedtbl_1
