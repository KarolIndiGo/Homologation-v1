-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: HC_OrdenesProcedimientosNoQx
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [ViewInternal].[HC_OrdenesProcedimientosNoQx] as

select 'Orden Extramural' as Tipo,  
  Cent.NOMCENATE AS Sede, 
			CASE
                 WHEN Q.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN Q.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN Q.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,
Q.NUMINGRES AS Ingreso,  i.IFECHAING as FechaIngreso ,CASE IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' 
			 when 9 then  'CN' 
			 when 10 then 'CD' 
			 when 11 then 'SC' 
			 when 12 then 'PE'  
			 when 13 then 'PT' 
			 when 14 then 'DE'  
			 when 15 then 'SI' 
			 END AS TipoIdentificacion, Q.IPCODPACI AS Documento, 
			 p.IPPRINOMB AS [PrimerNombre], p.IPSEGNOMB  AS [SegundoNombre], p.IPPRIAPEL AS [PrimerApellido], p.IPSEGAPEL AS [SegundoApellido],
			 CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
		Q.CODSERIPS AS CUPS, S.DESSERIPS AS Desc_CUPS,
		
		th.Nit,  ha.name AS Entidad, 
		d.CODDIAGNO as Cie10 , D .NOMDIAGNO AS Diagnostico, 
          -- CASE ESTSERIPS WHEN 1 THEN 'Ordenado' WHEN 2 THEN 'Completado' WHEN 3 THEN 'Interpretado' WHEN 4 THEN 'Sin Interfaz' WHEN 5 THEN 'Anulado' else ESTSERIPS  END AS Estado, 
		   Q.FECORDMED AS FechaOrden, pro.NOMMEDICO as ProfesionalOrdena,
		   
		   F.ufucodigo as CodUFSol, F.UFUDESCRI as UnidadFuncionalSolicitud,
		  -- FECHAPRO AS FechaConfirmacion,
		  CASE PRISERIPS WHEN 1 THEN 'Urgente' WHEN 2 THEN 'Rutina' END AS Prioridad, --INTERPRET AS Interpretacion, 
		  -- Q.numfolint as FolioInterpreta,
		   --DATEDIFF(minute, Q.FECORDMED, FECHAPRO) AS [OportunidadCitaVsExamen (min)], 
		   --DATEDIFF(HOUR, Q.FECORDMED, FECHAPRO) AS [OportunidadCitaVsExamen (Hora)],
		   Q.OBSSERIPS as Observacion, --AC.DESAREA AS AreaOtrosProcedimientos,-- uc.UFUCODIGO as CodUfP, uc.UFUDESCRI as UnidadProcesa,
		  --pro.CODPROSAL as CodMedico,   ltrim(rtrim(PRO.MEDPRINOM))+' '+ltrim(rtrim(PRO.MEDPRIAPEL)) as MedicoRealiza,q.FECHREALI as FechaRealizado,
		   C.DESESPECI as EspecialidadTratante,
		   --,case CODCENATEPRO when 001 then 'Neiva' when 00104 then 'Abner' when 00105 then 'Materno' when 002 then 'Florencia'
		   --when 004 then 'Tunja' when 007 then 'Facatativa' end as 'CA Procesa', 
		 ga.code as CodGrupoAtencion,    ga.name as GrupoAtencion,-- q.FECHAANULADO as FechaAnulado, us.NOMUSUARI as ProfesionalAnula, q.OBSANULADO as ObservacionAnula,
		  -- CASE WHEN S.SERIPSDASH =12 THEN 'Si' ELSE 'No' END AS OtrosProcedimientos,
		   i.IOBSERVAC as ObservaciónIngreso,
		     HCU.ENFACTUAL AS Enfermedad_Actual, 
			 em.FECALTPAC AS [Fecha alta Médica], 
		   --se agrega este campo para identificar cuales son otros procedimientos
		    '' AS ActividadCita ,
		 '' AS EstadoCita,
		   '' AS FechaInicialCita, '' as FechaFinalCita
from  dbo.HCORDPRON Q with(nolock) inner join 
		 .INPACIENT P with(nolock) on P.IPCODPACI = Q.IPCODPACI INNER JOIN
		 .ADCENATEN Cent with(nolock) on Cent.CODCENATE = Q.CODCENATE INNER JOIN
		 .ADINGRESO I with(nolock) on I.NUMINGRES = Q.NUMINGRES LEFT JOIN  
		 .CHCAMASHO CA with(nolock) on CA.CODICAMAS = I.CODCAMACT LEFT JOIN 
		 .ADACTIVID L with(nolock) ON P.CODACTIVI = L.codactivi INNER JOIN 
		 .INUNIFUNC F with(nolock) on F.UFUCODIGO = Q.UFUCODIGO LEFT JOIN
		 .INENTIDAD E with(nolock) ON E.CODENTIDA = P.CODENTIDA LEFT JOIN 
		 .INCUPSIPS S with(nolock) on s.CODSERIPS = Q.CODSERIPS LEFT JOIN 
		 .INDIAGNOS D with(nolock) ON D.CODDIAGNO = Q.CODDIAGNO LEFT JOIN 
		 .INPROFSAL PRO with(nolock) ON PRO.CODPROSAL = Q.CODPROSAL LEFT JOIN 
		
		.HCHISPACA as hc with (nolock) on hc.NUMINGRES=q.NUMINGRES and hc.NUMEFOLIO=q.NUMEFOLIO LEFT JOIN
		 dbo.HCURGING1 AS HCU WITH (NOLOCK) ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO LEFT JOIN
		  dbo.HCREGEGRE AS em WITH (NOLOCK) ON em.IPCODPACI = HC.IPCODPACI AND em.NUMINGRES = HC.NUMINGRES LEFT OUTER JOIN
		 .INESPECIA C with(nolock) on C.CODESPECI =HC.CODESPTRA  LEFT JOIN 
		   contract.healthadministrator as ha on ha.id=i.genconentity 
		   left outer join common.thirdparty as th on th.id=ha.thirdpartyid LEFT OUTER JOIN
		   Contract.CareGroup as ga on ga.id=i.GENCAREGROUP left outer join
		   dbo.SEGusuaru as us on us.CODUSUARI=q.PROANULADO
WHERE  Q.SOLICITASALA = 0 AND S.SERIPSDASH in (12,9,8) and q.ESTSERIPS<>'5' --se agrega 8. Ninguno, y 9. Procedimiento no Qx  --AND AC.ID = 14 
AND FECORDMED >='01-01-2025' and q.IPCODPACI<>'0123456789'
--order by FECORDMED desc

union all

select 'Ambulatorio' as Tipo,
  Cent.NOMCENATE AS Sede, 
			CASE
                 WHEN Q.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN Q.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN Q.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional, Q.NUMINGRES AS Ingreso,  i.IFECHAING as FechaIngreso ,  CASE IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' 
			 when 9 then  'CN' 
			 when 10 then 'CD' 
			 when 11 then 'SC' 
			 when 12 then 'PE'  
			 when 13 then 'PT' 
			 when 14 then 'DE'  
			 when 15 then 'SI' 
			 END AS TipoIdentificacion, Q.IPCODPACI AS Documento, 
			 p.IPPRINOMB AS [PrimerNombre], p.IPSEGNOMB  AS [SegundoNombre], p.IPPRIAPEL AS [PrimerApellido], p.IPSEGAPEL AS [SegundoApellido],
			 CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
		Q.CODSERIPS AS CUPS, S.DESSERIPS AS Desc_CUPS,
		
		th.Nit,  ha.name AS Entidad, 
	'' as Cie10 ,	'' AS Diagnostico, 
          -- CASE q.ESTADO WHEN 1 THEN 'Ordenado' WHEN 2 THEN 'Completado' WHEN 3 THEN 'Interpretado' WHEN 4 THEN 'Sin Interfaz' WHEN 5 THEN 'Anulado'   END AS Estado, 
		   Q.FECHAREG AS FechaOrden,  pro.NOMMEDICO as ProfesionalOrdena,
		   
		   F.ufucodigo as CodUFSol, F.UFUDESCRI as UnidadFuncionalSolicitud,
		--   FECHAPRO AS FechaConfirmacion,
		'' AS Prioridad,-- INTERPRETACION AS Interpretacion, 
		  -- q.NUMEFOLIOINT as FolioInterpreta,
		  -- DATEDIFF(minute, Q.FECHAREG, FECHAPRO) AS [OportunidadCitaVsExamen (min)], 
		  -- DATEDIFF(HOUR, Q.FECHAREG, FECHAPRO) AS [OportunidadCitaVsExamen (Hora)],
		  q.OBSERVACION as Observacion,-- AC.DESAREA AS AreaOtrosProcedimientos,-- uc.UFUCODIGO as CodUfP, uc.UFUDESCRI as UnidadProcesa,
		  --pro.CODPROSAL as CodMedico,   ltrim(rtrim(PRO.MEDPRINOM))+' '+ltrim(rtrim(PRO.MEDPRIAPEL)) as MedicoRealiza,q.FECHAREALI as FechaRealizado,
		   C.DESESPECI as EspecialidadTratante,
		   --,case CODCENATEPRO when 001 then 'Neiva' when 00104 then 'Abner' when 00105 then 'Materno' when 002 then 'Florencia'
		  -- when 004 then 'Tunja' when 007 then 'Facatativa' end as 'CA Procesa', 
		 ga.code as CodGrupoAtencion,  ga.name as GrupoAtencion,-- q.TERLLAMADO as FechaAnulado, us.NOMUSUARI as ProfesionalAnula, q.OBVAUSENT as ObservacionAnula,
		  -- CASE WHEN S.SERIPSDASH =12 THEN 'Si' ELSE 'No' END AS OtrosProcedimientos,
		   i.IOBSERVAC as ObservaciónIngreso,
		     '' AS Enfermedad_Actual, 
			 '' AS [Fecha alta Médica], 
		   AC.DESACTMED AS ActividadCita ,
		   CASE cI.CODESTCIT
        WHEN '0' THEN            'Asignada'
        WHEN '1' THEN            'Cumplida'
        WHEN '2' THEN            'Incumplida'
        WHEN '3' THEN            'Preasignada'
        WHEN '4' THEN            'Cancelada'
		WHEN '5' THEN            'Inatención'
    END AS EstadoCita,
		   CI.FECHORAIN AS FechaInicialCita, CI.FECHORAFI as FechaFinalCita
from  dbo.AMBORDOTROSPRO Q with(nolock) inner join 
		 .INPACIENT P with(nolock) on P.IPCODPACI = Q.IPCODPACI INNER JOIN
		 .ADCENATEN Cent with(nolock) on Cent.CODCENATE = Q.CODCENATE INNER JOIN
		 .ADINGRESO I with(nolock) on I.NUMINGRES = Q.NUMINGRES LEFT JOIN  
		 --.CHCAMASHO CA with(nolock) on CA.CODICAMAS = I.CODCAMACT INNER JOIN
		 .ADACTIVID L with(nolock) ON P.CODACTIVI = L.codactivi LEFT JOIN 
		 .INUNIFUNC F with(nolock) on F.UFUCODIGO = Q.UFUCODIGO LEFT JOIN
		 .INENTIDAD E with(nolock) ON E.CODENTIDA = P.CODENTIDA LEFT JOIN 
		 .INCUPSIPS S with(nolock) on s.CODSERIPS = Q.CODSERIPS LEFT JOIN 
		 --.INDIAGNOS D with(nolock) ON D.CODDIAGNO = Q.CODDIAGNO LEFT JOIN 
		 .INPROFSAL PRO with(nolock) ON PRO.CODPROSAL = Q.CODPROSAL LEFT JOIN 
		AGASICITA AS CI WITH (NOLOCK) ON CI.CODAUTONU=Q.IDCITA LEFT JOIN 
		  dbo.AGACTIMED		AS AC	WITH (NOLOCK) ON AC.CODACTMED = CI.CODACTMED LEFT JOIN
		  		 .INESPECIA C with(nolock) on C.CODESPECI =ci.CODESPECI  LEFT JOIN 

		   contract.healthadministrator as ha on ha.id=i.genconentity
		   left outer join common.thirdparty as th on th.id=ha.thirdpartyid LEFT OUTER JOIN
		   Contract.CareGroup as ga on ga.id=i.GENCAREGROUP left outer join
		   dbo.SEGusuaru as us on us.CODUSUARI=q.PROAUSENT
WHERE   S.SERIPSDASH in (12,9,8) and q.ESTADO<>'5' --se agrega 8. Ninguno, y 9. Procedimiento no Qx    --AND AC.ID = 14 
AND FECHAREG >='01-01-2025'  and q.IPCODPACI<>'0123456789'
--AND Q.NUMINGRES='DCC8CF6D4B'



