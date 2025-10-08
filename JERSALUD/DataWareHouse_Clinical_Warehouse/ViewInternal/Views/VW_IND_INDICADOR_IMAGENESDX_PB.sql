-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INDICADOR_IMAGENESDX_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_INDICADOR_IMAGENESDX_PB 
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
    CASE
        WHEN Red.Red IS NULL
        THEN 'Red Externa'
        WHEN Red.Red IS NOT NULL
        THEN Red.Red
    END AS Red,
    case when DX.CODDIAGNO is null then '0000' else DX.CODDIAGNO end as CIE10,
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
  M.CODPROSAL AS CodMedico,

  			case 
when I.CODSERIPS in ('881201','881431','881432','881435','881436','881437','882298') then 'RIAS'   --Pertenece a Programa
when I.CODSERIPS in ('441302','452305','879111','879131','879301','879430','879460','879510','879520','881112','881132','881141','881151','881202','881210','881211','881301',
'881302','881306','881332','881401','881402','881501','881502','881510','881521','881601','881610','881612','881620','881621','881630','882112','882203','882222','882307',
'882308','882316','882317','883101','883102','883111','883210','883220','883230','883232','883351','883401','883430','883440','883512','883522','920202','920208','881130','882106') then 'Morbilidad' 
 else 'Otros' end as 'GrupoCUPS'

     FROM [INDIGO031].[dbo].[HCORDIMAG] AS I
          INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS ca  ON I.CODCENATE = ca.CODCENATE
          INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS M  ON I.CODPROSAL = M.CODPROSAL
          INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS EI  ON M.CODESPEC1 = EI.CODESPECI
		  inner join [INDIGO031].[dbo].[INCUPSIPS] as cu on cu.CODSERIPS=I.CODSERIPS
 		  LEFT OUTER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS DX  ON DX.CODDIAGNO = I.CODDIAGNO
          LEFT OUTER JOIN [DataWareHouse_Clinical].[ViewInternal].[VW_IND_REDPROFESIONALES_JER] AS Red  ON M.CODESPEC1 = Red.CODESPECI
		  left outer join (select max(e.IPFECHACO) as Fecha,e.NUMINGRES,
		  CASE C.CODTIPCIT WHEN 0 THEN 'Primera Vez' WHEN 1 THEN 'Control' WHEN 2 THEN 'Pos Operatorio' WHEN 3 THEN 'Cita Web' END AS TipoCita
from [INDIGO031].[dbo].[ADCONCOEX] as e 
inner join [INDIGO031].[dbo].[AGASICITA] AS C ON C.CODAUTONU=e.NUMCONCIT
where CONESTADO in ('1','3') and year(e.IPFECHACO)>='2023' 
group by e.NUMINGRES, C.CODTIPCIT) as cita on cita.NUMINGRES=I.NUMINGRES
INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS IG  ON I.NUMINGRES = IG.NUMINGRES AND YEAR(IG.IFECHAING) >= '2023'
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS B  ON B.IPCODPACI = IG.IPCODPACI
WHERE year(I.FECORDMED) >= '2023'and I.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')
AND I.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
                                FROM [INDIGO031].[dbo].[HCFOLANUL])
