-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Indicador_Medicamentos_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Indicador_Medicamentos_PB]  AS

     SELECT 
	 'Medicamentos' AS Tipo, 
            ca.NOMCENATE AS Sede,
			prof.codprosal, LTRIM(RTRIM(PROF.MEDPRINOM))+' '+LTRIM(RTRIM(PROF.MEDPRIAPEL)) as Medico, ESP.DESESPECI as Profesion,
              CASE
                 WHEN om.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN om.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN om.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional, 
            MONTH(OM.FECINIDOS) AS Mes, 
            YEAR(OM.FECINIDOS) AS Año, 
            (OM.CANPEDPRO) AS Cant,
			--,case when dx.CODDIAGNO= 'I10x' then 'Hipertensión Arterial'
			--	 when dx.CODDIAGNO between 'I150' and 'I159' then 'Hipertensión Arterial'
			--	 when dx.CODDIAGNO between 'E100' and 'E149' then 'Diabetes Mellitus'
			--	 when dx.CODDIAGNO between 'E780' and 'E785' then 'Hipetrigliceridemia - Hipercolesterolemia'
			--	 when dx.CODDIAGNO in ('E660','E668','E669') then 'Obesidad'
			--	 else 'Morbilidad' end as 'GruposRiesgo',
case when dx.CODDIAGNO= 'I10x' then 'Hipertensión Arterial'   --Pertenece a Programa
when dx.CODDIAGNO between 'I150' and 'I159' then 'Hipertensión Arterial'  --Pertenece a Programa
when dx.CODDIAGNO between 'E100' and 'E149' then 'Diabetes Mellitus'  --Pertenece a Programa
when dx.CODDIAGNO between 'E780' and 'E785' then 'Hipetrigliceridemia - Hipercolesterolemia'  --Pertenece a Programa
when dx.CODDIAGNO in ('E660','E668','E669') then 'Obesidad'   --Pertenece a Programa
when dx.CODDIAGNO in ('Z863') then 'HPEENM'  --Pertenece a Programa
when dx.CODDIAGNO in ('Z001', 'Z000', 'Z002','Z003', 'Z008', 'Z121', 'Z123', 'Z124', 'Z125','Z136', 'Z761','Z762','Z316','Z318', 'Z319','Z309','Z310','Z311','Z312','Z313','Z314','Z315','Z316','Z317','Z318',
'Z319','Z320','Z321','Z322','Z323','Z324','Z325','Z326','Z327','Z328','Z329','Z330','Z331','Z332','Z333','Z334','Z335','Z336','Z337','Z338','Z339','Z340','Z341','Z342','Z343','Z344',
'Z345','Z346','Z347','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z391', 'Z392', 'Z718', 'Z719') then 'RPYM'  --se agrega RPYM  --Pertenece a programa en Medicamentos
 else 'Morbilidad' end as 'GruposRiesgo', 
				 case when cita.TipoCita is null then 'No relaciona Cita' else cita.TipoCita end as TipoCita,
				 --CASE
     --           WHEN red.Red IS NULL
     --           THEN 'Red Externa'
     --           WHEN red.Red IS NOT NULL
     --           THEN red.red
     --       END AS Red,
			case when dx.CODDIAGNO is null then '0000' else dx.CODDIAGNO end as CIE10,
			case when DX.NOMDIAGNO is null then 'Codigo Azul' else DX.NOMDIAGNO end AS Diagnostico,
			m.CODPRODUC as CodProducto, m.DESPRODUC as Producto,
			 CASE
   WHEN DATEDIFF(MONTH,B.IPFECNACI,OM.FECINIDOS)/12 <= '5' THEN						'1. Primera Infancia (0-5)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,OM.FECINIDOS)/12 BETWEEN '6' AND '11' THEN		'2. Infancia (6-11)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,OM.FECINIDOS)/12 BETWEEN '12' AND '17' THEN		'3. Adolescencia (12-17)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,OM.FECINIDOS)/12 BETWEEN '18' AND '28' THEN		'4. Juventud (18-28)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,OM.FECINIDOS)/12 BETWEEN '29' AND '59' THEN		'5. Adultez (29-59)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,OM.FECINIDOS)/12 >= '60' THEN						'6. Vejez (>60)'
 END                                   AS CursoVida,
 OM.NUMINGRES AS Ingreso,
 CASE WHEN B.IPSEXOPAC = '1' THEN 'Masculino' WHEN B.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo, OM.NUMEFOLIO as FolioHC,
 case 
when m.CODPRODUC in ('00626','00082','00083','00098','I00138','00125','00125','00126','00126','01766','01904','02124','01894','01728','00157','00157','00158','00158','00159','00159','00159','01682','01682','01937','00594','00595','00260','00263','00261','00262',
'00333','01749','01701','01746','00246','01745','00250','00251','00320','00330','01950','00329','01711','02031','00424','01697','00486','00485','01918','00487','00488','02067','00520','00522','00521','01512','00530','00531','02032','01674','00532','00532','00532',
'00533','00565','00566','02123','01912','00577','00583','00590','00600','00593','00601','00599','00623','00624','00625','00625','00626','00045','01845','00046','00672','00687','00688','00706','00207','01363','01467','01675','00772','00774','00773','00777','00778',
'00776','01677','01679','00780','00779','00783','00781','01553','00798','00802','00799','01709','00800','00801','01667','00803','00804','02138','00882','00880','00879','00883','00884','00913','00930','00931','00931','01957','01790','00932','01927','01829','01829',
'00933','00934','00936','00939','00018','00017','00019','00319','00965','00965','00961','00963','00966','00962','00967','00960','00967','01690','00959','00958','00529','00689','00914','00916','01286','01287','01289','01483','01484','01485','00985','00986','00980',
'00981','00982','00983','00995','00995','00994','00997','01345','01064','01064','01065','01065','02044','01086','01082','01083','01084','01084','01083','01086','01094','01120','01121','01253','01253','01253','01562','01254','00597','00598','01259','01260','01258',
'01929','01770','01290','01291','01359','01360','01361','01362','01753','01461','01550','01463','01942','00129','00127','00128','00130','00131','01655','01804','01465','01464','01465','01466','01468','01469','01470','01727','01478','01479','01816','01482','01702',
'01486','01333') then 'RIAS'   --Pertenece a Programa
 else 'Morbilidad' end as 'GrupoProducto'



     FROM dbo.HCPRESCRA OM WITH (NOLOCK)
          JOIN dbo.IHLISTPRO M WITH (NOLOCK) ON OM.CODPRODUC = M.CODPRODUC
          JOIN dbo.ADCENATEN CA WITH (NOLOCK) ON OM.CODCENATE = CA.CODCENATE  --tabla identificada para lentitud de vista
		  		  JOIN dbo.INPROFSAL prof WITH (NOLOCK) on OM.CODPROSAL = prof.CODPROSAL
		 JOIN  dbo.INESPECIA ESP WITH (NOLOCK) ON ESP.CODESPECI=prof.CODESPEC1
		 LEFT OUTER JOIN dbo.INDIAGNOS AS DX WITH (NOLOCK) ON DX.CODDIAGNO = om.CODDIAGNO
LEFT OUTER JOIN ViewInternal.IND_RedProfesionales_Jer AS Red WITH (NOLOCK) ON prof.CODESPEC1 = Red.CODESPECI
		  left outer join (select max(e.IPFECHACO) as Fecha,e.NUMINGRES,
								CASE C.CODTIPCIT WHEN 0 THEN 'Primera Vez' WHEN 1 THEN 'Control' WHEN 2 THEN 'Pos Operatorio' WHEN 3 THEN 'Cita Web' END AS TipoCita
							from INDIGO031.dbo.ADCONCOEX as e WITH (NOLOCK)
							inner join INDIGO031.dbo.AGASICITA AS C WITH (NOLOCK) ON C.CODAUTONU=E.NUMCONCIT
							where CONESTADO in ('1','3') and e.IPFECHACO>='01-01-2024'
							group by e.NUMINGRES, C.CODTIPCIT) as cita on cita.NUMINGRES=om.NUMINGRES

--INNER JOIN	dbo.ADINGRESO AS I WITH (NOLOCK) ON I.NUMINGRES = OM.NUMINGRES 
INNER JOIN dbo.INPACIENT AS B WITH (NOLOCK) ON B.IPCODPACI = OM.IPCODPACI 

     WHERE M.TIPPRODUC = 1
           AND om.FECINIDOS >= '01-01-2024' and  om.IPCODPACI not in ('1234567', '12345678', '14141414','9999999') AND om.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM INDIGO031.dbo.HCFOLANUL)
										--) as a
										--where a.Ingreso='3548944'
		   -- GROUP BY CA.NOMCENATE, 
     --         CA.CODCENATE, 
     --         MONTH(OM.FECINIDOS), 0
     --         M.TIPPRODUC, 
     --         YEAR(OM.FECINIDOS),
			  -- ESP.DESESPECI,
			  --PROF.NOMMEDICO, prof.codprosal
