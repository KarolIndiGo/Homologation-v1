-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_INVENTARIO_AUDITORIA_AJUSTES
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_INVENTARIO_AUDITORIA_AJUSTES] 
@AÑO AS INT,
@MES AS INT
AS

---****************************************************************************************************************************************-----
---************************************************AJUSTES DE INVENTARIOS******************************************************************----
---*****************************************************************************************************************************************----

WITH CTE_KARDEX_AJUSTE
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName--,case K.MovementType when 1 then 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO MOVIMIENTO'
 FROM Inventory .Kardex K
 WHERE K.EntityName ='InventoryAdjustment' and YEAR(k.DocumentDate)=@AÑO AND MONTH(k.DocumentDate)=@MES -- AND K.EntityCode='0300000106'
),

CTE_DETALLE_KARDEX_AJUSTE
AS
(
 SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',K.EntityId,K.EntityCode 'CODIGO',K.EntityCode,
 CAST(SUM(K.Quantity*k.AverageCost) AS NUMERIC) 'VALOR INVENTARIO' --,KOT.[TIPO MOVIMIENTO] ---K.AverageCost  ,K.PreviousCost
FROM Inventory.Kardex K
 INNER JOIN CTE_KARDEX_AJUSTE AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
 WHERE K.EntityName ='InventoryAdjustment' --AND MovementType=1
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.EntityId
),

CTE_CONTABILIDAD_AJUSTE
AS
(

  SELECT JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',JV.EntityId,JV.EntityCode,JV.EntityName,SUM(CAST(DebitValue AS NUMERIC)) 'VALOR DEBITO CONT',SUM(CAST(CreditValue AS NUMERIC)) 'VALOR CREDITO CONT'
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_DETALLE_KARDEX_AJUSTE AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='InventoryAdjustment'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA  ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName--,ma.number,ma.name
)

SELECT 'AJUSTES' TIPO, K.AÑO,K.MES,K.DIA,K.[CODIGO] 'CODIGO AJUSTE',K.[VALOR INVENTARIO],OT.[COMPROBANTE CONTABLE],OT.[TIPO COMPROBANTE],
OT.[VALOR DEBITO CONT],OT.[VALOR CREDITO CONT],K.[VALOR INVENTARIO]-OT.[VALOR CREDITO CONT] AS 'DIFERENCIA INV - CONT'
FROM CTE_DETALLE_KARDEX_AJUSTE K
LEFT JOIN CTE_CONTABILIDAD_AJUSTE OT ON K.EntityId =OT.EntityId AND K.EntityCode=OT.EntityCode

