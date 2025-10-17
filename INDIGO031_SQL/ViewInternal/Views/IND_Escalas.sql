-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Escalas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Escalas] AS

     SELECT  ESC.NUMINGRES,
            CASE PA.IPTIPODOC
                WHEN 1
                THEN 'CC'
                WHEN 2
                THEN 'CE'
                WHEN 3
                THEN 'TI'
                WHEN 4
                THEN 'RC'
                WHEN 5
                THEN 'PA'
                WHEN 6
                THEN 'AS'
                WHEN 7
                THEN 'MS'
                WHEN 8
                THEN 'NU'
            END AS TIPODOCUMENTO, 
            ESC.IPCODPACI AS IDENTIFICACION, 
            PA.IPNOMCOMP AS PACIENTE,
            CASE PA.IPSEXOPAC
                WHEN 1
                THEN 'H'
                WHEN 2
                THEN 'M'
            END AS SEXO, 
            CONVERT(VARCHAR, PA.IPFECNACI, 23) AS Fecha_Nacimiento, 
            (DATEDIFF(MONTH, PA.IPFECNACI, GETDATE())) / 12 AS Edad_Paciente, 
            ESC.FECHAREGISTRO, 
            ESC.CODPROSAL, 
            ESC.TIPOESCALA,
            CASE ESC.TIPOESCALA
				WHEN 1 THEN 'Escala CAGE'
				WHEN 2 THEN 'Escala APGAR_Familiar'
				WHEN 3 THEN 'Escala EDPS'
				WHEN 4 THEN 'Escala Biopsicosocial'
				WHEN 5 THEN 'Escala Tamizaje Violencia Domestica'
				WHEN 6 THEN 'Escala Riesgo Framingham'
				WHEN 7 THEN 'Escala Morisky'
				WHEN 8 THEN 'Test FINDRISC'
				WHEN 9 THEN 'Test MiniMental'
				WHEN 10 THEN 'Test Dependencia Nicotina'
				WHEN 11 THEN 'Escala Tanner Desarrollo Mamario Mujer'
				WHEN 12 THEN 'Escala Tanner Desarrollo VelloPubiano Mujer'
				WHEN 13 THEN 'Escala Tanner Desarrollo Genital Hombre'
				WHEN 14 THEN 'Escala Tanner Desarrollo VelloPubiano Hombre'
				WHEN 15 THEN 'Escala Wagner'
				WHEN 16 THEN 'Escala Modificada Disnea'
				WHEN 17 THEN 'Escala CAT_COPD_AssessmentTest'
				WHEN 18 THEN 'Exacerbaciones'
				WHEN 19 THEN 'Clasificacion EPOC'
				WHEN 20 THEN 'Test Goodenough'
				WHEN 21 THEN 'GOLD_EPOC'
				WHEN 22 THEN 'Escala Abreviada Desarrollo'
				WHEN 23 THEN 'Escala TISS_28'
				WHEN 24 THEN 'Escala Branden'
				WHEN 25 THEN 'Escala ApacheII'
				WHEN 26 THEN 'Escala Karnosfky'
				WHEN 27 THEN 'Escala Ecog'
				WHEN 28 THEN 'Escala Nems'
				WHEN 29 THEN 'Escala Glasgow_Mayor5Anos'
				WHEN 30 THEN 'Escala Glasgow_de1a5Anos'
				WHEN 31 THEN 'Escala Glasgow_Menor1Ano'
				WHEN 32 THEN 'Escala SOFA'
				WHEN 33 THEN 'Escala Charlson'
				WHEN 34 THEN 'Escala SAPS3'
				WHEN 35 THEN 'Escala Barthel'
				WHEN 36 THEN 'Escala Morse'
				WHEN 37 THEN 'Escala Macdems'
				WHEN 38 THEN 'Escala NSRAS'
				WHEN 39 THEN 'Escala MSTS'
				WHEN 40 THEN 'Escala Person'
				WHEN 41 THEN 'Escala beck'
				WHEN 42 THEN 'Escala Zarit'
				WHEN 43 THEN 'Escala RQC'
				WHEN 44 THEN 'Escala Bacteriana Silness'
				WHEN 45 THEN 'Escala VALE'
				WHEN 46 THEN 'Escala RASS'
				WHEN 47 THEN 'Escala DownTown'
				WHEN 48 THEN 'Escala Norton'
				WHEN 49 THEN 'Escala Vass'
				WHEN 50 THEN 'Escala Nutricion'
				WHEN 51 THEN 'Escala SQR'
				WHEN 52 THEN 'Escala M_CHAT'
				WHEN 53 THEN 'Escala WHOOLEY'
				WHEN 54 THEN 'Escala Audit-Alcoholismo'
				WHEN 55 THEN 'Escala de Fragilidad de Linda Fried'
				WHEN 56 THEN 'Escala de Autoniomina Lawton Brody'
				WHEN 57 THEN 'Escala GAD'
				WHEN 58 THEN 'Escala MNA'
				WHEN 59 THEN 'Escala MNA Simplificada'
				WHEN 60 THEN 'Escala Assist'
				WHEN 61 THEN 'Escala News'
				WHEN 62 THEN 'Escala CHA2DS2_VASc'
				WHEN 63 THEN 'Escala CRUSADE'
				WHEN 64 THEN 'Escala HAS_BLED'
				WHEN 65 THEN 'Escala HEMORR2HAGES'
				WHEN 66 THEN 'Escala EUROSCOREII'
				WHEN 67 THEN 'Escala NYHA'
				WHEN 68 THEN 'Escala KILLIP'
				WHEN 69 THEN 'Escala PADUA'
				WHEN 70 THEN 'Escala CAPRINI'
				WHEN 71 THEN 'Escala MUST'
				WHEN 72 THEN 'Escala STRONG KIDS'
				WHEN 73 THEN 'Escala VALORACION GLOBAL SUBJETIVA DEL ESTADO NUTRICIONAL'
				WHEN 74 THEN 'Escala TOMO CEST'
				WHEN 75 THEN 'Escala WELLS TVP'
				WHEN 76 THEN 'Escala WELLS TEP'
				WHEN 77 THEN 'Escala NPC'
				WHEN 78 THEN 'Escala GRACE'
				WHEN 79 THEN 'Escala TIMI SEST'
				WHEN 80 THEN 'Escala ANTHONISEN'
				WHEN 81 THEN 'Escala DAS 29'
				WHEN 82 THEN 'Escala mRS'
				WHEN 83 THEN 'Escala HAQ'
				WHEN 84 THEN 'Escala ASPECT'
				WHEN 85 THEN 'Escala Abreviada Desarrollo V3'
				WHEN 86 THEN 'Escala Indice Oleary'
				WHEN 87 THEN 'Escala NIHSS'
            /*PE.NOMBREESCALA*/ end AS Nombre_Escala, 
			ESC.RESULTADO, 

		dbo.InterpretacionEscala(ESC.ID,ESC.TIPOESCALA,ESC.RESULTADO,ESC.RESULTADODECIMAL,PA.IPSEXOPAC) AS Interpretacion,-- se agrega por solicitud en caso 318104
            CA.NOMCENATE AS Centro_Atencion, 
            P.CODPROSAL AS CodMed, 
            P.NOMMEDICO AS MEDICO, 
            E.DESESPECI AS ESPECIALIDAD
     FROM dbo.HCESCALAS AS ESC
	 left join [dbo].[HCPARAESCALAS] as PE on PE.codigo=ESC.TIPOESCALA
          INNER JOIN dbo.INPACIENT AS PA ON PA.IPCODPACI = ESC.IPCODPACI
          INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = ESC.CODCENATE
          INNER JOIN dbo.INPROFSAL AS P ON P.CODPROSAL = ESC.CODPROSAL
          INNER JOIN dbo.INESPECIA AS E ON P.CODESPEC1 = E.CODESPECI
		  WHERE ESC.FECHAREGISTRO >='01/01/2019'
		  --and esc.IPCODPACI='24097615' and NUMINGRES='F4895BFF43'

		  --select distinct TIPOESCALA from dbo.HCESCALAS order by TIPOESCALA
		  --where IPCODPACI='24097615' and NUMINGRES='F4895BFF43'

		  