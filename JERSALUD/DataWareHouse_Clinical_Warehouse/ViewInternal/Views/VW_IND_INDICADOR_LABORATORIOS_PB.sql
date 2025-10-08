-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INDICADOR_LABORATORIOS_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_IND_INDICADOR_LABORATORIOS_PB 
AS

     SELECT 
	 ca.NOMCENATE AS Sede,
             CASE
                WHEN I.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN I.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN I.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional, 
            LTRIM(RTRIM(M.MEDPRINOM))+' '+LTRIM(RTRIM(M.MEDPRIAPEL)) AS MedicOrdena, 
            LTRIM(RTRIM(EI.DESESPECI)) AS Especialidad, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
            (I.CANSERIPS) AS Cant,
		    '' 	AS Red,
			case when I.CODDIAGNO is null then '0000' else I.CODDIAGNO end as CIE10,
			case when DX.NOMDIAGNO is null then 'Codigo Azul' else DX.NOMDIAGNO end AS Diagnostico, I.NUMINGRES as Ingreso,
			I.CODSERIPS as Cups, cu.DESSERIPS as DescripcionCups ,
case when DX.CODDIAGNO= 'I10x' then 'Hipertensión Arterial'   --Pertenece a Programa
when DX.CODDIAGNO between 'I150' and 'I159' then 'Hipertensión Arterial'  --Pertenece a Programa
when DX.CODDIAGNO between 'E100' and 'E149' then 'Diabetes Mellitus'  --Pertenece a Programa
when DX.CODDIAGNO between 'E780' and 'E785' then 'Hipetrigliceridemia - Hipercolesterolemia'  --Pertenece a Programa
when DX.CODDIAGNO in ('E660','E668','E669') then 'Obesidad'   --Pertenece a Programa
when DX.CODDIAGNO in ('Z863') then 'HPEENM'  --Pertenece a Programa
when DX.CODDIAGNO in ('Z001', 'Z000', 'Z002','Z003', 'Z008', 'Z121', 'Z123', 'Z124', 'Z125','Z136', 'Z761','Z762','Z316','Z318', 'Z319','Z309','Z310','Z311','Z312','Z313','Z314','Z315','Z316','Z317','Z318',
'Z319','Z320','Z321','Z322','Z323','Z324','Z325','Z326','Z327','Z328','Z329','Z330','Z331','Z332','Z333','Z334','Z335','Z336','Z337','Z338','Z339','Z340','Z341','Z342','Z343','Z344',
'Z345','Z346','Z347','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z391', 'Z392', 'Z718', 'Z719') then 'RPYM'  --se agrega RPYM  --Pertenece a RPYMM
 else 'Morbilidad' end as 'GruposRiesgo',  

				 case when I.CODSERIPS in ('902211','902212','902213','906039', '906249', '906317', '903841', '903815', '903816', '903817', '903818', '903868', 
				 '903895', '906610', '906611', '907012', '907008', 
				 '907009', '901235', '901237', '906127', '906129', '901304', '907106', '903426', '903427', '903026','903604', '903835', '904912', 
				 '903859', '903867', '903866', '904904', '903703') then 'Programas' else 'Morbilidad' end as 'Clasificacion', 
				 case when cita.TipoCita is null then 'No relaciona Cita' else cita.TipoCita end as TipoCita,
				 		  			 CASE
   WHEN DATEDIFF(MONTH,B.IPFECNACI,I.FECORDMED)/12 <= '5' THEN						'1. Primera Infancia (0-5)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,I.FECORDMED)/12 BETWEEN '6' AND '11' THEN		'2. Infancia (6-11)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,I.FECORDMED)/12 BETWEEN '12' AND '17' THEN		'3. Adolescencia (12-17)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,I.FECORDMED)/12 BETWEEN '18' AND '28' THEN		'4. Juventud (18-28)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,I.FECORDMED)/12 BETWEEN '29' AND '59' THEN		'5. Adultez (29-59)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,I.FECORDMED)/12 >= '60' THEN						'6. Vejez (>60)'
 END                                   AS CursoVida,

		   CASE WHEN B.IPSEXOPAC = '1' THEN 'Masculino' WHEN B.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
		   M.CODPROSAL AS CodMedico

     FROM [INDIGO031].[dbo].[HCORDLABO] AS I 
          INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS ca   ON I.CODCENATE = ca.CODCENATE
          INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS M  ON I.CODPROSAL = M.CODPROSAL
          INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS EI  ON M.CODESPEC1 = EI.CODESPECI
		  inner join [INDIGO031].[dbo].[INCUPSIPS] as cu  on cu.CODSERIPS=I.CODSERIPS
 		  LEFT OUTER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS DX  ON DX.CODDIAGNO = I.CODDIAGNO
          LEFT OUTER JOIN [DataWareHouse_Clinical].[ViewInternal].[VW_IND_REDPROFESIONALES_JER] AS Red  ON M.CODESPEC1 = Red.CODESPECI
		  left outer join (select max(e.IPFECHACO) as Fecha,e.NUMINGRES,
		  CASE C.CODTIPCIT WHEN 0 THEN 'Primera Vez' WHEN 1 THEN 'Control' WHEN 2 THEN 'Pos Operatorio' WHEN 3 THEN 'Cita Web' END AS TipoCita

from [INDIGO031].[dbo].[ADCONCOEX] as e 
inner join [INDIGO031].[dbo].[AGASICITA] AS C  ON C.CODAUTONU=e.NUMCONCIT
where CONESTADO in ('1','3') and e.IPFECHACO>= '01-01-2023'
group by e.NUMINGRES, C.CODTIPCIT) as cita on cita.NUMINGRES=I.NUMINGRES

----INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS IG  ON IG.NUMINGRES = I.NUMINGRES 
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS B  ON B.IPCODPACI = I.IPCODPACI 

     WHERE I.FECORDMED >= '01-01-2023' and  I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999') AND I.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM [INDIGO031].[dbo].[HCFOLANUL]) --and I.NUMINGRES='2595529'
