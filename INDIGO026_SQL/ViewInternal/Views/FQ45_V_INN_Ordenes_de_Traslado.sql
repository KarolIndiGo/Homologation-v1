-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Ordenes_de_Traslado
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_Ordenes_de_Traslado]
AS
SELECT REPLACE ('BOGOTA', ORD.OperatingUnitId, '')
          AS [Unidad Operativa],
       ORD.Code
          AS [Orden de Traslado],
       ORD.DocumentDate
          AS Fecha,
       UFU.Name
          AS [Unidad Funcional],
       CON.Code + ' - ' + CON.Name
          AS Concepto,
       ALM.Code
          AS Codigo,
       ALM.Name
          AS [Almacen de Despacho],
       PRO.Code
          AS [Codigo de Producto],
       PRO.Name
          AS Producto,
       CASE PRO.POSProduct WHEN 0 THEN 'NO POS' WHEN 1 THEN 'POS' END
          AS [Tipo de Producto],
       DET.Quantity
          AS Cantidad,
       DET.Value
          AS [Costo Promedio],
       CASE ORD.OrderType WHEN 1 THEN 'TRASLADO' WHEN 2 THEN 'CONSUMO' END
          AS Tipo,
       ALM2.Code
          AS [Codigo ALM Dest],
       ALM2.Name
          AS [Almacen de Destino],
       ORD.Description
          AS Descripcion,
       USU.Identification + ' - ' + USU.Fullname
          AS [Usuario Creacion],
       ORD.CreationDate
          AS [Fecha de Cracion]
FROM Inventory.TransferOrder ORD
     LEFT JOIN Payroll.FunctionalUnit UFU
        ON UFU.Id = ORD.TargetFunctionalUnitId
     LEFT JOIN Inventory.AdjustmentConcept CON
        ON ORD.AdjustmentConceptId = CON.Id
     LEFT JOIN Inventory.Warehouse ALM
        ON ORD.SourceWarehouseId = ALM.Id
     LEFT JOIN Inventory.Warehouse ALM2
        ON ORD.TargetWarehouseId = ALM2.Id
     LEFT JOIN Inventory.TransferOrderDetail DET
        ON DET.TransferOrderId = ORD.Id
     LEFT JOIN Inventory.InventoryProduct PRO ON DET.ProductId = PRO.Id
     LEFT JOIN Security.Person USU
        ON ORD.CreationUser = USU.Identification
WHERE (ORD.Status <> 3)
