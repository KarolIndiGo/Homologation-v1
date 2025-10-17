-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_ESTADISTICO_GLOSAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: [Report].[VIEW_ESTADISTICO_GLOSAS]
Tipo:Vista
Observacion:
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
__________________________________________________________________________________________________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:28-02-2024
Observaciones: Se agrega en la condicion de la tabla Portfolio.AccountReceivable para que no traiga en la columna
			  AccountReceivableType el tipo 4 y el 6, con esto se exonera los pagares y las cuotas moderadoras ya que no lo paga una instucion.
			  Esto solicitado en el ticket 15484
--------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
--------------------------------------------------------------------------------------------
***********************************************************************************************/

CREATE VIEW [Report].[VIEW_ESTADISTICO_GLOSAS] AS

SELECT  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
T.Nit 'NIT', 
T.Name AS 'ENTIDAD', 
C.RadicatedConsecutive AS 'NRO RADICADO GLOSA', 
CAST(C.RadicatedDate AS DATE) AS 'FECHA RADICADO GLOSA', 
CAST(C.ConfirmDate AS DATE) AS 'FECHA CONFIRMACION RADICADO GLOSA', 
CASE WHEN C.State = 1 THEN 'Sin Confirmar' 
	 WHEN C.State = 2 THEN 'ConfirmadoRadicado' 
	 WHEN C.State = 3 THEN 'OficioConRespuesta' 
	 WHEN C.State = 4 THEN 'Anulada' END AS 'ESTADO RADICADO GLOSA', 
DG.InvoiceNumber AS 'FACTURA', CAST(DG.InvoiceDate AS DATE) AS 'FECHA FACTURA', DG.InvoiceValueEntity AS 'VALOR ENTIDAD', 
           DG.BalanceInvoice AS  'VALOR FACUTRA', DG.ValueGlosado AS 'VALOR GLOSADO', DG.ValueAcceptedFirstInstance AS 'VALOR ACEPTADO 1RA INS', DG.ValueReiterated AS 'VALOR REITERADO', DG.ValueAcceptedSecondInstance AS 'VALOR ACEPTADO 2DA INS', DG.ValueAcceptedIPSconciliation AS 'VALOR ACEPTADO IPS CONCILIACION', 
           DG.ValueAcceptedEAPBconciliation AS 'VALOR ACEPTADO EAPB CONCILIACION', DG.BalanceGlosa AS 'SALDO PENDIENTE DE CONCILIAR', DG.ValuePayments AS 'VALOR PAGO PARCIAL', tcj.LegalTransferValue AS 'COBRO JURIDICO', DG.RadicatedNumber AS 'NRO RADICADO ERP', CAST(DG.RadicatedDate AS DATE) AS 'FECHA RADICADO ERP', 
           CASE WHEN CC.State = 1 THEN 'Sin Confirmar' WHEN CC.State = 2 THEN 'Confirmado' END AS 'ESTADO CONCILIACION', CC.ConciliationConsecutive AS 'NRO CONCILIACION', C.Comment AS 'OBSERVACIONES', CAST(CC.ConciliationDate AS DATE) AS 'FECHA REGISTRO CONCILIACION', 
           CAST(CC.ConfirmDate AS DATE) AS 'FECHA CONFIRMACION CONCILIACION', CAST(CC.DocumentDate AS DATE) AS 'FECHA OFICIO CONCILIACION', CAST(C.DocumentDate AS DATE) AS 'FECHA OFICIO RADICADO GLOSA', CAST(C.DateRadicatedDocumentReply AS DATE) AS 'FECHA CONFIRMACION CONSECUTIVO RESPUESTA', CAST(DG.CoordinationDateGlosa AS DATE) AS 'FECHA CONFIRMACION RESPUESTA GLOSA FACTURA',
		    CAST(ing.IFECHAING AS DATE)  as 'FECHA INGRESO', CAST(eg.FECALTPAC AS DATE)  as 'FECHA EGRESO', CAT.Name AS 'CATEGORIA',CEN.NOMCENATE AS 'CENTRO DE ATENCION',
			1 as 'CANTIDAD',
			CAST(C.RadicatedDate AS date) AS 'FECHA BUSQUEDA',
			CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM   Glosas.GlosaPortfolioGlosada AS DG INNER JOIN
               (SELECT D.DocumentType, D.InvoiceNumber, D.GlosaObjectionsReceptionCId, D.PortfolioGlosaId
              FROM   Glosas.GlosaObjectionsReceptionD AS D INNER JOIN
                             (SELECT MAX(GlosaObjectionsReceptionCId) AS GlosaObjectionsReceptionCId, PortfolioGlosaId, InvoiceNumber
                            FROM   Glosas.GlosaObjectionsReceptionD
                            GROUP BY PortfolioGlosaId, InvoiceNumber) AS G ON G.GlosaObjectionsReceptionCId = D.GlosaObjectionsReceptionCId AND D.InvoiceNumber = G.InvoiceNumber AND D.PortfolioGlosaId = G.PortfolioGlosaId) AS G1 ON G1.PortfolioGlosaId = DG.Id INNER JOIN
           Glosas.GlosaObjectionsReceptionC AS C with (nolock) ON G1.GlosaObjectionsReceptionCId = C.Id INNER JOIN
           Common.Customer AS T with (nolock) ON C.CustomerId = T.Id LEFT OUTER JOIN
               (SELECT InvoiceNumber, MAX(ConciliationCId) AS ConciliationCId
              FROM   Glosas.ConciliationD
              GROUP BY InvoiceNumber) AS CD ON DG.InvoiceNumber = CD.InvoiceNumber LEFT OUTER JOIN
           Glosas.ConciliationC AS CC with (nolock) ON CD.ConciliationCId = CC.Id LEFT OUTER JOIN
           Glosas.TransferJuridicalDebtCollectionD AS tcj with (nolock) ON tcj.InvoiceNumber = DG.InvoiceNumber LEFT OUTER JOIN
		   Portfolio.AccountReceivable as ar with (nolock) on ar.InvoiceNumber=dg.InvoiceNumber and ar.Balance>'0' /*in v2*/and AccountReceivableType NOT IN (4,6)/*fn v2*/ left outer join
		   billing.invoice as i on i.invoicenumber=dg.invoicenumber
		   LEFT JOIN Billing.InvoiceCategories AS CAT ON CAT.Id = I.InvoiceCategoryId
		   left outer join
		   adingreso as ing on ing.NUMINGRES=i.AdmissionNumber left outer join
		   dbo.HCREGEGRE AS eg WITH (nolock) ON eg.numingres=i.AdmissionNumber 
		   LEFT JOIN DBO.ADCENATEN AS CEN ON CEN.CODCENATE =ING.CODCENATE 
		   --where DG.InvoiceNumber='FEVC3388'


