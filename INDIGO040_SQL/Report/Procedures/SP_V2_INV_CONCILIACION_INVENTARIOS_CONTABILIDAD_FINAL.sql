-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_V2_INV_CONCILIACION_INVENTARIOS_CONTABILIDAD_FINAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0


--CON CAMBIO ORDEN DE TRASLADO--

CREATE PROCEDURE [Report].[SP_V2_INV_CONCILIACION_INVENTARIOS_CONTABILIDAD_FINAL]

----************************************ EMPRESA: ODO  SCRIPT TOTAL MOVIMIENTOS *********************************---
@FECINI AS DATE,
@FECHFIN AS DATE

AS
--DECLARE @FECINI AS DATE='2024-06-01';
--DECLARE @FECHFIN AS DATE='2024-06-30';

---****************************************************************************************************************************************-----
---************************************************DISPENSACIONES FARMACEUTICAS*************************************************************----
---*****************************************************************************************************************************************----

WITH CTE_KARDEX_DISPENSACIONES
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='PharmaceuticalDispensing' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())
 ),

CTE_DETALLE_KARDEX_DISPENSACIONES
AS
(
 SELECT 'DISPENSACION FARMACEUTICA' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DISPENSACIONES AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) on apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='PharmaceuticalDispensing' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DISPENSACIONES
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'DISPENSACION FARMACEUTICA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DISPENSACIONES AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='PharmaceuticalDispensing'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION DISPENSACIONES FARMACEUTICAS*************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_DISPENSACIONES
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='PharmaceuticalDispensingDevolution' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())
),

CTE_DETALLE_KARDEX_DEVOLUCION_DISPENSACIONES
AS
(
 SELECT 'DEVOLUCION DISPENSACION FARMACEUTICA' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_DISPENSACIONES AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='PharmaceuticalDispensingDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DEVOLUCION_DISPENSACIONES
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'DEVOLUCION DISPENSACION FARMACEUTICA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2)))'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_KARDEX_DEVOLUCION_DISPENSACIONES AS KOT WITH (NOLOCK) ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='PharmaceuticalDispensingDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************AJUSTES DE INVENTARIOS ******************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_AJUSTES
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='InventoryAdjustment' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())-- AND K.EntityCode='0001868764'
),

CTE_DETALLE_KARDEX_AJUSTES
AS
(
 SELECT 'AJUSTE DE INVENTARIOS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_AJUSTES AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK)  ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='InventoryAdjustment' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_AJUSTES
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'AJUSTE DE INVENTARIOS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_AJUSTES AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='InventoryAdjustment'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK)  ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************* PRESTAMOS DE MERCANCIAS ***************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_PRESTAMOS
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='LoanMerchandise' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE()) -- AND K.EntityCode='0001868764'
),

CTE_DETALLE_KARDEX_PRESTAMOS
AS
(
 SELECT 'PRESTAMOS DE MERCANCIAS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_PRESTAMOS AS KOT WITH (NOLOCK) ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='LoanMerchandise' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_PRESTAMOS
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'PRESTAMOS DE MERCANCIAS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_PRESTAMOS AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='LoanMerchandise'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION DE PRESTAMOS DE MERCANCIAS****************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_PRESTAMOS
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,k.DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='LoanMerchandiseDevolution' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE()) -- AND K.EntityCode='PMA0000001923'
),

CTE_DETALLE_KARDEX_DEVOLUCION_PRESTAMOS
AS
(
 SELECT 'DEVOLUCION PRESTAMOS DE MERCANCIAS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_PRESTAMOS AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='LoanMerchandiseDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DEVOLUCION_PRESTAMOS
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO', 'DEVOLUCION PRESTAMOS DE MERCANCIAS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DEVOLUCION_PRESTAMOS AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='LoanMerchandiseDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---*************************************************** ORDENES DE TRASLADO *****************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_ORDENES_TRASLADO
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,
CASE TFO.OrderType WHEN 1 THEN 'Traslado' WHEN 2 THEN 'Consumo' WHEN 3 THEN 'Traslado en Transito' END 'TIPO ORDEN',
CASE TFO.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Entregado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'En Transito' END 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Inventory .TransferOrder TFO WITH (NOLOCK) ON TFO.ID=K.EntityId AND TFO.CODE=K.EntityCode
 WHERE K.EntityName ='TransferOrder' AND TFO.Status<> 3 AND TFO.OrderType<>3 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE()) 
 --AND K.EntityCode='MAN00100770'

 UNION ALL

 SELECT K.EntityId,K.EntityCode, K.EntityName,max(CAST(k.CreationDate AS DATE)) DocumentDate,'Traslado en Transito' AS 'TIPO ORDEN',
CASE TFO.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Entregado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'En Transito' END 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Inventory .TransferOrder TFO WITH (NOLOCK) ON TFO.ID=K.EntityId AND TFO.CODE=K.EntityCode
 WHERE K.EntityName ='TransferOrder' AND TFO.Status<> 3 AND TFO.OrderType=3 and k.MovementType=1 and CAST(k.CreationDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.CreationDate BETWEEN CAST(DATEFROMPARTS(@AÑO, @MES, 1) AS DATETIME) AND CAST(DATEADD(MINUTE, -6, COMMON.GETDATE()) AS DATETIME)
 --k.CreationDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE()) 
 --AND K.EntityCode='MAN00100770'
 group by K.EntityId,K.EntityCode, K.EntityName,TFO.Status

),

CTE_DETALLE_KARDEX_ORDENES_TRASLADO
AS
(
 SELECT 'ORDENES DE TRASLADO' 'TRANSACCION',year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.[TIPO ORDEN],KOT.[ESTADO],
 KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_ORDENES_TRASLADO AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='TransferOrder' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.[TIPO ORDEN],KOT.[ESTADO],KOT.DocumentDate
),

CTE_CONTABILIDAD_ORDENES_TRASLADO
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'ORDENES DE TRASLADO' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_ORDENES_TRASLADO AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='TransferOrder'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION DE ORDENES DE TRASLADO *******************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_ORDENES_TRASLADO
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,CASE TFO.OrderType WHEN 1 THEN 'Traslado' WHEN 2 THEN 'Consumo' WHEN 3 THEN 'Traslado en Transito' END 'TIPO ORDEN',
 CASE TFO.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Entregado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'En Transito' END 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Inventory .TransferOrderDevolution AS TOD WITH (NOLOCK) ON TOD.ID=K.EntityId AND TOD.CODE=EntityCode
INNER JOIN Inventory .TransferOrder TFO WITH (NOLOCK) ON TFO.ID=TOD.TransferOrderId 
 WHERE K.EntityName ='TransferOrderDevolution'AND TOD.Status<>3 AND TFO.OrderType<>2 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())-- AND K.EntityCode='PMA0000001923'
),

CTE_KARDEX_DEVOLUCION_ORDENES_TRASLADO_CONSUMO
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,CASE TFO.OrderType WHEN 1 THEN 'Traslado' WHEN 2 THEN 'Consumo' WHEN 3 THEN 'Traslado en Transito' END 'TIPO ORDEN',
 CASE TFO.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Entregado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'En Transito' END 'ESTADO',TFO.ID 'ID ORDEN TRASLADO',
 TFO.CODE 'CODIGO ORDEN',K.MovementType,K.AffectInventory
 FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN Inventory .TransferOrderDevolution AS TOD WITH (NOLOCK) ON TOD.ID=K.EntityId AND TOD.CODE=EntityCode
INNER JOIN Inventory .TransferOrder TFO WITH (NOLOCK) ON TFO.ID=TOD.TransferOrderId 
 WHERE K.EntityName ='TransferOrderDevolution'AND TOD.Status<>3 AND TFO.OrderType=2 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())
-- AND K.EntityCode='ALCH0000000050'
),

CTE_DETALLE_KARDEX_DEVOLUCION_ORDENES_TRASLADO
AS
(
 SELECT 'DEVOLUCION ORDENES DE TRASLADO' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.[TIPO ORDEN],KOT.[ESTADO],
 KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_ORDENES_TRASLADO AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK)  ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='TransferOrderDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.[TIPO ORDEN],KOT.[ESTADO],KOT.DocumentDate
),

CTE_DETALLE_KARDEX_DEVOLUCION_ORDENES_TRASLADO_CONSUMO
AS
(
 SELECT  'DEVOLUCION ORDENES DE TRASLADO' 'TRANSACCION',year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE KOT.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE WHEN VirtualStore = 1 THEN 'VIRTUAL' WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
 WHEN CustodyStore = 1 THEN 'CUSTODIA' WHEN TransitStore = 1 THEN 'TRANSITO' WHEN ControlStore = 1 THEN 'CONTROL' WHEN WareHouseType = 1 THEN 'REMANENTE'
 ELSE 'NINGUNO' END AS 'TIPO ALMACEN',
 IIF(KOT.MovementType=1,cast(SUM(todd.Quantity * tood.Value) as numeric(18,2)),0) 'TOTAL ENTRADAS', 
 IIF(Kot.MovementType=2,cast(SUM(todd.Quantity * tood.Value) as numeric(18,2)),0) 'TOTAL SALIDAS',
 CASE KOT.AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',KOT.EntityCode 'CODIGO DOCUMENTO',KOT.EntityId,KOT.[TIPO ORDEN],KOT.[ESTADO],
 KOT.DocumentDate 'FECHA BUSQUEDA'
  FROM    Inventory.TransferOrderDevolution tod WITH (NOLOCK)
        INNER JOIN CTE_KARDEX_DEVOLUCION_ORDENES_TRASLADO_CONSUMO AS KOT ON tod.ID=KOT.EntityId AND tod.CODE=KOT.EntityCode
        join Inventory.TransferOrderDevolutionDetail todd WITH (NOLOCK) on todd.TransferOrderDevolutionId = tod.Id
        join Inventory.TransferOrderDetailBatchSerial todbs WITH (NOLOCK) on todbs.Id = todd.TransferOrderDetailBatchSerialId
        join Inventory.TransferOrderDetail tood WITH (NOLOCK) on tood.Id = todbs.TransferOrderDetailId
        join Inventory.TransferOrder too WITH (NOLOCK) on too.Id = tood.TransferOrderId
        INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =tood.ProductId 
        INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK)  ON WH.Id =too.SourceWarehouseId
        INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
        INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
        INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
		WHERE KOT.EntityName ='TransferOrderDevolution' 
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),PG.CODE,PG.NAME,MA.Number,KOT.MovementType,WH.CODE,WH.NAME,VirtualStore,
  WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.AffectInventory,KOT.EntityCode,KOT.EntityId,KOT.[TIPO ORDEN],KOT.[ESTADO],KOT.DocumentDate
),

CTE_CONTABILIDAD_DEVOLUCION_ORDENES_TRASLADO
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO', 'DEVOLUCION ORDENES DE TRASLADO' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DEVOLUCION_ORDENES_TRASLADO AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='TransferOrderDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

CTE_CONTABILIDAD_DEVOLUCION_ORDENES_TRASLADO_CONSUMO
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO', 'DEVOLUCION ORDENES DE TRASLADO' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DEVOLUCION_ORDENES_TRASLADO_CONSUMO AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='TransferOrderDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---********************************************************************************************************************************************************-----
---********************************************************** COMPROBANTES DE ENTRADA **********************************************************************----
---*********************************************************************************************************************************************************----

CTE_KARDEX_COMPROBANTES_ENTRADA
AS
(
 SELECT DISTINCT K.EntityId,K.EntityCode,CAST(k.DocumentDate AS DATE) DocumentDate, K.EntityName ,AP.Id ID_CXP,AP.Code [CODIGO CXP],
 'SI' 'VALOR',EV.ValueTax 'VALOR IVA','Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Payments.AccountPayable AS AP WITH (NOLOCK) ON K.EntityId=AP.EntityId AND K.EntityCode=AP.EntityCode
 INNER JOIN Inventory.EntranceVoucher EV WITH (NOLOCK) ON EV.ID=K.EntityId AND EV.CODE=K.EntityCode
 INNER JOIN Inventory.EntranceVoucherDetail AS EVD WITH (NOLOCK) ON EV.ID=EVD.EntranceVoucherId
 WHERE K.EntityName ='EntranceVoucher' AND EV.Status<> 3 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE()) --AND K.EntityCode='MSGT0000000377'
),

CTE_DETALLE_KARDEX_COMPROBANTES_ENTRADA
AS
(
  SELECT 'COMPROBANTES DE ENTRADA' 'TRANSACCION',year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
  MA.Number 'CUENTA CONTABLE','ENTRADA' 'TIPO DE TRANSACCION', WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE WHEN VirtualStore = 1 THEN 'VIRTUAL' 
  WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION' WHEN CustodyStore = 1 THEN 'CUSTODIA' WHEN TransitStore = 1 THEN 'TRANSITO'WHEN ControlStore = 1 THEN 'CONTROL' 
  WHEN WareHouseType = 1 THEN 'REMANENTE'ELSE 'NINGUNO' END AS 'TIPO ALMACEN',
  CAST(SUM(EVD.TotalValue) AS NUMERIC(18,2)) 'TOTAL ENTRADAS', 0 'TOTAL SALIDAS',
  CASE EVD.EntranceSource WHEN 1 THEN 'Ninguna' WHEN 2 THEN 'Orden de Compra' WHEN  3 THEN 'Contrato' WHEN 4 THEN 'Remisión de Entrada' 
  WHEN  5 THEN 'Remisión en Consignación' END 'TIPO ORDEN','SI' 'AFECTA INVENTARIO',KOT.EntityCode 'CODIGO DOCUMENTO',
   KOT.EntityId,MA.ID IdCuenta,KOT.[ESTADO],KOT.[CODIGO CXP] 'CODIGO INTERNO',KOT.DocumentDate 'FECHA BUSQUEDA'
  FROM Inventory.EntranceVoucher EV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_COMPROBANTES_ENTRADA KOT ON KOT.EntityId=EV.Id AND KOT.EntityCode=EV.Code
  INNER JOIN Inventory.EntranceVoucherDetail AS EVD WITH (NOLOCK) ON EV.ID=EVD.EntranceVoucherId
  INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =EVD.ProductId 
  INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =EV.WarehouseId
  INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
  INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),PG.CODE,PG.NAME,MA.Number,WH.CODE,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,
  TransitStore,ControlStore,WareHouseType,EVD.EntranceSource,KOT.EntityCode,KOT.EntityId,MA.ID,KOT.[ESTADO],KOT.[CODIGO CXP],KOT.DocumentDate
),

CTE_DETALLE_KARDEX_RECLASIFICACION_REMISIONES
AS
(
  SELECT 'RECLASIFICACION REMISIONES' 'TRANSACCION',year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
  MA.Number 'CUENTA CONTABLE','ENTRADA' 'TIPO DE TRANSACCION', WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE WHEN VirtualStore = 1 THEN 'VIRTUAL' 
  WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION' WHEN CustodyStore = 1 THEN 'CUSTODIA' WHEN TransitStore = 1 THEN 'TRANSITO'WHEN ControlStore = 1 THEN 'CONTROL' 
  WHEN WareHouseType = 1 THEN 'REMANENTE'ELSE 'NINGUNO' END AS 'TIPO ALMACEN',
  0 'TOTAL ENTRADAS', 
  IIF(RED.IvaPercentage='0.00',SUM(CAST(EVD.Quantity*RED.UnitValue AS NUMERIC(18,2))),SUM(CAST((EVD.Quantity*RED.UnitValue)*((RED.IvaPercentage/100)+1) AS NUMERIC(28,2)))) 'TOTAL SALIDAS',  
  --CAST(SUM((EVD.Quantity*RED.LastValue)) AS NUMERIC(18,2)),CAST(SUM((EVD.Quantity*RED.LastValue)*((RED.IvaPercentage/100)+1))) AS NUMERIC(18,2)))) 'TOTAL SALIDAS',
  --CAST(SUM((EVD.Quantity*RED.LastValue)) AS NUMERIC(18,2)) 'TOTAL SALIDAS',


  CASE EVD.EntranceSource WHEN 1 THEN 'Ninguna' WHEN 2 THEN 'Orden de Compra' WHEN  3 THEN 'Contrato' WHEN 4 THEN 'Remisión de Entrada' 
  WHEN  5 THEN 'Remisión en Consignación' END 'TIPO ORDEN','SI' 'AFECTA INVENTARIO',KOT.EntityCode 'CODIGO DOCUMENTO',
   KOT.EntityId,MA.ID IdCuenta,KOT.[ESTADO],KOT.[CODIGO CXP] 'CODIGO INTERNO',KOT.DocumentDate 'FECHA BUSQUEDA'
  FROM Inventory.EntranceVoucher EV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_COMPROBANTES_ENTRADA KOT ON KOT.EntityId=EV.Id AND KOT.EntityCode=EV.Code
  INNER JOIN Inventory.EntranceVoucherDetail AS EVD WITH (NOLOCK) ON EV.ID=EVD.EntranceVoucherId
  --INNER JOIN Inventory.RemissionEntrance AS RE WITH (NOLOCK) ON RE.Code=EVD.SourceCode
  INNER JOIN Inventory.RemissionEntranceDetailBatchSerial AS REDBS WITH (NOLOCK) ON REDBS.Id=EVD.RemissionEntranceDetailBatchSerialId
  INNER JOIN Inventory.RemissionEntranceDetail as RED WITH (NOLOCK) ON RED.Id=REDBS.RemissionEntranceDetailId
  INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =RED.ProductId 
  INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =EV.WarehouseId
  INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
  INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
  WHERE EVD.EntranceSource=4
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),PG.CODE,PG.NAME,MA.Number,WH.CODE,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,
  TransitStore,ControlStore,WareHouseType,EVD.EntranceSource,KOT.EntityCode,KOT.EntityId,MA.ID,KOT.[ESTADO],KOT.[CODIGO CXP],KOT.DocumentDate,RED.IvaPercentage
),

CTE_CONTABILIDAD_COMPROBANTES_ENTRADA
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  KOT.EntityCode 'CODIGO DOCUMENTO',  'COMPROBANTES DE ENTRADA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',
  SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', 
  JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.[CODIGO CXP] 'CODIGO INTERNO',KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_COMPROBANTES_ENTRADA AS KOT ON KOT.ID_CXP=JV.EntityId AND KOT.[CODIGO CXP]=JV.EntityCode AND JV.EntityName='AccountPayable'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.EntityCode,KOT.[CODIGO CXP],KOT.DocumentDate,JV.ID
),

CTE_CONTABILIDAD_COMPROBANTES_RECLASIFICACION_REMISIONES
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  KOT.EntityCode 'CODIGO DOCUMENTO',  'RECLASIFICACION REMISIONES' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',
  SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', 
  JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.[CODIGO CXP] 'CODIGO INTERNO',KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_COMPROBANTES_ENTRADA AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='RemissionReclassification'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.EntityCode,KOT.[CODIGO CXP],KOT.DocumentDate,JV.ID
),

---*********************************************************************************************************************************************************----
---****************************************************** DEVOLUCION COMPROBANTES DE ENTRADA ***************************************************************----
---*********************************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_COMPROBANTES_ENTRADA
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode,CAST(k.DocumentDate AS DATE) DocumentDate, K.EntityName,PN.ID ID_NOTA,PN.CODE 'CODIGO NOTA',EVD.ID ID_DEVO,EVD.CODE 'CODIGO DEV', EVD.ValueTax 'VALOR IVA',
CASE EVD.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Inventory.EntranceVoucherDevolution EVD WITH (NOLOCK) ON EVD.ID=K.EntityId AND EVD.CODE=EntityCode
 INNER JOIN Payments.PaymentNotes as PN WITH (NOLOCK) ON PN.Entitycode=EVD.Code and PN.EntityId= EVD.Id
 WHERE K.EntityName ='EntranceVoucherDevolution'AND EVD.Status<>3 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())-- AND K.EntityCode='ACBA0000004270'
),

CTE_DETALLE_KARDEX_DEVOLUCION_COMPROBANTES_ENTRADA
AS
(
 SELECT 'DEVOLUCION DE COMPRAS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE WHEN VirtualStore = 1 THEN 'VIRTUAL' WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'WHEN TransitStore = 1 THEN 'TRANSITO'WHEN ControlStore = 1 THEN 'CONTROL'WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'END AS 'TIPO ALMACEN',
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,'Devoluciones en Compras' [TIPO ORDEN],
 KOT.[ESTADO],KOT.[CODIGO NOTA] 'CODIGO INTERNO',KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_COMPROBANTES_ENTRADA AS KOT ON KOT.ID_DEVO=K.EntityId AND KOT.[CODIGO DEV]=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='EntranceVoucherDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.[CODIGO NOTA],KOT.[ESTADO],KOT.DocumentDate
),

CTE_CONTABILIDAD_DEVOLUCION_COMPROBANTES_ENTRADA
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  KOT.EntityCode 'CODIGO DOCUMENTO', 'DEVOLUCION DE COMPRAS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',
  SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', KOT.[CODIGO NOTA] 'CODIGO INTERNO',
  JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DEVOLUCION_COMPROBANTES_ENTRADA AS KOT ON KOT.ID_NOTA=JV.EntityId AND KOT.[CODIGO NOTA]=JV.EntityCode AND JV.EntityName='PaymentNotes'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.EntityCode,KOT.[CODIGO NOTA],KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************ REMISIONES DE ENTRADA *************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_REMISIONES_ENTRADA
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='RemissionEntrance' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())-- AND K.EntityCode='MSGT0000000146'
),

CTE_DETALLE_KARDEX_REMISIONES_ENTRADA
AS
(
 SELECT  'REMISION DE ENTRADA' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_REMISIONES_ENTRADA AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='RemissionEntrance' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_REMISIONES_ENTRADA
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'REMISION DE ENTRADA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_REMISIONES_ENTRADA AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='RemissionEntrance'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK)  ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION REMISION DE ENTRADA *************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_REMISION_ENTRADA
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Inventory.RemissionDevolution AS RV WITH (NOLOCK) ON RV.Id=k.EntityId and RV.Code=K.EntityCode
 WHERE K.EntityName ='RemissionDevolution' AND RV.DevolutionType=1 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())  --AND K.EntityCode='MSGT0000000146'
),

CTE_DETALLE_KARDEX_DEVOLUCION_REMISION_ENTRADA
AS
(
 SELECT 'DEVOLUCION REMISION DE ENTRADA' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE WHEN VirtualStore = 1 THEN 'VIRTUAL' WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA' WHEN TransitStore = 1 THEN 'TRANSITO' WHEN ControlStore = 1 THEN 'CONTROL' WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_REMISION_ENTRADA AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='RemissionDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DEVOLUCION_REMISIONES_ENTRADA
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'DEVOLUCION REMISION DE ENTRADA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DEVOLUCION_REMISION_ENTRADA AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='RemissionEntranceDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---*****************************************REMISIONES DE INVENTARIO EN CONSIGNACION*********************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_REMISIONES_CONSIGNACION
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='ConsignmentInventoryRemission' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())  --AND K.EntityCode='ALCE0000000249'
),

CTE_DETALLE_KARDEX_REMISIONES_CONSIGNACION
AS
(
 SELECT  'REMISION DE INVENTARIO CONSIGNACION' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_REMISIONES_CONSIGNACION AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='ConsignmentInventoryRemission' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_REMISIONES_CONSIGNACION
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'REMISION DE INVENTARIO CONSIGNACION' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_REMISIONES_CONSIGNACION AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='ConsignmentInventoryRemission'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION REMISION DE INVENTARIO CONSIGNACION*********************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_REMISION_CONSIGNACION
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Inventory.RemissionDevolution AS RV WITH (NOLOCK) ON RV.Id=k.EntityId and RV.Code=K.EntityCode
 WHERE K.EntityName ='RemissionDevolution' AND RV.DevolutionType=3 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE()) -- AND K.EntityCode='PMCT0000000016'
),

CTE_DETALLE_KARDEX_DEVOLUCION_REMISION_CONSIGNACION
AS
(
 SELECT 'DEVOLUCION REMISION DE ENTRADA' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE WHEN VirtualStore = 1 THEN 'VIRTUAL' WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA' WHEN TransitStore = 1 THEN 'TRANSITO' WHEN ControlStore = 1 THEN 'CONTROL' WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_REMISION_CONSIGNACION AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='RemissionDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DEVOLUCION_REMISIONES_CONSIGNACION
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'DEVOLUCION REMISION DE ENTRADA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DEVOLUCION_REMISION_CONSIGNACION AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='ConsignmentInventoryRemissionDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************FACTURA DE PRODUCTOS *************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_FACTURA_PRODUCTOS
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='BasicBilling' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())
 ),

CTE_DETALLE_KARDEX_FACTURA_PRODUCTOS
AS
(
 SELECT 'FACTURA BASICA PRODUCTOS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_FACTURA_PRODUCTOS AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) on apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='BasicBilling' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_FACTURA_PRODUCTOS
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'FACTURA BASICA PRODUCTOS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_FACTURA_PRODUCTOS AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='BasicBilling'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION FACTURA BASICA PRODUCTOS*************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_FACTURA_PRODUCTOS
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='BasicBillingDevolution' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 --k.DocumentDate between '2024-06-01 00:00:00'and  DATEADD(MINUTE, -6, COMMON.GETDATE())
),

CTE_DETALLE_KARDEX_DEVOLUCION_FACTURA_PRODUCTOS
AS
(
 SELECT 'DEVOLUCION FACTURA BASICA PRODUCTOS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_FACTURA_PRODUCTOS AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='BasicBillingDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DEVOLUCION_FACTURA_PRODUCTOS
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'DEVOLUCION FACTURA BASICA PRODUCTOS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2)))'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_KARDEX_DEVOLUCION_FACTURA_PRODUCTOS AS KOT WITH (NOLOCK) ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='BasicBilling'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---**************************************************** REMISIONES DE SALIDA *************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_REMISIONES_SALIDA
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='RemissionOutput' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
),

CTE_DETALLE_KARDEX_REMISIONES_SALIDA
AS
(
 SELECT 'REMISION DE SALIDA' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_REMISIONES_SALIDA AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) on apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='RemissionOutput' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_REMISIONES_SALIDA
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'REMISION DE SALIDA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_REMISIONES_SALIDA AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='RemissionOutput'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION REMISION DE SALIDA *************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_REMISION_SALIDA
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 INNER JOIN Inventory.RemissionDevolution AS RV WITH (NOLOCK) ON RV.Id=k.EntityId and RV.Code=K.EntityCode
 WHERE K.EntityName ='RemissionDevolution' AND RV.DevolutionType=2 AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
),

CTE_DETALLE_KARDEX_DEVOLUCION_REMISION_SALIDA
AS
(
 SELECT 'DEVOLUCION REMISION DE SALIDA' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE WHEN VirtualStore = 1 THEN 'VIRTUAL' WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA' WHEN TransitStore = 1 THEN 'TRANSITO' WHEN ControlStore = 1 THEN 'CONTROL' WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_REMISION_SALIDA AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='RemissionDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DEVOLUCION_REMISIONES_SALIDA
AS
(

  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'DEVOLUCION REMISION DE ENTRADA' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DEVOLUCION_REMISION_SALIDA AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='RemissionOutputDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************ DOCUMENTO FACTURA DE PRODUCTOS V2 *************************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DOCUMENTO_FACTURA_PRODUCTOS
AS
(
SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='DocumentInvoiceProductSales' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
 ),

CTE_DETALLE_KARDEX_DOCUMENTO_FACTURA_PRODUCTOS
AS
(
 SELECT 'FACTURA BASICA PRODUCTOS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DOCUMENTO_FACTURA_PRODUCTOS AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) on apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='DocumentInvoiceProductSales' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DOCUMENTO_FACTURA_PRODUCTOS
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'FACTURA BASICA PRODUCTOS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2))) 'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN CTE_KARDEX_DOCUMENTO_FACTURA_PRODUCTOS AS KOT ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode AND JV.EntityName='DocumentInvoiceProductSales'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

---****************************************************************************************************************************************-----
---************************************************DEVOLUCION DOCUMENTO FACTURA BASICA PRODUCTOS************************************************----
---*****************************************************************************************************************************************----

CTE_KARDEX_DEVOLUCION_DOCUMENTO_FACTURA_PRODUCTOS
AS
(
 SELECT DISTINCT K.EntityId,K.EntityCode, K.EntityName,CAST(k.DocumentDate AS DATE) DocumentDate,'Confirmado' 'ESTADO'
 FROM Inventory .Kardex K WITH (NOLOCK)
 WHERE K.EntityName ='DocumentInvoiceProductSalesDevolution' AND CAST(K.DocumentDate AS DATE) BETWEEN @FECINI AND @FECHFIN
),

CTE_DETALLE_KARDEX_DEVOLUCION_DOCUMENTO_FACTURA_PRODUCTOS
AS
(
 SELECT 'DEVOLUCION FACTURA BASICA PRODUCTOS' 'TRANSACCION',year(K.DocumentDate) 'AÑO',month(K.DocumentDate) 'MES',DAY(K.DocumentDate) 'DIA',PG.CODE 'CODIGO GRUPO',PG.NAME 'GRUPO PRODUCTO',
 MA.Number 'CUENTA CONTABLE',CASE K.MovementType WHEN 1 THEN 'ENTRADA' WHEN 2 THEN 'SALIDA' END 'TIPO DE TRANSACCION',
 WH.CODE 'CODIGO ALMACEN', WH.NAME 'NOMBRE ALMACEN',CASE 
        WHEN VirtualStore = 1 THEN 'VIRTUAL' 
        WHEN WarehouseConsignment = 1 THEN 'CONSIGNACION'
        WHEN CustodyStore = 1 THEN 'CUSTODIA'
        WHEN TransitStore = 1 THEN 'TRANSITO'
        WHEN ControlStore = 1 THEN 'CONTROL'
        WHEN WareHouseType = 1 THEN 'REMANENTE'
        ELSE 'NINGUNO'
    END AS 'TIPO ALMACEN',KOT.[ESTADO],
 IIF(K.MovementType=1,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL ENTRADAS', IIF(K.MovementType=2,CAST(SUM(K.Quantity*k.Value) AS NUMERIC(18,2)),0) 'TOTAL SALIDAS',
 CASE AffectInventory WHEN 1 THEN 'SI' ELSE 'NO' END 'AFECTA INVENTARIO',K.EntityCode 'CODIGO DOCUMENTO',K.EntityCode,K.EntityId,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA'
FROM Inventory.Kardex K WITH (NOLOCK)
 INNER JOIN CTE_KARDEX_DEVOLUCION_DOCUMENTO_FACTURA_PRODUCTOS AS KOT ON KOT.EntityId=K.EntityId AND KOT.EntityCode=K.EntityCode
 INNER JOIN Inventory.InventoryProduct AS PRO WITH (NOLOCK) ON PRO.Id =K.ProductId 
 INNER JOIN Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id =K.WarehouseId
 INNER JOIN Inventory.ProductGroup AS PG WITH (NOLOCK) ON PG.Id=PRO.ProductGroupId
 INNER JOIN Payments.AccountPayableConcepts apc WITH (NOLOCK) ON apc.Id = PG.InventoryAccountPayableConceptId 
 INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=apc.IdAccount
 WHERE K.EntityName ='DocumentInvoiceProductSalesDevolution' 
 GROUP BY year(K.DocumentDate),month(K.DocumentDate),DAY(K.DocumentDate),K.EntityCode,K.MovementType,K.EntityId,PG.CODE,PG.NAME,MA.Number,K.MovementType,
 AffectInventory,MA.ID,WH.CODE ,WH.NAME,VirtualStore,WarehouseConsignment,CustodyStore,TransitStore,ControlStore,WareHouseType,KOT.DocumentDate,KOT.[ESTADO]
),

CTE_CONTABILIDAD_DEVOLUCION_DOCUMENTO_FACTURA_PRODUCTOS
AS
(
  SELECT year(KOT.DocumentDate) 'AÑO',month(KOT.DocumentDate) 'MES',DAY(KOT.DocumentDate) 'DIA',JV.CONSECUTIVE 'COMPROBANTE CONTABLE',JVT.Code +' - '+ JVT.Name 'TIPO COMPROBANTE',
  JV.EntityCode 'CODIGO DOCUMENTO',  'DEVOLUCION FACTURA BASICA PRODUCTOS' 'TRANSACCION',MA.NUMBER 'CUENTA CONTABILIDAD',SUM(CAST(DebitValue AS NUMERIC(18,2)))'VALOR DEBITO',
  SUM(CAST(CreditValue AS NUMERIC(18,2))) 'VALOR CREDITO', JV.EntityId,JV.EntityCode,JV.EntityName,MA.ID IdCuenta,KOT.DocumentDate 'FECHA BUSQUEDA','Confirmado' 'ESTADO',JV.ID 'ID COMPROBANTE'
  FROM GeneralLedger.JournalVouchers JV
  INNER JOIN CTE_KARDEX_DEVOLUCION_DOCUMENTO_FACTURA_PRODUCTOS AS KOT WITH (NOLOCK) ON KOT.EntityId=JV.EntityId AND KOT.EntityCode=JV.EntityCode 
  AND JV.EntityName='DocumentInvoiceProductSalesDevolution'
  INNER JOIN GeneralLedger.JournalVoucherDetails JVD WITH (NOLOCK) ON JVD.IdAccounting=JV.ID
  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.ID=JVD.IdMainAccount
  INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.ID= JV.IdJournalVoucher
  WHERE JV.LegalBookId=1
  GROUP BY year(KOT.DocumentDate),month(KOT.DocumentDate),DAY(KOT.DocumentDate),JV.CONSECUTIVE,JVT.Code +' - '+ JVT.Name,JV.EntityId,JV.EntityCode,JV.EntityName,
  MA.NUMBER,MA.ID,KOT.DocumentDate,JV.ID
),

CTE_DATOS_MOSTRAR
AS
(
------------------------------******************DISPENSACIONES Y DEVOLUCION DE DISPENSACIONES ***********************------------------------------

SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Dispensación Farmacéutica' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 'ID COMPROBANTE',000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DISPENSACIONES
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Dispensación Farmacéutica' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DISPENSACIONES
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,'Devolución Dispensación' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_DISPENSACIONES
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Devolución Dispensación' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_DISPENSACIONES
------------------------------**********************************************************************************************************------------------------------
UNION ALL
------------------------------************************ AJUSTES DE INVENTARIOS **********************************************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Ajuste' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_AJUSTES
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Ajuste' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_AJUSTES
------------------------------**********************************************************************************************************------------------------------
UNION ALL
------------------------------*********************************** PRESTAMOS *********************************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Prestamos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_PRESTAMOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Prestamos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA, [ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_PRESTAMOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,'Devolución de Prestamos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_PRESTAMOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Devolución de Prestamos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_PRESTAMOS
------------------------------**********************************************************************************************************------------------------------
UNION ALL
------------------------------************************** ORDENES DE TRASALDOS *****************************************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],[TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_ORDENES_TRASLADO
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Ordene de Traslado' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_ORDENES_TRASLADO
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,[TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_ORDENES_TRASLADO
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,[TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_ORDENES_TRASLADO_CONSUMO
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Ordene de Traslado' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_ORDENES_TRASLADO
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Ordene de Traslado' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_ORDENES_TRASLADO_CONSUMO
------------------------------************************************************** *****************************************************------------------------------
UNION ALL
------------------------------************************** COMPROBANTES DE ENTRADA *****************************************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],[TIPO ORDEN],[ESTADO],
[CODIGO INTERNO],[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_COMPROBANTES_ENTRADA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],[TIPO ORDEN],[ESTADO],
[CODIGO INTERNO],[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_RECLASIFICACION_REMISIONES
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Comprobante Entrada' [TIPO ORDEN],[ESTADO],
[CODIGO INTERNO],[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_COMPROBANTES_ENTRADA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Reclasificación remisión' [TIPO ORDEN],[ESTADO],
[CODIGO INTERNO],[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_COMPROBANTES_RECLASIFICACION_REMISIONES
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,[TIPO ORDEN],[ESTADO],
[CODIGO INTERNO],[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_COMPROBANTES_ENTRADA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Comprobante Entrada' [TIPO ORDEN],[ESTADO],
[CODIGO INTERNO],[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_COMPROBANTES_ENTRADA
------------------------------***************************************************************************************************------------------------------
UNION ALL
------------------------------**************************** REMISION DE ENTRADA ******************************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Remisión de Entrada' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_REMISIONES_ENTRADA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Remisión de Entrada' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_REMISIONES_ENTRADA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,'Devolución Remisión de Entrada' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_REMISION_ENTRADA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Devolución Remisión de Entrada' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_REMISIONES_ENTRADA
------------------------------***************************************************************************************************------------------------------
UNION ALL
------------------------------**************************** REMISION DE INVENTARIOS CONSIGNACION ***********************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Remisión Inventario Consignación' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_REMISIONES_CONSIGNACION
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Remisión Inventario Consignación' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA, [ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_REMISIONES_CONSIGNACION
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,'Devolución Remisión Inventario Consignación' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_REMISION_CONSIGNACION
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Devolución Remisión Inventario Consignación' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_REMISIONES_CONSIGNACION
------------------------------***************************************************************************************************------------------------------
UNION ALL
------------------------------**************************** FACTURA BASICA PRODUCTOS Y DEVOLUCIONES ***********************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Factura Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 'ID COMPROBANTE',000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_FACTURA_PRODUCTOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Factura Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_FACTURA_PRODUCTOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,'Devolución Factura Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_FACTURA_PRODUCTOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Devolución Factura Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_FACTURA_PRODUCTOS
------------------------------***************************************************************************************************------------------------------
UNION ALL
------------------------------**************************** REMISION DE SALIDA ******************************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Remisión de Salida' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_REMISIONES_SALIDA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Remisión de Salida' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_REMISIONES_SALIDA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,'Devolución Remisión de Salida' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_REMISION_SALIDA
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Devolución Remisión de Entrada' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_REMISIONES_SALIDA
------------------------------***************************************************************************************************------------------------------
UNION ALL
------------------------------**************************** FACTURA BASICA PRODUCTOS Y DEVOLUCIONES ***********************************------------------------------
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO],'Factura Documento Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 'ID COMPROBANTE',000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DOCUMENTO_FACTURA_PRODUCTOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Factura Documento Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DOCUMENTO_FACTURA_PRODUCTOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'INVENTARIOS' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],[CODIGO GRUPO],[GRUPO PRODUCTO],[CUENTA CONTABLE],[NOMBRE ALMACEN],[TIPO DE TRANSACCION],[TIPO ALMACEN],
[TOTAL ENTRADAS],[TOTAL SALIDAS] ,[AFECTA INVENTARIO],[CODIGO DOCUMENTO] ,'Devolución Factura Documento Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,000 [ID COMPROBANTE],000 [COMPROBANTE CONTABLE],'N/A' [TIPO COMPROBANTE]
FROM CTE_DETALLE_KARDEX_DEVOLUCION_DOCUMENTO_FACTURA_PRODUCTOS
UNION ALL
SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,'CONTABILIDAD' 'MODULO',[TRANSACCION],[AÑO],[MES],[DIA],'' [CODIGO GRUPO],'' [GRUPO PRODUCTO],[CUENTA CONTABILIDAD],'' [NOMBRE ALMACEN],
'' [TIPO DE TRANSACCION],'NINGUNO' [TIPO ALMACEN],[VALOR DEBITO],[VALOR CREDITO] ,'' [AFECTA INVENTARIO] ,[CODIGO DOCUMENTO],'Devolución Factura Documento Productos' [TIPO ORDEN],[ESTADO],
[CODIGO DOCUMENTO] 'CODIGO INTERNO',[FECHA BUSQUEDA],CONVERT(DATETIME,COMMON.GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUA,[ID COMPROBANTE],[COMPROBANTE CONTABLE],[TIPO COMPROBANTE]
FROM CTE_CONTABILIDAD_DEVOLUCION_DOCUMENTO_FACTURA_PRODUCTOS
)

SELECT * FROM CTE_DATOS_MOSTRAR
--WHERE [CODIGO DOCUMENTO]='MAN00098691'
