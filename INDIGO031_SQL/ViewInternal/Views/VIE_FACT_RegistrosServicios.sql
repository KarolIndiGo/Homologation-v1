-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_FACT_RegistrosServicios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_FACT_RegistrosServicios]
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
     FROM Billing.Invoice AS F
          INNER JOIN Billing.InvoiceDetail AS FD ON F.Id = FD.InvoiceId
                                                                      AND F.STATUS = 1
                                                                      AND F.DocumentType = 5
          INNER JOIN Billing.ServiceOrderDetail AS SOD ON FD.ServiceOrderDetailId = SOD.Id
          INNER JOIN Billing.ServiceOrder AS SO ON SOD.ServiceOrderId = SO.Id
          INNER JOIN Contract.CUPSEntity AS CUPS ON CUPS.Id = SOD.CUPSEntityId
          INNER JOIN dbo.ADINGRESO AS ING ON ING.NUMINGRES = F.AdmissionNumber
          INNER JOIN Contract.CareGroup AS GA ON GA.Id = ING.GENCAREGROUP
          INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = ING.CODCENATE
          INNER JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = ING.UFUCODIGO
          INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = ING.IPCODPACI
          INNER JOIN dbo.SEGusuaru AS us ON ING.CODUSUCRE = us.CODUSUARI
          INNER JOIN Billing.BillingConcept AS CF ON CUPS.BillingConceptId = CF.Id
          INNER JOIN GeneralLedger.MainAccounts AS CU ON CF.EntityIncomeAccountId = CU.Id;
