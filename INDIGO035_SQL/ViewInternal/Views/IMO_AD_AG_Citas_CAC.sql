-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_AG_Citas_CAC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_AD_AG_Citas_CAC] as

SELECT  
    CASE
         WHEN a.codcenate IN ('001') THEN 'NEIVA'
         WHEN a.codcenate IN ('002') THEN 'PITALITO'
    END AS SEDE,    
    CASE C.ACTIVICON
         WHEN 0 THEN 'Consulta Externa'
         WHEN 1 THEN 'Procedimiento Qx'
         WHEN 2 THEN 'Apoyo Diagnóstico'
         WHEN 3 THEN 'Tratamientos Especiales'
         WHEN 4 THEN 'Diálisis'
    END AS Cita,
    CASE 
         WHEN A.TIPTRATAMIENTO = 1 THEN 'Quimioterapia'
         WHEN A.TIPTRATAMIENTO = 2 THEN 'RadioTerapia'
         WHEN A.TIPTRATAMIENTO = 3 THEN 'Diálisis'
         WHEN A.TIPTRATAMIENTO = 4 THEN 'Braquiterapia'
         WHEN A.TIPTRATAMIENTO IS NULL THEN 'No Aplica'
    END AS TipoTratamiento, 
    CASE 
        WHEN C.ACTIVICON = 0 THEN A.CODPROSAL
        WHEN C.ACTIVICON = 3 THEN CI.CODPROSAL
    END AS CodMedico,
    CASE 
        WHEN C.ACTIVICON = 0 THEN D.NOMMEDICO
        WHEN C.ACTIVICON = 3 THEN DC.NOMMEDICO    
    END AS Medico,
    CASE 
        WHEN C.ACTIVICON = 0 THEN E.DESESPECI
        WHEN C.ACTIVICON = 3 THEN ESP.DESESPECI
    END AS EspecialidadPpalMedico,
    C.CODACTMED AS CodigoActividad,
    C.DESACTMED AS Actividad,
    CASE 
        WHEN A.CODTIPCIT = '0' THEN LTRIM(RTRIM(C.CODSERIPS)) + ' - ' + LTRIM(RTRIM(IPSp.DESSERIPS))
        WHEN A.CODTIPCIT = '1' THEN LTRIM(RTRIM(C.CODSERIPSCONTROL)) + ' - ' + LTRIM(RTRIM(IPSc.DESSERIPS))
        WHEN A.CODSERIPS IS NOT NULL THEN LTRIM(RTRIM(IPS.CODSERIPS)) + ' - ' + LTRIM(RTRIM(IPS.DESSERIPS))
    END AS CUPS_Cita,
    A.FECREGSIS AS FechaAsignacionCita,
    CONVERT(VARCHAR(10), A.FECHORAIN, 23) AS FechaCita,
    A.FECITADES AS FechaDeseada,
    DATEDIFF(DAY, A.FECREGSIS, A.FECHORAIN) AS DiasOportunidad,
    DATEDIFF(DAY, A.FECITADES, A.FECHORAIN) AS Oportunidad_Deseada,
    B.IPCODPACI AS IdentificacionPaciente,
    CASE
        WHEN B.IPTIPODOC = '1' THEN 'Cedula de Ciudadania'
        WHEN B.IPTIPODOC = '2' THEN 'Cedula de Extranjeria'
        WHEN B.IPTIPODOC = '3' THEN 'Tarjeta de Identidad'
        WHEN B.IPTIPODOC = '4' THEN 'Registro Civil'
        WHEN B.IPTIPODOC = '5' THEN 'Pasaporte'
        WHEN B.IPTIPODOC = '6' THEN 'Adulto sin Identificacion'
        WHEN B.IPTIPODOC = '7' THEN 'Menor sin Identificacion'
    END AS Tipo_Documento,
    B.IPPRIAPEL AS PrimerApellido,
    B.IPSEGAPEL AS SegundoApellido,
    B.IPPRINOMB AS PrimerNombre,
    B.IPSEGNOMB AS SegundoNombre,
    B.IPNOMCOMP AS Paciente,
    CASE
        WHEN B.IPSEXOPAC = '1' THEN 'Masculino'
        WHEN B.IPSEXOPAC = '2' THEN 'Femenino'
    END AS Sexo,
    CONVERT(VARCHAR(10),B.IPFECNACI, 23) AS  FechaNacimiento,
    YEAR(GETDATE()) - YEAR(B.IPFECNACI) - 1 AS EdadEnAnos,
    B.IPDIRECCI AS Direccion,
    CASE IPTIPOPAC
        WHEN 1 THEN 'C: Régimen Contributivo'
        WHEN 2 THEN 'S: Régimen Subsidiado'
        WHEN 3 THEN 'N: No asegurado'
        WHEN 9 THEN 'E: Régimen especial'
        WHEN 10 THEN 'P: Regímenes de excepción'
        
    END AS TipoAfiliacion,
    GR.Name AS Grupo_Atencion,
    TP.NIT,
    H1.Name AS Entidad,
    H1.HealthEntityCode AS CodigoEntidad,
    B.CORELEPAC AS E_mail,
    --B.IPTELMOVI AS TelefonoMovil,
    CONCAT(B.IPTELEFON,' ',B.IPTELMOVI) AS TelefonoPaciente, --en este
    CASE 
        WHEN A.CODIGOCON IS NULL THEN CODIGSALA 
        ELSE A.CODIGOCON 
    END AS [CodigoConsultorio/Sala],
    CASE 
        WHEN H.DESCRICON IS NULL THEN DESCRIPSAL 
        ELSE H.DESCRICON 
    END AS [Consultorio/Sala],
    CASE 
        WHEN A.CODTIPCIT = '0' THEN '1aVez'
        WHEN A.CODTIPCIT = '1' THEN 'Control'
        WHEN A.CODTIPCIT = '2' THEN 'PosOperatorio'
        WHEN A.CODTIPCIT = '3' THEN 'Cita Web'
        WHEN A.CODTIPCIT = '4' THEN 'Extra'
        WHEN A.CODTIPCIT IS NULL THEN 'Sin dato'
    END AS EstiloCita,
    CASE A.CODTIPSOL
        WHEN '0' THEN 'Personal'
        WHEN '1' THEN 'Telefonica'
    END AS TipoCita,
    CASE A.CODESTCIT
        WHEN '0' THEN 'Asignada'
        WHEN '1' THEN 'Cumplida'
        WHEN '2' THEN 'Incumplida'
        WHEN '3' THEN 'Preasignada'
        WHEN '4' THEN 'Cancelada'
        WHEN '5' THEN 'Inatención'
    END AS EstadoCita,
    RTRIM(A.CODUSUASI) AS CodUsuarioAsigna,
    G.NOMUSUARI AS Usuario_Asigna,
    A.FECHCANCELA AS FechaCancelación,
    A.OBSCAUCAN AS Mot_Cancelacion,
    cac.DESCAUCAN AS Causa_Cancelacion,
    A.CANCELUSU AS CodUsuarioCancela,
    A.OBSCAUCAN AS ObservaCancela,
    mot.DESMOTANU AS Causa_Inatencion,
    A.FECHAINA AS Fecha_Inatencion,
    UC.NOMUSUARI AS Usuario_Cancela,
    A.CODESPECI AS CodEspecialidad,
    RTRIM(E1.DESESPECI) AS EspecialidadCita,
    A.OBSERVACI AS Observaciones,
    CASE B.ZONAPARTADA
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No'
    END AS ZonaApartada,
    UB.UBINOMBRE AS Ubicacion,
	mu.DEPMUNCOD as CodMun,
    ltrim(rtrim(mu.MUNNOMBRE)) AS Municipio,
    CASE
        WHEN CO.CODPROSAL = A.CODPROSAL THEN CO.NUMINGRES
        ELSE '0'
    END AS IngresoCita,
    DEP.nomdepart AS Departamento,
    CASE ris.gestacion 
        WHEN 1 THEN 'Si' 
        ELSE 'No' 
    END AS Gestante,
    CASE b.estadopac 
        WHEN 1 THEN 'Vivo' 
        WHEN 0 THEN 'Fallecido' 
    END AS EstadoPaciente,
    A.Fase,
    A.OtraFase,
    CID.Ciclo,
    ES.DESCRIPTION AS Esquema,
    CASE 
        WHEN A.CODESTCIT IN ('4','5') THEN NULL
        ELSE DX.CODDIAGNO 
    END AS Cie10_Cita,
    CASE 
        WHEN A.CODESTCIT IN ('4','5') THEN NULL
        ELSE DX.NOMDIAGNO 
    END AS Diagnostico_Cita
FROM dbo.AGASICITA AS A
    INNER JOIN dbo.INPACIENT AS B ON B.IPCODPACI = A.IPCODPACI
        LEFT JOIN Contract.CareGroup AS GR ON GR.Id = B.GENCAREGROUP
        LEFT JOIN Contract.HealthAdministrator AS H1 ON H1.Id = B.GENCONENTITY
    INNER JOIN dbo.AGACTIMED AS C ON C.CODACTMED = A.CODACTMED
        LEFT OUTER JOIN dbo.INPROFSAL AS D ON D.CODPROSAL = A.CODPROSAL
            INNER JOIN dbo.INESPECIA AS E ON E.CODESPECI = D.CODESPEC1
        LEFT JOIN dbo.AGCONSULTORIO AS H2 ON H2.CODIGO = A.CODIGOCON
        LEFT JOIN dbo.AGCONSULT AS H ON H.CODIGOCON = A.CODIGOCON AND H.CODCENATE = A.CODCENATE
        LEFT JOIN dbo.INESPECIA AS E1 ON E1.CODESPECI = A.CODESPECI
        LEFT JOIN dbo.SEGusuaru AS G ON G.CODUSUARI = A.CODUSUASI
        LEFT JOIN dbo.SEGusuaru AS UC ON UC.CODUSUARI = A.CANCELUSU
        LEFT JOIN dbo.INUBICACI AS UB ON UB.AUUBICACI = B.AUUBICACI
            LEFT JOIN dbo.INMUNICIP AS mu ON mu.DEPMUNCOD = UB.DEPMUNCOD
                LEFT JOIN dbo.INDEPARTA AS DEP ON DEP.depcodigo = mu.DEPCODIGO
        LEFT JOIN (
            SELECT 
                MAX(CO.IPFECHCIT) AS IPFECHCIT,
                IPCODPACI,
                CODPROSAL,
                NUMINGRES,
                IDHCHISPACA
            FROM dbo.ADCONCOEX AS CO
            WHERE CO.IPFECHCIT >= '2025-01-01'
            GROUP BY IPCODPACI, CODPROSAL, NUMINGRES, IDHCHISPACA
        ) AS CO
            ON CO.IPCODPACI = A.IPCODPACI
            AND CAST(CO.IPFECHCIT AS DATE) = CAST(A.FECHORAIN AS DATE)
            AND A.CODPROSAL = CO.CODPROSAL
        LEFT JOIN dbo.AGCAUCANC AS cac ON cac.CODCAUCAN = A.CODCAUCAN
        LEFT JOIN dbo.AGENSALAC AS sala ON sala.CODCONCEC = A.IDSALA
        LEFT JOIN dbo.INCUPSIPS AS IPS ON IPS.CODSERIPS = A.CODSERIPS
        LEFT JOIN dbo.INCUPSIPS AS IPSp ON IPSp.CODSERIPS = C.CODSERIPS
        LEFT JOIN dbo.INCUPSIPS AS IPSc ON IPSc.CODSERIPS = C.CODSERIPSCONTROL
        LEFT JOIN dbo.HCRIESGOSP AS ris ON ris.NUMINGRCES = A.NUMINGRES
        LEFT JOIN dbo.HCMOANULB AS mot ON mot.CODMOTANU = A.CODCAUINA
        LEFT JOIN Common.ThirdParty AS TP ON TP.ID = H1.ThirdPartyId 
        LEFT JOIN EHR.HCORDCICLOSD AS cid ON cid.ID = A.IDHCORDCICLOSD
        LEFT JOIN EHR.HCORDCICLOS AS ci ON ci.Id = cid.IDHCORDCICLOS
        LEFT JOIN EHR.Schemes AS ES ON ES.Id = ci.SchemesId
        LEFT JOIN dbo.INESPECIA AS ESP ON ESP.CODESPECI = ci.CODESPECI
        LEFT JOIN dbo.INPROFSAL AS DC ON DC.CODPROSAL = ci.CODPROSAL
        LEFT JOIN dbo.HCHISPACA AS hc ON hc.ID = CO.IDHCHISPACA
        LEFT JOIN dbo.INDIAGNOS AS DX ON DX.CODDIAGNO = hc.CODDIAGNO
WHERE  
      A.FECHORAIN >= '2025-01-01'
  AND A.CODESTCIT = '1'
AND (A.IPCODPACI NOT IN ( '000000', '777777', '99999', '00000', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '333333', '3131', '33333', '333333', '3131', '33333', '3333', '333333', '33333',
'3131', '3333', '333333', '3131', '3333', '333333', '55555', '3333', '333333', '0000', '33333', '3131', '55555', '3333', '0000', '3131', '33333', '55555', '0000000', '3333', '333333', '3131', '33333','0123456789'))
  --AND C.DESACTMED NOT IN (
  --      'Consulta de Psicologia',
  --      'Consulta de Simulacion y Modelo',
  --      'Consulta de Trabajo Social')
 AND DX.CODDIAGNO IN (
    'C530','C531','C538','C539','D060','D061','D067','D069',
    'C180','C181','C182','C183','C184','C185','C186','C187','C188','C189',
    'C19X','C20X','C210','C211','C212','C218','D010','D011','D012','D013',
    'C160','C161','C162','C163','C164','C165','C166','C168','C169','D002',
    'C810','C811','C812','C813','C817','C819','C910','C920','C924','C925',
    'C500','C501','C502','C503','C504','C505','C506','C508','C509','D050',
    'D051','D057','D059','C430','C431','C432','C433','C434','C435','C436',
    'C437','C438','C439','D030','D031','D032','D033','D034','D035','D036',
    'D037','D038','D039','C820','C821','C822','C827','C829','C830','C831',
    'C832','C833','C834','C835','C836','C837','C838','C839','C840','C841',
    'C842','C843','C844','C845','C850','C851','C857','C859','C960','C961',
    'C962','C963','C967','C969','C61X','D075','C33X','C340','C341','C342',
    'C343','C348','C349','D021','D022','C000','C001','C002','C003','C004',
    'C005','C006','C008','C009','C01X','C020','C021','C022','C023','C024',
    'C028','C029','C030','C031','C039','C040','C041','C048','C049','C050',
    'C051','C052','C058','C059','C060','C061','C062','C068','C069','C07X',
    'C080','C081','C088','C089','C090','C091','C098','C099','C100','C101',
    'C102','C103','C104','C108','C109','C110','C111','C112','C113','C118',
    'C119','C12X','C130','C131','C132','C138','C139','C140','C142','C148',
    'D000','C150','C151','C152','C153','C154','C155','C158','C159','C170',
    'C171','C172','C173','C178','C179','C220','C221','C222','C223','C224',
    'C227','C229','C23X','C240','C241','C248','C249','C250','C251','C252',
    'C253','C254','C257','C258','C259','C260','C261','C268','C269','D001',
    'D014','D015','D017','D019','C300','C301','C310','C311','C312','C313',
    'C318','C319','C320','C321','C322','C323','C328','C329','C37X','C380',
    'C381','C382','C383','C384','C388','C390','C398','C399','D020','D023',
    'D024','C400','C401','C402','C403','C408','C409','C410','C411','C412',
    'C413','C414','C418','C419','C440','C441','C442','C443','C444','C445',
    'C446','C447','C448','C449','D040','D041','D042','D043','D044','D045',
    'D046','D047','D048','D049','C450','C451','C452','C457','C459','C460',
    'C461','C462','C463','C467','C468','C469','C470','C471','C472','C473',
    'C474','C475','C476','C478','C479','C480','C481','C482','C488','C490',
    'C491','C492','C493','C494','C495','C496','C498','C499','C510','C511',
    'C512','C518','C519','C52X','C540','C541','C542','C543','C548','C549',
    'C55X','C56X','C570','C571','C572','C573','C574','C577','C578','C579',
    'C58X','D070','D071','D072','D073','C600','C601','C602','C608','C609',
    'C620','C621','C629','C630','C631','C632','C637','C638','C639','D074',
    'D076','C64X','C65X','C66X','C670','C671','C672','C673','C674','C675',
    'C676','C677','C678','C679','C680','C681','C688','C689','D090','D091',
    'C690','C691','C692','C693','C694','C695','C696','C698','C699','C700',
    'C701','C709','C710','C711','C712','C713','C714','C715','C716','C717',
    'C718','C719','C720','C721','C722','C723','C724','C725','C728','C729',
    'D092','C73X','C740','C741','C749','C750','C751','C752','C753','C754',
    'C755','C758','C759','D093','C760','C761','C762','C763','C764','C765',
    'C767','C768','C80X','C800','C809','C97X','D097','D099','C880','C881',
    'C882','C883','C887','C889','C900','C901','C902','C911','C912','C913',
    'C914','C915','C917','C919','C921','C922','C923','C927','C929','C930',
    'C931','C932','C937','C939','C940','C941','C942','C943','C944','C945',
    'C947','C950','C951','C952','C957','C959','D45X','D460','D461','D462',
    'D463','D464','D467','D469','D471','D473','D752','D760','C770','C771',
    'C772','C773','C774','C775','C778','C779','C780','C781','C782','C783',
    'C784','C785','C786','C787','C788','C790','C791','C792','C793','C794',
    'C795','C796','C797','C798','C799','C814','C823','C824','C825','C826',
    'C846','C847','C848','C849','C852','C860','C861','C862','C863','C864',
    'C865','C866','C884','C903','C916','C918','C926','C928','C933','C946',
    'C964','C965','C966','C968','D465','D466','D474','D475'

    ) --and B.IPCODPACI = '1003818811'

