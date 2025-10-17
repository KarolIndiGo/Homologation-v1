-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewAutorizacionesAmbulatorias
-- Extracted by Fabric SQL Extractor SPN v3.9.0







    /*******************************************************************************************************************
Nombre: [Report].[ViewAutorizacionesAmbulatorias]
Tipo:Vista
Observacion:
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 28-09-2023
Ovservaciones:Se crean los CTE CTE_ViewListRequest_CTE, CTE_PRODUCTO y se elimina el cte CTE_OBSERVACION para mejorar en un 50% la consulta de la 
			  vista y se coloque filtro de fecha a 6 meses
--------------------------------------
Version 3
Persona que modifico: Amira Gil Meneses
Observacion:Se adiciona campo Fecha sugerida para laboratorios e Imagenología
Fecha:22-11-2023
--***********************************************************************************************************************************/


CREATE VIEW [Report].[ViewAutorizacionesAmbulatorias] as

with 

CTE_Trazabilidad as
(
SELECT 
TPE.TraceabilityPaperworkId, 
MIN(TPE.Id) Id
FROM [Authorization].TraceabilityPaperworkEvents TPE 
WHERE TPE.Status IN (1,2,3,4) AND CAST(CreationDate AS DATE) BETWEEN GETDATE()-183 AND GETDATE()
GROUP BY TPE.TraceabilityPaperworkId
),
CTE_TrazabilidadEventos as
(
SELECT tpe.TraceabilityPaperworkId, MIN(tpe.Id) Id
	FROM [Authorization].TraceabilityPaperworkEvents tpe 
	WHERE tpe.Status IN (2,4) AND CAST(CreationDate AS DATE) BETWEEN GETDATE()-183 AND GETDATE()
	GROUP BY tpe.TraceabilityPaperworkId
),
CTE_Postergaciones as
(
SELECT tpp.TraceabilityPaperworkId, SUM(DATEDIFF(MINUTE, tpp.CreationDate, IIF(tpp.Status = 1, Common.GETDATE(), tpp.ModificationDate))) PostponementMinutes
FROM [Authorization].TraceabilityPaperworkPostponementReasons tpp 
GROUP BY tpp.TraceabilityPaperworkId
),

CTE_ViewListRequest_CTE AS
(
SELECT 
EntityId,
EntityName,
RequestDate,
FunctionalUnitCode,
CareCenterCode,
PatientCode,
AdmissionNumber,
Type,
ItemCode,
ContractDescriptionId,
ProfessionalCode,
Folio,DiagnosticCode,
TraceabilityPaperworkId,
Quantity,observations
FROM
[Authorization].[ViewListRequest_CTE]
WHERE CAST(RequestDate AS DATE) BETWEEN GETDATE()-182 AND GETDATE()
),

--CTE_OBSERVACION AS
--(
--select 'HCORDPROQ'AS TABLA,[AUTO] AS ID,OBSSERIPS AS OBSERVACION from HCORDPROQ WHERE CAST(FECORDMED AS DATE) BETWEEN GETDATE()-183 AND GETDATE() AND OBSSERIPS IS NOT NULL
--UNION ALL
--select 'HCORDPRON'AS TABLA,[AUTO] AS ID,OBSSERIPS AS OBSERVACION from HCORDPRON WHERE CAST(FECORDMED AS DATE) BETWEEN GETDATE()-183 AND GETDATE() AND OBSSERIPS IS NOT NULL
--UNION ALL
--select 'HCORDLABO'AS TABLA,[AUTO] AS ID,OBSSERIPS AS OBSERVACION from HCORDLABO WHERE CAST(FECORDMED AS DATE) BETWEEN GETDATE()-183 AND GETDATE() AND OBSSERIPS IS NOT NULL
--UNION ALL
--select 'HCORHEMCO'AS TABLA,ID,OBSERVACI AS OBSERVACION from HCORHEMCO WHERE CAST(FECORDMED AS DATE) BETWEEN GETDATE()-183 AND GETDATE() AND OBSERVACI IS NOT NULL
--UNION ALL
--select 'HCORDPATO'AS TABLA,[AUTO] AS ID,OBSSERIPS AS OBSERVACION from HCORDPATO WHERE CAST(FECORDMED AS DATE) BETWEEN GETDATE()-183 AND GETDATE() AND OBSSERIPS IS NOT NULL
--UNION ALL
--select 'HCORDINTE'AS TABLA,[AUTO] AS ID,OBSSERIPS AS OBSERVACION from HCORDINTE WHERE CAST(FECORDMED AS DATE) BETWEEN GETDATE()-183 AND GETDATE() AND OBSSERIPS IS NOT NULL
--UNION ALL
--select 'HCORDIMAG'AS TABLA,[AUTO] AS ID,OBSSERIPS AS OBSERVACION  from HCORDIMAG WHERE CAST(FECORDMED AS DATE) BETWEEN GETDATE()-183 AND GETDATE() AND OBSSERIPS IS NOT NULL
--),
CTE_PRODUCTO AS
(
SELECT	
prd.ProductRateId, prd.ProductId, 
			MAX(prd.Id) Id, MAX(IIF(prd.Contracted = 1, 1, 0)) 
			Contracted, MAX(IIF(prd.Quoted = 1, 1, 0)) Quoted,
			MIN(prd.InitialDate) InitialDate, 
			MAX(prd.EndDate) EndDate
	FROM Inventory.ProductRateDetail prd
	WHERE CAST(EndDate AS DATE) BETWEEN GETDATE()-183 AND GETDATE()
	GROUP BY prd.ProductRateId, prd.ProductId
),
CTE_AUTORIZACION AS 
(
SELECT	csa.Id,
			apcc.CareCenterCode, 		
			1 Type, 
			apce.CUPSEntityId ItemId,
			apce.ContractDescriptionId DescriptionId,
			apce.AuthorizationGroupId
	FROM [Authorization].AuthorizationPortfolioCareCenter apcc
	JOIN [Authorization].AuthorizationPortfolio ap ON apcc.AuthorizationPortfolioId = ap.Id
	JOIN [Authorization].AuthorizationPortfolioCUPSEntity apce ON ap.Id = apce.AuthorizationPortfolioId
	JOIN [Authorization].ConfigurationServicesAmbulatory csa ON apce.Id = csa.AuthorizationPortfolioCUPSEntityId
	WHERE ap.Status = 1

UNION ALL

SELECT
csa.Id,
		apcc.CareCenterCode, 		
		2 Type, 
		apip.InventoryProductId ItemId,
		NULL DescriptionId,
		apip.AuthorizationGroupId
FROM 
[Authorization].AuthorizationPortfolioCareCenter apcc
JOIN [Authorization].AuthorizationPortfolio ap ON apcc.AuthorizationPortfolioId = ap.Id
JOIN [Authorization].AuthorizationPortfolioInventoryProduct apip ON ap.Id = apip.AuthorizationPortfolioId
JOIN [Authorization].ConfigurationServicesAmbulatory csa ON apip.Id = csa.AuthorizationPortfolioCUPSEntityId
WHERE ap.Status = 1
)

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
cte.EntityId,
cte.EntityName,
CONCAT(fun.UFUCODIGO, ' - ', fun.UFUDESCRI) FunctionalUnitCodeName,
cte.RequestDate [Fecha Solicitud],
cc.NOMCENATE [Centro de Atencion],
cte.AdmissionNumber [Ingreso],
Common.GetIdentificationTypeCode(p.IPTIPODOC, 1) [Tipo ID Paciente],
cte.PatientCode [Documento],
RTRIM(LTRIM(p.IPNOMCOMP)) [Nombre Paciente],
CAST(p.IPFECNACI as date) [Fecha Nacimiento],
p.IPTELEFON [Telefono],
p.IPTELMOVI [Movil],
p.CORELEPAC [Email],
dbo.Edad(p.IPFECNACI, [Common].[GETDATE]()) [Edad],
CASE p.IPSEXOPAC WHEN 1 THEN 'M' 
				 WHEN 2 THEN 'F' END AS [Sexo],
RTRIM(p.IPDIRECCI) as Direccion,
ha.Code [CodigoEntidad],
ha.Name [Entidad],
cg.Code [Codigo Grupo de Atencion],
cg.Name [Grupo de Atencion],
cte.ProfessionalCode,
ps.NOMMEDICO [Profesional],
ESP.DESESPECI as [ESPECIALIDAD],
CAST(cte.observations as varchar(2000)) AS [Observacion Orden],
--OB.OBSERVACION AS [Observacion Orden],
d.CODDIAGNO [Cod Diagnostico],
d.NOMDIAGNO [Descripción CIE10],
CASE cte.EntityName 
	when 'HCORDIMAG' then 'IMAGENES'
	when 'HCORDLABO' then 'LABORATORIOS'
	when 'HCORDPATO' then 'PATOLOGIAS'
	when 'HCORDINTE' then 'INTERCONSULTAS'
	when 'HCORDPRON' then 'PROCEDIMIENTOS NO QX'
	when 'HCORDPROQ' then 'PROCEDIMIENTOS QX'
	when 'HCORHEMCO' then 'HEMOCOMPONENTES'
	when 'HCDESCOEX' then 'CONTROLES'
	when 'HCPRESCRA' then 'MEDICAMENTOS'
	else cte.EntityName
	end as [TipoSolicitud],
ISNULL(ce.Code, ip.Code) [CUPS],
ISNULL(ce.Description, ip.Name) [Servicio],
cd.Name [Descripcion Relacionada],
HIS.INDICAMED 'INDICACIONES MEDICAS',
IIF(ISNULL(ptc.Id, 0) > 0 OR ISNULL(prd.Id, 0) > 0, 1, 0) 'CUBIERTO',
IIF(ISNULL(ptc.Contracted, 0) = 1 OR ISNULL(prd.Contracted, 0) = 1, 1, 0) 'CONTRATADO',
IIF(ISNULL(ptc.Quoted, 0) = 1 OR ISNULL(prd.Quoted, 0) = 1, 1, 0) 'COTIZADO',
IIF(csa.Id IS NULL, 0, ISNULL(csae.SusceptibleAuthorization, 1)) 'AUTORIZADO',
bg.Name [Agrupador],
cte.Quantity [Cantidad Ordenada],
CASE ISNULL(tp.Status, 1) WHEN 1 THEN 'Solicitado' 
						  WHEN 2 THEN 'Radicado' 
						  WHEN 3 THEN 'Radicado Pendiente de Autorizacion' 
						  WHEN 4 THEN 'Radicado No Autorizado' 
						  WHEN 5 THEN 'Autorizado' 
						  WHEN 6 THEN 'Autorizado en Entrega' 
						  WHEN 7 THEN 'Autorizado Entregado' 
						  WHEN 8 THEN 'Agendado' 
						  WHEN 9 THEN 'Ejecutado' 
						  WHEN 10 THEN 'Facturado' 
						  WHEN 11 THEN 'Cancelado' 
						  WHEN 12 THEN 'Solicitado en Cotización'
						  WHEN 13 THEN 'Radicado en Cotización'
						  WHEN 14 THEN 'Autorizado Remitido'
						  WHEN 15 THEN 'Autorizado con Cotización'
						  WHEN 16 THEN 'Postergado' ELSE 'N/A'END [Estado Actual],
tper.CreationDate [Fecha Radicado],
tpea.CreationDate [Fecha Autorizacion],
tpea.AuthorizationExpiredDate [Fecha Vencimiento Autorizacion],
ISNULL(LAB.FECHASUGE,IMA.FECHASUGE )  AS [FechaSugerida],
tp.CancellationDate [Fecha Cancelacion],
DATEDIFF(MINUTE, tp.RequestDate, COALESCE(tper.CreationDate, tpea.CreationDate, tp.CancellationDate, Common.GETDATE())) [Tiempo Solicitud (Minutos)],
DATEDIFF(MINUTE, tper.CreationDate, COALESCE(tpea.CreationDate, tp.CancellationDate, Common.GETDATE())) [Tiempo Radicacion (Minutos)],
tpp.PostponementMinutes [Tiempo Pospuesto (Minutos)],
coalesce(pcancel.FullName, pers.Fullname) as Usuario,
1 as 'CANTIDAD',
CAST(cte.RequestDate AS DATE) [FECHA BUSQUEDA], 
YEAR(cte.RequestDate) AS 'AÑO FECHA BUSQUEDA', 
MONTH(cte.RequestDate) AS 'MES AÑO FECHA BUSQUEDA', 
CASE MONTH(cte.RequestDate) WHEN 1 THEN 'ENERO'
							WHEN 2 THEN 'FEBRERO'
							WHEN 3 THEN 'MARZO'
							WHEN 4 THEN 'ABRIL'
							WHEN 5 THEN 'MAYO'
							WHEN 6 THEN 'JUNIO'
							WHEN 7 THEN 'JULIO'
							WHEN 8 THEN 'AGOSTO'
							WHEN 9 THEN 'SEPTIEMBRE'
							WHEN 10 THEN 'OCTUBRE'
							WHEN 11 THEN 'NOVIEMBRE'
							WHEN 12 THEN 'DICIEMBRE' END AS [MES NOMBRE FECHA BUSQUEDA], 
DAY(cte.RequestDate) AS [DIA FECHA BUSQUEDA],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
CTE_ViewListRequest_CTE CTE 
INNER JOIN dbo.INUNIFUNC FUN on cte.FunctionalUnitCode=fun.UFUCODIGO
INNER JOIN dbo.ADCENATEN cc  ON cte.CareCenterCode = cc.CODCENATE
INNER JOIN dbo.INPACIENT p  ON cte.PatientCode = p.IPCODPACI
INNER JOIN dbo.ADINGRESO ain  on cte.AdmissionNumber=ain.NUMINGRES
INNER JOIN Contract.CareGroup cg  ON ain.GENCAREGROUP = cg.Id
LEFT JOIN Contract.CUPSEntity ce  ON cte.Type = 1 AND cte.ItemCode = ce.Code
LEFT JOIN Inventory.InventoryProduct ip  ON cte.Type = 2 AND cte.ItemCode = ip.Code
LEFT JOIN Contract.ProcedureCups ptc ON cte.Type = 1 AND cg.ProcedureTemplateId = ptc.ProceduresTemplateId AND ce.Id = ptc.CupsId AND ISNULL(cte.ContractDescriptionId, 0) = ISNULL(ptc.CUPSEntityContractDescriptionId, 0)
LEFT JOIN CTE_PRODUCTO prd ON cte.Type = 2 AND cg.ProductRateId = prd.ProductRateId AND ip.Id = prd.ProductId AND CAST(cte.RequestDate AS DATE) BETWEEN prd.InitialDate AND prd.EndDate
LEFT JOIN CTE_AUTORIZACION csa ON cte.CareCenterCode = csa.CareCenterCode AND cte.Type = csa.Type AND csa.ItemId = IIF(cte.Type = 1, ce.Id, ip.Id) AND ISNULL(cte.ContractDescriptionId, 0) = ISNULL(csa.DescriptionId, 0)
left join [Authorization].AuthorizationGroup ag on ag.Id = csa.AuthorizationGroupId
LEFT JOIN [Authorization].ConfigurationServicesAmbulatoryExceptions csae ON csa.Id = csae.ConfigurationServicesAmbulatoryId AND cg.Id = csae.CareGroupId
LEFT JOIN dbo.HCHISPACA AS HIS  ON HIS.NUMINGRES = cte.AdmissionNumber AND HIS.NUMEFOLIO = cte.Folio
LEFT JOIN dbo.INESPECIA AS ESP  ON ESP.CODESPECI = HIS.CODESPTRA
left join dbo.HCORDLABO as LAB on cte.EntityId=lab.Auto AND cte.EntityName='HCORDLABO'
left join dbo.HCORDIMAG as IMA ON cte.EntityId=ima.Auto AND cte.EntityName='HCORDIMAG'

-------------------------------------------------------------------------------
LEFT JOIN Contract.HealthAdministrator ha  ON ain.GENCONENTITY=ha.Id
LEFT JOIN dbo.INPROFSAL ps  ON cte.ProfessionalCode = ps.CODPROSAL
left join dbo.INDIAGNOS d on cte.DiagnosticCode=d.CODDIAGNO
LEFT JOIN Contract.ContractDescriptions cd  ON cte.ContractDescriptionId = cd.Id
LEFT JOIN Billing.BillingGroup bg  ON ISNULL(ce.BillingGroupId, ip.BillingGroupId)=bg.Id
-------------------------------------------------------------------------------
LEFT JOIN [Authorization].TraceabilityPaperwork tp  on cte.TraceabilityPaperworkId=tp.Id
LEFT JOIN [Security].[User] ucancel on tp.CancellationUserCode=ucancel.UserCode
LEFT join [Security].Person pcancel on ucancel.IdPerson=pcancel.Id
LEFT JOIN CTE_Trazabilidad tperm ON tp.Id = tperm.TraceabilityPaperworkId
LEFT JOIN [Authorization].TraceabilityPaperworkEvents tper  ON tperm.Id = tper.Id
LEFT JOIN [Security].[User] u on tper.CreationUser=u.UserCode
LEFT join [Security].Person pers on u.IdPerson=pers.Id
-------------------------------------------------------------------------------
LEFT JOIN CTE_TrazabilidadEventos tpeam ON tp.Id = tpeam.TraceabilityPaperworkId
LEFT JOIN [Authorization].TraceabilityPaperworkEvents tpea  ON tpeam.Id = tpea.Id
-------------------------------------------------------------------------------
LEFT JOIN CTE_Postergaciones tpp ON tp.Id = tpp.TraceabilityPaperworkId
--LEFT JOIN CTE_OBSERVACION OB ON TP.EntityId=OB.ID AND cte.EntityName=OB.TABLA
