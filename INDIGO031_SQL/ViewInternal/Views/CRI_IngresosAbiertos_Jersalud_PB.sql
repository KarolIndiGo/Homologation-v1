-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: CRI_IngresosAbiertos_Jersalud_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[CRI_IngresosAbiertos_Jersalud_PB] as
 
SELECT DISTINCT 
           i.CODCENATE,  CASE i.CODCENATE WHEN '001' THEN 'BOGOTA' 
										  WHEN '002' THEN 'TUNJA'
										  WHEN '003' THEN 'DUITAMA'
										  WHEN '004' THEN 'SOGAMOSO'
										  WHEN '005' THEN 'CHIQUINQUIRA'
										  WHEN '006' THEN 'GARAGOA'
										  WHEN '007' THEN 'GUATEQUE'
										  WHEN '008' THEN 'SOATA'
										  WHEN '009' THEN 'MONIQUIRA'
										  WHEN '010' THEN 'VILLAVICENCIO'
										  WHEN '011' THEN 'ACACIAS'
										  WHEN '012' THEN 'GRANADA'
										  WHEN '013' THEN 'PUERTO LOPEZ'
										  WHEN '014' THEN 'PUERTO GAITAN'
										  WHEN '015' THEN 'YOPAL'
										  WHEN '016' THEN 'VILLANUEVA                                                                                 ' 
										  WHEN '017' THEN 'PUERTO BOYACA'                                                                              
										  WHEN '018' THEN 'SAN MARTIN'                                                                                 
WHEN '019'   THEN    	'PAZ DE ARIPORO'                                                                             
WHEN '020'     THEN  	'AGUAZUL'                                                                                    
WHEN '021'    THEN   	'MIRAFLORES'                                                                                 
										  END AS Sede, 
		   i.NUMINGRES AS Ingreso, 
           ga.Code AS [Grupo Atención Ingreso], 
		   ga.Name AS [Grupo Atención], 
		   t.Nit, t.Name AS Entidad, i.IPCODPACI AS [Identificación Paciente], 
		   p.IPNOMCOMP AS [Nombre Paciente], p.IPEXPEDIC AS [Lugar Expedición antes Vie], 
		   CAST(p.GENEXPEDITIONCITY AS varchar(20)) + ' - ' + ISNULL(ci.Name, '') AS [Lugar expedición Vie], 
           i.IFECHAING AS Fecha_Ingreso, 
		   i.IESTADOIN AS Estado, i.UFUCODIGO AS CodUF, 
		   uf.UFUDESCRI AS Unidad_Funcional,-- HCU.ENFACTUAL AS Enfermedad_Actual, 
		   em.FECALTPAC AS [Fecha alta Médica], HC.CODDIAGNO AS CIE_10, CIE10.NOMDIAGNO AS Diagnóstico, u.NOMUSUARI AS Usuario, 
           uu.NOMUSUARI AS UsuarioModifico, D.UFUDESCRI AS UnidadActual, 
		   i.IOBSERVAC AS Observaciones, CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END AS TipoIngreso,
		   --CASE WHEN (CONVERT(varchar, em.FECALTPAC, 105)) IS NULL THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso
		   CASE WHEN  em.FECALTPAC IS NULL THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso
FROM   dbo.ADINGRESO AS i  INNER JOIN
           dbo.INUNIFUNC AS uf  ON uf.UFUCODIGO = i.UFUCODIGO LEFT OUTER JOIN
           dbo.SEGusuaru AS u  ON u.CODUSUARI = i.CODUSUCRE LEFT OUTER JOIN
           Contract.HealthAdministrator AS ea  ON ea.Id = i.GENCONENTITY LEFT OUTER JOIN
           Common.ThirdParty AS t ON t.Id = ea.ThirdPartyId LEFT OUTER JOIN
           dbo.INPACIENT AS p  ON p.IPCODPACI = i.IPCODPACI LEFT OUTER JOIN
           Contract.CareGroup AS ga  ON ga.Id = i.GENCAREGROUP LEFT OUTER JOIN
           Common.City AS ci  ON ci.Id = p.GENEXPEDITIONCITY LEFT OUTER JOIN
           dbo.SEGusuaru AS uu  ON uu.CODUSUARI = i.CODUSUMOD LEFT OUTER JOIN
           dbo.HCHISPACA AS HC  ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i' LEFT OUTER JOIN
           --dbo.HCURGING1 AS HCU ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
              -- (SELECT IPCODPACI, NUMINGRES, MAX(NUMEFOLIO) AS Folio
              --FROM   dbo.INDIAGNOP
              --WHERE (CODDIAPRI = 'True')
              --GROUP BY NUMINGRES, IPCODPACI) AS DX ON DX.IPCODPACI = HCU.IPCODPACI AND DX.NUMINGRES = HCU.NUMINGRES AND DX.Folio = HC.NUMEFOLIO LEFT OUTER JOIN
           dbo.INDIAGNOS AS CIE10  ON CIE10.CODDIAGNO = HC.CODDIAGNO LEFT OUTER JOIN
           --dbo.HCURGEVO1 AS HCU1  ON HCU.NUMINGRES = HC.NUMINGRES AND HCU1.IPCODPACI = HC.IPCODPACI AND HCU1.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
           dbo.ADINGRESO AS I2  ON I2.NUMINGRES = i.NUMINGRES LEFT OUTER JOIN
           dbo.INUNIFUNC AS D  ON I2.UFUAACTHOS = D.UFUCODIGO LEFT OUTER JOIN
           dbo.HCREGEGRE AS em  ON em.IPCODPACI = i.IPCODPACI AND em.NUMINGRES = i.NUMINGRES LEFT OUTER JOIN
		   dbo.ADCENATEN AS CE  ON CE.CODCENATE=I.CODCENATE
WHERE (i.IESTADOIN <> 'F') AND (i.IESTADOIN <> 'A') AND (i.IESTADOIN <> 'C') and i.IPCODPACI<>'9999999'
--AND i.NUMINGRES='1703C318D1'

--select * from dbo.HCREGEGRE 
--where NUMINGRES='1703C318D1'

--select * from dbo.HCHISPACA
--where NUMINGRES='1703C318D1'