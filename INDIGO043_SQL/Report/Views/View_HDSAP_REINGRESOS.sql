-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_REINGRESOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_Reingresos]
AS
SELECT        TOP (100) PERCENT I.NUMINGRES AS Ingreso, I.IPCODPACI AS Identificación, INPACIENT.IPNOMCOMP AS NombrePaciente, I.UFUINGMED AS UnidadF, 
                         UF.UFUDESCRI AS UnidadFuncional, 
                         CASE WHEN I.IINGREPOR = 1 THEN 'Urgencias' WHEN I.IINGREPOR = 2 THEN 'Consulta Externa' WHEN I.IINGREPOR = 3 THEN 'Nacido Hospital' WHEN I.IINGREPOR
                          = 4 THEN 'Remitido' WHEN I.IINGREPOR = 5 THEN 'Hospitalización de Urgencias' END AS Servicio, I.IFECHAING AS Fecha, EG.FECALTPAC AS 'FechaEgreso', UF2.UFUDESCRI AS 'UnidadFuncionalEgreso'
FROM            ADINGRESO AS I INNER JOIN
                         INUNIFUNC AS UF ON I.UFUINGMED = UF.UFUCODIGO INNER JOIN
                         INPACIENT ON I.IPCODPACI = INPACIENT.IPCODPACI INNER JOIN
						 HCREGEGRE AS EG ON EG.NUMINGRES=I.NUMINGRES inner JOIN
						 INUNIFUNC AS UF2 ON EG.UFUCODIGO=UF2.UFUCODIGO
WHERE        (I.IREINGRES = 1)

