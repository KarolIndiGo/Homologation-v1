-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_FACT_VentasDiarias
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE view [ViewInternal].[MM_FACT_VentasDiarias] as
-------- Examenes Especializados
SELECT   
            'Examenes Especializados' AS Tipo,  CC.Code , CC.Name AS [Centro Costo], tcoco.Code AS [Tipo Comprobante], 
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
			  WHEN cc.Code in ('MMD14','MMD15','MMD16','MMD22','MMD30') THEN 'NEIVA'
				WHEN cc.Code in ('MMD07','MMD08') THEN 'TUNJA'
				WHEN cc.Code = 'MMD100' THEN 'ADMINISTRATIVO'
				WHEN cc.Code = 'MMD02' THEN 'BOGOTA'
				WHEN cc.Code = 'MMD03' THEN 'FACATATIVA'
				WHEN cc.Code = 'MMD05' THEN 'SOGAMOSO'
				WHEN cc.Code = 'MMD06' THEN 'DUITAMA'
				WHEN cc.Code = 'MMD09' THEN 'VILLAVICENCIO'
				WHEN cc.Code = 'MMD10' THEN 'PUERTO LOPEZ'
				WHEN cc.Code = 'MMD11' THEN 'ACACIAS'
				WHEN cc.Code = 'MMD12' THEN 'GRANADA'
				WHEN cc.Code = 'MMD13' THEN 'CHIQUINQUIRA'
				WHEN cc.Code = 'MMD17' THEN 'GARAGOA'
				WHEN cc.Code = 'MMD18' THEN 'GUATEQUE'
				WHEN cc.Code = 'MMD19' THEN 'MONIQUIRA'
				WHEN cc.Code = 'MMD20' THEN 'SOATA'
				WHEN cc.Code = 'MMD21' THEN 'FLORENCIA'
				WHEN cc.Code = 'MMD23' THEN 'MIRAFLORES'
				WHEN cc.Code = 'MMD24' THEN 'YOPAL'
				WHEN cc.Code = 'MMD25' THEN 'SAN MARTIN'
				WHEN cc.Code = 'MMD26' THEN 'PAZ DE ARIPORO'
				WHEN cc.Code = 'MMD27' THEN 'VILLANUEVA'
				WHEN cc.Code = 'MMD28' THEN 'AGUAZUL'
				WHEN cc.Code = 'MMD29' THEN 'PUERTO GAITAN'
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
-- (t .PersonType = '2') 
 (coco.VoucherDate >= '01-01-2022') and (cuenta.Number  in ('41250103','41250121')) --and (month(coco.VoucherDate) >= month(getdate())-2) 
and coco.Status ='2' AND (coco.LegalBookId = '1') AND TCOCO.CODE not in ('0003') --and tcoco.Code<>'21'
group by CC.Code, CC.Name, tcoco.Name, coco.EntityCode , coco.EntityName, cuenta.Number,  coco.VoucherDate , 
tcoco.Code, T.Nit, T.Name, t.PersonType--, tipo.Tipo

union all

SELECT   
            'Ingresos por Servicios' AS Tipo,  CC.Code , CC.Name AS [Centro Costo], tcoco.Code AS [Tipo Comprobante], 
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
			  WHEN cc.Code in ('MMD14','MMD15','MMD16','MMD22','MMD30') THEN 'NEIVA'
				WHEN cc.Code in ('MMD07','MMD08') THEN 'TUNJA'
				WHEN cc.Code = 'MMD100' THEN 'ADMINISTRATIVO'
				WHEN cc.Code = 'MMD02' THEN 'BOGOTA'
				WHEN cc.Code = 'MMD03' THEN 'FACATATIVA'
				WHEN cc.Code = 'MMD05' THEN 'SOGAMOSO'
				WHEN cc.Code = 'MMD06' THEN 'DUITAMA'
				WHEN cc.Code = 'MMD09' THEN 'VILLAVICENCIO'
				WHEN cc.Code = 'MMD10' THEN 'PUERTO LOPEZ'
				WHEN cc.Code = 'MMD11' THEN 'ACACIAS'
				WHEN cc.Code = 'MMD12' THEN 'GRANADA'
				WHEN cc.Code = 'MMD13' THEN 'CHIQUINQUIRA'
				WHEN cc.Code = 'MMD17' THEN 'GARAGOA'
				WHEN cc.Code = 'MMD18' THEN 'GUATEQUE'
				WHEN cc.Code = 'MMD19' THEN 'MONIQUIRA'
				WHEN cc.Code = 'MMD20' THEN 'SOATA'
				WHEN cc.Code = 'MMD21' THEN 'FLORENCIA'
				WHEN cc.Code = 'MMD23' THEN 'MIRAFLORES'
				WHEN cc.Code = 'MMD24' THEN 'YOPAL'
				WHEN cc.Code = 'MMD25' THEN 'SAN MARTIN'
				WHEN cc.Code = 'MMD26' THEN 'PAZ DE ARIPORO'
				WHEN cc.Code = 'MMD27' THEN 'VILLANUEVA'
				WHEN cc.Code = 'MMD28' THEN 'AGUAZUL'
				WHEN cc.Code = 'MMD29' THEN 'PUERTO GAITAN'
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
WHERE   (cuenta.Number in ('41250101', '41250106','41250109','41250112', '41250115', '41250118', '41250125' )) -- AND (t .PersonType = '2') 
and (coco.VoucherDate >= '01-01-2022') --and (month(coco.VoucherDate) >= month(getdate())-2) 
and coco.Status ='2' AND (coco.LegalBookId = '1') AND TCOCO.CODE not in ('0003') --and tcoco.Code<>'21'
group by CC.Code, CC.Name, tcoco.Name, coco.EntityCode , coco.EntityName, cuenta.Number,  coco.VoucherDate , 
tcoco.Code, T.Nit, T.Name , t.PersonType--, tipo.Tipo




