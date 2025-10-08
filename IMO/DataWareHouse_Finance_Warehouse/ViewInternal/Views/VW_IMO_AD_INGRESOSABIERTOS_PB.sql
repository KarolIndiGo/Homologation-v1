-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INGRESOSABIERTOS_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_IngresosAbiertos_PB
AS

SELECT DISTINCT 
           i.CODCENATE, 'Neiva' AS Sede, 
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
		  '' AS Observaciones,
		  CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END AS TipoIngreso,
		   CASE WHEN (CONVERT(varchar, em.FECALTPAC, 105)) IS NULL THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso,
		  CASE ga.EntityType WHEN '1' THEN 'EPS Contributivo' WHEN '2' THEN 'EPS Subsidiado'  
		  WHEN '3' THEN 'ET Vinculados Municipios' WHEN '4' THEN 'ET Vinculados Departamentos' 
		   WHEN '5' THEN 'ARL' WHEN '6' THEN 'Prepagada' WHEN '7' THEN 'IPS Privada' WHEN '8' THEN 'IPS Publica' WHEN '9' THEN 'Regimen Especial' WHEN '10' THEN 'Accidentes Transito' --WHEN '11' THEN 'Fosyga' 
		  -- WHEN '12' THEN 'Otros' WHEN '13' THEN 'Aseguradoras' 
		   else 'Particulares'
		   end as Regimen,  CASE WHEN p.IPSEXOPAC = '1' THEN 'Masculino' WHEN p.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
		   YEAR(i.IFECHAING) - YEAR(p.IPFECNACI) AS Edad
FROM   [INDIGO035].[dbo].[ADINGRESO] AS i  INNER JOIN
           [INDIGO035].[dbo].[INUNIFUNC] AS uf  ON uf.UFUCODIGO = i.UFUCODIGO LEFT OUTER JOIN
           [INDIGO035].[dbo].[SEGusuaru] AS u  ON u.CODUSUARI = i.CODUSUCRE LEFT OUTER JOIN
           [INDIGO035].[Contract].[HealthAdministrator] AS ea  ON ea.Id = i.GENCONENTITY LEFT OUTER JOIN
           [INDIGO035].[Common].[ThirdParty] AS t ON t.Id = ea.ThirdPartyId LEFT OUTER JOIN
           [INDIGO035].[dbo].[INPACIENT] AS p  ON p.IPCODPACI = i.IPCODPACI LEFT OUTER JOIN
           [INDIGO035].[Contract].[CareGroup] AS ga  ON ga.Id = i.GENCAREGROUP LEFT OUTER JOIN
           [INDIGO035].[Common].[City] AS ci  ON ci.Id = p.GENEXPEDITIONCITY LEFT OUTER JOIN
           [INDIGO035].[dbo].[SEGusuaru] AS uu  ON uu.CODUSUARI = i.CODUSUMOD LEFT OUTER JOIN
           [INDIGO035].[dbo].[HCHISPACA] AS HC  ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i' LEFT OUTER JOIN
           --dbo.HCURGING1 AS HCU ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
              -- (SELECT IPCODPACI, NUMINGRES, MAX(NUMEFOLIO) AS Folio
              --FROM   dbo.INDIAGNOP
              --WHERE (CODDIAPRI = 'True')
              --GROUP BY NUMINGRES, IPCODPACI) AS DX ON DX.IPCODPACI = HCU.IPCODPACI AND DX.NUMINGRES = HCU.NUMINGRES AND DX.Folio = HC.NUMEFOLIO LEFT OUTER JOIN
           [INDIGO035].[dbo].[INDIAGNOS] AS CIE10  ON CIE10.CODDIAGNO = HC.CODDIAGNO LEFT OUTER JOIN
           --dbo.HCURGEVO1 AS HCU1  ON HCU.NUMINGRES = HC.NUMINGRES AND HCU1.IPCODPACI = HC.IPCODPACI AND HCU1.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
           [INDIGO035].[dbo].[ADINGRESO] AS I2  ON I2.NUMINGRES = i.NUMINGRES LEFT OUTER JOIN
           [INDIGO035].[dbo].[INUNIFUNC] AS D  ON I2.UFUAACTHOS = D.UFUCODIGO LEFT OUTER JOIN
           [INDIGO035].[dbo].[HCREGEGRE] AS em  ON em.IPCODPACI = HC.IPCODPACI AND em.NUMINGRES = HC.NUMINGRES
WHERE (i.IESTADOIN <> 'F') AND (i.IESTADOIN <> 'A') AND (i.IESTADOIN <> 'C') and i.IPCODPACI<>'0123456789'
