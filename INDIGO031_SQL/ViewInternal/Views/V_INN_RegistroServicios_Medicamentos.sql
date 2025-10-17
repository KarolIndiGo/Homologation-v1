-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_RegistroServicios_Medicamentos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_RegistroServicios_Medicamentos]
AS
SELECT ING.IFECHAING AS Fecha_Ingreso, 
	ING.NUMINGRES AS Ingreso,
	CASE ING.IESTADOIN
		WHEN '' THEN 'Abierto'
		WHEN 'F' THEN 'Facturado'
		WHEN 'P' THEN 'Parcial'
	END AS EstadoIng, 
	ING.CODUSUCRE AS Usuario_Crea, 
	us.NOMUSUARI AS [Usuario Ingreso], 
	CA.NOMCENATE AS [Centro Atencion],
	CASE P.IPTIPODOC
		WHEN 1 THEN 'CC'
		WHEN 2 THEN 'CE'
		WHEN 3 THEN 'TI'
		WHEN 4 THEN 'RC'
		WHEN 5 THEN 'PA'
		WHEN 6 THEN 'AS'
		WHEN 7 THEN 'MS'
		WHEN 8 THEN 'NU'
	END AS TipoDoc, 
	ING.IPCODPACI AS Identificacion, 
	P.IPNOMCOMP AS Paciente, 
	F.InvoiceDate AS FechaFactura, 
	F.InvoiceNumber AS RegistroServicio, 
	F.TotalInvoice AS TotalFactura, 
	MED.Code AS MED, 
	MED.Description AS Servicio, 
	U.UFUDESCRI AS Unidad, 
	SOD.InvoicedQuantity AS Cant_OS, 
	FD.InvoicedQuantity AS CantFact, 
	FD.TotalSalesPrice AS VlrUnitario, 
	FD.InvoicedQuantity * FD.TotalSalesPrice AS Total, 
	FD.GrandTotalSalesPrice AS VlrServicio, 
	CONVERT(MONEY, med.ProductCost, 101) AS CostoPromedio, 
	FD.InvoicedQuantity * med.ProductCost AS VlrCosto, 
	F.InvoicedUser AS Facturador, 
	GA.Code + ' - ' + GA.Name AS Grupo_Atencion, 
	CU.Number AS Cuenta, 
	CU.Name AS CuentaContable,
	CASE ING.TIPOINGRE
		WHEN 1 THEN 'Ambulatorio'
		WHEN 2 THEN 'Hospitalario'
	END AS TipoIngreso,
	MONTH(F.InvoiceDate) AS MesFactura, 
    YEAR(F.InvoiceDate) AS AñoFactura 
FROM dbo.ADINGRESO AS ING
	INNER JOIN Billing.ServiceOrder AS SO ON SO.AdmissionNumber = ING.NUMINGRES AND ING.IESTADOIN <> 'A'
	INNER JOIN Billing.ServiceOrderDetail AS SOD ON SOD.ServiceOrderId = SO.Id
	LEFT OUTER JOIN Billing.InvoiceDetail AS FD ON FD.ServiceOrderDetailId = SOD.Id
	LEFT OUTER JOIN Billing.Invoice AS F ON FD.InvoiceId = F.Id AND F.STATUS = 1
	INNER JOIN Inventory.InventoryProduct AS MED ON MED.Id = SOD.ProductId
	JOIN Contract.CareGroup AS GA ON GA.Id = F.CareGroupId AND GA.Name LIKE '%MEDICAMENTOS%'
	INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = ING.CODCENATE
	INNER JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = ING.UFUCODIGO
	INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = ING.IPCODPACI
	INNER JOIN dbo.SEGusuaru AS us ON ING.CODUSUCRE = us.CODUSUARI
	INNER JOIN Inventory.ProductGroup AS GR ON MED.ProductGroupId = GR.Id
	LEFT OUTER JOIN GeneralLedger.MainAccounts AS CU ON GR.IncomeAccountId = CU.Id
WHERE YEAR(F.InvoiceDate) = '2021'
