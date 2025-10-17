-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_FACT_FacturacionMiomed
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_FACT_FacturacionMiomed]
AS
     SELECT F.InvoiceDate AS FechaFactura, 
            GA.Code AS codigo, 
            GA.Name AS Grupo_Atencion, 
            F.InvoiceNumber AS Factura, 
            P.IPNOMCOMP AS Paciente, 
            O.PatientCode AS Identificacion, 
            O.AdmissionNumber AS N_Ingreso, 
            S.Code AS CUPS, 
            S.RIPSDescription AS Servicio, 
            SUM(DO.InvoicedQuantity) AS Cant,
            CASE
                WHEN DF.TotalSalesPrice = 0
                THEN DF.TotalSalesPrice
                WHEN DF.TotalSalesPrice > 0
                THEN SUM(DO.InvoicedQuantity) * (DF.TotalSalesPrice)
            END AS ValorIPS,
            CASE
                WHEN DF.TotalSalesPrice = 0
                THEN 'Aplicado'
                WHEN DF.TotalSalesPrice > 0
                THEN 'Facturado'
            END AS EstadoServicio, 
            CU.Name AS CuentaContable
     FROM Billing.InvoiceDetail AS DF
          INNER JOIN Billing.ServiceOrderDetail AS DO ON DF.ServiceOrderDetailId = DO.Id
          INNER JOIN Billing.ServiceOrder AS O ON DO.ServiceOrderId = O.Id
                                                                    AND O.STATUS <> 3
          INNER JOIN Contract.CUPSEntity AS S ON DO.CUPSEntityId = S.Id
          INNER JOIN Billing.Invoice AS F ON DF.InvoiceId = F.Id
                                                               AND F.STATUS = 1
                                                               AND CONVERT(NVARCHAR(10), F.InvoiceDate, 20) > CONVERT(NVARCHAR(10), GETDATE() - 150, 20)
          INNER JOIN dbo.INPACIENT AS P ON O.PatientCode = P.IPCODPACI
          INNER JOIN Contract.CareGroup AS G ON DO.CareGroupId = G.Id
          INNER JOIN Billing.BillingConcept AS CF ON S.BillingConceptId = CF.Id
          INNER JOIN GeneralLedger.MainAccounts AS CU ON CF.EntityIncomeAccountId = CU.Id
          INNER JOIN Contract.CareGroup AS GA ON GA.Id = DO.CareGroupId
     WHERE(CU.Name LIKE '%laboratorio%')
          AND (F.InvoiceDate BETWEEN '2019-09-01' AND '2019-12-31')
     GROUP BY F.InvoiceDate, 
              GA.Name, 
              GA.Code, 
              F.InvoiceNumber, 
              P.IPNOMCOMP, 
              O.PatientCode, 
              O.AdmissionNumber, 
              S.Code, 
              S.RIPSDescription, 
              DF.TotalSalesPrice, 
              DF.GrandTotalSalesPrice, 
              G.Name, 
              G.Id, 
              CU.Name;
