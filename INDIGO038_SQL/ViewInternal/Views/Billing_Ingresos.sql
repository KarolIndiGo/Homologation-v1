-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_Ingresos
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create VIEW [ViewInternal].[Billing_Ingresos]
AS
SELECT  
                         i.NUMINGRES AS Ingreso, caa.nomcenate as CentroAtencion,ga.Code AS Cód_Grupo_Atención, ga.Name AS Grupo_Atención, t.Nit,ea.Name AS Entidad,
i.IPCODPACI AS Identificación,
CAST(p.GENEXPEDITIONCITY AS varchar(20)) + ' - ' + ISNULL(ci.Name, '')
                         AS Lugar_Expedición,
p.IPNOMCOMP AS Paciente, i.IFECHAING AS Fecha_Ingreso,
                         CASE i.IESTADOIN WHEN '  ' THEN 'Sin Confirmar Hoja de Trabajo' WHEN 'F' THEN 'Confirmada Hoja de Trabajo' WHEN 'A' THEN 'Anulado' WHEN 'C' THEN 'Cerrado' WHEN 'P' THEN 'Facturado Parcial' END AS Estado,
                         uf.UFUCODIGO as CodUF,uf.UFUDESCRI AS Unidad_Funcional, em.FECALTPAC AS Fecha_Alta_Médica,LTRIM(RTRIM(em.CODPROSAL)) + ' - '+ LTRIM(RTRIM(PRO.NOMMEDICO)) as MedicoAltaMedica,
  HC.CODDIAGNO AS CIE_10, CIE10.NOMDIAGNO AS Diagnóstico, i.codusucre AS CódUsuarioCrea, per.fullname AS Usuario_Crea,
                         i.FECREGCRE AS Fecha_Creación, uu.NOMUSUARI AS UsuarioModifico, i.FECREGMOD AS Fecha_Modificación, D .UFUDESCRI AS UnidadActual, i.IOBSERVAC AS Observaciones,
                         CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END AS TipoIngreso, HCU.ENFACTUAL AS Enfermedad_Actual,
UBINOMBRE AS Ubicación,
MUNNOMBRE AS Municipio, p.IPTELEFON AS [Tele Fijo],
                         p.IPTELMOVI AS [Tel Movil], i.IAUTORIZA as Autorizacion,
		  -- A.Tipo as TipoEntidad, case when a.tipo in ('Accidentes_de_transito','Fosyga') then 'SOAT' else 'GENERAL' END AS 'GRUPO',
		      CASE WHEN (CONVERT(varchar, em.FECALTPAC, 105)) IS NULL THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso, dep.nomdepart as Departamento,
			  CASE IPTIPOPAC WHEN 1 THEN 'Contributivo' WHEN 2 THEN 'Subsidiado' WHEN 3 THEN 'Vinculado' WHEN 4 THEN 'Particular' WHEN 5 THEN 'Otro' WHEN 6 THEN 'Desplazado Reg. Contributivo' WHEN 7 THEN 'Desplazado Reg. Subsidiado' WHEN 8 THEN 'Desplazado No Asegurado' END AS TipoPaciente--, rcd.Observation AS ObservacionFactura
FROM            dbo.ADINGRESO AS i  INNER JOIN
                         dbo.INUNIFUNC AS uf  ON uf.UFUCODIGO = i.UFUCODIGO LEFT OUTER JOIN
                         Contract.CareGroup AS ga  ON ga.Id = i.GENCAREGROUP LEFT OUTER JOIN
                         Security.[User] AS u  ON u.UserCode = i.CODUSUCRE LEFT OUTER JOIN
                         Security.[User] AS um  ON uM.UserCode = i.codusumod LEFT OUTER JOIN
                         Security.Person AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
                         Security.Person AS PERM  ON PERM .Id = um.IdPerson LEFT OUTER JOIN
                         dbo.HCHISPACA AS HC  ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i' LEFT OUTER JOIN
                         dbo.INPACIENT AS p  ON p.IPCODPACI = i.IPCODPACI LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ea  ON ea.Id = i.GENCONENTITY  LEFT OUTER JOIN
           Common.ThirdParty AS t ON t.Id = ea.ThirdPartyId LEFT OUTER JOIN
                         Common.City AS ci  ON ci.Id = p.GENEXPEDITIONCITY LEFT OUTER JOIN
                         dbo.HCURGING1 AS HCU  ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
                             (SELECT        IPCODPACI, NUMINGRES, MAX(NUMEFOLIO) AS Folio
                               FROM            dbo.INDIAGNOP
                               WHERE        (CODDIAPRI = 'True')
                               GROUP BY NUMINGRES, IPCODPACI) AS DX ON DX.IPCODPACI = HCU.IPCODPACI AND DX.NUMINGRES = HCU.NUMINGRES AND DX.Folio = HC.NUMEFOLIO LEFT OUTER JOIN
                         dbo.INDIAGNOS AS CIE10  ON CIE10.CODDIAGNO = HC.CODDIAGNO LEFT OUTER JOIN
                         dbo.HCURGEVO1 AS HCU1  ON HCU.NUMINGRES = HC.NUMINGRES AND HCU1.IPCODPACI = HC.IPCODPACI AND HCU1.NUMEFOLIO = HC.NUMEFOLIO LEFT OUTER JOIN
                         dbo.ADINGRESO AS I2  ON I2.NUMINGRES = i.NUMINGRES LEFT OUTER JOIN
                         dbo.INUNIFUNC AS D  ON I2.UFUAACTHOS = D .UFUCODIGO LEFT OUTER JOIN
                         dbo.HCREGEGRE AS em  ON em.IPCODPACI = HC.IPCODPACI AND em.NUMINGRES = HC.NUMINGRES LEFT OUTER JOIN
                         dbo.SEGusuaru AS uu  ON uu.CODUSUARI = i.CODUSUCRE LEFT OUTER JOIN
                         dbo.INUBICACI AS BB  ON BB.AUUBICACI = P.AUUBICACI LEFT OUTER JOIN
                         dbo.INMUNICIP AS EE  ON EE.DEPMUNCOD = BB.DEPMUNCOD LEFT OUTER JOIN
						  dbo.INDEPARTA AS DEP  ON DEP.depcodigo = ee.DEPCODIGO 
left outer join adcenaten as caa  on caa.codcenate=I.codcenate
LEFT OUTER JOIN INPROFSAL AS PRO  ON PRO.CODPROSAL=em.CODPROSAL
-- LEFT OUTER JOIN  ReportesFinancieros.[DF].[Contract_EntidadesAdministradoras] as a on a.id=I.GENCONENTITY--LEFT OUTER JOIN
--Billing.RevenueControl AS RC  ON RC.AdmissionNumber = I.NUMINGRES LEFT OUTER JOIN
--Billing.RevenueControlDetail AS rcd  ON rcd.RevenueControlId = RC.Id AND I.GENCONENTITY = rcd.HealthAdministratorId
WHERE      (i.IESTADOIN <> 'A') and i.IFECHAING>='01/01/2023'
--and i.NUMINGRES='5329709'