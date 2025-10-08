-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_TREASURY_CUOTASMODERADORAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.IMO_Treasury_CuotasModeradoras
AS 

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
ing.IPCODPACI as Documento, IPP.IPNOMCOMP as Nombre, TP.Name as Entidad, ing.IFECHAING as FechaIngreso, RCD.ValueFeeModerator as [Valor Cuota Moderadora], 
rec.ReciboCaja, rec.ValorRecibo, rec.Detalle, rec.Fecha, 
i.InvoiceNumber AS Factura, i.InvoiceDate AS [Fecha Factura] --SE AGREGA CAMPOS Factura, [Fecha Factura], CASO 223624
FROM   [INDIGO035].[Billing].[RevenueControlDetail] AS RCD
INNER JOIN [INDIGO035].[Billing].[RevenueControl] AS RC ON RC.Id=RCD.RevenueControlId
INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS ing ON ing.NUMINGRES=RC.AdmissionNumber
INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id=ing.GENCONENTITY
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS TP ON TP.Id=HA.ThirdPartyId
INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS IPP ON IPP.IPCODPACI=ing.IPCODPACI
left JOIN [INDIGO035].[Billing].[Invoice] AS i ON i.RevenueControlDetailId=RCD.Id
left join (SELECT cr.Code as ReciboCaja, cr.Detail as Detalle, cr.DocumentDate as Fecha, cr.Value as ValorRecibo, t.Nit
FROM [INDIGO035].[Treasury].[CashReceiptDetails] as r 
inner join [INDIGO035].[Common].[ThirdParty] as t on t.Id=r.IdThirdParty
inner join [INDIGO035].[Treasury].[CashReceipts] as cr on cr.Id=r.IdCashReceipt
where r.IdCashReceiptConcept=34 ) as rec on rec.Nit=ing.IPCODPACI
where RCD.ValueFeeModerator>0


