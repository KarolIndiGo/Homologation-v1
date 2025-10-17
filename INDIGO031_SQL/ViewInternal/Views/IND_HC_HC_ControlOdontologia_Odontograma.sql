-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_HC_HC_ControlOdontologia_Odontograma
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IND_HC_HC_ControlOdontologia_Odontograma] as

SELECT 
C.ID AS Id, caa.nomcenate as CentroAtención, u.ufudescri as UnidadFuncional, c.ipcodpaci as DocumentoPaciente, p.IPPRINOMB as  PrimerNombre, p.IPSEGNOMB as SegundoNombre,
p.IPPRIAPEL as PrimerApellido, p.IPSEGAPEL as SegundoApellido, c.numingres as Ingreso,  YEAR(FECHAREG) - YEAR(P.IPFECNACI) AS Edad, 
CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo, ltrim(rtrim(dxp2.CODDIAGNO))+' - '+ dxp2.NOMDIAGNO as DiagnosticoPrincial,
c.numefolio as Folio, m.nommedico as Profesional, c.fechareg as FechaRegistro,
rc.codserips as CodigoProcedimiento, ps.desserips as Procedimiento, RCI.NOMBRE AS RIAS, CV.CEO_C as [Indice Cariados CEO],CEO_E as [Indice Extraidos CEO],  CEO_O as [Indice Obturados CEO], CPO_C as [Indice Cariados CPO],
CPO_P as [Indice Perdidos CPO],  CPO_O as [Indice Obturados CPO], CPO_C+CPO_P+CPO_O as [Indice COP], 
dt.Diente , case when dtd.Id is not null then 
CASE  DTD.TIPO WHEN 1 THEN 'Nivel Diente' WHEN 2 THEN 'Vestibular Arriba' WHEN 3 THEN 'Oclusal' WHEN 4 THEN 'Palatino'
			   WHEN 5 THEN 'Distal Izquierda' WHEN 6 THEN 'Distal Derecha' WHEN 7 THEN 'Mesial Derecha' WHEN 8 THEN 'Mesial Izquierda'
               WHEN 9 THEN 'Vestibular Abajo' WHEN 10 THEN 'Lingual'END else 
CASE  DTDt.TIPO WHEN 1 THEN 'Nivel Diente' WHEN 2 THEN 'Vestibular Arriba' WHEN 3 THEN 'Oclusal' WHEN 4 THEN 'Palatino'
			   WHEN 5 THEN 'Distal Izquierda' WHEN 6 THEN 'Distal Derecha' WHEN 7 THEN 'Mesial Derecha' WHEN 8 THEN 'Mesial Izquierda'
               WHEN 9 THEN 'Vestibular Abajo' WHEN 10 THEN 'Lingual'END  			   
			   end AS Ubicacion,
case when dtd.Id is not null then 
 case odp.INDICECPO when 'N' THEN 'No Aplica' when 'C' then 'Cariado' when 'P' then 'Perdido' when 'O' then 'Obturado' end else
 case odpt.INDICECPO when 'N' THEN 'No Aplica' when 'C' then 'Cariado' when 'P' then 'Perdido' when 'O' then 'Obturado' end end as IndiceCPO,
case when dtd.Id is not null then 
 case odp.INDICECEO when 'N' THEN 'No Aplica' when 'C' then 'Cariado' when 'E' then 'Extraido' when 'O' then 'Obturado' end else 
 case odpt.INDICECEO when 'N' THEN 'No Aplica' when 'C' then 'Cariado' when 'E' then 'Extraido' when 'O' then 'Obturado'
 end end as IndiceCEO,
case when dtd.Id is not null then 
case odp.APLICADIA when 1 then 'Diente' when 2 then 'Superficie' end else 
case odpt.APLICATRA when 1 then 'Diente' when 2 then 'Superficie' end
end as [Aplica a], 
case when dtd.Id is not null then 
OBSERVDIA else OBSERVTRA end as Observación, 
case when dtd.Id is not null then 
dx.CODDIAGNO+' - '+ dx.NOMDIAGNO else 
ltrim(rtrim(odpt.CODIGOTRA))+' - '+ odpt.DESCRITRA
end as Nombre, tratamiento.DIENTE as [Diente Tratamiento], tratamiento.Ubicacion as [Ubicacion Tratamiento], tratamiento.Nombre as [Nombre Tratamiento], 
tratamiento.CUPS as [CUPS Tratamiento]--, tratamiento.EstadoTratamiento
FROM DBO.ODONTOCONTROL AS C INNER JOIN
	 DBO.ODONTOCONTROLVALO AS CV ON CV.IDODONTOCONTROL=C.ID INNER JOIN
	  DBO.ODONTODIENTE AS dt ON dt.IDODONTOCONTROL=C.ID and TIPOODONTOGRAMA='V' left outer JOIN
	  DBO.ODONTODIENTEDIAG AS dtd ON dtd.IDODONTODIENTE=DT.ID  left outer JOIN
	  DBO.ODONTODIENTETRATA AS dtdt ON dtdt.IDODONTODIENTE=DT.ID  left outer JOIN
	  DBO.ODOPARDIA AS odp ON odp.CONSECDIA=DTd.CONSECDIA  left outer JOIN
	  DBO.ODOPARTRA AS odpt ON odpt.CONSECTRA=DTdt.CONSECTRA  left outer JOIN
	   DBO.INDIAGNOS AS dx ON dx.CODDIAGNO=odp.CODDIAGNO INNER JOIN
	 dbo.ADINGRESO AS I  ON C.NUMINGRES = I.NUMINGRES INNER JOIN
     dbo.INPACIENT AS P  ON C.IPCODPACI = P.IPCODPACI INNER JOIN
     dbo.INUNIFUNC AS U  ON C.UFUCODIGO = U.UFUCODIGO INNER JOIN
	dbo.INPROFSAL AS M  ON C.CODPROSAL = M.CODPROSAL LEFT OUTER JOIN
	dbo.RIASCUPS AS RC  ON RC.ID = C.IDRIASCUPS LEFT OUTER JOIN
	dbo.RIAS AS RCI  ON RCI.ID = RC.IDRIAS LEFT OUTER JOIN
	dbo.INCUPSIPS AS PS  ON PS.CODSERIPS=RC.CODSERIPS  left outer join 
	 DBO.adcenaten as caa  on caa.codcenate=C.codcenate left outer join 
	 dbo.INDIAGNOP as dxp on dxp.NUMINGRES=c.NUMINGRES and dxp.CODDIAPRI=1 left outer join 
	  DBO.INDIAGNOS AS dxp2 ON dxp2.CODDIAGNO=dxp.CODDIAGNO left outer join 
	  (select diente, CASE  DTDt.TIPO WHEN 1 THEN 'Nivel Diente' WHEN 2 THEN 'Vestibular Arriba' WHEN 3 THEN 'Oclusal' WHEN 4 THEN 'Palatino'
			   WHEN 5 THEN 'Distal Izquierda' WHEN 6 THEN 'Distal Derecha' WHEN 7 THEN 'Mesial Derecha' WHEN 8 THEN 'Mesial Izquierda'
               WHEN 9 THEN 'Vestibular Abajo' WHEN 10 THEN 'Lingual'   end AS Ubicacion,ltrim(rtrim(odpt.CODIGOTRA))+' - '+ odpt.DESCRITRA as Nombre, dt.IDODONTOCONTROL,
			   ltrim(rtrim(cup.CODSERIPS))+' - '+ cup.DESSERIPS as CUPS--, case estado when '1'  then 'Sin realizar' when '2' then 'Realizado' 
			 --  when '3' then 'No realizado' when '4' then 'Cancelado' end as EstadoTratamiento
		from DBO.ODONTODIENTE AS dt left outer JOIN
			 DBO.ODONTODIENTETRATA AS dtdt ON dtdt.IDODONTODIENTE=DT.ID left outer JOIN
	  DBO.ODOPARTRA AS odpt ON odpt.CONSECTRA=DTdt.CONSECTRA left outer JOIN
	  DBO.INCUPSIPS AS cup ON cup.CODSERIPS=dtdt.CODSERIPS --left outer JOIN
	--  dbo.ODONTOPLANTRATAMIENTOPACD as estado on estado.IDODOPARTRA=odpt.CONSECTRA
		where TIPOODONTOGRAMA='T') as tratamiento ON tratamiento.IDODONTOCONTROL=C.ID 
	 --DBO.adcenaten as caa  on caa.codcenate=C.codcenate
WHERE (FECHAREG)>='2023-09-01' --and c.IPCODPACI='74861453'
