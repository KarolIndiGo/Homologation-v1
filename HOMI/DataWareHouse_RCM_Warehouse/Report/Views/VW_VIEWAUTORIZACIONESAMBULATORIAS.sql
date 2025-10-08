-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: VW_VIEWAUTORIZACIONESAMBULATORIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_VIEWAUTORIZACIONESAMBULATORIAS]
AS
--SELECT COUNT(*) FROM [Report].[VW_VIEWAUTORIZACIONESAMBULATORIAS]

--select top 10* FROM [DataWareHouse_RCM].[Report].[VW_VIEWAUTORIZACIONESAMBULATORIAS]

--SELECT TOP 10 Edad
--FROM [DataWareHouse_RCM].[Report].[VW_VIEWAUTORIZACIONESAMBULATORIAS];


with CTE_Trazabilidad as
(
SELECT 
TPE.TraceabilityPaperworkId, 
MIN(TPE.Id) Id
FROM [INDIGO036].[Authorization].[TraceabilityPaperworkEvents] TPE 
WHERE TPE.Status IN (1,2,3,4) AND CAST(CreationDate AS DATE) BETWEEN GETDATE()-183 AND GETDATE()
GROUP BY TPE.TraceabilityPaperworkId
),
CTE_TrazabilidadEventos as
(
SELECT tpe.TraceabilityPaperworkId, MIN(tpe.Id) Id
	FROM [INDIGO036].[Authorization].[TraceabilityPaperworkEvents] tpe 
	WHERE tpe.Status IN (2,4) AND CAST(CreationDate AS DATE) BETWEEN GETDATE()-183 AND GETDATE()
	GROUP BY tpe.TraceabilityPaperworkId
),
CTE_Postergaciones as
( 
SELECT tpp.TraceabilityPaperworkId, SUM(DATEDIFF(MINUTE, tpp.CreationDate, IIF(tpp.Status = 1, CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'SA Pacific Standard Time' AS datetime), tpp.ModificationDate))) PostponementMinutes
FROM [INDIGO036].[Authorization].[TraceabilityPaperworkPostponementReasons] tpp 
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
Quantity,
Observations
FROM [DataWareHouse_RCM].[Authorization].[VW_VIEWLISTREQUEST_CTE] --[Authorization].[ViewListRequest_CTE]
WHERE CAST(RequestDate AS DATE) BETWEEN GETDATE()-182 AND GETDATE()
),

CTE_PRODUCTO AS
(
SELECT
prd.ProductRateId, prd.ProductId, 
			MAX(prd.Id) Id, MAX(IIF(prd.Contracted = 1, 1, 0)) 
			Contracted, MAX(IIF(prd.Quoted = 1, 1, 0)) Quoted,
			MIN(prd.InitialDate) InitialDate, 
			MAX(prd.EndDate) EndDate
	FROM [INDIGO036].[Inventory].[ProductRateDetail] prd
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
	FROM [INDIGO036].[Authorization].AuthorizationPortfolioCareCenter apcc
	JOIN [INDIGO036].[Authorization].AuthorizationPortfolio ap ON apcc.AuthorizationPortfolioId = ap.Id
	JOIN [INDIGO036].[Authorization].AuthorizationPortfolioCUPSEntity apce ON ap.Id = apce.AuthorizationPortfolioId
	JOIN [INDIGO036].[Authorization].ConfigurationServicesAmbulatory csa ON apce.Id = csa.AuthorizationPortfolioCUPSEntityId
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
[INDIGO036].[Authorization].AuthorizationPortfolioCareCenter apcc
JOIN [INDIGO036].[Authorization].AuthorizationPortfolio ap ON apcc.AuthorizationPortfolioId = ap.Id
JOIN [INDIGO036].[Authorization].AuthorizationPortfolioInventoryProduct apip ON ap.Id = apip.AuthorizationPortfolioId
JOIN [INDIGO036].[Authorization].ConfigurationServicesAmbulatory csa ON apip.Id = csa.AuthorizationPortfolioCUPSEntityId
WHERE ap.Status = 1
)
SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
CTE.EntityId,
CTE.EntityName,
CONCAT(FUN.UFUCODIGO, ' - ', FUN.UFUDESCRI) FunctionalUnitCodeName,
CTE.RequestDate [Fecha Solicitud],
cc.NOMCENATE [Centro de Atencion],
CTE.AdmissionNumber [Ingreso],
CASE p.IPTIPODOC
    WHEN 1 THEN 'CC'
    WHEN 2 THEN 'CE'
    WHEN 3 THEN 'TI'
    WHEN 4 THEN 'RC'
    WHEN 5 THEN 'PA'
    WHEN 6 THEN 'AS'
    WHEN 7 THEN 'MS'
    WHEN 8 THEN 'NU'
    WHEN 9 THEN 'CN'
    WHEN 10 THEN 'CD'
    WHEN 11 THEN 'SC'
    WHEN 12 THEN 'PE'
    WHEN 13 THEN 'PT'
    WHEN 14 THEN 'DE'
    ELSE 'SI'
END AS [Tipo ID Paciente],
CTE.PatientCode [Documento],
RTRIM(LTRIM(p.IPNOMCOMP)) [Nombre Paciente],
CAST(p.IPFECNACI as date) [Fecha Nacimiento],
p.IPTELEFON [Telefono],
p.IPTELMOVI [Movil],
p.CORELEPAC [Email],
DATEDIFF(YEAR, p.IPFECNACI, GETDATE()) [Edad],
CASE p.IPSEXOPAC WHEN 1 THEN 'M' 
				 WHEN 2 THEN 'F' END AS [Sexo],
RTRIM(p.IPDIRECCI) as Direccion,
ha.Code [CodigoEntidad],
ha.Name [Entidad],
cg.Code [Codigo Grupo de Atencion],
cg.Name [Grupo de Atencion],
CTE.ProfessionalCode,
ps.NOMMEDICO [Profesional],
ESP.DESESPECI as [ESPECIALIDAD],
CAST(CTE.Observations as varchar(2000)) AS [Observacion Orden],
--OB.OBSERVACION AS [Observacion Orden],
d.CODDIAGNO [Cod Diagnostico],
d.NOMDIAGNO [Descripción CIE10],
CASE CTE.EntityName 
	when 'HCORDIMAG' then 'IMAGENES'
	when 'HCORDLABO' then 'LABORATORIOS'
	when 'HCORDPATO' then 'PATOLOGIAS'
	when 'HCORDINTE' then 'INTERCONSULTAS'
	when 'HCORDPRON' then 'PROCEDIMIENTOS NO QX'
	when 'HCORDPROQ' then 'PROCEDIMIENTOS QX'
	when 'HCORHEMCO' then 'HEMOCOMPONENTES'
	when 'HCDESCOEX' then 'CONTROLES'
	when 'HCPRESCRA' then 'MEDICAMENTOS'
	else CTE.EntityName
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
CTE.Quantity [Cantidad Ordenada],
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
DATEDIFF(MINUTE, tp.RequestDate, COALESCE(tper.CreationDate, tpea.CreationDate, tp.CancellationDate, CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'SA Pacific Standard Time' AS datetime))) [Tiempo Solicitud (Minutos)],
DATEDIFF(MINUTE, tper.CreationDate, COALESCE(tpea.CreationDate, tp.CancellationDate, CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'SA Pacific Standard Time' AS datetime))) [Tiempo Radicacion (Minutos)],
tpp.PostponementMinutes [Tiempo Pospuesto (Minutos)],
coalesce(pcancel.Fullname, pers.Fullname) as Usuario,
1 as 'CANTIDAD',
CAST(CTE.RequestDate AS DATE) [FECHA BUSQUEDA], 
YEAR(CTE.RequestDate) AS 'AÑO FECHA BUSQUEDA', 
MONTH(CTE.RequestDate) AS 'MES AÑO FECHA BUSQUEDA', 
CASE MONTH(CTE.RequestDate) WHEN 1 THEN 'ENERO'
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
DAY(CTE.RequestDate) AS [DIA FECHA BUSQUEDA],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
CTE_ViewListRequest_CTE CTE 
INNER JOIN [INDIGO036].[dbo].INUNIFUNC FUN on CTE.FunctionalUnitCode=FUN.UFUCODIGO
INNER JOIN [INDIGO036].[dbo].ADCENATEN cc  ON CTE.CareCenterCode = cc.CODCENATE
INNER JOIN [INDIGO036].[dbo].INPACIENT p  ON CTE.PatientCode = p.IPCODPACI
INNER JOIN [INDIGO036].[dbo].ADINGRESO ain  on CTE.AdmissionNumber=ain.NUMINGRES
INNER JOIN [INDIGO036].[Contract].CareGroup cg  ON ain.GENCAREGROUP = cg.Id
LEFT JOIN [INDIGO036].[Contract].CUPSEntity ce  ON CTE.Type = 1 AND CTE.ItemCode = ce.Code
LEFT JOIN [INDIGO036].[Inventory].[InventoryProduct] ip  ON CTE.Type = 2 AND CTE.ItemCode = ip.Code
LEFT JOIN [INDIGO036].[Contract].ProcedureCups ptc ON CTE.Type = 1 AND cg.ProcedureTemplateId = ptc.ProceduresTemplateId AND ce.Id = ptc.CupsId AND ISNULL(CTE.ContractDescriptionId, 0) = ISNULL(ptc.CUPSEntityContractDescriptionId, 0)
LEFT JOIN CTE_PRODUCTO prd ON CTE.Type = 2 AND cg.ProductRateId = prd.ProductRateId AND ip.Id = prd.ProductId AND CAST(CTE.RequestDate AS DATE) BETWEEN prd.InitialDate AND prd.EndDate
LEFT JOIN CTE_AUTORIZACION csa ON CTE.CareCenterCode = csa.CareCenterCode AND CTE.Type = csa.Type AND csa.ItemId = IIF(CTE.Type = 1, ce.Id, ip.Id) AND ISNULL(CTE.ContractDescriptionId, 0) = ISNULL(csa.DescriptionId, 0)
left join [INDIGO036].[Authorization].AuthorizationGroup ag on ag.Id = csa.AuthorizationGroupId
LEFT JOIN [INDIGO036].[Authorization].ConfigurationServicesAmbulatoryExceptions csae ON csa.Id = csae.ConfigurationServicesAmbulatoryId AND cg.Id = csae.CareGroupId
LEFT JOIN [INDIGO036].[dbo].HCHISPACA AS HIS  ON HIS.NUMINGRES = CTE.AdmissionNumber AND HIS.NUMEFOLIO = CTE.Folio
LEFT JOIN [INDIGO036].[dbo].INESPECIA AS ESP  ON ESP.CODESPECI = HIS.CODESPTRA
left join [INDIGO036].[dbo].HCORDLABO as LAB on CTE.EntityId=LAB.AUTO AND CTE.EntityName='HCORDLABO'
left join [INDIGO036].[dbo].HCORDIMAG as IMA ON CTE.EntityId=IMA.AUTO AND CTE.EntityName='HCORDIMAG'
-------------------------------------------------------------------------------
LEFT JOIN [INDIGO036].[Contract].HealthAdministrator ha  ON ain.GENCONENTITY=ha.Id
LEFT JOIN [INDIGO036].[dbo].INPROFSAL ps  ON CTE.ProfessionalCode = ps.CODPROSAL
left join [INDIGO036].[dbo].INDIAGNOS d on CTE.DiagnosticCode=d.CODDIAGNO
LEFT JOIN [INDIGO036].[Contract].ContractDescriptions cd  ON CTE.ContractDescriptionId = cd.Id
LEFT JOIN INDIGO036.Billing.BillingGroup bg  ON ISNULL(ce.BillingGroupId, ip.BillingGroupId)=bg.Id
-------------------------------------------------------------------------------
LEFT JOIN [INDIGO036].[Authorization].TraceabilityPaperwork tp  on CTE.TraceabilityPaperworkId=tp.Id
LEFT JOIN [INDIGO036].[Security].[UserInt] ucancel on tp.CancellationUserCode=ucancel.UserCode
LEFT join [INDIGO036].[Security].[PersonInt] pcancel on ucancel.IdPerson=pcancel.Id
LEFT JOIN CTE_Trazabilidad tperm ON tp.Id = tperm.TraceabilityPaperworkId
LEFT JOIN [INDIGO036].[Authorization].TraceabilityPaperworkEvents tper  ON tperm.Id = tper.Id
LEFT JOIN [INDIGO036].[Security].[UserInt] u on tper.CreationUser=u.UserCode
LEFT join [INDIGO036].[Security].[PersonInt] pers on u.IdPerson=pers.Id
-------------------------------------------------------------------------------
LEFT JOIN CTE_TrazabilidadEventos tpeam ON tp.Id = tpeam.TraceabilityPaperworkId
LEFT JOIN [INDIGO036].[Authorization].TraceabilityPaperworkEvents tpea  ON tpeam.Id = tpea.Id
-------------------------------------------------------------------------------
LEFT JOIN CTE_Postergaciones tpp ON tp.Id = tpp.TraceabilityPaperworkId
--LEFT JOIN CTE_OBSERVACION OB ON TP.EntityId=OB.ID AND cte.EntityName=OB.TABLA
