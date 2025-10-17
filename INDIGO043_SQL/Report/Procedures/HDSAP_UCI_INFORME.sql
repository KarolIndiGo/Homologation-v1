-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HDSAP_UCI_INFORME
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE PROCEDURE [Report].[HDSAP_UCI_INFORME]  
	@FechaIni datetime,
	@FechaFin datetime
AS
SELECT Cedula, Nombre, CodigoServicio, NombreServicio, Regulado,
		Cantidad, Total,  
		CASE WHEN UFcode<>'141' THEN 0 
			WHEN Regulado=1 AND UsuarioCargo IN ('m04','m07','783', '052','059','096','U096') THEN 0
			WHEN CCcode='7003' AND UsuarioCargo IN ('m04','m07','783', '052','059','096','U096') THEN Total * 0.83		--FARMACIA
			WHEN CCcode='7003' AND UsuarioCargo NOT IN ('m04','m07','783', '052','059','096','U096') THEN 0				--FARMACIA
			WHEN UFcode='141' AND CCcode='7002' THEN Total * 0.83			--TERAPIAS
			WHEN CCcode='4007' AND CodigoServicio='890606' THEN Total * 0.83			--4007 - UCI AND 890606 NUTRICION, 04/12/2020
			WHEN CodigoServicio LIKE '890%' THEN 0							--INTERCONSULTAS
			WHEN CCcode='4007' THEN Total * 0.83								--4007 - UCI - UNIDAD DE CUIDADOS INTENSIVOS ADULTOS, SE EXCLUYÓ PREVIAMENTE INTERCONSULTAS
			WHEN UFcode='141' AND CCcode='6001' AND CodigoServicio IN ('903604','903111','903859','903864','903813') THEN  Total * 0.83  --ELECTROLITOS QUE VENDE EL HOSPITAL
			WHEN UFcode='141' AND CCcode='6001' AND CodigoServicio NOT IN ('903604','903111','903859','903864','903813') THEN  0  --EXCLUYE ELECTROLITOS QUE VENDE EL HOSPITAL
			WHEN UFcode='141' AND CCcode='7001' AND CodigoServicio IN ('911102','911103','911111','911116') THEN  Total * 0.83		--BANCO DE SANGRE
			WHEN UFcode='141' AND CCcode='7001' AND CodigoServicio NOT IN ('911102','911103','911111','911116') THEN  0				--BANCO DE SANGRE
			WHEN UFcode='141' AND CCcode NOT IN ('4007','6001','7001', '7002', '7003') THEN 0		--CC: UCI, LABORATORIO, BANCO DE SANGRE, TERAPIAS, FARMACIA
			END AS [83%_UCI], 
		CASE WHEN UFcode<>'141' THEN 0 
			WHEN Regulado=1 AND UsuarioCargo IN ('m04','m07','783', '052','059','096','U096') THEN 0
			WHEN CCcode='7003' AND UsuarioCargo IN ('m04','m07','783', '052','059','096','U096') THEN Total * 0.17		--FARMACIA
			WHEN CCcode='7003' AND UsuarioCargo NOT IN ('m04','m07','783', '052','059','096','U096') THEN 0				--FARMACIA
			WHEN UFcode='141' AND CCcode='7002' THEN Total * 0.17			--TERAPIAS
			WHEN CCcode='4007' AND CodigoServicio='890606' THEN Total * 0.17			--4007 - UCI AND 890606 NUTRICION, 04/12/2020
			WHEN CodigoServicio LIKE '890%' THEN 0							--INTERCONSULTAS
			WHEN CCcode='4007' THEN Total * 0.17								--4007 - UCI - UNIDAD DE CUIDADOS INTENSIVOS ADULTOS, SE EXCLUYÓ PREVIAMENTE INTERCONSULTAS
			WHEN UFcode='141' AND CCcode='6001' AND CodigoServicio IN ('903604','903111','903859','903864','903813') THEN  Total * 0.17 --ELECTROLITOS QUE VENDE EL HOSPITAL
			WHEN UFcode='141' AND CCcode='6001' AND CodigoServicio NOT IN ('903604','903111','903859','903864','903813') THEN  0  --EXCLUYE ELECTROLITOS QUE VENDE EL HOSPITAL
			WHEN UFcode='141' AND CCcode='7001' AND CodigoServicio IN ('911102','911103','911111','911116') THEN  Total * 0.17		--BANCO DE SANGRE
			WHEN UFcode='141' AND CCcode='7001' AND CodigoServicio NOT IN ('911102','911103','911111','911116') THEN  0				--BANCO DE SANGRE
			WHEN UFcode='141' AND CCcode NOT IN ('4007','6001','7001', '7002', '7003') THEN 0		--CC: UCI, LABORATORIO, BANCO DE SANGRE, TERAPIAS, FARMACIA
			END AS [17%_HSP], 
		CASE WHEN Regulado=1 AND UsuarioCargo IN ('m04','m07','783', '052','059','096','U096') THEN Total ELSE 0 END AS [100%_UCI], 
		CASE WHEN UFcode<>'141' THEN Total 
			WHEN Regulado=1 AND UsuarioCargo NOT IN ('m04','m07','783', '052','059','096','U096') THEN Total 
			WHEN CCcode='7003' AND UsuarioCargo NOT IN ('m04','m07','783', '052','059','096','U096') THEN Total
			WHEN CodigoServicio LIKE '890%'AND CodigoServicio<>'890606' THEN Total							--INTERCONSULTAS, MODIFICADO 04/12/2020
			WHEN UFcode='141' AND CCcode='6001' AND CodigoServicio NOT IN ('903604','903111','903859','903864','903813') THEN  Total  --EXCLUYE ELECTROLITOS QUE VENDE EL HOSPITAL
			WHEN UFcode='141' AND CCcode='7001' AND CodigoServicio NOT IN ('911102','911103','911111','911116') THEN  Total				--BANCO DE SANGRE
			WHEN UFcode='141' AND CCcode NOT IN ('4007','6001','7001', '7002', '7003') THEN Total		--CC: UCI, LABORATORIO, BANCO DE SANGRE, TERAPIAS, FARMACIA
			ELSE 0 END AS [100%_HSP], 
		UsuarioCargo, Ingreso, UnidadesFuncionales, CentroCosto, 
		CASE WHEN UFcode<>'141' THEN CCname + ' HSP' 
			WHEN Regulado=1 AND UsuarioCargo IN ('m04','m07','783', '052','059','096','U096') THEN 'MEDICAMENTOS REGULADOS UCI'
			WHEN UsuarioCargo IN ('m04','m07','783', '052','059','096','U096') THEN CCname + ' UCI'
			WHEN Regulado=1 AND UsuarioCargo NOT IN ('m04','m07','783', '052','059','096','U096') THEN 'MEDICAMENTOS REGULADOS HSP' 
			WHEN UFcode='141' AND CCcode NOT IN ('4007','7002','6001') THEN CCname + ' HSP'
			WHEN CCcode='4007' AND CodigoServicio='890606' THEN 'NUTRICION UCI'			--4007 - UCI AND 890606 NUTRICION, 04/12/2020
			WHEN CodigoServicio LIKE '890%' THEN 'INTERCONSULTAS HSP'							--INTERCONSULTAS, 04/12/2020
			ELSE NULL END AS Servicios,
		Categoria, Factura, FechaFactura
		, GrupoFacturacion
		, Facturador
		, CASE EntityType WHEN 1 THEN 'EPS Contributivo' WHEN 2 THEN 'EPS Subsidiado' WHEN 3 THEN 'ET Vinculados Municipios'
			WHEN 4 THEN 'ET Vinculados Departamentos' WHEN 5 THEN 'ARL Riesgos Laborales' WHEN 6 THEN 'MP Medicina Prepagada'
			WHEN 7 THEN 'IPS Privada' WHEN 8 THEN 'IPS Publica' WHEN 9 THEN 'Regimen Especial' WHEN 10 THEN 'Accidentes de transito'
			WHEN 11 THEN 'Fosyga' WHEN 12 THEN 'Otros' END AS TipoEntidad
		, EAPB
		, TerceroEntidad		--04/12/2020
		--1 - EPS Contributivo 2 - EPS Subsidiado 3 - ET Vinculados Municipios 4 - ET Vinculados Departamentos 
		--5 - ARL Riesgos Laborales 6 - MP Medicina Prepagada 7 - IPS Privada 8 - IPS Publica 9 - Regimen Especial 
		--10 - Accidentes de transito 11 - Fosyga 12 - Otros
FROM (SELECT ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, 
		CAST(DATEDIFF(dd, CAST(pa.IPFECNACI AS date), sod.ServiceDate) / 365.25 AS int) AS Edad, pa.IPDIRECCI AS Direccion, 
		innm.MUNNOMBRE AS Municipio, ad.NUMINGRES AS Ingreso, ce.Code AS CodigoServicio, ce.Description AS NombreServicio, 
		CAST(sod.ServiceDate AS date) AS FechaServicio, sod.InvoicedQuantity AS Cantidad, sod.SubTotalSalesPrice AS ValorUnitario, 
		id.GrandTotalDiscount AS Descuento, id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, 
		cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, 
		fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, 
		cc.Code + ' - ' + cc.Name AS CentroCosto, 
		i.InvoiceNumber AS Factura, 
		i.InvoicedUser AS UsuarioFacturacion, per.Fullname AS NombreFacturacion, so.CreationUser AS UsuarioCargo, 
		per2.Fullname AS NombreCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, ha.Code AS CodigoEntidad, 
		ad.IAUTORIZA AS AuthorizationNumber, INPF.NOMMEDICO AS Nommedico, ines.DESESPECI AS Especialidad, CAST(0 AS BIT) AS Regulado,
		fu.Code UFcode, fu.Name UFname, cc.Code CCcode, cc.Name CCname
		, BG.Name GrupoFacturacion															--30/04/2020
		, per.Fullname Facturador		--03/09/2020
		, ha.EntityType		--03/09/2020
		, ha.Name EAPB		--05/10/2020
	FROM Billing.Invoice AS i INNER JOIN
		Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
        Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
        dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
        dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI LEFT OUTER JOIN
        dbo.INUBICACI AS inn ON inn.AUUBICACI = pa.AUUBICACI LEFT OUTER JOIN
        dbo.INMUNICIP AS innm ON innm.DEPMUNCOD = inn.DEPMUNCOD LEFT OUTER JOIN
        Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
        Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
        Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
        Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId INNER JOIN
		Billing.BillingGroup AS BG ON ce.BillingGroupId=BG.Id INNER JOIN					--30/04/2020
        Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
        Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
        Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
        Security.Person AS per ON per.Id = u.IdPerson LEFT OUTER JOIN
        Security.[User] AS ua ON ua.UserCode = so.CreationUser LEFT OUTER JOIN
        Security.Person AS per2 ON per2.Id = ua.IdPerson LEFT OUTER JOIN
        Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
        Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId LEFT OUTER JOIN
        dbo.INPROFSAL AS INPF ON INPF.CODPROSAL = sod.PerformsHealthProfessionalCode LEFT OUTER JOIN
        dbo.INESPECIA AS ines ON ines.CODESPECI = sod.PerformsProfessionalSpecialty
    WHERE        (i.Status = 1)
		AND i.InvoiceCategoryId IN (SELECT ic.Id
									FROM Billing.InvoiceCategories AS ic
									WHERE ic.Name LIKE '%UCI%')
		AND i.InvoiceDate >= @FechaIni AND i.InvoiceDate < DATEADD(DAY, 1 ,@FechaFin)
    UNION ALL
    SELECT        ad.IPCODPACI AS Cedula, pa.IPNOMCOMP AS Nombre, CAST(DATEDIFF(dd, CAST(pa.IPFECNACI AS date), sod.ServiceDate) / 365.25 AS int) AS Edad, pa.IPDIRECCI AS Direccion, 
        innm.MUNNOMBRE AS Municipio, ad.NUMINGRES AS Ingreso, p.Code AS CodigoServicio, p.Name AS NombreServicio, CAST(sod.ServiceDate AS date) AS FechaServicio, 
        sod.InvoicedQuantity AS Cantidad, sod.SubTotalSalesPrice AS ValorUnitario, id.GrandTotalDiscount AS Descuento, 
		id.GrandTotalSalesPrice AS Total, ic.Code + ' - ' + ic.Name AS Categoria, 
        cg.Code + ' - ' + cg.Name AS GrupoAtencion, ha.Code + ' - ' + cg.Name AS EntidadAdministradora, t.Nit + ' - ' + t.Name AS TerceroEntidad, 
		fu.Code + ' - ' + fu.Name AS UnidadesFuncionales, 
        cc.Code + ' - ' + cc.Name AS CentroCosto, i.InvoiceNumber AS Factura, i.InvoicedUser AS UsuarioFacturacion, per.Fullname AS NombreFacturacion, so.CreationUser AS UsuarioCargo, 
        per2.Fullname AS NombreCargo, i.InvoiceDate AS FechaFactura, ad.IINGREPOR AS IngresaPor, ha.Code AS CodigoEntidad, ad.IAUTORIZA AS AuthorizationNumber, INPF.NOMMEDICO AS Nommedico, 
        ines.DESESPECI AS Especialidad
		, p.ProductWithPriceControl  AS Regulado,
		fu.Code UFcode, fu.Name UFname, cc.Code CCcode, cc.Name CCname
		, BG.Name GrupoFacturacion															--30/04/2020
		, per.Fullname Facturador		--03/09/2020
		, ha.EntityType		--03/09/2020
		, ha.Name EAPB		--05/10/2020
    FROM            Billing.Invoice AS i INNER JOIN
        Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId INNER JOIN
        Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
        dbo.ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
        dbo.INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI LEFT OUTER JOIN
        dbo.INUBICACI AS inn ON inn.AUUBICACI = pa.AUUBICACI LEFT OUTER JOIN
        dbo.INMUNICIP AS innm ON innm.DEPMUNCOD = inn.DEPMUNCOD LEFT OUTER JOIN
        Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
        Billing.ServiceOrder AS so ON so.Id = sod.ServiceOrderId INNER JOIN
        Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
        Inventory.InventoryProduct AS p ON p.Id = sod.ProductId INNER JOIN
		Billing.BillingGroup AS BG ON P.BillingGroupId=BG.Id INNER JOIN					--30/04/2020
        Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
        Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
        Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
        Security.Person AS per ON per.Id = u.IdPerson LEFT OUTER JOIN
        Security.[User] AS ua ON ua.UserCode = so.CreationUser LEFT OUTER JOIN
        Security.Person AS per2 ON per2.Id = ua.IdPerson LEFT OUTER JOIN
        Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId LEFT OUTER JOIN
        Common.ThirdParty AS t ON t.Id = ha.ThirdPartyId LEFT OUTER JOIN
        dbo.INPROFSAL AS INPF ON INPF.CODPROSAL = sod.PerformsHealthProfessionalCode LEFT OUTER JOIN
        dbo.INESPECIA AS ines ON ines.CODESPECI = sod.PerformsProfessionalSpecialty
    WHERE        (i.Status = 1)
		AND i.InvoiceCategoryId IN (SELECT ic.Id
									FROM Billing.InvoiceCategories AS ic
									WHERE ic.Name LIKE '%UCI%')
		AND i.InvoiceDate >= @FechaIni AND i.InvoiceDate < DATEADD(DAY, 1 ,@FechaFin)) AS datos

ORDER BY Ingreso
			

