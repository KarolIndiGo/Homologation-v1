-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGralxProfesional_ImagenesDx_Tarifa_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IND_IndicadoresGralxProfesional_ImagenesDx_Tarifa_PB] as

 SELECT 'ImagenesDx' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
          CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
			i.codserips as Codigo,
			CUP.DESSERIPS AS Servicio,
   --        (I.CANSERIPS) AS Cant,
		   i.ipcodpaci as Documento,
		   i.fecordmed as Fecha,
		    [ISS+ 35%] as Valor,
			numingres as Ingreso
     FROM DBO.HCORDIMAG I 
        inner join   DBO.ADCENATEN ca WITH (NOLOCK) ON I.CODCENATE = CA.CODCENATE
		 inner join    DBO.INPROFSAL prof WITH (NOLOCK) on I.CODPROSAL = prof.CODPROSAL
		inner join     DBO.INESPECIA ESP WITH (NOLOCK) ON prof.CODESPEC1 = ESP.CODESPECI
		inner join     DBO.INCUPSIPS CUP WITH (NOLOCK) ON CUP.CODSERIPS = I.CODSERIPS
		LEFT JOIN [ViewInternal].[Tarifas_Imagenologia] AS T ON T.Code=I.CODSERIPS
     WHERE I.FECORDMED >= '01-01-2022' 
           AND I.ESTSERIPS <> 6  and  i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999') AND i.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM DBO.HCFOLANUL)
