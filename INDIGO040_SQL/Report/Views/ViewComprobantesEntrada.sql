-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewComprobantesEntrada
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[ViewComprobantesEntrada] AS

WITH
CTE_DETAIL_EntranceVoucher AS
(
	SELECT
	EntranceVoucherId,
	SUM(EVD.Quantity) AS CANTIDAD,
	TIP.Name as TIPO,
	SUM(EVD.TotalValue) AS TOTAL
	FROM 
	Inventory.EntranceVoucherDetail EVD INNER JOIN 
	Inventory.InventoryProduct AS PRO ON EVD.ProductId=PRO.Id INNER JOIN
	Inventory.ProductType TIP ON PRO.ProductTypeId=TIP.Id
	GROUP BY EntranceVoucherId,TIP.Name
)

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
YEAR(CAST(EV.DocumentDate AS DATE)) * 100 + MONTH(CAST(EV.DocumentDate AS DATE)) [ID_TIEMPO],
EV.Code AS [CODIGO COMPROBANTE DE ENTRADA], 
EV.DocumentDate AS [FECHA COMPROBANTE DE ENTRADA], 
TER.Nit AS [NIT TERCERO],
PR.Name AS PROVEEDOR, 
EV.InvoiceNumber AS [# FACTURA], 
EV.Description AS DESCRIPCION, 
FORMAT(EVD.TOTAL,'##########')TOTAL, 
CASE EV.status WHEN 1 THEN 'Registrado' 
				WHEN 2 THEN 'Confirmado' 
				WHEN 3 THEN 'Anulado' END AS ESTADO,
UPPER(EVD.TIPO) TIPO,
EVD.CANTIDAD,
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM     
Inventory.EntranceVoucher AS EV INNER JOIN
CTE_DETAIL_EntranceVoucher EVD ON EV.Id=EVD.EntranceVoucherId INNER JOIN
Common.Supplier AS PR ON PR.Id = EV.SupplierId INNER JOIN
Common.ThirdParty AS TER ON PR.IdThirdParty=TER.Id 
