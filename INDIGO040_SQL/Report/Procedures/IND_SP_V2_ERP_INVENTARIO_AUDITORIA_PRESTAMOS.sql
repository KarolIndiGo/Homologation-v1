-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_INVENTARIO_AUDITORIA_PRESTAMOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE PROCEDURE [Report].[IND_SP_V2_ERP_INVENTARIO_AUDITORIA_PRESTAMOS] 
@AÑO AS INT,
@MES AS INT
AS


---****************************************************************************************************************************************-----
---************************************************PRESTAMOS DE MERCACIAS******************************************************************----
---*****************************************************************************************************************************************----

WITH CTE_KARDEX_PRESTAMOS
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName
 FROM Inventory .Kardex K
 WHERE K.EntityName ='LoanMerchandise' AND YEAR(k.DocumentDate)=@AÑO AND MONTH(k.DocumentDate)=@MES -- AND K.EntityCode='0300000106'
),

CTE_DETALLE_KARDEX_PRESTAMOS
AS
(
 SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',K.EntityId,K.EntityCode 'CODIGO',K.EntityCode,
IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.AverageCost) AS NUMERIC),0) 'VALOR INVENTARIO'  ---K.AverageCost  ,K.PreviousCost
FROM Inventory.Kardex K
 INNER JOIN CTE_KARDEX_PRESTAMOS AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
 WHERE K.EntityName ='LoanMerchandise' AND MovementType=1
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId
),

CTE_CONTABILIDAD_PRESTAMOS
AS
(

  SELECT JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',JV.EntityId,JV.EntityCode,JV.EntityName,SUM(CAST(DebitValue AS NUMERIC)) 'VALOR DEBITO CONT',SUM(CAST(CreditValue AS NUMERIC)) 'VALOR CREDITO CONT'
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_DETALLE_KARDEX_PRESTAMOS AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='LoanMerchandise'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA  ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName--,ma.number,ma.name
),

---***********************************************************************************************************************************************----
---*********************************SEGMENTO DEVOLUCIONES DE PRESTAMOS DE MERCANCIAS**************************************************************----
---***********************************************************************************************************************************************----

CTE_KARDEX_PRESTAMOS_DEVOLUCION
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName 
FROM Inventory .Kardex K
WHERE K.EntityName ='LoanMerchandiseDevolution' AND YEAR(k.DocumentDate)=@AÑO AND MONTH(k.DocumentDate)=@MES --AND K.EntityCode='009328'
),

CTE_DETALLE_KARDEX_PRESTAMOS_DEVOLUCION
AS
(
 SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',K.EntityId,K.EntityCode 'CODIGO',K.EntityCode,
IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.AverageCost) AS NUMERIC),0) 'VALOR INVENTARIO'
FROM Inventory.Kardex K
 INNER JOIN CTE_KARDEX_PRESTAMOS_DEVOLUCION AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
 WHERE K.EntityName ='LoanMerchandiseDevolution' AND MovementType=2
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId
),

CTE_CONTABILIDAD_PRESTAMOS_DEVOLUCION
AS
(

  SELECT JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE', JV.EntityId,JV.EntityCode,JV.EntityName,isnull(SUM(CAST(DebitValue AS NUMERIC)),0) 'VALOR DEBITO CONT',isnull(SUM(CAST(CreditValue AS NUMERIC)),0) 'VALOR CREDITO CONT'
  --,ma.number 'CUENTA',  ma.name 'NOMBRE CUENTA' 
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_DETALLE_KARDEX_PRESTAMOS_DEVOLUCION AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='LoanMerchandiseDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA  ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name, JV.EntityId,JV.EntityCode,JV.EntityName--,ma.number,ma.name
)

--SELECT * FROM CTE_CONTABILIDAD_COMPROBANTES_ENTRADA_DEVOLUCION


SELECT 'PRESTAMOS' TIPO, K.AÑO,K.MES,K.[CODIGO] 'CODIGO PRE/DEV',K.[VALOR INVENTARIO],OT.[COMPROBANTE CONTABLE],OT.[TIPO COMPROBANTE],
OT.[VALOR DEBITO CONT],OT.[VALOR CREDITO CONT],K.[VALOR INVENTARIO]-OT.[VALOR CREDITO CONT] AS 'DIFERENCIA INV - CONT'
FROM CTE_DETALLE_KARDEX_PRESTAMOS K
LEFT JOIN CTE_CONTABILIDAD_PRESTAMOS OT ON K.EntityId =OT.EntityId AND K.EntityCode=OT.EntityCode

UNION ALL

SELECT 'DEVOLUCIONES PRESTAMOS' TIPO,K.AÑO,K.MES,K.[CODIGO] 'CODIGO PRE/DEV',K.[VALOR INVENTARIO],OT.[COMPROBANTE CONTABLE],
OT.[TIPO COMPROBANTE],OT.[VALOR DEBITO CONT],OT.[VALOR CREDITO CONT],K.[VALOR INVENTARIO]-OT.[VALOR CREDITO CONT] AS 'DIFERENCIA INV - CONT'
FROM CTE_DETALLE_KARDEX_PRESTAMOS_DEVOLUCION K
LEFT JOIN CTE_CONTABILIDAD_PRESTAMOS_DEVOLUCION OT ON K.EntityId =OT.EntityId AND K.EntityCode=OT.EntityCode
