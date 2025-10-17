-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Indicador_ProcedimientosNoQX_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Indicador_ProcedimientosNoQX_PB] AS

--Preguntar si se deben incluir los codigos azules
     SELECT  
	 ca.NOMCENATE AS Sede,
            CASE
                    WHEN i.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN i.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN i.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional, 
            LTRIM(RTRIM(M.MEDPRINOM))+' '+LTRIM(RTRIM(M.MEDPRIAPEL)) AS MedicOrdena, 
            LTRIM(RTRIM(EI.DESESPECI)) AS Especialidad, 
            MONTH(I.FECORDMED) AS Mes, 
            YEAR(I.FECORDMED) AS Año, 
            (I.CANSERIPS) AS Cant,
            CASE
                WHEN red.Red IS NULL
                THEN 'Red Externa'
                WHEN red.Red IS NOT NULL
                THEN red.red
            END AS Red,
			case when dx.CODDIAGNO is null then '0000' else dx.CODDIAGNO end as CIE10,
			case when DX.NOMDIAGNO is null then 'Codigo Azul' else DX.NOMDIAGNO end AS Diagnostico, i.NUMINGRES as Ingreso,
			i.codserips as Cups, cu.DESSERIPS as DescripcionCups ,
case 
when i.codserips in ('697101','702203','851102','861203','861801','876801','876802','892901','895100','897011','954626','977100','702201','697100') then 'RIAS'   --Pertenece a Programa
when i.codserips in ('61002','869500','886012','886013','891509','891530','891531','891703','893805','895001','895004','930860','939403','954107','954301',
'954302','954626','992102','992200','992300','992990','J869500-1','J869500-2','J869500-3','891704') then 'Morbilidad' 
 else 'Otros' end as 'GrupoCUPS',  


case when dx.CODDIAGNO= 'I10x' then 'Hipertensión Arterial'   --Pertenece a Programa
when dx.CODDIAGNO between 'I150' and 'I159' then 'Hipertensión Arterial'  --Pertenece a Programa
when dx.CODDIAGNO between 'E100' and 'E149' then 'Diabetes Mellitus'  --Pertenece a Programa
when dx.CODDIAGNO between 'E780' and 'E785' then 'Hipetrigliceridemia - Hipercolesterolemia'  --Pertenece a Programa
when dx.CODDIAGNO in ('E660','E668','E669') then 'Obesidad'   --Pertenece a Programa
when dx.CODDIAGNO in ('Z863') then 'HPEENM'  --Pertenece a Programa
when dx.CODDIAGNO in ('Z001', 'Z000', 'Z002','Z003', 'Z008', 'Z121', 'Z123', 'Z124', 'Z125','Z136', 'Z761','Z762','Z316','Z318', 'Z319','Z309','Z310','Z311','Z312','Z313','Z314','Z315','Z316','Z317','Z318',
'Z319','Z320','Z321','Z322','Z323','Z324','Z325','Z326','Z327','Z328','Z329','Z330','Z331','Z332','Z333','Z334','Z335','Z336','Z337','Z338','Z339','Z340','Z341','Z342','Z343','Z344',
'Z345','Z346','Z347','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z391', 'Z392', 'Z718', 'Z719') then 'RPYM'  --se agrega RPYM  --Pertenece a RPYMM
 else 'Morbilidad' end as 'GruposRiesgo',  
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

     FROM dbo.HCORDPRON AS I
          INNER JOIN dbo.ADCENATEN AS ca  ON I.CODCENATE = ca.CODCENATE
          INNER JOIN dbo.INPROFSAL AS M  ON I.CODPROSAL = M.CODPROSAL
          INNER JOIN dbo.INESPECIA AS EI  ON M.CODESPEC1 = EI.CODESPECI
		  inner join dbo.INCUPSIPS as cu on cu.CODSERIPS=i.CODSERIPS
 		  LEFT OUTER JOIN dbo.INDIAGNOS AS DX  ON DX.CODDIAGNO = I.CODDIAGNO
          LEFT OUTER JOIN ViewInternal.IND_RedProfesionales_Jer AS Red  ON m.CODESPEC1 = Red.CODESPECI
		  left outer join (select max(e.IPFECHACO) as Fecha,e.NUMINGRES,
		  CASE C.CODTIPCIT WHEN 0 THEN 'Primera Vez' WHEN 1 THEN 'Control' WHEN 2 THEN 'Pos Operatorio' WHEN 3 THEN 'Cita Web' END AS TipoCita


from INDIGO031.dbo.ADCONCOEX as e 
inner join INDIGO031.dbo.AGASICITA AS C ON C.CODAUTONU=E.NUMCONCIT
where CONESTADO in ('1','3') and year(e.IPFECHACO)>='2023' 
group by e.NUMINGRES, C.CODTIPCIT) as cita on cita.NUMINGRES=i.NUMINGRES
INNER JOIN	dbo.ADINGRESO AS IG  ON I.NUMINGRES = IG.NUMINGRES AND YEAR(IG.IFECHAING) >= '2023'
INNER JOIN dbo.INPACIENT AS B  ON B.IPCODPACI = IG.IPCODPACI 
     WHERE year(I.FECORDMED) >= '2023'and i.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
	 AND I.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM INDIGO031.dbo.HCFOLANUL)
	 --and i.NUMINGRES='2595529'
     --GROUP BY MONTH(I.FECORDMED), 
     --         ca.NOMCENATE, 
     --         ca.CODCENATE, 
     --          Red.Red, 
     --         YEAR(I.FECORDMED), 
     --         EI.DESESPECI,
			  --DX.NOMDIAGNO,
			  --NUMINGRES,
			  --M.MEDPRINOM,
			  --M.MEDPRIAPEL,
			  --dx.CODDIAGNO,
			  --i.CODSERIPS;
			

--select *
--from dbo.INDIAGNOS
--where CODDIAGNO in ('E660')


--select *
--from INDIGO031.dbo.HCHISPACA
--where NUMINGRES='2853051'

----select *
------max(e.IPFECHACO) as Fecha,e.NUMINGRES,CASE C.CODTIPCIT WHEN 0 THEN 'Primera Vez' WHEN 1 THEN 'Control' WHEN 2 THEN 'Pos Operatorio' WHEN 3 THEN 'Cita Web' END AS TipoCita
----from INDIGO031.dbo.ADCONCOEX as e 
----inner join INDIGO031.dbo.AGASICITA AS C ON C.CODAUTONU=E.NUMCONCIT
----where CONESTADO in ('1','3') and year(e.IPFECHACO)>='2023' and e.NUMINGRES='2873164'
------group by e.NUMINGRES, C.CODTIPCIT

--select *
--from INDIGO031.dbo.HCHISPACA
--where NUMINGRES='2853051'

--select *
--from INDIGO031.dbo.HCORDLABO
--where NUMINGRES='2853051'
