-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: dbo
-- Object: IND_AD_IngresosAbiertosVie
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [dbo].[IND_AD_IngresosAbiertosVie]
AS
SELECT DISTINCT 
                         i.NUMINGRES AS Ingreso, ga.Code AS Cód_Grupo_Atención, ga.Name AS Grupo_Atención, ea.Name AS Entidad, i.IPCODPACI AS Identificación, CAST(p.GENEXPEDITIONCITY AS varchar(20)) + ' - ' + ISNULL(ci.Name, '') 
                         AS Lugar_Expedición, p.IPNOMCOMP AS Paciente, i.IFECHAING AS Fecha_Ingreso, 
                         CASE i.IESTADOIN WHEN '  ' THEN 'Sin Confirmar Hoja de Trabajo' WHEN 'F' THEN 'Confirmada Hoja de Trabajo' WHEN 'A' THEN 'Anulado' WHEN 'C' THEN 'Cerrado' WHEN 'P' THEN 'Facturado Parcial' END AS Estado, 
                         uf.UFUDESCRI AS Unidad_Funcional, em.FECALTPAC AS Fecha_Alta_Médica, HC.CODDIAGNO AS CIE_10, CIE10.NOMDIAGNO AS Diagnóstico, i.codusucre AS CódUsuarioCrea, per.fullname AS Usuario_Crea, 
                         i.FECREGCRE AS Fecha_Creación, uu.NOMUSUARI AS UsuarioModifico, i.FECREGMOD AS Fecha_Modificación, D .UFUDESCRI AS UnidadActual, i.IOBSERVAC AS Observaciones, 
                         CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END AS TipoIngreso, HCU.ENFACTUAL AS Enfermedad_Actual, UBINOMBRE AS Ubicación, MUNNOMBRE AS Municipio, p.IPTELEFON AS [Tele Fijo], 
                         p.IPTELMOVI AS [Tel Movil]
FROM            dbo.ADINGRESO AS i WITH (NOLOCK) INNER JOIN
                         dbo.INUNIFUNC AS uf WITH (NOLOCK) ON uf.UFUCODIGO = i.UFUCODIGO LEFT OUTER JOIN
                         Contract.CareGroup AS ga WITH (NOLOCK) ON ga.Id = i.GENCAREGROUP LEFT OUTER JOIN
                         Security.[User] AS u ON u.UserCode = i.CODUSUCRE LEFT OUTER JOIN
                         Security.[User] AS um ON u.UserCode = i.codusumod LEFT OUTER JOIN
                         Security.Person AS per ON per.Id = u.IdPerson LEFT OUTER JOIN
                         Security.Person AS PERM ON PERM .Id = um.IdPerson LEFT OUTER JOIN
                         dbo.HCHISPACA AS HC WITH (NOLOCK) ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i' LEFT OUTER JOIN
                         dbo.INPACIENT AS p WITH (NOLOCK) ON p.IPCODPACI = i.IPCODPACI LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ea WITH (nolock) ON ea.Id = i.GENCONENTITY LEFT OUTER JOIN
                         Common.City AS ci WITH (NOLOCK) ON ci.Id = p.GENEXPEDITIONCITY LEFT OUTER JOIN
                         dbo.HCURGING1 AS HCU WITH (NOLOCK) ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
                             (SELECT        IPCODPACI, NUMINGRES, MAX(NUMEFOLIO) AS Folio
                               FROM            dbo.INDIAGNOP
                               WHERE        (CODDIAPRI = 'True')
                               GROUP BY NUMINGRES, IPCODPACI) AS DX ON DX.IPCODPACI = HCU.IPCODPACI AND DX.NUMINGRES = HCU.NUMINGRES AND DX.Folio = HC.NUMEFOLIO LEFT OUTER JOIN
                         dbo.INDIAGNOS AS CIE10 WITH (NOLOCK) ON CIE10.CODDIAGNO = HC.CODDIAGNO LEFT OUTER JOIN
                         dbo.HCURGEVO1 AS HCU1 WITH (NOLOCK) ON HCU.NUMINGRES = HC.NUMINGRES AND HCU1.IPCODPACI = HC.IPCODPACI AND HCU1.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
                         dbo.ADINGRESO AS I2 WITH (NOLOCK) ON I2.NUMINGRES = i.NUMINGRES LEFT OUTER JOIN
                         dbo.INUNIFUNC AS D WITH (NOLOCK) ON I2.UFUAACTHOS = D .UFUCODIGO LEFT OUTER JOIN
                         dbo.HCREGEGRE AS em WITH (NOLOCK) ON em.IPCODPACI = HC.IPCODPACI AND em.NUMINGRES = HC.NUMINGRES LEFT OUTER JOIN
                         dbo.SEGusuaru AS uu WITH (NOLOCK) ON uu.CODUSUARI = i.CODUSUCRE LEFT OUTER JOIN
                         dbo.INUBICACI AS BB WITH (NOLOCK) ON BB.AUUBICACI = P.AUUBICACI LEFT OUTER JOIN
                         dbo.INMUNICIP AS EE WITH (NOLOCK) ON EE.DEPMUNCOD = BB.DEPMUNCOD
WHERE        (i.CODCENATE IN ('001', '00101','00102','00103')) AND (i.IESTADOIN <> 'F') AND (i.IESTADOIN <> 'A') AND (i.IESTADOIN <> 'C')
