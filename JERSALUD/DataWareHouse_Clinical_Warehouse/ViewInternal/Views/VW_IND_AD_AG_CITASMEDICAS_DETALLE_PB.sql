-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AD_AG_CITASMEDICAS_DETALLE_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AD_AG_CITASMEDICAS_DETALLE_PB
AS

SELECT DISTINCT  CASE C.ACTIVICON WHEN 0 THEN 'Consulta Ext.' WHEN 1 THEN 'Procedimiento Qx' WHEN 2 THEN 'Apoyo Dx' END AS Cita,
--case sala.tiposervic when  '1' then  'Laboratorio' when '2' then 'Imagenes Diagnosticas' end as TipoServicio ,
     CA.NOMCENATE AS sede, 
   CASE
                WHEN A.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN A.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN A.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional, 
     
    A.CODPROSAL as CodMedico,ltrim(rtrim(D.MEDPRINOM))+' '+ltrim(rtrim(D.MEDPRIAPEL)) AS Medico,
    E.DESESPECI AS EspecilaidadPpalMedico,
    C.DESACTMED AS Actividad,
	ltrim(rtrim(IPS.CODSERIPS)) as CUPS,
	ltrim(rtrim(IPS.DESSERIPS)) AS CUPS_Cita,
    A.FECREGSIS AS FechaAsignacionCita,
    A.FECHORAIN AS FechaCita,
	A.FECITADES AS FechaDeseada,
	A.FECHAOFERTADA as FechaOfertada,
	DATEDIFF(DAY, A.FECREGSIS, A.FECHORAIN) - INDIGO031.ViewInternal.DiasNoLaborales( A.FECREGSIS, A.FECHORAIN)  AS DiasOportunidad,
	DATEDIFF(DAY, A.FECITADES, A.FECHORAIN) - INDIGO031.ViewInternal.DiasNoLaborales( A.FECITADES, A.FECHORAIN)  AS Oportunidad_Deseada,
	DATEDIFF(HOUR, A.FECITADES, A.FECHORAIN) AS [Oportunidad_Deseada(HR)],
	DATEDIFF(DAY, A.FECHAOFERTADA, A.FECHORAIN) - INDIGO031.ViewInternal.DiasNoLaborales( A.FECHAOFERTADA, A.FECHORAIN) as Oportunidad_Ofertada,
	 CASE WHEN B.IPTIPODOC = '1' THEN 'CC' WHEN B.IPTIPODOC = '2' THEN 'CE' WHEN B.IPTIPODOC =  '3' THEN 'TI' WHEN B.IPTIPODOC ='4' THEN 'RC' WHEN B.IPTIPODOC ='5' THEN 'PA' WHEN B.IPTIPODOC ='6' THEN 'AS' WHEN B.IPTIPODOC ='7' THEN 'MS' 
WHEN B.IPTIPODOC ='8' THEN 'NU' WHEN B.IPTIPODOC ='9' THEN 'NV' WHEN B.IPTIPODOC ='10' THEN 'CD' WHEN B.IPTIPODOC ='11' THEN 'SC' WHEN B.IPTIPODOC ='12' THEN 'PE' WHEN B.IPTIPODOC ='13' THEN 'PT' WHEN B.IPTIPODOC ='14' THEN 'DE' 
WHEN B.IPTIPODOC ='15' THEN 'SI' WHEN B.IPTIPODOC ='16' THEN 'NI'  END AS TipoDocumento, 
	 B.IPCODPACI AS IdentificacionPaciente,
	 B.IPNOMCOMP AS Paciente, B.IPPRIAPEL AS PrimerApellido, B.IPSEGAPEL AS SegApellido, B.IPPRINOMB AS PrimerNombre, B.IPSEGNOMB AS SegNombre, 
    CASE
        WHEN B.IPSEXOPAC = '1' THEN
            'M'
        WHEN B.IPSEXOPAC = '2' THEN
            'F'
    END AS Sexo,
   
	DATEDIFF(MONTH,B.IPFECNACI,A.FECHORAIN)/12 AS EdadEnAños,
    

	tp.Nit as Nit,
   
    CASE A.CODTIPCIT
        WHEN '0' THEN
            '1aVez'
        WHEN '1' THEN
            'Control'
        WHEN '2' THEN
            'PosOperatorio'
        WHEN '4' THEN
            'Extra'
    END AS EstiloCita,
    
    CASE A.CODESTCIT
        WHEN '0' THEN
            'Asignada'
        WHEN '1' THEN
            'Cumplida'
        WHEN '2' THEN
            'Incumplida'
        WHEN '3' THEN
            'Preasignada'
        WHEN '4' THEN
            'Cancelada'
			  WHEN '5' THEN
            'Inatención'
    END AS EstadoCita,
    G.CODUSUARI as CodUsuAsigna,
    G.NOMUSUARI AS Usuario_Asigna,
    A.FECHCANCELA AS Fechacancelación,
	cac.DESCAUCAN as Causa_Cancelacion,
	A.OBSCAUCAN as Observ_Cancela,
	INA.DESMOTANU AS Causa_Inatencion,
	A.OBSCAUINA as Observ_Inatencion,
    rtrim(E1.DESESPECI) AS EspecialidadCita, 
    mu.MUNNOMBRE AS Municipio,
    DEP.nomdepart AS Departamento,
	datename(weekday,A.FECREGSIS) as DiaSemana,
	A.CODESPECI as CodEspecialidad,
	tp.Name as Entidad,
	'https://forms.office.com/r/LPJ0SyLy6v' as [Link Cancelacion],
	rtrim(A.CODPROSAL)+rtrim(E1.DESESPECI)+CA.NOMCENATE as LLAVE,
	A.CODAUTONU AS IdCita,
	case 
when HC.CODDIAGNO= 'I10x' then 'Hipertensión Arterial'   --Pertenece a Programa
when HC.CODDIAGNO between 'I150' and 'I159' then 'Hipertensión Arterial'  --Pertenece a Programa
when HC.CODDIAGNO between 'E100' and 'E149' then 'Diabetes Mellitus'  --Pertenece a Programa
when HC.CODDIAGNO between 'E780' and 'E785' then 'Hipetrigliceridemia - Hipercolesterolemia'  --Pertenece a Programa
when HC.CODDIAGNO in ('E660','E668','E669') then 'Obesidad'   --Pertenece a Programa
when HC.CODDIAGNO in ('Z001', 'Z000', 'Z002','Z003', 'Z008', 'Z121', 'Z123', 'Z124', 'Z125','Z136', 'Z761','Z762','Z316','Z318', 'Z319','Z309','Z310','Z311','Z312','Z313','Z314','Z315','Z316','Z317','Z318',
'Z319','Z320','Z321','Z322','Z323','Z324','Z325','Z326','Z327','Z328','Z329','Z330','Z331','Z332','Z333','Z334','Z335','Z336','Z337','Z338','Z339','Z340','Z341','Z342','Z343','Z344',
'Z345','Z346','Z347','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z391', 'Z392', 'Z718', 'Z719') then 'RPYM'  --se agrega RPYM  --Pertenece a RPYMM
 else 'Morbilidad' end as 'GruposRiesgo'

FROM [INDIGO031].[dbo].[AGASICITA] AS A
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS B
LEFT JOIN [INDIGO031].[Contract].[CareGroup] AS GR ON GR.Id = B.GENCAREGROUP
LEFT JOIN [INDIGO031].[Contract].[HealthAdministrator] AS H1 ON H1.Id = B.GENCONENTITY
        ON B.IPCODPACI = A.IPCODPACI
INNER JOIN [INDIGO031].[dbo].[AGACTIMED] AS C ON C.CODACTMED = A.CODACTMED
LEFT OUTER JOIN [INDIGO031].[dbo].[INPROFSAL] AS D
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS E ON E.CODESPECI = D.CODESPEC1
        ON D.CODPROSAL = A.CODPROSAL
LEFT JOIN [INDIGO031].[dbo].[AGCONSULTORIO] AS H ON H.CODIGO = A.CODIGOCON
LEFT JOIN [INDIGO031].[dbo].[INESPECIA] AS E1 ON E1.CODESPECI = A.CODESPECI
LEFT JOIN [INDIGO031].[dbo].[SEGusuaru] AS G ON G.CODUSUARI = A.CODUSUASI
LEFT JOIN [INDIGO031].[dbo].[SEGusuaru] AS UC ON UC.CODUSUARI = A.CANCELUSU
LEFT JOIN [INDIGO031].[dbo].[INUBICACI] AS UB ON UB.AUUBICACI = B.AUUBICACI
LEFT JOIN [INDIGO031].[dbo].[INMUNICIP] AS mu ON mu.DEPMUNCOD = UB.DEPMUNCOD
LEFT JOIN [INDIGO031].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO
left join [INDIGO031].[dbo].[AGCAUCANC] as cac on cac.CODCAUCAN=A.CODCAUCAN
LEFT OUTER JOIN [INDIGO031].[dbo].[INCUPSIPS] AS IPS  ON IPS.CODSERIPS=A.CODSERIPS
left outer join [INDIGO031].[Common].[ThirdParty] as tp on tp.Id=H1.ThirdPartyId
left outer join [INDIGO031].[dbo].[ADCENATEN] AS CA  ON CA.CODCENATE = A.CODCENATE
LEFT OUTER JOIN (SELECT CODMOTANU, DESMOTANU
								FROM [INDIGO031].[dbo].[HCMOANULB]
								WHERE (TIPSERIPS = '9')) AS INA ON INA.CODMOTANU=A.CODCAUINA
LEFT OUTER JOIN ( SELECT MAX(IDHCHISPACA) AS IDHCHISPACA, NUMCONCIT, IPCODPACI, MAX(NUMINGRES) AS NUMINGRES
    FROM [INDIGO031].[dbo].[ADCONCOEX]
    WHERE CONESTADO = '3' and year(IPFECHCIT)>='2023' --AND NUMCONCIT='2290791'
    GROUP BY NUMCONCIT, IPCODPACI) AS CE1 on A.IPCODPACI=CE1.IPCODPACI and    A.CODAUTONU = CE1.NUMCONCIT
LEFT JOIN [INDIGO031].[dbo].[HCHISPACA] AS HC   ON HC.NUMINGRES = CE1.NUMINGRES and HC.ID=CE1.IDHCHISPACA
WHERE 
       year(A.FECHORAIN)>=2023
     -- AND (A.FECHORAIN <= '31/12/2020 23:59:59')
     AND (A.IPCODPACI NOT IN ( '000000', '777777', '99999', '00000', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '333333', '3131', '33333', '333333', '3131', '33333', '3333', '333333', '33333',
'3131', '3333', '333333', '3131', '3333', '333333', '55555', '3333', '333333', '0000', '33333', '3131', '55555', '3333', '0000', '3131', '33333', '55555', '0000000', '3333', '333333', '3131', '33333','9999999' ))