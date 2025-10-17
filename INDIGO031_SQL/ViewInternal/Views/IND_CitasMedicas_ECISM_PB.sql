-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_CitasMedicas_ECISM_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_CitasMedicas_ECISM_PB] AS	
	SELECT *
	FROM (
	SELECT               
            C.IPCODPACI AS IDENTIFICACION,
            CA.NOMCENATE AS sede, 
			CASE
                 WHEN c.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN c.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN c.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
            P.CODPROSAL AS CodMed, 
            P.NOMMEDICO AS MEDICO, 
            rtrim(E.DESESPECI) AS ESPECIALIDAD, 
            C.FECHORAIN AS [FECHA DE CITA], 
            
            CASE C.CODESTCIT
                WHEN '0'
                THEN 'Asignada'
                WHEN '1'
                THEN 'Cumplida'
                WHEN '2'
                THEN 'Incumplida'
                WHEN '3'
                THEN 'Preasignada'
                WHEN 4
                THEN 'Cancelada'
            END AS ESTADO,
   
           
            IIF(H.NUMEFOLIO IS NULL, 'SIN HC', 'CON HC') AS Tiene_HC, 
            IIF(H.NUMEFOLIO IS NULL, IIF(C.CODESTCIT = '0'
                                         AND C.FECHORAIN < DATEADD(DAY, -1, GETDATE()), 'Incumplida',
                                                                                        CASE C.CODESTCIT
                                                                                            WHEN '0'
                                                                                            THEN 'Asignada'
                                                                                            WHEN '1'
                                                                                            THEN 'Cumplida'
                                                                                            WHEN '2'
                                                                                            THEN 'Incumplida'
                                                                                            WHEN '3'
                                                                                            THEN 'Preasignada'
                                                                                            WHEN 4
                                                                                            THEN 'Cancelada'
                                                                                        END), 'Cumplida') AS Estado_Real_Cita,
																						'https://forms.office.com/r/LPJ0SyLy6v' as [Link Cancelacion],
case 
when h.CODDIAGNO= 'I10x' then 'Hipertensión Arterial'   --Pertenece a Programa
when h.CODDIAGNO between 'I150' and 'I159' then 'Hipertensión Arterial'  --Pertenece a Programa
when h.CODDIAGNO between 'E100' and 'E149' then 'Diabetes Mellitus'  --Pertenece a Programa
when h.CODDIAGNO between 'E780' and 'E785' then 'Hipetrigliceridemia - Hipercolesterolemia'  --Pertenece a Programa
when h.CODDIAGNO in ('E660','E668','E669') then 'Obesidad'   --Pertenece a Programa
when h.CODDIAGNO in ('Z001', 'Z000', 'Z002','Z003', 'Z008', 'Z121', 'Z123', 'Z124', 'Z125','Z136', 'Z761','Z762','Z316','Z318', 'Z319','Z309','Z310','Z311','Z312','Z313','Z314','Z315','Z316','Z317','Z318',
'Z319','Z320','Z321','Z322','Z323','Z324','Z325','Z326','Z327','Z328','Z329','Z330','Z331','Z332','Z333','Z334','Z335','Z336','Z337','Z338','Z339','Z340','Z341','Z342','Z343','Z344',
'Z345','Z346','Z347','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z391', 'Z392', 'Z718', 'Z719') then 'RPYM'  --se agrega RPYM  --Pertenece a RPYMM
 else 'Morbilidad' end as 'GruposRiesgo', a.CODACTMED as CodActividad, a.DESACTMED as Actividad
          
     FROM dbo.AGASICITA AS C  
          INNER JOIN dbo.INPACIENT AS PA   ON PA.IPCODPACI = C.IPCODPACI
          INNER JOIN dbo.INPROFSAL AS P   ON P.CODPROSAL = C.CODPROSAL
          INNER JOIN dbo.INESPECIA AS E   ON c.codespeci = E.CODESPECI
          INNER JOIN dbo.AGACTIMED AS A   ON A.CODACTMED = C.CODACTMED
          INNER JOIN dbo.SEGusuaru AS US   ON US.CODUSUARI = C.CODUSUASI
          LEFT OUTER JOIN dbo.ADCONCOEX AS ce on c.IPCODPACI=ce.IPCODPACI and    C.CODAUTONU = CE.NUMCONCIT
          LEFT OUTER JOIN Contract.HealthAdministrator AS EA   ON PA.GENCONENTITY = EA.Id
          INNER JOIN dbo.ADCENATEN AS CA   ON C.CODCENATE = CA.CODCENATE
          LEFT JOIN dbo.HCHISPACA AS H   ON H.NUMINGRES = CE.NUMINGRES and h.id=ce.IDHCHISPACA
        
     WHERE --C.FECHORAIN BETWEEN '2020-12-01' AND '2021-02-01'
     year(C.FECHORAIN)>=2023 and c.codespeci in('365','366','367')  --and  month(C.FECHORAIN)>=7) 
	  ) AS A 
	 WHERE  IDENTIFICACION<>'9999999' 
