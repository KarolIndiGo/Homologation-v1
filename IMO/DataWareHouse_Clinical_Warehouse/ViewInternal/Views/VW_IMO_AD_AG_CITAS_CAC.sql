-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_IMO_AD_AG_CITAS_CAC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_AG_Citas_CAC AS

SELECT  
    CASE
         WHEN A.CODCENATE IN ('001') THEN 'NEIVA'
         WHEN A.CODCENATE IN ('002') THEN 'PITALITO'
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
        WHEN A.CODTIPCIT = '0' THEN LTRIM(RTRIM(C.CODSERIPS)) + ' - ' + LTRIM(RTRIM(IPSP.DESSERIPS))
        WHEN A.CODTIPCIT = '1' THEN LTRIM(RTRIM(C.CODSERIPSCONTROL)) + ' - ' + LTRIM(RTRIM(IPSC.DESSERIPS))
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
    TP.Nit,
    H1.Name AS Entidad,
    H1.HealthEntityCode AS CodigoEntidad,
    B.CORELEPAC AS E_mail,
    B.IPTELMOVI AS TelefonoMovil,
    B.IPTELEFON AS TelefonoPaciente,
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
    CAC.DESCAUCAN AS Causa_Cancelacion,
    A.CANCELUSU AS CodUsuarioCancela,
    A.OBSCAUCAN AS ObservaCancela,
    MOT.DESMOTANU AS Causa_Inatencion,
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
    MU.DEPMUNCOD as CodMun,
    LTRIM(RTRIM(MU.MUNNOMBRE)) AS Municipio,
    CASE
        WHEN CO.CODPROSAL = A.CODPROSAL THEN CO.NUMINGRES
        ELSE '0'
    END AS IngresoCita,
    DEP.nomdepart AS Departamento,
    CASE RIS.GESTACION 
        WHEN 1 THEN 'Si' 
        ELSE 'No' 
    END AS Gestante,
    CASE B.ESTADOPAC 
        WHEN 1 THEN 'Vivo' 
        WHEN 0 THEN 'Fallecido' 
    END AS EstadoPaciente,
    A.FASE,
    A.OTRAFASE,
    CID.CICLO,
    ES.Description AS Esquema,
    CASE 
        WHEN A.CODESTCIT IN ('4','5') THEN NULL
        ELSE DX.CODDIAGNO 
    END AS Cie10_Cita,
    CASE 
        WHEN A.CODESTCIT IN ('4','5') THEN NULL
        ELSE DX.NOMDIAGNO 
    END AS Diagnostico_Cita
FROM [INDIGO035].[dbo].[AGASICITA] AS A
    INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS B ON B.IPCODPACI = A.IPCODPACI
        LEFT JOIN [INDIGO035].[Contract].[CareGroup] AS GR ON GR.Id = B.GENCAREGROUP
        LEFT JOIN [INDIGO035].[Contract].[HealthAdministrator] AS H1 ON H1.Id = B.GENCONENTITY
    INNER JOIN [INDIGO035].[dbo].[AGACTIMED] AS C ON C.CODACTMED = A.CODACTMED
        LEFT OUTER JOIN [INDIGO035].[dbo].[INPROFSAL] AS D ON D.CODPROSAL = A.CODPROSAL
            INNER JOIN [INDIGO035].[dbo].[INESPECIA] AS E ON E.CODESPECI = D.CODESPEC1
        LEFT JOIN [INDIGO035].[dbo].[AGCONSULTORIO] AS H2 ON H2.CODIGO = A.CODIGOCON
        LEFT JOIN [INDIGO035].[dbo].[AGCONSULT] AS H ON H.CODIGOCON = A.CODIGOCON AND H.CODCENATE = A.CODCENATE
        LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS E1 ON E1.CODESPECI = A.CODESPECI
        LEFT JOIN [INDIGO035].[dbo].[SEGusuaru] AS G ON G.CODUSUARI = A.CODUSUASI
        LEFT JOIN [INDIGO035].[dbo].[SEGusuaru] AS UC ON UC.CODUSUARI = A.CANCELUSU
        LEFT JOIN [INDIGO035].[dbo].[INUBICACI] AS UB ON UB.AUUBICACI = B.AUUBICACI
            LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS MU ON MU.DEPMUNCOD = UB.DEPMUNCOD
                LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = MU.DEPCODIGO
        LEFT JOIN (
            SELECT 
                MAX(CO.IPFECHCIT) AS IPFECHCIT,
                IPCODPACI,
                CODPROSAL,
                NUMINGRES,
                IDHCHISPACA
            FROM [INDIGO035].[dbo].[ADCONCOEX] AS CO
            WHERE CO.IPFECHCIT >= '2025-01-01'
            GROUP BY IPCODPACI, CODPROSAL, NUMINGRES, IDHCHISPACA
        ) AS CO
            ON CO.IPCODPACI = A.IPCODPACI
            AND CAST(CO.IPFECHCIT AS DATE) = CAST(A.FECHORAIN AS DATE)
            AND A.CODPROSAL = CO.CODPROSAL
        LEFT JOIN [INDIGO035].[dbo].[AGCAUCANC] AS CAC ON CAC.CODCAUCAN = A.CODCAUCAN
        LEFT JOIN [INDIGO035].[dbo].[AGENSALAC] AS SALA ON SALA.CODCONCEC = A.IDSALA
        LEFT JOIN [INDIGO035].[dbo].[INCUPSIPS] AS IPS ON IPS.CODSERIPS = A.CODSERIPS
        LEFT JOIN [INDIGO035].[dbo].[INCUPSIPS] AS IPSP ON IPSP.CODSERIPS = C.CODSERIPS
        LEFT JOIN [INDIGO035].[dbo].[INCUPSIPS] AS IPSC ON IPSC.CODSERIPS = C.CODSERIPSCONTROL
        LEFT JOIN [INDIGO035].[dbo].[HCRIESGOSP] AS RIS ON RIS.NUMINGRCES = A.NUMINGRES
        LEFT JOIN [INDIGO035].[dbo].[HCMOANULB] AS MOT ON MOT.CODMOTANU = A.CODCAUINA
        LEFT JOIN [INDIGO035].[Common].[ThirdParty] AS TP ON TP.Id = H1.ThirdPartyId 
        LEFT JOIN [INDIGO035].[EHR].[HCORDCICLOSD] AS CID ON CID.ID = A.IDHCORDCICLOSD
        LEFT JOIN [INDIGO035].[EHR].[HCORDCICLOS] AS CI ON CI.Id = CID.IDHCORDCICLOS
        LEFT JOIN [INDIGO035].[EHR].[Schemes] AS ES ON ES.Id = CI.SchemesId
        LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS ESP ON ESP.CODESPECI = CI.CODESPECI
        LEFT JOIN [INDIGO035].[dbo].[INPROFSAL] AS DC ON DC.CODPROSAL = CI.CODPROSAL
        LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS HC ON HC.ID = CO.IDHCHISPACA
        LEFT JOIN [INDIGO035].[dbo].[INDIAGNOS] AS DX ON DX.CODDIAGNO = HC.CODDIAGNO
WHERE  
      A.FECHORAIN >= '2025-01-01'
  AND A.CODESTCIT = '1'
  AND (A.IPCODPACI NOT IN ( 
      '000000', '777777', '99999', '00000', '33333', '33333', '33333', '33333', '33333', 
      '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '333333', 
      '3131', '33333', '333333', '3131', '33333', '3333', '333333', '33333', '3131', 
      '3333', '333333', '3131', '3333', '333333', '55555', '3333', '333333', '0000', 
      '33333', '3131', '55555', '3333', '0000', '3131', '33333', '55555', '0000000', 
      '3333', '333333', '3131', '33333','0123456789'))
  AND C.DESACTMED NOT IN (
        'Consulta de Psicologia',
        'Consulta de Simulacion y Modelo',
        'Consulta de Trabajo Social'
    )