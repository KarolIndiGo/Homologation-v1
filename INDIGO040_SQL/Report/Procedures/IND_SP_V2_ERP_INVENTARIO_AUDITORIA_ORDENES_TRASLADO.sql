-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_INVENTARIO_AUDITORIA_ORDENES_TRASLADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE PROCEDURE [Report].[IND_SP_V2_ERP_INVENTARIO_AUDITORIA_ORDENES_TRASLADO] 
@AÑO AS INT,
@MES AS INT
AS

--DECLARE @AÑO AS INT=2024;
--DECLARE @MES AS INT= 2;

WITH CTE_KARDEX_ORDEN_TRASLADO
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName, CASE TFO.OrderType WHEN 1 THEN 'Traslado' WHEN 2 THEN 'Consumo' WHEN 3 THEN 'Traslado en Transito' END 'TIPO ORDEN'
FROM Inventory .Kardex K
INNER JOIN Inventory .TransferOrder TFO ON TFO.ID=K.EntityId AND TFO.CODE=K.EntityCode
WHERE K.EntityName ='TransferOrder' AND  YEAR(k.DocumentDate)=@AÑO AND MONTH(k.DocumentDate)=@MES  --K.EntityCode in ('002255','004403')
),

--SELECT * FROM CTE_KARDEX_ORDEN_TRASLADO

CTE_DETALLE_KARDEX_ORDENES_TRASLADO
AS
(

 SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',KOT.[TIPO ORDEN] ,K.EntityId,K.EntityCode 'ORDEN DE TRASLADO',K.EntityCode,
 CAST(SUM(K.Quantity*K.AverageCost) AS NUMERIC) 'VALOR INVENTARIO'--,IIF(K.MovementType=1,0,CAST(SUM(K.Quantity*K.AverageCost) AS NUMERIC)) 'CREDITO INV' 
 FROM Inventory.Kardex K
 INNER JOIN CTE_KARDEX_ORDEN_TRASLADO AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
  WHERE K.EntityName ='TransferOrder' AND KOT.[TIPO ORDEN]='Traslado' AND MovementType=1
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),KOT.[TIPO ORDEN],K.EntityCode,K.MovementType,K.EntityId

 UNION ALL

  SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',KOT.[TIPO ORDEN] ,K.EntityId,K.EntityCode 'ORDEN DE TRASLADO',K.EntityCode,
   CAST(SUM(K.Quantity*K.AverageCost) AS NUMERIC) 'VALOR INVENTARIO'--,IIF(K.MovementType=1,0,CAST(SUM(K.Quantity*K.AverageCost) AS NUMERIC)) 'CREDITO INV' 
   FROM Inventory.Kardex K
   INNER JOIN CTE_KARDEX_ORDEN_TRASLADO AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
   INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
   INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
   INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
  WHERE K.EntityName ='TransferOrder' AND KOT.[TIPO ORDEN]='Consumo' AND MovementType=2
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),KOT.[TIPO ORDEN],K.EntityCode,K.MovementType,K.EntityId
),

CTE_CONTABILIDAD_ORDEN_TRASLADO
AS
(

  SELECT JV.CONSECUTIVE 'CONSECUTIVO CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE', JV.EntityId,JV.EntityCode,JV.EntityName,SUM(CAST(DebitValue AS NUMERIC)) 'VALOR DEBITO CONT',SUM(CAST(CreditValue AS NUMERIC)) 'VALOR CREDITO CONT'
  --,ma.number 'CUENTA',  ma.name 'NOMBRE CUENTA' 
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_KARDEX_ORDEN_TRASLADO AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND KOT.EntityName=JV.EntityName
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA  ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JVT.ID= JV.IdJournalVoucher
  GROUP BY JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName--,ma.number,ma.name
),
-------***********************************************************************------
-------*************SEGMENTO DEVOLUCIONES DE ORDENES DE TRASLADO**************------
-------***********************************************************************------

CTE_KARDEX_ORDEN_TRASLADO_DEVOLUTIVO
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName ,CASE TFO.OrderType WHEN 1 THEN 'Traslado' WHEN 2 THEN 'Consumo' WHEN 3 THEN 'Traslado en Transito' END 'TIPO ORDEN',
TFO.CODE 'CODIGO ORDEN TRASLADO'
FROM Inventory .Kardex K
INNER JOIN Inventory .TransferOrderDevolution AS TOD ON TOD.ID=K.EntityId AND TOD.CODE=EntityCode
INNER JOIN Inventory .TransferOrder TFO ON TFO.ID=TOD.TransferOrderId 
WHERE K.EntityName ='TransferOrderDevolution' AND YEAR(k.DocumentDate)=@AÑO AND MONTH(k.DocumentDate)=@MES --AND K.EntityCode='009328'
),

CTE_DETALLE_KARDEX_DEVOLUCION_ORDENES_TRASLADO
AS
(
 SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',KOT.[TIPO ORDEN],K.EntityId,K.EntityCode 'CODIGO',K.EntityCode,
 CAST(SUM(K.Quantity*K.AverageCost) AS NUMERIC) 'VALOR INVENTARIO',KOT.[CODIGO ORDEN TRASLADO]
FROM Inventory.Kardex K
 INNER JOIN CTE_KARDEX_ORDEN_TRASLADO_DEVOLUTIVO AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
 WHERE K.EntityName ='TransferOrderDevolution' --AND MovementType=1
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),KOT.[TIPO ORDEN],K.EntityCode,K.MovementType,K.EntityId,KOT.[CODIGO ORDEN TRASLADO]
),

CTE_CONTABILIDAD_ORDEN_TRASLADO_DEVOLUTIVO
AS
(

  SELECT JV.CONSECUTIVE 'CONSECUTIVO CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE', JV.EntityId,JV.EntityCode,JV.EntityName,isnull(SUM(CAST(DebitValue AS NUMERIC)),0) 'VALOR DEBITO CONT',isnull(SUM(CAST(CreditValue AS NUMERIC)),0) 'VALOR CREDITO CONT'
  --,ma.number 'CUENTA',  ma.name 'NOMBRE CUENTA' 
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_KARDEX_ORDEN_TRASLADO_DEVOLUTIVO AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode --AND KOT.EntityName=JV.EntityName
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA  ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JVT.ID= JV.IdJournalVoucher
  GROUP BY JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName--,ma.number,ma.name
)

----**************************************************************************************------
---------------------------- CONSULTAS DE VISUALIZACION-----------------------------------------
----**************************************************************************************------


SELECT 'ORDENES DE TRASLADO' TIPO,K.AÑO,K.MES,K.DIA ,k.[TIPO ORDEN],K.[ORDEN DE TRASLADO] 'CODIGO ORD/DEV',K.[ORDEN DE TRASLADO],K.[VALOR INVENTARIO], OT.[CONSECUTIVO CONTABLE], 
OT.[TIPO COMPROBANTE],OT.[VALOR DEBITO CONT],OT.[VALOR CREDITO CONT],K.[VALOR INVENTARIO]-OT.[VALOR CREDITO CONT] 'DIFERENCIA INV - CONT'
 FROM CTE_DETALLE_KARDEX_ORDENES_TRASLADO K
 LEFT JOIN CTE_CONTABILIDAD_ORDEN_TRASLADO OT ON K.EntityId =OT.EntityId AND K.EntityCode=OT.EntityCode
UNION ALL
SELECT 'DEVOLUCIONES ORDENES DE TRASLADO' TIPO,K.AÑO,K.MES,K.DIA,k.[TIPO ORDEN],K.[CODIGO] 'CODIGO ORD/DEV',K.[CODIGO ORDEN TRASLADO],K.[VALOR INVENTARIO],OT.[CONSECUTIVO CONTABLE], 
OT.[TIPO COMPROBANTE],OT.[VALOR DEBITO CONT],OT.[VALOR CREDITO CONT], K.[VALOR INVENTARIO]-OT.[VALOR CREDITO CONT] 'DIFERENCIA INV - CONT'
 FROM CTE_DETALLE_KARDEX_DEVOLUCION_ORDENES_TRASLADO K
 LEFT JOIN CTE_CONTABILIDAD_ORDEN_TRASLADO_DEVOLUTIVO OT ON K.EntityId =OT.EntityId AND K.EntityCode=OT.EntityCode