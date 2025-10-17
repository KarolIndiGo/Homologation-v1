-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_SOLICITUDPROCEDIMIENTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_SOLICITUDPROCEDIMIENTO]
AS

select distinct
       hc.NUMINGRES Ingreso,
       i.ipcodpaci Documento,
	   i.ipnomcomp Nombre,
       case i.IPTIPOPAC
	   when  1
	   then 'Contributivo' 
	   when 2
	   then 'Subsidiado' 
	   when 3
	   then 'Vinculado' 
	   when 4
	   then 'Particular' 
	   when 5
	   then 'Otro' 
	   when 6
	   then 'Desplazado Reg. Contributivo'
	   when 7
	   then 'Desplazado Reg. Subsidiado' 
	   when 8
	   then 'Desplazado No Asegurado'
	   END EntidadAdministradora,
	   hc.FECORDMED FechaSolicitud,
	   inu.UFUDESCRI UnidadFuncional,
	   icu.CODSERIPS CodigoCups,
	   icu.DESCODCUPS NombreCups,
	   HC.CODPROSAL MedicoSolicita,
	   pr.NOMMEDICO NombreMedicoSolicita,
	   h.FECHORFIN FechaRealización,
	   H.CODPROSAL MedicoRealiza,
	   pr1.NOMMEDICO NombreMedicoRealiza,
	   ine.DESESPECI EspecialidadMedicoRealiza,
	   datediff(MINUTE,hc.FECORDMED,h.FECHORINI) DiferenciaMinutos

from .HCORDPROQ hc 
left join .HCQXINFOR h  on hc.NUMINGRES = h.NUMINGRES and hc.CODSERIPS = h.CODSERIPS
left join .INPACIENT i  on i.IPCODPACI = hc.IPCODPACI
join .INUNIFUNC inu  on inu.UFUCODIGO = hc.UFUCODIGO
left join .INCUPSIPS icu  on icu.CODSERIPS = hc.CODSERIPS
left join .INPROFSAL pr  on pr.CODPROSAL = hc.CODPROSAL
left join .INPROFSAL pr1  on pr1.CODPROSAL = h.CODPROSAL
left join .INESPECIA ine  on ine.CODESPECI = pr1.CODESPEC1


where hc.MANEXTPRO = 0 and not ESTSERIPS = 3


