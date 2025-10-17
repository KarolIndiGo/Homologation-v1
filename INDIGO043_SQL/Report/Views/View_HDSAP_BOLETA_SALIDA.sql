-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_BOLETA_SALIDA
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[View_HDSAP_BOLETA_SALIDA]
AS
   SELECT 
       distinct
       s.CreationDate FechaBoleta,
       s.code CódigoBoleta,
       t.nit Identificacion,
	   s.AdmissionNumber Ingreso,
	   case  a.TIPOINGRE
	   when 1
	   then 'Ambulatorio'
	   when 2
	   then 'Hospitalario'
	   end TipoIngreso,
	   a.IOBSERVAC Observacion,
	   t.Name Paciente ,
	   a.FECHEGRESO FechaSalida,
	   i.UFUDESCRI UnidadFuncionalEgreso,
	   a.IESTADOIN EstadoIngreso,
	   s.CreationUser CódigoFacturador,
	   p.fullname NombreFacturador,
	   ine.NOMENTIDA Entidad,
	   pac.IPTELMOVI

	   

FROM Billing.SlipOut s
join Security.[User] su on su.UserCode = s.CreationUser
join Security.Person as p on p.Id=su.IdPerson
join ADINGRESO a on a.NUMINGRES = s.AdmissionNumber
JOIN dbo.INUNIFUNC i ON i.UFUCODIGO = a.UFUEGRMED
join INPACIENT pac on pac.IPCODPACI = a.IPCODPACI
join Common.ThirdParty t on t.nit = pac.IPCODPACI
join INENTIDAD ine on ine.CODENTIDA = pac.CODENTIDA
--WHERE s.code = 'E000533621'


