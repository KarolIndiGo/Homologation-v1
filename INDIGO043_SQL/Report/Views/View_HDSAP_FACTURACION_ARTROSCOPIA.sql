-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURACION_ARTROSCOPIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_FACTURACION_ARTROSCOPIA]
AS


SELECT
    i.InvoiceDate FechaFactura ,i.PatientCode DocumentoPaciente,i.AdmissionNumber Ingreso,i.InvoiceNumber Factura, ce.Code AS CUPSCode, SUBSTRING(CE.Description, 1, 94) AS CUPSName, 
    SOD.TotalSalesPrice AS TotalFactura, IPSS.Code AS CodigoIps, SUBSTRING(IPSS.Name, 1, 100) AS ServicioIps, 
    SODS.InvoicedQuantity AS Cantidad, SODS.TotalSalesPrice AS TotalProcedimiento,  CASE WHEN IPSS.Code = '39113' THEN 
    (SOD.TotalSalesPrice - SODS.TotalSalesPrice) 
    ELSE 
        '0'
    END AS Diferencia, QX.NUMEFOLIO NUMEROFOLIOHISTORIA, QX.FECHORFIN FECHAREALIZACIONPROCEDIMIENTO
FROM Billing.InvoiceDetail AS ID WITH (NOLOCK) 
INNER JOIN Billing.Invoice AS I WITH (NOLOCK) ON ID.InvoiceId = I.Id 
INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id = ID.ServiceOrderDetailId 
INNER JOIN BILLING.ServiceOrderDetailDistribution AS SODD WITH (NOLOCK) ON SOD.ID = SODD.ServiceOrderDetailId And SODD.RevenueControlDetailId = I.RevenueControlDetailId 
INNER JOIN HCQXINFOR QX WITH(NOLOCK) ON QX.NUMINGRES = I.AdmissionNumber AND QX.IPCODPACI = I.PatientCode
INNER JOIN Contract.CUPSEntity AS CE WITH (NOLOCK) ON CE.Id = SOD.CUPSEntityId 
INNER JOIN Billing.BillingGroup AS BG WITH (NOLOCK) ON BG.Id = IIF(ISNULL(SOD.ApplyRIAS, 0) = 1, ISNULL(CE.RIASBillingGroupId, CE.BillingGroupId), CE.BillingGroupId) 
INNER JOIN Contract.IPSService AS IPS WITH (NOLOCK) ON SOD.IPSServiceId = IPS.Id 
LEFT OUTER JOIN ADINGRESO AS INGRES WITH (NOLOCK) ON INGRES.NUMINGRES = I.AdmissionNumber 
LEFT OUTER JOIN Billing.ServiceOrderDetailSurgical AS SODS WITH (NOLOCK) ON SODS.ServiceOrderDetailId = SOD.Id AND SODS.TotalSalesPrice > 0 AND SODS.OnlyMedicalFees = 0 
LEFT OUTER JOIN Contract.IPSService AS IPSS WITH (NOLOCK) ON SODS.IPSServiceId = IPSS.Id
WHERE sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 and sod.IsDelete = 0 AND I.[Status] = 1 AND bg.Id in ('3','6','8','7') 

UNION ALL
SELECT
     i.InvoiceDate FechaFactura ,i.PatientCode DocumentoPaciente,i.AdmissionNumber Ingreso,i.InvoiceNumber Factura, IP.Code AS CUPSCode, SUBSTRING(IP.Name, 1, 94) AS CUPSName, SOD.TotalSalesPrice AS TotalFactura, 
     IP.Code, IP.Name, SOD.InvoicedQuantity AS Cantidad, 
    SOD.TotalSalesPrice AS TotalProcedimiento, CASE WHEN IP.Code = '39113' THEN 
        (SOD.TotalSalesPrice - SOD.TotalSalesPrice)
    ELSE 
        '0'
    END AS Diferencia, QX.NUMEFOLIO NUMEROFOLIOHISTORIA, QX.FECHORFIN FECHAREALIZACIONPROCEDIMIENTO
FROM Billing.InvoiceDetail AS ID WITH (NOLOCK) 
INNER JOIN Billing.Invoice AS I WITH (NOLOCK) ON ID.InvoiceId = I.Id 
INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id = ID.ServiceOrderDetailId 
INNER JOIN Billing.ServiceOrderDetailDistribution AS SODD WITH (NOLOCK) ON SOD.ID = SODD.ServiceOrderDetailId And SODD.RevenueControlDetailId = I.RevenueControlDetailId 
INNER JOIN HCQXINFOR QX WITH(NOLOCK) ON QX.NUMINGRES = I.AdmissionNumber AND QX.IPCODPACI = I.PatientCode
INNER JOIN Inventory.InventoryProduct AS Ip WITH (NOLOCK) ON Ip.Id = SOD.ProductId 
INNER JOIN Billing.BillingGroup AS BG WITH (NOLOCK) ON BG.Id = IP.BillingGroupId 
LEFT OUTER JOIN ADINGRESO AS INGRES WITH (NOLOCK) ON INGRES.NUMINGRES = I.AdmissionNumber 
WHERE SOD.SettlementType != 3 AND SODD.GrandTotalSalesPrice > 0 and sod.IsDelete = 0 AND I.[Status] = 1 AND  bg.Id in ('3','6','8','7') 

