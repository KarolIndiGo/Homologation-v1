-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ESTUDIOSOCIOECONOMICO
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_ESTUDIOSOCIOECONOMICO]
AS

 select distinct hc.IPCODPACI Documento,
       pa.IPNOMCOMP [Nombre Paciente],
       hc.NUMINGRES [Numero Ingreso],
	   hc.FECPROCES [Fecha],
	   INP.CODPROSAL [Código Profesional],
	   inp.NOMMEDICO [Nombre Profesional],
	   fu.Name [Unidad Funcional],
	   c.Name [Grupo Atención]



from HCDOCUMAD hc
join INPROFSAL inp on inp.CODPROSAL = hc.CODPROSAL
join INPACIENT pa on pa.IPCODPACI = hc.IPCODPACI
join Common.ThirdParty t on t.nit = pa.IPCODPACI
left outer join Payroll.FunctionalUnit fu on fu.code = hc.UFUCODIGO
left join Billing.Invoice bi on bi.AdmissionNumber = hc.NUMINGRES
left join Contract.CareGroup c on c.Id = bi.CareGroupId
WHERE   INP.CODPROSAL IN ('974','TS12','661')

