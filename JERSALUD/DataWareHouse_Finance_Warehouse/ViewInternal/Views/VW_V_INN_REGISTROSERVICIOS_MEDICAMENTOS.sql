-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_REGISTROSERVICIOS_MEDICAMENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_REGISTROSERVICIOS_MEDICAMENTOS AS

SELECT 
    ING.IFECHAING AS Fecha_Ingreso, 
    ING.NUMINGRES AS Ingreso,
    CASE ING.IESTADOIN
        WHEN '' THEN 'Abierto'
        WHEN 'F' THEN 'Facturado'
        WHEN 'P' THEN 'Parcial'
    END AS EstadoIng, 
    ING.CODUSUCRE AS Usuario_Crea, 
    us.NOMUSUARI AS [Usuario Ingreso], 
    CA.NOMCENATE AS [Centro Atencion],
    CASE P.IPTIPODOC
        WHEN 1 THEN 'CC'
        WHEN 2 THEN 'CE'
        WHEN 3 THEN 'TI'
        WHEN 4 THEN 'RC'
        WHEN 5 THEN 'PA'
        WHEN 6 THEN 'AS'
        WHEN 7 THEN 'MS'
        WHEN 8 THEN 'NU'
    END AS TipoDoc, 
    ING.IPCODPACI AS Identificacion, 
    P.IPNOMCOMP AS Paciente, 
    F.InvoiceDate AS FechaFactura, 
    F.InvoiceNumber AS RegistroServicio, 
    F.TotalInvoice AS TotalFactura, 
    MED.Code AS MED, 
    MED.Description AS Servicio, 
    U.UFUDESCRI AS Unidad, 
    SOD.InvoicedQuantity AS Cant_OS, 
    FD.InvoicedQuantity AS CantFact, 
    FD.TotalSalesPrice AS VlrUnitario, 
    FD.InvoicedQuantity * FD.TotalSalesPrice AS Total, 
    FD.GrandTotalSalesPrice AS VlrServicio, 
    CAST(MED.ProductCost AS DECIMAL(18,2)) AS CostoPromedio, 
    FD.InvoicedQuantity * MED.ProductCost AS VlrCosto, 
    F.InvoicedUser AS Facturador, 
    GA.Code + ' - ' + GA.Name AS Grupo_Atencion, 
    CU.Number AS Cuenta, 
    CU.Name AS CuentaContable,
    CASE ING.TIPOINGRE
        WHEN 1 THEN 'Ambulatorio'
        WHEN 2 THEN 'Hospitalario'
    END AS TipoIngreso,
    MONTH(F.InvoiceDate) AS MesFactura, 
    YEAR(F.InvoiceDate) AS AñoFactura 
FROM INDIGO031.dbo.ADINGRESO AS ING
    INNER JOIN INDIGO031.Billing.ServiceOrder AS SO ON SO.AdmissionNumber = ING.NUMINGRES AND ING.IESTADOIN <> 'A'
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD ON SOD.ServiceOrderId = SO.Id
    LEFT OUTER JOIN INDIGO031.Billing.InvoiceDetail AS FD ON FD.ServiceOrderDetailId = SOD.Id
    LEFT OUTER JOIN INDIGO031.Billing.Invoice AS F ON FD.InvoiceId = F.Id AND F.Status = 1
    INNER JOIN INDIGO031.Inventory.InventoryProduct AS MED ON MED.Id = SOD.ProductId
    JOIN INDIGO031.Contract.CareGroup AS GA ON GA.Id = F.CareGroupId AND GA.Name LIKE '%MEDICAMENTOS%'
    INNER JOIN INDIGO031.dbo.ADCENATEN AS CA ON CA.CODCENATE = ING.CODCENATE
    INNER JOIN INDIGO031.dbo.INUNIFUNC AS U ON U.UFUCODIGO = ING.UFUCODIGO
    INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = ING.IPCODPACI
    INNER JOIN INDIGO031.dbo.SEGusuaru AS us ON ING.CODUSUCRE = us.CODUSUARI
    INNER JOIN INDIGO031.Inventory.ProductGroup AS GR ON MED.ProductGroupId = GR.Id
    LEFT OUTER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU ON GR.IncomeAccountId = CU.Id
WHERE YEAR(F.InvoiceDate) = '2021'