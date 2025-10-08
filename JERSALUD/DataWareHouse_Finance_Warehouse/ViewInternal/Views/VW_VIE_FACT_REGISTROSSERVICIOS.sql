-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_FACT_REGISTROSSERVICIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_FACT_REGISTROSSERVICIOS
AS
     SELECT ING.IFECHAING AS Fecha_Ingreso, 
            ING.NUMINGRES AS Ingreso, 
            ING.CODUSUCRE AS Usuario_Crea, 
            us.NOMUSUARI AS Usuario, 
            CA.NOMCENATE AS [Centro Atencion],
            CASE P.IPTIPODOC
                WHEN 1
                THEN 'CC'
                WHEN 2
                THEN 'CE'
                WHEN 3
                THEN 'TI'
                WHEN 4
                THEN 'RC'
                WHEN 5
                THEN 'PA'
                WHEN 6
                THEN 'AS'
                WHEN 7
                THEN 'MS'
                WHEN 8
                THEN 'NU'
            END AS TipoDoc, 
            ING.IPCODPACI AS Identificacion, 
            P.IPNOMCOMP AS Paciente, 
            F.InvoiceDate AS FechaFactura, 
            F.InvoiceNumber AS Factura, 
            F.TotalInvoice AS TotalFactura, 
            CUPS.Code AS CUPS, 
            CUPS.Description AS Servicio, 
            FD.InvoicedQuantity AS Cant, 
            FD.TotalSalesPrice AS VlrUnitario, 
            FD.GrandTotalSalesPrice AS VlrServicio, 
            F.InvoicedUser AS Facturador, 
            GA.Code AS Cod_Grupo_Atencion, 
            GA.Name AS Grupo_Atencion, 
            CU.Number AS Cuenta, 
            CU.Name AS CuentaContable
     FROM INDIGO031.Billing.Invoice AS F
          INNER JOIN INDIGO031.Billing.InvoiceDetail AS FD ON F.Id = FD.InvoiceId
                                                                      AND F.Status = 1
                                                                      AND F.DocumentType = 5
          INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD ON FD.ServiceOrderDetailId = SOD.Id
          INNER JOIN INDIGO031.Billing.ServiceOrder AS SO ON SOD.ServiceOrderId = SO.Id
          INNER JOIN INDIGO031.Contract.CUPSEntity AS CUPS ON CUPS.Id = SOD.CUPSEntityId
          INNER JOIN INDIGO031.dbo.ADINGRESO AS ING ON ING.NUMINGRES = F.AdmissionNumber
          INNER JOIN INDIGO031.Contract.CareGroup AS GA ON GA.Id = ING.GENCAREGROUP
          INNER JOIN INDIGO031.dbo.ADCENATEN AS CA ON CA.CODCENATE = ING.CODCENATE
          INNER JOIN INDIGO031.dbo.INUNIFUNC AS U ON U.UFUCODIGO = ING.UFUCODIGO
          INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = ING.IPCODPACI
          INNER JOIN INDIGO031.dbo.SEGusuaru AS us ON ING.CODUSUCRE = us.CODUSUARI
          INNER JOIN INDIGO031.Billing.BillingConcept AS CF ON CUPS.BillingConceptId = CF.Id
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU ON CF.EntityIncomeAccountId = CU.Id;