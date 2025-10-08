-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_BILLING_AD_PENDIENTE_FACTURAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_Billing_AD_Pendiente_facturar
AS

SELECT 
    [INDIGO035].[Billing].[RevenueControlDetail].CareGroupId,
    [INDIGO035].[Billing].[RevenueControlDetail].Id,
    CASE 
        WHEN ing.CODCENATE IN ('001', '00101', '00102', '00103') THEN 'Neiva'
        WHEN ing.CODCENATE = '00104' THEN 'Abner'
    END AS Sede,
    ing.IESTADOIN AS EstadoIngreso,
    so.AdmissionNumber AS Ingreso,
    ing.IFECHAING AS FechaIngreso,
    [INDIGO035].[Billing].[RevenueControl].PatientCode AS Identificación,
    p.IPNOMCOMP AS Paciente,
    --t .Name AS Entidad,
    [INDIGO035].[Billing].[RevenueControlDetail].FolioOrder AS [Folios a facturar], 
    CASE [INDIGO035].[Billing].[RevenueControlDetail].FolioType 
        WHEN '1' THEN 'EAPB con contrato'
        WHEN '2' THEN 'EAPB sin contrato'
        WHEN '3' THEN 'Particulares'
        WHEN '4' THEN 'Aseguradoras'
    END AS Tipo, 
    CASE [INDIGO035].[Billing].[RevenueControlDetail].LiquidationType 
        WHEN '1' THEN 'Pago por servicios'
        WHEN '2' THEN 'Capitacion'
        WHEN '3' THEN 'Factura Global'
        WHEN '4' THEN 'Capitacion Global'
    END AS [Tipo de liquidacion],
    ea.HealthEntityCode AS [Entidad Administradora],
    CASE 
        WHEN t.PersonType = '1' THEN '999' 
        ELSE t.Nit 
    END AS [Nit Entidad], 
    CASE 
        WHEN t.PersonType = '1' THEN 'PACIENTES PARTICULARES' 
        ELSE t.Name 
    END AS Entidad,
    ga.Code AS [Grupo Atención],
    ga.Name AS [Descripción Grupo Atención], 
    [INDIGO035].[Billing].[RevenueControlDetail].TotalFolio AS [Vr total folio pendiente facturar],
    dq.InvoicedQuantity AS [Cantidad QX],
    dq.TotalSalesPrice AS [Total Facturado QX], 
    dq.PerformsHealthProfessionalCode AS [Cód Profesional QX],
    RTRIM(medqx.CODPROSAL) + ' - ' + LTRIM(medqx.NOMMEDICO) AS [Profesional QX], 
    CASE [INDIGO035].[Billing].[RevenueControlDetail].ResponsibleRecoveryFee 
        WHEN '1' THEN 'Ninguno' 
        WHEN '2' THEN 'Paciente' 
        WHEN '3' THEN 'Tercero' 
    END AS [Responsable cuota recuperación], 
    [INDIGO035].[Billing].[RevenueControlDetail].TotalPatientWithDiscount AS [Vr cobrado a Paciente],
    [INDIGO035].[Billing].[RevenueControlDetail].ValueCopay AS [Vr cuota recuperación folio], 
    [INDIGO035].[Billing].[RevenueControlDetail].ValueFeeModerator AS [Vr cuota moderadora folio],
    [INDIGO035].[Billing].[RevenueControlDetail].Observation AS [Observaciones],
    cat.Name AS [Categoría para RIPS], 
    CASE [INDIGO035].[Billing].[RevenueControlDetail].Status 
        WHEN '1' THEN 'Registrado' 
        WHEN '2' THEN 'Facturado' 
        WHEN '3' THEN 'Bloqueado' 
    END AS Estado,
    per.Fullname AS [Usuario Crea], 
    [INDIGO035].[Billing].[RevenueControlDetail].CreationDate AS [Fecha creación],
    PERM.Fullname AS [Usuario modifica], 
    [INDIGO035].[Billing].[RevenueControlDetail].ModificationDate AS [Fecha modificación], 
    CASE [INDIGO035].[Billing].[ServiceOrderDetail].ServiceType 
        WHEN '1' THEN 'SOAT' 
        WHEN '2' THEN 'ISS' 
        WHEN '3' THEN 'CUPS' 
    END AS [Tipo Servicio], 
    CASE [INDIGO035].[Billing].[ServiceOrderDetail].RecordType 
        WHEN '1' THEN 'Servicios' 
        WHEN '2' THEN 'Medicamentos' 
    END AS [Servicios/Medicamentos], 
    cups.Code AS [Código CUPS], 
    cups.Description AS [Descripción CUPS], 
    ServiciosIPS.Code AS [Código Servicio], 
    ServiciosIPS.Name AS [Descripción Servicio], 
    [INDIGO035].[Billing].[ServiceOrderDetail].Packaging AS [Servicio incluido en Paquete], 
    CASE [INDIGO035].[Billing].[ServiceOrderDetail].Presentation 
        WHEN '1' THEN 'No Quirúrgico' 
        WHEN '2' THEN 'Quirúrgico' 
        WHEN '3' THEN 'Paquete' 
    END AS [Presentación Servicio], 
    pr.Code AS [Cód Producto], 
    pr.Name AS [Descripción Producto], 
    [INDIGO035].[Billing].[ServiceOrderDetail].SupplyQuantity AS [Cantidad entregada], 
    [INDIGO035].[Billing].[ServiceOrderDetail].DevolutionQuantity AS [Cantidad devuelta], 
    [INDIGO035].[Billing].[ServiceOrderDetail].InvoicedQuantity AS [Cantidad a facturar], 
    [INDIGO035].[Billing].[ServiceOrderDetail].RateManualSalePrice AS [Valor unitario  a facturar],
    ([INDIGO035].[Billing].[ServiceOrderDetail].InvoicedQuantity * [INDIGO035].[Billing].[ServiceOrderDetail].RateManualSalePrice) AS [Total a facturar], 
    [INDIGO035].[Billing].[RevenueControlDetail].TotalPatientSalesPrice AS [Total Cuota Recuperación], 
    [INDIGO035].[Billing].[ServiceOrderDetail].ServiceDate AS [Fecha Servicio],  
    [INDIGO035].[Billing].[ServiceOrderDetail].AuthorizationNumber AS [Autorización], 
    UF.Code AS [Unidad Funcional], 
    UF.Name AS [Descripción Unidad Funcional], 
    salida.FECALTPAC AS [Fecha Alta médica], 
    GETDATE() AS [TimeStamp], --[INDIGO035].[Billing].[RevenueControlDetail].TimeStamp--
    ing.UFUEGRMED AS UnidadEgreso,
    ServiciosIPSQ.Score AS UVR, 
    ServiciosIPSQ.NewScore AS [UVR > 450], 
    sg.Name AS [Grupo Quirurgico],
    CASE ga.EntityType 
        WHEN '1' THEN 'EPS Contributivo' 
        WHEN '2' THEN 'EPS Subsidiado' 
        WHEN '3' THEN 'ET Vinculados Municipios' 
        WHEN '4' THEN 'ET Vinculados Departamentos' 
        WHEN '5' THEN 'ARL' 
        WHEN '6' THEN 'Prepagada' 
        WHEN '7' THEN 'IPS' 
        WHEN '8' THEN 'IPS' 
        WHEN '9' THEN 'Regimen Especial' 
        WHEN '10' THEN 'Accidentes Transito'
        WHEN '11' THEN 'Fosyga' 
        WHEN '12' THEN 'Otros' 
        WHEN '13' THEN 'Aseguradoras' 
        WHEN '99' THEN 'Particulares' 
    END AS Regimen,
    CONCAT(NE.Code, ' - ', NE.Name) AS [Finalidad Consulta/Procedimiento],
    CASE
        WHEN NE.Code IN ('11','12','13','15','16','17','18','19','20','22','23','24','25','27','43','44') THEN 'AC y AP'
        WHEN NE.Code IN ('14','26','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42') THEN 'AP'
        WHEN NE.Code IN ('21') THEN 'AC'
        ELSE '' 
    END AS [Finalidad Aplica Para]

FROM [INDIGO035].[Billing].[RevenueControlDetail]
    INNER JOIN [INDIGO035].[Billing].[ServiceOrderDetailDistribution] 
        ON [INDIGO035].[Billing].[RevenueControlDetail].Id = [INDIGO035].[Billing].[ServiceOrderDetailDistribution].RevenueControlDetailId 
        AND [INDIGO035].[Billing].[RevenueControlDetail].Status IN ('1', '3')
    INNER JOIN [INDIGO035].[Billing].[ServiceOrderDetail] 
        ON [INDIGO035].[Billing].[ServiceOrderDetailDistribution].ServiceOrderDetailId = [INDIGO035].[Billing].[ServiceOrderDetail].Id
    INNER JOIN [INDIGO035].[Billing].[RevenueControl] 
        ON [INDIGO035].[Billing].[RevenueControlDetail].RevenueControlId = [INDIGO035].[Billing].[RevenueControl].Id
    LEFT OUTER JOIN [INDIGO035].[dbo].[INPACIENT] AS p 
        ON p.IPCODPACI = [INDIGO035].[Billing].[RevenueControl].PatientCode
    LEFT OUTER JOIN [INDIGO035].[Contract].[ContractEntity] AS e 
        ON e.Id = [INDIGO035].[Billing].[RevenueControlDetail].ContractEntityId
    LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS ga 
        ON ga.Id = [INDIGO035].[Billing].[RevenueControlDetail].CareGroupId
    LEFT OUTER JOIN [INDIGO035].[Billing].[InvoiceCategories] AS cat 
        ON cat.Id = [INDIGO035].[Billing].[RevenueControlDetail].InvoiceCategoryId
    LEFT OUTER JOIN [INDIGO035].[Security].[UserInt] AS u 
        ON u.UserCode = [INDIGO035].[Billing].[RevenueControlDetail].CreationUser
    LEFT OUTER JOIN [INDIGO035].[Security].[PersonInt] AS per 
        ON per.Id = u.IdPerson
    LEFT OUTER JOIN [INDIGO035].[Security].[UserInt] AS um 
        ON um.UserCode = [INDIGO035].[Billing].[RevenueControlDetail].ModificationUser
    LEFT OUTER JOIN [INDIGO035].[Security].[PersonInt] AS PERM 
        ON PERM.Id = um.IdPerson
    LEFT OUTER JOIN [INDIGO035].[Contract].[CUPSEntity] AS cups 
        ON cups.Id = [INDIGO035].[Billing].[ServiceOrderDetail].CUPSEntityId
    LEFT OUTER JOIN [INDIGO035].[Contract].[IPSService] AS ServiciosIPS 
        ON ServiciosIPS.Id = [INDIGO035].[Billing].[ServiceOrderDetail].IPSServiceId
    LEFT OUTER JOIN [INDIGO035].[Inventory].[InventoryProduct] AS pr 
        ON pr.Id = [INDIGO035].[Billing].[ServiceOrderDetail].ProductId
    LEFT OUTER JOIN [INDIGO035].[Payroll].[FunctionalUnit] AS UF 
        ON UF.Id = [INDIGO035].[Billing].[ServiceOrderDetail].PerformsFunctionalUnitId
    LEFT OUTER JOIN [INDIGO035].[dbo].[HCREGEGRE] AS salida 
        ON salida.NUMINGRES = [INDIGO035].[Billing].[RevenueControl].AdmissionNumber
    LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ea 
        ON ea.Id = [INDIGO035].[Billing].[RevenueControlDetail].HealthAdministratorId
    LEFT OUTER JOIN [INDIGO035].[Common].[ThirdParty] AS t 
        ON t.Id = [INDIGO035].[Billing].[ServiceOrderDetail].ThirdPartyId
    LEFT OUTER JOIN [INDIGO035].[dbo].[ADINGRESO] AS ing 
        ON ing.NUMINGRES = [INDIGO035].[Billing].[RevenueControl].AdmissionNumber
    LEFT OUTER JOIN [INDIGO035].[Billing].[ServiceOrderDetailSurgical] AS dq 
        ON dq.ServiceOrderDetailId = [INDIGO035].[Billing].[ServiceOrderDetail].Id
    LEFT OUTER JOIN [INDIGO035].[Contract].[IPSService] AS ServiciosIPSQ 
        ON ServiciosIPSQ.Id = dq.IPSServiceId
    LEFT OUTER JOIN [INDIGO035].[dbo].[INPROFSAL] AS medqx 
        ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
    LEFT OUTER JOIN [INDIGO035].[Billing].[ServiceOrder] AS so  
        ON so.Id = [INDIGO035].[Billing].[ServiceOrderDetail].ServiceOrderId
    LEFT JOIN [INDIGO035].[Contract].[SurgicalGroup] AS sg 
        ON sg.Id = ServiciosIPSQ.SurgicalGroupId
    LEFT JOIN [INDIGO035].[Admissions].[HealthPurposes] AS NE 
        ON NE.Id = ing.IdHealthPurposes

WHERE 
    [INDIGO035].[Billing].[RevenueControlDetail].Status IN ('1', '3') 
    AND [INDIGO035].[Billing].[ServiceOrderDetail].IsDelete = '0' 
    AND ing.IESTADOIN <> 'A' 
    AND ing.IESTADOIN <> 'F' 
    AND ing.IESTADOIN <> 'C'  
    AND [INDIGO035].[Billing].[RevenueControl].PatientCode <> '0123456789';