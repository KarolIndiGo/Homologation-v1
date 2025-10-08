-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_CXC_INFORME_CARTERA_FINAL_VS_ANTICIPOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.SP_CXC_INFORME_CARTERA_FINAL_VS_ANTICIPOS
AS

WITH
-- 1. TBL_CARTERA (reemplaza la tabla variable)
TBL_CARTERA AS (
    SELECT
        C.Id,
        CASE C.OpeningBalance WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END AS SALDO_INICIAL,
        CASE C.AccountReceivableType
            WHEN '1' THEN 'Factura Basica'
            WHEN '2' THEN 'Factura Salud'
            WHEN '3' THEN 'Impuestos'
            WHEN '4' THEN 'Pagarés'
            WHEN '5' THEN 'Acuerdos de Pago'
            WHEN '6' THEN 'Documento Pago CuotaModeradora'
            WHEN '7' THEN 'Factura Producto'
        END AS TIPO,
        ISNULL(ma1.Number, ISNULL(ma2.Number, ISNULL(ma3.Number, ISNULL(ma4.Number, ma5.Number)))) AS CODIGO_CUENTA,
        ISNULL(ma1.Name, ISNULL(ma2.Name, ISNULL(ma3.Name, ISNULL(ma4.Name, ma5.Name)))) AS CUENTA,
        C.InvoiceNumber AS FACTURA,
        CASE C.PortfolioStatus
            WHEN 1 THEN 'SIN RADICAR - EMITIDO'
            WHEN 2 THEN 'RADICADA SIN CONFIRMAR - ENVIADO'
            WHEN 3 THEN 'RADICADA'
            WHEN 4 THEN 'GLOSADA'
            WHEN 7 THEN 'CERTIFICADA PARCIAL'
            WHEN 8 THEN 'CERTIFICADA TOTAL'
            WHEN 14 THEN 'DEVOLUCION'
            WHEN 15 THEN 'CUENTA DIFICIL RECAUDO'
            WHEN 16 THEN 'COBRO JURIDICO'
        END AS ESTADO,
        CAST(C.AccountReceivableDate AS DATE) AS FECHA_FACTURA,
        CAST(C.ExpiredDate AS DATE) AS FECHA_VENCIMIENTO,
        DATEDIFF(DAY, CAST(C.AccountReceivableDate AS DATE), GETDATE()) AS DIAS_CARTERA,
        CASE
            WHEN DATEDIFF(DAY, C.AccountReceivableDate, GETDATE()) < 1 THEN '1. Sin Vencer'
            WHEN DATEDIFF(DAY, C.AccountReceivableDate, GETDATE()) BETWEEN 1 AND 30 THEN '2. De 1 a 30 Dias'
            WHEN DATEDIFF(DAY, C.AccountReceivableDate, GETDATE()) BETWEEN 31 AND 60 THEN '3. De 31 a 60 Dias'
            WHEN DATEDIFF(DAY, C.AccountReceivableDate, GETDATE()) BETWEEN 61 AND 90 THEN '4. De 61 a 90 Dias'
            WHEN DATEDIFF(DAY, C.AccountReceivableDate, GETDATE()) BETWEEN 91 AND 120 THEN '5. De 91 a 120 Dias'
            WHEN DATEDIFF(DAY, C.AccountReceivableDate, GETDATE()) BETWEEN 121 AND 180 THEN '6. De 121 a 180 Dias'
            WHEN DATEDIFF(DAY, C.AccountReceivableDate, GETDATE()) BETWEEN 181 AND 360 THEN '7. De 181 a 360 Dias'
            ELSE 'Mayor a 360 Dias'
        END AS EDAD_CARTERA,
        CASE WHEN TE.PersonType = 1 THEN '999' ELSE TE.Nit END AS NIT,
        TE.Name AS ENTIDAD,
        CG.Name AS GRUPO_ATENCION,
        C.Value AS VALOR_FACTURA,
        COALESCE(ACD.Balance, 0) AS SinRadicar1301,
        COALESCE(ACD2.Balance, 0) AS Radicada1302,
        COALESCE(ACD3.Balance, 0) AS Glosada1303,
        COALESCE(ACD4.Balance, 0) AS CobroJuridico1304,
        COALESCE(ACD5.Balance, 0) AS Conciliada1305,
        C.Balance AS SALDO_FACTURA
    FROM INDIGO036.Portfolio.AccountReceivable AS C
    INNER JOIN INDIGO036.Common.ThirdParty AS TE
        ON C.ThirdPartyId = TE.Id AND C.Status <> 3
    LEFT JOIN INDIGO036.Portfolio.AccountReceivableAccounting AS ACD
        INNER JOIN INDIGO036.GeneralLedger.MainAccounts ma1
            ON ACD.MainAccountId = ma1.Id
        INNER JOIN INDIGO036.Report.TempCartera TCV
            ON ACD.MainAccountId = TCV.IdCuenta AND TCV.Descri = 'SinRadicar1301'
        ON C.Id = ACD.AccountReceivableId
    LEFT JOIN INDIGO036.Portfolio.AccountReceivableAccounting AS ACD2
        INNER JOIN INDIGO036.GeneralLedger.MainAccounts ma2
            ON ma2.Id = ACD2.MainAccountId
        INNER JOIN INDIGO036.Report.TempCartera TCV2
            ON ACD2.MainAccountId = TCV2.IdCuenta AND TCV2.Descri = 'Radicada1302'
        ON C.Id = ACD2.AccountReceivableId
    LEFT JOIN INDIGO036.Portfolio.AccountReceivableAccounting AS ACD3
        INNER JOIN INDIGO036.GeneralLedger.MainAccounts ma3
            ON ma3.Id = ACD3.MainAccountId
        INNER JOIN INDIGO036.Report.TempCartera TCV3
            ON ACD3.MainAccountId = TCV3.IdCuenta AND TCV3.Descri = 'Glosada1303'
        ON C.Id = ACD3.AccountReceivableId
    LEFT JOIN INDIGO036.Portfolio.AccountReceivableAccounting AS ACD4
        INNER JOIN INDIGO036.GeneralLedger.MainAccounts ma4
            ON ma4.Id = ACD4.MainAccountId
        INNER JOIN INDIGO036.Report.TempCartera TCV4
            ON ACD4.MainAccountId = TCV4.IdCuenta AND TCV4.Descri = 'CobroJuridico1304'
        ON C.Id = ACD4.AccountReceivableId
    LEFT JOIN INDIGO036.Portfolio.AccountReceivableAccounting AS ACD5
        INNER JOIN INDIGO036.GeneralLedger.MainAccounts ma5
            ON ma5.Id = ACD5.MainAccountId
        INNER JOIN INDIGO036.Report.TempCartera TCV5
            ON ACD5.MainAccountId = TCV5.IdCuenta AND TCV5.Descri = 'Conciliada1305'
        ON C.Id = ACD5.AccountReceivableId
    LEFT JOIN INDIGO036.Contract.CareGroup CG
        ON C.CareGroupId = CG.Id
    WHERE
        C.AccountReceivableType IN (1, 2)
        AND C.Balance > 0
        AND TE.PersonType = 2
),

-- 2. CTE_RADICACION, CTE_GLOSAS, CTE_DEVOLUCION, CTE_ANTICIPOS, CTE_SUMAS_NOTAS, CTE_NOTAS...

CTE_RADICACION AS (
    SELECT rid.InvoiceNumber, MIN(ri.Id) AS Id, MIN(rid.RadicatedNumber) AS RadicatedNumber
    FROM INDIGO036.Portfolio.RadicateInvoiceC ri
    INNER JOIN INDIGO036.Portfolio.RadicateInvoiceD rid
        ON ri.Id = rid.RadicateInvoiceCId
    INNER JOIN TBL_CARTERA AS FAC
        ON FAC.FACTURA = rid.InvoiceNumber
    WHERE rid.State <> '4'
    GROUP BY rid.InvoiceNumber
),

CTE_GLOSAS AS (
    -- contenido tal como estaba, ajustado a alias sin espacios...
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
    INDIGO036.Glosas.GlosaPortfolioGlosada AS DG INNER JOIN
    (
        SELECT D.DocumentType, D.InvoiceNumber, D.GlosaObjectionsReceptionCId, D.PortfolioGlosaId
        FROM   INDIGO036.Glosas.GlosaObjectionsReceptionD AS D  INNER JOIN
        (SELECT MAX(GlosaObjectionsReceptionCId) AS GlosaObjectionsReceptionCId, PortfolioGlosaId, InvoiceNumber
        FROM   INDIGO036.Glosas.GlosaObjectionsReceptionD 
        GROUP BY PortfolioGlosaId, InvoiceNumber) AS G ON G.GlosaObjectionsReceptionCId = D.GlosaObjectionsReceptionCId AND D.InvoiceNumber = G.InvoiceNumber AND D.PortfolioGlosaId = G.PortfolioGlosaId
    ) AS G1 ON G1.PortfolioGlosaId = DG.Id INNER JOIN
    INDIGO036.Glosas.GlosaObjectionsReceptionC AS C ON G1.GlosaObjectionsReceptionCId = C.Id INNER JOIN
    INDIGO036.Common.Customer AS T  ON C.CustomerId = T.Id LEFT OUTER JOIN
    INDIGO036.Portfolio.AccountReceivable as ar  on ar.InvoiceNumber=DG.InvoiceNumber and ar.Balance>'0' --left outer join
    WHERE (C.State <> 4) AND (DG.BalanceGlosa <> '0')  and ar.Balance>'0'
),

CTE_DEVOLUCION AS (
    -- igual...
    SELECT DEV.InvoiceNumber ,DEV.BalanceInvoice 'VALOR DEVOLUCION' ,CASE cab.State WHEN  1 THEN 'DEVOLUCION SIN CONFIRMAR'
    WHEN 2 THEN 'DEVOLUCION CONFIRMADO RADICADO' WHEN 3 THEN 'DEVOLUCION OFICIO CON RESPUESTA ENVIADA' WHEN 4 THEN 'ANULADO' END 'ESTADO DEVOLUCION'
    FROM INDIGO036.Glosas.GlosaDevolutionsReceptionD DEV 
    INNER JOIN
        (SELECT max(DEV.GlosaDevolutionsReceptionCId) IdCabeceraDev,DEV.InvoiceNumber 
    FROM INDIGO036.Glosas.GlosaDevolutionsReceptionD DEV
    GROUP BY DEV.InvoiceNumber
        ) AS G ON G.IdCabeceraDev =DEV.GlosaDevolutionsReceptionCId AND G.InvoiceNumber =DEV.InvoiceNumber 
        INNER JOIN INDIGO036.Glosas.GlosaDevolutionsReceptionC AS cab ON cab.Id =DEV.GlosaDevolutionsReceptionCId
        where cab.State<>'4'
),

CTE_ANTICIPOS AS (
    SELECT
        PTD.AccountReceivableId,
        SUM(PTD.Value) AS VALOR_PAGOS_A_FACTURA
    FROM TBL_CARTERA CAR
    INNER JOIN INDIGO036.Portfolio.PortfolioTransferDetail PTD
        ON CAR.Id = PTD.AccountReceivableId
    INNER JOIN INDIGO036.Portfolio.PortfolioTransfer CA
        ON PTD.PortfolioTrasferId = CA.Id AND CA.Status = 2
    GROUP BY PTD.AccountReceivableId
),

CTE_SUMAS_NOTAS AS (
    -- igual...
    SELECT 
    F.InvoiceNumber,
    IIF(NC.Nature=1,ISNULL(SUM(FA.AdjusmentValue),0),0) 'AJUSTE DEBITO',
    IIF(NC.Nature=2,ISNULL(SUM(FA.AdjusmentValue),0),0) 'AJUSTE CREDITO',
    FA.AccountReceivableId,
    F.Id IdFactura 
    FROM 
    INDIGO036.Portfolio.PortfolioNote AS NC INNER JOIN 
    INDIGO036.Portfolio.PortfolioNoteDetail AS ND ON NC.Id=ND.PortfolioNoteId INNER JOIN 
    INDIGO036.Portfolio.PortfolioNoteAccountReceivableAdvance AS FA ON FA.PortfolioNoteId = NC.Id LEFT JOIN 
    INDIGO036.Portfolio.AccountReceivable AS c ON c.Id = FA.AccountReceivableId LEFT JOIN 
    INDIGO036.Billing.Invoice AS F ON F.InvoiceNumber = c.InvoiceNumber --LEFT JOIN 
    GROUP BY F.InvoiceNumber,NC.Nature,FA.AccountReceivableId ,F.Id
),

CTE_NOTAS AS (
    SELECT
        AccountReceivableId,
        SUM([AJUSTE CREDITO]) AS AJUSTE_CREDITO,
        SUM([AJUSTE DEBITO]) AS AJUSTE_DEBITO
    FROM CTE_SUMAS_NOTAS
    GROUP BY AccountReceivableId
),

CTE_CARTERA_DATO AS (
    -- igual...
    SELECT 
    CAR.SALDO_INICIAL,
    CAR.TIPO ,
    CAR.FACTURA 'FACTURA/RECIBO',
    CAR.ESTADO,
    CAR.CODIGO_CUENTA,
    CAR.CUENTA,
    IIF(DEV.[VALOR DEVOLUCION]>0,DEV.[ESTADO DEVOLUCION],GLO.[ESTADO GLOSA] ) 'ESTADO GLOSA-DEVOLUCION' ,
    CAR.FECHA_FACTURA 'FECHA FACTURA/RECIBO',CAR.FECHA_VENCIMIENTO, RAD.RadicatedNumber 'NRO RADICADO',CAST(RI.ConfirmDate AS DATE)  AS 'FECHA RADICADO',CAR.DIAS_CARTERA,
    CAR.EDAD_CARTERA,DATEDIFF (DAY,cast(RI.ConfirmDate  as date),GETDATE()) 'DIAS RADICADO',
    CASE 
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) < 1 THEN '1. Sin Vencer'
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) BETWEEN 1 AND 30 THEN '2. De 1 a 30 Días'
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) BETWEEN 31 AND 60 THEN '3. De 31 a 60 Días'
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) BETWEEN 61 AND 90 THEN '4. De 61 a 90 Días'
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) BETWEEN 91 AND 120 THEN '5. De 91 a 120 Días'
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) BETWEEN 121 AND 180 THEN '6. De 121 a 180 Días'
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) BETWEEN 181 AND 360 THEN '7. De 181 a 360 Días'
    WHEN DATEDIFF(DAY, RI.ConfirmDate, GETDATE()) > 360 THEN '8. Mayor a 360 Días'
    END AS [EDAD RADICADO],
    CAR.NIT,
    CAR.ENTIDAD,
    CAR.GRUPO_ATENCION,
    CAR.VALOR_FACTURA 'VALOR FACTURA/RECIBO' ,
    CAR.SinRadicar1301,CAR.Radicada1302 ,CAR.Glosada1303,CAR.CobroJuridico1304,CAR.Conciliada1305 ,
    ISNULL(GLO. [VALOR GLOSADO],0) [VALOR GLOSADO],ISNULL(GLO.[VALOR ACEPTADO 1 INST],0) [VALOR ACEPTADO 1 INST] ,ISNULL(GLO.[VALOR ACEPTADO 2 INST],0) [VALOR ACEPTADO 2 INST],
    ISNULL(GLO.[VALOR ACEPTADO EAPB CONCILIACION],0) [VALOR ACEPTADO EAPB CONCILIACION] ,ISNULL(GLO.[VALOR ACEPTADO IPS CONCILIACION],0) [VALOR ACEPTADO IPS CONCILIACION] ,
    ISNULL(GLO.[SALDO PENDIENTE CONCILIAR],0) [SALDO PENDIENTE CONCILIAR] , ISNULL(DEV.[VALOR DEVOLUCION],0) [VALOR DEVOLUCION],
    ISNULL(ANT.VALOR_PAGOS_A_FACTURA,0)'VALOR PAGOS A FACTURA/RECIBO',
    --ISNULL(NOTA.[VALOR NOTA],0) [VALOR NOTA],
    NOTA.[AJUSTE_CREDITO],
    NOTA.[AJUSTE_DEBITO],
    CAR.[SALDO_FACTURA] 'SALDO FACTURA/RECIBO'
    -- CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
    --into report.cxc
    FROM TBL_CARTERA CAR 
    LEFT JOIN CTE_RADICACION AS RAD ON RAD.InvoiceNumber =CAR.FACTURA
    LEFT JOIN INDIGO036.Portfolio.RadicateInvoiceC RI ON RAD.Id = RI.Id
    LEFT JOIN CTE_GLOSAS AS GLO ON GLO.IdCartera =CAR.Id
    LEFT JOIN CTE_DEVOLUCION AS DEV  ON DEV.InvoiceNumber =CAR.FACTURA
    LEFT JOIN CTE_ANTICIPOS ANT ON ANT.AccountReceivableId =CAR.Id
    LEFT JOIN CTE_NOTAS AS NOTA ON NOTA.AccountReceivableId =CAR.Id
),

CTE_ANTICIPOS_NUEVO AS (
    -- igual... 
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
    FROM INDIGO036.Portfolio.PortfolioAdvance  PA
    INNER JOIN INDIGO036.Common.ThirdParty AS TP ON TP.Id =PA.ThirdPartyId
    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts M ON PA.MainAccountId=M.Id
    LEFT JOIN INDIGO036.Treasury.CashReceipts AS CR ON PA.CashReceiptId =CR.Id 
    LEFT JOIN INDIGO036.Treasury.CashReceiptDetails AS CRD ON CRD.Id =PA.CashReceiptDetailId 
    WHERE PA.Balance > 0 AND PA.Status <>3 AND CRD.IdCashReceiptConcept in (2,8)
),

CTE_DISTRIBUCION_ANTICIPOS AS (
    -- igual...
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
    INDIGO036.Portfolio.PortfolioAdvance PA 
    LEFT JOIN INDIGO036.GeneralLedger.MainAccounts M ON PA.MainAccountId=M.Id
    LEFT JOIN INDIGO036.Common.Customer C ON PA.CustomerId=C.Id 
    LEFT JOIN INDIGO036.Portfolio.PortfolioNoteDistribution PND ON PA.Id=PND.PortfolioAdvanceId
    LEFT JOIN INDIGO036.Portfolio.PortfolioNote PN ON PND.PortfolioNoteId=PN.Id AND PN.NoteType=4
    where PA.Balance !='0.00'
)

-- 3. SELECT final, combinando los 3 sets
SELECT * FROM CTE_CARTERA_DATO
UNION ALL
SELECT * FROM CTE_ANTICIPOS_NUEVO
UNION ALL
SELECT * FROM CTE_DISTRIBUCION_ANTICIPOS;
