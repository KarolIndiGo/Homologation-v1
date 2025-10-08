-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Authorization
-- Object: VW_VIEWLISTREQUEST_CTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Authorization].VW_VIEWLISTREQUEST_CTE
AS

with temp_ADINGRESO as (
	select a.UFUCODIGO, a.NUMINGRES
	from INDIGO036.dbo.ADINGRESO a 
	where IESTADOIN <> 'A'
),
temp_HCHISPACA as (
	select h.FECHISPAC, h.CODPROSAL, h.INDICAMED, h.CODDIAGNO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.CODCENATE, h.UFUCODIGO
	from INDIGO036.dbo.HCHISPACA h 
	inner join temp_ADINGRESO t  on t.NUMINGRES = h.NUMINGRES
	where ESTAFOLIO <> 0
),
temp_HCORDIMAG as (
	select h.AUTO, h.CODCENATE, h.UFUCODIGO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECORDMED, h.CODPROSAL, h.CANSERIPS,
	h.CODSERIPS, h.TraceabilityPaperworkId, h.TraceabilityPaperworkEventsId, h.OBSSERIPS, h.CODDIAGNO, h.IDDESCRIPCIONRELACIONADA
	from INDIGO036.dbo.HCORDIMAG h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1
),
temp_HCORDLABO as (
	select h.AUTO, h.CODCENATE, h.UFUCODIGO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECORDMED, h.CODPROSAL, h.CANSERIPS,
	h.CODSERIPS, h.TraceabilityPaperworkId, h.TraceabilityPaperworkEventsId, h.OBSSERIPS, h.CODDIAGNO, h.IDDESCRIPCIONRELACIONADA
	from INDIGO036.dbo.HCORDLABO h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1
),
temp_HCORDPATO as (
	select h.AUTO, h.CODCENATE, h.UFUCODIGO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECORDMED, h.CODPROSAL, h.CANSERIPS,
	h.CODSERIPS, h.TraceabilityPaperworkId, h.TraceabilityPaperworkEventsId, h.OBSSERIPS, h.CODDIAGNO, h.IDDESCRIPCIONRELACIONADA
	from INDIGO036.dbo.HCORDPATO h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1
),
temp_HCORDINTE as (
	select h.AUTO, h.CODCENATE, h.UFUCODIGO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECORDMED, h.CODPROSAL, h.CANSERIPS,
	h.CODSERIPS, h.TraceabilityPaperworkId, h.TraceabilityPaperworkEventsId, h.OBSSERIPS, h.CODDIAGNO, h.IDDESCRIPCIONRELACIONADA
	from INDIGO036.dbo.HCORDINTE h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1
),
temp_HCORDPRON as (
	select h.AUTO, h.CODCENATE, h.UFUCODIGO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECORDMED, h.CODPROSAL, h.CANSERIPS,
	h.CODSERIPS, h.TraceabilityPaperworkId, h.TraceabilityPaperworkEventsId, h.OBSSERIPS, h.CODDIAGNO, h.IDDESCRIPCIONRELACIONADA
	from INDIGO036.dbo.HCORDPRON  h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1
),
temp_HCORDPROQ as (
	select h.AUTO, h.CODCENATE, h.UFUCODIGO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECORDMED, h.CODPROSAL, h.CANSERIPS,
	h.CODSERIPS, h.TraceabilityPaperworkId, h.TraceabilityPaperworkEventsId, h.OBSSERIPS, h.CODDIAGNO, h.IDDESCRIPCIONRELACIONADA
	from INDIGO036.dbo.HCORDPROQ h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1
),
temp_HCPRESCRD as (
	select h.ID, h.CODCENATE, h.UFUCODIGO, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECINIDOS, h.CODPROSAL, h.CANPEDPRO,
	h.CODPRODUC, h.TraceabilityPaperworkId, h.TraceabilityPaperworkEventsId
	from INDIGO036.dbo.HCPRESCRD h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1 and h.IDHCORDQUIMIO is null
),
temp_HCORHEMCO as (
	select h.ID, h.CODCENATE, h.NUMINGRES, h.NUMEFOLIO, h.IPCODPACI, h.FECORDMED, h.CODDIAGNO, t.UFUCODIGO
	from INDIGO036.dbo.HCORHEMCO h 
	inner join temp_HCHISPACA t  on t.NUMINGRES = h.NUMINGRES and t.NUMEFOLIO = h.NUMEFOLIO and t.IPCODPACI = h.IPCODPACI
	where h.MANEXTPRO = 1
),
temp_CUPSEntity as (
	select ce.Id, ce.Code, ce.Description, 
	cecd.Id CUPSEntityContractDescriptionId,
	cd.Id ContractDescriptionId, cd.Code ContractDescriptionCode, cd.Name ContractDescriptionName
	from INDIGO036.Contract.CUPSEntity ce  
	LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd  ON ce.Id = cecd.CUPSEntityId AND cecd.IsDelete = 0
	LEFT JOIN INDIGO036.Contract.ContractDescriptions cd  ON cecd.ContractDescriptionId = cd.Id
	where ce.Status = 1
)

SELECT	h.EntityName,
		h.EntityId,
		h.CareCenterCode,
		h.FunctionalUnitCode,
		h.AdmissionNumber,
		h.Folio,
		h.PatientCode,
		h.RequestDate, 
		h.ProfessionalCode,
		h.Quantity,
		h.Type,
		h.ItemId,
		h.ItemCode,
		h.ItemCodeOriginal,
		h.ItemName,
		h.CUPSEntityContractDescriptionId,
		h.ContractDescriptionId,
		h.DescriptionCodeName,
		h.TraceabilityPaperworkId,
		h.TraceabilityPaperworkEventsId,
		h.Observations,
		h.DiagnosticCode
FROM
(
	-- Ordenes de imagenes ambulatorias
	SELECT	'HCORDIMAG' EntityName, 
			h.AUTO EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECORDMED RequestDate, 
			h.CODPROSAL ProfessionalCode,
			h.CANSERIPS Quantity,
			1 Type,			
			ce.Id ItemId,
			ce.Code ItemCode,
			h.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			h.OBSSERIPS Observations,
			h.CODDIAGNO DiagnosticCode
	FROM temp_HCORDIMAG h 
	join temp_CUPSEntity ce  on ce.Code = h.CODSERIPS and ISNULL(ce.CUPSEntityContractDescriptionId,0) = ISNULL(h.IDDESCRIPCIONRELACIONADA,0)
UNION ALL
	-- Ordenes de laboratorios ambulatorios
	SELECT	'HCORDLABO' EntityName, 
			h.AUTO EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECORDMED RequestDate, 
			h.CODPROSAL ProfessionalCode,
			h.CANSERIPS Quantity,
			1 Type,
			ce.Id ItemId,
			ce.Code ItemCode,
			h.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			h.OBSSERIPS Observations,
			h.CODDIAGNO DiagnosticCode
	FROM temp_HCORDLABO h 
	join temp_CUPSEntity ce  on ce.Code = h.CODSERIPS and ISNULL(ce.CUPSEntityContractDescriptionId,0) = ISNULL(h.IDDESCRIPCIONRELACIONADA,0)
UNION ALL
	-- Ordenes de patologias ambulatorias
	SELECT	'HCORDPATO' EntityName, 
			h.AUTO EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECORDMED RequestDate, 
			h.CODPROSAL ProfessionalCode,
			h.CANSERIPS Quantity,
			1 Type,
			ce.Id ItemId,
			ce.Code ItemCode,
			h.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			h.OBSSERIPS Observations,
			h.CODDIAGNO DiagnosticCode
	FROM temp_HCORDPATO h 
	join temp_CUPSEntity ce  on ce.Code = h.CODSERIPS and ISNULL(ce.CUPSEntityContractDescriptionId,0) = ISNULL(h.IDDESCRIPCIONRELACIONADA,0)
UNION ALL
	-- Ordenes de interconsultas ambulatorias
	SELECT	'HCORDINTE' EntityName, 
			h.AUTO EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECORDMED RequestDate, 
			h.CODPROSAL ProfessionalCode,
			h.CANSERIPS Quantity,
			1 Type,
			ce.Id ItemId,
			ce.Code ItemCode,
			h.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			h.OBSSERIPS Observations,
			h.CODDIAGNO DiagnosticCode
	FROM temp_HCORDINTE h 
	join temp_CUPSEntity ce  on ce.Code = h.CODSERIPS and ISNULL(ce.CUPSEntityContractDescriptionId,0) = ISNULL(h.IDDESCRIPCIONRELACIONADA,0)
UNION ALL
	-- Ordenes de procedimientos no Qx ambulatorias
	SELECT	'HCORDPRON' EntityName, 
			h.AUTO EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECORDMED RequestDate, 
			h.CODPROSAL ProfessionalCode,
			h.CANSERIPS Quantity,
			1 Type,
			ce.Id ItemId,
			ce.Code ItemCode,
			h.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			h.OBSSERIPS Observations,
			h.CODDIAGNO DiagnosticCode
	FROM temp_HCORDPRON h 
	join temp_CUPSEntity ce  on ce.Code = h.CODSERIPS and ISNULL(ce.CUPSEntityContractDescriptionId,0) = ISNULL(h.IDDESCRIPCIONRELACIONADA,0)
UNION ALL
	-- Ordenes de procedimientos Qx ambulatorias
	SELECT	'HCORDPROQ' EntityName, 
			h.AUTO EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECORDMED RequestDate, 
			h.CODPROSAL ProfessionalCode,
			h.CANSERIPS Quantity,
			1 Type,
			ce.Id ItemId,
			ce.Code ItemCode,
			h.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			h.OBSSERIPS Observations,
			h.CODDIAGNO DiagnosticCode
	FROM temp_HCORDPROQ h 
	join temp_CUPSEntity ce  on ce.Code = h.CODSERIPS and ISNULL(ce.CUPSEntityContractDescriptionId,0) = ISNULL(h.IDDESCRIPCIONRELACIONADA,0)
UNION ALL
	-- Hemocomponentes
	SELECT 'HCORHEMCO' EntityName, 
			h.ID EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECORDMED RequestDate, 
			'' ProfessionalCode,
			hd.Quantity Quantity,
			1 Type,
			ce.Id ItemId,
			ce.Code ItemCode,
			hd.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			hd.TraceabilityPaperworkId,
			hd.TraceabilityPaperworkEventsId,
			'' Observations,
			h.CODDIAGNO DiagnosticCode
	FROM temp_HCORHEMCO h  
	JOIN 
	(
		SELECT	hd.HCORHEMCOID, 
				hd.CODSERIPS, 
				hd.TraceabilityPaperworkId, 
				hd.TraceabilityPaperworkEventsId, 
				hd.IDDESCRIPCIONRELACIONADA,
				COUNT(1) Quantity
		FROM INDIGO036.dbo.HCORHEMSER hd 
		GROUP BY hd.HCORHEMCOID, hd.CODSERIPS, hd.TraceabilityPaperworkId, hd.TraceabilityPaperworkEventsId, hd.IDDESCRIPCIONRELACIONADA
	) hd ON h.ID = hd.HCORHEMCOID
	join temp_CUPSEntity ce  on ce.Code = hd.CODSERIPS and ce.CUPSEntityContractDescriptionId = hd.IDDESCRIPCIONRELACIONADA
UNION ALL
	-- Ordenes de control por la especialidad que atendió al paciente
	SELECT	'HCDESCOEX' EntityName, 
			h.AUTO EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			hc.FECHISPAC RequestDate, 
			hc.CODPROSAL ProfessionalCode,
			1 Quantity,
			1 Type,			
			ce.Id ItemId,
			ce.Code ItemCode,
			h.CODSERIPS ItemCodeOriginal,
			ce.Description ItemName,
			ce.CUPSEntityContractDescriptionId,
			ce.ContractDescriptionId,
			CONCAT(ce.ContractDescriptionCode, ' - ', ce.ContractDescriptionName) DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			hc.INDICAMED Observations,
			hc.CODDIAGNO DiagnosticCode
	FROM temp_HCHISPACA hc 
	JOIN INDIGO036.dbo.HCDESCOEX h  ON hc.NUMINGRES = h.NUMINGRES AND hc.NUMEFOLIO = h.NUMEFOLIO
	join temp_CUPSEntity ce  on ce.Code = h.CODSERIPS and ISNULL(ce.CUPSEntityContractDescriptionId,0) = ISNULL(h.IDDESCRIPCIONRELACIONADA,0)
UNION ALL
	-- Medicamentos extramurales que no sean de quimio
	SELECT	'HCPRESCRA' EntityName, 
			h.ID EntityId,		
			h.CODCENATE CareCenterCode, 
			h.UFUCODIGO FunctionalUnitCode,
			h.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			h.IPCODPACI PatientCode,
			h.FECINIDOS RequestDate, 
			h.CODPROSAL ProfessionalCode,
			h.CANPEDPRO Quantity,
			2 Type,
			ip.Id ItemId,
			ip.Code ItemCode,
			h.CODPRODUC ItemCodeOriginal,
			ip.Name ItemName,
			NULL CUPSEntityContractDescriptionId,
			NULL ContractDescriptionId,
			NULL DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			'' Observations,
			pres.CODDIAGNO DiagnosticCode
	FROM temp_HCPRESCRD h 
	join 
	(
		SELECT a.NUMINGRES, a.NUMEFOLIO, a.CODPRODUC, MIN(a.CODDIAGNO) CODDIAGNO
		FROM INDIGO036.dbo.HCPRESCRA a 
		GROUP BY a.NUMINGRES, a.NUMEFOLIO, a.CODPRODUC
	) pres on pres.NUMINGRES = h.NUMINGRES and pres.NUMEFOLIO = h.NUMEFOLIO and pres.CODPRODUC = h.CODPRODUC
	JOIN INDIGO036.Inventory.ATC atc  ON h.CODPRODUC = atc.Code
	JOIN INDIGO036.Inventory.InventoryProduct ip  ON atc.Id = ip.ATCId
UNION ALL
	-- Medicamentos extramurales que si esten en quimio
	SELECT	'HCORMEDICAMESQUEMA' EntityName, 
			h.ID EntityId,		
			his.CODCENATE CareCenterCode, 
			o.UFUCODIGO FunctionalUnitCode,
			his.NUMINGRES AdmissionNumber,
			h.NUMEFOLIO Folio,
			o.IPCODPACI PatientCode,
			his.FECHISPAC RequestDate, 
			o.CODPROSAL ProfessionalCode,
			temp.Quantity Quantity,
			2 Type,
			ip.Id ItemId,
			ip.Code ItemCode,
			h.CODPRODUC ItemCodeOriginal,
			ip.Name ItemName,
			NULL CUPSEntityContractDescriptionId,
			NULL ContractDescriptionId,
			NULL DescriptionCodeName,
			h.TraceabilityPaperworkId,
			h.TraceabilityPaperworkEventsId,
			'' Observations,
			o.CODDIAGNO DiagnosticCode
	FROM INDIGO036.EHR.HCORMEDICAMESQUEMA h 
	inner join INDIGO036.EHR.HCORDQUIMIO o  on o.ID = h.IDHCORDQUIMIO
	inner join temp_HCHISPACA his  on his.IPCODPACI = o.IPCODPACI and his.NUMEFOLIO = h.NUMEFOLIO
	JOIN INDIGO036.Inventory.ATC atc  ON h.CODPRODUC = atc.Code
	JOIN INDIGO036.Inventory.InventoryProduct ip  ON atc.Id = ip.ATCId
    inner join (
        select hes.IDHCORDQUIMIO, hes.CICLO, hes.CODPRODUC, SUM(hes.CANTIDAD) Quantity
        from INDIGO036.EHR.HCORDMEDICAM hes 
        group by hes.IDHCORDQUIMIO, hes.CICLO, hes.CODPRODUC
    ) temp on h.IDHCORDQUIMIO = temp.IDHCORDQUIMIO and h.CICLO = temp.CICLO and h.CODPRODUC = temp.CODPRODUC
	LEFT JOIN INDIGO036.[Authorization].TraceabilityPaperwork tp  ON h.TraceabilityPaperworkId = tp.Id
UNION ALL
	-- Solicitudes Manuales
	SELECT	'TraceabilityPaperwork' EntityName, 
			h.Id EntityId,		
			h.CareCenterCode, 
			h.FunctionalUnitCode,
			h.AdmissionNumber,
			h.Folio,
			h.PatientCode,
			h.RequestDate, 
			h.ProfessionalCode,
			h.RequestQuantity Quantity,
			h.Type,
			ISNULL(ip.Id, ce.Id) ItemId,
			ISNULL(ip.Code, ce.Code) ItemCode,
			ISNULL(ip.Code, ce.Code) ItemCodeOriginal,
			ISNULL(ip.Name, ce.Description) ItemName,
			cecd.Id CUPSEntityContractDescriptionId,
			cd.Id ContractDescriptionId,
			CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
			h.Id TraceabilityPaperworkId,
			tpem.Id TraceabilityPaperworkEventsId,
			'' Observations,
			'' DiagnosticCode
	FROM INDIGO036.[Authorization].TraceabilityPaperwork h 
	LEFT JOIN INDIGO036.Inventory.InventoryProduct ip  ON h.Type = 2 AND h.ServiceCode = ip.Code
	LEFT JOIN INDIGO036.Contract.CUPSEntity ce  ON h.Type = 1 AND h.ServiceCode = ce.Code	
	LEFT JOIN INDIGO036.Contract.ContractDescriptions cd  ON h.ContractDescriptionId = cd.Id
	LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd  ON ce.Id = cecd.CUPSEntityId AND h.ContractDescriptionId = cecd.ContractDescriptionId
	LEFT JOIN
	(
		SELECT tpe.TraceabilityPaperworkId, MAX(tpe.Id) Id
		FROM INDIGO036.[Authorization].TraceabilityPaperworkEvents tpe 
		GROUP BY tpe.TraceabilityPaperworkId
	) tpem ON h.Id = tpem.TraceabilityPaperworkId
	WHERE (ISNULL(h.EntityName, '') = '' AND ISNULL(h.EntityId, 0) = 0) or h.EntityName = 'TraceabilityPaperwork'
) h