-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_IMO_AD_AG_CITASTRATAMIENTOPACIENTES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_AD_AG_CITASTRATAMIENTOPACIENTES AS

SELECT 
    SEDE,
    Cita,
    TipoTratamiento,
    CodMedico,
    Medico,
    EspecialidadPpalMedico,
    CodigoActividad,
    Actividad,
    CASE     
        WHEN CUPS_Cita LIKE '%PRIMERA VEZ%'
             AND EXISTS (
                 SELECT 1
                 FROM [DataWareHouse_Clinical].[ViewInternal].[VW_IMO_AD_AG_CITASTRATAMIENTOPACIENTES_NOVERIFICA] c2
                 WHERE c2.IdentificacionPaciente = A.IdentificacionPaciente
                   AND c2.Actividad = A.Actividad
                   AND c2.FechaCita < A.FechaCita 
                   AND c2.EstadoCita <> 'Cancelada'
             )
        THEN 'SI'
        WHEN A.CUPS_Cita LIKE '%PRIMERA VEZ%'
        THEN 'NO'
        ELSE NULL
    END AS CitasAnteriores,
    CUPS_Cita,
    FechaAsignacionCita,
    FechaCita,
    FechaDeseada,
    DiasOportunidad,
    Oportunidad_Deseada,
    IdentificacionPaciente,
    Tipo_Documento,
    PrimerApellido,
    SegundoApellido,
    PrimerNombre,
    SegundoNombre,
    Paciente,
    Sexo,
    FechaNacimiento,
    EdadEnAnos,
    Direccion,
    TipoAfiliacion,
    Grupo_Atencion,
    Nit,
    Entidad,
    CódigoEntidad,
    E_mail,
    TelefonoMovil,
    TelefonoPaciente,
    [CodigoConsultorio/Sala],
    [Consultorio/Sala],
    EstiloCita,
    TipoCita,
    EstadoCita,
    CodUsuarioAsigna,
    Usuario_Asigna,
    Fechacancelación,
    Mot_Cancelacion,
    Causa_Cancelacion,
    CodUsuarioCancela,
    ObservaCancela,
    Causa_Inatencion,
    Fecha_Inatencion,
    Usuario_Cancela,
    CodEspecialidad,
    EspecialidadCita,
    Observaciones,
    ZonaApartada,
    Ubicacion,
    Municipio,
    IngresoCita,
    Departamento,
    Gestante,
    EstadoPaciente,
    FASE,
    OTRAFASE,
    CICLO,
    Esquema,
    Cie10_Cita,
    Diagnostico_Cita
FROM (
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
            WHEN A.TIPTRATAMIENTO=1 THEN 'Quimioterapia' 
            WHEN A.TIPTRATAMIENTO=2 THEN 'RadioTerapia' 
            WHEN A.TIPTRATAMIENTO=3 THEN 'Diálisis' 
            WHEN A.TIPTRATAMIENTO=4 THEN 'Braquiterapia' 
            WHEN A.TIPTRATAMIENTO IS NULL THEN 'No Aplica' 
        END AS TipoTratamiento, 
        CASE 
            WHEN C.ACTIVICON=0 THEN A.CODPROSAL
            WHEN C.ACTIVICON=3 THEN ci.CODPROSAL
        END AS CodMedico,
        CASE 
            WHEN C.ACTIVICON=0 THEN D.NOMMEDICO
            WHEN C.ACTIVICON=3 THEN DC.NOMMEDICO    
        END AS Medico,
        CASE 
            WHEN C.ACTIVICON=0 THEN E.DESESPECI
            WHEN C.ACTIVICON=3 THEN ESP.DESESPECI
        END AS EspecialidadPpalMedico,
        C.CODACTMED AS CodigoActividad,
        C.DESACTMED AS Actividad,
        CASE 
            WHEN A.CODTIPCIT = '0' THEN LTRIM(RTRIM(C.CODSERIPS))+' - '+LTRIM(RTRIM(IPSp.DESSERIPS))
            WHEN A.CODTIPCIT = '1' THEN LTRIM(RTRIM(C.CODSERIPSCONTROL))+' - '+LTRIM(RTRIM(IPSc.DESSERIPS))
            WHEN A.CODSERIPS IS NOT NULL THEN LTRIM(RTRIM(IPS.CODSERIPS))+' - '+LTRIM(RTRIM(IPS.DESSERIPS))
        END AS CUPS_Cita,
        A.FECREGSIS AS FechaAsignacionCita,
        A.FECHORAIN AS FechaCita,
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
        B.IPFECNACI AS FechaNacimiento,
        YEAR(GETDATE()) - YEAR(B.IPFECNACI) - 1 AS EdadEnAnos,
        B.IPDIRECCI AS Direccion,
        CASE IPTIPOPAC 
            WHEN 1 THEN 'Contributivo' 
            WHEN 2 THEN 'Subsidiado' 
            WHEN 3 THEN 'Vinculado' 
            WHEN 4 THEN 'Particular' 
            WHEN 5 THEN 'Otro' 
            WHEN 6 THEN 'Desplazado Reg. Contributivo' 
            WHEN 7 THEN 'Desplazado Reg. Subsidiado' 
            WHEN 8 THEN 'Desplazado No Asegurado' 
        END AS TipoAfiliacion,
        GR.Name AS Grupo_Atencion,
        TP.Nit,
        H1.Name AS Entidad,
        H1.HealthEntityCode AS CódigoEntidad,
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
        A.FECHCANCELA AS Fechacancelación,
        A.OBSCAUCAN AS Mot_Cancelacion,
        cac.DESCAUCAN as Causa_Cancelacion,
        A.CANCELUSU AS CodUsuarioCancela,
        A.OBSCAUCAN as ObservaCancela,
        MOT.DESMOTANU as Causa_Inatencion,
        A.FECHAINA as Fecha_Inatencion,
        UC.NOMUSUARI AS Usuario_Cancela,
        A.CODESPECI as CodEspecialidad,
        RTRIM(E1.DESESPECI) AS EspecialidadCita,
        A.OBSERVACI AS Observaciones,
        CASE B.ZONAPARTADA
            WHEN 1 THEN 'Si'
            WHEN 0 THEN 'No'
        END AS ZonaApartada,
        UB.UBINOMBRE AS Ubicacion,
        mu.MUNNOMBRE AS Municipio,
        CASE
            WHEN CO.CODPROSAL = A.CODPROSAL THEN CO.NUMINGRES
            ELSE '0'
        END AS IngresoCita,
        DEP.nomdepart AS Departamento,
        CASE ris.GESTACION 
            WHEN 1 THEN 'Si' 
            ELSE 'No' 
        END AS Gestante,
        CASE B.ESTADOPAC 
            WHEN 1 THEN 'Vivo' 
            WHEN 0 THEN 'Fallecido' 
        END AS EstadoPaciente, 
        A.FASE,
        A.OTRAFASE,
        cid.CICLO,
        ES.Description AS Esquema, 
        CASE 
            WHEN A.TIPSOLICITU=3 THEN CICLO.CODDIAGNO
            WHEN A.CODESTCIT IN ('4','5') THEN NULL
            WHEN A.CODESTCIT NOT IN ('4','5') THEN DX.CODDIAGNO
        END AS Cie10_Cita, 
        CASE 
            WHEN A.TIPSOLICITU=3 THEN CICLO.NOMDIAGNO
            WHEN A.CODESTCIT IN ('4','5') THEN NULL
            WHEN A.CODESTCIT NOT IN ('4','5') THEN DX.NOMDIAGNO
        END AS Diagnostico_Cita 
    FROM [INDIGO035].[dbo].[AGASICITA] AS A
    INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS B       
    LEFT JOIN [INDIGO035].[Contract].[CareGroup] AS GR ON GR.Id = B.GENCAREGROUP        
    LEFT JOIN [INDIGO035].[Contract].[HealthAdministrator] AS H1 ON H1.Id = B.GENCONENTITY ON B.IPCODPACI = A.IPCODPACI
    INNER JOIN [INDIGO035].[dbo].[AGACTIMED] AS C ON C.CODACTMED = A.CODACTMED
    LEFT OUTER JOIN [INDIGO035].[dbo].[INPROFSAL] AS D
    INNER JOIN [INDIGO035].[dbo].[INESPECIA] AS E ON E.CODESPECI = D.CODESPEC1 ON D.CODPROSAL = A.CODPROSAL
    LEFT JOIN [INDIGO035].[dbo].[AGCONSULTORIO] AS H2 ON H2.CODIGO = A.CODIGOCON
    LEFT JOIN [INDIGO035].[dbo].[AGCONSULT] AS H ON H.CODIGOCON = A.CODIGOCON AND H.CODCENATE=A.CODCENATE
    LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS E1 ON E1.CODESPECI = A.CODESPECI
    LEFT JOIN [INDIGO035].[dbo].[SEGusuaru] AS G ON G.CODUSUARI = A.CODUSUASI
    LEFT JOIN [INDIGO035].[dbo].[SEGusuaru] AS UC ON UC.CODUSUARI = A.CANCELUSU
    LEFT JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
    LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu 
    LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = B.AUUBICACI
    LEFT JOIN (
        SELECT MAX(CO.IPFECHCIT) IPFECHCIT, 
               IPCODPACI,
               CODPROSAL,
               NUMINGRES,
               IDHCHISPACA
        FROM [INDIGO035].[dbo].[ADCONCOEX] AS CO
        WHERE (CO.IPFECHCIT >= '01/01/2022 00:00:00') AND (CO.IPFECHCIT >= '01/01/2022 23:59:59')
        GROUP BY IPCODPACI, CODPROSAL, NUMINGRES, IDHCHISPACA
    ) AS CO
        ON CO.IPCODPACI = A.IPCODPACI
           AND CAST(CO.IPFECHCIT AS DATE) = CAST(A.FECHORAIN AS DATE)
           AND A.CODPROSAL = CO.CODPROSAL
    LEFT JOIN [INDIGO035].[dbo].[AGCAUCANC] AS cac ON cac.CODCAUCAN=A.CODCAUCAN
    LEFT OUTER JOIN [INDIGO035].[dbo].[AGENSALAC] AS sala  ON sala.CODCONCEC=A.IDSALA
    LEFT OUTER JOIN [INDIGO035].[dbo].[INCUPSIPS] AS IPS  ON IPS.CODSERIPS=A.CODSERIPS
    LEFT OUTER JOIN [INDIGO035].[dbo].[INCUPSIPS] AS IPSp  ON IPSp.CODSERIPS=C.CODSERIPS
    LEFT OUTER JOIN [INDIGO035].[dbo].[INCUPSIPS] AS IPSc  ON IPSc.CODSERIPS=C.CODSERIPSCONTROL
    LEFT OUTER JOIN [INDIGO035].[dbo].[HCRIESGOSP] AS ris  ON ris.NUMINGRCES=A.NUMINGRES
    LEFT OUTER JOIN [INDIGO035].[dbo].[HCMOANULB] AS MOT  ON MOT.CODMOTANU=A.CODCAUINA
    LEFT OUTER JOIN [INDIGO035].[Common].[ThirdParty] AS TP ON TP.Id=H1.ThirdPartyId
    LEFT OUTER JOIN [INDIGO035].[EHR].[HCORDCICLOSD] AS cid ON cid.ID = A.IDHCORDCICLOSD
    LEFT OUTER JOIN [INDIGO035].[EHR].[HCORDCICLOS] AS ci ON ci.Id = cid.IDHCORDCICLOS
    LEFT OUTER JOIN [INDIGO035].[EHR].[Schemes] AS ES ON ES.Id = ci.SchemesId
    LEFT OUTER JOIN [INDIGO035].[dbo].[INESPECIA] AS ESP ON ESP.CODESPECI = ci.CODESPECI
    LEFT OUTER JOIN [INDIGO035].[dbo].[INPROFSAL] AS DC ON DC.CODPROSAL = ci.CODPROSAL
    LEFT OUTER JOIN [INDIGO035].[dbo].[HCHISPACA] AS hc ON CO.IDHCHISPACA = hc.ID
    LEFT OUTER JOIN [INDIGO035].[dbo].[INDIAGNOS] AS DX ON DX.CODDIAGNO =hc.CODDIAGNO
    LEFT OUTER JOIN (
        SELECT d.ID as IDRelacionCicloCita, s.CODDIAGNO, s.NOMDIAGNO
        FROM [INDIGO035].[EHR].[HCORDCICLOSD] as d
        INNER JOIN [INDIGO035].[EHR].[HCORDQUIMIO] as q ON q.ID=d.IDHCORDQUIMIO
        INNER JOIN [INDIGO035].[dbo].[INDIAGNOS] as s ON s.CODDIAGNO=q.CODDIAGNO
    ) AS CICLO ON CICLO.IDRelacionCicloCita=A.IDHCORDCICLOSD
    WHERE (A.FECHORAIN)>='01-01-2022'
      AND (A.IPCODPACI NOT IN ('000000', '777777', '99999', '00000', '33333', '333333', '3131', '55555', '0000', '0000000','0123456789'))
) AS A