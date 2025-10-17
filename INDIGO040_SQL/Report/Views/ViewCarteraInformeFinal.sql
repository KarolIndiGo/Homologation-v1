-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCarteraInformeFinal
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: [Report].[ViewCarteraInformeFinal]
Tipo:View
Observacion: 
Profesional: 
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:06-11-2024
Observaciones: SE AGREGA EL CAMPO [FECHA DOCUMENTO CALCULADO], siguendo la logica de la vista VReportPortfolioByAge
--------------------------------------
Version 2
Persona que modifico:
Fecha: 
Observaciones:
***********************************************************************************************************************************/




----*****SCRIPS HORIZONTAL********+
CREATE VIEW [Report].[ViewCarteraInformeFinal] AS

WITH CTE_FACTURACION_RADICACION
AS
(
  SELECT AR.Id,CASE AR.AccountReceivableType  WHEN '1'THEN 'Factura Básica'WHEN '2'THEN 'Factura Salud'WHEN '3'THEN 'Impuestos'WHEN '4'THEN 'Pagarés'WHEN '5'THEN 'Acuerdos de Pago' 
  WHEN '6'THEN 'Documento Pago CuotaModeradora'WHEN '7'THEN 'Factura Producto'END AS 'TIPO',CASE AR.OpeningBalance  WHEN 1 THEN 'SI' ELSE 'NO' END 'SALDO INICIAL',
  'FACTURA NRO' + ' - ' + AR.InvoiceNumber 'OBSERVACION',  TP.Nit 'NIT',TP.Name 'CLIENTE',
  HA.HealthEntityCode 'CODIGO ENTIDAD',HA.Name 'ENTIDAD',CG.Name 'GRUPO DE ATENCION',CASE WHEN HA.EntityType LIKE '1' THEN 'EPS CONTRIBUTIVO' WHEN HA.EntityType LIKE '2' THEN 'EPS SUBSIDIADO' WHEN HA.EntityType LIKE '3' THEN 'ET VINCULADO MUNICIPIO'
  WHEN HA.EntityType LIKE '4' THEN 'ET VINCULADOS DAPARTAMENTO' WHEN HA.EntityType LIKE '5' THEN 'ARL RIESGO LABORALES' WHEN HA.EntityType LIKE '6' THEN 'MP MEDICINA PREPAGADA'
  WHEN HA.EntityType LIKE '7' THEN 'IPS PRIVADA' WHEN HA.EntityType LIKE '8' THEN 'IPS PUBLICA' WHEN HA.EntityType LIKE '9' THEN 'REGIMEN ESPECIAL'WHEN HA.EntityType LIKE '10' THEN 'ACCIDENTE DE TRANSITO'
  WHEN HA.EntityType LIKE '11' THEN 'FOSYGA' WHEN HA.EntityType LIKE '12' THEN 'OTROS' WHEN HA.EntityType LIKE '13' THEN 'ASEGURADORA'  ELSE 'NO REGISTRA' END AS 'TIPO REGIMEN',
  CASE AR.PortfolioStatus  WHEN 1 THEN 'Sin Radicar' WHEN 2 THEN 'Radicada sin Confirmar'WHEN 3 THEN 'Radicada Entidad' WHEN 4 THEN 'Objetada o Glosada' WHEN 7 THEN 'Certificada Parcial' 
  WHEN 8 THEN 'Certificada Total' WHEN 14 THEN 'Devolución Factura'WHEN 15 THEN 'Cuenta de Dificil Recaudo' WHEN 16 THEN 'Cobro Jurídico' END 'ESTADO',AR.InvoiceNumber 'FACTURA/RECIBO',
  CAST(AR.Value AS NUMERIC) 'VALOR FACTURA/ANTICIPO',
  CAST(AR.AccountReceivableDate AS DATE) AS 'FECHA FACTURA/RECIBO',
  CAST(AR.ExpiredDate AS DATE) AS 'FECHA VENCIMIENTO',
  DATEDIFF (DAY,cast(AR.AccountReceivableDate  as date),GETDATE()) AS 'DIAS CARTERA',
  MA.Number 'CUENTA CONTABLE' ,MA.Name 'DESCRIPCION CUENTA',CAST(ARA.Balance AS NUMERIC) 'SALDO FACTURA/RECIBO',
  CASE WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) < 1 THEN '1. Sin Vencer'
			 WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) > 0 AND CAST(GETDATE() - AR.AccountReceivableDate AS INT) < 31 THEN '2. De 1 a 30 Dias'
			 WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) > 30 AND CAST(GETDATE() - AR.AccountReceivableDate AS INT) < 61 THEN '3. De 31 a 60 Dias'
			 WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) > 60 AND CAST(GETDATE() - AR.AccountReceivableDate AS INT) < 91 THEN '4. De 61 a 90 Dias'
			 WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) > 90 AND CAST(GETDATE() - AR.AccountReceivableDate AS INT) < 121 THEN '5. De 91 a 120 Dias'
			 WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) > 120 AND CAST(GETDATE() - AR.AccountReceivableDate AS INT) < 181 THEN '6. De 121 a 180 Dias'
			 WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) > 180 AND CAST(GETDATE() - AR.AccountReceivableDate AS INT) < 361 THEN '7. De 181 a 360 Dias'
			 WHEN CAST(GETDATE() - AR.AccountReceivableDate AS INT) > 360 THEN 'Mayor a 360 Dias' END AS 'EDAD CARTERA/RECIBO',TC.Descri 'ESTADO CUENTA',
			 CAST(I.InitialDate AS DATE) 'FECHA INGRESO',CAST(I.OutputDate AS DATE) 'FECHA EGRESO',I.TotalPatientSalesPrice 'VALOR CUOTA/COPAGO',
			 CASE TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END 'AMBITO',UNI.UFUDESCRI 'UNIDAD FUNCIONAL EGRESO',AR.AccountReceivableDate

  FROM Portfolio.AccountReceivable AS AR WITH (NOLOCK) -----   from Portfolio .AccountReceivable as AR
  INNER JOIN Portfolio.AccountReceivableAccounting AS ARA WITH (NOLOCK) ON ARA.AccountReceivableId =AR.Id  ----INNER JOIN Portfolio .AccountReceivableAccounting AS ARA ON ARA.AccountReceivableId =AR.Id
  INNER JOIN GeneralLedger .MainAccounts as MA WITH (NOLOCK) ON MA.Id =ARA.MainAccountId
  INNER JOIN REPORT.TempCartera AS TC WITH (NOLOCK) ON TC.Cuenta =MA.Number 
  INNER JOIN Common.ThirdParty AS TP WITH (NOLOCK) ON  AR.ThirdPartyId = TP.Id   ---- INNER JOIN Common .ThirdParty AS TP ON TP.Id =AR.ThirdPartyId
  LEFT JOIN  Billing .Invoice AS I WITH (NOLOCK) ON I.Id =AR.InvoiceId 
  LEFT JOIN  DBO.ADINGRESO AS ING WITH (NOLOCK) ON I.AdmissionNumber =ING.NUMINGRES 
  LEFT JOIN  DBO.INUNIFUNC AS UNI WITH (NOLOCK) ON UNI.UFUCODIGO= ISNULL(ING.UFUEGRMED,ISNULL(ING.UFUEGRHOS,ING.UFUCODIGO))
  LEFT JOIN  Contract .HealthAdministrator HA WITH (NOLOCK) ON HA.Id =I.HealthAdministratorId
  LEFT JOIN  Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
  
  where ARA.Balance <>0 --and ar.InvoiceNumber ='HSJS4333'
  --AND AR.AccountReceivableType =2
),

--SELECT * FROM CTE_FACTURACION_RADICACION 

CTE_RADICACION
AS
(
   SELECT rid.InvoiceNumber, MIN(ri.Id) Id, MIN(rid.RadicatedNumber) RadicatedNumber
   FROM Portfolio.RadicateInvoiceC ri WITH (NOLOCK)
   INNER JOIN Portfolio.RadicateInvoiceD rid WITH (NOLOCK) ON ri.Id = rid.RadicateInvoiceCId
   INNER JOIN CTE_FACTURACION_RADICACION AS FAC ON FAC.[FACTURA/RECIBO]  =RID.InvoiceNumber 
   WHERE rid.State <>'4'
   GROUP BY rid.InvoiceNumber
),

CTE_GLOSAS
AS
(
  SELECT  
  ISNULL(DG.ValueGlosado,0) AS 'VALOR GLOSADO', 
  DG.ValueAcceptedFirstInstance AS 'VALOR ACEPTADO 1 INST', 
  DG.ValueAcceptedSecondInstance AS 'VALOR ACEPTADO 2 INST', 
  DG.ValueAcceptedIPSconciliation AS 'VALOR ACEPTADO IPS CONCILIACION', 
  DG.ValueAcceptedEAPBconciliation AS 'VALOR ACEPTADO EAPB CONCILIACION', 
  DG.BalanceGlosa AS 'SALDO PENDIENTE CONCILIAR', 
  ar.Id 'IdCartera',
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
   Glosas.GlosaObjectionsReceptionC AS C ON G1.GlosaObjectionsReceptionCId = C.Id LEFT OUTER JOIN 
   Portfolio.AccountReceivable as ar  on ar.InvoiceNumber=dg.InvoiceNumber and ar.Balance>'0'
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
	 INNER JOIN Portfolio.AccountReceivable as ar  on ar.InvoiceNumber=DEV.InvoiceNumber and ar.Balance>'0'
	 --WHERE dev.InvoiceNumber ='IND19626'
     GROUP BY DEV.InvoiceNumber
	) AS G ON G.IdCabeceraDev =DEV.GlosaDevolutionsReceptionCId AND G.InvoiceNumber =DEV.InvoiceNumber 
	INNER JOIN Glosas.GlosaDevolutionsReceptionC AS cab ON cab.Id =dev.GlosaDevolutionsReceptionCId
	where cab.State<>'4'
),

CTE_SUMAS_NOTAS AS
(
	SELECT 
	F.InvoiceNumber,IIF(NC.Nature=1,ISNULL(SUM(FA.AdjusmentValue),0),0) 'AJUSTE DEBITO',IIF(NC.Nature=2,ISNULL(SUM(FA.AdjusmentValue),0),0) 'AJUSTE CREDITO',
	FA.AccountReceivableId,	f.Id IdFactura 
	FROM 
	Portfolio.PortfolioNote AS NC INNER JOIN 
	Portfolio.PortfolioNoteDetail AS ND ON NC.Id=ND.PortfolioNoteId INNER JOIN 
	Portfolio.PortfolioNoteAccountReceivableAdvance AS FA ON FA.PortfolioNoteId = NC.Id LEFT JOIN 
	Portfolio.AccountReceivable AS c ON c.Id = FA.AccountReceivableId LEFT JOIN 
	Billing.Invoice AS F ON F.InvoiceNumber = c.InvoiceNumber --LEFT JOIN 
	GROUP BY F.InvoiceNumber,NC.Nature,FA.AccountReceivableId ,f.Id
),

CTE_NOTAS AS
(
  SELECT AccountReceivableId,CAST(ISNULL(SUM([AJUSTE CREDITO]),0) AS numeric) AS [AJUSTE CREDITO],CAST(ISNULL(SUM([AJUSTE DEBITO]),0) AS NUMERIC) AS [AJUSTE DEBITO]
  FROM CTE_SUMAS_NOTAS
  GROUP BY AccountReceivableId
),

CTE_ANTICIPOS
AS
(
  SELECT 
  PTD.AccountReceivableId,
  --AR.InvoiceNumber 'FACTURA',
  SUM(PTD.Value) 'VALOR PAGOS A FACTURA' --PTD.PortfolioTrasferId ,
  FROM
  CTE_FACTURACION_RADICACION CAR INNER JOIN
  Portfolio.PortfolioTransferDetail PTD ON CAR.ID=PTD.AccountReceivableId INNER JOIN
  Portfolio.PortfolioTransfer AS CA ON PTD.PortfolioTrasferId = CA.Id /*IN V3*/ AND CA.Status=2 /*FN V3*/
  GROUP BY PTD.AccountReceivableId
 ),

CTE_CARTERA_DATO
 AS
 (
  SELECT FAC.Id,FAC.TIPO,FAC.[SALDO INICIAL],FAC.OBSERVACION ,FAC.NIT,FAC.CLIENTE,FAC.[CODIGO ENTIDAD],
  FAC.ENTIDAD,FAC.[GRUPO DE ATENCION] ,FAC.[TIPO REGIMEN],FAC.[ESTADO],FAC.[FACTURA/RECIBO],
  CAST(FAC.[VALOR FACTURA/ANTICIPO] AS NUMERIC) [VALOR FACTURA/ANTICIPO] ,
  FAC.[FECHA FACTURA/RECIBO],
  FAC.[FECHA VENCIMIENTO],FAC.[DIAS CARTERA],  FAC.[CUENTA CONTABLE],
  FAC.[DESCRIPCION CUENTA],CAST(FAC.[SALDO FACTURA/RECIBO] AS NUMERIC) [SALDO FACTURA/RECIBO],
  FAC.[EDAD CARTERA/RECIBO],FAC.[ESTADO CUENTA] ,
  RAD.RadicatedNumber 'NRO RADICADO',
  CAST(Ri.ConfirmDate AS DATE)  AS 'FECHA RADICADO',
  DATEDIFF (DAY,cast(RI.ConfirmDate  as date),GETDATE()) 'DIAS RADICADO',
  CASE WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) < 1THEN '1. Sin Vencer'
	   WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 0 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 31 THEN '2. De 1 a 30 Dias'
	   WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 30 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 61THEN '3. De 31 a 60 Dias'
	   WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 60 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 91 THEN '4. De 61 a 90 Dias'
	   WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 90 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 121 THEN '5. De 91 a 120 Dias'
	   WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 120 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 181 THEN '6. De 121 a 180 Dias'
	   WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 180 AND CAST(GETDATE() - RI.ConfirmDate AS INT) < 361 THEN '7. De 181 a 360 Dias'
	   WHEN CAST(GETDATE() - RI.ConfirmDate AS INT) > 360 THEN 'Mayor a 360 Dias'END AS 'EDAD RADICADO',FAC.[FECHA INGRESO] ,FAC.[FECHA EGRESO] ,[VALOR CUOTA/COPAGO],FAC.AMBITO,
  CAST(ISNULL(GLO. [VALOR GLOSADO],0) AS NUMERIC) [VALOR GLOSADO],CAST(ISNULL(GLO.[VALOR ACEPTADO 1 INST],0) AS NUMERIC) [VALOR ACEPTADO 1 INST] ,
  CAST(ISNULL(GLO.[VALOR ACEPTADO 2 INST],0) AS NUMERIC) [VALOR ACEPTADO 2 INST],CAST(ISNULL(GLO.[VALOR ACEPTADO EAPB CONCILIACION],0) AS NUMERIC) [VALOR ACEPTADO EAPB CONCILIACION],
  CAST(ISNULL(GLO.[VALOR ACEPTADO IPS CONCILIACION],0) AS NUMERIC) [VALOR ACEPTADO IPS CONCILIACION],CAST(ISNULL(GLO.[SALDO PENDIENTE CONCILIAR],0) AS NUMERIC) [SALDO PENDIENTE CONCILIAR],
  CAST(ISNULL(DEV.[VALOR DEVOLUCION],0) AS NUMERIC) [VALOR DEVOLUCION],ISNULL(NOTA.[AJUSTE CREDITO],0) [AJUSTE CREDITO] ,
  ISNULL(NOTA.[AJUSTE DEBITO],0) [AJUSTE DEBITO],
  --CAST(ISNULL(G.[VALOR PAGOS A FACTURA],0) AS NUMERIC) 'VALOR PAGOS A FACTURA/RECIBO'
 /*IN V2*/ ISNULL(RI.ConfirmDate,FAC.AccountReceivableDate) AS [FECHA DOCUMENTO CALCULADO] /*FN V2*/
 FROM CTE_FACTURACION_RADICACION FAC
 INNER JOIN Portfolio.AccountReceivable AS AC ON  AC.ID=FAC.ID
 LEFT JOIN CTE_RADICACION AS RAD ON RAD.InvoiceNumber =FAC.[FACTURA/RECIBO]  
 LEFT JOIN Portfolio.RadicateInvoiceC ri ON RAD.Id = ri.Id
 LEFT JOIN CTE_GLOSAS AS GLO ON GLO.IdCartera =FAC.Id
 LEFT JOIN CTE_DEVOLUCION AS DEV  ON DEV.InvoiceNumber =FAC.[FACTURA/RECIBO]
 LEFT JOIN CTE_NOTAS AS NOTA ON NOTA.AccountReceivableId =FAC.Id
 --WHERE FAC.[FACTURA/RECIBO] IN ('7166391','HSJS15967','7182201')
),

--SELECT * FROM CTE_CARTERA_DATO 

CTE_ANTICIPOS_NUEVO
AS
(
 
 SELECT PA.Id,'Anticipos' 'TIPO',CASE PA.OpeningBalance WHEN 1 THEN 'SI' ELSE 'NO' END 'SALDO INICIAL',PA.Observations 'OBSERVACION',TP.Nit 'NIT',TP.Name 'CLIENTE','' 'CODIGO ENTIDAD',
 TP.Name 'ENTIDAD','' 'GRUPO ATENCION','' 'TIPO REGIMEN',CASE  PA.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END 'ESTADO',PA.Code 'FACTURA/RECIBO',
 cast(PA.Value as numeric) 'VALOR FACTURA/ANTICIPO', 
 CAST(ISNULL(CR.DocumentDate,PA.DocumentDate)AS DATE) 'FECHA FACTURA/RECIBO',
 null 'FECHA VENCIMIENTO',0 'DIAS CARTERA', M.Number AS [CUENTA CONTABLE],
 M.Name AS 'DESCRIPCION CUENTA',-(CAST(PA.Balance AS NUMERIC)) AS 'SALDO FACTURA/RECIBO',
             CASE WHEN CAST(GETDATE() - PA.DocumentDate  AS INT) < 1 THEN '1. Sin Vencer'
			 WHEN CAST(GETDATE() - PA.DocumentDate AS INT) > 0 AND CAST(GETDATE() - PA.DocumentDate AS INT) < 31 THEN '2. De 1 a 30 Dias'
			 WHEN CAST(GETDATE() - PA.DocumentDate AS INT) > 30 AND CAST(GETDATE() - PA.DocumentDate AS INT) < 61 THEN '3. De 31 a 60 Dias'
			 WHEN CAST(GETDATE() - PA.DocumentDate AS INT) > 60 AND CAST(GETDATE() - PA.DocumentDate AS INT) < 91 THEN '4. De 61 a 90 Dias'
			 WHEN CAST(GETDATE() - PA.DocumentDate AS INT) > 90 AND CAST(GETDATE() - PA.DocumentDate AS INT) < 121 THEN '5. De 91 a 120 Dias'
			 WHEN CAST(GETDATE() - PA.DocumentDate AS INT) > 120 AND CAST(GETDATE() - PA.DocumentDate AS INT) < 181 THEN '6. De 121 a 180 Dias'
			 WHEN CAST(GETDATE() - PA.DocumentDate AS INT) > 180 AND CAST(GETDATE() - PA.DocumentDate AS INT) < 361 THEN '7. De 181 a 360 Dias'
			 WHEN CAST(GETDATE() - PA.DocumentDate AS INT) > 360 THEN 'Mayor a 360 Dias' END AS 'EDAD CARTERA/RECIBO','' 'ESTADO CUENTA','' 'NRO RADICADO', NULL 'FECHA RADICADO',
 0 'DIAS RADICADO', '' 'EDAD RADICADO',NULL 'FECHA INGRESO', NULL 'FECHA EGRESO',CAST(0 AS numeric ) 'VALOR CUOTA/COPAGO','' 'AMBITO',
 0 'VALOR GLOSADO', 0 'VALOR ACEPTADO 1 INST', 0 'VALOR ACEPTADO 2 INST', 0 'VALOR ACEPTADO EAPB CONCILIACION',0 'VALOR ACEPTADO IPS CONCILIACION', 0 'SALDO PENDIENTE CONCILIAR', 0 'VALOR DEVOLUCION',
 0 AS [AJUSTE CREDITO], 0 AS [AJUSTE DEBITO],--0 'VALOR PAGOS A FACTURA/RECIBO'
 /*IN V2*/ PA.DocumentDate AS [FECHA DOCUMENTO CALCULADO] /*FN V2*/
 FROM Portfolio.PortfolioAdvance  PA
 INNER JOIN Common.ThirdParty AS TP ON TP.Id =PA.ThirdPartyId
 LEFT JOIN GeneralLedger.MainAccounts M ON PA.MainAccountId=M.Id
 LEFT JOIN Treasury .CashReceipts AS CR ON PA.CashReceiptId =CR.Id 
 LEFT JOIN Treasury .CashReceiptDetails AS CRD ON CRD.Id =PA.CashReceiptDetailId 
 WHERE PA.Balance > 0 AND PA.Status <>3 --AND CRD.IdCashReceiptConcept in (2,8)--AND PA.CODE='0000039134'
)

SELECT * FROM CTE_CARTERA_DATO 
--WHERE [ESTADO CUENTA]='CobroJuridico1304'
UNION ALL
SELECT * FROM CTE_ANTICIPOS_NUEVO 
--WHERE [ESTADO CUENTA] ='CobroJuridico1304'

--SELECT SUM(FAC.[VALOR CUENTA] )
--FROM CTE_FACTURACION_RADICACION FAC
--LEFT JOIN CTE_RADICACION AS RAD ON RAD.InvoiceNumber =FAC.[NUMERO FACTURA]  
--LEFT JOIN Portfolio.RadicateInvoiceC ri ON RAD.Id = ri.Id
--LEFT JOIN CTE_GLOSAS AS GLO ON GLO.IdCartera =FAC.Id
--LEFT JOIN CTE_DEVOLUCION AS DEV  ON DEV.InvoiceNumber =FAC.[NUMERO FACTURA]
--WHERE FAC.[ESTADO CUENTA] ='CobroJuridico1304'



--select *  FROM Portfolio.AccountReceivable


--select * from Contract .HealthAdministrator 

--SELECT * FROM   Portfolio.PortfolioAdvance PA WHERE  PA.Balance > 0 AND PA.Status <>3


--SELECT * FROM Treasury.CashReceiptDetails

--SELECT * FROM Treasury .CashReceiptConcepts 
