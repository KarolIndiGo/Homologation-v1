-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_LABORATORIOS_INTERPRETADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_LABORATORIOS_INTERPRETADOS]
AS

SELECT  h.FECORDMED FechaSolicitud,
        h.IPCODPACI DocumentoPaciente,
        cups.code CodigoCups,
        CUPS.Description NombreCups,
		pro.NOMMEDICO MedicoInterpreta,
		h.INTERPRET Interpretacion



FROM HCORDLABO H
JOIN Contract.CUPSEntity CUPS ON CUPS.Code = H.CODSERIPS
join INPROFSAL pro on pro.CODPROSAL = h.CODPROINT
  

