-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_HC_HC_CONTROLODONTOLOGIA_ODONTOGRAMA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_HC_HC_CONTROLODONTOLOGIA_ODONTOGRAMA
as

SELECT 
    C.ID AS Id
    , caa.NOMCENATE as CentroAtención
    , U.UFUDESCRI as UnidadFuncional
    , C.IPCODPACI as DocumentoPaciente
    , P.IPPRINOMB as  PrimerNombre
    , P.IPSEGNOMB as SegundoNombre
    , P.IPPRIAPEL as PrimerApellido
    , P.IPSEGAPEL as SegundoApellido
    , C.NUMINGRES as Ingreso
    , YEAR(FECHAREG) - YEAR(P.IPFECNACI) AS Edad
    , CASE 
        WHEN P.IPSEXOPAC = '1' THEN 'Masculino' 
        WHEN P.IPSEXOPAC = '2' THEN 'Femenino' 
        END AS Sexo
    , ltrim(rtrim(dxp2.CODDIAGNO))+' - '+ dxp2.NOMDIAGNO as DiagnosticoPrincial
    , C.NUMEFOLIO as Folio
    , M.NOMMEDICO as Profesional
    , C.FECHAREG as FechaRegistro
    , RC.CODSERIPS as CodigoProcedimiento
    , PS.DESSERIPS as Procedimiento
    , RCI.NOMBRE AS RIAS
    , CV.CEO_C as [Indice Cariados CEO]
    , CEO_E as [Indice Extraidos CEO]
    , CEO_O as [Indice Obturados CEO]
    , CPO_C as [Indice Cariados CPO]
    , CPO_P as [Indice Perdidos CPO]
    , CPO_O as [Indice Obturados CPO]
    , CPO_C+CPO_P+CPO_O as [Indice COP]
    , dt.DIENTE 
    , case 
        when dtd.ID is not null then 
    CASE  dtd.TIPO 
        WHEN 1 THEN 'Nivel Diente' 
        WHEN 2 THEN 'Vestibular Arriba' 
        WHEN 3 THEN 'Oclusal' 
        WHEN 4 THEN 'Palatino'
		WHEN 5 THEN 'Distal Izquierda' 
        WHEN 6 THEN 'Distal Derecha' 
        WHEN 7 THEN 'Mesial Derecha' 
        WHEN 8 THEN 'Mesial Izquierda'
        WHEN 9 THEN 'Vestibular Abajo' 
        WHEN 10 THEN 'Lingual'
        END 
    else 
    CASE dtdt.TIPO 
        WHEN 1 THEN 'Nivel Diente' 
        WHEN 2 THEN 'Vestibular Arriba' 
        WHEN 3 THEN 'Oclusal' 
        WHEN 4 THEN 'Palatino'
		WHEN 5 THEN 'Distal Izquierda' 
        WHEN 6 THEN 'Distal Derecha' 
        WHEN 7 THEN 'Mesial Derecha' 
        WHEN 8 THEN 'Mesial Izquierda'
        WHEN 9 THEN 'Vestibular Abajo' 
        WHEN 10 THEN 'Lingual'
        END  			   
	end AS Ubicacion
    ,case 
        when dtd.ID is not null then 
    case odp.INDICECPO 
        when 'N' THEN 'No Aplica' 
        when 'C' then 'Cariado' 
        when 'P' then 'Perdido' 
        when 'O' then 'Obturado' 
        end 
    else
    case odpt.INDICECPO 
        when 'N' THEN 'No Aplica' 
        when 'C' then 'Cariado' 
        when 'P' then 'Perdido' 
        when 'O' then 'Obturado' 
        end 
    end as IndiceCPO
    , case 
        when dtd.ID is not null then 
    case odp.INDICECEO 
        when 'N' THEN 'No Aplica' 
        when 'C' then 'Cariado' 
        when 'E' then 'Extraido' 
        when 'O' then 'Obturado' 
        end 
    else 
    case odpt.INDICECEO 
        when 'N' THEN 'No Aplica' 
        when 'C' then 'Cariado' 
        when 'E' then 'Extraido' 
        when 'O' then 'Obturado'
        end 
    end as IndiceCEO
    ,case 
        when dtd.ID is not null then 
    case odp.APLICADIA 
        when 1 then 'Diente' 
        when 2 then 'Superficie' 
        end 
    else 
    case odpt.APLICATRA 
        when 1 then 'Diente' 
        when 2 then 'Superficie' 
        end
    end as [Aplica a]
    , case 
        when dtd.ID is not null then OBSERVDIA else OBSERVTRA end as Observación
    , case 
        when dtd.ID is not null then dx.CODDIAGNO+' - '+ dx.NOMDIAGNO 
    else ltrim(rtrim(odpt.CODIGOTRA))+' - '+ odpt.DESCRITRA
    end as Nombre
    , tratamiento.DIENTE as [Diente Tratamiento]
    , tratamiento.Ubicacion as [Ubicacion Tratamiento]
    , tratamiento.Nombre as [Nombre Tratamiento]
    , tratamiento.CUPS as [CUPS Tratamiento]--, tratamiento.EstadoTratamiento

FROM [INDIGO031].[dbo].[ODONTOCONTROL] AS C
INNER JOIN INDIGO031.dbo.ODONTOCONTROLVALO AS CV ON CV.IDODONTOCONTROL=C.ID 
INNER JOIN INDIGO031.dbo.ODONTODIENTE AS dt ON dt.IDODONTOCONTROL=C.ID and TIPOODONTOGRAMA='V' 
left outer JOIN INDIGO031.dbo.ODONTODIENTEDIAG AS dtd ON dtd.IDODONTODIENTE=dt.ID
left outer JOIN INDIGO031.dbo.ODONTODIENTETRATA AS dtdt ON dtdt.IDODONTODIENTE=dt.ID  
left outer JOIN INDIGO031.dbo.ODOPARDIA AS odp ON odp.CONSECDIA=dtd.CONSECDIA 
left outer JOIN INDIGO031.dbo.ODOPARTRA AS odpt ON odpt.CONSECTRA=dtdt.CONSECTRA  
left outer JOIN INDIGO031.dbo.INDIAGNOS AS dx ON dx.CODDIAGNO=odp.CODDIAGNO 
INNER JOIN INDIGO031.dbo.ADINGRESO AS I  ON C.NUMINGRES = I.NUMINGRES 
INNER JOIN INDIGO031.dbo.INPACIENT AS P  ON C.IPCODPACI = P.IPCODPACI
INNER JOIN INDIGO031.dbo.INUNIFUNC AS U  ON C.UFUCODIGO = U.UFUCODIGO 
INNER JOIN INDIGO031.dbo.INPROFSAL AS M  ON C.CODPROSAL = M.CODPROSAL 
LEFT OUTER JOIN INDIGO031.dbo.RIASCUPS AS RC  ON RC.ID = C.IDRIASCUPS 
LEFT OUTER JOIN INDIGO031.dbo.RIAS AS RCI  ON RCI.ID = RC.IDRIAS
LEFT OUTER JOIN INDIGO031.dbo.INCUPSIPS AS PS  ON PS.CODSERIPS=RC.CODSERIPS  
left outer join INDIGO031.dbo.ADCENATEN as caa  on caa.CODCENATE=C.CODCENATE 
left outer join INDIGO031.dbo.INDIAGNOP as dxp on dxp.NUMINGRES=C.NUMINGRES and dxp.CODDIAPRI=1 
left outer join INDIGO031.dbo.INDIAGNOS AS dxp2 ON dxp2.CODDIAGNO=dxp.CODDIAGNO 
left outer join
	  (select DIENTE, CASE  dtdt.TIPO WHEN 1 THEN 'Nivel Diente' WHEN 2 THEN 'Vestibular Arriba' WHEN 3 THEN 'Oclusal' WHEN 4 THEN 'Palatino'
			   WHEN 5 THEN 'Distal Izquierda' WHEN 6 THEN 'Distal Derecha' WHEN 7 THEN 'Mesial Derecha' WHEN 8 THEN 'Mesial Izquierda'
               WHEN 9 THEN 'Vestibular Abajo' WHEN 10 THEN 'Lingual'   end AS Ubicacion,ltrim(rtrim(odpt.CODIGOTRA))+' - '+ odpt.DESCRITRA as Nombre, dt.IDODONTOCONTROL,
			   ltrim(rtrim(cup.CODSERIPS))+' - '+ cup.DESSERIPS as CUPS--, case estado when '1'  then 'Sin realizar' when '2' then 'Realizado' 
			 --  when '3' then 'No realizado' when '4' then 'Cancelado' end as EstadoTratamiento
		from [INDIGO031].[dbo].[ODONTODIENTE] AS dt 
        left outer JOIN INDIGO031.dbo.ODONTODIENTETRATA AS dtdt ON dtdt.IDODONTODIENTE=dt.ID 
        left outer JOIN INDIGO031.dbo.ODOPARTRA AS odpt ON odpt.CONSECTRA=dtdt.CONSECTRA 
        left outer JOIN INDIGO031.dbo.INCUPSIPS AS cup ON cup.CODSERIPS=dtdt.CODSERIPS --left outer JOIN

		where TIPOODONTOGRAMA='T') as tratamiento ON tratamiento.IDODONTOCONTROL=C.ID 

WHERE (FECHAREG)>='2023-09-01'
