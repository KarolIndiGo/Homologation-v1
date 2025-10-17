-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_Diagnosticos
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_Diagnosticos]
AS

select distinct
       i.FECDIAGNO Fecha,
       id.CODICIE10 CodigoCIE10,
	   id.NOMDIAGNO Diagnostico,
	   i.IPCODPACI DocumentoPaciente,
	   p.IPNOMCOMP NombrePaciente,
	   p.IPTELMOVI TelefonoMovil,
	   p.IPFECNACI FechaNacimiento,
	   a.IFECHAING FechaIngreso,
	   case i.DIAINGEGR
	   when 'I'
	   then 'Ingreso'
	   when 'E'
	   then 'Egreso'
	   else 'Ambos'
	   end TipoDiagnostico,
   	    floor((((cast(datediff(day, p.IPFECNACI, 
		getdate()) as float)/365-(floor(cast(datediff(day, p.IPFECNACI, 
		getdate()) as float)/365)))*12)-floor((cast(datediff(day, p.IPFECNACI, 
		getdate()) as float)/365-(floor(cast(datediff(day, p.IPFECNACI, 
		getdate()) as float)/365)))*12))*(365/12)) AS "Dias", floor((cast(datediff(day, p.IPFECNACI, 
		getdate()) as float)/365-(floor(cast(datediff(day, p.IPFECNACI,
		getdate()) as float)/365)))*12) AS "Meses", 
		floor(cast(datediff(day, p.IPFECNACI, getdate()) as float)/365)  as Años,
	   case p.IPSEXOPAC
	   when 1
	   then 'Masculino'
	   when 2
	   then 'Femenino'
	   end SexoPaciente,
	   ad.DESACTIVI Ocupación,
	   ag.DESGRUPET GrupoEtnico,
	   n.UBINOMBRE UbicacionResidencia,
	   p.IPDIRECCI DireccionResidencia,
	   f.UFUDESCRI UnidadFuncional,
	   d.NOMENTIDA EntidadAdmistradora,
	   concat (rtrim(pro.CODPROSAL),'--',pro.NOMMEDICO) ProfesionalSalud,
	   case a.TIPOINGRE
	   when 1
	   then 'Ambulatorio'
	   when 2
	   then 'Hospitalario'
	   End TipoIngreso,
	   case h.INDICAPAC
	   when 11
	   then 'Muerto'
	   else 'Vivo'
	   end EstadoFinalPaciente,
	   i.NUMINGRES Ingreso,
	   mun.MUNNOMBRE Municipio

from INDIAGNOH i
join INDIAGNOS id on id.CODDIAGNO = i.CODDIAGNO
join INPACIENT p on p.IPCODPACI = i.IPCODPACI
join ADINGRESO a on a.NUMINGRES = i.NUMINGRES
join ADACTIVID ad on ad.CODACTIVI = p.CODACTIVI
join ADGRUETNI ag on ag.CODGRUPOE = p.CODGRUPOE
join INUBICACI n on n.AUUBICACI = p.AUUBICACI
join INMUNICIP mun on mun.DEPMUNCOD = n.DEPMUNCOD
join INUNIFUNC f on f.UFUCODIGO = i.UFUCODIGO
join INENTIDAD d on d.CODENTIDA = p.CODENTIDA
join INPROFSAL pro on pro.CODPROSAL = i.CODPROSAL
join HCHISPACA h on h.NUMINGRES = a.NUMINGRES
  

