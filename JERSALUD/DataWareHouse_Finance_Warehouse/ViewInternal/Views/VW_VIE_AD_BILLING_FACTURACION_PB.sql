-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_BILLING_FACTURACION_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_BILLING_FACTURACION_PB AS
SELECT 
    uo.UnitName AS Sede, 
    F.InvoiceNumber AS [Nro Registro], 
    F.AdmissionNumber AS Ingreso, 
    F.PatientCode AS Identificación, 
    ga.Name AS [Grupo de Atención], 
    F.TotalInvoice AS [Total Registro], 
    F.InvoiceDate AS [Fecha Registro], 
    dos.InvoicedQuantity AS Cantidad,
    CASE
        WHEN dq.TotalSalesPrice IS NULL
        THEN dos.TotalSalesPrice
        ELSE dq.TotalSalesPrice
    END AS ValorUnitario,
    CASE
        WHEN dq.TotalSalesPrice IS NULL
        THEN DF.GrandTotalSalesPrice
        ELSE dq.TotalSalesPrice
    END AS ValorTotal, 
    t.Nit, 
    ea.Code + ' - ' + ea.Name AS [Entidad Administradora],
    CASE dos.RecordType
        WHEN '1'
        THEN 'Servicios'
        WHEN '2'
        THEN 'Medicamentos'
    END AS [Servicios/Medicamentos],
    CASE
        WHEN pr.Code IS NULL
        THEN ServiciosIPS.Code
        ELSE pr.Code
    END AS Código,
    CASE
        WHEN pr.Name IS NULL
        THEN ServiciosIPS.Name
        ELSE pr.Name
    END AS Descripción,
    UF.Name AS [Descripción Unidad Funcional], 
    CC.Number AS CuentaContable, 
    CC.Name AS NombreCuenta, 
    CCo.Code AS CC, 
    CCo.Name AS CentroCosto, 
    case 
        when ga.Code in ('BOG315','BOG314','BOG313','BOG312','BOG311','BOG310','BOG309','BOG308','BOG307','BOG306','BOG305','BOG304','BOG303') then 'Alto Costo Oncologia' 
        when ga.Code in ('BOG292','BOG120','BOG115') then 'Med Hemofilia y Excl.' 
        when ga.Code in ('BOG207', 'BOG200','BOG199','BOG198','BOG197','BOG196','BOG195','BOG194','BOG193','BOG192','BOG191','BOG190','BOG189','BOG188','BOG187','BOG186') then 'Med Alta Complejidad'
        when ga.Code in ('BOG098','BOG099','BOG100','BOG101','BOG102','BOG103','BOG104','BOG105','BOG106','BOG107','BOG108','BOG109','BOG110','BOG111','BOG129','BOG208') then 'Med Media y Baja Complejidad - Dispositivos' 
    end as 'Tipo Evento',
    PG.Code as CodGrupo, 
    PG.Name AS Grupo, 
    CASE 
        WHEN uo.Id IN (8,9,10,11,12,13,14,15,24) THEN 'BOYACA' 
        WHEN uo.Id  IN (16,17,18,19,20) THEN 'META'  
        WHEN uo.Id  IN (22,27) THEN 'CASANARE' 
    END AS REGIONAL
FROM 
    INDIGO031.Billing.Invoice AS F
    INNER JOIN INDIGO031.Billing.RevenueControlDetail AS Brcd ON F.RevenueControlDetailId = Brcd.Id
    INNER JOIN INDIGO031.Billing.InvoiceDetail AS DF ON DF.InvoiceId = F.Id
    INNER JOIN INDIGO031.dbo.ADINGRESO AS ing 
        LEFT JOIN INDIGO031.dbo.INDIAGNOS AS diag ON diag.CODDIAGNO = ing.CODDIAEGR
        ON ing.NUMINGRES = F.AdmissionNumber
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS dos 
        INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CC ON CC.Id = dos.IncomeMainAccountId
        INNER JOIN INDIGO031.Payroll.CostCenter AS CCo ON dos.CostCenterId = CCo.Id
        LEFT JOIN INDIGO031.Contract.IPSService AS ServiciosIPS ON ServiciosIPS.Id = dos.IPSServiceId
        LEFT JOIN INDIGO031.Inventory.InventoryProduct AS pr ON pr.Id = dos.ProductId
        LEFT JOIN INDIGO031.dbo.INPROFSAL AS med 
            LEFT JOIN INDIGO031.dbo.INESPECIA AS espmed ON espmed.CODESPECI = med.CODESPEC1
            ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
        LEFT JOIN INDIGO031.Billing.ServiceOrderDetailSurgical AS dq 
            LEFT JOIN INDIGO031.Contract.IPSService AS ServiciosIPSQ ON ServiciosIPSQ.Id = dq.IPSServiceId
            ON dq.ServiceOrderDetailId = dos.Id
            AND dq.OnlyMedicalFees = '0'
        LEFT JOIN INDIGO031.Payroll.FunctionalUnit AS UF ON UF.Id = dos.PerformsFunctionalUnitId
        LEFT JOIN INDIGO031.Contract.CUPSEntity AS CUPS 
            LEFT JOIN INDIGO031.Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId
            ON CUPS.Id = dos.CUPSEntityId
        LEFT JOIN INDIGO031.Billing.ServiceOrder AS so ON so.Id = dos.ServiceOrderId
        ON dos.Id = DF.ServiceOrderDetailId
    INNER JOIN INDIGO031.dbo.INPACIENT AS p ON p.IPCODPACI = F.PatientCode
    INNER JOIN INDIGO031.Common.ThirdParty AS t ON t.Id = F.ThirdPartyId
    INNER JOIN INDIGO031.Common.OperatingUnit AS uo ON uo.Id = F.OperatingUnitId
    LEFT JOIN INDIGO031.Contract.CareGroup AS ga ON ga.Id = F.CareGroupId
    LEFT JOIN INDIGO031.Contract.HealthAdministrator AS ea ON ea.Id = F.HealthAdministratorId
    LEFT JOIN INDIGO031.Inventory.ProductGroup AS PG ON PG.Id = pr.ProductGroupId
WHERE
    (F.Status = '1')
    AND (F.RevenueControlDetailId IS NOT NULL)
    AND year(F.InvoiceDate) = '2022'
    AND (dos.IsDelete = '0')
    and  p.IPCODPACI <> '012345678'
    and ga.Code in (
        'BOG315','BOG314','BOG313','BOG312','BOG311','BOG310','BOG309','BOG308','BOG307','BOG306','BOG305','BOG304','BOG303',
        'BOG292','BOG120','BOG115',
        'BOG207', 'BOG200','BOG199','BOG198','BOG197','BOG196','BOG195','BOG194','BOG193','BOG192','BOG191','BOG190','BOG189','BOG188','BOG187','BOG186',
        'BOG098','BOG099','BOG100','BOG101','BOG102','BOG103','BOG104','BOG105','BOG106','BOG107','BOG108','BOG109','BOG110','BOG111','BOG129','BOG208'
    )