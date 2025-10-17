-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Treasury_CuotasModeradoras
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_Treasury_CuotasModeradoras] as
SELECT  
CASE IPP.IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' 
			 when 9 then  'CN' 
			 when 10 then 'CD' 
			 when 11 then 'SC' 
			 when 12 then 'PE'  
			 when 13 then 'PT' 
			 when 14 then 'DE'  
			 when 15 then 'SI' 
			 END AS TipoIdentificacion,
ing.IPCODPACI as Documento, IPP.IPNOMCOMP as Nombre, TP.Name as Entidad, ing.IFECHAING as FechaIngreso, rcd.ValueFeeModerator as [Valor Cuota Moderadora], 
rec.ReciboCaja, rec.ValorRecibo, rec.Detalle, rec.Fecha, 
i.InvoiceNumber AS Factura, i.InvoiceDate AS [Fecha Factura] --SE AGREGA CAMPOS Factura, [Fecha Factura], CASO 223624
FROM   Billing.RevenueControlDetail AS RCD
INNER JOIN Billing.RevenueControl AS RC ON RC.Id=RCD.RevenueControlId
INNER JOIN dbo.ADINGRESO AS ing ON ing.NUMINGRES=rc.AdmissionNumber
INNER JOIN Contract.HealthAdministrator AS HA ON HA.ID=ING.GENCONENTITY
INNER JOIN Common.ThirdParty AS TP ON TP.ID=HA.ThirdPartyId
INNER JOIN DBO.INPACIENT AS IPP ON IPP.IPCODPACI=ING.IPCODPACI
left JOIN Billing.Invoice AS i ON i.RevenueControlDetailId=rcd.Id
left join (SELECT cr.code as ReciboCaja, cr.Detail as Detalle, cr.DocumentDate as Fecha, cr.Value as ValorRecibo, t.Nit
FROM Treasury.CashReceiptDetails as r 
inner join Common.ThirdParty as t on t.id=r.IdThirdParty
inner join Treasury.CashReceipts as cr on cr.id=r.IdCashReceipt
where r.IdCashReceiptConcept=34 ) as rec on rec.Nit=ing.IPCODPACI
where rcd.ValueFeeModerator>0
--and ing.IPCODPACI= '20367819'



