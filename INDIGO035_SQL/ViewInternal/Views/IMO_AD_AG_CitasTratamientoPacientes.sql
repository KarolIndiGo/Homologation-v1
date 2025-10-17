-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_AG_CitasTratamientoPacientes
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IMO_AD_AG_CitasTratamientoPacientes] as

SELECT SEDE,	Cita,	TipoTratamiento,	CodMedico,	Medico,	EspecialidadPpalMedico,	CodigoActividad,	Actividad,	
  case     WHEN CUPS_Cita LIKE '%PRIMERA VEZ%'
             AND EXISTS (
                 SELECT 1
                 FROM [ViewInternal].[IMO_AD_AG_CitasTratamientoPacientes_NoVerifica] c2
                 WHERE c2.IdentificacionPaciente = A.IdentificacionPaciente
                   AND c2.Actividad  = A.Actividad
                   AND c2.FechaCita < A.FechaCita 
				   and c2.EstadoCita <>'Cancelada' -- hubo alguna antes
             )
        THEN 'SI'
        WHEN A.CUPS_Cita LIKE '%PRIMERA VEZ%'
        THEN 'NO'
        ELSE NULL
    END AS CitasAnteriores, CUPS_Cita, FechaAsignacionCita, FechaDeseada, FechaCita,DiasOportunidad,	Oportunidad_Deseada,
	IdentificacionPaciente,	Tipo_Documento,	PrimerApellido,	SegundoApellido,	PrimerNombre,	SegundoNombre,	Paciente,	Sexo,
	FechaNacimiento,	EdadEnAnos,	Direccion,	TipoAfiliacion,	Grupo_Atencion,	NIT,	Entidad,	CódigoEntidad,
	E_mail,	TelefonoMovil,	TelefonoPaciente,	[CodigoConsultorio/Sala],	[Consultorio/Sala],
	EstiloCita,	TipoCita,	EstadoCita,	CodUsuarioAsigna,	Usuario_Asigna,	Fechacancelación,	Mot_Cancelacion,	Causa_Cancelacion,
	CodUsuarioCancela,	ObservaCancela,	Causa_Inatencion,	Fecha_Inatencion,	Usuario_Cancela,	CodEspecialidad,	EspecialidadCita,
	Observaciones,	ZonaApartada,	Ubicacion,	Municipio,	IngresoCita,	Departamento,	Gestante,	EstadoPaciente,
	Fase,	OtraFase,	Ciclo,	Esquema,	Cie10_Cita,	Diagnostico_Cita
FROM (

SELECT  
    CASE
	     WHEN a.codcenate IN ( '001') THEN 'NEIVA'
		 WHEN a.codcenate IN ( '002') THEN 'PITALITO'
	 END AS SEDE, 	
--CASE A.TIPSOLICITU WHEN 1 THEN 'Cita Medica' WHEN 2 THEN 'Cita Apoyo Diagnostico' WHEN 3 THEN 'Cita Tratamiento Especiales' END AS Cita,
CASE C.ACTIVICON WHEN 0 THEN 'Consulta Externa' WHEN 1 THEN 'Procedimiento Qx' WHEN 2 THEN 'Apoyo Diagnóstico' WHEN 3 THEN 'Tratamientos Especiales' WHEN 4 THEN 'Diálisis' END AS Cita,

	case WHEN A.TIPTRATAMIENTO=1 THEN 'Quimioterapia' WHEN A.TIPTRATAMIENTO=2 THEN 'RadioTerapia' WHEN A.TIPTRATAMIENTO=3 THEN 'Diálisis' WHEN A.TIPTRATAMIENTO=4 THEN 'Braquiterapia' WHEN A.TIPTRATAMIENTO IS NULL THEN 'No Aplica' END AS TipoTratamiento, 
	
    --A.CODAUTONU,
	CASE 
	WHEN C.ACTIVICON=0 THEN A.CODPROSAL
	WHEN C.ACTIVICON=3 THEN CI.CODPROSAL
	END AS CodMedico,
--ESP.DESESPECI AS Especialidad,
--    A.CODPROSAL AS CodMedico,
	CASE 
	WHEN C.ACTIVICON=0 THEN D.NOMMEDICO
	WHEN C.ACTIVICON=3 THEN DC.NOMMEDICO	
	END AS Medico,
    --D.NOMMEDICO AS Medico,
	CASE 
	WHEN C.ACTIVICON=0 THEN E.DESESPECI
	WHEN C.ACTIVICON=3 THEN ESP.DESESPECI
	END AS EspecialidadPpalMedico,
    --E.DESESPECI AS EspecilaidadPpalMedico,
    C.CODACTMED AS CodigoActividad,
    C.DESACTMED AS Actividad,
	--ltrim(rtrim(IPS.CODSERIPS))+' - '+ltrim(rtrim(IPS.DESSERIPS)) AS CUPS_Cita,

	

	CASE 
    WHEN A.CODTIPCIT = '0' then ltrim(rtrim(C.CODSERIPS))+' - '+ltrim(rtrim(IPSp.DESSERIPS))
    WHEN A.CODTIPCIT = '1' THEN ltrim(rtrim(C.CODSERIPSCONTROL))+' - '+ltrim(rtrim(IPSc.DESSERIPS))
	WHEN A.CODSERIPS IS NOT NULL THEN ltrim(rtrim(IPS.CODSERIPS))+' - '+ltrim(rtrim(IPS.DESSERIPS))
	END AS CUPS_Cita,
	A.FECHORAIN AS FechaCita,
    A.FECREGSIS AS FechaAsignacionCita,
	A.FECITADES AS FechaDeseada,
	 DATEDIFF(DAY, A.FECREGSIS, A.FECHORAIN) AS DiasOportunidad,
	DATEDIFF(DAY, A.FECITADES, A.FECHORAIN) AS Oportunidad_Deseada,
    --CAST(DATEDIFF(DAY, A.FECREGSIS, A.FECHORAIN) AS decimal(4,1)) AS DiasOportunidad,
	--CAST(DATEDIFF(DAY, A.FECITADES, A.FECHORAIN) AS decimal(4,1)) AS Oportunidad_Deseada,
    B.IPCODPACI AS IdentificacionPaciente,
    CASE
        WHEN B.IPTIPODOC = '1' THEN            'Cedula de Ciudadania'
        WHEN B.IPTIPODOC = '2' THEN            'Cedula de Extranjeria'
        WHEN B.IPTIPODOC = '3' THEN            'Tarjeta de Identidad'
        WHEN B.IPTIPODOC = '4' THEN            'Registro Civil'
        WHEN B.IPTIPODOC = '5' THEN            'Pasaporte'
        WHEN B.IPTIPODOC = '6' THEN            'Adulto sin Identificacion'
        WHEN B.IPTIPODOC = '7' THEN            'Menor sin Identificacion'
		WHEN B.IPTIPODOC = '13' THEN           'Permiso Temporal de Permanencia'
		WHEN B.IPTIPODOC = '11' THEN           'Salvoconducto (Aplica para extranjeros)'
		WHEN B.IPTIPODOC = '9' THEN           'Certificado de Nacido Vivo'

    END AS Tipo_Documento,
    B.IPPRIAPEL AS PrimerApellido,
    B.IPSEGAPEL AS SegundoApellido,
    B.IPPRINOMB AS PrimerNombre,
    B.IPSEGNOMB AS SegundoNombre,
    B.IPNOMCOMP AS Paciente,
    CASE
        WHEN B.IPSEXOPAC = '1' THEN
            'Masculino'
        WHEN B.IPSEXOPAC = '2' THEN
            'Femenino'
    END AS Sexo,
    B.IPFECNACI AS FechaNacimiento,
    YEAR(GETDATE()) - YEAR(B.IPFECNACI) - 1 AS EdadEnAnos,
    B.IPDIRECCI AS Direccion,
	CASE IPTIPOPAC WHEN 1 THEN 'Contributivo' WHEN 2 THEN 'Subsidiado' WHEN 3 THEN 'Vinculado' WHEN 4 THEN 'Particular' WHEN 5 THEN 'Otro' WHEN 6 THEN 'Desplazado Reg. Contributivo' WHEN 7 THEN 'Desplazado Reg. Subsidiado' WHEN
    8 THEN 'Desplazado No Asegurado' END AS TipoAfiliacion,
    GR.Name AS Grupo_Atencion,
	TP.NIT,
    H1.Name AS Entidad,
	H1.HealthEntityCode AS CódigoEntidad,
    B.CORELEPAC AS E_mail,
    B.IPTELMOVI AS TelefonoMovil,
    B.IPTELEFON AS TelefonoPaciente,
    case when A.CODIGOCON is null then CODIGSALA else A.CODIGOCON end AS [CodigoConsultorio/Sala],
    case when H.DESCRICON is null then DESCRIPSAL else H.DESCRICON end AS [Consultorio/Sala],
  CASE 
    WHEN A.CODTIPCIT = '0' THEN         '1aVez'
    WHEN A.CODTIPCIT = '1' THEN        'Control'
    WHEN A.CODTIPCIT = '2' THEN        'PosOperatorio'
    WHEN A.CODTIPCIT = '3' THEN        'Cita Web'
    WHEN A.CODTIPCIT = '4' THEN        'Extra'
    WHEN A.CODTIPCIT IS NULL THEN        'Sin dato'
END AS EstiloCita,
    CASE A.CODTIPSOL
        WHEN '0' THEN            'Personal'
        WHEN '1' THEN            'Telefonica'
    END AS TipoCita,
    CASE A.CODESTCIT
        WHEN '0' THEN            'Asignada'
        WHEN '1' THEN            'Cumplida'
        WHEN '2' THEN            'Incumplida'
        WHEN '3' THEN            'Preasignada'
        WHEN '4' THEN            'Cancelada'
		WHEN '5' THEN            'Inatención'
    END AS EstadoCita,
    RTRIM(A.CODUSUASI) AS CodUsuarioAsigna,
    G.NOMUSUARI AS Usuario_Asigna,
    A.FECHCANCELA AS Fechacancelación,
    A.OBSCAUCAN AS Mot_Cancelacion,
	cac.DESCAUCAN as Causa_Cancelacion,
    A.CANCELUSU AS CodUsuarioCancela,
	a.OBSCAUCAN as ObservaCancela,
	mot.DESMOTANU as Causa_Inatencion,
	a.FECHAINA as Fecha_Inatencion,
    UC.NOMUSUARI AS Usuario_Cancela,
	A.CODESPECI as CodEspecialidad,
    RTRIM(E1.DESESPECI) AS EspecialidadCita,
    a.observaci AS Observaciones,
  --  m.Mes,
    CASE B.ZONAPARTADA
        WHEN 1 THEN            'Si'
        WHEN 0 THEN            'No'
    END AS ZonaApartada,
    UB.UBINOMBRE AS Ubicacion,
    mu.MUNNOMBRE AS Municipio,
    CASE
        WHEN CO.CODPROSAL = A.CODPROSAL THEN            CO.NUMINGRES
        ELSE            '0'
    END AS IngresoCita,
    DEP.nomdepart AS Departamento,
	case ris.gestacion when 1 then 'Si' else 'No' end as Gestante,
	case b.estadopac when 1 then 'Vivo' when 0 then 'Fallecido' end as EstadoPaciente, 
	--IDHCORDCICLOSD,
A.Fase,
A.OtraFase,
CID.Ciclo,--A.CICLO,
ES.DESCRIPTION AS Esquema, 
CASE WHEN A.TIPSOLICITU=3 THEN CICLO.CODDIAGNO
WHEN A.CODESTCIT IN ('4','5') THEN NULL
WHEN A.CODESTCIT NOT IN ('4','5') THEN DX.CODDIAGNO
END AS Cie10_Cita, 
CASE WHEN A.TIPSOLICITU=3 THEN CICLO.NOMDIAGNO
WHEN A.CODESTCIT IN ('4','5') THEN NULL
WHEN A.CODESTCIT NOT IN ('4','5') THEN dx.NOMDIAGNO
  END AS Diagnostico_Cita 

--select distinct codcenate 
FROM dbo.AGASICITA AS A
    INNER JOIN dbo.INPACIENT AS B       
	LEFT JOIN Contract.CareGroup AS GR ON GR.Id = B.GENCAREGROUP        
	LEFT JOIN Contract.HealthAdministrator AS H1 ON H1.Id = B.GENCONENTITY ON B.IPCODPACI = A.IPCODPACI
    --INNER JOIN dbo.Meses AS m
    --    ON m.Codigo = CAST(MONTH(A.FECHORAIN) AS CHAR(2))
    INNER JOIN dbo.AGACTIMED AS C ON C.CODACTMED = A.CODACTMED
    LEFT OUTER JOIN dbo.INPROFSAL AS D
    INNER JOIN dbo.INESPECIA AS E ON E.CODESPECI = D.CODESPEC1 ON D.CODPROSAL = A.CODPROSAL
	LEFT JOIN dbo.AGCONSULTORIO AS H2 ON H2.CODIGO = A.CODIGOCON
    LEFT JOIN dbo.AGCONSULT AS H ON H.CODIGOCON = A.CODIGOCON AND H.CODCENATE=A.CODCENATE
    LEFT JOIN dbo.INESPECIA AS E1 ON E1.CODESPECI = A.CODESPECI
    LEFT JOIN dbo.SEGusuaru AS G ON G.CODUSUARI = A.CODUSUASI
    LEFT JOIN dbo.SEGusuaru AS UC ON UC.CODUSUARI = A.CANCELUSU
    LEFT JOIN dbo.INUBICACI AS UB
	LEFT JOIN dbo.INMUNICIP AS mu LEFT JOIN dbo.INDEPARTA AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = B.AUUBICACI
    LEFT JOIN
    (
        SELECT MAX(CO.IPFECHCIT) IPFECHCIT, 
               IPCODPACI,
               CODPROSAL,
               NUMINGRES,IDHCHISPACA
        FROM dbo.ADCONCOEX AS CO
        WHERE (CO.IPFECHCIT >= '01/01/2022 00:00:00') AND (CO.IPFECHCIT >= '01/01/2022 23:59:59')
        GROUP BY IPCODPACI, CODPROSAL, NUMINGRES,IDHCHISPACA
    ) AS CO
        ON CO.IPCODPACI = A.IPCODPACI
           AND CAST(CO.IPFECHCIT AS DATE) = CAST(A.FECHORAIN AS DATE)
           AND A.CODPROSAL = CO.CODPROSAL
		   left join .AGCAUCANC as cac on cac.CODCAUCAN=a.CODCAUCAN
		   left outer join .AGENSALAC AS sala  on sala.CODCONCEC=a.IDSALA
		   LEFT OUTER JOIN .INCUPSIPS AS IPS  ON IPS.CODSERIPS=A.CODSERIPS
		   LEFT OUTER JOIN .INCUPSIPS AS IPSp  ON IPSp.CODSERIPS=C.CODSERIPS
		   LEFT OUTER JOIN .INCUPSIPS AS IPSc  ON IPSc.CODSERIPS=C.CODSERIPSCONTROL
		   left outer join .DBO.HCRIESGOSP as ris  on ris.NUMINGRCES=a.NUMINGRES
		   left outer join .HCMOANULB AS MOT  ON MOT.CODMOTANU=a.CODCAUINA
		   LEFT OUTER JOIN Common.ThirdParty AS TP ON TP.ID=H1.ThirdPartyId
		   LEFT OUTER JOIN EHR.HCORDCICLOSD AS cid ON cid.ID = A.IDHCORDCICLOSD
		   LEFT OUTER JOIN EHR.HCORDCICLOS AS ci ON ci.Id = cid.IDHCORDCICLOS
		   LEFT OUTER JOIN EHR.Schemes AS ES ON ES.Id = ci.SchemesId
		   LEFT OUTER JOIN dbo.INESPECIA AS ESP ON ESP.CODESPECI = ci.CODESPECI
		   LEFT OUTER JOIN dbo.INPROFSAL AS DC ON DC.CODPROSAL = ci.CODPROSAL
		   --left outer join dbo.ADCONCOEX as ac on co.IPCODPACI = ac.IPCODPACI and co.NUMINGRES = ac.NUMINGRES and co.IPFECHCIT = ac.IPFECHCIT and co.CODPROSAL = ac.CODPROSAL
		   left outer join dbo.HCHISPACA as hc on co.IDHCHISPACA = hc.ID
		   LEFT OUTER JOIN dbo.INDIAGNOS AS DX ON DX.CODDIAGNO =hc.CODDIAGNO
		   --LEFT OUTER JOIN Contract.CUPSEntity AS CUPS ON CUPS.
		   LEFT OUTER JOIN (select d.id as IDRelacionCicloCita, s.CODDIAGNO, s.NOMDIAGNO
								from INDIGO035.EHR.HCORDCICLOSD as d
								inner join INDIGO035.EHR.HCORDQUIMIO as q on q.id=d.IDHCORDQUIMIO
								inner join INDIGO035.dbo.INDIAGNOS as s on s.CODDIAGNO=q.CODDIAGNO
							) AS CICLO ON CICLO.IDRelacionCicloCita=A.IDHCORDCICLOSD
		

WHERE  --a.IPCODPACI='1004074483' and --CID.ID='1234' AND
       (A.FECHORAIN)>='01-01-2022' --AND A.IPCODPACI='1116204187'
     -- AND (A.FECHORAIN <= '31/12/2020 23:59:59')
      AND (A.IPCODPACI NOT IN ( '000000', '777777', '99999', '00000', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '33333', '333333', '3131', '33333', '333333', '3131', '33333', '3333', '333333', '33333',
'3131', '3333', '333333', '3131', '3333', '333333', '55555', '3333', '333333', '0000', '33333', '3131', '55555', '3333', '0000', '3131', '33333', '55555', '0000000', '3333', '333333', '3131', '33333','0123456789')) --and a.ipcodpaci='83233455'
--) AS A

--select * from EHR.HCORDCICLOS WHERE Id='217'
--select * from EHR.HCORDCICLOSD  where ID='1234'
--select * from EHR.Schemes where id='506'
--select * from EHR.HCORDQUIMIO  where ID='47'

--select p.*, e.CODESPECI,e.DESESPECI  from dbo.INPROFSAL as p
--left join dbo.INESPECIA as e on e.CODESPECI = p.CODESPEC1 or e.CODESPECI = p.CODESPEC2 or e.CODESPECI = p.CODESPEC3
--where CODPROSAL in ('7692799','1075310283')
) AS A
