-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TIEMPOSHOSPITALIZACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_TIEMPOSHOSPITALIZACION]
AS
SELECT 
    ch.NUMINGRES AS NumeroIngreso,
    i.IPCODPACI AS Documento,
    i.IPNOMCOMP AS NombrePaciente,
    ch.FECINIEST AS FechaHospitalizacion,
	ch.FECFINEST AS Fechacama,
    CH.REGDIAEST DiasEstancia,
	uni.UFUDESCRI

FROM CHREGESTA ch
JOIN INPACIENT i ON i.IPCODPACI = ch.IPCODPACI
JOIN CHCAMASHO cc ON cc.CODICAMAS = ch.CODICAMAS
JOIN INUNIFUNC uni ON uni.UFUCODIGO = cc.UFUCODIGO
WHERE cc.UFUCODIGO IN ('122','13','15','17','18','48','69','14','67') 

