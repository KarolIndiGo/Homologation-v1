-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_ArchivoRecaudo
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre: [Report].[SP_ArchivoRecaudo]
Tipo:Procedimiento Almacenado
Observacion: Archivo de recaudo
Profesional: Nilsson Galindo
Fecha Creación:16-12-2024
Profesional revisión: 
Fecha Revisión:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico:Monica Elizabeth Valderrama
Fecha:04-02-2025
Observaciones: Se adiciona el campo PA.Observations [OBSERVACIONES]
               se reemplaza INNER por LEFT en la segunda línea del from estaba (INNER JOIN CTE_CRUCE_ANTICIPOS CA ON PA.Id=CA.PortfolioAdvanceId)
			   Se adiciona el CTE_REINTEGRO_ANTICIPOS 
			   Se adiciona (LEFT JOIN CTE_REINTEGRO_ANTICIPOS RA ON PA.ID = RA.PortfolioAdvanceId) en la última línea del from
--------------------------------------
Version 2
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/



CREATE PROCEDURE [Report].[SP_ArchivoRecaudo]
@FECHCORT DATE
AS

--DECLARE @FECHCORT DATE='2025-02-28';

WITH 
CTE_OTROS_CONCEPTOS AS
(
	SELECT 
	PT.PortfolioAdvanceId,
	SUM(PTF.VALUE) AS VALUE
	FROM
	Portfolio.PortfolioTransferOtherConcept PTF
	INNER JOIN Portfolio.PortfolioTransfer PT ON PTF.PortfolioTransferId=PT.Id
	WHERE CAST(PT.DocumentDate AS DATE)<=@FECHCORT
	GROUP BY PT.PortfolioAdvanceId
),

CTE_CRUCE_ANTICIPOS AS
(
	SELECT
	SUM(PTD.Value)AS BALANCE,
	PT.PortfolioAdvanceId
	FROM 
	Portfolio.PortfolioTransfer PT
	INNER JOIN Portfolio.PortfolioTransferDetail PTD ON PT.Id=PTD.PortfolioTrasferId
	WHERE PT.Status IN (2) AND CAST(PT.DocumentDate AS DATE)<=@FECHCORT --AND PTR.PortfolioAdvanceId='53692'
	GROUP BY PT.PortfolioAdvanceId
),
CTE_CRUCE_ANTICIPOS_REVERSADO  AS
(
	SELECT
	SUM(PTD.Value)AS BALANCE,
	PTR.PortfolioAdvanceId
	FROM 
	Portfolio.PortfolioTransfer PTR
	INNER JOIN Portfolio.PortfolioTransferDetail PTD ON PTR.Id=PTD.PortfolioTrasferId
	WHERE PTR.Status=4 AND CAST(PTR.DocumentDate AS DATE)<=@FECHCORT-- AND PTR.PortfolioAdvanceId='019192'
	GROUP BY PTR.PortfolioAdvanceId
),
CTE_CRUCE_REVERSADO  AS
(
	SELECT
	SUM(PTD.Value)AS BALANCE,
	PTR.PortfolioAdvanceId
	FROM 
	Portfolio.PortfolioTransfer PTR
	INNER JOIN Portfolio.PortfolioTransferDetail PTD ON PTR.Id=PTD.PortfolioTrasferId
	WHERE PTR.Status=4 AND CAST(PTR.Recersaldate AS DATE)<=@FECHCORT-- AND PTR.PortfolioAdvanceId='019192'
	GROUP BY PTR.PortfolioAdvanceId
),

CTE_REINTEGRO_ANTICIPOS AS   ---Se adiciona V1
(
 	SELECT
	SUM(TVTA.Value)AS BALANCE,
	TVTA.PortfolioAdvanceId
	FROM 
	Portfolio.PortfolioAdvance PA
	INNER JOIN Treasury.VoucherTransactionAdvance TVTA ON PA.ID = TVTA.PortfolioAdvanceId
	WHERE CAST(PA.DocumentDate AS DATE)<=@FECHCORT --AND PA.Code='CPD0000049456'
	GROUP BY TVTA.PortfolioAdvanceId
)

SELECT
PA.Id,
PA.Code AS [CODIGO ANTICIPO],
TER.Nit AS [NIT],
TER.Name AS [NOMBRE],
PA.DocumentDate AS [FECHA ANTICIPO],
PA.Value AS [VALOR ANTICIPO],
--ISNULL(RA.BALANCE1,0)+(CA.BALANCE-ISNULL(OC.VALUE,0)) AS CRUCE, ---Se Adiciona RA.Balance1 V1
--ISNULL(RA.BALANCE1,0)-(PA.VaLUE-(CA.BALANCE-ISNULL(OC.VALUE,0))) AS SALDO, ---Se Adiciona RA.Balance1 V1
IIF(CA.PortfolioAdvanceId IS NULL,0,CA.BALANCE-ISNULL(OC.VALUE,0))+ISNULL(RA.BALANCE,0)+IIF(TN.Code IS NULL,0,PA.VaLUE)+ISNULL(CAR.BALANCE,0)-ISNULL(REV.BALANCE,0) AS CRUCE, ---Se Adiciona RA.Balance1 V1
IIF(CA.PortfolioAdvanceId IS NULL,PA.VaLUE,PA.VaLUE-(CA.BALANCE-ISNULL(OC.VALUE,0)))-ISNULL(RA.BALANCE,0)-IIF(TN.Code IS NULL,0,PA.VaLUE)-ISNULL(CAR.BALANCE,0)+ISNULL(REV.BALANCE,0) AS SALDO, ---Se Adiciona RA.Balance1 V1
GLM.Number [CUENTA CONTABLE],
PA.Observations [OBSERVACIONES],  --Se adiciona campo V1
@FECHCORT AS [FECHA CORTE],
RA.BALANCE AS REINTEGRO,IIF(TN.Code IS NULL,0,PA.VaLUE) AS NOTAS,ISNULL(CAR.BALANCE,0) AS REVERSADO,CA.BALANCE AS CRUCE--,CAR.BALANCE AS REVERSADO
FROM
Portfolio.PortfolioAdvance PA
INNER JOIN Common.ThirdParty TER ON PA.ThirdPartyId=TER.Id
LEFT JOIN CTE_CRUCE_ANTICIPOS CA ON PA.Id=CA.PortfolioAdvanceId  -- se reemplaza INNER por LEFT  V1
LEFT JOIN CTE_OTROS_CONCEPTOS OC ON CA.PortfolioAdvanceId=OC.PortfolioAdvanceId
LEFT JOIN GeneralLedger.MainAccounts GLM ON PA.MainAccountId = GLM.Id
LEFT JOIN CTE_REINTEGRO_ANTICIPOS RA ON PA.ID = RA.PortfolioAdvanceId  ---se Adiciona línea completa V1
LEFT JOIN Treasury.TreasuryNote TN ON PA.CashReceiptId=TN.CashReceiptId AND TN.NoteType IN(4,7) AND CAST(TN.NoteDate AS DATE)<=@FECHCORT
LEFT JOIN CTE_CRUCE_ANTICIPOS_REVERSADO CAR ON PA.Id=CAR.PortfolioAdvanceId
LEFT JOIN CTE_CRUCE_REVERSADO REV ON PA.Id=REV.PortfolioAdvanceId
WHERE CAST(PA.DocumentDate AS DATE)<=@FECHCORT --and PA.Code='CPD0000050758'
--AND TER.Nit='1030702464'


--1013640438,1012466078
--SELECT * FROM Common.ThirdParty WHERE NIT='1006779952'
--SELECT * FROM Portfolio.PortfolioAdvance WHERE Code='CPD0000050758'
--SELECT * FROM Portfolio.PortfolioTransfer
--WHERE PA.id=53520

--select * from Portfolio.PortfolioAdvance where id=48372
----SELECT * FROM Portfolio.PortfolioTransferDetail
----SELECT * FROM Portfolio.AccountReceivable

--select *
--from Portfolio.PortfolioNoteAccountReceivableAdvance
--where portfolioAdvanceid=48372
 
 
--SELECT *
--from Treasury.VoucherTransactionAdvance
--WHERE portfolioAdvanceid=88874
 

