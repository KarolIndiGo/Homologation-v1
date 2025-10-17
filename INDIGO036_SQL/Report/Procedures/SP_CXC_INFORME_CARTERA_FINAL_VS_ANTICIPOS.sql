-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_CXC_INFORME_CARTERA_FINAL_VS_ANTICIPOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0








    /*******************************************************************************************************************
Nombre: [Report].[SP_CXC_INFORME_CARTERA_FINAL_VS_ANTICIPOS]
Tipo:Procedimiento almacenado
Observacion:
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 08-05-2023
Observaciones:Se ajusta el @TBL_CARTERA, para que tenga en cuenta el tipo de cuenta por cobrar de facturación ley 100 y no solo el tipo dos Impuestos Industria y Comercio,
			  este cambio fue solicitado en HOmi segun el ticket 9642
----------------------------------------------------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:22-05-2023
Observaciones: Se ajusta EL CTE CTE_ANTICIPOS, para que solo tenga en cuenta los traslados de cartera de los anticipos vs cuentas por cobrar, esto solicitado
			   en el ticket 10639 por HOMI.
-----------------------------------------------------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:31-10-2023
Observaciones: SE CAMBIA LA LOGICA EN EL CTE DE LA NOTA, PARA QUE AHORA NO TENGA EN CUENTA EL VALOR DE LA NOTA, SI NO EL VALOR AJUSTADO
			   DEPENDIENDO DE LA NATURALEZA DE LA NOTA.
***********************************************************************************************************************************/




CREATE PROCEDURE [Report].[SP_CXC_INFORME_CARTERA_FINAL_VS_ANTICIPOS]
AS



DECLARE @TBL_CARTERA as TABLE([Id] [int] NOT NULL,
							  [SALDO INICIAL] [varchar](2) NULL,
							  [TIPO] [varchar](28) NULL,
							  [CODIGO CUENTA][VARCHAR](15) NULL,
							  [CUENTA] [VARCHAR] (50) NULL,
							  [FACTURA] [varchar](20) NOT NULL,
							  [ESTADO] [varchar](32) NULL,
							  [FECHA FACTURA] [date] NULL,
							  [FECHA VENCIMIENTO] [date] NULL,
							  [DIAS CARTERA] [int] NULL,
							  [EDAD CARTERA] [varchar](20) NULL,
							  [NIT] [varchar](25) NOT NULL,
							  [ENTIDAD] [varchar](300) NOT NULL,
							  [GRUPO ATENCION] [varchar](100) NULL,
							  [VALOR FACTURA] [numeric](18, 2) NOT NULL,
							  [SinRadicar1301] [numeric](18, 2) NULL,
							  [Radicada1302] [numeric](18, 2) NULL,
							  [Glosada1303] [numeric](18, 2) NULL,
							  [CobroJuridico1304] [numeric](18, 2) NULL,
							  [Conciliada1305] [numeric](18, 2) NULL,
							  [SALDO FACTURA] [numeric](18, 2) NOT NULL);

INSERT INTO @TBL_CARTERA
 SELECT C.Id ,
 CASE C.OpeningBalance WHEN 0 THEN 'NO' 
					   WHEN 1 THEN 'SI' END 'SALDO INICIAL' ,
		CASE C.AccountReceivableType  WHEN '1'THEN 'Factura Basica'
									  WHEN '2'THEN 'Factura Salud'
									  WHEN '3'THEN 'Impuestos'
									  WHEN '4'THEN 'Pagarés'
									  WHEN '5'THEN 'Acuerdos de Pago' 
									  WHEN '6'THEN 'Documento Pago CuotaModeradora'
									  WHEN '7'THEN 'Factura Producto'END AS 'TIPO',
ISNULL(ma1.Number,ISNULL(ma2.Number,ISNULL(ma3.Number,ISNULL(ma4.Number,ma5.Number))))  AS [CODIGO CUENTA],
ISNULL(ma1.Name,ISNULL(ma2.Name,ISNULL(ma3.Name,ISNULL(ma4.Name,ma5.Name)))) AS CUENTA,
        C.InvoiceNumber AS FACTURA, 
		CASE C.PortfolioStatus WHEN 1 THEN 'SIN RADICAR - EMITIDO' 
							   WHEN 2 THEN 'RADICADA SIN CONFIRMAR - ENVIADO' 
							   WHEN 3 THEN 'RADICADA'
							   WHEN 4 THEN 'GLOSADA' 
							   WHEN 7 THEN 'CERTIFICADA PARCIAL' 
							   WHEN 8 THEN 'CERTIFICADA TOTAL' 
							   WHEN 14 THEN 'DEVOLUCION' 
							   WHEN 15 THEN 'CUENTA DIFICIL RECAUDO'
							   WHEN 16 THEN 'COBRO JURIDICO' END AS 'ESTADO', 
CAST(C.AccountReceivableDate AS DATE) AS 'FECHA FACTURA',
CAST(C.ExpiredDate AS DATE) AS [FECHA VENCIMIENTO],
		DATEDIFF (DAY,cast(C.AccountReceivableDate  as date),GETDATE()) AS [DIAS CARTERA],
		CASE WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) < 1 THEN '1. Sin Vencer'
			 WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) > 0 AND CAST(GETDATE() - C.AccountReceivableDate AS INT) < 31 THEN '2. De 1 a 30 Dias'
			 WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) > 30 AND CAST(GETDATE() - C.AccountReceivableDate AS INT) < 61 THEN '3. De 31 a 60 Dias'
			 WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) > 60 AND CAST(GETDATE() - C.AccountReceivableDate AS INT) < 91 THEN '4. De 61 a 90 Dias'
			 WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) > 90 AND CAST(GETDATE() - C.AccountReceivableDate AS INT) < 121 THEN '5. De 91 a 120 Dias'
			 WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) > 120 AND CAST(GETDATE() - C.AccountReceivableDate AS INT) < 181 THEN '6. De 121 a 180 Dias'
			 WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) > 180 AND CAST(GETDATE() - C.AccountReceivableDate AS INT) < 361 THEN '7. De 181 a 360 Dias'
			 WHEN CAST(GETDATE() - C.AccountReceivableDate AS INT) > 360 THEN 'Mayor a 360 Dias' END AS 'EDAD CARTERA',		
		CASE when TE.PersonType=1 then '999' else TE.Nit end as 'NIT' ,
		TE.Name AS 'ENTIDAD',CG.Name 'GRUPO ATENCION',
		C.Value AS [VALOR FACTURA],
COALESCE(ACD.Balance, 0) AS SinRadicar1301, 
COALESCE(ACD2.Balance, 0) AS Radicada1302, 
COALESCE(ACD3.Balance, 0) AS Glosada1303, COALESCE(ACD4.Balance, 0) AS CobroJuridico1304, 
COALESCE(ACD5.Balance, 0) AS Conciliada1305,
C.Balance AS [SALDO FACTURA]
FROM 
Portfolio.AccountReceivable AS C 
INNER JOIN Common.ThirdParty AS TE ON C.ThirdPartyId = TE.Id AND C.STATUS <> 3
LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD 
LEFT JOIN GeneralLedger.MainAccounts ma1 on ACD.MainAccountId=ma1.Id
INNER JOIN Report.TempCartera AS TCV ON ACD.MainAccountId = TCV.Idcuenta AND TCV.Descri = 'SinRadicar1301' ON C.Id=ACD.AccountReceivableId
LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD2 
LEFT JOIN GeneralLedger.MainAccounts ma2 on ma2.Id = ACD2.MainAccountId
INNER JOIN Report.TempCartera AS TCV2 ON ACD2.MainAccountId = TCV2.Idcuenta AND TCV2.Descri = 'Radicada1302' ON C.Id = ACD2.AccountReceivableId
LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD3
LEFT JOIN GeneralLedger.MainAccounts ma3  on ma3.Id = ACD3.MainAccountId
INNER JOIN Report.TempCartera AS TCV3 ON ACD3.MainAccountId = TCV3.Idcuenta AND TCV3.Descri = 'Glosada1303' ON C.Id = ACD3.AccountReceivableId
LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD4
LEFT JOIN GeneralLedger.MainAccounts ma4 on ma4.Id = ACD4.MainAccountId
INNER JOIN Report.TempCartera AS TCV4 ON ACD4.MainAccountId = TCV4.Idcuenta AND TCV4.Descri = 'CobroJuridico1304' ON C.Id = ACD4.AccountReceivableId
LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD5
LEFT JOIN GeneralLedger.MainAccounts ma5 on ma5.Id = ACD5.MainAccountId
INNER JOIN Report.TempCartera AS TCV5 ON ACD5.MainAccountId = TCV5.Idcuenta AND TCV5.Descri = 'Conciliada1305' ON C.Id = ACD5.AccountReceivableId
LEFT JOIN Contract.CareGroup cg ON C.CareGroupId = cg.Id
--LEFT JOIN Billing.Invoice i on i.Id = C.InvoiceId

WHERE C.AccountReceivableType /*IN V2*/in (1/*FN 2*/,2) AND C.Balance>0 AND TE.PersonType=2; --and c.InvoiceNumber='IND132137'


WITH 

CTE_RADICACION
AS
(
   SELECT rid.InvoiceNumber, MIN(ri.Id) Id, MIN(rid.RadicatedNumber) RadicatedNumber
   FROM Portfolio.RadicateInvoiceC ri 
   INNER JOIN Portfolio.RadicateInvoiceD rid ON ri.Id = rid.RadicateInvoiceCId
   INNER JOIN @TBL_CARTERA AS FAC ON FAC.FACTURA =RID.InvoiceNumber 
   WHERE rid.State <>'4'
   GROUP BY rid.InvoiceNumber
),

CTE_GLOSAS
AS
(
  SELECT  
  T.Nit, 
  T.Name AS Entidad, 
  C.RadicatedConsecutive AS NroRadicadoGlosa, 
  C.RadicatedDate AS FechaRadicadoGlosas, 
  C.ConfirmDate AS FechaConfirmacionRadicadoGlosas, 
  CASE WHEN C.State = 1 THEN 'Sin Confirmar' 
	   WHEN C.State = 2 THEN 'ConfirmadoRadicado' 
	   WHEN C.State = 3 THEN 'OficioConRespuesta' 
	   WHEN C.State = 4 THEN 'Anulada' END AS EstadoRadicadoGlosa, 
  DG.InvoiceNumber AS Factura, 
  DG.InvoiceDate AS FechaFactura, 
  DG.InvoiceValueEntity AS ValorEntidad, 
  DG.BalanceInvoice AS 'VALOR FACTURA', 
  ISNULL(DG.ValueGlosado,0) AS 'VALOR GLOSADO', 
  DG.ValueAcceptedFirstInstance AS 'VALOR ACEPTADO 1 INST', 
  --DG.ValueReiterated AS 'VALOR REITERADO', 
  DG.ValueAcceptedSecondInstance AS 'VALOR ACEPTADO 2 INST', 
  DG.ValueAcceptedIPSconciliation AS 'VALOR ACEPTADO IPS CONCILIACION', 
  DG.ValueAcceptedEAPBconciliation AS 'VALOR ACEPTADO EAPB CONCILIACION', 
  DG.BalanceGlosa AS 'SALDO PENDIENTE CONCILIAR', 
  --DG.ValuePayments AS ValorPagoParcial, 
  --tcj.LegalTransferValue AS CobroJuridico, 
  --DG.RadicatedNumber AS NroRadicadoERP, 
  --DG.RadicatedDate AS FechaRadicadoERP, 
  --DG.AccountantAccountCustomers AS Cuenta, 
  --CASE WHEN CC.State = 1 THEN 'Sin Confirmar' 
	 --  WHEN CC.State = 2 THEN 'Confirmado' END AS EstadoConciliaion, 
  --CC.ConciliationConsecutive AS NroConciliacion, 
  --C.Comment AS Observacion, 
  --CC.ConciliationDate AS FechaRegistroConciliacion, 
  --CC.ConfirmDate AS FechaConfirmacionConciliacion, 
  --CC.DocumentDate AS FechaOficioConciliación, 
  --C.DocumentDate AS [ Fecha Oficio Radicación Glosa], 
  --C.DateRadicatedDocumentReply AS FechaConfirmaciónConsecutivoRespuesta, 
  --DG.CoordinationDateGlosa AS FechaConfirmaciónRespuestaGlosaFactura,
  --case when ing.IFECHAING is not null then ing.IFECHAING  end as FechaIngreso,
  --case when eg.FECALTPAC is not null then eg.FECALTPAC end as FechaEgreso,
  ar.Id 'IdCartera',
  --ar.InvoiceId ,
  CASE DG.State WHEN 1 THEN 'PENDIENTE CONFIRMADO RECEPCION GLOSA' 
				WHEN 2 THEN 'PENDIENTE EVALUACION GLOSA' 
				WHEN 3 THEN 'PENDIENTE ENVIO OFICIO'
				WHEN 4 THEN 'PENDIENTE CONFIRMAR REITERACION' 
				WHEN 5 THEN 'PENDIENTE EVALUACION REITERACION' 
				WHEN 6 THEN 'PENDIENTE CONCILIACION'
				WHEN 7 THEN 'PENDIENTE CONFIRMAR FACTURA CONCILIACION' 
				WHEN 8 THEN 'CONCILIACION' 
				WHEN 9 THEN 'CONCILIACION PARCIAL' 
				WHEN 11 THEN 'GLOSA CON RESPUESTA'
				WHEN 12 THEN 'REITERACION CON RESPUESTA' 
				WHEN 13 THEN 'PENDIENTE CONFIRMAR PAGO PARCIAL' 
				WHEN 14 THEN 'CONFIRMADO PAGO PARCIAL'
				WHEN 15 THEN 'TRASLADO A COBRO JURIDICO' END 'ESTADO GLOSA'
FROM   
Glosas.GlosaPortfolioGlosada AS DG INNER JOIN
(
	SELECT D.DocumentType, D.InvoiceNumber, D.GlosaObjectionsReceptionCId, D.PortfolioGlosaId
	FROM   Glosas.GlosaObjectionsReceptionD AS D  INNER JOIN
	(SELECT MAX(GlosaObjectionsReceptionCId) AS GlosaObjectionsReceptionCId, PortfolioGlosaId, InvoiceNumber
	FROM   Glosas.GlosaObjectionsReceptionD 
	GROUP BY PortfolioGlosaId, InvoiceNumber) AS G ON G.GlosaObjectionsReceptionCId = D.GlosaObjectionsReceptionCId AND D.InvoiceNumber = G.InvoiceNumber AND D.PortfolioGlosaId = G.PortfolioGlosaId
) AS G1 ON G1.PortfolioGlosaId = DG.Id INNER JOIN
Glosas.GlosaObjectionsReceptionC AS C ON G1.GlosaObjectionsReceptionCId = C.Id INNER JOIN
Common.Customer AS T  ON C.CustomerId = T.Id LEFT OUTER JOIN
--(
--	SELECT InvoiceNumber, MAX(ConciliationCId) AS ConciliationCId
--	FROM   Glosas.ConciliationD
--	GROUP BY InvoiceNumber
--) AS CD ON DG.InvoiceNumber = CD.InvoiceNumber LEFT OUTER JOIN
--Glosas.ConciliationC AS CC  ON CD.ConciliationCId = CC.Id LEFT OUTER JOIN
--Glosas.TransferJuridicalDebtCollectionD AS tcj  ON tcj.InvoiceNumber = DG.InvoiceNumber LEFT OUTER JOIN
Portfolio.AccountReceivable as ar  on ar.InvoiceNumber=dg.InvoiceNumber and ar.Balance>'0' --left outer join
--billing.invoice as i on i.invoicenumber=dg.invoicenumber left outer join
--dbo.adingreso as ing on ing.NUMINGRES=i.AdmissionNumber left outer join
--dbo.HCREGEGRE AS eg ON eg.numingres=i.AdmissionNumber 
WHERE (C.State <> 4) AND (DG.BalanceGlosa <> '0')  and ar.Balance>'0'
),

CTE_DEVOLUCION
AS
(
  SELECT DEV.InvoiceNumber ,DEV.BalanceInvoice 'VALOR DEVOLUCION' ,CASE CAB.State WHEN  1 THEN 'DEVOLUCION SIN CONFIRMAR'
  WHEN 2 THEN 'DEVOLUCION CONFIRMADO RADICADO' WHEN 3 THEN 'DEVOLUCION OFICIO CON RESPUESTA ENVIADA' WHEN 4 THEN 'ANULADO' END 'ESTADO DEVOLUCION'
    FROM Glosas .GlosaDevolutionsReceptionD DEV 
    INNER JOIN
	(SELECT max(DEV.GlosaDevolutionsReceptionCId) IdCabeceraDev,DEV.InvoiceNumber 
     FROM Glosas .GlosaDevolutionsReceptionD DEV 
	 --WHERE dev.InvoiceNumber ='IND19626'
     GROUP BY DEV.InvoiceNumber
	) AS G ON G.IdCabeceraDev =DEV.GlosaDevolutionsReceptionCId AND G.InvoiceNumber =DEV.InvoiceNumber 
	INNER JOIN Glosas.GlosaDevolutionsReceptionC AS cab ON cab.Id =dev.GlosaDevolutionsReceptionCId
	where cab.State<>'4'
),

CTE_ANTICIPOS
AS
(
  SELECT 
  PTD.AccountReceivableId,
  --AR.InvoiceNumber 'FACTURA',
  SUM(PTD.Value) 'VALOR PAGOS A FACTURA' --PTD.PortfolioTrasferId ,
  FROM
  @TBL_CARTERA CAR INNER JOIN
  Portfolio.PortfolioTransferDetail PTD ON CAR.ID=PTD.AccountReceivableId INNER JOIN
  Portfolio.PortfolioTransfer AS CA ON PTD.PortfolioTrasferId = CA.Id /*IN V3*/ AND CA.Status=2 /*FN V3*/
  --INNER JOIN Portfolio .AccountReceivable AR on PTD.AccountReceivableId =AR.Id 
  --INNER JOIN Portfolio.PortfolioAdvance PA ON PA.Id = CA.PortfolioAdvanceId
  --WHERE AR.InvoiceNumber ='IND48955'
  GROUP BY PTD.AccountReceivableId--,AR.InvoiceNumber--,PTD.PortfolioTrasferId 
 ),

CTE_SUMAS_NOTAS AS
(
	SELECT 
	F.InvoiceNumber,
	--IN V4 CASE NC.Nature WHEN 1 THEN 'Debito' 
	--			   WHEN 2 THEN 'Credito' END AS 'NATURALEZA',
	--SUM(ND.Value) 'VALOR NOTA', FN V4
	IIF(NC.Nature=1,ISNULL(SUM(FA.AdjusmentValue),0),0) 'AJUSTE DEBITO',
	IIF(NC.Nature=2,ISNULL(SUM(FA.AdjusmentValue),0),0) 'AJUSTE CREDITO',
	FA.AccountReceivableId,
	f.Id IdFactura 
	FROM 
	Portfolio.PortfolioNote AS NC INNER JOIN 
	Portfolio.PortfolioNoteDetail AS ND ON NC.Id=ND.PortfolioNoteId INNER JOIN 
	Portfolio.PortfolioNoteAccountReceivableAdvance AS FA ON FA.PortfolioNoteId = NC.Id LEFT JOIN 
	Portfolio.AccountReceivable AS c ON c.Id = FA.AccountReceivableId LEFT JOIN 
	Billing.Invoice AS F ON F.InvoiceNumber = c.InvoiceNumber --LEFT JOIN 
	--IN V4 Portfolio.PortfolioNoteConcept AS conc ON conc.Id = ND.PortfolioNoteConceptId FN V4
	--WHERE f.InvoiceNumber='IND206396'
	GROUP BY F.InvoiceNumber,NC.Nature,FA.AccountReceivableId ,f.Id
),

CTE_NOTAS AS
(
SELECT
AccountReceivableId,
SUM([AJUSTE CREDITO]) AS [AJUSTE CREDITO],
SUM([AJUSTE DEBITO]) AS [AJUSTE DEBITO]
FROM CTE_SUMAS_NOTAS
GROUP BY AccountReceivableId
),

 CTE_CARTERA_DATO
 AS
 (
SELECT 
  CAR.[SALDO INICIAL],
  CAR.TIPO ,
  CAR.FACTURA 'FACTURA/RECIBO',
  CAR.ESTADO,
  CAR.[CODIGO CUENTA],
  CAR.CUENTA,
  IIF(DEV.[VALOR DEVOLUCION]>0,DEV.[ESTADO DEVOLUCION],GLO.[ESTADO GLOSA] ) 'ESTADO GLOSA-DEVOLUCION' ,
  CAR.[FECHA FACTURA] 'FECHA FACTURA/RECIBO',CAR.[FECHA VENCIMIENTO], RAD.RadicatedNumber 'NRO RADICADO',CAST(Ri.ConfirmDate AS DATE)  AS 'FECHA RADICADO',CAR.[DIAS CARTERA],
  CAR.[EDAD CARTERA],DATEDIFF (DAY,cast(RI.ConfirmDate  as date),GETDATE()) 'DIAS RADICADO',
  CASE WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) < 1THEN '1. Sin Vencer'WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 0 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 31
  THEN '2. De 1 a 30 Dias'WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 30 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 61THEN '3. De 31 a 60 Dias'
  WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 60 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 91 THEN '4. De 61 a 90 Dias'
  WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 90 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 121 THEN '5. De 91 a 120 Dias'
  WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 120 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 181 THEN '6. De 121 a 180 Dias'
  WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 180 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 361 THEN '7. De 181 a 360 Dias'
  WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 360 THEN 'Mayor a 360 Dias'END AS 'EDAD RADICADO',CAR.NIT ,CAR.ENTIDAD ,CAR.[GRUPO ATENCION] ,
  CAR.[VALOR FACTURA] 'VALOR FACTURA/RECIBO' ,
  CAR.SinRadicar1301,CAR.Radicada1302 ,CAR.Glosada1303,CAR.CobroJuridico1304,CAR.Conciliada1305 ,
  ISNULL(GLO. [VALOR GLOSADO],0) [VALOR GLOSADO],ISNULL(GLO.[VALOR ACEPTADO 1 INST],0) [VALOR ACEPTADO 1 INST] ,ISNULL(GLO.[VALOR ACEPTADO 2 INST],0) [VALOR ACEPTADO 2 INST],
  ISNULL(GLO.[VALOR ACEPTADO EAPB CONCILIACION],0) [VALOR ACEPTADO EAPB CONCILIACION] ,ISNULL(GLO.[VALOR ACEPTADO IPS CONCILIACION],0) [VALOR ACEPTADO IPS CONCILIACION] ,
  ISNULL(GLO.[SALDO PENDIENTE CONCILIAR],0) [SALDO PENDIENTE CONCILIAR] , ISNULL(DEV.[VALOR DEVOLUCION],0) [VALOR DEVOLUCION],
  ISNULL(ANT.[VALOR PAGOS A FACTURA],0)'VALOR PAGOS A FACTURA/RECIBO',
  --ISNULL(NOTA.[VALOR NOTA],0) [VALOR NOTA],
  NOTA.[AJUSTE CREDITO],
  NOTA.[AJUSTE DEBITO],
  CAR.[SALDO FACTURA] 'SALDO FACTURA/RECIBO'
 -- CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  --into report.cxc
FROM @TBL_CARTERA CAR 
LEFT JOIN CTE_RADICACION AS RAD ON RAD.InvoiceNumber =CAR.FACTURA
LEFT JOIN Portfolio.RadicateInvoiceC ri ON RAD.Id = ri.Id
LEFT JOIN CTE_GLOSAS AS GLO ON GLO.IdCartera =CAR.Id
LEFT JOIN CTE_DEVOLUCION AS DEV  ON DEV.InvoiceNumber =CAR.FACTURA
LEFT JOIN CTE_ANTICIPOS ANT ON ANT.AccountReceivableId =CAR.ID
LEFT JOIN CTE_NOTAS AS NOTA ON NOTA.AccountReceivableId =CAR.Id
),

CTE_ANTICIPOS_NUEVO
AS
(
 
 SELECT 
 PA.Observations 'SALDO INICIAL',
 'RECIBOS DE CAJA' 'TIPO',PA.Code 'FACTURA/RECIBO',
 CASE  PA.Status WHEN 1 THEN 'REGISTRADO' WHEN 2 THEN 'CONFIRMADO' WHEN 3 THEN 'ANULADO' END 'ESTADO',
 M.Number AS [CODIGO CUENTA],
 M.Name AS CUENTA,
 '' 'ESTADO GLOSA-DEVOLUCION', 
 CAST(ISNULL(CR.DocumentDate,PA.DocumentDate)AS DATE) 'FECHA FACTURA/RECIBO',
 '1900-01-01' 'FECHA VENCIMIENTO','' 'NRO RADICADO', '' 'FECHA RADICADO',0 'DIAS CARTERA',
 '' 'EDAD CARTERA',0 'DIAS RADICADO', '' 'EDAD RADICADO',TP.Nit 'NIT',TP.Name 'ENTIDAD','' 'GRUPO ATENCION',
 PA.Value 'VALOR FACTURA/RECIBO',
 0 'SinRadicar1301',0 'Radicada1302',0 'Glosada1303',0 'CobroJuridico1304', 0 'Conciliada1305', 0 'VALOR GLOSADO', 0 'VALOR ACEPTADO 1 INST', 0 'VALOR ACEPTADO 2 INST',
 0 'VALOR ACEPTADO EAPB CONCILIACION',0 'VALOR ACEPTADO IPS CONCILIACION',
 0 'SALDO PENDIENTE CONCILIAR',
 0 'VALOR DEVOLUCION',
 PA.TransferValue 'VALOR PAGOS A FACTURA/RECIBO',
 --0 'VALOR NOTA',
 0 AS [AJUSTE CREDITO],
 0 AS [AJUSTE DEBITO],
 PA.Balance AS 'SALDO FACTURA/RECIBO'
 --, ,PA.DocumentDate,PA.Value ,PA.TransferValue ,PA.Balance,CR.Code ,CR.DocumentDate ,PA.CreationDate ,CR.CreationDate ,CR.ConfirmationDate ,PA.ConfirmationDate 
 FROM Portfolio.PortfolioAdvance  PA
 INNER JOIN Common.ThirdParty AS TP ON TP.Id =PA.ThirdPartyId
 LEFT JOIN GeneralLedger.MainAccounts M ON PA.MainAccountId=M.Id
 LEFT JOIN Treasury .CashReceipts AS CR ON PA.CashReceiptId =CR.Id 
 LEFT JOIN Treasury .CashReceiptDetails AS CRD ON CRD.Id =PA.CashReceiptDetailId 
 WHERE PA.Balance > 0 AND PA.Status <>3 AND CRD.IdCashReceiptConcept in (2,8)--AND PA.CODE='0000039134'
),
--SE TIENE EN CUENTA LA TABLA PRINCIPAL QUE ES CRICE DE ANTICIPOS, YA SEA POR SALDOS INICIALES O POR NOTA.
CTE_DISTRIBUCION_ANTICIPOS AS
(
select 
	PA.Observations AS [SALDO INICIAL],
	'DISTRIBUCION DE ANTICIPOS' AS TIPO,
	PA.Code AS [FACTURA/RECIBO],
	CASE PA.Status WHEN 1 THEN 'REGISTRADO'
				   WHEN 2 THEN 'CONFIRMADO'
				   WHEN 3 THEN 'ANULADO' END AS ESTADO,
	 M.Number AS [CODIGO CUENTA],
	 M.Name AS CUENTA,
	'' AS [ESTADO GLOSA-DEVOLUCION],
	PA.DocumentDate AS [FECHA FACTURA/RECIBO],
	'1900-01-01' AS [FECHA VENCIMIENTO],
	PN.Code AS [NRO RADICADO],
	'' AS [FECHA RADICADO],
	0 AS [DIAS CARTERA],
	'' AS [EDAD CARTERA],
	0 AS [DIAS RADICADO], 
	'' AS [EDAD RADICADO],
	C.Nit AS [NIT],
	C.Name AS [ENTIDAD],
	'' AS [GRUPO ATENCION], 
	PND.Value [VALOR FACTURA/RECIBO],
	 0 'SinRadicar1301',
	 0 'Radicada1302',
	 0 'Glosada1303',0 'CobroJuridico1304', 0 'Conciliada1305', 0 'VALOR GLOSADO', 0 'VALOR ACEPTADO 1 INST', 0 'VALOR ACEPTADO 2 INST',
	 0 'VALOR ACEPTADO EAPB CONCILIACION',0 'VALOR ACEPTADO IPS CONCILIACION',0 'SALDO PENDIENTE CONCILIAR',0 'VALOR DEVOLUCION',0 'VALOR PAGOS A FACTURA/RECIBO',
	 --0 'VALOR NOTA',
	  0 AS [AJUSTE CREDITO],
	  0 AS [AJUSTE DEBITO],
	 PA.Balance AS 'SALDO FACTURA/RECIBO'
from 
Portfolio.PortfolioAdvance PA 
LEFT JOIN GeneralLedger.MainAccounts M ON PA.MainAccountId=M.Id
LEFT JOIN Common.Customer C ON PA.CustomerId=C.Id 
LEFT JOIN Portfolio.PortfolioNoteDistribution PND ON PA.Id=PND.PortfolioAdvanceId
LEFT JOIN Portfolio.PortfolioNote PN ON PND.PortfolioNoteId=PN.Id AND PN.NoteType=4
where PA.Balance !='0.00'
)


SELECT DISTINCT * FROM CTE_CARTERA_DATO --where [FACTURA/RECIBO] = 'hsjo7'
UNION ALL
SELECT DISTINCT * FROM CTE_ANTICIPOS_NUEVO --where [FACTURA/RECIBO] = 'hsjo7'
UNION ALL
SELECT DISTINCT * FROM CTE_DISTRIBUCION_ANTICIPOS --where [FACTURA/RECIBO] = 'hsjo7'
