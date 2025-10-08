-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_BILLING_SERVICIOSFACTURADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_BILLING_SERVICIOSFACTURADOS AS
SELECT  
    ING.IFECHAING AS FECHA_INGRESO, 
    CA.NOMCENATE AS CENTRO_ATENCION, 
    U.UFUDESCRI AS UNIDAD_FUNCIONAL,
    ING.IPCODPACI AS IDENTIFICACION_PACIENTE, 
    P.IPNOMCOMP AS NOMBRE_PACIENTE, 
    CUPS.Code AS CUPS, 
    CUPS.Description AS CUPS_DESCRIPCION, 
    F.InvoiceNumber AS FACTURA,
    CASE F.Status
        WHEN 1 THEN 'Facturado'
        WHEN 2 THEN 'Anulado'
    END AS Estado_Factura, 
    FD.InvoicedQuantity AS CANTIDAD, 
    FD.TotalSalesPrice AS VALOR_UNITARIO, 
    FD.InvoicedQuantity * FD.TotalSalesPrice AS TOTAL,
    F.TotalInvoice AS TOTAL_FACTURA, 
    F.InvoiceDate AS FECHA_CIERRE, 
    F.InvoicedUser AS USUARIOFACT, 
    T.Name AS FUNCIONARIO, 
    CA.NOMCENATE AS Sede, 
    GA.Code AS Cod_Grupo_Atencion, 
    GA.Name AS Grupo_Atencion,
    ESP.DESESPECI AS Especialidad,
    SOD.PerformsHealthProfessionalCode AS CodMedico,
    bg.Name AS GrupoFacturacion
FROM INDIGO031.Billing.Invoice AS F
    INNER JOIN INDIGO031.Billing.InvoiceDetail AS FD ON F.Id = FD.InvoiceId
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD ON FD.ServiceOrderDetailId = SOD.Id
    INNER JOIN INDIGO031.Billing.ServiceOrder AS SO ON SOD.ServiceOrderId = SO.Id
    INNER JOIN INDIGO031.Contract.CUPSEntity AS CUPS ON CUPS.Id = SOD.CUPSEntityId
    INNER JOIN INDIGO031.dbo.ADINGRESO AS ING ON ING.NUMINGRES = SO.AdmissionNumber
    INNER JOIN INDIGO031.Contract.CareGroup AS GA ON GA.Id = SOD.CareGroupId
    INNER JOIN INDIGO031.dbo.ADCENATEN AS CA ON CA.CODCENATE = ING.CODCENATE
    INNER JOIN INDIGO031.dbo.INUNIFUNC AS U ON U.UFUCODIGO = ING.UFUCODIGO
    INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = ING.IPCODPACI
    LEFT JOIN INDIGO031.Common.ThirdParty AS T ON F.InvoicedUser = T.Nit
    LEFT JOIN INDIGO031.dbo.INESPECIA AS ESP ON ESP.CODESPECI = SOD.PerformsProfessionalSpecialty
    LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS bg ON bg.Id = CUPS.BillingGroupId
WHERE F.Status = 1
    AND YEAR(F.InvoiceDate) = 2021
    AND bg.Code IN (19, 20, 28, 11)
    AND CUPS.Code NOT IN ('990202', '990223', '990224', '990221', '990222', '990205', '990207', '990209')