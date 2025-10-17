-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: NA_DemandaInducidaECIS-M
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[NA_DemandaInducidaECIS-M] AS

     SELECT DISTINCT 
            NP.ID, 
            NP.NUMINGRES AS Ingreso,
            CASE P.IPTIPODOC
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
            END AS Tipo_Documento_Paciente, 
            NP.IPCODPACI AS Paciente, 
            P.IPNOMCOMP AS Nombre_Paciente, 
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS Telefono, 
            P.IPTELMOVI AS Celular, 
            P.IPFECNACI AS Fecha_Nacimiento, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS Edad, 
            NP.FECHACREACION AS Fecha_Nota, 
            TN.NOMBRE AS Nombre_Nota, 
            --PR.NOMMEDICO AS Medico, 
            CA.NOMCENATE AS Centro_Atencion,
			US.NOMUSUARI AS USUARIO,
         (
		SELECT 
			CASE 
				WHEN ND.VALOR ='1' THEN 'Efectiva'
				WHEN ND.VALOR ='2' THEN 'No efectiva'
				ELSE ND.VALOR
			END
		FROM dbo.NTNOTASADMINISTRATIVASD AS ND
		WHERE ND.IDNTVARIABLE = 30
			  AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
	 ) AS 'Resultado de llamada o visita',
		 
		 (
		 SELECT TVL.NOMBRE
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 104
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Grupo, 
	 (
		SELECT 
			CASE 
				WHEN ND.VALOR ='01' THEN 'Si'
				WHEN ND.VALOR ='02' THEN 'No'
				ELSE ND.VALOR
			END
		FROM dbo.NTNOTASADMINISTRATIVASD AS ND
		WHERE ND.IDNTVARIABLE = 120
		
			  AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
			  
	 ) AS 'Visita Aceptada',
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 110
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS 'Fecha Programacion Visita',
	 (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 103
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS 'Observaciones ECIS',CASE
                 WHEN CA.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN CA.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN CA.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional
	 



     FROM dbo.NTNOTASADMINISTRATIVASC AS NP 
          INNER JOIN dbo.NTADMINISTRATIVAS AS TN  ON TN.ID = NP.IDNOTAADMINISTRATIVA
          INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = NP.IPCODPACI
          INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = NP.CODCENATE
          --INNER JOIN dbo.INPROFSAL AS PR  ON PR.CODPROSAL = NP.CODUSUARI
		  INNER JOIN dbo.SEGusuaru AS US ON US.CODUSUARI = NP.CODUSUARI
     WHERE 
tn.nombre = 'Demanda inducida ECIS-M' --and NP.ID='229086'



--select * from dbo.NTNOTASADMINISTRATIVASC
--where IPCODPACI='1053335249'
--select * from dbo.NTNOTASADMINISTRATIVASD
--where IDNTNOTASADMINISTRATIVASC='232190'
--select * from dbo.NTVARIABLES
--where ID in('103','104','110','30','120')

