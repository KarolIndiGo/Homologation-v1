-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_INFORME_FIAS_17_18
-- Extracted by Fabric SQL Extractor SPN v3.9.0


--select * from dbo.INESPECIA where DESESPECI like '%DERMATO%'
/****** Object:  View [dbo].[Informe_FIAS_17_18]    Script Date: 2/10/2023 8:09:43 a. m. ******/
CREATE VIEW [ViewInternal].[VW_INFORME_FIAS_17_18]
AS
/*
DPTO
MUNICIPIO
TIPO DE DOCUMENTO
NUMERO DE DOCUMENTO
FECHA DE SOLICITUD DE CITA
FECHA ASIGNACIÓN DE LA CITA
TIPO DE CONSULTA
SEDE
ESPECIALIDAD
TIPO
ACTIVIDAD
*/
SELECT DISTINCT C.CODAUTONU as CodigoCita,
            DEP.depcodigo + '-' + DEP.nomdepart AS DPTO, 
            MUNI.MUNCODIGO + '-' + MUNI.MUNNOMBRE AS MUNICIPIO,
            CASE PA.IPTIPODOC
                WHEN 1 THEN 'CC'
                WHEN 2 THEN 'CE'
                WHEN 3 THEN 'TI'
                WHEN 4 THEN 'RC'
                WHEN 5 THEN 'PA'
                WHEN 6 THEN 'AS'
                WHEN 7 THEN 'MS'
                WHEN 8 THEN 'NU'
            END AS TIPO_DOCUMENTO, 
            C.IPCODPACI AS Numero_Documento, 
            C.FECITADES AS Fecha_Cita_Deseada, 
			C.FECREGSIS AS Fecha_Solicitud, 
			C.FECHORAIN AS Fecha_Cita,
            CASE E.CODESPECI
                WHEN '002' THEN '1= MEDICINA GENERAL'
                WHEN '116' THEN '2= ODONTOLOGIA GENERAL'
                WHEN '101' THEN '3= MEDICINA INTERNA'
                WHEN '142' THEN '4= PEDIATRIA'
                WHEN '085' THEN '5= GINECOLOGIA'
                WHEN '085' THEN '6= OBSTETRICIA'
				WHEN '044' THEN '7= CIRUGIA GENERAL'
                WHEN '099' THEN '8= MEDICINA FAMILIAR'
                WHEN '152' THEN '2= PSQUIATRIA'
                WHEN '131' THEN '1= ORTOPEDIA'
				WHEN '063' THEN '5= DERMATOLOGIA'
            END AS TIPO_CONSULTA,
            CASE E.CODESPECI
                WHEN '002' THEN 'FIAS 17'
                WHEN '116' THEN 'FIAS 17'
                WHEN '101' THEN 'FIAS 17'
                WHEN '142' THEN 'FIAS 17'
                WHEN '085' THEN 'FIAS 17'
                WHEN '085' THEN 'FIAS 17'
                WHEN '099' THEN 'FIAS 17 y 18'
                WHEN '152' THEN 'FIAS 18'
                WHEN '131' THEN 'FIAS 18'
				WHEN '044' THEN 'FIAS 17'
				WHEN '063' THEN 'FIAS 18'
            END AS FIAS, 
            PA.IPNOMCOMP AS Paciente, 
            CA.NOMCENATE AS Centro_Atencion, 
            --E.CODESPECI AS CodEspecialida, 
            E.DESESPECI AS Especialida, 
            A.DESACTMED AS Actividad, 
            R.NOMBRE AS RIAS,
            CASE
                WHEN C.CODTIPCIT = '0' THEN 'Primera Vez'
                WHEN C.CODTIPCIT = '1' THEN 'Control'
                WHEN C.CODTIPCIT = '2' THEN 'Pos Operatorio'
            END AS TIPO,
            CASE C.CODESTCIT
                WHEN '0' THEN 'Asignada'
                WHEN '1' THEN 'Cumplida'
                WHEN '2' THEN 'Incumplida'
                WHEN '3' THEN 'Preasignada'
                WHEN '4' THEN 'Cancelada'
            END AS Estado_Cita, 
            --DATEDIFF(y, C.FECITADES, C.FECHORAIN) AS [Días Oportunidad], 
			DATEDIFF(y, C.FECREGSIS, C.FECHORAIN) AS [Días Oportunidad], 
            MONTH(C.FECREGSIS) AS MesRegistro, 
            C.FECHCANCELA AS FechaCancelacion,
			PA.IPFECNACI AS Fecha_Nacimiento,
			CASE PA.IPSEXOPAC WHEN 1 THEN 'H' WHEN 2 THEN 'M' END AS Sexo,
			PA.IPPRIAPEL AS PrimerApellido, 
			PA.IPSEGAPEL AS SegApellido, 
			PA.IPPRINOMB AS PrimerNombre,
			PA.IPSEGNOMB AS SegNombre
     FROM INDIGO031.dbo.AGASICITA AS C 
          INNER JOIN INDIGO031.dbo.INPACIENT AS PA  ON PA.IPCODPACI = C.IPCODPACI
          INNER JOIN INDIGO031.dbo.INPROFSAL AS P  ON P.CODPROSAL = C.CODPROSAL
          INNER JOIN INDIGO031.dbo.INESPECIA AS E  ON P.CODESPEC1 = E.CODESPECI
          INNER JOIN INDIGO031.dbo.AGACTIMED AS A  ON A.CODACTMED = C.CODACTMED
          INNER JOIN INDIGO031.dbo.ADCENATEN AS CA  ON C.CODCENATE = CA.CODCENATE
          INNER JOIN INDIGO031.dbo.INMUNICIP AS MUNI ON MUNI.DEPMUNCOD = CA.DEPMUNCOD
          INNER JOIN INDIGO031.dbo.INDEPARTA AS DEP ON DEP.depcodigo = MUNI.DEPCODIGO
          LEFT OUTER JOIN INDIGO031.dbo.RIASCUPS AS RIC  ON A.IDRIASCUPS = RIC.ID
          LEFT OUTER JOIN INDIGO031.dbo.RIAS AS R  ON RIC.IDRIAS = R.ID
     WHERE C.FECHORAIN >= DATEADD(MONTH, -3, GETDATE())
		   AND C.IPCODPACI NOT IN ('1234567', '14141414', '9999999')
           AND E.CODESPECI IN
		  ('002', --MG
           '116', --ODONTOLOGIA
           '101', --MEDICINA INTERNA
           '142', --PEDIATRIA
           '085', -- GINECO Y OBS
           '099', -- FAMILIAR
           '152', -- PSIQUIATRIA
           '131', -- ORTOPEDIA
		   '044', -- ORTOPEDIA
		   '063' --	DERMATOLOGIA                                                
		  )
--order by C.FECHORAIN DESC

