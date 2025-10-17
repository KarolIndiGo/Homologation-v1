-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_FACT_VentasDiarias
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [ViewInternal].[IMO_FACT_VentasDiarias] as
------ Evento--
SELECT   
            'Evento' AS Tipo,  CC.Code , CC.Name AS [Centro Costo], tcoco.Code AS [Tipo Comprobante], 
tcoco.Name AS NombreComprobante, coco.EntityCode AS CodDocumento, 
           CASE coco.EntityName WHEN 'Invoice' THEN 'Factura' WHEN 'LoanMerchandise' THEN 'Mercancia Prestamo' WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmaceutica' WHEN 'TransferOrder' THEN 'Orden Traslado' WHEN 'InventoryAdjustment' THEN 'Ajustes de Inventario' WHEN 'PharmaceuticalDispensingDevolution' THEN
            'Devolución de Dispensación' WHEN 'AccountPayable' THEN 'Cuentas x Pagar' WHEN 'RemissionEntrance' THEN 'Remision Entrada' WHEN 'RemissionReclassification' THEN 'Reclasificación de Remision' ELSE coco.EntityName END AS Documento, 
			 cuenta.Number AS cuenta, 
           coco.VoucherDate AS [Fecha comprobante], MONTH(coco.VoucherDate) AS Mes, 
		   --dcoco.DebitValue AS Débito, dcoco.CreditValue AS Crédito, 
		  CASE when T.PersonType=1 then '999' else T.Nit end as Nit , T.Name AS Tercero,
		   ((SUM(dcoco.DebitValue) - SUM(dcoco.CreditValue))) * - 1 as Valor,  
		   datename(weekday,coco.VoucherDate) as DiaSemana,--, tipo.Tipo as TipoEntidad
		   
              CASE
                    WHEN cc.Name LIKE 'NEV%'
                THEN 'Neiva'
                WHEN cc.Name LIKE 'PIT%'
                THEN 'Pitalito'
                WHEN cc.Name LIKE 'TUN%'
                THEN 'Tunja'
				ELSE 'DESCONOCIDO'
				
            END AS Sede
FROM   GeneralLedger.JournalVouchers AS coco WITH (nolock) INNER JOIN
           GeneralLedger.JournalVoucherDetails AS dcoco WITH (nolock) ON coco.Id = dcoco.IdAccounting INNER JOIN
           GeneralLedger.JournalVoucherTypes AS tcoco WITH (nolock) ON coco.IdJournalVoucher = tcoco.Id INNER JOIN
           GeneralLedger.MainAccounts AS cuenta WITH (nolock) ON cuenta.Id = dcoco.IdMainAccount INNER JOIN
           Common.ThirdParty AS T WITH (nolock) ON T.Id = dcoco.IdThirdParty INNER JOIN      
          Payroll.CostCenter AS cc ON CC.Id = dcoco.IdCostCenter --left outer join 
		  --(SELECT distinct(InvoiceNumber) as invoicenumber, h.Tipo
				--FROM Billing.Invoice as i 
				--inner join ReportesMedi.dbo.VIE_AD_Contract_EntidadesAdministradoras as h on h.id=i.HealthAdministratorId
				--WHERE year(InvoiceDate)>='2020') as tipo on tipo.InvoiceNumber=coco.EntityCode
WHERE  --(cuenta.Number >= '411') --and (cuenta.Number <= '413999999') 
 (t .PersonType = '2') 
and (coco.VoucherDate >= '01-01-2022') and (cuenta.Number  in ('41301101','41301102', '41260706', '41301103', '41303501','41301104','41103704','41350101', '41351010')) --and (month(coco.VoucherDate) >= month(getdate())-2) 
and coco.Status ='2' AND (coco.LegalBookId = '1') --AND TCOCO.CODE not in ('000003','000002') --and tcoco.Code<>'21'
group by CC.Code, CC.Name, tcoco.Name, coco.EntityCode , coco.EntityName, cuenta.Number,  coco.VoucherDate , 
tcoco.Code, T.Nit, T.Name, t.PersonType--, tipo.Tipo

union all

SELECT   
            'PGP' AS Tipo,  CC.Code , CC.Name AS [Centro Costo], tcoco.Code AS [Tipo Comprobante], 
tcoco.Name AS NombreComprobante, coco.EntityCode AS CodDocumento, 
           CASE coco.EntityName WHEN 'Invoice' THEN 'Factura' WHEN 'LoanMerchandise' THEN 'Mercancia Prestamo' WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmaceutica' WHEN 'TransferOrder' THEN 'Orden Traslado' WHEN 'InventoryAdjustment' THEN 'Ajustes de Inventario' WHEN 'PharmaceuticalDispensingDevolution' THEN
            'Devolución de Dispensación' WHEN 'AccountPayable' THEN 'Cuentas x Pagar' WHEN 'RemissionEntrance' THEN 'Remision Entrada' WHEN 'RemissionReclassification' THEN 'Reclasificación de Remision' ELSE coco.EntityName END AS Documento, 
			 cuenta.Number AS cuenta, 
           coco.VoucherDate AS [Fecha comprobante], MONTH(coco.VoucherDate) AS Mes, 
		   --dcoco.DebitValue AS Débito, dcoco.CreditValue AS Crédito, 
		   CASE when T.PersonType=1 then '999' else T.Nit end as Nit , T.Name AS Tercero,
		   ((SUM(dcoco.DebitValue) - SUM(dcoco.CreditValue))) * - 1 as Valor, 
		   datename(weekday,coco.VoucherDate) as DiaSemana,--, tipo.Tipo as TipoEntidad
		    CASE
                    WHEN cc.Name LIKE 'NEV%'
                THEN 'Neiva'
                WHEN cc.Name LIKE 'PIT%'
                THEN 'Pitalito'
                WHEN cc.Name LIKE 'TUN%'
                THEN 'Tunja'
				ELSE 'DESCONOCIDO'
				
            END AS Sede
FROM   GeneralLedger.JournalVouchers AS coco WITH (nolock) INNER JOIN
           GeneralLedger.JournalVoucherDetails AS dcoco WITH (nolock) ON coco.Id = dcoco.IdAccounting INNER JOIN
           GeneralLedger.JournalVoucherTypes AS tcoco WITH (nolock) ON coco.IdJournalVoucher = tcoco.Id INNER JOIN
           GeneralLedger.MainAccounts AS cuenta WITH (nolock) ON cuenta.Id = dcoco.IdMainAccount INNER JOIN
           Common.ThirdParty AS T WITH (nolock) ON T.Id = dcoco.IdThirdParty INNER JOIN      
          Payroll.CostCenter AS cc ON CC.Id = dcoco.IdCostCenter --left outer join 
		  --(SELECT distinct(InvoiceNumber) as invoicenumber, h.Tipo
				--FROM Billing.Invoice as i 
				--inner join ReportesMedi.dbo.VIE_AD_Contract_EntidadesAdministradoras as h on h.id=i.HealthAdministratorId
				--WHERE year(InvoiceDate)>='2020') as tipo on tipo.InvoiceNumber=coco.EntityCode
WHERE   (cuenta.Number in ('41103701'))  AND (t .PersonType = '2') 
and (coco.VoucherDate >= '01-01-2022') --and (month(coco.VoucherDate) >= month(getdate())-2) 
and coco.Status ='2' AND (coco.LegalBookId = '1') --AND TCOCO.CODE not in ('000003','000002') --and tcoco.Code<>'21'
group by CC.Code, CC.Name, tcoco.Name, coco.EntityCode , coco.EntityName, cuenta.Number,  coco.VoucherDate , 
tcoco.Code, T.Nit, T.Name , t.PersonType--, tipo.Tipo


union all

SELECT   
            'Naturales' AS Tipo,  CC.Code , CC.Name AS [Centro Costo], tcoco.Code AS [Tipo Comprobante], 
tcoco.Name AS NombreComprobante, coco.EntityCode AS CodDocumento, 
           CASE coco.EntityName WHEN 'Invoice' THEN 'Factura' WHEN 'LoanMerchandise' THEN 'Mercancia Prestamo' WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmaceutica' WHEN 'TransferOrder' THEN 'Orden Traslado' WHEN 'InventoryAdjustment' THEN 'Ajustes de Inventario' WHEN 'PharmaceuticalDispensingDevolution' THEN
            'Devolución de Dispensación' WHEN 'AccountPayable' THEN 'Cuentas x Pagar' WHEN 'RemissionEntrance' THEN 'Remision Entrada' WHEN 'RemissionReclassification' THEN 'Reclasificación de Remision' ELSE coco.EntityName END AS Documento, 
			 cuenta.Number AS cuenta, 
           coco.VoucherDate AS [Fecha comprobante], MONTH(coco.VoucherDate) AS Mes, 
		   --dcoco.DebitValue AS Débito, dcoco.CreditValue AS Crédito, 
		   CASE when T.PersonType=1 then '999' else T.Nit end as Nit , T.Name AS Tercero,
		   ((SUM(dcoco.DebitValue) - SUM(dcoco.CreditValue))) * - 1 as Valor, 
		   datename(weekday,coco.VoucherDate) as DiaSemana,--, tipo.Tipo as TipoEntidad
		    CASE
                    WHEN cc.Name LIKE 'NEV%'
                THEN 'Neiva'
                WHEN cc.Name LIKE 'PIT%'
                THEN 'Pitalito'
                WHEN cc.Name LIKE 'TUN%'
                THEN 'Tunja'
				ELSE 'DESCONOCIDO'
				
            END AS Sede
FROM   GeneralLedger.JournalVouchers AS coco WITH (nolock) INNER JOIN
           GeneralLedger.JournalVoucherDetails AS dcoco WITH (nolock) ON coco.Id = dcoco.IdAccounting INNER JOIN
           GeneralLedger.JournalVoucherTypes AS tcoco WITH (nolock) ON coco.IdJournalVoucher = tcoco.Id INNER JOIN
           GeneralLedger.MainAccounts AS cuenta WITH (nolock) ON cuenta.Id = dcoco.IdMainAccount INNER JOIN
           Common.ThirdParty AS T WITH (nolock) ON T.Id = dcoco.IdThirdParty INNER JOIN      
          Payroll.CostCenter AS cc ON CC.Id = dcoco.IdCostCenter --left outer join 
		  --(SELECT distinct(InvoiceNumber) as invoicenumber, h.Tipo
				--FROM Billing.Invoice as i 
				--inner join ReportesMedi.dbo.VIE_AD_Contract_EntidadesAdministradoras as h on h.id=i.HealthAdministratorId
				--WHERE year(InvoiceDate)>='2020') as tipo on tipo.InvoiceNumber=coco.EntityCode
WHERE   (cuenta.Number  LIKE '41%')  AND (t.PersonType = '1') 
and (coco.VoucherDate >= '01-01-2022') --and (month(coco.VoucherDate) >= month(getdate())-2) 
--and coco.Status ='2'
AND (coco.LegalBookId = '1') AND TCOCO.CODE not in ('000003','000002') --and tcoco.Code<>'21'
group by CC.Code, CC.Name, tcoco.Name, coco.EntityCode , coco.EntityName, cuenta.Number,  coco.VoucherDate , 
tcoco.Code, T.Nit, T.Name, t.PersonType--, tipo.Tipo


