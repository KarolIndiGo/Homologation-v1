-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AD_HC_OrdenesMedicas_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IND_AD_HC_OrdenesMedicas_PB] as

 SELECT 'Laboratorio' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                   WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'Casanare'
            END AS Regional, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
			i.codserips as Codigo,
			CUP.DESSERIPS AS Servicio,
   --        (I.CANSERIPS) AS Cant,
		   i.ipcodpaci as Documento,
		   i.fecordmed as Fecha,
		   i.numingres as Ingreso,
		   i.coddiagno as CIE10,
		   dx.nomdiagno as Diagnostico
     FROM HCORDLABO I 
        inner join   ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
		 inner join    INPROFSAL prof  on I.CODPROSAL = prof.CODPROSAL
		inner join     INESPECIA ESP  ON prof.CODESPEC1 = ESP.CODESPECI
		inner join     INCUPSIPS CUP  ON CUP.CODSERIPS = I.CODSERIPS
		inner join     indiagnos dx  ON dx.coddiagno = I.coddiagno
     WHERE I.FECORDMED >= '01-01-2023' and i.IPCODPACI<>'9999999'
           AND I.ESTSERIPS <> 6
		   
union all

 SELECT 'ImagenesDx' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                   WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'Casanare'
            END AS Regional, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
			i.codserips as Codigo,
			CUP.DESSERIPS AS Servicio,
   --        (I.CANSERIPS) AS Cant,
		   i.ipcodpaci as Documento,
		   i.fecordmed as Fecha,
		   i.numingres as Ingreso,
		    i.coddiagno as CIE10,
		   dx.nomdiagno as Diagnostico
     FROM HCORDIMAG I 
        inner join   ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
		 inner join    INPROFSAL prof  on I.CODPROSAL = prof.CODPROSAL
		inner join     INESPECIA ESP  ON prof.CODESPEC1 = ESP.CODESPECI
		inner join     INCUPSIPS CUP  ON CUP.CODSERIPS = I.CODSERIPS
		inner join     indiagnos dx  ON dx.coddiagno = I.coddiagno
     WHERE I.FECORDMED >= '01-01-2023'  and i.IPCODPACI<>'9999999'
           AND I.ESTSERIPS <> 6
	


	union all

 SELECT 'Interconsultas' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                   WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'Casanare'
            END AS Regional, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
			i.codserips as Codigo,
			CUP.DESSERIPS AS Servicio,
   --        (I.CANSERIPS) AS Cant,
		   i.ipcodpaci as Documento,
		   i.fecordmed as Fecha,
		   i.numingres as Ingreso,
		   i.coddiagno as CIE10,
		   dx.nomdiagno as Diagnostico
     FROM HCORDINTE I 
        inner join   ADCENATEN ca  ON I.CODCENATE = CA.CODCENATE
		 inner join    INPROFSAL prof  on I.CODPROSAL = prof.CODPROSAL
		inner join     INESPECIA ESP  ON prof.CODESPEC1 = ESP.CODESPECI
		inner join     INCUPSIPS CUP  ON CUP.CODSERIPS = I.CODSERIPS
		inner join     indiagnos dx  ON dx.coddiagno = I.coddiagno
     WHERE I.FECORDMED >= '01-01-2023'  and i.IPCODPACI<>'9999999'
           AND I.ESTSERIPS <> 5		   
		   
		   
		
