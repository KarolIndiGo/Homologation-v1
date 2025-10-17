-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_INVENTARIO_AUDITORIA_COMPROBANTES_ENTRADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_INVENTARIO_AUDITORIA_COMPROBANTES_ENTRADA] 
@AÑO AS INT,
@MES AS INT
AS

--DECLARE @AÑO AS INT=2024;
--DECLARE @MES AS INT=3;

------******************************************************************************************************************************************************************-----
------------------------------------------------------------SEGMENTO COMPROBANTE DE ENTRADA ---------------------------------------------------------------------------------
------******************************************************************************************************************************************************************-----

----CONSULTA A LA TABLA DE KARDEX CON SOLO DOCUMENTOS TIPO EntranceVoucher TRAYENDO DATOS UNICOS------

WITH CTE_KARDEX_COMPROBANTES_ENTRADA
AS
(
    SELECT DISTINCT EntityId,EntityCode,EntityName,ID_CXP,[VALOR IVA],[CODIGO CXP],[NINGUNA],[ORDEN DE COMPRA],[CONTRATO],[REMISION ENTRADA],[REMISION EN CONSIGNACION]
     FROM
     (
     SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName ,AP.Id ID_CXP,AP.Code [CODIGO CXP],CASE EVD.EntranceSource WHEN 1 THEN 'NINGUNA'
      WHEN 2 THEN 'ORDEN DE COMPRA' WHEN  3 THEN 'CONTRATO' WHEN 4 THEN 'REMISION ENTRADA' WHEN  5 THEN 'REMISION EN CONSIGNACION' END 'ORIGEN','SI' 'VALOR',EV.ValueTax 'VALOR IVA'
      FROM Inventory .Kardex K
      INNER JOIN Payments.AccountPayable AS AP ON K.EntityId=AP.EntityId AND K.EntityCode=AP.EntityCode
      INNER JOIN Inventory .EntranceVoucher EV ON EV.ID=K.EntityId AND EV.CODE=K.EntityCode
      INNER JOIN Inventory .EntranceVoucherDetail AS EVD ON EV.ID=EVD.EntranceVoucherId 
     WHERE K.EntityName ='EntranceVoucher'  AND YEAR(k.DocumentDate)=@AÑO AND MONTH(k.DocumentDate)=@MES  --AND K.EntityCode='0100000654'
     ) AS SourceTable
    
    PIVOT  
     (MAX([VALOR])
         FOR [ORIGEN] In([NINGUNA],[ORDEN DE COMPRA],[CONTRATO],[REMISION ENTRADA],[REMISION EN CONSIGNACION])
     ) AS PVTTABLE  
),

----CONSULTA A LA TABLA DE KARDEX UNIENDO CON EL CTE DE COMPROBANTES UNICOS AGRUPANDO POR PRODUCTO------

CTE_DETALLE_KARDEX_COMPROBANTES_ENTRADA
AS
(
 SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',K.EntityId,K.EntityCode 'CODIGO',K.EntityCode,KOT.ID_CXP,KOT.[CODIGO CXP],
IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC),0) 'VALOR INVENTARIO',KOT.[NINGUNA],KOT.[ORDEN DE COMPRA],KOT.[CONTRATO],KOT.[REMISION ENTRADA],
KOT.[REMISION EN CONSIGNACION],KOT.[VALOR IVA] 
FROM Inventory.Kardex K
 INNER JOIN CTE_KARDEX_COMPROBANTES_ENTRADA AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
 WHERE K.EntityName ='EntranceVoucher' AND MovementType=1
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,KOT.ID_CXP,[CODIGO CXP],KOT.[NINGUNA],KOT.[ORDEN DE COMPRA],
 KOT.[CONTRATO],KOT.[REMISION ENTRADA],KOT.[REMISION EN CONSIGNACION],KOT.[VALOR IVA]
),

----CONSULTA A LA TABLA DE CONTABILIDAD UNIENDO CON EL CTE DE COMPROBANTES UNICOS DE KARDEX PARA TRAER LOS VALORES A NIVEL DE CONTABILIDAD AGRUPANDO POR PRODUCTO------

CTE_CONTABILIDAD_COMPROBANTE_ENTRADA
AS
(

  SELECT JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',JV.EntityId,JV.EntityCode,JV.EntityName,SUM(CAST(DebitValue AS NUMERIC)) 'VALOR DEBITO CONT',SUM(CAST(CreditValue AS NUMERIC)) 'VALOR CREDITO CONT'
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_KARDEX_COMPROBANTES_ENTRADA AS KOT ON KOT.ID_CXP=JV.EntityId AND KOT.[CODIGO CXP]=JV.EntityCode AND JV.EntityName='AccountPayable'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA  ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName--,ma.number,ma.name
),

------******************************************************************************************************************************************************************-----
------------------------------------------------------SEGMENTO DEVOLUCIONES COMPROBANTE DE ENTRADA --------------------------------------------------------------------------
------******************************************************************************************************************************************************************-----

----CONSULTA A LA TABLA DE KARDEX CON SOLO DOCUMENTOS TIPO EntranceVoucherDevolution TRAYENDO DATOS UNICOS------

CTE_KARDEX_COMPROBANTES_ENTRADA_DEVOLUCION
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,PN.ID ID_NOTA,PN.CODE 'CODIGO NOTA',EVD.ID ID_DEVO,EVD.CODE 'CODIGO DEV', EVD.ValueTax 'VALOR IVA'
FROM Inventory .Kardex K
INNER JOIN Inventory.EntranceVoucherDevolution EVD ON EVD.ID=K.EntityId AND EVD.CODE=EntityCode
INNER JOIN Payments.PaymentNotes as PN ON PN.Entitycode=EVD.Code and PN.EntityId= EVD.Id
WHERE K.EntityName ='EntranceVoucherDevolution' AND YEAR(k.DocumentDate)=@AÑO AND MONTH(k.DocumentDate)=@MES --AND K.EntityCode='009328'
),

----CONSULTA A LA TABLA DE KARDEX UNIENDO CON EL CTE DE COMPROBANTES DE DEVOLUCION UNICOS AGRUPANDO POR PRODUCTO------

CTE_DETALLE_KARDEX_COMPROBANTES_ENTRADA_DEVOLUCION
AS
(
 SELECT year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',K.EntityId,K.EntityCode 'CODIGO',K.EntityCode,ID_NOTA,KOT.[CODIGO NOTA],
IIF(K.MovementType=2,CAST(SUM(K.Quantity*K.PreviousCost) AS NUMERIC),0) 'VALOR INVENTARIO',KOT.[VALOR IVA]
FROM Inventory.Kardex K
 INNER JOIN CTE_KARDEX_COMPROBANTES_ENTRADA_DEVOLUCION AS KOT ON KOT.ID_DEVO=K.EntityId AND KOT.[CODIGO DEV]=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG ON PG.Id=PRO.ProductGroupId
 WHERE K.EntityName ='EntranceVoucherDevolution' AND MovementType=2
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,ID_NOTA,KOT.[CODIGO NOTA],KOT.[VALOR IVA]
),

----CONSULTA A LA TABLA DE CONTABILIDAD UNIENDO CON EL CTE DE COMPROBANTES UNICOS DE DEVOLUCION DE KARDEX PARA TRAER LOS VALORES A NIVEL DE CONTABILIDAD AGRUPANDO POR PRODUCTO------

CTE_CONTABILIDAD_COMPROBANTES_ENTRADA_DEVOLUCION
AS
(

  SELECT JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE', JV.EntityId,JV.EntityCode,JV.EntityName,isnull(SUM(CAST(DebitValue AS NUMERIC)),0) 'VALOR DEBITO CONT',isnull(SUM(CAST(CreditValue AS NUMERIC)),0) 'VALOR CREDITO CONT'
  --,ma.number 'CUENTA',  ma.name 'NOMBRE CUENTA' 
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_DETALLE_KARDEX_COMPROBANTES_ENTRADA_DEVOLUCION AS KOT ON KOT.ID_NOTA=JV.EntityId AND KOT.[CODIGO NOTA]=JV.EntityCode AND JV.EntityName='PaymentNotes'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA  ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name, JV.EntityId,JV.EntityCode,JV.EntityName--,ma.number,ma.name
)

------******************************************************************************************************************************************************************-----
------------------------------------------------------SEGMENTO CONSULTA DE VISUALIZACION DE DATOS --------------------------------------------------------------------------
------******************************************************************************************************************************************************************-----


SELECT 'COMPROBANTES ENTRADA' TIPO, K.AÑO,K.MES,K.DIA,K.[CODIGO] 'CODIGO COM/DEV',K.[VALOR INVENTARIO],K.[CODIGO CXP],K.[NINGUNA],K.[ORDEN DE COMPRA],K.[CONTRATO],
K.[REMISION ENTRADA],K.[REMISION EN CONSIGNACION],OT.[COMPROBANTE CONTABLE],OT.[TIPO COMPROBANTE],OT.[VALOR DEBITO CONT],OT.[VALOR CREDITO CONT],
K.[VALOR INVENTARIO]-OT.[VALOR CREDITO CONT] AS 'DIFERENCIA INV - CONT',K.[VALOR IVA]

FROM CTE_DETALLE_KARDEX_COMPROBANTES_ENTRADA K
LEFT JOIN CTE_CONTABILIDAD_COMPROBANTE_ENTRADA OT ON K.ID_CXP =OT.EntityId AND K.[CODIGO CXP]=OT.EntityCode
UNION ALL

SELECT 'DEVOLUCIONES COMPROBANTES ENTRADA' TIPO,K.AÑO,K.MES,K.DIA,K.[CODIGO] 'CODIGO COM/DEV',K.[VALOR INVENTARIO],K.[CODIGO NOTA],'','','','','',
OT.[COMPROBANTE CONTABLE],
OT.[TIPO COMPROBANTE],OT.[VALOR DEBITO CONT],OT.[VALOR CREDITO CONT],K.[VALOR INVENTARIO]-OT.[VALOR CREDITO CONT] AS 'DIFERENCIA INV - CONT',K.[VALOR IVA]

FROM CTE_DETALLE_KARDEX_COMPROBANTES_ENTRADA_DEVOLUCION K
LEFT JOIN CTE_CONTABILIDAD_COMPROBANTES_ENTRADA_DEVOLUCION OT ON K.ID_NOTA =OT.EntityId AND K.[CODIGO NOTA]=OT.EntityCode

