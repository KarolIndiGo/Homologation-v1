-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_SaldoAlmacenes
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_SaldoAlmacenes]
AS
SELECT PRO.Code
          AS Codigo,
       PRO.Name
          AS Producto,
       CASE TPRO.Id
          WHEN 1 THEN 'MEDICAMENTO'
          WHEN 2 THEN 'DISPOSITIVO MÉDICO'
          WHEN 3 THEN 'ELEMENTO DE CONSUMO'
          WHEN 4 THEN 'ALIMENTACION ESPECIAL'
          WHEN 5 THEN 'LABORATORIO CLINICO'
          WHEN 6 THEN 'MATERIAL DE OSTEOSINTESIS'
          WHEN 7 THEN 'LITOGRAFIA'
          WHEN 9 THEN 'EQUIPO BIOMEDICO'
          WHEN 10 THEN 'SERVICIO CONECTIVIDAD'
       END
          AS [Tipo de Producto],
       PRO.ATCId
          AS [Codigo ATC],
       PRO.CodeCUM
          AS [C.U.M],
       PRO.CodeAlternative
          AS [Codigo Alterno],
       PRO.CodeAlternativeTwo
          AS [Codigo Alterno 2],
       SUB.Name
          AS SubGrupo,
       EMP.Name
          AS Unidad,
       GFAC.Name
          [Grupo de Facturacion],
       CASE PRO.ProductControl WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END
          AS [Producto Control],
       PRO.ProductCost
          AS [Costo Promedio],
       PRO.FinalProductCost
          AS [Ultimo Costo],
       CASE PRO.Status WHEN 0 THEN 'INACTIVO' WHEN 1 THEN 'ACTIVADO' END
          AS Estado,
       CAN.Quantity
          AS Cantidad,
       PRO.ProductCost * CAN.Quantity
          AS [Valor Total],
       ALM.Id
          AS [Id Almacen],
       ALM.Code
          AS [Codigo de Almacen],
       ALM.Name
          AS Almacen,
       ALM.Prefix
          AS Prefijo,
       (SELECT max (Fecha)
        FROM ViewInternal.FQ45_INN_Kardex
        WHERE [Codigo del Producto] = PRO.Code AND [id Almacen] = ALM.id) as [Fecha_ultmov]
FROM Inventory.InventoryProduct PRO
     INNER JOIN Inventory.ProductType TPRO
        ON PRO.ProductTypeId = TPRO.Id
     INNER JOIN Inventory.ProductSubGroup SUB
        ON PRO.ProductSubGroupId = SUB.Id
     INNER JOIN Inventory.PackagingUnit EMP
        ON PRO.PackagingUnitId = EMP.Id
     INNER JOIN Billing.BillingGroup GFAC
        ON PRO.BillingGroupId = GFAC.Id
     INNER JOIN Inventory.PhysicalInventory CAN
        ON PRO.Id = CAN.ProductId
     INNER JOIN Inventory.Warehouse ALM ON CAN.WarehouseId = ALM.Id
WHERE (CAN.Quantity <> 0)