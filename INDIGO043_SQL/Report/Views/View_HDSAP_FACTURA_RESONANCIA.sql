-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURA_RESONANCIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_FACTURA_RESONANCIA]
AS



 SELECT 

   DISTINCT
   I.PatientCode AS IDENTIFICACION,
   RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
   I.AdmissionNumber AS INGRESO,
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS FECHAFACTURA,
   CAST(I.TotalInvoice AS NUMERIC(20,2)) AS [TOTAL FACTURA],
   ISNULL(CUPS.Code,IPR.Code) AS [CUPS/PRODUCTO],
   ISNULL(CUPS.Description,IPR.Description ) AS DESCRIPCION, 
   IPR1.Code AS PRODUCTO,
   IPR1.NAME AS NOMBREPRODUCTO,
   PHD.SalePrice PRECIOPRODUCTO,
   PHD.Quantity CANTIDADDISPENSADA,
   phd.ReturnedQuantity CANTIDADDEVUELTA,
   TP.Name AS ENTIDAD,
   ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity) 'CANTIDAD',
   CAST(ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice) AS NUMERIC(20,2)) 'VALOR SERVICIO'
   --CAST(ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice) AS NUMERIC(20,2)) 'VALOR UNITARIO',
   --CAST(ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) AS NUMERIC(20,2)) 'VALOR TOTAL'
   
FROM Billing.invoice i
  INNER JOIN Billing.InvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId =I.Id 
  INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id =ID.ServiceOrderDetailId
  INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId 
  INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
  INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
  LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
  INNER JOIN Inventory.PharmaceuticalDispensing ph on ph.AdmissionNumber = i.AdmissionNumber
  INNER JOIN Inventory.PharmaceuticalDispensingDetail phd on phd.PharmaceuticalDispensingId = ph.id
  LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = SOD.ProductId
  LEFT JOIN Inventory.InventoryProduct AS IPR1 WITH (NOLOCK) ON IPR1.Id = PHD.ProductId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS WITH (NOLOCK) ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
  WHERE 
    CUPS.Code IN ('883101','883102','883103','883105','883106','883107','883108','883109','883110',
                '883111','883210','883211','883220','883221','883230','883231','883232','883233',
                '883234','883235','883301','883341','883351','883401','883430','883434','883435',
                '883436','883440','883441','883442','883443','883511','883512','883521','883522',
                '883560','883904','883905','883908','883909') AND IPR1.code in ('M-00957',
'20030187-03',
'DM-00089',
'DM-00537',
'DM-00538',
'19932754-02',
'20021045-08') 

