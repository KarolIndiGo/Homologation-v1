-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AD_HC_ORDENESMEDICAS_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_IND_AD_HC_ORDENESMEDICAS_PB
AS

SELECT 'Laboratorio' AS Tipo,
            ca.NOMCENATE AS Sede, prof.CODPROSAL, prof.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                   WHEN ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN ca.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN ca.CODCENATE IN (015,016,019,020)
                THEN 'Casanare'
            END AS Regional, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
			I.CODSERIPS as Codigo,
			CUP.DESSERIPS AS Servicio,
   --        (I.Canserips) AS Cant,
		   I.IPCODPACI as Documento,
		   I.FECORDMED as Fecha,
		   I.NUMINGRES as Ingreso,
		   I.CODDIAGNO as CIE10,
		   dx.NOMDIAGNO as Diagnostico
     FROM INDIGO031.dbo.HCORDLABO I 
        inner join  INDIGO031.dbo.ADCENATEN ca  ON I.CODCENATE = ca.CODCENATE
		inner join  INDIGO031.dbo.INPROFSAL prof  on I.CODPROSAL = prof.CODPROSAL
		inner join  INDIGO031.dbo.INESPECIA ESP  ON prof.CODESPEC1 = ESP.CODESPECI
		inner join  INDIGO031.dbo.INCUPSIPS CUP  ON CUP.CODSERIPS = I.CODSERIPS
		inner join  INDIGO031.dbo.INDIAGNOS dx  ON dx.CODDIAGNO = I.CODDIAGNO
     WHERE I.FECORDMED >= '01-01-2023' and I.IPCODPACI<>'9999999'
           AND I.ESTSERIPS <> 6
		   
union all

 SELECT 'ImagenesDx' AS Tipo,
            ca.NOMCENATE AS Sede, prof.CODPROSAL, prof.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                   WHEN ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN ca.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN ca.CODCENATE IN (015,016,019,020)
                THEN 'Casanare'
            END AS Regional, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
			I.CODSERIPS as Codigo,
			CUP.DESSERIPS AS Servicio,
   --        (I.Canserips) AS Cant,
		   I.IPCODPACI as Documento,
		   I.FECORDMED as Fecha,
		   I.NUMINGRES as Ingreso,
		    I.CODDIAGNO as CIE10,
		   dx.NOMDIAGNO as Diagnostico
     FROM INDIGO031.dbo.HCORDIMAG I 
        inner join   INDIGO031.dbo.ADCENATEN ca  ON I.CODCENATE = ca.CODCENATE
		inner join   INDIGO031.dbo.INPROFSAL prof  on I.CODPROSAL = prof.CODPROSAL
		inner join   INDIGO031.dbo.INESPECIA ESP  ON prof.CODESPEC1 = ESP.CODESPECI
		inner join   INDIGO031.dbo.INCUPSIPS CUP  ON CUP.CODSERIPS = I.CODSERIPS
		inner join   INDIGO031.dbo.INDIAGNOS dx  ON dx.CODDIAGNO = I.CODDIAGNO
     WHERE I.FECORDMED >= '01-01-2023'  and I.IPCODPACI<>'9999999'
           AND I.ESTSERIPS <> 6
	


	union all

 SELECT 'Interconsultas' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.CODPROSAL, prof.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                   WHEN ca.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN ca.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN ca.CODCENATE IN (015,016,019,020)
                THEN 'Casanare'
            END AS Regional, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
			I.CODSERIPS as Codigo,
			CUP.DESSERIPS AS Servicio,
   --        (I.Canserips) AS Cant,
		   I.IPCODPACI as Documento,
		   I.FECORDMED as Fecha,
		   I.NUMINGRES as Ingreso,
		   I.CODDIAGNO as CIE10,
		   dx.NOMDIAGNO as Diagnostico
     FROM INDIGO031.dbo.HCORDINTE I 
        inner join   INDIGO031.dbo.ADCENATEN ca  ON I.CODCENATE = ca.CODCENATE
		inner join   INDIGO031.dbo.INPROFSAL prof  on I.CODPROSAL = prof.CODPROSAL
		inner join   INDIGO031.dbo.INESPECIA ESP  ON prof.CODESPEC1 = ESP.CODESPECI
		inner join   INDIGO031.dbo.INCUPSIPS CUP  ON CUP.CODSERIPS = I.CODSERIPS
		inner join   INDIGO031.dbo.INDIAGNOS dx  ON dx.CODDIAGNO = I.CODDIAGNO
     WHERE I.FECORDMED >= '01-01-2023'  and I.IPCODPACI<>'9999999'
           AND I.ESTSERIPS <> 5		   
		   
