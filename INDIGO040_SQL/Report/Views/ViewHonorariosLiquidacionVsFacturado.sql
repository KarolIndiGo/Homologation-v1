-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewHonorariosLiquidacionVsFacturado
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[ViewHonorariosLiquidacionVsFacturado] AS

SELECT  
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 L.Code AS Codigo_Liquidacion, C.Id AS IDCausacion, 
 LD.Id AS IDLiquidacion, LD.MedicalFeesCausationId, 
 E.Name AS Entidad_Administradora, 
 E1.Name AS Tercero, F.InvoiceNumber AS Factura, 
 F.InvoiceDate AS Fecha_Factura, F.AdmissionNumber AS Ingreso,
 P.IPCODPACI AS Identificacion_Usuario, P.IPNOMCOMP AS Nombre_Usuario,
 CU.Code AS CUPS, CU.Description AS Descripcion_CUPS, 
 S.Code AS CodigoServicio, S.Name AS NombreServicio, 
 FD.InvoicedQuantity AS Cantidad_Cobrada, 
 FD.GrandTotalSalesPrice AS Valor_Facturado_Entidad,
 C.TotalAmountPayable AS Valor_Pagar_Tercero, 
 T.Name AS Tercero_Causa, 
 CASE C.Status WHEN '1' THEN 'Causado' WHEN '2' THEN 'Liquidado' WHEN '3' THEN 'Confirmado' WHEN '4' THEN 'Anulado' END AS Estado_Causacion, 
 CASE L.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado_Liquidacion, 
 L.ConfirmationDate AS Fecha_Confirmacion_Liquidacion, '' /*PER.Fullname*/ AS Facturador, 
 D.CODICIE10 AS Diadnostico_CIE10, D.NOMDIAGNO AS Diagnostico_Egreso, CC.Name AS CentroCosto,
 1 as 'CANTIDAD',
CAST(F.InvoiceDate AS date) AS 'FECHA BUSQUEDA',
YEAR(F.InvoiceDate) AS 'AÑO FECHA BUSQUEDA',
MONTH(F.InvoiceDate) AS 'MES AÑO FECHA BUSQUEDA',
CASE MONTH(F.InvoiceDate) 
	WHEN 1 THEN 'ENERO'
	WHEN 2 THEN 'FEBRERO'
	WHEN 3 THEN 'MARZO'
	WHEN 4 THEN 'ABRIL'
	WHEN 5 THEN 'MAYO'
	WHEN 6 THEN 'JUNIO'
	WHEN 7 THEN 'JULIO'
	WHEN 8 THEN 'AGOSTO'
	WHEN 9 THEN 'SEPTIEMBRE'
	WHEN 10 THEN 'OCTUBRE'
	WHEN 11 THEN 'NOVIEMBRE'
	WHEN 12 THEN 'DICIEMBRE'
  END AS 'MES NOMBRE FECHA BUSQUEDA', 
FORMAT(DAY(F.InvoiceDate), '00') AS 'DIA FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM           
 Billing.InvoiceDetail AS FD 
 INNER JOIN Billing.Invoice AS F WITH (nolock) ON F.Id = FD.InvoiceId 
 LEFT OUTER JOIN MedicalFees.MedicalFeesCausation AS C WITH (nolock) ON C.InvoiceDetailId = FD.Id 
 LEFT OUTER JOIN MedicalFees.MedicalFeesLiquidationDetail AS LD WITH (nolock) ON LD.MedicalFeesCausationId = C.Id 
 LEFT OUTER JOIN Common.ThirdParty AS T WITH (nolock) ON T.Id = C.ThirdPartyId 
 LEFT OUTER JOIN Billing.ServiceOrderDetail AS OD WITH (nolock) ON OD.Id = FD.ServiceOrderDetailId 
 LEFT OUTER JOIN Contract.CUPSEntity AS CU WITH (nolock) ON CU.Id = OD.CUPSEntityId 
 LEFT OUTER JOIN MedicalFees.MedicalFeesLiquidation AS L WITH (nolock) ON L.Id = LD.MedicalFeesLiquidacionId 
 LEFT OUTER JOIN Contract.HealthAdministrator AS E WITH (nolock) ON E.Id = F.HealthAdministratorId
 LEFT OUTER JOIN Common.ThirdParty AS E1 WITH (nolock) ON E1.Id = F.ThirdPartyId 
 --LEFT OUTER JOIN [Security].[User] AS U WITH (nolock) ON U.UserCode = F.InvoicedUser 
 --LEFT OUTER JOIN [Security].[Person] AS PER WITH (nolock) ON PER.Id = U.IdPerson 
 LEFT OUTER JOIN Contract.IPSService AS S WITH (nolock) ON S.Id = OD.IPSServiceId 
 LEFT OUTER JOIN dbo.INPACIENT AS P WITH (nolock) ON P.IPCODPACI = F.PatientCode 
 LEFT OUTER JOIN dbo.INDIAGNOS AS D WITH (nolock) ON D.CODICIE10 = F.OutputDiagnosis 
 LEFT OUTER JOIN Payroll.CostCenter AS CC WITH (nolock) ON CC.Id = OD.CostCenterId
WHERE       
 /*(F.InvoiceDate > '31-10-2018 23:59:59') AND*/ (OD.CUPSEntityId IS NOT NULL)

