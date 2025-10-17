-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_REPORTE_DEVOLUCIONES_TRAZABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [Report].[VIEW_REPORTE_DEVOLUCIONES_TRAZABILIDAD] AS

WITH CTE_INGRESOS_FACTURAS
AS
  (
    SELECT DD.Id AS [ID DET],DC.RadicatedConsecutive AS [RADICADO DEVOLUCION], DD.InvoiceNumber AS FACTURA, DD.InvoiceDate AS [FECHA FACTURA], DD.BalanceInvoice AS [VALOR FACTURA],
	 DD.RadicatedDate AS [FECHA RADICACION], DC.DocumentDate AS [FECHA RECEPCION DEVOLUCION],DC.RadicatedDate AS [FECHA RADICADO DEVOLUCION],DC.CustomerId 'CLIENTE',DD.RadicatedNumber AS [CONSECUTIVO RADICACION],
	Ingress 'INGRESO'  FROM Glosas.GlosaDevolutionsReceptionD AS DD WITH (nolock) INNER JOIN
                         Glosas.GlosaDevolutionsReceptionC AS DC WITH (nolock) ON DD.GlosaDevolutionsReceptionCId = DC.Id
  ),

CTE_RADICADO
AS
 (
 SELECT DET.InvoiceNumber , MAX(DET.RadicatedNumber) AS RadicatedNumber FROM Portfolio .RadicateInvoiceD  DET
 INNER JOIN CTE_INGRESOS_FACTURAS AS FAC ON DET.InvoiceNumber =FAC.FACTURA WHERE DET.State <> '4' GROUP BY DET.InvoiceNumber
 )

SELECT        
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
CTE.[RADICADO DEVOLUCION],CTE.FACTURA, CTE.[FECHA FACTURA], FAC.TotalInvoice [VALOR FACTURA], 
CASE
					WHEN cg.EntityType ='1' THEN 'EPS Contributivo' 
					WHEN cg.EntityType = '2' THEN  'EPS Subsidiado' 
					WHEN cg.EntityType = '3' THEN 'ET Vinculados Municipios'
					WHEN cg.EntityType = '4' THEN 'ET Vinculados Departamentos' 
					WHEN cg.EntityType = '5'  THEN 'ARL Riesgos Laborales' 
					WHEN cg.EntityType = '6' THEN 'MP Medicina Prepagada' 
					WHEN cg.EntityType = '7'  THEN 'IPS Privada' 
					WHEN cg.EntityType = '8'  THEN 'IPS Publica' 
					WHEN cg.EntityType = '9'  THEN 'Regimen Especial' 
					WHEN cg.EntityType = '10'  THEN 'Accidentes de transito' 
					WHEN cg.EntityType = '11'  THEN 'Fosyga' 
					WHEN cg.EntityType = '12'  THEN 'Otros' 
					WHEN cg.EntityType = '13'  THEN 'Aseguradoras' 
					WHEN cg.EntityType = '99'  THEN 'Particulares'
					end as Regimen,
CASE P.IPTIPODOC    WHEN '1' THEN 'CEDULA DE CIUDADANIA' 
					WHEN '2' THEN 'CEDULA DE EXTRANJERIA' 
					WHEN '3' THEN 'TARJETA DE IDENTIDAD' 
					WHEN '4' THEN 'REGISTRO CIVIL' 
					WHEN '5' THEN 'PASAPORTE'
					WHEN '6' THEN 'ADULTO SIN IDENTIFICACION' 
					WHEN '7' THEN 'MENOR SIN IDENTIFICACION' 
					WHEN '8' THEN 'NUMERO UNICO DE IDENTIFICACIÒN' 
					WHEN '9' THEN 'CERTIFICADO NACIDO VIVO' 
					WHEN '10' THEN 'CARNET DIPLOMATICO'
					WHEN '11' THEN 'SALVOCONDUCTO' 
					WHEN '12' THEN 'PERMISO ESPECIAL DE PERMANENCIA'
					WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
					WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
					WHEN '15' THEN 'SIN IDENTIFICACION'
					END AS  'TIPO DOCUMENTO', 
FAC.PatientCode AS 'IDENTIFICACION PACIENTE', 
P.IPNOMCOMP AS 'NOMBRE PACIENTE',
CASE AR.PortfolioStatus WHEN '1' THEN 'SIN RADICAR' WHEN '2' THEN 'RADICADA SIN CONFIRMAR' WHEN '3' THEN 'RADICADA ENTIDAD' WHEN '7' THEN 'CERTIFICADA PARCIAL' WHEN '8' THEN 'CERTIFICADA TOTAL' WHEN
                          '14' THEN 'DEVOLUCION FACTURA ' WHEN '15' THEN 'TRASLADO COBRO JURÍDICO CONFIRMADO' END AS [ESTADO CARTERA], CTE.[FECHA RADICACION], 
                        CTE.[FECHA RECEPCION DEVOLUCION], 
                         CTE.[CONSECUTIVO RADICACION], AR.Balance AS [SALDO CARTERA], CTE.[FECHA RADICADO DEVOLUCION], 
                         U.NOMUSUARI AS FACTURADOR,e.Nit NitEntidad, E.Name AS ENTIDAD, CASE MV.TypeDevolution WHEN '1' THEN 'Justificada' WHEN '2' THEN 'Injustificada' ELSE 'Sin Gestión' END AS TIPODEVOLUCION, 
                         MV.CreationDate AS [FECHA OPCIÓN Justifica ó Injustifica],C.Code as [CODIGO CONCEPTO DEVOLUCION] ,C.NameSpecific AS [CONCEPTO DEVOLUCION], MV.Comment AS [MOTIVO EAPB], MV.Answer AS [RESPUESTA IPS], 
                         MV.CreationUser AS [USUARIO INGRESO DEV],U2.NOMUSUARI [NOMBRE USUARIO DEV],  CAT.Name AS 'CATEGORIA',CEN.NOMCENATE AS 'CENTRO DE ATENCION',
						 CTE.INGRESO ,CASE FAC.Status WHEN 1 THEN 'FACTURADO' ELSE 'ANULADA' END 'ESTADO FACTURA', 
						 RAD.RadicatedNumber 'ULTIMO RADICADO', 
						 1 as 'CANTIDAD',
						 CAST([FECHA RECEPCION DEVOLUCION] AS date) AS 'FECHA BUSQUEDA',
						 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM       CTE_INGRESOS_FACTURAS AS CTE
						 INNER JOIN Billing .Invoice AS FAC ON FAC.InvoiceNumber =CTE.FACTURA  
						 INNER JOIN
						 Contract.HealthAdministrator AS cg ON cg.Id = fac.HealthAdministratorId left JOIN
                         Glosas.GlosaMovementDevolutions AS MV WITH (nolock) ON CTE.[ID DET]  = MV.IdDevolutionsReceptionD LEFT OUTER JOIN
                         Portfolio.AccountReceivable AS AR WITH (nolock) ON CTE.FACTURA  = AR.InvoiceNumber AND AR.AccountReceivableType = '2' LEFT OUTER JOIN
                         dbo.SEGusuaru AS U WITH (nolock) ON AR.CreationUser = U.CODUSUARI LEFT OUTER JOIN
                         Common.ConceptGlosas AS C WITH (nolock) ON C.Id = MV.IdConceptGlosa LEFT OUTER JOIN
                         Common.Customer AS E WITH (nolock) ON CTE.CLIENTE = E.Id LEFT OUTER JOIN
						 dbo.SEGusuaru AS U2 WITH (nolock) ON MV.CreationUser = U2.CODUSUARI
						 LEFT JOIN CTE_RADICADO AS RAD ON RAD.InvoiceNumber =CTE.FACTURA AND RAD.RadicatedNumber > CTE.[CONSECUTIVO RADICACION] 
						 LEFT JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES =FAC.AdmissionNumber 
						 LEFT JOIN DBO.ADCENATEN AS CEN ON CEN.CODCENATE =ING.CODCENATE
						 LEFT JOIN Billing.InvoiceCategories AS CAT ON CAT.Id = FAC.InvoiceCategoryId
						 LEFT JOIN dbo.INPACIENT AS P ON P.ipcodpaci = FAC.PatientCode
						 --WHERE CAST([FECHA RECEPCION DEVOLUCION] AS date)='2024-02-26' 

