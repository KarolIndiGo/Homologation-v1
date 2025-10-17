-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INFORMEESTANCIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_INFORMEESTANCIA]
AS



SELECT 
       I.NUMINGRES AS NumeroIngreso, 
       E.IPCODPACI AS Identificación, 
       P.IPNOMCOMP AS NombrePaciente,
	   ISNULL(bi.InvoiceNumber, 'SIN FACTURAR') Factura,
       UF.UFUDESCRI AS Servicio, 
       C.DESCCAMAS AS Cama,        
       I.IFECHAING AS FechaIngreso, 
       DATEDIFF(d, I.IFECHAING, GETDATE()) AS DiasHospital, 
       E.FECINIEST AS IngresoCama, 
       DATEDIFF(d, E.FECINIEST, GETDATE()) AS DiasCama, 
       case   	when cg.EntityType ='1' then 'EPS Contributivo' 
				when cg.EntityType = '2' then  'EPS Subsidiado' 
				when cg.EntityType = '3' then 'ET Vinculados Municipios'
				when cg.EntityType = '4' then 'ET Vinculados Departamentos' 
				when cg.EntityType = '5'  then 'ARL Riesgos Laborales' 
				when cg.EntityType = '6' then 'MP Medicina Prepagada' 
				when cg.EntityType = '7'  then 'IPS Privada' 
				when cg.EntityType = '8'  then 'IPS Publica' 
				when cg.EntityType = '9'  then 'Regimen Especial' 
				when cg.EntityType = '10'  then 'Accidentes de transito' 
				when cg.EntityType = '11'  then 'Fosyga' 
				when cg.EntityType = '12'  then 'Otros' 
				when cg.EntityType = '13'  then 'Aseguradoras' 
				when cg.EntityType = '99'  then 'Particulares'
				end as Regimen,
				ine.NOMENTIDA Entidad,
       I.IAUTORIZA AS NumeroAutorizacion, 
       I.IOBSERVAC AS Observaciones

FROM dbo.CHCAMASHO AS C
     INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = C.CODCENATE
     INNER JOIN dbo.INUNIFUNC AS UF ON UF.UFUCODIGO = C.UFUCODIGO
     INNER JOIN dbo.CHREGESTA AS E ON E.CODICAMAS = C.CODICAMAS
	 LEFT JOIN Billing.Invoice bi on bi.AdmissionNumber = e.NUMINGRES
     INNER JOIN dbo.CHTIPESTA AS TE ON TE.CODTIPEST = E.CODTIPEST
     INNER JOIN dbo.ADINGRESO AS I ON I.NUMINGRES = E.NUMINGRES
	 join INENTIDAD ine on ine.CODENTIDA = i.CODENTIDA
     INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = E.IPCODPACI
     LEFT JOIN Contract.CareGroup CG ON CG.ID = BI.CareGroupId
WHERE(C.CODCENATE = 001) and uf.UFUCODIGO in ('67','18') 



